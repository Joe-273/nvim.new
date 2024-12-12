local utils = require('kaiho.helper.utils')

local function get_color(group, attr)
	attr = attr or 'fg'
	local ok, hl_group = pcall(vim.api.nvim_get_hl, 0, { name = group })
	if not ok then
		vim.notify(
			'Highlight group \'' .. group .. '\' does not exist or has no ' .. attr .. ' color.',
			vim.log.levels.WARN
		)
	end

	local color = hl_group[attr]
	if color then
		return string.lower(string.format('#%06X', color))
	end
end

local colors = {}
local function setup_colors()
	-- Base
	colors.main_fg = get_color('Normal')
	colors.main_bg = get_color('Normal', 'bg')

	-- Other
	colors.main_string = get_color('String')
	colors.main_special = get_color('Special')
	colors.main_comment = get_color('Comment')
	colors.main_function = get_color('Function')
	colors.main_operator = get_color('Operator')
	colors.main_constant = get_color('Constant')
	colors.main_statement = get_color('Statement')

	-- Use for git
	colors.git_add = get_color('GitSignsAdd') or get_color('Added')
	colors.git_delete = get_color('GitSignsDelete') or get_color('Removed')
	colors.git_change = get_color('GitSignsChange') or get_color('Changed')

	-- Use for diagnostic
	colors.diagnostic_error = get_color('DiagnosticError')
	colors.diagnostic_warn = get_color('DiagnosticWarn')
	colors.diagnostic_info = get_color('DiagnosticInfo')
	colors.diagnostic_hint = get_color('DiagnosticHint')

	-- Base
	colors.main_light_fg = utils.lighten(colors.main_fg, 0.8)
	colors.main_light_bg = utils.lighten(colors.main_bg, 0.8)
	colors.main_dark_fg = utils.darken(colors.main_fg, 0.8)
	colors.main_dark_bg = utils.darken(colors.main_bg, 0.8)
end

---@return Colors
local function get_colors()
	return colors
end

return {
	get_colors = get_colors,
	setup_colors = setup_colors,
}
