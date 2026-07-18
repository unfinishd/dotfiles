vim.opt.termguicolors = true
vim.g.have_nerd_font = true
vim.opt.mouse = 'a'

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.signcolumn = 'yes'
vim.opt.colorcolumn = '100'
vim.opt.showmatch = true

vim.o.splitright = true
vim.o.splitbelow = true

vim.opt.undofile = true
vim.opt.clipboard:append('unnamedplus')

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.inccommand = 'split' -- preview substitutions live