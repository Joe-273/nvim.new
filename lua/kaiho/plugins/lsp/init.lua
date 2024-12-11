return {
	'WhoIsSethDaniel/mason-tool-installer.nvim',
	event = 'VeryLazy',
	dependencies = {
		'neovim/nvim-lspconfig',
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'hrsh7th/cmp-nvim-lsp',
	},
	config = function()
		require('kaiho.plugins.lsp.setup')
	end,
}
