---@diagnostic disable: missing-fields

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
			filter = {
				event = 'notify',
				find = 'Translate',
			},
			opts = { skip = true },
		},
	},
	format = {
		details = {
			'{level} ',
			'{date} ',
			'{title} ',
			'{cmdline} ',
			'{message}',
		},
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

-- Set winfixbuf & statuscolumn & foldcolumn to the noice window
vim.api.nvim_create_autocmd('BufWinEnter', {
	group = vim.api.nvim_create_augroup('IrreplaceableWindows', { clear = true }),
	pattern = '*',
	callback = function()
		local filetypes = { 'noice' }
		local buftypes = { 'nofile' }
		if vim.tbl_contains(buftypes, vim.bo.buftype) and vim.tbl_contains(filetypes, vim.bo.filetype) then
			vim.cmd('set winfixbuf')
			vim.cmd('setlocal statuscolumn=')
			vim.opt_local.foldenable = false
			vim.opt_local.foldcolumn = '0'
		end
	end,
})
