local wk = require "which-key"
local set = vim.keymap.set

local function cmd(command) return "<cmd>" .. command .. "<cr>" end

local function pick(name, opts)
  return function() require("telescope.builtin")[name](opts) end
end

-- close buffers without closing their windows; offset is the position of a
-- listed buffer relative to the current one (negative = to its left)
local function close_buffers(should_close)
  local bufs = vim.tbl_filter(
    function(buf) return vim.bo[buf].buflisted end,
    vim.api.nvim_list_bufs()
  )
  local current = vim.fn.index(bufs, vim.api.nvim_get_current_buf())
  for i, buf in ipairs(bufs) do
    if should_close(i - 1 - current) then
      require("mini.bufremove").delete(buf, false)
    end
  end
end

local terminals = {}

local function float_term(command)
  return function()
    if vim.fn.executable(command) == 0 then
      vim.notify(command .. " is not executable", vim.log.levels.ERROR)
      return
    end
    if not terminals[command] then
      terminals[command] = require("toggleterm.terminal").Terminal:new {
        cmd = command,
        direction = "float",
        hidden = true,
      }
    end
    terminals[command]:toggle()
  end
end

local function notify_toggle(name, enabled)
  vim.notify(name .. (enabled and " enabled" or " disabled"))
end

-- run a command in a buffer without letting it notify
local function quietly(buf, command)
  local notify = vim.notify
  vim.notify = function() end
  pcall(vim.api.nvim_buf_call, buf, function() vim.cmd(command) end)
  vim.notify = notify
end

