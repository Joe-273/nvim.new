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

-- Disable statuscolumn & foldcolumn in noice window
vim.api.nvim_create_autocmd('BufWinEnter', {
	pattern = '*',
	callback = function()
		local filetypes = { 'noice' }
		local buftypes = { 'nofile' }
		if vim.tbl_contains(buftypes, vim.bo.buftype) and vim.tbl_contains(filetypes, vim.bo.filetype) then
			vim.cmd('setlocal statuscolumn=')
			vim.opt_local.foldenable = false
			vim.opt_local.foldcolumn = '0'
		end
	end,
})
