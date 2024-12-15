return {
	'Bekaboo/dropbar.nvim',
	event = 'VeryLazy',
	dependencies = {
		'nvim-telescope/telescope-fzf-native.nvim',
	},
	config = function()
		require('kaiho.plugins.dropbar.setup')
	end,
}
