vim.opt.fileencoding = 'utf-8'
vim.opt.swapfile = false
vim.opt.helplang = 'ja'
vim.opt.hidden = true

-- vim.opt.ttimeout = true;
-- vim.opt.ttimeoutlen = 50;

vim.opt.clipboard:append({ 'unnamedplus' })

vim.opt.wildmenu = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.showcmd = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.matchtime = 1

vim.opt.termguicolors = true
vim.opt.background = 'dark'
vim.opt.fillchars = 'vert:▎,fold:·'

vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
-- vim.opt.autoindent = true
-- vim.opt.smartindent = true
-- vim.opt.cindent = true

vim.opt.number = true
vim.opt.wrap = false
vim.opt.showtabline = 2
vim.opt.visualbell = true
vim.opt.showmatch = true
vim.opt.list = true
vim.opt.listchars = {tab='»-', trail='*', nbsp='+'}
-- vim.opt.listchars = {tab='>-', trail='*', nbsp='+'}
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"

vim.opt.winblend = 20
vim.opt.pumblend = 20
vim.opt.signcolumn = 'yes'

vim.keymap.set('i', 'jj', '<esc>')
