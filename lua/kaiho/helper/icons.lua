-- [[ Provide global icons ]]

local M = {}

M.diag_sign = {
	error = ' ',
	warn = ' ',
	info = ' ',
	hint = ' ',
}
M.edge_char = {
	left = '',
	right = '',
	-- left = '',
	-- right = '',
}

M.fold_sign = {
	open = '',
	close = '',
}

M.kind_icons = {
	String = '',
	Number = '',
	Boolean = '',
	Array = '󰅨',
	Object = '󱃖',
	Package = '󰏖',
	Null = '',
	Identifier = '',
	-- keys from lspkind
	Text = '󰉿',
	Method = '󰆧',
	Function = '󰡱',
	Constructor = '',
	Field = '',
	Variable = '',
	Class = '󰠱',
	Interface = '',
	Module = '',
	Property = '󰜢',
	Unit = '󰑭',
	Value = '󱀍',
	Enum = '',
	Keyword = '󰌋',
	Snippet = '',
	Color = '󰏘',
	File = '󰈙',
	Reference = '󰈇',
	Folder = '󰉋',
	EnumMember = '',
	Constant = '󰏿',
	Struct = '󰙅',
	Event = '',
	Operator = '󰆕',
	TypeParameter = '',
}

M.sep_chars = {
	thin_left_aligned = '▏',
	thin_right_aligned = '▕',
	thick_left_aligned = '▌',
	thick_right_aligned = '▐',
}

M.other = {
	selection = ' ',
}

return M