local url_pattern = [=[\v\c<(https?|ftp|file|ssh|git)://[^[:space:]<>"')\]]+]=]

local function update_url_highlight()
  local win = vim.api.nvim_get_current_win()
  local id = vim.w[win].url_match
  if id then
    pcall(vim.fn.matchdelete, id, win)
    vim.w[win].url_match = nil
  end
  if vim.g.url_highlight ~= false and vim.bo.buftype == "" then
    vim.w[win].url_match = vim.fn.matchadd("HighlightURL", url_pattern, 15)
  end
end

local function toggle_codelens()
  if vim.lsp.codelens.enable then
    local enabled = not vim.lsp.codelens.is_enabled()
    vim.lsp.codelens.enable(enabled)
    notify_toggle("CodeLens", enabled)
    return
  end
  -- Neovim 0.11 has no built-in toggle, so refresh by autocmd
  local enabled = not vim.g.codelens_enabled
  vim.g.codelens_enabled = enabled
  local group = vim.api.nvim_create_augroup("codelens-toggle", { clear = true })
  if enabled then
    vim.api.nvim_create_autocmd(
      { "BufEnter", "CursorHold", "InsertLeave" },
      { group = group, callback = function() vim.lsp.codelens.refresh() end }
    )
    vim.lsp.codelens.refresh()
  else
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      vim.lsp.codelens.clear(nil, buf)
    end
  end
  notify_toggle("CodeLens", enabled)
end

local function reload()
  for name in pairs(package.loaded) do
    if name:match "^themes%." or name == "core.colorscheme" then
      package.loaded[name] = nil
    end
  end
  package.loaded["core.keymaps"] = nil
  require "core.keymaps"
  vim.cmd.colorscheme(require "core.colorscheme")
  vim.notify "Config reloaded"
end

-- fugitive's status buffer has no toggle of its own: close it if it is
-- showing in this tab, otherwise open it with the given command
local function git_status(open)
  return function()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "fugitive" then
        local only_win = #vim.api.nvim_tabpage_list_wins(0) == 1
        if only_win and #vim.api.nvim_list_tabpages() > 1 then
          vim.cmd.tabclose()
        else
          pcall(vim.api.nvim_win_close, win, false)
        end
        return
      end
    end
    vim.cmd(open)
  end
end

-- close diffview if one is showing in this session, otherwise open it
local function diffview_toggle()
  if require("diffview.lib").get_current_view() then
    vim.cmd "DiffviewClose"
  else
    vim.cmd "DiffviewOpen"
  end
end

-- mini.map doubles as a pure scrollbar when its window is one column wide;
-- `vim.g.minimap_bar` tells which of the two is showing
local minimap_bar_opts = {
  window = { width = 1, winblend = 100, show_integration_count = false },
}

local function minimap_is_open()
  local win = require("mini.map").current.win_data[
    vim.api.nvim_get_current_tabpage()
  ]
  return win ~= nil and vim.api.nvim_win_is_valid(win)
end

-- closed -> map; bar -> map; map -> closed
local function minimap_toggle()
  local map = require "mini.map"
  if not minimap_is_open() then
    vim.g.minimap_bar = false
    map.open()
  elseif vim.g.minimap_bar then
    vim.g.minimap_bar = false
    local window = map.config.window
    map.refresh {
      window = {
        width = window.width,
        winblend = window.winblend,
        show_integration_count = window.show_integration_count,
      },
    }
  else
    map.close()
  end
end

-- closed -> bar; map -> bar; bar -> closed
local function minimap_toggle_bar()
  local map = require "mini.map"
  if not minimap_is_open() then
    vim.g.minimap_bar = true
    map.open(minimap_bar_opts)
  elseif vim.g.minimap_bar then
    vim.g.minimap_bar = false
    map.close()
  else
    vim.g.minimap_bar = true
    map.refresh(minimap_bar_opts)
  end
end

-- pick one of this project's Arrow bookmarks and open it in a split
local function arrow_split_open(split)
  local ok, persist = pcall(require, "arrow.persist")
  if ok then pcall(persist.load_cache_file) end
  local files = vim.g.arrow_filenames or {}
  if #files == 0 then
    vim.notify "No Arrow bookmarks in this project"
    return
  end
  vim.ui.select(files, { prompt = "Open bookmark in split" }, function(file)
    if file then vim.cmd[split](vim.fn.fnameescape(file)) end
  end)
end

wk.add { { "<leader>", group = "Leader menu" } }

set("n", "<leader>r", reload, { desc = "Reload config" })

set("n", "<leader>n", cmd "enew", { desc = "New file" })
set({ "n", "i" }, "<C-s>", cmd "w", { desc = "Save file" })
set("n", "<Esc>s", cmd "w", { desc = "Save file" })
set("n", "<leader>w", cmd "w", { desc = "Save file" })
set("n", "<leader>c", cmd "clo", { desc = "Close window" })
set("n", "<leader>q", cmd "q", { desc = "Quit window" })
set({ "n", "i" }, "<esc>q", cmd "q", { desc = "Quit window" })
set("n", "<leader>Q", cmd "q!", { desc = "Quit window without saving" })
set("n", "<C-q>", cmd "qa", { desc = "Quit Neovim" })

set("v", "<Tab>", ">gv", { desc = "Indent selection" })
set("v", "<S-Tab>", "<gv", { desc = "Unindent selection" })

set("n", "j", "v:count == 0 ? 'gj' : 'j'", {
  expr = true, silent = true, desc = "Move cursor down" }
)
set("n", "k", "v:count == 0 ? 'gk' : 'k'", {
  expr = true, silent = true, desc = "Move cursor up" }
)

set("n", "<Esc>", cmd "nohlsearch", { desc = "Clear search highlight" })

set("i", "<C-z>", cmd "undo", { desc = "Undo" })
set("n", "x", "i<del><c-o><cmd>stopinsert<cr>", {
  desc = "Delete character without yanking" }
)
set("n", "<Esc>x", "vd", { desc = "Cut character" })
set("n", "<Esc>i", "i <esc>r", { desc = "Insert a single character" })

set("v", "P", "p", { desc = "Paste and yank" })
set("v", "p", "\"_dP", { desc = "Yankless paste" })
set("v", "D", "\"_d", { desc = "Yankless delete" })

set({ "n", "v" }, "<leader>y", "\"*y", { desc = "Yank to selection" })
set({ "n", "v" }, "<leader>Y", "\"*Y", { desc = "Yank to selection" })
set({ "n", "v" }, "<leader>d", "\"*d", { desc = "Delete into selection" })
set("n", "<leader>p", "\"*p", { desc = "Paste from selection" })
set("v", "<leader>p", "\"_d\"*P", { desc = "Paste from selection" })

set({ "i", "x" }, "<C-c>", "<esc>yiwea", { desc = "Yank word" })
set("n", "yA", "<cmd>silent %y<CR>", { desc = "Yank buffer" })
set("i", "<C-h>", "<c-o>dB", { desc = "Delete back to start of WORD" })
set("i", "<C-Del>", "<c-o>dE", { desc = "Delete to end of WORD" })

set("i", "<C-d>", cmd "copy+0", { desc = "Duplicate line" })
set({ "n", "x", "o" }, "<Esc>d", cmd "copy+0", { desc = "Duplicate line" })
set("n", "<CR>", "o<esc>", { desc = "Append empty line below" })
set("n", "J", "mzJ`z", { desc = "Join lines in place" })
set("n", "<Esc><CR>", "i<cr><esc>", { desc = "Split line at cursor" })
set( "n", "<Esc>o", "d0i<bs><c-o><cmd>stopinsert<cr>",
  { desc = "Delete from last newline up to cursor" }
)
set("v", "A", ":s/$/", { desc = "Append to all selected lines" })

set("n", "<C-p>", "0i<cr><esc>kP", { desc = "Paste above the current line" })
set("n", "<C-n>", "0ji<cr><esc>kP", { desc = "Paste below the current line" })

set("n", "n", "nzzzv", { desc = "Next search result" }) -- last `zv` somehow looks smoother
set("n", "N", "Nzzzv", { desc = "Previous search result" })

wk.add {
  { "g", group = "Goto" },
  -- buffer-local LSP map when available, Vim's builtin otherwise
  { "gd", desc = "Go to definition (LSP, else local declaration)" },
}
wk.add { { "gq", group = "Quickfix" } }
set("n", "gqk", "<cmd>cnext<cr>zz", { desc = "Quickfix next error" })
set("n", "gqj", "<cmd>cprev<cr>zz", { desc = "Quickfix previous error" })
wk.add { { "gl", group = "Location list" } }
set("n", "glk", "<cmd>lnext<cr>zz", { desc = "Location list next error" })
set("n", "glj", "<cmd>lprev<cr>zz", { desc = "Location list previous error" })

set("v", "<leader>=", ":! column -t -s= -o=<cr>", { desc = "Align on =" })
set("n", "<leader>=", "Vk:! column -t -s= -o=<cr>2$",
  { desc = "Align with last line on =" }
)

set({ "n", "x", "o" }, "è", "{", { desc = "Previous paragraph" })
set({ "n", "x", "o" }, "ò", "}", { desc = "Next paragraph" })

set("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selected lines down" })
set("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selected lines up" })
set("v", "<C-j>", ":m '>+10<cr>gv=gv", { desc = "Move 10 lines down" })
set("v", "<C-k>", ":m '<-11<cr>gv=gv", { desc = "Move 10 lines up" })

