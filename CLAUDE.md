# CLAUDE.md

Guidelines for Claude when editing this Neovim config. Read this first.

## Setup

- **Editor:** Neovim 0.12+
- **Plugin manager:** `vim.pack` (built-in, Lua API — `:h vim.pack`)
- **Config root:** `~/.config/nvim`
- **Plugin install dir:** `~/.local/share/nvim/site/pack/core/` — managed entirely by `vim.pack`. Do not touch directly.
- **Lockfile:** `nvim-pack-lock.json` in the config root — managed by `vim.pack`. Do not edit by hand.

## Hard Rules

1. **Do not switch plugin managers.** No `lazy.nvim`, `packer`, `paq`, `mini.deps`, or bootstrap snippets for any of them. Everything goes through `vim.pack`.
2. **Do not edit `nvim-pack-lock.json` by hand.** Use `vim.pack.update()` / `vim.pack.del()`.
3. **Do not `rm` plugin directories** under `~/.local/share/nvim/site/pack/core/`. Use `vim.pack.del({ 'name' })`. Manual deletion desyncs the lockfile and the plugin will reinstall on next startup.
4. **Do not use `lazy.nvim` spec fields.** `opts =`, `config = function() end`, `event =`, `cmd =`, `ft =`, `keys =`, `dependencies =`, `priority =` are NOT `vim.pack` — they will be silently ignored. `vim.pack.add()` only accepts: `src`, `version`, `name`, `data`.
5. **Always use full URLs** in `vim.pack.add()`: `'https://github.com/user/repo'`, never `'user/repo'`.
6. **Never declare done without verifying the config still starts.** See "Verification" below.

## vim.pack API Cheat Sheet

```lua
-- Add (install if missing + load). It's just a function; can be called multiple times.
vim.pack.add({
  'https://github.com/user/repo',                                  -- simple
  { src = 'https://github.com/user/repo', version = 'stable' },    -- pin branch/tag/commit
  { src = 'https://github.com/user/repo', name = 'custom-name' },  -- rename on disk
})

-- Hooks: autocommands on PackChangedPre / PackChanged. NOT spec fields.
vim.api.nvim_create_autocmd('PackChanged', { callback = function(ev)
  if ev.data.spec.name == 'nvim-treesitter' and ev.data.kind == 'update' then
    if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
    vim.cmd('TSUpdate')
  end
end })

-- Update / delete
vim.pack.update()                          -- all plugins, opens confirmation tabpage
vim.pack.update({ 'mini.nvim' })           -- specific
vim.pack.update(nil, { force = true })     -- no confirmation
vim.pack.update(nil, { offline = true })   -- inspect state, no network
vim.pack.update(nil, { target = 'lockfile' }) -- revert to lockfile state
vim.pack.del({ 'name' })                   -- delete from disk + lockfile
```

**Install hooks must be defined before the `vim.pack.add()` that triggers them.** Put hook autocommands at the top of `init.lua` (or earlier in load order than the `vim.pack.add` call), otherwise they won't fire on first install / lockfile bootstrap.

**Plugins do not auto-setup.** After `vim.pack.add(...)`, call `require('plugin').setup({...})` explicitly. `vim.pack` does not call setup for you (unlike `lazy.nvim`'s `opts`).

## Style & Structure

- **Match the existing layout.** If files live in `plugin/` (auto-sourced alphabetically at startup), put new ones there. If everything is in `init.lua`, don't fragment it without asking.
- **Force load order with filename prefixes** when using `plugin/` (e.g., `00-colorscheme.lua`).
- **Lazy loading: keep it simple.** Prefer `vim.schedule(function() vim.pack.add({...}) end)` or `nvim_create_autocmd('InsertEnter', { once = true, callback = ... })`. Don't introduce a lazy-loading framework.
- **Don't reorder existing `vim.pack.add()` calls** unless a dependency requires it. Load order is observable.

## Workflow Rules

1. **Read the existing files first.** Don't assume layout — run `view` on `init.lua` and `plugin/` before editing.
2. **Make minimal, focused changes.** If asked to add one plugin, don't refactor the file.
3. **State assumptions.** If guessing at a version pin, plugin name, hook command — say so.
4. **One change at a time** for non-trivial edits. Verify between them.
5. **Ask before:**
   - Deleting any plugin
   - Changing `version` / pin on an installed plugin
   - Adding an install hook that runs build commands (`make`, `cargo`, `npm`)
   - Adding `vim.loader.enable()` or other startup-modifying calls
   - Restructuring the config layout (single-file ↔ `plugin/` dir)

## Verification

After every meaningful edit, run a headless startup check:

```bash
nvim --headless +qa 2>&1
```

- No output → clean start.
- Any error / stack trace → broken. Fix before reporting back.

For more thorough checks when something feels off:

```bash
nvim --headless "+checkhealth vim.pack" "+qa" 2>&1
```

In an interactive session:
- `:checkhealth vim.pack` — lockfile/disk drift, orphaned plugins
- `:messages` — startup errors that scrolled off
- `:lua =vim.pack.get()` — inspect what `vim.pack` thinks is installed

## Risky Edits → Test Under a Separate Config

For colorscheme swaps, completion engine swaps, big reorganizations, or anything you're unsure about, suggest the user test with `NVIM_APPNAME` first instead of mutating the live config:

```bash
cp -r ~/.config/nvim ~/.config/nvim-test
NVIM_APPNAME=nvim-test nvim
```

Plugins will reinstall into a separate data dir (`~/.local/share/nvim-test/`), so the main config is untouched.

## Recovery Hints (mention if something breaks)

- Revert to last known-good lockfile state: `git checkout nvim-pack-lock.json && nvim --headless "+lua vim.pack.update(nil, { target = 'lockfile', force = true })" +qa`
- Lockfile / disk out of sync: `:checkhealth vim.pack` will list the specific fix
- Plugin won't load: confirm the `vim.pack.add()` call ran without error (`:messages`) and that you called `require(...).setup()` after it
