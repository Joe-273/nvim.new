-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = false

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Set indent
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Enable soft line wrap
vim.opt.wrap = true

-- Create a backup file
vim.opt.backup = false

-- Enables 24-bit RGB color in the TUI.
vim.opt.termguicolors = true

-- Enable mouse mode, can be useful for resizing splits for example
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Use system clipboard:
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Disable completion
vim.opt.completeopt = 'noselect'

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Auto refresh buffer content when file is changed
vim.opt.autoread = true

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time, displays which-key popup sooner
vim.opt.timeoutlen = 250

-- Preview substitutions live, as you type
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Only one statusline
vim.opt.laststatus = 2

vim.opt.shortmess:append('c')
vim.opt.shortmess:append('C')
