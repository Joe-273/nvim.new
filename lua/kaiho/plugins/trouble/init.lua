return {
	'folke/trouble.nvim',
	event = { 'BufReadPre', 'BufNewFile' },
	config = function()
		require('kaiho.plugins.trouble.setup')
	end,
}
