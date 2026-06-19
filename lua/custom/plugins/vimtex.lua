vim.pack.add { 'https://github.com/lervag/vimtex' }

-- vimtex uses `,` as its <localleader>. Set this before any <localleader>
-- mapping is created for vimtex.
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
elseif vim.env.WAYLAND_DISPLAY and vim.env.WAYLAND_DISPLAY ~= '' then
    -- Wayland: zathura's GTK surface renders solid black on KDE Wayland + AMD
    -- regardless of backend (x11) or GPU (software GL), so it is unusable here.
    -- Okular is Qt/KDE-native, renders correctly on KDE Wayland, and supports
    -- SyncTeX forward search via --unique. @pdf/@line/@tex are vimtex tokens.
    vim.g.vimtex_view_method = 'general'
    -- Okular can't form a valid URL from this project's spaced path
    -- ("Bachelorarbeit Charli"): it leaves the space literal and encodes '#'
    -- to '%23', so it refuses the file. The wrapper percent-encodes the path
    -- into a proper file:// URL before calling okular. @pdf/@tex are shell-
    -- escaped by vimtex, so each arrives as one argument despite the space.
    vim.g.vimtex_view_general_viewer = vim.fn.expand '~/.local/bin/vimtex-okular'
    vim.g.vimtex_view_general_options = '@pdf @line @tex'
else
    vim.g.vimtex_view_method = 'zathura'
end

-- Compiler
vim.g.vimtex_compiler_method = 'latexmk'
vim.g.vimtex_compiler_latexmk = {
    out_dir = 'build',
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

        -- Continue \item on Enter in insert mode. On any other line, fall
        -- through to nvim-autopairs' <CR> handler (pair-splitting / indent)
        -- instead of a bare newline, which this buffer-local map would
        -- otherwise clobber inside tex files.
        vim.keymap.set('i', '<CR>', function()
            local line = vim.api.nvim_get_current_line()

            if line:match '^%s*\\item' then return '\n\\item ' end

            return require('nvim-autopairs').autopairs_cr()
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
            -- VimTeX (,ll) owns compilation and builds into build/ in continuous
            -- mode. Don't let texlab also build, or it litters the source folder
            -- and fights VimTeX over latexmk lock files. Output goes to build/.
            build = {
                executable = 'latexmk',
                args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '-output-directory=build', '%f' },
                onSave = false,
            },
            -- texlab calls okular directly with a bare `%p#src:%l %f` string,
            -- which okular treats as a schemeless local path and percent-encodes
            -- the '#' to '%23', breaking the synctex jump. Reuse the same wrapper
            -- as VimTeX: it builds a proper file:// URL so '#' stays a fragment.
            forwardSearch = vim.fn.has 'mac' == 1 and {
                executable = '/Applications/Skim.app/Contents/SharedSupport/displayline',
                args = { '%l', '%p', '%f' },
            } or {
                executable = vim.fn.expand '~/.local/bin/vimtex-okular',
                args = { '%p', '%l', '%f' },
            },
        },
    },
})
vim.lsp.enable 'texlab'
