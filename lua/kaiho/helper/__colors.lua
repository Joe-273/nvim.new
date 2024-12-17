local utils = require('kaiho.helper.utils')

local function get_color_by_hlgroup(group, attr)
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
		return string.lower(string.format('#%06X', color))
	end
end

local def_fg = '#ffffff'
local def_bg = '#000000'
local colors_map = {
	-- Base
	main_fg = { hl = 'Normal' },
	main_bg = { hl = 'Normal:bg' },

	-- Other
	main_string = { hl = 'String' },
	main_special = { hl = 'Special' },
	main_comment = { hl = 'Comment' },
	main_function = { hl = 'Function' },
	main_operator = { hl = 'Operator' },
	main_constant = { hl = 'Constant' },
	main_statement = { hl = 'Statement' },

	-- Git
	git_add = { hl = { 'Added', 'GitSignsAdd' } },
	git_delete = { hl = { 'Removed', 'GitSignsDelete' } },
	git_change = { hl = { 'Changed', 'GitSignsChange' } },

	-- Diagnostic
	diagnostic_error = { hl = 'DiagnosticError' },
	diagnostic_warn = { hl = 'DiagnosticWarn' },
	diagnostic_info = { hl = 'DiagnosticInfo' },
	diagnostic_hint = { hl = 'DiagnosticHint' },

	-- Extra base
	main_dark_fg = { base = 'main_fg', meta = 'darken:0.85' },
	main_dark_bg = { base = 'main_bg', meta = 'darken:0.85' },
	main_light_fg = { base = 'main_fg', meta = 'lighten:0.85' },
	main_light_bg = { base = 'main_bg', meta = 'lighten:0.85' },
}

-- Get all colors in colors_map
---@return Colors
local function get_colors()
	local colors = {}

	-- Lighten or darken color
	local function adjust_color(base, action, value)
		local color = colors[base]

		value = tonumber(value)
		if not value then
			vim.notify('Invalid value for color adjustment: ' .. value, vim.log.levels.WARN)
			return
		end
		if not color then
			vim.notify('Base color \'' .. base .. '\' not found.', vim.log.levels.WARN)
			return
		end
		if not utils[action] then
			vim.notify('Invalid color adjustment action: ' .. action, vim.log.levels.WARN)
			return
		end
		return utils[action](color, value)
	end

	for color_key, color_tbl in pairs(colors_map) do
		local hl = color_tbl.hl
		if hl ~= nil then
			hl = type(hl) ~= 'table' and { hl } or hl
			for _, group_str in pairs(hl) do
				local group, attr = group_str:match('([^:]+):?(.*)')
				attr = attr ~= '' and attr or 'fg'
				local color = get_color_by_hlgroup(group, attr)
				if not color then
					color = attr == 'fg' and def_fg or def_bg
				end
				colors[color_key] = color
			end
		end
	end

	for color_key, color_tbl in pairs(colors_map) do
		local base = color_tbl.base
		local meta = color_tbl.meta
		if base and meta then
			local action, value = meta:match('([^:]+):([%d,%.]+)')
			colors[color_key] = adjust_color(base, action, value)
		end
	end

	return colors
end

return {
	get_colors = get_colors,
}
