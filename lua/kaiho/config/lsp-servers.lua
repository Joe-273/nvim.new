local lsps = {
	'lua_ls',
	'html',
	'cssls',
	'emmet_ls',
	'ts_ls',
	'volar',
	'jsonls',
}
local formatters = {
	'prettierd',
	'stylua',
}
local linters = {}

local ensure_installed = vim.list_extend(vim.list_extend({}, lsps), formatters)
ensure_installed = vim.list_extend(ensure_installed, linters)
require('mason-tool-installer').setup({
	ensure_installed = ensure_installed,
	run_on_start = false,
})

local function get_lsp_config()
	local lsps_tbl = {}
	for _, lsp_name in pairs(lsps) do
		local ok, lsp_config = pcall(require, 'kaiho.config.lsp-config.' .. lsp_name)
		if not ok then
			lsp_config = {}
		end
		lsps_tbl[lsp_name] = lsp_config
	end
	return lsps_tbl
end

return get_lsp_config()
