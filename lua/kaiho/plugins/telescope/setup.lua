local Actions = require('telescope.actions')

local layout_opts = require('kaiho.plugins.telescope.preference.options')

require('telescope').setup({
	defaults = {
		sorting_strategy = 'ascending',
		dynamic_preview_title = true,
		mappings = {
			i = {
				['<C-q>'] = false,
				['<C-e>'] = Actions.close,
				['<esc>'] = Actions.close,
				['<C-y>'] = Actions.select_default,
			},
			n = {
				['<C-e>'] = Actions.close,
				['<C-q>'] = false,
			},
		},
		prompt_prefix = ' ',
		entry_prefix = '  ',
		selection_caret = '➤ ',
		layout_config = {
			horizontal = {
				prompt_position = 'top',
				preview_cutoff = layout_opts.preview_limit,
				preview_width = layout_opts.preview_width,
			},
			width = layout_opts.width,
			height = layout_opts.height,
		},
	},
	-- pickers = {},
	extensions = {
		['ui-select'] = {
			require('telescope.themes').get_dropdown(),
		},
	},
})

-- Enable Telescope extensions if they are installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')
-- Set keymaps
require('kaiho.plugins.telescope.keymaps')
