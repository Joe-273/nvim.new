local utils = require('kaiho.helper.utils')

local function get_hlgroup_color(group, attr)
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
		return string.format('#%06X', color)
	end
	return nil
end

local colors_map = {
	-- Use for main color
	main_fg = { hl = 'Normal' },
	main_bg = { hl = 'Normal', attr = 'bg' },
	main_string = { hl = 'String' },
	main_special = { hl = 'Special' },
	main_comment = { hl = 'Comment' },
	main_function = { hl = 'Function' },
	main_operator = { hl = 'Operator' },
	main_constant = { hl = 'Constant' },
	main_statement = { hl = 'Statement' },

	-- Use for git
	git_add = { hl = { 'Added', 'GitSignsAdd' } },
	git_delete = { hl = { 'Removed', 'GitSignsDelete' } },
	git_change = { hl = { 'Changed', 'GitSignsChange' } },

	-- Use for diagnostic
	diagnostic_error = { hl = 'DiagnosticError' },
	diagnostic_warn = { hl = 'DiagnosticWarn' },
	diagnostic_info = { hl = 'DiagnosticInfo' },
	diagnostic_hint = { hl = 'DiagnosticHint' },
}

local colors = {}
-- Setup current colors and save to table: `colors`
local function setup_colors()
	local spare_hlgroup = 'Normal'

	for key, hlgroups in pairs(colors_map) do
		local hlgroup_tbl = hlgroups.hl
		if type(hlgroup_tbl) ~= 'table' then
			hlgroup_tbl = { hlgroup_tbl }
		end

		for _, hlgroup in ipairs(hlgroup_tbl) do
			colors[key] = get_hlgroup_color(hlgroup, hlgroups.attr or 'fg')
		end

		if not colors[key] then
			colors[key] = get_hlgroup_color(spare_hlgroup)
		end
	end

	colors['main_light_fg'] = utils.lighten(colors['main_fg'], 0.6)
	colors['main_light_bg'] = utils.lighten(colors['main_bg'], 0.6)
	colors['main_dark_fg'] = utils.darken(colors['main_fg'], 0.6)
	colors['main_dark_bg'] = utils.darken(colors['main_bg'], 0.6)
end

return {
	colors = colors,
	init_colors = setup_colors,
}