set({ "n", "v" }, "<leader>\\", ":%s/", { desc = "Replace all instances of" })
set(
  "n", "<leader>%",
  ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", -- wtf?
  { desc = "Replace word under cursor" }
)
set(
  "v", "<leader>%",
  ":s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
  { desc = "Replace word under cursor in selection" }
)

set("n", "<leader>X", function()
  require("chmod").run("+x")
end, { desc = "Make current file executable" })

wk.add { { "<leader>f", group = "Find" } }
set("n", "<leader>ff", pick "find_files", { desc = "Find files" })
set("n", "<leader>fF", pick(
  "find_files",
  { hidden = true, no_ignore = true }
), { desc = "Find all files" })
set("n", "<leader>f_", pick "builtin", { desc = "List Telescope pickers" })
set({ "n", "v" }, "<leader>fw", pick("grep_string", {
  prompt_title = "Find word",
  word_match = "-w",
  use_regex = true,
  search = "",
}), { desc = "Find word" })
set({ "n", "v" }, "<leader>fn", pick("grep_string", {
  prompt_title = "Find next",
}), { desc = "Find word under cursor" })
set("n", "<leader>fs", pick("live_grep", {
  prompt_title = "Match exact string",
  search = "",
}), { desc = "Find string occurrences" })
set(
  "n",
  "<leader>f/",
  pick("live_grep", {
    grep_open_files = true,
    prompt_title = "Match in open files",
  }),
  { desc = "Find string in open files" }
)
set(
  "n",
  "<leader>fS",
  pick("live_grep", { additional_args = { "--hidden", "--no-ignore" } }),
  { desc = "Find in all files" }
)
set(
  "n",
  "<leader>f.",
  pick("find_files", {
    cwd = vim.fn.stdpath "config",
    follow = true,
    prompt_title = "Find config files",
  }),
  { desc = "Find Neovim config files" }
)
set(
  "n",
  "<leader>f:",
  pick("live_grep", {
    cwd = vim.fn.stdpath "config",
    follow = true,
    prompt_title = "Search config",
  }),
  { desc = "Find string in Neovim config" }
)
set("n", "<leader>fb", pick "buffers", { desc = "Find open buffers" })
set("n", "<leader>/", function()
  require("telescope.builtin").current_buffer_fuzzy_find(
    require("telescope.themes").get_dropdown {
      winblend = 10,
      previewer = false,
      prompt_title = "This buffer",
    }
  )
end, { desc = "Search current buffer" })
set("n", "<leader>f%", pick "resume", { desc = "Reopen last search" })
set("n", "<leader>f^", pick "oldfiles", { desc = "View recent files" })
set({ "n", "v" }, "<leader>f'", pick "marks", { desc = "Find marks" })
set("n", "<leader>fr", pick "registers", { desc = "Find registers" })
set("n", "<leader>fd", pick "lsp_definitions", { desc = "Find definitions" })
set("n", "<leader>fD", pick "diagnostics", { desc = "Search diagnostics" })
set("n", "<leader>fk", pick "keymaps", { desc = "Show keymaps" })
set("n", "<leader>fx", pick "commands", { desc = "Search commands" })
set("n", "<leader>fc", pick (
  "colorscheme", { prompt_title = "Find colorschemes" }
), { desc = "Find colorschemes" })
set("n", "<leader>fm", pick "man_pages", { desc = "Find man" })
set("n", "<leader>fh", pick "help_tags", { desc = "Find help" })
set("n", "<leader>fp", cmd "Telescope projects", { desc = "Find projects" })
set("n", "<leader>fi", function() require("core.scratch").pick "project" end, {
  desc = "Find project scratch files",
})
set("n", "<leader>fI", function() require("core.scratch").pick "global" end, {
  desc = "Find global scratch files",
})
set("n", "<leader>fN", function()
  require "notify" -- make sure the telescope extension is on the rtp
  pcall(require("telescope").load_extension, "notify")
  vim.cmd "Telescope notify"
end, { desc = "Notification history" })

