local M = {}

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "Chmod" })
end

---@param mode string  e.g. "+x", "-x", "755", "u+x"; bare "x"/"rw" is treated as "+x"/"+rw"
---@param file? string defaults to the current buffer's file
function M.run(mode, file)
  file = file or vim.api.nvim_buf_get_name(0)
  if file == "" or vim.fn.filereadable(file) == 0 then
    return notify("Buffer has no file on disk", vim.log.levels.WARN)
  end

  if mode:match("^[rwxXst]+$") then
    mode = "+" .. mode
  end

  local res = vim.system({ "chmod", mode, file }):wait()
  if res.code ~= 0 then
    return notify("chmod failed: " .. vim.trim(res.stderr or ""), vim.log.levels.ERROR)
  end

  -- verify against the real permission bits on disk
  local perms = vim.fn.getfperm(file)
  local ok = true
  if mode == "+x" then
    ok = vim.fn.executable(file) == 1
  elseif mode == "-x" then
    ok = vim.fn.executable(file) == 0
  end

  local name = vim.fn.fnamemodify(file, ":t")
  if ok then
    notify(("%s → %s (%s)"):format(name, mode, perms))
  else
    notify(("chmod %s ran but verification failed (%s)"):format(mode, perms), vim.log.levels.ERROR)
  end
end

function M.setup()
  vim.api.nvim_create_user_command("Chmod", function(opts)
    M.run(opts.args)
  end, {
    nargs = 1,
    desc = "chmod the current file",
    complete = function()
      return { "+x", "-x", "x", "644", "755", "u+x", "a+x" }
    end,
  })
end

return M
