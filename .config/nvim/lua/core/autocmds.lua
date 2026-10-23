local autocmd = vim.api.nvim_create_autocmd

vim.filetype.add { extension = { rasi = "css" } }

local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = augroup "highlight-yank",
  callback = function() vim.hl.on_yank() end,
})

local numbertoggle = augroup "numbertoggle"
autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  desc = "Hybrid line numbers outside insert mode",
  group = numbertoggle,
  callback = function()
    if vim.wo.number and vim.fn.mode() ~= "i" then
      vim.wo.relativenumber = true
    end
  end,
})
autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  desc = "Absolute line numbers in insert mode and unfocused windows",
  group = numbertoggle,
  callback = function()
    if vim.wo.number then vim.wo.relativenumber = false end
  end,
})

-- foldmethod is window-local: remember it per window and restore it on leave
local fold_protect = augroup "fold-protect"
autocmd("InsertEnter", {
  desc = "Use manual folds while inserting",
  group = fold_protect,
  callback = function()
    if vim.w.last_fdm == nil then
      vim.w.last_fdm = vim.wo.foldmethod
      vim.wo.foldmethod = "manual"
    end
  end,
})
autocmd({ "InsertLeave", "WinLeave" }, {
  desc = "Restore the fold method",
  group = fold_protect,
  callback = function()
    if vim.w.last_fdm ~= nil then
      vim.wo.foldmethod = vim.w.last_fdm
      vim.w.last_fdm = nil
    end
  end,
})

autocmd("FileType", {
  desc = "Four-space indentation for Python",
  group = augroup "python-indent",
  pattern = "python",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})

local large_buf = augroup "large-buf"
local max_size = 1024 * 256
local max_lines = 10000
local matchparen_off = false

local function disable_features(buf)
  vim.b[buf].large_buf = true
  vim.treesitter.stop(buf)
  vim.api.nvim_buf_call(buf, function() vim.cmd.syntax "clear" end)
  require("ibl").setup_buffer(buf, { enabled = false })
end

-- BufReadPre only knows the file size, so the flag is set early enough for
-- the treesitter FileType handler; the line count is checked after reading
autocmd("BufReadPre", {
  desc = "Flag large files",
  group = large_buf,
  callback = function(args)
    local stat = vim.uv.fs_stat(args.match)
    if stat and stat.size > max_size then vim.b[args.buf].large_buf = true end
  end,
})
autocmd("BufReadPost", {
  desc = "Disable heavy features in large buffers",
  group = large_buf,
  callback = function(args)
    if
      vim.b[args.buf].large_buf
      or vim.api.nvim_buf_line_count(args.buf) > max_lines
    then
      disable_features(args.buf)
    end
  end,
})
autocmd("BufEnter", {
  desc = "Pause matchparen while a large buffer is current",
  group = large_buf,
  callback = function(args)
    local large = vim.b[args.buf].large_buf == true
    if large == matchparen_off then return end
    matchparen_off = large
    vim.cmd(large and "NoMatchParen" or "DoMatchParen")
  end,
})

-- the global normal-mode <CR> map would shadow these buffers' own <CR>
local restore_enter = augroup "restore-enter"
autocmd("FileType", {
  desc = "Restore <CR> in quickfix and location lists",
  group = restore_enter,
  pattern = "qf",
  callback = function(args)
    vim.keymap.set(
      "n",
      "<CR>",
      "<CR>",
      { buffer = args.buf, desc = "Jump to entry" }
    )
  end,
})
autocmd("CmdwinEnter", {
  desc = "Restore <CR> in the command-line window",
  group = restore_enter,
  callback = function(args)
    vim.keymap.set(
      "n",
      "<CR>",
      "<CR>",
      { buffer = args.buf, desc = "Execute command line" }
    )
  end,
})
