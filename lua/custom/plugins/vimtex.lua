-- vim.pack.add requires Neovim 0.11+
vim.pack.add {
    {
        src = 'https://github.com/lervag/vimtex',
        opt = true,
    },
}

vim.g.maplocalleader = ','

-- Syntax & concealment
vim.g.vimtex_syntax_conceal_disable = 1
vim.g.vimtex_syntax_enabled = 1
vim.g.vimtex_syntax_conceal = {
    accents = 1,
    ligatures = 1,
    cites = 1,
    fancy = 1,
    math_bounds = 1,
    math_delimiters = 1,
    math_fracs = 1,
    math_super_sub = 1,
    math_symbols = 1,
    sections = 0,
    styles = 1,
}

-- PDF viewer
if vim.fn.has 'mac' == 1 then
    vim.g.vimtex_view_method = 'skim'
else
    vim.g.vimtex_view_method = 'zathura'
end

-- Compiler
vim.g.vimtex_compiler_method = 'latexmk'
vim.g.vimtex_compiler_latexmk = {
    continuous = 1,
    callback = 1,
    options = {
        '-verbose',
        '-file-line-error',
        '-synctex=1',
        '-interaction=nonstopmode',
        '-shell-escape',
    },
}

-- Insert mode mappings (enables \item continuation + math shortcuts)
vim.g.vimtex_imaps_enabled = 1

-- Completion
vim.g.vimtex_complete_enabled = 1
vim.g.vimtex_complete_close_braces = 1

-- Folding
vim.g.vimtex_fold_enabled = 0

-- TOC
vim.g.vimtex_toc_config = {
    split_width = 30,
    show_help = 0,
}

-- Quickfix: open on errors but don't steal focus, suppress noisy warnings
vim.g.vimtex_quickfix_mode = 2
vim.g.vimtex_quickfix_ignore_filters = {
    'Underfull',
    'Overfull',
    'LaTeX Warning',
}

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'tex',
    callback = function()
        vim.cmd 'packadd vimtex'

        vim.keymap.set('n', '<localleader>lt', function() return require('vimtex.fzf-lua').run() end, { buffer = true, desc = 'VimTeX ToC (fzf)' })

        -- Continue \item on Enter in insert mode
        vim.keymap.set('i', '<CR>', function()
            local line = vim.api.nvim_get_current_line()

            if line:match '^%s*\\item' then return '\n\\item ' end

            return '\n'
        end, {
            buffer = true,
            expr = true,
            replace_keycodes = false,
            desc = 'Continue LaTeX itemize',
        })
    end,
})

vim.lsp.config('texlab', {
    settings = {
        texlab = {
            build = {
                executable = 'latexmk',
                args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
                onSave = true,
            },
            forwardSearch = vim.fn.has 'mac' == 1 and {
                executable = '/Applications/Skim.app/Contents/SharedSupport/displayline',
                args = { '%l', '%p', '%f' },
            } or {
                executable = 'zathura',
                args = { '--synctex-forward', '%l:1:%f', '%p' },
            },
        },
    },
})
vim.lsp.enable 'texlab'
