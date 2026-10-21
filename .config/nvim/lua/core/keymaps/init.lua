local wk = require "which-key"
local set = vim.keymap.set

local function cmd(command) return "<cmd>" .. command .. "<cr>" end

local function pick(name, opts)
  return function() require("telescope.builtin")[name](opts) end
end

set("n", "<C-s>", cmd "w", { desc = "Save file" })
set("i", "<C-s>", cmd "w!", { desc = "Force save and stay in insert mode" })
set("n", "<Esc>s", cmd "w", { desc = "Save file" })
set("n", "<leader>q", cmd "q", { desc = "Close window" })
set("n", "<Esc>q", cmd "qa", { desc = "Quit Neovim" })
set("n", "<Esc>Q", cmd "q!", { desc = "Quit without saving" })
set("n", "<Esc>c", ":clo<cr>", { desc = "Close window" })
set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Leave terminal mode" })
set("n", "<Esc>", cmd "nohlsearch", { desc = "Clear search highlight" })

set("i", "<C-z>", cmd "undo", { desc = "Undo" })
set(
  "n",
  "x",
  "i<del><c-o><cmd>stopinsert<cr>",
  { desc = "Delete character without yanking" }
)
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
set("n", "<leader>fh", pick "help_tags", { desc = "Find help" })
set("n", "<leader>fk", pick "keymaps", { desc = "Show keymaps" })
set("n", "<leader>ff", pick "find_files", { desc = "Find files" })
set("n", "<leader>f_", pick "builtin", { desc = "List Telescope pickers" })
set({ "n", "v" }, "<leader>fw", pick ("grep_string", {
  prompt_title = "Find word",
  word_match = "-w",
  use_regex = true,
  search = "",
}), { desc = "Find word" })
set("n", "<leader>fs", pick ("live_grep", {
  prompt_title = "Match exact string",
  search = "",
}), { desc = "Find string occurrences" })
set("n", "<leader>f<", pick "resume", { desc = "Reopen last search" })
set("n", "<leader>f%", pick "oldfiles", { desc = "View recent files" })
set("n", "<leader>fx", pick "commands", { desc = "Search commands" })
set("n", "<leader>fd", pick "diagnostics", { desc = "Search diagnostics" })
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
  "<leader>f.",
  pick("find_files", {
    cwd = vim.fn.stdpath "config",
    follow = true,
    prompt_title = "Search Neovim config"
  }),
  { desc = "Find Neovim config files" }
)
set("n", "<leader><leader>", pick "buffers", { desc = "Find open buffers" })
set("n", "<leader>/", function()
  require("telescope.builtin").current_buffer_fuzzy_find(
    require("telescope.themes").get_dropdown {
      winblend = 10,
      previewer = false,
      prompt_title = "Search current buffer"
    }
  )
end, { desc = "Search current buffer" })
set({ "n", "v" }, "<leader>fm", pick "marks", { desc = "Find marks" })

set({ "n", "v" }, "<leader>fg", function()
  require("telescope.builtin").grep_string {
    search = vim.fn.input "grep> ",
    use_regex = true,
  }
end)

wk.add { { "<leader>g", group = "git" } }
set("n", "<leader>gf", pick "git_files", { desc = "Find tracked files" })
set({ "n", "v" }, "<leader>gd", pick ("git_status", {
  prompt_title = "Find diff"
}), { desc = "Find diffs in repo" })
set({ "n", "v" }, "<leader>gc", pick "commits", { desc = "Find commits" })
set({ "n", "v" }, "<leader>gb", pick "git_branches", { desc = "Find branches" })

set({ "n", "v" }, "<leader>F", function()
  require("conform").format { async = true }
end, { desc = "Format buffer" })

set(
  "n",
  "<leader>Q",
  vim.diagnostic.setloclist,
  { desc = "Diagnostics to location list" }
)

wk.add { { "<leader>b", group = "Buffers" } }
set("n", "<leader><tab>", cmd "bn", { desc = "Next buffer" })
set("n", "<leader><s-tab>", cmd "bp", { desc = "Previous buffer" })
set("n", "<leader>bn", cmd "bn", { desc = "Next buffer" })
set("n", "<leader>bp", cmd "bp", { desc = "Previous buffer" })
set("n", "<F12>", ":buffers<cr>:buffer<space>", { desc = "Pick buffer" })
set("n", "<leader>ℵ", cmd "<Nop>", { desc = "Go to buffer ℵ (0-9)" })
for i = 1, 9 do
  set("n", "<leader>" .. i, cmd("b" .. i), {
    desc = i == 0 and "Go to buffer 10" or "Go to buffer " .. i,
  })
  wk.add { { "<leader>" .. i, hidden = true } }
end

for i = 1, 9 do
  set("n", "<Esc>" .. i, i .. "gt", { desc = "Go to tab " .. i })
end
set("n", "<Esc>0", "10gt", { desc = "Go to tab 10" })
set("n", "<Esc>t", cmd "tabe", { desc = "New tab" })
set("n", "<Esc>w", cmd "tabc", { desc = "Close tab" })
set("n", "<Esc><Tab>", "gt", { desc = "Next tab" })
set("n", "<S-Tab>", "gT", { desc = "Previous tab" })
set("i", "<Esc><Tab>", "<esc>gt<cr>", { desc = "Next tab" })
set("i", "<S-Tab>", "<esc>gT<cr>", { desc = "Previous tab" })

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

-- Toggle and terminal; the gitsigns and LSP toggles are buffer-local
wk.add { { "<leader>t", group = "Toggle/Terminal" } }
set("n", "<leader>tx", cmd "terminal", { desc = "Open terminal in window" })

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

-- Windsurf; <C-x><C-x> because a bare <C-x> would shadow completion keys
set(
  "i",
  "<Esc>;",
  cmd "call codeium#CycleCompletions(-1)",
  { desc = "Previous Codeium suggestion" }
)
set(
  "i",
  "<Esc>,",
  cmd "call codeium#CycleCompletions(1)",
  { desc = "Next Codeium suggestion" }
)
set(
  "i",
  "<Esc>\\",
  cmd "call codeium#Complete()",
  { desc = "Trigger Codeium suggestion" }
)
set("i", "<C-\\>1", cmd "Codeium Enable", { desc = "Enable Codeium" })
set("i", "<C-\\>0", cmd "Codeium Disable", { desc = "Disable Codeium" })
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