set({ "n", "v" }, "<leader>fg", function()
  require("telescope.builtin").grep_string {
    search = vim.fn.input "grep> ",
    use_regex = true,
  }
end)

wk.add { { "<leader>g", group = "git" } }
set("n", "<leader>gd", diffview_toggle, { desc = "Toggle diffview" })
set("n", "<leader>gD", cmd "DiffviewFileHistory %", {
  desc = "Diffview file history (current file)",
})

wk.add { { "<leader>gf", group = "Find" } }
set("n", "<leader>gff", pick("git_files",
  { prompt_title = "Git files" }
), { desc = "Find tracked files" })
set({ "n", "v" }, "<leader>gfd", pick("git_status", {
  prompt_title = "Find diff",
}), { desc = "Git changes" })
set({ "n", "v" }, "<leader>gfc", pick("git_bcommits",
  { prompt_title = "Git commits" }
), { desc = "Find commits" })
set({ "n", "v" }, "<leader>gfb", pick("git_branches",
  { prompt_title = "Git branches" }
), { desc = "Find branches" })

wk.add { { "<leader>gs", group = "Git status" } }
set("n", "<leader>gss", git_status "tab Git", {
  desc = "Toggle git status (full window)",
})
set("n", "<leader>gs\\", git_status "vertical Git", {
  desc = "Toggle git status (vertical split)",
})
set("n", "<leader>gs|", git_status "Git", {
  desc = "Toggle git status (horizontal split)",
})

-- Language tools; the LSP maps are buffer-local, see plugins/lsp.lua and
-- plugins/telescope.lua
wk.add { { "<leader>l", group = "Language tools" } }
set( "n", "<leader>ld", vim.diagnostic.open_float, { desc = "Hover diagnostics" })
set("n", "<leader>lD", pick "diagnostics", { desc = "Find diagnostics" })
set( "n", "<leader>lQ", vim.diagnostic.setloclist, { desc = "Diagnostics to location list" })
set("n", "<leader>li", cmd "checkhealth vim.lsp", { desc = "LSP information" })
set("n", "<leader>lf", function()
  require("conform").format { async = true }
end, { desc = "Format buffer" })
set("v", "<leader>lf", function()
  require("conform").format { async = true }
end, { desc = "Format" })

wk.add { { "<leader>P", group = "Plugins" } }
set("n", "<leader>Ps", cmd "Lazy home", { desc = "Lazy status" })
set("n", "<leader>Pi", cmd "Lazy install", { desc = "Install" })
set("n", "<leader>PS", cmd "Lazy sync", { desc = "Sync" })
set("n", "<leader>Pu", cmd "Lazy check", { desc = "Check updates" })
set("n", "<leader>PU", cmd "Lazy update", { desc = "Update" })
set("n", "<leader>Pm", cmd "Mason", { desc = "Open Mason" })

