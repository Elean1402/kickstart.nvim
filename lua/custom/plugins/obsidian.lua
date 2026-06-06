vim.pack.add({
  {
    src = 'https://github.com/obsidian-nvim/obsidian.nvim',
    version = vim.version.range('*'),  -- track latest release, drop this line for latest commit
  },
})

require('obsidian').setup({
  legacy_commands = false,
  workspaces = {
    {
      name = "To-Do",
      path = "~/obsidian/To-Do's/",  -- point this at your actual vault folder
    },
    {
      name = 'Uni',
      path = '~/obsidian/Uni',
    },
    {
      name = 'Studie',
      path = '~/obsidian/Studie',
    },
    {
      name = 'New Slate',
      path = '~/obsidian/New Slate',
    },
  },
  ui = { enable = false },  -- let render-markdown.nvim do the rendering
})
