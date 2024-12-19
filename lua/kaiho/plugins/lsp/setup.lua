---@diagnostic disable: missing-fields
-- Init Lsp keymaps & diagnostic
require('kaiho.plugins.lsp.handlers.setup')

-- Merge default_capabilities & cmp_nvim_lsp_capabilities
local capabilities = vim.tbl_deep_extend(
	'force',
	vim.lsp.protocol.make_client_capabilities(),
	require('cmp_nvim_lsp').default_capabilities()
)
-- for ufo plugin
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}

-- local lsp_server = lsp_servers.get_lsp_config()
local lsp_server = require('kaiho.config.lsp-servers')

-- Setup mason
require('mason').setup({ ui = { border = 'rounded' } })

require('mason-lspconfig').setup({
	handlers = {
		function(server_name)
			local server = lsp_server[server_name] or {}
			-- Merge personal_capabilities & lspconfig_capabilities
			server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
			require('lspconfig')[server_name].setup(server)
		end,
	},
})

-- Auto install laps/formaters/linters
vim.cmd('MasonToolsInstall')
