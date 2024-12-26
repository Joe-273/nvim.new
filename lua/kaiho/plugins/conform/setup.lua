require('conform').setup({
	format_on_save = function(bufnr)
		local disable_filetypes = { c = true, cpp = true }
		local lsp_format_opt
		if disable_filetypes[vim.bo[bufnr].filetype] then
			lsp_format_opt = 'never'
		else
			lsp_format_opt = 'fallback'
		end
		return {
			timeout_ms = 500,
			lsp_format = lsp_format_opt,
		}
	end,
	notify_no_formatters = true,
	notify_on_error = true,

	formatters_by_ft = {
		javascript = { 'prettierd' },
		typescript = { 'prettierd' },
		javascriptreact = { 'prettierd' },
		typescriptreact = { 'prettierd' },
		css = { 'prettierd' },
		html = { 'prettierd' },
		json = { 'prettierd' },
		yaml = { 'prettierd' },
		markdown = { 'prettierd' },
		lua = { 'stylua' },
		zsh = { 'shfmt' },
		bash = { 'shfmt' },
	},

	formatters = {
		prettierd = {
			require_cwd = true,
		},
	},
})
