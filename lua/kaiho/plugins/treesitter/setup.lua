---@diagnostic disable: missing-fields
-- ensure installed languages
local ensure_installed = {
	'bash',
	'c',
	'diff',
	'lua',
	'luadoc',
	'markdown',
	'markdown_inline',
	'query',
	'vim',
	'vimdoc',
	'regex',
	'bash',
	'python',
	'toml',

	'javascript',
	'typescript',
	'tsx',
	'vue',

	'html',
	'css',
	'scss',

	'json',
	'jsonc',
}

require('nvim-treesitter.configs').setup({
	ensure_installed = ensure_installed,
	sync_install = true,
	ignore_install = {},
	-- Autoinstall languages that are not installed
	auto_install = true,
	highlight = {
		enable = true,
		disable = {},
		additional_vim_regex_highlighting = { 'ruby' },
	},
	indent = { enable = true, disable = { 'ruby' } },
})
