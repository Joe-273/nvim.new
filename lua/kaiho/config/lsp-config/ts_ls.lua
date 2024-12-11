---@diagnostic disable: undefined-field
local function get_pkg_path(pkg, path, opts)
	pcall(require, 'mason') -- make sure Mason is loaded. Will fail when generating docs
	local root = vim.env.MASON or (vim.fn.stdpath('data') .. '/mason')
	opts = opts or {}
	opts.warn = opts.warn == nil and true or opts.warn
	path = path or ''
	local ret = root .. '/packages/' .. pkg .. '/' .. path
	if opts.warn and not vim.loop.fs_stat(ret) and not require('lazy.core.config').headless() then
		vim.notify(
			('[ts_ls.lua]: Mason package path not found for **%s**:\n- `%s`\nYou may need to force update the package.'):format(
				pkg,
				path
			),
			vim.log.levels.WARN
		)
	end
	return ret
end

local ts_ls = {
	init_options = {
		plugins = {
			{
				name = '@vue/typescript-plugin',
				location = get_pkg_path('vue-language-server', '/node_modules/@vue/language-server'),
				languages = { 'javascript', 'typescript', 'vue' },
			},
		},
		preferences = {
			includeInlayVariableTypeHints = true,
			includeInlayParameterNameHints = 'all',
			includeInlayEnumMemberValueHints = true,
			includeInlayFunctionParameterTypeHints = true,
			includeInlayFunctionLikeReturnTypeHints = true,
			includeInlayPropertyDeclarationTypeHints = true,
			includeInlayVariableTypeHintsWhenTypeMatchesName = true,
			includeInlayParameterNameHintsWhenArgumentMatchesName = true,
		},
	},
	filetypes = {
		'javascript',
		'javascriptreact',
		'javascript.jsx',
		'typescript',
		'typescriptreact',
		'typescript.tsx',
		'vue',
	},
}

return ts_ls
