return {
	'stevearc/conform.nvim',
	event = { 'BufWritePre' },
	cmd = { 'ConformInfo' },
	dependencies = {
		'WhoIsSethDaniel/mason-tool-installer.nvim',
	},
	config = function()
		require('kaiho.plugins.conform.setup')
	end,
}
