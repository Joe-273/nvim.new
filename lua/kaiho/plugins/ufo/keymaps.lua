local ufo = require('ufo')

local utils = require('kaiho.helper.utils')

local opts = { noremap = true, silent = true }
local group_map = utils.group_map

local function preview_folding_line()
	local winid = ufo.peekFoldedLinesUnderCursor()
	if not winid then
		vim.lsp.buf.hover()
	end
end

group_map('Folds', {
	{ 'n', 'zR', ufo.openAllFolds, 'Expand all', opts },
	{ 'n', 'zr', ufo.openFoldsExceptKinds, 'Expand all except kinds', opts },
	{ 'n', 'zM', ufo.closeAllFolds, 'Close all', opts },
	{ 'n', 'K', preview_folding_line, 'Preview line', opts },
})
