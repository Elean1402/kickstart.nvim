-- ============================================================
-- SECTION 1: FOUNDATION
-- Core Neovim settings, leaders, options, basic keymaps, basic autocmds
-- ============================================================
do
    -- Enable faster startup by caching compiled Lua modules
    vim.loader.enable()

    -- Set <space> as the leader key
    -- See `:help mapleader`
    --  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '
    vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)
    -- Set to true if you have a Nerd Font installed and selected in the terminal
    vim.g.have_nerd_font = true

    -- [[ Setting options ]]
    --  See `:help vim.o`
    -- NOTE: You can change these options as you wish!
    --  For more options, you can see `:help option-list`
    vim.o.colorcolumn = '80'
    -- Make line numbers default
    vim.o.number = true
    -- You can also add relative line numbers, to help with jumping.
    --  Experiment for yourself to see if you like it!
    vim.o.relativenumber = true

    -- Enable mouse mode, can be useful for resizing splits for example!
    vim.o.mouse = 'a'

    -- Don't show the mode, since it's already in the status line
    vim.o.showmode = false

    -- Sync clipboard between OS and Neovim.
    --  Schedule the setting after `UiEnter` because it can increase startup-time.
    --  Remove this option if you want your OS clipboard to remain independent.
    --  See `:help 'clipboard'`
    vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

    -- Enable break indent
    vim.o.breakindent = true

    -- Enable undo/redo changes even after closing and reopening a file
    vim.o.undofile = true

    -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
    vim.o.ignorecase = true
    vim.o.smartcase = true

    -- Keep signcolumn on by default
    vim.o.signcolumn = 'yes'

    -- Decrease update time
    vim.o.updatetime = 250

    -- Decrease mapped sequence wait time
    vim.o.timeoutlen = 300

    -- Configure how new splits should be opened
    vim.o.splitright = true
    vim.o.splitbelow = true

    -- Sets how neovim will display certain whitespace characters in the editor.
    --  See `:help 'list'`
    --  and `:help 'listchars'`
    --
    --  Notice listchars is set using `vim.opt` instead of `vim.o`.
    --  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
    --   See `:help lua-options`
    --   and `:help lua-guide-options`
    vim.o.list = true
    vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

    -- Preview substitutions live, as you type!
    vim.o.inccommand = 'split'

    -- Show which line your cursor is on
    vim.o.cursorline = true

    -- Minimal number of screen lines to keep above and below the cursor.
    vim.o.scrolloff = 10

    -- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
    -- instead raise a dialog asking if you wish to save the current file(s)
    -- See `:help 'confirm'`
    vim.o.confirm = true

    -- [[ Basic Keymaps ]]
    --  See `:help vim.keymap.set()`

    -- Clear highlights on search when pressing <Esc> in normal mode
    --  See `:help hlsearch`
    vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

    -- Diagnostic Config & Keymaps
    --  See `:help vim.diagnostic.Opts`
    vim.diagnostic.config {
        update_in_insert = false,
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = { min = vim.diagnostic.severity.WARN } },

        -- Can switch between these as you prefer
        virtual_text = true, -- Text shows up at the end of the line
        virtual_lines = false, -- Text shows up underneath the line, with virtual lines

        -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
        jump = {
            on_jump = function(_, bufnr)
                vim.diagnostic.open_float {
                    bufnr = bufnr,
                    scope = 'cursor',
                    focus = false,
                }
            end,
        },
    }

    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

    -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
    -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
    -- is not what someone will guess without a bit more experience.
    --
    -- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
    -- or just use <C-\><C-n> to exit terminal mode
    vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

    -- TIP: Disable arrow keys in normal mode
    vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
    vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
    vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
    vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

    -- Keybinds to make split navigation easier.
    --  Use CTRL+<hjkl> to switch between windows
    --
    --  See `:help wincmd` for a list of all window commands
    vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
    vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
    vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
    vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

    -- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
    -- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
    -- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
    -- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
    -- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

    -- Paragraph jumps on QWERTZ home row: ö previous, ä next
    vim.keymap.set({ 'n', 'x', 'o' }, 'ö', '{', { desc = 'Jump to previous paragraph' })
    vim.keymap.set({ 'n', 'x', 'o' }, 'ä', '}', { desc = 'Jump to next paragraph' })

    -- Diagnostic jumps on Ö/Ä (replaces AltGr-heavy [d/]d)
    vim.keymap.set('n', 'Ö', function() vim.diagnostic.jump { count = -1 } end, { desc = 'Jump to previous diagnostic' })
    vim.keymap.set('n', 'Ä', function() vim.diagnostic.jump { count = 1 } end, { desc = 'Jump to next diagnostic' })

    -- [[ Basic Autocommands ]]
    --  See `:help lua-guide-autocommands`

    -- Highlight when yanking (copying) text
    --  Try it with `yap` in normal mode
    --  See `:help vim.hl.on_yank()`
    vim.api.nvim_create_autocmd('TextYankPost', {
        desc = 'Highlight when yanking (copying) text',
        group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
        callback = function() vim.hl.on_yank() end,
    })
