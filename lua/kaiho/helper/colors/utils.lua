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

local function adjust_color(base_color, meta_str)
	local action, value = meta_str:match('([^:]+):([%d,%.]+)')
	value = tonumber(value)

	if not value then
		vim.notify('Invalid value for color adjustment: ' .. value, vim.log.levels.WARN)
		return
	end

	if not utils[action] then
		vim.notify('Invalid color adjustment action: ' .. action, vim.log.levels.WARN)
		return
	end

	return utils[action](base_color, value)
end

return {
	get_color_by_hlgroup = get_color_by_hlgroup,
	adjust_color = adjust_color,
}
