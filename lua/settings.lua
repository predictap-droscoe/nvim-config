local fn = vim.fn
local opt = vim.opt
local cmd = vim.cmd

cmd([[colorscheme jellybeans]])

-- Copy/Paste/Cut
cmd([[if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif
]])

-- confirm instead of erroring when exiting after not viewing all opened files
opt.confirm = true

-- Enable invisible characters
opt.listchars = {space = "·", tab = ">-"}
opt.list = true

-- disable swap files
opt.swapfile = false

-- write files as they are, don't mess with line endings etc.
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.fileencodings = {"utf-8"}
opt.bomb = true
opt.binary = true

opt.hlsearch = true -- highlight search
opt.cursorline = true --highlight the current line

opt.hidden = true -- don't complain when hiding unedited files
opt.fileformats = {"unix", "dos", "mac"}

-- TODO do I need syntax on?

-- some visuals
opt.ruler = true
opt.number = true
opt.mousemodel = "popup"
-- opt.t_Co = 256
opt.laststatus = 2

-- TODO what does this do again?
opt.modeline = true
opt.modelines = 10

opt.title = true
opt.titleold = "Terminal"
opt.titlestring = "%F"

opt.statusline = "%F%m%r%h%w%=(%{&ff}/%Y) (line %l/%L, col %c) "

-- Make search case insensitive, but become sensitive if an upper case
-- character is used.
opt.ignorecase = true
opt.smartcase = true
opt.spelllang = "en_us"
opt.spellfile = fn.stdpath("config") .. "/spell/en.utf-8.add"

opt.undofile = true
opt.undodir = fn.stdpath("config") .. "/undo"

cmd(
  [[
set termguicolors
let g:Hexokinase_optInPatterns = ['full_hex','triple_hex','rgb','rgba','hsl','hsla','colour_names']
]]
)
-- cmd("highlight ExtraWhitespace ctermbg=red guibg=red")
-- cmd("match ExtraWhitespace /\\s\\+$/")
-- cmd("autocmd TermEnter * highlight ExtraWhitespace none")
-- cmd("autocmd TermLeave * highlight ExtraWhitespace ctermbg=red guibg=red")

opt.mouse = "a"
for i, c in ipairs({"<", ">", "h", "l", "[", "]"}) do
  opt.whichwrap:append(c)
end

-- tabstuff
opt.tabstop = 2
opt.shiftwidth = 0
opt.expandtab = true

-- TODO determine if these can be done more natively
cmd(
  [[
filetype on
filetype plugin on
filetype indent on


au BufNewFile,BufRead *.markdown,*.mdown,*.mkd,*.mkdn,*.mdwn,*.md  set ft=markdown
]]
)
-- autocmd FileType make set noexpandtab tabstop=8 shiftwidth=8 softtabstop=0

-- find/replace previews
opt.inccommand = "split"

opt.autoread = true
