local builtin = require('statuscol.builtin')

local icons = require('kaiho.helper.icons')

vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:]]
	.. icons.fold_sign.open
	.. [[,foldsep: ,foldclose:]]
	.. icons.fold_sign.close

local function handler(virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}
	local suffix = ('   %d lines'):format(endLnum - lnum)
	local sufWidth = vim.fn.strdisplaywidth(suffix)
	local targetWidth = width - sufWidth
	local curWidth = 0
	for _, chunk in ipairs(virtText) do
		local chunkText = chunk[1]
		local chunkWidth = vim.fn.strdisplaywidth(chunkText)
		if targetWidth > curWidth + chunkWidth then
			table.insert(newVirtText, chunk)
		else
			chunkText = truncate(chunkText, targetWidth - curWidth)
			local hlGroup = chunk[2]
			table.insert(newVirtText, { chunkText, hlGroup })
			chunkWidth = vim.fn.strdisplaywidth(chunkText)
			-- str width returned from truncate() may less than 2nd argument, need padding
			if curWidth + chunkWidth < targetWidth then
				suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
			end
			break
		end
		curWidth = curWidth + chunkWidth
	end
	table.insert(newVirtText, { suffix, 'MoreMsg' })
	return newVirtText
end

require('statuscol').setup({
	ft_ignore = { 'neo-tree', 'terminal', 'toggleterm', 'trouble', 'nioce' },
	relculright = true,
	segments = {
		{
			sign = { namespace = { 'gitsigns' }, colwidth = 1, fillchar = ' ' },
			click = 'v:lua.ScSa',
		},
		{
			sign = { namespace = { 'diagnostic' }, fillchar = ' ' },
			click = 'v:lua.ScSa',
		},
		{ text = { builtin.lnumfunc }, click = 'v:lua.ScLa' },
		{ text = { ' ', builtin.foldfunc, ' ' }, click = 'v:lua.ScFa' },
	},
})

require('ufo').setup({
	fold_virt_text_handler = handler,
	enable_get_fold_virt_text = true,
	open_fold_hl_timeout = 400,
	close_fold_kinds_for_ft = {
		default = { 'imports', 'comment' },
	},
	preview = {
		win_config = {
			winblend = 0,
		},
		mappings = {
			scrollU = '<C-u>',
			scrollD = '<C-d>',
		},
	},
	provider_selector = function()
		return { 'treesitter', 'indent' }
	end,
})

require('kaiho.plugins.ufo.keymaps')
