local wk = require "which-key"
local set = vim.keymap.set

local function cmd(command) return "<cmd>" .. command .. "<cr>" end

local function pick(name, opts)
  return function() require("telescope.builtin")[name](opts) end
end



-- <leader>uF toggle format on save
-- <leader>uc/ua/uC toggle completion/autopairs/colorizer, <leader>un line
-- numbering, <leader>ui indent detection, <leader>uN notifications,
-- <leader>uu URL highlight, <leader>uL CodeLens, <leader>uA rooter

--
--------- Review
--

-- AstroNvim maps that clash with this layout, kept here disabled. Uncomment
-- one (and drop the conflicting map further down) to get it back.
--
-- Not carried over, to decide on:
-- * <leader>lS symbols outline (aerial) and <leader>lI none-ls info: neither
--   plugin is installed
-- * ]f [f ]k [k and the <leader>a swap maps: need treesitter-textobjects

-- set("n", "]b", function()
--   require("bufferline").cycle(vim.v.count1)
-- end, { desc = "Next buffer" })
-- set("n", "[b", function()
--   require("bufferline").cycle(-vim.v.count1)
-- end, { desc = "Previous buffer" })


--------


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

wk.add { { "<leader>", group = "Leader menu" } }

set({ "n", "i" }, "<C-s>", cmd "w", { desc = "Save file" })
set("n", "<Esc>s", cmd "w", { desc = "Save file" })
set("n", "<leader>c", cmd "clo", { desc = "Close window" })
set("n", "<leader>q", cmd "q", { desc = "Quit window" })
set({ "n", "i" }, "<esc>q", cmd "q", { desc = "Quit window" })
set("n", "<leader>Q", cmd "q!", { desc = "Quit window without saving" })
set("n", "<C-q>", cmd "qa", { desc = "Quit Neovim" })
set("n", "<leader>n", cmd "enew", { desc = "New file" })
set("n", "<leader>r", reload, { desc = "Reload config" })
set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Move cursor down" })
set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Move cursor up" })
set("v", "<Tab>", ">gv", { desc = "Indent selection" })
set("v", "<S-Tab>", "<gv", { desc = "Unindent selection" })
set("n", "<Esc>", cmd "nohlsearch", { desc = "Clear search highlight" })

set("i", "<C-z>", cmd "undo", { desc = "Undo" })
set("n", "x", "i<del><c-o><cmd>stopinsert<cr>", { desc = "Delete character without yanking" })
set("n", "<Esc>x", "vd", { desc = "Cut character" })
set("n", "<C-p>", "0i<cr><esc>kP", { desc = "Paste above the current line" })
set("n", "<C-n>", "0ji<cr><esc>kP", { desc = "Paste below the current line" })
set("n", "<Esc>i", "i <esc>r", { desc = "Insert a single character" })
set({ "i", "x" }, "<C-c>", "<esc>yiwea", { desc = "Copy word" })
set("i", "<C-h>", "<c-o>dB", { desc = "Delete back to start of WORD" })
set("i", "<C-Del>", "<c-o>dE", { desc = "Delete to end of WORD" })
set("i", "<C-d>", cmd "copy+0", { desc = "Duplicate line" })
set({ "n", "x", "o" }, "<Esc>d", cmd "copy+0", { desc = "Duplicate line" })
set("n", "<CR>", "o<esc>", { desc = "Append empty line below" })
set("n", "<Esc><CR>", "i<cr><esc>", { desc = "Split line at cursor" })
set(
  "n",
  "<Esc>o",
  "d0i<bs><c-o><cmd>stopinsert<cr>",
  { desc = "Delete from last newline up to cursor" }
)
set("x", "A", ":s/$/", { desc = "Append to all selected lines" })
set(
  { "n", "x", "o", "i" },
  "<F3>",
  cmd "se hlsearch!",
  { desc = "Toggle search highlight" }
)
set("x", "<Esc>=", ":! column -t -s= -o=<cr>", { desc = "Align on =" })
set(
  "n",
  "<Esc>=",
  "Vk:! column -t -s= -o=<cr>2$",
  { desc = "Align current and previous line on =" }
)
set({ "n", "x", "o" }, "è", "{", { desc = "Previous paragraph" })
set({ "n", "x", "o" }, "ò", "}", { desc = "Next paragraph" })

wk.add { { "<leader>f", group = "Find" } }
set("n", "<leader>ff", pick "find_files", { desc = "Find files" })
set("n", "<leader>fF", pick("find_files", { hidden = true, no_ignore = true }), { desc = "Find all files" })
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
  { desc = "Find Neovim config files" }
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
set("n", "<leader>fd", pick "diagnostics", { desc = "Search diagnostics" })
set("n", "<leader>fk", pick "keymaps", { desc = "Show keymaps" })
set("n", "<leader>fx", pick "commands", { desc = "Search commands" })
set("n", "<leader>ft", pick "colorscheme", { desc = "Find themes" })
set("n", "<leader>fm", pick "man_pages", { desc = "Find man" })
set("n", "<leader>fh", pick "help_tags", { desc = "Find help" })

set({ "n", "v" }, "<leader>fg", function()
  require("telescope.builtin").grep_string {
    search = vim.fn.input "grep> ",
    use_regex = true,
  }
end)

wk.add { { "<leader>g", group = "git" } }
set("n", "<leader>gf", pick "git_files", { desc = "Find tracked files" })
set({ "n", "v" }, "<leader>gd", pick("git_status", {
  prompt_title = "Find diff",
}), { desc = "Find diffs in repo" })
set({ "n", "v" }, "<leader>gc", pick "commits", { desc = "Find commits" })
set({ "n", "v" }, "<leader>gb", pick "git_branches", { desc = "Find branches" })
set("n", "<leader>gC", pick "git_bcommits", { desc = "Find commits of buffer" })
set("n", "<leader>gt", pick "git_status", { desc = "Find git status" })

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
wk.add { { "gl", group = "LSP" } }

wk.add { { "<leader>p", group = "Packages" } }
set("n", "<leader>pi", cmd "Lazy install", { desc = "Plugins install" })
set("n", "<leader>ps", cmd "Lazy home", { desc = "Plugins status" })
set("n", "<leader>pS", cmd "Lazy sync", { desc = "Plugins sync" })
set("n", "<leader>pu", cmd "Lazy check", { desc = "Plugins check updates" })
set("n", "<leader>pU", cmd "Lazy update", { desc = "Plugins update" })
set("n", "<leader>pm", cmd "Mason", { desc = "Mason installer" })

wk.add { { "<leader>u", group = "UI/UX" } }
set("n", "<leader>ud", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })
set("n", "<leader>ug", function()
  vim.wo.signcolumn = vim.wo.signcolumn == "no" and "yes" or "no"
end, { desc = "Toggle sign column" })
set("n", "<leader>us", cmd "set spell!", { desc = "Toggle spellcheck" })
set("n", "<leader>uw", cmd "set wrap!", { desc = "Toggle wrap" })
set("n", "<leader>up", cmd "set paste!", { desc = "Toggle paste mode" })
set("n", "<leader>ub", function()
  vim.o.background = vim.o.background == "dark" and "light" or "dark"
end, { desc = "Toggle background" })
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
  set({ "n", "v", "i" }, "<Esc>" .. i, tab .. "gt", { desc = "Go to tab " .. tab })
  wk.add { { "<Esc>" .. i, hidden = true } }
end
set({ "n", "v", "i" }, "<Esc>ℵ", cmd "<Nop>", { desc = "Go to tab ℵ (1-10)" })
set({ "n", "v", "i" }, "<Esc>t", cmd "tabe", { desc = "New tab" })
set({ "n", "v", "i" }, "<Esc>w", cmd "tabc", { desc = "Close tab" })
set({ "n", "v", "i" }, "<Esc><Tab>", cmd "gt", { desc = "Next tab" })
set({ "n", "v", "i" }, "<S-Tab>", cmd "gT", { desc = "Previous tab" })
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

-- Explorer
set("n", "<leader>e", cmd "Neotree toggle", { desc = "Toggle explorer" })
set("n", "<leader>o", function()
  if vim.bo.filetype == "neo-tree" then
    vim.cmd.wincmd "p"
  else
    vim.cmd.Neotree "focus"
  end
end, { desc = "Toggle explorer focus" })

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