wk.add { { "<leader>u", group = "UI/UX" } }
set("n", "<leader>uf", cmd "AerialToggle", { desc = "Toggle Aerial" })
set("n", "<leader>ud", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })
set( { "n", "x", "o", "i" }, "<leader>u/", cmd "se hlsearch!",
  { desc = "Toggle search highlight" }
)
set("n", "<leader>ug", function()
  vim.wo.signcolumn = vim.wo.signcolumn == "no" and "yes" or "no"
end, { desc = "Toggle sign column" })
set("n", "<leader>us", cmd "set spell!", { desc = "Toggle spellcheck" })
set("n", "<leader>uw", cmd "set wrap!", { desc = "Toggle wrap" })
set("n", "<leader>up", cmd "set paste!", { desc = "Toggle paste mode" })
set("n", "<leader>ub", function() require("core.transparency").toggle() end, {
  desc = "Toggle transparent background",
})
set("n", "<leader>uB", function()
  vim.o.background = vim.o.background == "dark" and "light" or "dark"
end, { desc = "Toggle light/dark background" })
set("n", "<leader>ul", function()
  vim.o.laststatus = vim.o.laststatus == 0 and 3 or 0
end, { desc = "Toggle statusline" })
set("n", "<leader>ut", function()
  vim.o.showtabline = vim.o.showtabline == 0 and 2 or 0
end, { desc = "Toggle tabline" })
set("n", "<leader>uS", function()
  vim.wo.conceallevel = vim.wo.conceallevel == 0 and 2 or 0
end, { desc = "Toggle conceal" })
set("n", "<leader>uy", function()
  local buf = vim.api.nvim_get_current_buf()
  if vim.treesitter.highlighter.active[buf] then
    vim.treesitter.stop(buf)
  else
    vim.treesitter.start(buf)
  end
end, { desc = "Toggle syntax highlighting (buffer)" })

set("n", "<leader>uF", function()
  vim.g.format_on_save = not vim.g.format_on_save
  notify_toggle("Format on save", vim.g.format_on_save)
end, { desc = "Toggle format on save" })
set("n", "<leader>uc", function()
  vim.g.completion_enabled = vim.g.completion_enabled == false
  notify_toggle("Completion", vim.g.completion_enabled)
end, { desc = "Toggle completion" })
set("n", "<leader>ua", function()
  local autopairs = require "nvim-autopairs"
  if autopairs.state.disabled then
    autopairs.enable()
  else
    autopairs.disable()
  end
  notify_toggle("Autopairs", not autopairs.state.disabled)
end, { desc = "Toggle autopairs" })
set("n", "<leader>uC", cmd "ColorizerToggle", { desc = "Toggle colorizer" })
set("n", "<leader>un", function()
  if vim.wo.number and vim.wo.relativenumber then
    vim.wo.relativenumber = false
    vim.notify "Line numbers: absolute"
  elseif vim.wo.number then
    vim.wo.number = false
    vim.notify "Line numbers: off"
  else
    vim.wo.number = true
    vim.wo.relativenumber = true
    vim.notify "Line numbers: relative"
  end
end, { desc = "Cycle line numbering" })
set("n", "<leader>ui", function()
  vim.g.indent_detection = vim.g.indent_detection == false
  notify_toggle("Indent detection", vim.g.indent_detection)
  if vim.g.indent_detection then
    quietly(0, "GuessIndent")
  end
end, { desc = "Toggle indent detection" })
set("n", "<leader>uN", function()
  local notification = require "fidget.notification"
  if vim.g.notifications_suppressed then
    vim.g.notifications_suppressed = false
    notification.suppress(false)
    notify_toggle("Notifications", true)
  else
    notify_toggle("Notifications", false)
    vim.g.notifications_suppressed = true
    notification.suppress(true)
  end
end, { desc = "Toggle notifications" })
set("n", "<leader>uh", function()
  vim.g.url_highlight = vim.g.url_highlight == false
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    vim.api.nvim_win_call(win, update_url_highlight)
  end
  notify_toggle("URL highlight", vim.g.url_highlight)
end, { desc = "Toggle URL highlight" })
set("n", "<leader>uL", toggle_codelens, { desc = "Toggle CodeLens" })
set("n", "<leader>um", minimap_toggle, { desc = "Toggle minimap" })
set("n", "<leader>uM", minimap_toggle_bar, { desc = "Toggle scrollbar" })
set("n", "<leader>uu", cmd "UndotreeToggle", { desc = "Toggle undotree" })

vim.api.nvim_set_hl(0, "HighlightURL", { underline = true })
vim.api.nvim_create_autocmd(
  { "VimEnter", "FileType", "BufEnter", "WinEnter" },
  {
    desc = "Highlight URLs",
    group = vim.api.nvim_create_augroup("url-highlight", { clear = true }),
    callback = update_url_highlight,
  }
)

