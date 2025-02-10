return {
	'uga-rosa/translate.nvim',
	keys = require('kaiho.plugins.translate.keymaps'),
	config = function()
		require('kaiho.plugins.translate.setup')
	end,
}
