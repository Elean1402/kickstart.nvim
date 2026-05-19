-- vim.pack.add requires Neovim 0.11+
vim.pack.add({
 {
   src = "https://github.com/lervag/vimtex",
   opt = true,
 },
})

vim.g.maplocalleader = ","
if vim.fn.has('mac') == 1 then
  vim.g.vimtex_view_method = 'skim'
else
  vim.g.vimtex_view_method = 'zathura'
end
vim.g.vimtex_compiler_method = "latexmk"

vim.g.vimtex_compiler_latexmk = {
  continuous = 1,
  options = {
    "-verbose",
    "-file-line-error",
    "-synctex=1",
    "-interaction=nonstopmode",
    "-shell-escape",
  },
}

vim.api.nvim_create_autocmd("FileType", {
 pattern = "tex",
 callback = function()
   vim.cmd("packadd vimtex")
 end,
})

vim.lsp.config("texlab", {
 settings = {
   texlab = {
     build = {
       executable = "latexmk",
       args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
       onSave = true,
     },
     forwardSearch = {
       executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
       args = { "%l", "%p", "%f" },
     },
   },
 },
})
vim.lsp.enable("texlab")
