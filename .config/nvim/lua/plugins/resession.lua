local function has_file_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buflisted and vim.api.nvim_buf_get_name(buf) ~= "" then
      return true
    end
  end
  return false
end

return {
  "stevearc/resession.nvim",
  lazy = false,
  opts = { autosave = { enabled = true, interval = 60, notify = false } },
  config = function(_, opts)
    local resession = require "resession"
    resession.setup(opts)

    vim.api.nvim_create_autocmd("VimLeavePre", {
      desc = "Save the last and the per-directory session on exit",
      group = vim.api.nvim_create_augroup("resession-save", { clear = true }),
      callback = function()
        if not has_file_buffers() then return end
        resession.save("Last Session", { notify = false })
        resession.save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
      end,
    })
  end,
}
