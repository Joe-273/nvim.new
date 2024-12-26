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
vim.api.nvim_create_autocmd('ColorScheme', {
	group = vim.api.nvim_create_augroup('SetupHighlight', { clear = true }),
	callback = function()
		require('kaiho.helper.highlight').setup_hl()

		require('lazy').reload({ plugins = { 'heirline.nvim' } })
	end,
})

-- Remove auto comment
vim.api.nvim_create_autocmd('BufEnter', {
	group = vim.api.nvim_create_augroup('RemoveAutoComment', { clear = true }),
	pattern = '*',
	callback = function()
		vim.opt.formatoptions:remove({ 'o', 'r' })
	end,
})

-- Auto switch input methods
vim.api.nvim_create_augroup('InputMethodSelect', { clear = true })
vim.api.nvim_create_autocmd('InsertEnter', {
	group = 'InputMethodSelect',
	callback = function()
		require('kaiho.helper.auto-im').restore_prev_im()
	end,
})
vim.api.nvim_create_autocmd({ 'InsertLeave', 'FocusGained' }, {
	group = 'InputMethodSelect',
	callback = function()
		require('kaiho.helper.auto-im').switch_default_im()
	end,
})
