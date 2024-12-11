return {
	-- [[ Cmp plugin & sources ]]
	'hrsh7th/nvim-cmp',
	lazy = 'VeryLazy',
	event = 'InsertEnter',
	dependencies = {
		'onsails/lspkind.nvim',
		'David-Kunz/cmp-npm',
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-path',
		{ 'hrsh7th/cmp-cmdline', keys = { ':', '/', '?' } },
		{
			'folke/lazydev.nvim',
			ft = 'lua', -- only load on lua files
			opts = {
				library = {
					{ path = '${3rd}/luv/library', words = { 'vim%.uv' } },
					{ path = 'wezterm-types', mods = { 'wezterm' } },
				},
			},
		},
		{
			-- [[ Snippets plugins ]]
			'L3MON4D3/LuaSnip',
			dependencies = {
				'saadparwaiz1/cmp_luasnip',
				'rafamadriz/friendly-snippets',
			},
		},
	},
	config = function()
		require('kaiho.plugins.cmp.setup')
		require('kaiho.plugins.cmp.cmdline-setup')
	end,
}
