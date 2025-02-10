return {
	'nvim-telescope/telescope.nvim',
	event = 'VeryLazy',
	branch = '0.1.x',
	dependencies = {
		'nvim-lua/popup.nvim',
		'nvim-lua/plenary.nvim',
		'nvim-tree/nvim-web-devicons',
		'nvim-telescope/telescope-ui-select.nvim',
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			build = 'make',
			cond = function()
				return vim.fn.executable('make') == 1
			end,
		},
	},
	config = function()
		require('kaiho.plugins.telescope.setup')
		require('kaiho.plugins.telescope.keymaps')
	end,
}
