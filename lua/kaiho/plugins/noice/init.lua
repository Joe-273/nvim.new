return {
	'folke/noice.nvim',
	event = 'VeryLazy',
	dependencies = {
		'MunifTanjim/nui.nvim',
	},
	config = function()
		require('kaiho.plugins.noice.setup')
	end,
}
