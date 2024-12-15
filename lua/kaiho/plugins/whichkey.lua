return {
	'folke/which-key.nvim',
	event = 'VeryLazy',
	opts = {
		preset = 'helix',
		-- Document existing key chains
		win = {
			title_pos = 'center',
		},
		spec = {
			{ '<leader>f', group = '[f]ind' },
			{ '<leader>g', group = '[g]it' },
			{ '<leader>h', group = '[h]unk' },
			{ '<leader>l', group = '[l]sp' },
			{ '<leader>p', group = '[p]ick' },
			{ '<leader>o', group = '[o]utline' },
			{ '<leader>t', group = '[t]oggle' },
		},
	},
}
