local cmd = vim.cmd

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.mapleader = ","

-- some command shortcuts
cmd("cnoreabbrev W! w!")
cmd("cnoreabbrev Q! q!")
cmd("cnoreabbrev Qall! qall!")
cmd("cnoreabbrev Wq wq")
cmd("cnoreabbrev Wa wa")
cmd("cnoreabbrev wQ wq")
cmd("cnoreabbrev WQ wq")
cmd("cnoreabbrev W w")
cmd("cnoreabbrev Q q")
cmd("cnoreabbrev Qall qall")

-- Search mappings: These will make it so that going to the next one in a
-- search will center on the line it's found in.
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- splitting
map("n", "<leader>sp", ":<C-u>split<CR>")
map("n", "<leader>v", ":<C-u>vsplit<CR>")
-- pbcopy for OSX copy/paste
map("v", "<C-x>", ":!pbcopy<CR>")
map("v", "<C-c>", ":w !pbcopy<CR><CR>")

-- buffer movement
map("n", "<leader>q", ":bp<CR>")
map("n", "<leader>w", ":bn<CR>")
map("n", "<leader>x", ":bd<CR>")

-- clear search highlights
map("n", "<leader><space>", ":noh<cr>", {silent = true})

-- window switching
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-h>", "<C-w>h")

-- maintain selection while indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

cmd("nmap ; :")

map("n", "<leader>nt", ":NERDTreeToggle<CR>")
map("n", "<leader>nf", ":NERDTreeFind %<CR>")

map("n", "<leader>p", ":FZF<CR>")
map("n", "<leader>P", ":FZF!<CR>")

-- easy search/replace
map("n", "<leader>sr", ":%s//gc<left><left><left>")

map(
  "n",
  "<leader>ln",
  ":try<bar>lnext<bar>catch /^Vim\\%((\\a\\+)\\)\\=:E\\%(553\\<bar>42\\):/<bar>lfirst<bar>endtry<cr>"
)
map("n", "<leader>lc", ":lclose<cr>")
map("n", "<leader>lo", ":lopen<cr>")

--[[ css colors
map('n', '<leader>ch', ':ColorHighlight<cr>')
map('n', '<leader>cc', ':ColorClear<cr>')
]]
-- sort object keys
map("n", "<leader>sk", "[{lv]}k:sort i<cr>")

-- fzf specific, consider moving to dedicated module
map("n", "<leader>ag", ":Ag<cr>")
