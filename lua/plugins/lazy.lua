local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {}
    end,
  },
  {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  {
    'terrortylor/nvim-comment',
    config = function()
      require('nvim_comment').setup({create_mappings = false})
    end
  },
  -- {
    --   'VonHeikemen/lsp-zero.nvim',
    --   branch = 'v3.x',
    --   lazy = true,
    --   config = false,
    --   init = function()
    --     vim.g.lsp_zero_extend_cmp = 0
    --     vim.g.lsp_zero_extend_lspconfig = 0
    --   end,
    -- },
    {
      'williamboman/mason.nvim',
      opts = {
        ensure_installed = { 'ts_ls', 'pyright', 'html', 'cssls', 'emmet_ls' },
      },
    },

    -- Autocompletion
    {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = { 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      cmp.setup({
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
      })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'williamboman/mason.nvim',
    },
    init = function()
      -- Always show the sign column (where icons like errors/warnings appear)
      vim.opt.signcolumn = 'yes'
    end,
    config = function()
      -- 1. Get completion capabilities from nvim-cmp
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- 2. NEW: Set global configuration for all LSP servers.
      -- This replaces the need to pass 'capabilities' to every single server setup.
      vim.lsp.config('*', { 
        capabilities = capabilities 
      })

      -- 3. Define keymaps that only activate when an LSP is attached to a file.
      vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
          local opts = { buffer = event.buf }

          -- Simplified function calls instead of <cmd> strings
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'x' }, '<F3>', function() vim.lsp.buf.format({ async = true }) end, opts)
          vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, opts)
        end,
      })

      -- 4. NEW: Enable your servers using the native Neovim 0.11 API.
      -- This replaces: require('lspconfig').ts_ls.setup({})
      local servers = { 'ts_ls', 'pyright', 'html', 'cssls', 'emmet_ls' }
      for _, server in ipairs(servers) do
        vim.lsp.enable(server)
      end
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require("gitsigns").setup()
    end,
  },
  { 'tpope/vim-fugitive' },
  { "folke/twilight.nvim", opts = {}},
  {
    'fei6409/log-highlight.nvim',
    opts = {},
  },
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  {
    "saadparwaiz1/cmp_luasnip",
  },
  {
    "rafamadriz/friendly-snippets",  -- optional
    lazy = true,
  },
  {
    "brianhuster/live-preview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "LivePreview" },
    opts = {
      port = 5500,
      browser = "default", -- or "firefox", "chrome", etc.
    },
  },
})
