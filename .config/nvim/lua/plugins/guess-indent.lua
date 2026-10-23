return {
  "NMAC427/guess-indent.nvim",
  event = { "BufReadPre", "BufNewFile" },
  cmd = "GuessIndent",
  -- detection is run from the autocmd below so <leader>ui can toggle it
  opts = { auto_cmd = false },
  config = function(_, opts)
    require("guess-indent").setup(opts)
    vim.api.nvim_create_autocmd("BufReadPost", {
      desc = "Detect indentation",
      group = vim.api.nvim_create_augroup("guess-indent-detect", {
        clear = true,
      }),
      callback = function(args)
        if vim.g.indent_detection == false or vim.bo[args.buf].buftype ~= "" then
          return
        end
        local notify = vim.notify
        vim.notify = function() end
        pcall(vim.api.nvim_buf_call, args.buf, function()
          vim.cmd "GuessIndent"
        end)
        vim.notify = notify
      end,
    })
  end,
}
