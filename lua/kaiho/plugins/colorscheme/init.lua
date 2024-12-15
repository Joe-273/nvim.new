-- TODO: 设置主题配置
return {
	{
		'folke/tokyonight.nvim',
		priority = 1000,
		config = function()
			vim.cmd.colorscheme('tokyonight')
		end,
	},
	{
		'catppuccin/nvim',
		priority = 1000,
		name = 'catppuccin',
		config = function()
			-- vim.cmd.colorscheme('catppuccin-macchiato')
		end,
	},
}
