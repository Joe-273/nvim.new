-- TODO: 获取高亮组颜色
local get_hlgroup_color = function(group, attr)
	attr = attr or 'fg'
	local ok, hl_group = pcall(vim.api.nvim_get_hl, 0, { name = group })
	if not ok then
		vim.notify(
			'Highlight group \'' .. group .. '\' does not exist or has no ' .. attr .. ' color.',
			vim.log.levels.WARN
		)
		return nil
	end
	return hl_group[attr]
end

local function to_hex_color(num)
	return string.format('#%06X', num)
end

get_hlgroup_color()

local hlcolor = {
	Normal = {}, -- Normal text
	NormalSB = {}, -- Normal text in non-current windows
	NormalFloat = {}, -- Normal text in floating windows.
	FloatBorder = {},
	FloatTitle = {}, -- Title of floating windows
	Pmenu = {}, -- Popup menu: normal item.
	PmenuSel = {}, -- Popup menu: selected item.
	PmenuSbar = {}, -- Popup menu: scrollbar.
	PmenuThumb = {}, -- Popup menu: Thumb of the scrollbar.
	TabLine = {}, -- tab pages line, not active tab page label
	TabLineFill = {}, -- tab pages line, where there are no labels
	TabLineSel = {}, -- tab pages line, active tab page label
	StatusLine = {}, -- status line of current window
	StatusLineNC = {}, -- status lines of not-current windows Note: if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
}

local colors = {
	Normal = {},
	Comment = {}, -- just comments
	Special = {}, -- special things inside a comment
	Constant = {}, -- (preferred) any constant
	String = {}, -- a string constant: "this is a string"
	Character = {}, --  a character constant: 'c', '\n'
	Number = {}, --   a number constant: 234, 0xff
	Identifier = {}, -- (preferred) any variable name
	Function = {}, -- function name (also: methods for classes)
	Statement = {}, -- (preferred) any statement
	Conditional = {}, --  if, then, else, endif, switch, etc.
	Repeat = {}, --   for, do, while, etc.
	Label = {}, --    case, default, etc.
	Operator = {}, -- "sizeof", "+", "*", etc.
	Keyword = {}, --  any other keyword
	Exception = {}, --  try, catch, throw
}

local use = {
	Statement = {},
	String = {},
	Special = {},
	Constant = {},
	Comment = {},
	Function = {},
	Operator = {},

	Added = {},
	Removed = {},
	Changed = {},

	DiagnosticError = {},
	DiagnosticWarn = {},
	DiagnosticInfo = {},
	DiagnosticHint = {},

	-- 注释斜体
}

for index, key in pairs(vim.tbl_keys(use)) do
	local fg = get_hlgroup_color(key)
	local bg = get_hlgroup_color(key, 'bg') or 'Null'
	local ok, fgHex = pcall(to_hex_color, fg)
	if not ok then
		fgHex = 'null'
	end
	local ok, bgHex = pcall(to_hex_color, bg)
	if not ok then
		bgHex = 'null'
	end
	print(key, '>>', fgHex, '>>', bgHex)
end
