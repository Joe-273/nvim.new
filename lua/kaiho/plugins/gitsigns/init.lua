return {
	'lewis6991/gitsigns.nvim',
	event = 'VeryLazy',
	config = function()
		require('kaiho.plugins.gitsigns.setup')
	end,
}