end

-- ============================================================
-- SECTION 2: PLUGIN MANAGER INTRO
-- vim.pack intro, build hooks
-- ============================================================
do
    -- [[ Intro to `vim.pack` ]]
    -- `vim.pack` is a new plugin manager built into Neovim,
    --  which provides a Lua interface for installing and managing plugins.
    --
    --  See `:help vim.pack`, `:help vim.pack-examples` or the
    --  excellent blog post from the creator of vim.pack and mini.nvim:
    --  https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack
    --
    --  To inspect plugin state and pending updates, run
    --    :lua vim.pack.update(nil, { offline = true })
    --
    --  To update plugins, run
    --    :lua vim.pack.update()
    --
    --
    --  Throughout the rest of the config there will be examples
    --  of how to install and configure plugins using `vim.pack`.
    --
    --  In this section we set up some autocommands to run build
    --  steps for certain plugins after they are installed or updated.

    local function run_build(name, cmd, cwd)
        local result = vim.system(cmd, { cwd = cwd }):wait()
        if result.code ~= 0 then
            local stderr = result.stderr or ''
            local stdout = result.stdout or ''
            local output = stderr ~= '' and stderr or stdout
            if output == '' then output = 'No output from build command.' end
            vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
        end
    end

    -- This autocommand runs after a plugin is installed or updated and
    --  runs the appropriate build command for that plugin if necessary.
    --
    -- See `:help vim.pack-events`
    vim.api.nvim_create_autocmd('PackChanged', {
        callback = function(ev)
            local name = ev.data.spec.name
            local kind = ev.data.kind
            if kind ~= 'install' and kind ~= 'update' then return end

            if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
                run_build(name, { 'make' }, ev.data.path)
                return
            end

            if name == 'LuaSnip' then
                if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then run_build(name, { 'make', 'install_jsregexp' }, ev.data.path) end
                return
            end

            if name == 'nvim-treesitter' then
                if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
                vim.cmd 'TSUpdate'
                return
            end
        end,
    })
end

---Because most plugins are hosted on GitHub, you can use the helper
---function to have less repetition in the following sections.
---@param repo string
---@return string
local function gh(repo) return 'https://github.com/' .. repo end

