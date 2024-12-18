local icons = require('kaiho.helper.icons')
local utils = require('kaiho.helper.utils')

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
local opts = { noremap = true, silent = true }
local group_map = utils.group_map

local outline_document_symbol =
	'<CMD>Trouble lsp_document_symbols toggle pinned=true win={relative=win,position=right,size=35}<CR>'
local outline_buffer_diagnostics = '<CMD>Trouble diagnostics toggle focus=true size=20 filter.buf=0<CR>'
local outline_workspace_diagnostics = '<CMD>Trouble workspace_diagnostics toggle focus=true size=20<CR>'
group_map('Outline', {
	{ 'n', '<leader>os', outline_document_symbol, 'document [s]ymbols', opts },
	{ 'n', '<leader>od', outline_buffer_diagnostics, 'buffer [d]iagnostics', opts },
	{ 'n', '<leader>oD', outline_workspace_diagnostics, 'workspace [D]iagnostics', opts },
})

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
				vim.defer_fn(function()
					vim.api.nvim_set_option_value('winhighlight', 'Normal:Normal', { win = win })
					vim.api.nvim_set_option_value('foldcolumn', '0', { win = win })
				end, 0)
			end
		end
	end,
})
