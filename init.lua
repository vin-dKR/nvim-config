-- init.lua
-- Load Packer
vim.cmd [[packadd packer.nvim]]


require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Plugins
  use 'nvim-treesitter/nvim-treesitter' -- Better syntax highlighting
  use 'nvim-lua/plenary.nvim'           -- Lua functions used by many plugins
  use 'neovim/nvim-lspconfig'           -- LSP support for NeoVim
  use 'hrsh7th/nvim-cmp'                -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' 		-- LSP source for nvim-cmp
  use 'hrsh7th/cmp-buffer' 		-- Buffer source for nvim-cmp
  use 'hrsh7th/cmp-path' 		-- Path source for nvim-cmp
  use 'hrsh7th/cmp-cmdline' 		-- Cmdline source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' 	-- Snippet source for nvim-cmp
  use 'L3MON4D3/LuaSnip'                -- Snippet engine
  use 'nvim-telescope/telescope.nvim'   -- Fuzzy finder plugin
  use { 'p00f/nvim-ts-rainbow' }  	-- For rainbow parentheses
  use { 'windwp/nvim-ts-autotag' } 	-- For automatic tag closing in HTML/JSX
  use 'kyazdani42/nvim-tree.lua'	-- Navigate b/w files easily

  -- More plugins as per your choice...
  -- after this run command :PackerSync at last and all set
end)


-- LSP 
local lspconfig = require('lspconfig')

-- nvim-cmp setup
local cmp = require'cmp'


-- Set leader key
vim.g.mapleader = " "

-- Save and exit easily
vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>', { noremap = true })   -- space+w (shortcut) -> save/wrote
vim.api.nvim_set_keymap('n', '<leader>q', ':q<CR>', { noremap = true })   -- space+q (shortcut) -> quit

-- Open Telescope for finding files
vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope find_files<CR>', { noremap = true, silent = true })  -- space+ff (shortcut) -> find files

-- Setup nvim-cmp.
local cmp = require'cmp'




vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldenable = false            -- Start with all folds Open

-- Enable relative line numbers
vim.o.relativenumber = true          -- Set relative line numbers



-- Configure nvim-cmp 
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),            -- Ctrl+space (shortcut) -> auto-complete
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item.
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif require('luasnip').expand_or_jumpable() then
        require('luasnip').expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif require('luasnip').jumpable(-1) then
        require('luasnip').jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
  }, {
    { name = 'buffer' },
    { name = 'path' },
  })
})





-- Setup LSP for TypeScript (replace tsserver(...if u have it) with ts_ls)
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

require('lspconfig').ts_ls.setup {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    client.server_capabilities.document_formatting = false  -- Optional: disable formatting if using prettier
  end,
}





-- Treesitter syntax highlighting
require'nvim-treesitter.configs'.setup {
  -- Existing setup for highlighting
  ensure_installed = { "lua", "javascript", "typescript", "python" }, -- Add languages here
  highlight = {
    enable = true,  -- Syntax highlighting
  },

  -- Add incremental selection
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",  -- Start selection
      node_incremental = "grn",  -- Increment to the next node
      scope_incremental = "grc",  -- Increment to the next scope
      node_decremental = "grm",  -- Decrement to the previous node
    },
  },

  -- Add text objects
  textobjects = {
    select = {
      enable = true,
      lookahead = true,  -- Automatically jump forward to textobj
      keymaps = {
        ["af"] = "@function.outer",  -- Select outer part of a function
        ["if"] = "@function.inner",  -- Select inner part of a function
        ["ac"] = "@class.outer",     -- Select outer part of a class
        ["ic"] = "@class.inner",     -- Select inner part of a class
      },
    },
  },

  -- Add folding
  fold = {
    enable = true,
    disable = {},  -- Add languages you don't want folding for
  },

  -- Enable rainbow parentheses
  rainbow = {
    enable = true,
    extended_mode = true,  -- Also highlight non-bracket delimiters like HTML tags
    max_file_lines = nil,  -- Enable for all files
  },

  -- Enable autotagging (useful for HTML and JSX)
  autotag = {
    enable = true,
  },
}







-- Navigate b/w files Tab
require'nvim-tree'.setup {}

-- Keybinding to toggle file explorer
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