-- ============================================================
-- SECTION 3: UI / CORE UX PLUGINS
-- guess-indent, gitsigns, which-key, colorscheme, todo-comments, mini modules
-- ============================================================
do
    -- [[ Installing and Configuring Plugins ]]
    --
    -- To install a plugin simply call `vim.pack.add` with its git url.
    -- This will download the default branch of the plugin, which will usually be `main` or `master`
    -- You can also have more advanced specs, which we will talk about later.
    --
    -- For most plugins its not enough to install them, you also need to call their `.setup()` to start them.
    --
    -- For example, lets say we want to install `guess-indent.nvim` - a plugin for
    -- automatically detecting and setting the indentation.
    --
    -- We first install it from https://github.com/NMAC427/guess-indent.nvim
    -- and then call its `setup()` function to start it with default settings.
    vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
    require('guess-indent').setup {}

    -- Because lua is a real programming language, you can also have some logic to your installation -
    -- like only installing a plugin if a condition is met.
    --
    -- Here we only install `nvim-web-devicons` (which adds pretty icons) if we have a Nerd Font,
    -- since otherwise the icons won't display properly.
    if vim.g.have_nerd_font then vim.pack.add { gh 'nvim-tree/nvim-web-devicons' } end

    -- gitsigns is configured in `lua/kickstart/plugins/gitsigns.lua`.

    -- Useful plugin to show you pending keybinds.
    vim.pack.add { gh 'folke/which-key.nvim' }
    require('which-key').setup {
        -- Delay between pressing a key and opening which-key (milliseconds)
        delay = 0,
        icons = { mappings = vim.g.have_nerd_font },
        -- Document existing key chains
        spec = {
            { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
            { '<leader>t', group = '[T]oggle' },
            { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } }, -- Enable gitsigns recommended keymaps first
            { '<leader>c', group = '[C]omment/TODO' },
            { '<leader>x', group = 'Trouble' },
            { 'gr', group = 'LSP Actions', mode = { 'n' } },
        },
    }

    -- [[ Colorscheme ]]
    -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command under that to load whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    vim.pack.add { gh 'folke/tokyonight.nvim' }
    ---@diagnostic disable-next-line: missing-fields
    require('tokyonight').setup {
        styles = {
            comments = { italic = false }, -- Disable italics in comments
        },
    }

    -- Load the colorscheme here.
    -- Like many other themes, this one has different styles, and you could load
    -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
    vim.cmd.colorscheme 'tokyonight-night'

    -- todo-comments is configured in `lua/custom/plugins/todo-comments.lua`.

    -- [[ mini.nvim ]]
    --  A collection of various small independent plugins/modules
    vim.pack.add { gh 'nvim-mini/mini.nvim' }

    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yiiq - [Y]ank [I]nside [I]+1 [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup {
        -- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
        mappings = {
            around_next = 'aa',
            inside_next = 'ii',
        },
        n_lines = 500,
    }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require 'mini.statusline'
    -- Set `use_icons` to true if you have a Nerd Font
    statusline.setup { use_icons = vim.g.have_nerd_font }

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function() return '%2l:%-2v' end

    -- ... and there is more!
    --  Check out: https://github.com/nvim-mini/mini.nvim

    -- [[ undotree ]] — visualize and navigate the undo tree
    vim.pack.add { gh 'mbbill/undotree' }
    vim.g.undotree_SetFocusWhenToggle = 1
    vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Toggle [U]ndotree' })
end
-- ============================================================
-- SECTION 4: SEARCH & NAVIGATION
-- fzf-lua setup, keymaps, LSP picker mappings
-- ============================================================
do
    vim.pack.add { gh 'ibhagwan/fzf-lua' }

    local fzf = require 'fzf-lua'

    fzf.setup {
        'default',
        ui_select = { winopts = { height = 0.33, width = 0.33 } },
    }

    vim.keymap.set('n', '<leader>sh', fzf.helptags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', fzf.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', fzf.files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>ss', fzf.builtin, { desc = '[S]earch [S]elect fzf-lua' })
    vim.keymap.set({ 'n', 'v' }, '<leader>sw', fzf.grep_cword, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', fzf.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', fzf.diagnostics_workspace, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', fzf.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', fzf.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader>sc', fzf.commands, { desc = '[S]earch [C]ommands' })
    vim.keymap.set('n', '<leader><leader>', fzf.buffers, { desc = '[ ] Find existing buffers' })

    -- LSP pickers on LspAttach
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('fzf-lsp-attach', { clear = true }),
        callback = function(event)
            local buf = event.buf
            vim.keymap.set('n', 'grr', fzf.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
            vim.keymap.set('n', 'gri', fzf.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })
            vim.keymap.set('n', 'gd', fzf.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
            vim.keymap.set('n', 'gO', fzf.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })
            vim.keymap.set('n', 'gW', fzf.lsp_live_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })
            vim.keymap.set('n', 'grt', fzf.lsp_typedefs, { buffer = buf, desc = '[G]oto [T]ype Definition' })
        end,
    })

    -- Fuzzy search in current buffer
    vim.keymap.set(
        'n',
        '<leader>/',
        function() fzf.grep_curbuf { winopts = { height = 0.33, width = 0.75 }, preview = { hidden = 'hidden' } } end,
        { desc = '[/] Fuzzily search in current buffer' }
    )

    -- Live grep across open buffers
    vim.keymap.set(
        'n',
        '<leader>s/',
        function() fzf.live_grep { grep_open_files = true, prompt = 'Live Grep in Open Files> ' } end,
        { desc = '[S]earch [/] in Open Files' }
    )

    -- Search Neovim config files
    vim.keymap.set('n', '<leader>sn', function() fzf.files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })

    -- [[ harpoon ]] — pin a handful of files and jump between them by index.
    -- Workflow: `<leader>a` to pin the current file, `<C-e>` to see the list,
    -- `<leader>1`..`<leader>4` to jump directly.
    vim.pack.add {
        gh 'nvim-lua/plenary.nvim', -- harpoon dependency; idempotent if loaded elsewhere
        { src = gh 'ThePrimeagen/harpoon', version = 'harpoon2' },
    }
    local harpoon = require 'harpoon'
    harpoon:setup()

    vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end, { desc = 'Harpoon [A]dd file' })
    vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon menu' })
    vim.keymap.set('n', '<leader>1', function() harpoon:list():select(1) end, { desc = 'Harpoon file 1' })
    vim.keymap.set('n', '<leader>2', function() harpoon:list():select(2) end, { desc = 'Harpoon file 2' })
    vim.keymap.set('n', '<leader>3', function() harpoon:list():select(3) end, { desc = 'Harpoon file 3' })
    vim.keymap.set('n', '<leader>4', function() harpoon:list():select(4) end, { desc = 'Harpoon file 4' })
