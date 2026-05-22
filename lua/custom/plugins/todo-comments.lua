-- todo-comments.nvim: highlights TODO/FIXME/HACK/NOTE/WARN/PERF comments
-- and provides commands to jump between them or list them all.

vim.pack.add {
    'https://github.com/nvim-lua/plenary.nvim', -- required dependency
    'https://github.com/folke/todo-comments.nvim',
}

require('todo-comments').setup {
    signs = true, -- show icons in the sign column
    highlight = {
        multiline = false, -- only highlight the first line of the comment
        pattern = [[.*<(KEYWORDS)\s*:]],
    },
    search = {
        command = 'rg',
        args = {
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
        },
    },
}
local function insert_todo(keyword)
    return function()
        local cs = vim.bo.commentstring:gsub('%%s', keyword .. ': ')
        vim.api.nvim_put({ cs }, 'l', false, true)
    end
end

vim.keymap.set('n', '<leader>ct', insert_todo 'TODO', { desc = 'Insert TODO' })
vim.keymap.set('n', '<leader>cf', insert_todo 'FIXME', { desc = 'Insert FIXME' })
vim.keymap.set('n', '<leader>ch', insert_todo 'HACK', { desc = 'Insert HACK' })
vim.keymap.set('n', '<leader>cn', insert_todo 'NOTE', { desc = 'Insert NOTE' })
-- Jump between TODOs
vim.keymap.set('n', '<leader>tn', function() require('todo-comments').jump_next() end, { desc = 'Next todo' })
vim.keymap.set('n', '<leader>tp', function() require('todo-comments').jump_prev() end, { desc = 'Prev todo' })

-- Open todos in trouble.nvim (works since we load trouble too)
vim.keymap.set('n', '<leader>xt', '<cmd>Trouble todo toggle<cr>', { desc = 'Todo (Trouble)' })
vim.keymap.set('n', '<leader>xT', '<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>', { desc = 'Todo/Fix/Fixme (Trouble)' })
