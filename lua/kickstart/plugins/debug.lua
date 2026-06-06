-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

vim.pack.add {
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/jay-babu/mason-nvim-dap.nvim',
  'https://github.com/leoluz/nvim-dap-go',
  'https://github.com/mfussenegger/nvim-dap-python',
}

-- Basic debugging keymaps, feel free to change to your liking!
vim.keymap.set('n', '<F5>', function() require('dap').continue() end, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F1>', function() require('dap').step_into() end, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', function() require('dap').step_over() end, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', function() require('dap').step_out() end, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<leader>b', function() require('dap').toggle_breakpoint() end, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>B', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, { desc = 'Debug: Set Breakpoint' })
-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
vim.keymap.set('n', '<F7>', function() require('dapui').toggle() end, { desc = 'Debug: See last session result.' })
vim.keymap.set('n', '<leader>rp', function()
    vim.cmd.write() -- save first
    local file = vim.fn.shellescape(vim.fn.expand '%')
    local cmd = ({
        python = 'uv run ' .. file, -- uses the project's .venv automatically
        lua = 'lua ' .. file,
        sh = 'bash ' .. file,
    })[vim.bo.filetype]
    if not cmd then
        vim.notify('No run command for filetype: ' .. vim.bo.filetype, vim.log.levels.WARN)
        return
    end
    vim.cmd('botright 15split | terminal ' .. cmd)
    vim.cmd.startinsert()
end, { desc = '[R]un current file' })
local dap = require 'dap'
local dapui = require 'dapui'

require('mason-nvim-dap').setup {
  -- Makes a best effort to setup the various debuggers with
  -- reasonable debug configurations
  automatic_installation = true,

  -- You can provide additional configuration to the handlers,
  -- see mason-nvim-dap README for more information
  handlers = {},

  -- You'll need to check that you have the required things installed
  -- online, please don't ask me how to install them :)
  ensure_installed = {
    -- Update this to ensure that you have the debuggers for the langs you want
    'delve',
  },
}

-- Dap UI setup
-- For more information, see |:help nvim-dap-ui|
---@diagnostic disable-next-line: missing-fields
dapui.setup {
  -- Set icons to characters that are more likely to work in every terminal.
  --    Feel free to remove or use ones that you like more! :)
  --    Don't feel like these are good choices.
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  ---@diagnostic disable-next-line: missing-fields
  controls = {
    icons = {
      pause = '⏸',
      play = '▶',
      step_into = '⏎',
      step_over = '⏭',
      step_out = '⏮',
      step_back = 'b',
      run_last = '▶▶',
      terminate = '⏹',
      disconnect = '⏏',
    },
  },
}

-- Change breakpoint icons
-- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
-- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
-- local breakpoint_icons = vim.g.have_nerd_font
--     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
--   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
-- for type, icon in pairs(breakpoint_icons) do
--   local tp = 'Dap' .. type
--   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
--   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
-- end

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

-- Install golang specific config
require('dap-go').setup {
  delve = {
    -- On Windows delve must be run attached or it crashes.
    -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
    detached = vim.fn.has 'win32' == 0,
  },
}

-- ============================================================
-- Rust / Zig (via codelldb)
-- ============================================================
-- codelldb is installed via Mason (see `ensure_installed` in init.lua).
-- For Rust, the *recommended* path is `:RustLsp debuggables` — rustaceanvim
-- auto-discovers Cargo targets. The raw config below lets <F5> work too for
-- any binary you point it at, and is the primary path for Zig.

local mason_path = vim.fn.stdpath 'data' .. '/mason'
local codelldb_adapter = mason_path .. '/packages/codelldb/extension/adapter/codelldb'

dap.adapters.codelldb = {
  type = 'server',
  port = '${port}',
  executable = {
    command = codelldb_adapter,
    args = { '--port', '${port}' },
  },
}

dap.configurations.rust = {
  {
    name = 'Launch (prompt for cargo binary)',
    type = 'codelldb',
    request = 'launch',
    program = function() return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file') end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}

dap.configurations.zig = {
  {
    name = 'Launch (prompt for zig-out binary)',
    type = 'codelldb',
    request = 'launch',
    program = function() return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/zig-out/bin/', 'file') end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}

-- Convenience: rustaceanvim's debuggables picker (auto-discovers Cargo targets)
vim.keymap.set('n', '<leader>dr', '<cmd>RustLsp debuggables<cr>', { desc = 'Debug: [R]ust debuggables' })

-- ============================================================
-- Python (via debugpy + nvim-dap-python)
-- ============================================================
-- debugpy is installed via Mason (see `ensure_installed` in init.lua).
-- We point nvim-dap-python at Mason's bundled venv so it works regardless of
-- the project's own virtualenv.
local debugpy_python = mason_path .. '/packages/debugpy/venv/bin/python'
require('dap-python').setup(debugpy_python)