end

-- ============================================================
-- SECTION 5: LSP
-- LSP keymaps, server configuration, Mason tools installations
-- ============================================================
do
    -- [[ LSP Configuration ]]
    -- Brief aside: **What is LSP?**
    --
    -- LSP is an initialism you've probably heard, but might not understand what it is.
    --
    -- LSP stands for Language Server Protocol. It's a protocol that helps editors
    -- and language tooling communicate in a standardized fashion.
    --
    -- In general, you have a "server" which is some tool built to understand a particular
    -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
    -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
    -- processes that communicate with some "client" - in this case, Neovim!
    --
    -- LSP provides Neovim with features like:
    --  - Go to definition
    --  - Find references
    --  - Autocompletion
    --  - Symbol Search
    --  - and more!
    --
    -- Thus, Language Servers are external tools that must be installed separately from
    -- Neovim. This is where `mason` and related plugins come into play.
    --
    -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
    -- and elegantly composed help section, `:help lsp-vs-treesitter`

    -- Useful status updates for LSP.
    vim.pack.add { gh 'j-hui/fidget.nvim' }
    require('fidget').setup {}

    --  This function gets run when an LSP attaches to a particular buffer.
    --    That is to say, every time a new file is opened that is associated with
    --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
    --    function will be executed to configure the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
            -- NOTE: Remember that Lua is a real programming language, and as such it is possible
            -- to define small helper and utility functions so you don't have to repeat yourself.
            --
            -- In this case, we create a function that lets us more easily define mappings specific
            -- for LSP related items. It sets the mode, buffer and description for us each time.
            local map = function(keys, func, desc, mode)
                mode = mode or 'n'
                vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
            end

            -- Rename the variable under your cursor.
            --  Most Language Servers support renaming across files, etc.
            map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

            -- Execute a code action, usually your cursor needs to be on top of an error
            -- or a suggestion from your LSP for this to activate.
            map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

            -- WARN: This is not Goto Definition, this is Goto Declaration.
            --  For example, in C this would take you to the header.
            map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

            -- The following two autocommands are used to highlight references of the
            -- word under your cursor when your cursor rests there for a little while.
            --    See `:help CursorHold` for information about when this is executed
            --
            -- When you move your cursor, the highlights will be cleared (the second autocommand).
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if client and client:supports_method('textDocument/documentHighlight', event.buf) then
                local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
                vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                    buffer = event.buf,
                    group = highlight_augroup,
                    callback = vim.lsp.buf.document_highlight,
                })

                vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                    buffer = event.buf,
                    group = highlight_augroup,
                    callback = vim.lsp.buf.clear_references,
                })

                vim.api.nvim_create_autocmd('LspDetach', {
                    group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                    callback = function(event2)
                        vim.lsp.buf.clear_references()
                        vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                    end,
                })
            end

            -- The following code creates a keymap to toggle inlay hints in your
            -- code, if the language server you are using supports them
            --
            -- This may be unwanted, since they displace some of your code
            if client and client:supports_method('textDocument/inlayHint', event.buf) then
                map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
            end
        end,
    })

    -- Enable the following language servers
    --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --  See `:help lsp-config` for information about keys and how to configure
    ---@type table<string, vim.lsp.Config>
    local servers = {
        clangd = {},
        gopls = {},
        pyright = {},
        zls = {},
        texlab = {},
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        -- ts_ls = {},

        -- Special Lua Config, as recommended by neovim help docs
        lua_ls = {
            on_init = function(client)
                client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

                if client.workspace_folders then
                    local path = client.workspace_folders[1].name
                    if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
                end

                client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                    runtime = {
                        version = 'LuaJIT',
                        path = { 'lua/?.lua', 'lua/?/init.lua' },
                    },
                    workspace = {
                        checkThirdParty = false,
                        -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
                        --  See https://github.com/neovim/nvim-lspconfig/issues/3189
                        library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
                            '${3rd}/luv/library',
                            '${3rd}/busted/library',
                        }),
                    },
                })
            end,
            ---@type lspconfig.settings.lua_ls
            settings = {
                Lua = {
                    format = { enable = false }, -- Formatting is done by stylua via conform
                },
            },
        },
    }

    vim.pack.add {
        gh 'neovim/nvim-lspconfig',
        gh 'mason-org/mason.nvim',
        gh 'mason-org/mason-lspconfig.nvim',
        gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
    }

    -- Automatically install LSPs and related tools to stdpath for Neovim
    require('mason').setup {}
    -- mason-lspconfig provides the LSP-name → Mason-package-name mapping that
    -- mason-tool-installer relies on (e.g. `lua_ls` → `lua-language-server`).
    -- `automatic_enable = false` so it doesn't double-enable servers we manually
    -- configure via `vim.lsp.enable` below.
    require('mason-lspconfig').setup { automatic_enable = false }

    -- Ensure the servers and tools above are installed
    --
    -- To check the current status of installed tools and/or manually install
    -- other tools, you can run
    --    :Mason
    --
    -- You can press `g?` for help in this menu.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
        'stylua', -- Lua formatter, used by conform
        'rust-analyzer', -- used by rustaceanvim, not enabled directly
        'codelldb', -- DAP adapter for rust
    })

    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    for name, server in pairs(servers) do
        vim.lsp.config(name, server)
        vim.lsp.enable(name)
    end
