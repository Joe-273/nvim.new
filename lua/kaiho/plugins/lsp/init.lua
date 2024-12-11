return {
	'neovim/nvim-lspconfig',
	event = 'VeryLazy',
	dependencies = {
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'hrsh7th/cmp-nvim-lsp',
	},
	config = function()
		require('kaiho.plugins.lsp.setup')
	end,
}
