return {
	'kevinhwang91/nvim-ufo',
	event = 'BufReadPost',
	dependencies = {
		'luukvbaal/statuscol.nvim',
		'kevinhwang91/promise-async',
	},
	config = function()
		require('kaiho.plugins.ufo.setup')
	end,
}