end

-- ============================================================
-- SECTION 6: FORMATTING
-- conform.nvim setup and keymap
-- ============================================================
do
    -- [[ Formatting ]]
    vim.pack.add { gh 'stevearc/conform.nvim' }
    require('conform').setup {
        notify_on_error = false,
        format_on_save = function(bufnr)
            -- You can specify filetypes to autoformat on save here:
            local enabled_filetypes = {
                lua = true,
                python = true,
                rust = true,
            }
            if enabled_filetypes[vim.bo[bufnr].filetype] then
                return { timeout_ms = 500 }
            else
                return nil
            end
        end,
        default_format_opts = {
            lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
        },
        -- You can also specify external formatters in here.
        formatters_by_ft = {
            rust = { 'rustfmt' },
            -- Conform can also run multiple formatters sequentially
            -- python = { "isort", "black" },
            --
            -- You can use 'stop_after_first' to run the first available formatter from the list
            -- javascript = { "prettierd", "prettier", stop_after_first = true },
        },
    }

    vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })
end

-- ============================================================
-- SECTION 7: AUTOCOMPLETE & SNIPPETS
-- blink.cmp and luasnip setup
-- ============================================================
do
    -- [[ Snippet Engine ]]

    -- NOTE: You can also specify plugin using a version range for its git tag.
    --  See `:help vim.version.range()` for more info
    vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
    require('luasnip').setup {}

    -- `friendly-snippets` contains a variety of premade snippets.
    --    See the README about individual language/framework/plugin snippets:
    --    https://github.com/rafamadriz/friendly-snippets
    --
    -- vim.pack.add { gh 'rafamadriz/friendly-snippets' }
    -- require('luasnip.loaders.from_vscode').lazy_load()

    -- [[ Autocomplete Engine ]]
    vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
    require('blink.cmp').setup {
        keymap = {
            -- 'default' (recommended) for mappings similar to built-in completions
            --   <c-y> to accept ([y]es) the completion.
            --    This will auto-import if your LSP supports it.
            --    This will expand snippets if the LSP sent a snippet.
            -- 'super-tab' for tab to accept
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- For an understanding of why the 'default' preset is recommended,
            -- you will need to read `:help ins-completion`
            --
            -- No, but seriously. Please read `:help ins-completion`, it is really good!
            --
            -- All presets have the following mappings:
            -- <tab>/<s-tab>: move to right/left of your snippet expansion
            -- <c-space>: Open menu or open docs if already open
            -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
            -- <c-e>: Hide menu
            -- <c-k>: Toggle signature help
            --
            -- See `:help blink-cmp-config-keymap` for defining your own keymap
            preset = 'default',
            ['<Tab>'] = { 'accept', 'fallback' },
            ['<C-j>'] = { 'select_next', 'fallback' },
            ['<C-k>'] = { 'select_prev', 'fallback' },

            -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
            --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },

        appearance = {
            -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = 'normal',
        },

        completion = {
            -- By default, you may press `<c-space>` to show the documentation.
            -- Optionally, set `auto_show = true` to show the documentation after a delay.
            documentation = { auto_show = true, auto_show_delay_ms = 500 },
        },

        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },

        snippets = { preset = 'luasnip' },

        -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
        -- which automatically downloads a prebuilt binary when enabled.
        --
        -- By default, we use the Lua implementation instead, but you may enable
        -- the rust implementation via `'prefer_rust_with_warning'`
        --
        -- See `:help blink-cmp-config-fuzzy` for more information
        fuzzy = { implementation = 'prefer_rust_with_warning' },

        -- Shows a signature help window while you type arguments for a function
        signature = { enabled = true },
    }
