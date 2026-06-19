-- trouble.nvim: pretty list for diagnostics, references, quickfix, loclist, etc.

vim.pack.add {
    'https://github.com/folke/trouble.nvim',
    -- icons are provided by mini.icons (via MiniIcons.mock_nvim_web_devicons in init.lua)
}

require('trouble').setup {
    focus = true, -- focus the trouble window when opened
    auto_close = true, -- close when the last item is removed
    warn_no_results = false,
    open_no_results = true,
}

-- Standard trouble keymaps (mirrors the upstream README)
local map = vim.keymap.set
map('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Diagnostics (Trouble)' })
map('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Buffer Diagnostics (Trouble)' })
map('n', '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', { desc = 'Symbols (Trouble)' })
map('n', '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', { desc = 'LSP Definitions/Refs (Trouble)' })
map('n', '<leader>xL', '<cmd>Trouble loclist toggle<cr>', { desc = 'Location List (Trouble)' })
map('n', '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', { desc = 'Quickfix List (Trouble)' })
