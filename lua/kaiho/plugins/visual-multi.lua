return {
	'mg979/vim-visual-multi',
	lazy = true,
	keys = { { '<C-n>', mode = { 'n', 'x' } } },
	config = function()
		vim.g.VM_maps = vim.g.VM_maps or {}
		vim.g.VM_maps['Undo'] = 'u'
		vim.g.VM_maps['Redo'] = '<C-r>'
	end,
}
