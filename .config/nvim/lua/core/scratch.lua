-- Floating scratch pads backed by plain files. Two scopes:
--   "project"  one folder per project root (the cwd, which project.nvim keeps
--              at the root): stdpath("data")/scratch/projects/<name>-<hash>
--   "global"   stdpath("data")/scratch
-- The extension of a file name decides its filetype; buffers are written
-- automatically, so nothing is ever lost.
--
--   toggle(scope)  show/hide the last used file of that scope in a float
--                  (pressing the other scope's key switches pads)
--   pick(scope)    Telescope picker over that scope's files
--                  <CR> open   <C-a> new file   <C-x> delete
--   new(scope)     prompt for a name (e.g. `notes.py`) and open it
local M = {}

local root = vim.fn.stdpath "data" .. "/scratch"
local default_name = "scratch.md"
local state = { win = nil, scope = nil, last = {} }

local function scope_dir(scope)
  if scope == "global" then return root end
  local cwd = vim.fn.getcwd()
  local name = vim.fn.fnamemodify(cwd, ":t")
  return ("%s/projects/%s-%s"):format(root, name, vim.fn.sha256(cwd):sub(1, 8))
end

local function scope_label(scope)
  if scope == "global" then return "global" end
  return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end

-- scratch files of a scope, newest first
local function list(scope)
  local dir = scope_dir(scope)
  vim.fn.mkdir(dir, "p")
  local items = {}
  for _, name in ipairs(vim.fn.readdir(dir)) do
    local stat = vim.uv.fs_stat(dir .. "/" .. name)
    if stat and stat.type == "file" then
      items[#items + 1] = { name = name, mtime = stat.mtime.sec }
    end
  end
  table.sort(items, function(a, b) return a.mtime > b.mtime end)
  return items
end

local function save(buf)
  if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].modified then
    vim.api.nvim_buf_call(buf, function() vim.cmd "silent! write" end)
  end
end

function M.is_open()
  return state.win ~= nil and vim.api.nvim_win_is_valid(state.win)
end

function M.close()
  if not M.is_open() then return end
  save(vim.api.nvim_win_get_buf(state.win))
  vim.api.nvim_win_close(state.win, false)
  state.win = nil
  state.scope = nil
end

function M.open(scope, name)
  M.close()
  local dir = scope_dir(scope)
  local path = dir .. "/" .. name
  vim.fn.mkdir(dir, "p")
  state.last[dir] = name
  state.scope = scope

  local buf = vim.fn.bufadd(path)
  vim.fn.bufload(buf)
  vim.bo[buf].buflisted = false
  vim.bo[buf].bufhidden = "hide"
  if vim.bo[buf].filetype == "" then
    local ft = vim.filetype.match { filename = path }
    if ft then vim.bo[buf].filetype = ft end
  end

  if not vim.b[buf].scratch_autosave then
    vim.b[buf].scratch_autosave = true
    vim.api.nvim_create_autocmd(
      { "TextChanged", "InsertLeave", "BufLeave", "FocusLost" },
      {
        desc = "Autosave scratch file",
        group = vim.api.nvim_create_augroup("scratch-autosave", {
          clear = false,
        }),
        buffer = buf,
        callback = function() save(buf) end,
      }
    )
  end

  local width = math.floor(vim.o.columns * 0.7)
  local height = math.floor(vim.o.lines * 0.7)
  state.win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2 - 1),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = (" %s: %s "):format(scope_label(scope), name),
    title_pos = "center",
  })
  vim.wo[state.win].wrap = true
  vim.wo[state.win].linebreak = true
end

function M.toggle(scope)
  if M.is_open() and state.scope == scope then
    M.close()
    return
  end
  local newest = list(scope)[1]
  M.open(
    scope,
    state.last[scope_dir(scope)] or (newest and newest.name) or default_name
  )
end

function M.new(scope)
  vim.ui.input({
    prompt = "Scratch file (extension sets the filetype): ",
    default = os.date "%Y-%m-%d-%H%M" .. ".md",
  }, function(name)
    if not name or name == "" then return end
    name = name:gsub("[/\\]", "-")
    if not name:match "%.[^.]+$" then name = name .. ".md" end
    M.open(scope, name)
  end)
end

-- returns true when the file was deleted
function M.delete(scope, name)
  if
    vim.fn.confirm("Delete scratch file " .. name .. "?", "&Yes\n&No", 2) ~= 1
  then
    return false
  end
  local dir = scope_dir(scope)
  local buf = vim.fn.bufnr(dir .. "/" .. name)
  if buf ~= -1 then
    if M.is_open() and vim.api.nvim_win_get_buf(state.win) == buf then
      M.close()
    end
    pcall(vim.api.nvim_buf_delete, buf, { force = true })
  end
  vim.fn.delete(dir .. "/" .. name)
  if state.last[dir] == name then state.last[dir] = nil end
  return true
end

function M.pick(scope)
  local pickers = require "telescope.pickers"
  local finders = require "telescope.finders"
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"
  local conf = require("telescope.config").values
  local dir = scope_dir(scope)

  local function finder()
    return finders.new_table {
      results = list(scope),
      entry_maker = function(item)
        return {
          value = item.name,
          ordinal = item.name,
          display = item.name .. "  " .. os.date("%d/%m/%y %H:%M", item.mtime),
          path = dir .. "/" .. item.name,
        }
      end,
    }
  end

  pickers
    .new({}, {
      prompt_title = ("Scratch files (%s)"):format(scope_label(scope)),
      results_title = "<C-a> new  <C-x> delete",
      finder = finder(),
      sorter = conf.generic_sorter {},
      previewer = conf.file_previewer {},
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          local entry = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if entry then M.open(scope, entry.value) end
        end)
        map({ "i", "n" }, "<C-a>", function()
          actions.close(prompt_bufnr)
          vim.schedule(function() M.new(scope) end)
        end)
        map({ "i", "n" }, "<C-x>", function()
          local entry = action_state.get_selected_entry()
          if entry and M.delete(scope, entry.value) then
            action_state.get_current_picker(prompt_bufnr):refresh(
              finder(),
              { reset_prompt = false }
            )
          end
        end)
        return true
      end,
    })
    :find()
end

return M