wk.add { { "<leader>b", group = "Buffers" } }
set("n", "<leader><tab>", cmd "bn", { desc = "Next buffer" })
set("n", "<leader><s-tab>", cmd "bp", { desc = "Previous buffer" })
set("n", "<leader>bn", cmd "bn", { desc = "Next buffer" })
set("n", "<leader>bp", cmd "bp", { desc = "Previous buffer" })
set("n", "<F12>", ":buffers<cr>:buffer<space>", { desc = "Pick buffer" })
set("n", "<leader>ℵ", cmd "<Nop>", { desc = "Go to buffer ℵ (1-10)" })
for i = 0, 9 do
  local buf = i == 0 and 10 or i
  set("n", "<leader>" .. i, cmd("b" .. buf), { desc = "Go to buffer " .. buf, })
  wk.add { { "<leader>" .. i, hidden = true } }
end
set("n", ">b", function()
  require("bufferline").move(vim.v.count1)
end, { desc = "Move buffer tab right" })
set("n", "<b", function()
  require("bufferline").move(-vim.v.count1)
end, { desc = "Move buffer tab left" })
set("n", "<leader>bb", cmd "BufferLinePick", { desc = "Pick buffer" })
set("n", "<leader>bd", cmd "BufferLinePickClose", { desc = "Pick to close" })
set("n", "<leader>b\\", function()
  vim.cmd.split()
  require("bufferline").pick()
end, { desc = "Open buffer from tabline in horizontal split" })
set("n", "<leader>b|", function()
  vim.cmd.vsplit()
  require("bufferline").pick()
end, { desc = "Open buffer from tabline in vertical split" })
wk.add { { "<leader>bs", group = "Sort buffers" } }
set("n", "<leader>bse", function()
  require("bufferline").sort_by "extension"
end, { desc = "Sort by extension" })
set("n", "<leader>bsr", function()
  require("bufferline").sort_by "relative_directory"
end, { desc = "Sort by relative path" })
set("n", "<leader>bsi", function()
  require("bufferline").sort_by(function(a, b) return a.id < b.id end)
end, { desc = "Sort by buffer number" })
set("n", "<leader>bsp", function()
  require("bufferline").sort_by(function(a, b) return a.path < b.path end)
end, { desc = "Sort by full path" })
set("n", "<leader>bsm", function()
  require("bufferline").sort_by(function(a, b)
    return (a.modified and 1 or 0) > (b.modified and 1 or 0)
  end)
end, { desc = "Sort by modification" })
set("n", "<leader>bc", function()
  require("mini.bufremove").delete(0, false)
end, { desc = "Close buffer" })
set("n", "<leader>bC", function()
  require("mini.bufremove").delete(0, true)
end, { desc = "Force close buffer" })
wk.add { { "<leader>bs", group = "Batch close buffers" } }
set("n", "<leader>bxo", function()
  close_buffers(function(offset) return offset ~= 0 end)
end, { desc = "Close all buffers except current" })
set("n", "<leader>bxl", function()
  close_buffers(function(offset) return offset < 0 end)
end, { desc = "Close all buffers to the left" })
set("n", "<leader>bxr", function()
  close_buffers(function(offset) return offset > 0 end)
end, { desc = "Close all buffers to the right" })
set("n", "<leader>bxa", function()
  close_buffers(function() return true end)
end, { desc = "Close all buffers" })

for i = 0, 9 do
  local tab = i == 0 and 10 or i
  set({ "n", "v", "i" }, "<Esc>" .. i, "<Esc>" .. tab .. "gt", { desc = "Go to tab " .. tab })
  wk.add { { "<Esc>" .. i, hidden = true } }
end
set({ "n", "v", "i" }, "<Esc>ℵ", cmd "<Nop>", { desc = "Go to tab ℵ (1-10)" })
set({ "n", "v", "i" }, "<Esc>t", cmd "tabe", { desc = "New tab" })
set({ "n", "v" }, "<Esc>w", cmd "tabc", { desc = "Close tab" })
set({ "n", "v", "i" }, "<Esc><Tab>", "<Esc>gt", { desc = "Next tab" })
set({ "n" }, "<S-Tab>", "<Esc>gT", { desc = "Previous tab" })
set("n", "]t", cmd "tabnext", { desc = "Next tab" })
set("n", "[t", cmd "tabprevious", { desc = "Previous tab" })

wk.add { { "<C-w>", group = " Windows" } }
for key, side in pairs { h = "left", j = "lower", k = "upper", l = "right" } do
  set(
    { "n", "x" },
    "<C-" .. key .. ">",
    "<C-w><C-" .. key .. ">",
    { desc = "Focus " .. side .. " window" }
  )
  set(
    "n",
    "<Esc>" .. key,
    "<C-w>" .. key,
    { desc = "Focus " .. side .. " window" }
  )
