return {
	'akinsho/toggleterm.nvim',
	event = 'VeryLazy',
	version = '*',
	config = function()
		require('kaiho.plugins.toggleterm.setup')
		require('kaiho.plugins.toggleterm.keymaps')
	end,
}
