vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('LspAttach', { clear = true }),
	callback = function(event)
		local Pickers = require('kaiho.plugins.telescope.preference.pickers')
		local utils = require('kaiho.helper.utils')

		local opts = { noremap = true, silent = true, buffer = event.buf }
		local group_map = utils.group_map

		group_map('Goto', {
			{ 'n', 'gd', Pickers.lsp_definitions, '[d]efinition', opts }, -- Definition
			{ 'n', 'gr', Pickers.lsp_references, '[r]eferences', opts }, -- Reference
			{ 'n', 'gI', Pickers.lsp_implementations, '[I]mplementation', opts }, -- Implementation
			{ 'n', 'gD', vim.lsp.buf.declaration, '[D]eclaration', opts }, -- Declaration.
			{ 'n', 'gt', Pickers.lsp_type_definitions, '[t]ype Definition', opts }, -- Type definition
		})
		group_map('LSP', {
			{ 'n', '<leader>lf', vim.lsp.buf.format, '[f]ormat', opts }, -- Format
			{ 'n', '<leader>lr', vim.lsp.buf.rename, '[r]ename', opts }, -- Rename
			{ 'n', '<leader>ls', vim.lsp.buf.signature_help, '[s]ignature help', opts }, -- Format
			{ 'n', '<leader>ld', vim.diagnostic.open_float, '[d]ianostic', opts }, -- Diagnostic
			{ { 'n', 'x' }, '<leader>la', vim.lsp.buf.code_action, 'code [a]ction', opts }, -- Code action
		})
		group_map('Find', {
			{ 'n', '<leader>fs', Pickers.lsp_document_symbols, '[s]ymbols of Document', opts }, -- Document symbol
			{ 'n', '<leader>fS', Pickers.lsp_dynamic_workspace_symbols, '[S]ymbols of Workspace ', opts }, -- Workspace symbol
		})

		local client = vim.lsp.get_client_by_id(event.data.client_id)

		-- LSP hover highlight
		if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
			local highlight_augroup = vim.api.nvim_create_augroup('LspHighlight', { clear = false })
			vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd('LspDetach', {
				group = vim.api.nvim_create_augroup('LspDetach', { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = 'LspHighlight', buffer = event2.buf })
				end,
			})
		end

		-- Toggle inlay hints
		local toggle_inlay_hint =
			utils.build_func(vim.lsp.inlay_hint.enable, (not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })))
		if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
			utils.map('n', '<leader>th', toggle_inlay_hint, 'Toggle: inlay [h]ints')
		end
	end,
})
