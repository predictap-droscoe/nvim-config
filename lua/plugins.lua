-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Nerdtree
  use 'scrooloose/nerdtree'
  use 'jistr/vim-nerdtree-tabs'
  use 'Xuyuanp/nerdtree-git-plugin'
  use 'PhilRunninger/nerdtree-visual-selection'

  -- QOL stuff
  use 'tpope/vim-commentary'
  use 'tpope/vim-sleuth'
  use 'tpope/vim-surround'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-endwise'
  use 'rstacruz/vim-closer'

  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'

  use 'nanotech/jellybeans.vim'
  use {
    'vim-airline/vim-airline',
    config = function()
      vim.g["airline_theme"] = 'jellybeans'
      vim.g["airline#extensions#syntastic#enabled"] = 1
      vim.g["airline#extensions#branch#enabled"] = 1
      vim.g["airline#extensions#tabline#enabled"] = 1
      vim.g["airline#extensions#tagbar#enabled"] = 1
      vim.g["airline_skip_empty_sections"] = 1
      vim.g["airline#extensions#tabline#ignore_bufadd_pat"] = '!|nerd_tree|undotree'
    end
  }
  use 'vim-airline/vim-airline-themes'

  use 'airblade/vim-gitgutter'

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function ()
      require('nvim-treesitter.configs').setup({
        ensure_installed = "maintained",
        highlight = {
          enable = true
        },
        indent = {
          enable = true
        }
      })
    end
  }

  use {
    'neovim/nvim-lspconfig',
    config = function()
      require('lspconfig').pyright.setup {}
    end
  }
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-buffer'
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin
  use {'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
    requires = 'L3MON4D3/LuaSnip',
    config = function()
      -- Add additional capabilities supported by nvim-cmp
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
      -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
      local lspconfig = require('lspconfig')
      lspconfig.pyright.setup({
        capabilities = capabilities
      })
      lspconfig.tsserver.setup({
        capabilities = capabilities
      })
      -- Set completeopt to have a better completion experience
      vim.o.completeopt = 'menu,menuone,noselect'
      -- luasnip setup
      local luasnip = require 'luasnip'

      -- nvim-cmp setup
      local cmp = require 'cmp'
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<Tab>'] = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
            else
              fallback()
            end
          end,
          ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
            else
              fallback()
            end
          end,
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' }
        },
      })
    end
  }
end)



