return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local gitsigns = require "gitsigns"
    -- gitsigns has no insert-mode switch, so blame is toggled around insert
    local blame = true

    gitsigns.setup {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      current_line_blame = true,
      current_line_blame_opts = { virt_text = true, virt_text_pos = "eol" },
      current_line_blame_formatter = "󰌌 <committer>, <committer_time:%d/%m/%y %H:%M> • <summary>",
      on_attach = function(bufnr)
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal { "]c", bang = true }
          else
            gitsigns.nav_hunk "next"
          end
        end, "Next git change")
        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal { "[c", bang = true }
          else
            gitsigns.nav_hunk "prev"
          end
        end, "Previous git change")

        map("v", "<leader>hs", function()
          gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
        end, "Stage hunk")
        map("v", "<leader>hr", function()
          gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
        end, "Reset hunk")
        map("n", "<leader>hs", gitsigns.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gitsigns.reset_hunk, "Reset hunk")
        map("n", "<leader>hS", gitsigns.stage_buffer, "Stage buffer")
        map("n", "<leader>hR", gitsigns.reset_buffer, "Reset buffer")
        map("n", "<leader>hp", gitsigns.preview_hunk, "Preview hunk")
        map(
          "n",
          "<leader>hi",
          gitsigns.preview_hunk_inline,
          "Preview hunk inline"
        )
        map("n", "<leader>hb", function()
          gitsigns.blame_line { full = true }
        end, "Blame line")
        map("n", "<leader>hd", gitsigns.diffthis, "Diff against index")
        map("n", "<leader>hD", function()
          gitsigns.diffthis "~"
        end, "Diff against last commit")
        map("n", "<leader>hQ", function()
          gitsigns.setqflist "all"
        end, "Hunks to quickfix list (whole repo)")
        map(
          "n",
          "<leader>hq",
          gitsigns.setqflist,
          "Hunks to quickfix list (file)"
        )

        map("n", "<leader>tb", function()
          blame = gitsigns.toggle_current_line_blame()
        end, "Toggle git blame line")
        map(
          "n",
          "<leader>tw",
          gitsigns.toggle_word_diff,
          "Toggle git word diff"
        )

        map({ "o", "x" }, "ih", gitsigns.select_hunk, "Select hunk")
      end,
    }

    local group = vim.api.nvim_create_augroup("gitsigns-blame-insert", {
      clear = true,
    })
    vim.api.nvim_create_autocmd("InsertEnter", {
      desc = "Hide git blame in insert mode",
      group = group,
      callback = function()
        if blame then gitsigns.toggle_current_line_blame(false) end
      end,
    })
    vim.api.nvim_create_autocmd("InsertLeave", {
      desc = "Show git blame after insert mode",
      group = group,
      callback = function()
        if blame then gitsigns.toggle_current_line_blame(true) end
      end,
    })
  end,
}
