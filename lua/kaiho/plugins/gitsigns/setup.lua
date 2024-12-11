require('gitsigns').setup({
	signs = {
		delete = { text = '' },
		topdelete = { text = '' },
		changedelete = { text = '┃' },
	},
	signs_staged = {
		delete = { text = '' },
		topdelete = { text = '' },
		changedelete = { text = '┃' },
	},
	preview_config = {
		-- Options passed to nvim_open_win
		border = 'rounded',
	},
	on_attach = function()
		require('kaiho.plugins.gitsigns.keymaps')
	end,
})
