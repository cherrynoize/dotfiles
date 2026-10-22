return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = "Neotree",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    -- provides the nvim-web-devicons stand-in neo-tree asks for
    "nvim-mini/mini.nvim",
  },
  opts = {
    close_if_last_window = true,
    sources = { "filesystem", "buffers", "git_status" },
    source_selector = { winbar = true, content_layout = "center" },
    default_component_configs = { indent = { with_expanders = true } },
    commands = {
      system_open = function(state)
        vim.ui.open(state.tree:get_node():get_id())
      end,
      parent_or_close = function(state)
        local node = state.tree:get_node()
        if node.type == "directory" and node:is_expanded() then
          state.commands.toggle_node(state)
        else
          require("neo-tree.ui.renderer").focus_node(
            state,
            node:get_parent_id()
          )
        end
      end,
      child_or_open = function(state)
        local node = state.tree:get_node()
        if node.type ~= "directory" then
          state.commands.open(state)
        elseif not node:is_expanded() then
          state.commands.toggle_node(state)
        elseif node:has_children() then
          require("neo-tree.ui.renderer").focus_node(
            state,
            node:get_child_ids()[1]
          )
        end
      end,
    },
    window = {
      width = 30,
      mappings = {
        ["<space>"] = "none",
        ["[b"] = "prev_source",
        ["]b"] = "next_source",
        ["<S-CR>"] = "system_open",
        O = "system_open",
        h = "parent_or_close",
        l = "child_or_open",
      },
    },
    filesystem = {
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
    },
  },
}
