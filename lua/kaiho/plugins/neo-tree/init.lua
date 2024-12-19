return {
	'nvim-neo-tree/neo-tree.nvim',
	branch = 'v3.x',
	dependencies = {
		'MunifTanjim/nui.nvim',
		'nvim-lua/plenary.nvim',
		'nvim-tree/nvim-web-devicons',
		'antosha417/nvim-lsp-file-operations',
	},
	keys = {
		{ '<C-e>', '<CMD>Neotree toggle<CR>', desc = 'Toggle: explore', mode = { 'n', 't' } },
		{
			'<leader>e',
			'<CMD>Neotree filesystem reveal_force_cwd toggle<CR>',
			desc = 'Toggle: [e]xplore to CWD',
			mode = { 'n', 't' },
		},
	},
	config = function()
		require('kaiho.plugins.neo-tree.setup')
		-- Initialize ufo plugin when opening neotree
		require('ufo').setup()
		require('lsp-file-operations').setup()
	end,
}
