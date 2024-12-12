return {
	{
		'folke/tokyonight.nvim',
		priority = 1000,
		config = function()
			-- vim.cmd.colorscheme('tokyonight')
		end,
	},
	{
		'catppuccin/nvim',
		priority = 1000,
		name = 'catppuccin',
		config = function()
			vim.cmd.colorscheme('catppuccin-frappe')
		end,
	},
}
