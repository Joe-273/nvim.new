local icons = require('kaiho.helper.icons')

vim.diagnostic.config({
	-- virtual_text = false,
	virtual_text = { spacing = 2, prefix = '󰧞' },
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = icons.diag_sign.error,
			[vim.diagnostic.severity.WARN] = icons.diag_sign.warn,
			[vim.diagnostic.severity.INFO] = icons.diag_sign.info,
			[vim.diagnostic.severity.HINT] = icons.diag_sign.hint,
		},
		linehl = {
			-- [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
			-- [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
			-- [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
			-- [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
		},
		numhl = {
			-- [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
			-- [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
			-- [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
			-- [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
		},
	},
	float = {
		border = 'rounded',
	},
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = 'rounded',
	max_width = math.ceil(vim.o.columns * 0.90),
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = 'rounded',
	max_width = math.ceil(vim.o.columns * 0.90),
})

require('kaiho.plugins.lsp.handlers.onattach')
