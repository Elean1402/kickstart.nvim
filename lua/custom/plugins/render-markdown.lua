vim.pack.add({
	{
	src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim',
	},
})
require('render-markdown').setup({
  latex = { enabled = false },
})
vim.keymap.set('n', '<leader>mr', '<cmd>RenderMarkdown toggle<cr>', { desc = 'Toggle markdown rendering' })
