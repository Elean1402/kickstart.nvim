-- vim.pack.add requires Neovim 0.11+
vim.pack.add({
 {
   src = "https://github.com/lervag/vimtex",
   opt = true, -- install as optional so we can lazy-load it
 },
})

-- Must be set before vimtex loads
vim.g.maplocalleader = ","   -- vimtex mappings use localleader

-- Viewer
vim.g.vimtex_view_method = "zathura"

-- Compiler
vim.g.vimtex_compiler_method = "latexmk"

-- Load vimtex only for tex files
vim.api.nvim_create_autocmd("FileType", {
 pattern = "tex",
 callback = function()
   vim.cmd("packadd vimtex")
 end,
})

-- texlab LSP
vim.lsp.config("texlab", {
 settings = {
   texlab = {
     build = {
       executable = "latexmk",
       args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
       onSave = true,
     },
     -- forward search (synctex) for zathura
     forwardSearch = {
       executable = "zathura",
       args = { "--synctex-forward", "%l:1:%f", "%p" },
     },
   },
 },
})
vim.lsp.enable("texlab")
