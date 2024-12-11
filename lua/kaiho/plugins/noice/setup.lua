---@diagnostic disable: missing-fields
local utils = require('kaiho.helper.utils')

local function toggle_noice()
	-- set noice flag
	local noice_opened = false
	local noice_win_id = nil

	-- Check if the noice window is open
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local win_config = vim.api.nvim_win_get_config(win)

		if vim.bo[buf].filetype == 'noice' and vim.bo[buf].buftype == 'nofile' then
			if win_config.anchor == nil and win_config.focusable then
				-- ignore float window
				noice_opened = true
				noice_win_id = win
				break
			end
		end
	end

	if noice_opened and noice_win_id then
		vim.api.nvim_win_close(noice_win_id, true)
	else
		require('noice').cmd('history')
	end
end

local function set_width(percent)
	return math.ceil(vim.o.columns * percent)
end

require('noice').setup({
	views = {
		cmdline_popup = { position = { row = 15, col = '50%' } },
		mini = {
			size = { max_width = set_width(0.8) },
			border = { style = 'rounded' },
			position = { row = -2 },
			win_options = { winblend = 0 },
		},
		hover = {
			border = { style = 'rounded' },
			position = { row = 2, col = 2 },
			size = { max_width = set_width(0.8) },
		},
	},
	lsp = {
		override = {
			-- override the default lsp markdown formatter with Noice
			['vim.lsp.util.convert_input_to_markdown_lines'] = true,
			-- override the lsp markdown formatter with Noice
			['vim.lsp.util.stylize_markdown'] = true,
			-- override cmp documentation with Noice (needs the other options to work)
			['cmp.entry.get_documentation'] = true,
		},
	},
	routes = {
		{
			view = 'notify',
			filter = { event = 'msg_showmode' },
		},
		{
			filter = { event = 'msg_show', min_height = 20 },
			view = 'cmdline_output',
		},
		{
			filter = { event = 'msg_show', kind = '', find = 'written' },
			opts = { skip = true },
		},
	},
	format = {
		lsp_progress = {
			'({data.progress.percentage}%) ',
			{ '{spinner} ', hl_group = 'NoiceLspProgressSpinner' },
			{ '{data.progress.title} ', hl_group = 'NoiceLspProgressTitle' },
			{ '{data.progress.client} ', hl_group = 'NoiceLspProgressClient' },
		},
		lsp_progress_done = {
			{ '✨ ', hl_group = 'NoiceLspProgressSpinner' },
			{ '{data.progress.title} ', hl_group = 'NoiceLspProgressTitle' },
			{ '{data.progress.client} ', hl_group = 'NoiceLspProgressClient' },
		},
	},
})

utils.map('n', '<leader>n', toggle_noice, 'Toggle: [n]oice history', { noremap = true, silent = true })
