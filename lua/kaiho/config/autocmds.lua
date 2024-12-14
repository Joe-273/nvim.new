-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('HighlightYank', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Restore cursor position
vim.api.nvim_create_autocmd('BufReadPost', {
	pattern = '*',
	callback = function()
		vim.cmd('silent! normal! g`"zv')
	end,
})

-- Fix colors when switching themes
local hl = require('kaiho.helper.highlight')
vim.api.nvim_create_autocmd({ 'ColorScheme', 'VimEnter' }, {
	callback = function()
		hl.setup_hlgroup()
		require('lazy').reload({ plugins = { 'heirline.nvim' } })
	end,
})
