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
  use '9mm/vim-closer'


end)
