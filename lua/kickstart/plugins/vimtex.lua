-- Add as optional (don't load immediately)
vim.pack.add({
  {
    src = "https://github.com/lervag/vimtex",
  },
})

-- Load it only for tex files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function()
    vim.cmd("packadd vimtex")
  end,
})

-- VimTeX config (must be set before the plugin loads)
vim.g.vimtex_view_method = "zathura"  -- or your viewer

vim.lsp.config("texlab", {
  settings = {
    texlab = {
      build = {
        executable = "latexmk",
        args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
        onSave = true,
      },
    },
  },
})
vim.lsp.enable("texlab")
