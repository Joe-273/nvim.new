return {
	'famiu/bufdelete.nvim',
	event = { 'BufReadPre', 'BufNewFile' },
	config = function()
		require('kaiho.plugins.bufdelete.keymaps')
	end,
}
