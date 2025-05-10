vim.o.tabstop=2 
vim.o.softtabstop=4
vim.o.shiftwidth=2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.number = true
vim.o.numberwidth=5
vim.o.relativenumber = true
vim.o.signcolumn=yes
vim.opt.swapfile = false
vim.o.backup = false
vim.o.undodir="$HOME/.config/nvim/undodir"
vim.o.undofile = true
vim.o.incsearch = true
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wrap = false
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.hidden = true
vim.o.scrolloff=999
vim.o.showmode = false
vim.o.updatetime=250 
vim.o.encoding="UTF-8"
vim.o.mouse=a

require('packer.plugins')

--  custom keybinds
vim.keymap.set('n', '<C-z>', ':UndotreeToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-b>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-p>', ':CtrlP<CR>', { noremap = true, silent = true })

vim.keymap.set('v', '//', '<plug>NERDCommenterToggle', { noremap = true, silent = true })
vim.keymap.set('n', '//', '<plug>NERDCommenterToggle', { noremap = true, silent = true })

-- vim.keymap.set("i", "<CR>", function()
--   return vim.fn["coc#pum#visible"]() == 1 and vim.fn["coc#pum#confirm"]() or "\r"
-- end, { expr = true, silent = true })

-- lazygit
vim.keymap.set('n', '<C-g>', ':LazyGit<CR>', { noremap = true, silent = true })
-- telescope
vim.keymap.set('n', '<C-f>', ':Telescope find_file<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-d>', ':Telescope live_grep<CR>', { noremap = true, silent = true })