end
-- ============================================================
-- SECTION 8: TREESITTER
-- Parser installation, syntax highlighting, folds, indentation
-- ============================================================
do
    -- [[ Configure Treesitter ]]
    --  Used to highlight, edit, and navigate code
    --
    --  See `:help nvim-treesitter-intro`

    -- NOTE: You can also specify a branch or a specific commit
    vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }

    -- Ensure basic parsers are installed
    local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'rust', 'toml' }
    require('nvim-treesitter').install(parsers)

    ---@param buf integer
    ---@param language string
    local function treesitter_try_attach(buf, language)
        -- Check if a parser exists and load it
        if not vim.treesitter.language.add(language) then return end
        -- Enable syntax highlighting and other treesitter features
        vim.treesitter.start(buf, language)

        -- Enable treesitter based folds
        -- For more info on folds see `:help folds`
        -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        -- vim.wo.foldmethod = 'expr'

        -- Check if treesitter indentation is available for this language, and if so enable it
        -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
        local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

        -- Enable treesitter based indentation
        if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
    end

    local available_parsers = require('nvim-treesitter').get_available()
    vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
            local buf, filetype = args.buf, args.match

            local language = vim.treesitter.language.get_lang(filetype)
            if not language then return end

            local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

            if vim.tbl_contains(installed_parsers, language) then
                -- Enable the parser if it is already installed
                treesitter_try_attach(buf, language)
            elseif vim.tbl_contains(available_parsers, language) then
                -- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
                require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
            else
                -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
                treesitter_try_attach(buf, language)
            end
        end,
    })

    -- [[ treesitter-context ]] — sticky context line at the top of the buffer
    -- showing the enclosing function/class/scope while you scroll.
    vim.pack.add { gh 'nvim-treesitter/nvim-treesitter-context' }
    require('treesitter-context').setup {
        max_lines = 3, -- limit how tall the sticky header can grow
        multiline_threshold = 1, -- collapse multi-line declarations to a single line
        mode = 'cursor', -- update based on cursor position (less jumpy than 'topline')
    }
end

-- ============================================================
-- SECTION 9: OPTIONAL EXAMPLES / NEXT STEPS
-- kickstart.plugins.* examples
-- ============================================================
do
    -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
    -- init.lua. If you want these files, they are in the repository, so you can just download them and
    -- place them in the correct locations.
    local py = vim.fn.expand '~/.venv/neovim/bin/python'
    if vim.uv.fs_stat(py) then vim.g.python3_host_prog = py end
    -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
    --
    --  Here are some example plugins that I've included in the Kickstart repository.
    --  Uncomment any of the lines below to enable them (you will need to restart nvim).
    --
    require 'kickstart.plugins.debug'
    require 'kickstart.plugins.indent_line'
    require 'kickstart.plugins.lint'
    require 'kickstart.plugins.autopairs'
    -- require 'kickstart.plugins.neo-tree'
    require 'kickstart.plugins.gitsigns' -- adds gitsigns recommended keymaps

    -- Loads every *.lua file in `lua/custom/plugins/` (see that dir's `init.lua`).
    require 'custom.plugins'
end

-- ============================================================
-- SECTION 10: RUST
-- rustaceanvim, crates.nvim
-- ============================================================
do
    -- vim.g.rustaceanvim must be set before rustaceanvim loads (auto-attaches on rust filetype).
    vim.g.rustaceanvim = {
        server = {
            default_settings = {
                ['rust-analyzer'] = {
                    check = { command = 'clippy' },
                    cargo = { allFeatures = true },
                    procMacro = { enable = true },
                    inlayHints = { closingBraceHints = { minLines = 10 } },
                },
            },
        },
    }
    vim.pack.add { gh 'mrcjkb/rustaceanvim' }

    vim.pack.add { gh 'saecki/crates.nvim' }
    require('crates').setup {}
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=4 sts=4 sw=4 et
