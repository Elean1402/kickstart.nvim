-- overleaf.nvim — edit Overleaf projects from Neovim over its realtime protocol.
--   https://github.com/richwomanbtc/overleaf.nvim
--
-- Unlike a pure-Lua plugin, this one ships a Node.js backend (in the repo's
-- `node/` dir) that must be built with `npm install` after every install/update.
-- Requirements: Node.js >= 18 and an Overleaf session cookie (see setup below).

-- Build step. With vim.pack this is a PackChanged autocommand, NOT a lazy.nvim
-- `build =` field. It must be registered BEFORE the vim.pack.add() that installs
-- the plugin, otherwise it won't fire on first install / lockfile bootstrap.
vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        if ev.data.spec.name ~= 'overleaf.nvim' then return end
        if ev.data.kind ~= 'install' and ev.data.kind ~= 'update' then return end

        if vim.fn.executable 'npm' ~= 1 then
            vim.notify(('overleaf.nvim: npm not found on PATH; run `npm install` in %s/node manually'):format(ev.data.path), vim.log.levels.WARN)
            return
        end

        local node_dir = vim.fs.joinpath(ev.data.path, 'node')
        local result = vim.system({ 'npm', 'install' }, { cwd = node_dir }):wait()
        if result.code ~= 0 then
            local output = (result.stderr ~= '' and result.stderr) or result.stdout or 'No output from npm install.'
            vim.notify('overleaf.nvim: `npm install` failed:\n' .. output, vim.log.levels.ERROR)
        end
    end,
})

vim.pack.add { 'https://github.com/richwomanbtc/overleaf.nvim' }

require('overleaf').setup({
    -- Path to .env file containing OVERLEAF_COOKIE (default: '.env')
    env_file = '.env',

    -- Session cookie (overrides .env)
    cookie = 'overleaf_session2=s%3AQgGNcx-2y7Ve9jaqaILcvA9cv9JQiIBm.PRKspJDvCtqoXJJOqd3rSAn5Isldp7LaN97JK1i1bWM',

    -- Path to Node.js binary (default: 'node')
    node_path = 'node',

    -- Log level: 'debug', 'info', 'warn', 'error' (default: 'info')
    log_level = 'info',

    -- Local file sync directory for external tools like Claude Code (default: nil = disabled)
    -- When set, all documents are mirrored to disk and external changes are synced back.
    sync_dir = '~/.overleaf',

    -- Set to false to disable default keymaps
    keys = true,
})
