return {
	'rebelot/heirline.nvim',
	event = 'VeryLazy',
	config = function()
		require('heirline').setup({
			statusline = require('kaiho.plugins.heirline.statusline'),
		})
	end,
}
