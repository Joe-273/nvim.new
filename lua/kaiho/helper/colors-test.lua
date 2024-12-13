-- NOTE: 用于测试的模块

local function to_hex_color(num)
	return string.format('#%06X', num)
end

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

	local color = hl_group[attr]
	if color then
		return to_hex_color(color)
	end
	return nil
end

get_hlgroup_color()

local hlcolor = {
	Normal = {}, -- Normal text
	PmenuSel = {}, -- Popup menu: selected item.
	StatusLine = {}, -- status line of current window
	StatusLineNC = {}, -- invert StatusLine

	-- Normal = {}, -- Normal text
	-- NormalSB = {}, -- Normal text in non-current windows
	-- NormalFloat = {}, -- Normal text in floating windows.
	-- FloatBorder = {},
	-- FloatTitle = {}, -- Title of floating windows
	-- Pmenu = {}, -- Popup menu: normal item.
	-- PmenuSel = {}, -- Popup menu: selected item.
	-- PmenuSbar = {}, -- Popup menu: scrollbar.
	-- PmenuThumb = {}, -- Popup menu: Thumb of the scrollbar.
	-- TabLine = {}, -- tab pages line, not active tab page label
	-- TabLineFill = {}, -- tab pages line, where there are no labels
	-- TabLineSel = {}, -- tab pages line, active tab page label
	-- StatusLine = {}, -- status line of current window
	-- StatusLineNC = {}, -- status lines of not-current windows Note: if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
}

-- 00:03:13 msg_show   luafile % Normal >> #E0E2EA >> #14161B
-- 00:03:13 msg_show   luafile % StatusLine >> #2C2E33 >> #C4C6CD
-- 00:03:13 msg_show   luafile % PmenuSel >> #2C2E33 >> #E0E2EA
-- 00:03:13 msg_show   luafile % StatusLineNC >> #C4C6CD >> #2C2E33
--
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
	-- Use for main color
	Statement = {},
	String = {},
	Special = {},
	Constant = {},
	Comment = {},
	Function = {},
	Operator = {},

	-- Use for git
	Added = {},
	Removed = {},
	Changed = {},

	-- Use for diagnostic
	DiagnosticError = {},
	DiagnosticWarn = {},
	DiagnosticInfo = {},
	DiagnosticHint = {},

	-- 注释斜体
}
---@param c  string
local function rgb(c)
	c = string.lower(c)
	return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
end

---@param foreground string foreground color
---@param alpha number|string number between 0 and 1. 0 results in bg, 1 results in fg
---@param background string background color
local function blend(foreground, alpha, background)
	if not foreground or not background then
		return nil
	end
	alpha = type(alpha) == 'string' and (tonumber(alpha, 16) / 0xff) or alpha
	local bg = rgb(background)
	local fg = rgb(foreground)

	local blendChannel = function(i)
		local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
		return math.floor(math.min(math.max(0, ret), 255) + 0.5)
	end

	return string.format('#%02x%02x%02x', blendChannel(1), blendChannel(2), blendChannel(3))
end

local function darken(color, amount, bg)
	return blend(color, amount, bg or '#000000')
end
local function lighter(color, amount, fg)
	return blend(color, amount, fg or '#FFFFFF')
end

for index, key in pairs(vim.tbl_keys(hlcolor)) do
	local fg = get_hlgroup_color(key)
	local bg = get_hlgroup_color(key, 'bg')
	print(key, '|', fg, '>>', darken(fg, 0.5))
	print(key, '|', bg, '>>', lighter(bg, 0.5))
	print('>>>>>>>>>>')
end

-- local colors_map = {
-- 	main_fg = { hl = { 'Normal' } },
-- 	main_bg = { hl = { 'Normal' }, attr = 'bg' },
--
-- 	-- Other
-- 	main_string = { hl = { 'String' } },
-- 	main_special = { hl = { 'Special' } },
-- 	main_comment = { hl = { 'Comment' } },
-- 	main_function = { hl = { 'Function' } },
-- 	main_operator = { hl = { 'Operator' } },
-- 	main_constant = { hl = { 'Constant' } },
-- 	main_statement = { hl = { 'Statement' } },
--
-- 	-- Use for git
-- 	git_add = { hl = { 'GitSignsAdd', 'Added' } },
-- 	git_delete = { hl = { 'GitSignsDelete', 'Removed' } },
-- 	git_change = { hl = { 'GitSignsChange', 'Changed' } },
--
-- 	-- Use for diagnostic
-- 	diagnostic_error = { hl = { 'DiagnosticError' } },
-- 	diagnostic_warn = { hl = { 'DiagnosticWarn' } },
-- 	diagnostic_info = { hl = { 'DiagnosticInfo' } },
-- 	diagnostic_hint = { hl = { 'DiagnosticHint' } },
-- }
-- local function get_colors()
-- 	local colors = {}
-- 	for key, colors_data in pairs(colors_map) do
-- 		local attr = colors_data.attr or 'fg'
--
-- 		local hl_groups = colors_data.hl
-- 		if type(hl_groups) ~= 'table' then
-- 			hl_groups = { hl_groups }
-- 		end
--
-- 		for _, hl_group in pairs(hl_groups) do
-- 			colors[key] = get_color(hl_group, attr)
-- 		end
--
-- 		if not colors[key] then
-- 			colors[key] = attr == 'fg' and def_fg or def_bg
-- 		end
-- 	end
--
-- 	-- Extra colors
-- 	colors.main_light_fg = utils.lighten(colors.main_fg, 0.8, def_fg)
-- 	colors.main_light_bg = utils.lighten(colors.main_bg, 0.8, def_fg)
-- 	colors.main_dark_fg = utils.darken(colors.main_fg, 0.8, def_bg)
-- 	colors.main_dark_bg = utils.darken(colors.main_bg, 0.8, def_bg)
--
-- 	return colors
-- end