end
set("n", "<C-w>=", cmd "WindowsEqualize", { desc = "Equalize windows" })
set(
  "n",
  "<C-w>_",
  cmd "WindowsMaximizeVertically",
  { desc = "Maximize window vertically" }
)
set(
  "n",
  "<C-w>|",
  cmd "WindowsMaximizeHorizontally",
  { desc = "Maximize window horizontally" }
)
set("n", "<C-w>z", cmd "WindowsMaximize", { desc = "Maximize window" })

wk.add { { "<leader>s", group = "󰨑 Split" } }
set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
set("n", "<leader>se", cmd "WindowsEqualize", { desc = "Equalize windows" })
set("n", "<leader>sx", cmd "close", { desc = "Close split window" })
set("n", "<leader>sm", cmd "WindowsMaximize", { desc = "Maximize window" })
set(
  "n",
  "<leader>s_",
  cmd "WindowsMaximizeVertically",
  { desc = "Maximize window vertically" }
)
set(
  "n",
  "<leader>s|",
  cmd "WindowsMaximizeHorizontally",
  { desc = "Maximize window horizontally" }
)
set("n", "<leader>so", "<C-w>o", { desc = "Close all other windows" })
set("n", "<leader>sr", "<C-w>r", { desc = "Rotate windows" })
set("n", "<leader>sT", "<C-w>T", { desc = "Move window to a new tab" })
set("n", "|", cmd "vsplit", { desc = "Split window vertically" })
set("n", "\\", cmd "split", { desc = "Split window horizontally" })
set("n", "<C-Up>", cmd "resize +2", { desc = "Increase window height" })
set("n", "<C-Down>", cmd "resize -2", { desc = "Decrease window height" })
set(
  "n",
  "<C-Left>",
  cmd "vertical resize -2",
  { desc = "Decrease window width" }
)
set(
  "n",
  "<C-Right>",
  cmd "vertical resize +2",
  { desc = "Increase window width" }
)

-- Arrow bookmarks; `<leader>''` (menu) and `<leader>'b` (buffer bookmarks) are
-- set by the plugin
wk.add {
  { "<leader>'", group = "Arrow" },
  { "<leader>'s", group = "Open bookmark in split" },
}
set("n", "<leader>'m", function()
  require("arrow.persist").toggle()
  vim.notify("Arrow: toggled bookmark for " .. vim.fn.expand "%:t")
end, { desc = "Bookmark file" })
set("n", "<leader>'sv", function() arrow_split_open "vsplit" end, {
  desc = "Open bookmark in vertical split",
})
set("n", "<leader>'sh", function() arrow_split_open "split" end, {
  desc = "Open bookmark in horizontal split",
})

-- Explorer
set("n", "<leader>E", cmd "Ex", { desc = "Open netrw" })
set("n", "<leader>e", cmd "Neotree toggle", { desc = "Toggle explorer" })
set("n", "<leader>o", function()
  if vim.bo.filetype == "neo-tree" then
    vim.cmd.wincmd "p"
  else
    vim.cmd.Neotree "focus"
  end
end, { desc = "Toggle explorer focus" })

-- Scratch pads; project files live per project root, global ones in
-- stdpath("data")/scratch, see core/scratch.lua
set("n", "<leader>i", function() require("core.scratch").toggle "project" end, {
  desc = "Toggle project scratch pad",
})
set("n", "<leader>I", function() require("core.scratch").toggle "global" end, {
  desc = "Toggle global scratch pad",
})

-- Folds
set("n", "zR", function() require("ufo").openAllFolds() end, {
  desc = "Open all folds",
})
set("n", "zM", function() require("ufo").closeAllFolds() end, {
  desc = "Close all folds",
})
set("n", "zr", function() require("ufo").openFoldsExceptKinds() end, {
  desc = "Fold less",
})
set("n", "zm", function() require("ufo").closeFoldsWith() end, {
  desc = "Fold more",
})
set("n", "zp", function() require("ufo").peekFoldedLinesUnderCursor() end, {
  desc = "Peek fold",
})

-- treesitter-textobjects
local function goto_textobject(direction, query, desc)
  local lhs = (direction == "next" and "]" or "[") .. query.key
  set({ "n", "x", "o" }, lhs, function()
    if vim.wo.diff and query.key == "c" then
      vim.cmd.normal { lhs, bang = true }
      return
    end
    require("nvim-treesitter-textobjects.move")["goto_" .. direction .. "_start"](
      query.capture,
      "textobjects"
    )
  end, { desc = desc })
end
local textobjects = {
  { key = "f", capture = "@function.outer", name = "function" },
  { key = "c", capture = "@class.outer", name = "class" },
}
for _, query in ipairs(textobjects) do
  goto_textobject("next", query, "Next " .. query.name .. " start")
  goto_textobject("previous", query, "Previous " .. query.name .. " start")
