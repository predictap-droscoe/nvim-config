-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]


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
  use 'rstacruz/vim-closer'

  use {'junegunn/fzf',
    configure = function()
      vim.cmd([[let $FZF_DEFAULT_COMMAND = 'ag -g ""']])
    end
  }
  use 'junegunn/fzf.vim'

  use 'nanotech/jellybeans.vim'
  use {
    'hoob3rt/lualine.nvim',
    requires = 'ryanoasis/vim-devicons',
    config = function ()
      local jellybeans = require'lualine.themes.jellybeans'
      local white = '#d1d1d1'
      jellybeans.normal.c.fg = white
      require('lualine').setup({
        options = {theme = jellybeans},
        extensions = {'fzf', 'nerdtree'},
        tabline = {lualine_c={'filename'}
        }})
    end
  }

  use 'airblade/vim-gitgutter'
  use 'tpope/vim-fugitive'

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

end)
