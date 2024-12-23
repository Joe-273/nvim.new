return {
	'folke/flash.nvim',
	event = 'VeryLazy',
	config = function()
		local Flash = require('flash')
		local utils = require('kaiho.helper.utils')
		local opts = { noremap = true, silent = true }
		utils.group_map('Flash', {
			{ { 'n', 'x', 'o' }, '<C-s>', Flash.jump, 'Pick Words', opts },
			{ { 'n', 'x', 'o' }, 'S', Flash.treesitter, 'Treesitter', opts },
			{ { 'o' }, 's', Flash.remote, 'Remote', opts },
		})
		Flash.setup()
	end,
}