end
wk.add { { "<leader>x", group = "Text objects" } }
set("n", "<leader>x.", function()
  require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
end, { desc = "Swap next parameter" })
set("n", "<leader>x,", function()
  require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.inner"
end, { desc = "Swap previous parameter" })

-- Sessions
wk.add { { "<leader>S", group = "Session" } }
set("n", "<leader>Sl", function()
  require("resession").load "Last Session"
end, { desc = "Load last session" })
set("n", "<leader>Ss", function() require("resession").save() end, {
  desc = "Save this session",
})
set("n", "<leader>St", function() require("resession").save_tab() end, {
  desc = "Save this tab's session",
})
set("n", "<leader>Sd", function() require("resession").delete() end, {
  desc = "Delete a session",
})
set("n", "<leader>Sf", function() require("resession").load() end, {
  desc = "Load a session",
})
set("n", "<leader>S.", function()
  require("resession").load(vim.fn.getcwd(), { dir = "dirsession" })
end, { desc = "Load current directory session" })

-- Toggle and terminal; the gitsigns toggles are buffer-local
wk.add { { "<leader>t", group = "Toggle/Terminal" } }
set("n", "<leader>tx", cmd "terminal", { desc = "Open terminal in window" })
set("n", "<leader>tf", cmd "ToggleTerm direction=float", {
  desc = "Toggle floating terminal",
})
set("n", "<leader>th", cmd "ToggleTerm direction=horizontal", {
  desc = "Toggle horizontal terminal",
})
set("n", "<leader>tv", cmd "ToggleTerm direction=vertical", {
  desc = "Toggle vertical terminal",
})
set("n", "<leader>tl", float_term "lazygit", { desc = "Toggle lazygit" })
set("n", "<leader>tn", float_term "node", { desc = "Toggle node" })
set("n", "<leader>tu", float_term "gdu", { desc = "Toggle disk usage" })
set("n", "<leader>tp", float_term "python", { desc = "Toggle python" })
set(
  { "n", "t" },
  "<F7>",
  cmd 'execute v:count . "ToggleTerm"',
  { desc = "Toggle terminal" }
)
set(
  { "n", "t" },
  "<C-'>",
  cmd 'execute v:count . "ToggleTerm"',
  { desc = "Toggle terminal" }
)

-- Git hunks; the maps are buffer-local, see plugins/gitsigns.lua
wk.add { { "<leader>h", group = "Git hunks" } }

-- Arduino; vim-arduino only defines its commands for arduino buffers, so
-- the group label is buffer-local too
vim.api.nvim_create_autocmd("FileType", {
  desc = "Arduino maps",
  group = vim.api.nvim_create_augroup("arduino-keymaps", { clear = true }),
  pattern = "arduino",
  callback = function(args)
    wk.add {
      { "<leader>a", group = " Arduino", buffer = args.buf },
    }
    local function map(lhs, command, desc)
      set(
        "n",
        "<leader>a" .. lhs,
        cmd(command),
        { buffer = args.buf, desc = desc }
      )
    end
    map("a", "ArduinoAttach", "Attach to board")
    map("v", "ArduinoVerify", "Build the sketch")
    map("u", "ArduinoUpload", "Build and upload the sketch")
    map(
      "us",
      "ArduinoUploadAndSerial",
      "Build, upload, and connect for debugging"
    )
    map("s", "ArduinoSerial", "Connect to the board over a serial port")
    map("b", "ArduinoChooseBoard", "Select the type of board")
    map("p", "ArduinoChooseProgrammer", "Select the programmer")
  end,
})

-- Windsurf
set(
  "i",
  "<Esc>,",
  cmd "call codeium#CycleCompletions(-1)",
  { desc = "Previous Codeium suggestion" }
)
set(
  "i",
  "<Esc>.",
  cmd "call codeium#CycleCompletions(1)",
  { desc = "Next Codeium suggestion" }
)
set(
  "i",
  "<Esc>\\",
  cmd "call codeium#Complete()",
  { desc = "Trigger Codeium suggestion" }
)
set("i", "<C-x>1", cmd "Codeium Enable", { desc = "Enable Codeium" })
set("i", "<C-x>0", cmd "Codeium Disable", { desc = "Disable Codeium" })
set(
  "i",
  "<C-x><C-x>",
  cmd "call codeium#Clear()",
  { desc = "Clear Codeium suggestion" }
)
set("i", "<C-f>", function() return vim.fn["codeium#Accept"]() end, {
  desc = "Accept Codeium suggestion",
  script = true,
  silent = true,
  nowait = true,
  expr = true,
})
