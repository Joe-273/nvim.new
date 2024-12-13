return {
	'rebelot/heirline.nvim',
	event = 'VeryLazy',
	config = function()
		local statusline_creator = require('kaiho.plugins.heirline.statusline')
		local tabline_creator = require('kaiho.plugins.heirline.tabline')
		require('heirline').setup({
			statusline = statusline_creator(),
			tabline = tabline_creator(),
		})
	end,
}
