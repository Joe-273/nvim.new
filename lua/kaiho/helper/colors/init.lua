local colors_utils = require('kaiho.helper.colors.utils')

local base_colors_map = {
	-- Base
	main_fg = { 'Normal' },
	main_bg = { 'Normal:bg' },
	-- Other
	main_string = { 'String' },
	main_special = { 'Special' },
	main_comment = { 'Comment' },
	main_function = { 'Function' },
	main_operator = { 'Operator' },
	main_constant = { 'Constant' },
	main_statement = { 'Statement' },
	-- Git
	git_added = { 'Added', 'GitSignsAdd' },
	git_deleted = { 'Removed', 'GitSignsDelete' },
	git_changed = { 'Changed', 'GitSignsChange' },
	-- Diagnostic
	diagnostic_error = { 'DiagnosticError' },
	diagnostic_warn = { 'DiagnosticWarn' },
	diagnostic_info = { 'DiagnosticInfo' },
	diagnostic_hint = { 'DiagnosticHint' },
}
local function get_base_colors(colors_map)
	local base_colors_tbl = {}
	for key, groups_arr in pairs(colors_map) do
		for _, group_str in pairs(groups_arr) do
			local group, attr = group_str:match('([^:]+):?(.*)')
			attr = attr ~= '' and attr or 'fg'
			base_colors_tbl[key] = colors_utils.get_color_by_hlgroup(group, attr)
		end
	end
	return base_colors_tbl
end

local derivative_colors_map = {
	-- Extra base
	main_dark_fg = { 'main_fg', 'darken:0.85' },
	main_dark_bg = { 'main_bg', 'darken:0.85' },
	main_light_fg = { 'main_fg', 'lighten:0.85' },
	main_light_bg = { 'main_bg', 'lighten:0.85' },
}
local function gen_derivative_colors(colors_map, base_colors)
	local derivative_colors_tbl = {}
	for key, data_touple in pairs(colors_map) do
		local base_color = base_colors[data_touple[1]]
		local meta_str = data_touple[2]
		derivative_colors_tbl[key] = colors_utils.adjust_color(base_color, meta_str)
	end
	return derivative_colors_tbl
end

---@return Colors
local function get_colors()
	local base_colrs = get_base_colors(base_colors_map)
	local derivative_colors = gen_derivative_colors(derivative_colors_map, base_colrs)
	return vim.tbl_extend('keep', base_colrs, derivative_colors)
end

return {
	get_colors = get_colors,
}
