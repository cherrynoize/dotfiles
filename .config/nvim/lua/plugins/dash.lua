local opts = {
  autostart = true,

  user = nil,

  panels = {
    {
      "actions",
      title = "QUICK ACTIONS",
      items = {
        "new_file", "find_files", "config", "plugins", "terminal",
        "find_word", "find_string", "find_in_open", "buffers", "diagnostics",
        "marks", "registers", "keymaps", "commands", "help_tags", "man_pages",
        "resume",
        "quit",
      },
    },
    { "recent", title = "RECENT FILES" },
    { "projects", title = "PROJECTS", reverse = true },
    { "colorschemes", title = "COLORSCHEMES" },
    { "git", title = "GIT" },
    { "system", title = "SYSTEM", style = "item" },
  },

  layout = {
    panel_width = 46,
    gap = 3,
    max_columns = 3,
    visible = 6,
    padding = 1,
    gaps = "auto",
  },

  colors = {
    bg       = "#07040D",
    surface  = "#160C26",
    elevated = "#211139",
    border   = "#3A1F5E",
    purple   = "#A855F7",
    text     = "#F3E8FF",
    soft     = "#C084FC",
    muted    = "#8B5CF6",
    orange   = "#F97316",
    ok       = "#10B981",
    blue      = "#00D1FF",
    blue_bg   = "#0A2240",
    blue_key  = "#12396B",
    blue_txt  = "#7DE3FF",
    blue_dim  = "#0B3A5A",
    blue_deep = "#0A86AD",
  },

  icons = { set = "md" },

  chips = { "branch", "cwd", "version", "startup" },

  hints = {
    { "H J K L", "panels" },
    { "j k", "move" },
    { "l", "select" },
  },

  keys = {
    panel_left = "H", panel_down = "J", panel_up = "K", panel_right = "L",
    next_panel = "<Tab>", prev_panel = "<S-Tab>",
    next_item = { "j", "<Down>", "<C-n>" },
    prev_item = { "k", "<Up>", "<C-p>" },
    page_down = { "<C-d>", "<PageDown>" },
    page_up = { "<C-u>", "<PageUp>" },
    first = "gg",
    last = "G",
    select = { "l", "<CR>" },
  },
}

return {
  "cherrynoize/dash-nvim",

  lazy = false,
  priority = 100,

  dependencies = {
    "nvim-telescope/telescope.nvim",    -- pickers
    "nvim-tree/nvim-web-devicons",      -- file icons in Recent files
    {
      "DrKJeff16/project.nvim",         -- Projects panel
      lazy = false,
      opts = {},
      config = function(_, opts)
        require("project").setup(opts)
        pcall(require("telescope").load_extension, "projects")
      end,
    },
  },

  opts = opts,
}
