local utils = require('kaiho.helper.utils')

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
