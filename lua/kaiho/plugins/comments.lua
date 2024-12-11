local utils = require('kaiho.helper.utils')

return {
	{
		'folke/todo-comments.nvim',
		event = 'VeryLazy',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			utils.map('n', '<leader>ft', '<CMD>TodoTelescope<CR>', 'Find [t]odo')
			require('todo-comments').setup({ signs = false })
		end,
	},
	{
		'numToStr/Comment.nvim',
		event = 'VeryLazy',
		opts = {},
	},
}
