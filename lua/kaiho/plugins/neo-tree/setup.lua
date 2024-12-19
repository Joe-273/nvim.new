local icons = require('kaiho.helper.icons')

local function neo_tree_buffer_enter_handler()
	-- Disable the foldcolumn in neotree
	local ok, ufo = pcall(require, 'ufo')
	if ok then
		ufo.detach()
	end
	vim.opt_local.foldenable = false
	vim.opt_local.foldcolumn = '0'
end

require('neo-tree').setup({
	-- close_if_last_window = true,
	-- hide_root_node = true,
	use_libuv_file_watcher = true,
	popup_border_style = 'rounded',
	default_component_configs = {
		indent = {
			with_expanders = true,
			last_indent_marker = '╰╴',
			expander_collapsed = icons.fold_sign.close,
			expander_expanded = icons.fold_sign.open,
		},
		modified = {
			symbol = '',
		},
		git_status = {
			symbols = {
				-- Change type
				added = 'A', -- or "✚",
				modified = 'M', -- or ""
				deleted = 'D', -- only used in the git_status source
				renamed = '󰁕', -- only used in the git_status source
				-- Status type
				untracked = 'U',
				ignored = '',
				unstaged = '󰄱',
				staged = '',
				conflict = '',
			},
		},
	},
	window = {
		position = 'left',
		width = 35,
		show_line_numbers = false,
		mapping_options = {
			noremap = true,
			nowait = true,
		},
		mappings = {
			['h'] = 'close_node',
			['l'] = 'open',
			['Z'] = 'expand_all_nodes',
			['<Space>'] = false,
		},
	},
	filesystem = {
		filtered_items = {
			hide_by_name = {
				'node_modules',
			},
		},
	},
	event_handlers = {
		{
			event = 'neo_tree_buffer_enter',
			handler = neo_tree_buffer_enter_handler,
		},
	},
})
