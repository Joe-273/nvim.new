return {
	'stevearc/conform.nvim',
	event = { 'BufWritePre' },
	cmd = { 'ConformInfo' },
	config = function()
		require('kaiho.plugins.conform.setup')
	end,
}
