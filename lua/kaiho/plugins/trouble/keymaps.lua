local utils = require('kaiho.helper.utils')

local opts = { noremap = true, silent = true }
local group_map = utils.group_map

local function runCmd(cmd, filetypes)
	filetypes = filetypes or nil
	filetypes = (filetypes ~= nil and type(filetypes) == 'string') and { filetypes } or filetypes
	return function()
		if filetypes then
			for _, filetype in pairs(filetypes) do
				if vim.bo.filetype == filetype then
					return
				end
			end
		end
		vim.cmd(cmd)
	end
end

local outline_document_symbol =
	'Trouble lsp_document_symbols toggle pinned=true win={relative=win,position=right,size=35}'
local outline_buffer_diagnostics = 'Trouble diagnostics toggle focus=true size=20 filter.buf=0'
local outline_workspace_diagnostics = 'Trouble workspace_diagnostics toggle focus=true size=20'
group_map('Outline', {
	{ 'n', '<leader>os', runCmd(outline_document_symbol, 'neo-tree'), 'document [s]ymbols', opts },
	{ 'n', '<leader>od', runCmd(outline_buffer_diagnostics), 'buffer [d]iagnostics', opts },
	{ 'n', '<leader>oD', runCmd(outline_workspace_diagnostics), 'workspace [D]iagnostics', opts },
})
