return {
	'nvim-treesitter/nvim-treesitter',
	event = { 'BufReadPre', 'BufNewFile' },
	build = ':TSUpdate',
	main = 'nvim-treesitter.configs',
	config = function()
		require('kaiho.plugins.treesitter.setup')
	end,
}
