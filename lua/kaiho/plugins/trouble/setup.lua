local icons = require('kaiho.helper.icons')

-- Helper functions
local function add_padding(t)
	local nt = {}
	for k, v in pairs(t) do
		nt[k] = v .. ' '
	end
	return nt
end
local function is_trouble_window(win)
	local bufnr = vim.api.nvim_win_get_buf(win)
	return vim.bo[bufnr].filetype == 'trouble'
end
local function is_relative_window(win)
	local win_config = vim.api.nvim_win_get_config(win)
	return not win_config.split and win_config.relative and win_config.relative == 'editor' and win_config.anchor == 'NW'
end

require('trouble').setup({
	modes = {
		lsp_document_symbols = {
			format = '{kind_icon}{symbol.name}',
		},
		workspace_diagnostics = {
			mode = 'diagnostics',
			preview = {
				type = 'float',
				relative = 'editor',
				border = 'rounded',
				title = '[Preview]',
				title_pos = 'center',
				position = { 2, -2 },
				size = { width = 0.6, height = 0.3 },
				zindex = 200,
			},
		},
	},
	icons = {
		indent = {
			last = '╰╴',
			fold_open = ' ',
			fold_closed = ' ',
		},
		kinds = add_padding(icons.kind_icons),
	},
})

-- Change trouble preview window
vim.api.nvim_create_autocmd('BufWinEnter', {
	callback = function()
		local wins = vim.api.nvim_tabpage_list_wins(0)
		for _, win in ipairs(wins) do
			if is_trouble_window(win) and is_relative_window(win) then
				-- Run async
				vim.defer_fn(function()
					vim.api.nvim_set_option_value('winhighlight', 'Normal:Normal', { win = win })
					vim.api.nvim_set_option_value('foldcolumn', '0', { win = win })
				end, 0)
			end
		end
	end,
})
