-- Usefile things

local fn = vim.fn
local opt = vim.opt
local cmd = vim.cmd

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-------------------------------------------------------------------
-- Auto-install paq-nvim package manager

local install_path = fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path})
end

require "paq" {
  "savq/paq-nvim";
}


-------------------------------------------------------------------
-- Settings


-- Copy/Paste/Cut
cmd([[if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif
]])


-- Enable invisible characters
opt.listchars =  {space='·', tab='>-'}
opt.list = true

-- disable swap files
opt.swapfile = false

-- write files as they are, don't mess with line endings etc.
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'
opt.fileencodings = {'utf-8'}
opt.bomb = true
opt.binary = true

opt.hlsearch = true -- highlight search
opt.cursorline = true --highlight the current line

opt.hidden = true -- don't complain when hiding unedited files
opt.fileformats = {'unix', 'dos', 'mac'}


-- TODO do I need syntax on?

-- some visuals
opt.ruler = true
opt.rnu = true
opt.mousemodel = "popup"
-- opt.t_Co = 256
opt.laststatus = 2

-- TODO what does this do again?
opt.modeline = true
opt.modelines = 10

opt.title = true
opt.titleold = 'Terminal'
opt.titlestring='%F'

opt.statusline="%F%m%r%h%w%=(%{&ff}/%Y) (line %l/%L, col %c) "

-- Make search case insensitive, but become sensitive if an upper case
-- character is used.
opt.ignorecase = true
opt.smartcase = true
opt.spelllang = "en_us"
opt.spellfile = fn.stdpath('config') .. "/spell/en.utf-8.add"

opt.undofile = true
opt.undodir = fn.stdpath('config') .. "/undo"

cmd("highlight ExtraWhitespace ctermbg=red guibg=red")
cmd("match ExtraWhitespace /\\s\\+$/")

opt.mouse="a"
for i,c in ipairs({'<', '>', 'h', 'l', '[', ']'}) do
  opt.whichwrap:append(c)
end

-- tabstuff
opt.tabstop = 2
opt.shiftwidth = 0
opt.expandtab = true

-- TODO determine if these can be done more natively
cmd([[
filetype on
filetype plugin on
filetype indent on

autocmd FileType make set noexpandtab tabstop=8 shiftwidth=8 softtabstop=0
]])

-- find/replace previews
opt.inccommand = "split"

opt.autoread = true


------------------------------------------------------------------------
-- Mappings

vim.g.mapleader = ','

-- some command shortcuts
cmd('cnoreabbrev W! w!')
cmd('cnoreabbrev Q! q!')
cmd('cnoreabbrev Qall! qall!')
cmd('cnoreabbrev Wq wq')
cmd('cnoreabbrev Wa wa')
cmd('cnoreabbrev wQ wq')
cmd('cnoreabbrev WQ wq')
cmd('cnoreabbrev W w')
cmd('cnoreabbrev Q q')
cmd('cnoreabbrev Qall qall')

-- Search mappings: These will make it so that going to the next one in a
-- search will center on the line it's found in.
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

-- splitting
map('n', '<leader>sp', ':<C-u>split<CR>')
map('n', '<leader>v', ':<C-u>vsplit<CR>')
-- pbcopy for OSX copy/paste
map('v', '<C-x>', ':!pbcopy<CR>')
map('v', '<C-c>',  ':w !pbcopy<CR><CR>')

-- buffer movement
map('n', '<leader>q', ':bp<CR>')
map('n', '<leader>w', ':bn<CR>')
map('n', '<leader>x', ':bd<CR>')

-- clear search highlights
map('n', '<silent> <leader><space>', ':noh<cr>')

-- window switching
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')
map('n', '<C-h>', '<C-w>h')

-- maintain selection while indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

cmd('nmap ; :')

--[[ may not be necessary depending on if I use nerdtree
map('n', '<leader>nt', ':NERDTreeToggle<CR>')
map('n', '<leader>nf', ':NERDTreeFind %<CR>')
map('n', '<leader>p', ':FZF<CR>')
map('n', '<leader>P', ':FZF!<CR>')
]]


-- easy search/replace
map('n', '<leader>sr', ':%s//gc<left><left><left>')

map('n', '<leader>ln', ':try<bar>lnext<bar>catch /^Vim\\%((\\a\\+)\\)\\=:E\\%(553\\<bar>42\\):/<bar>lfirst<bar>endtry<cr>')
map('n', '<leader>lc', ':lclose<cr>')
map('n', '<leader>lo', ':lopen<cr>')

--[[ css colors
map('n', '<leader>ch', ':ColorHighlight<cr>')
map('n', '<leader>cc', ':ColorClear<cr>')
]]

-- sort object keys
map('n', '<leader>sk', '[{lv]}k:sort i<cr>')



