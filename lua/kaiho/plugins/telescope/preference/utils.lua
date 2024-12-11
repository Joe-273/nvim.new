local telescope_utils = require('telescope.utils')

local telescope_size = require('kaiho.plugins.telescope.preference.options')

local function get_path_and_tail(fileName)
	local tail = telescope_utils.path_tail(fileName)
	local parent_dir = require('plenary.strings').truncate(fileName, #fileName - (#tail + 1), '')

	local path_display = telescope_utils.transform_path({
		path_display = { 'smart' },
	}, parent_dir)

	return tail, path_display
end

local function get_result_panel_width()
	local result_panel_width = nil

	if vim.o.columns <= telescope_size.preview_limit then
		result_panel_width = vim.o.columns * telescope_size.width
	else
		result_panel_width = vim.o.columns * telescope_size.width * (1 - telescope_size.preview_width)
	end

	return result_panel_width
end

-- Calculates the valid width for a panel based on a percentage of the result panel width,
-- with consideration for a maximum length and an optional threshold.
---@param panel_percent number
--   The percentage of the result panel width to use as the base width for the panel.
---@param max_length number
--   The maximum allowed length for the panel width.
---@param enable_threshold? number
--   An optional threshold width. If the result panel width is greater than this threshold,
--   the panel width will be calculated as a percentage of the result panel width; otherwise,
--   the threshold itself will be used as the panel width.
---@return number
--   The calculated valid width for the panel, respecting the maximum length and threshold.
local function get_valid_width(panel_percent, max_length, enable_threshold)
	local width = get_result_panel_width()
	enable_threshold = enable_threshold or nil

	if enable_threshold ~= nil and width < enable_threshold then
		width = enable_threshold
	else
		width = math.ceil(width * panel_percent)
		if width > max_length then
			width = max_length
		end
	end

	return width
end

-- Adjusts the 'flex_part' string to fit within a specified 'width' when combined with 'fix_part'.
-- If the combined length of 'fix_part' and 'flex_part' exceeds 'width', 'flex_part' is truncated.
-- Otherwise, 'flex_part' is padded with spaces to meet the 'width'.
---@param flex_part string
--   The flexible string part that may be truncated or padded.
---@param fix_part string
--   The fixed string part with a constant length.
---@param width number
--   The maximum allowed width for the combined 'fix_part' and 'flex_part'.
---@return string
--   The adjusted string that fits within the specified 'width'.
local function process_string(flex_part, fix_part, width)
	local diff_value = #fix_part + #flex_part - width

	if diff_value > 0 then
		return require('plenary.strings').truncate(flex_part, #flex_part - diff_value, '') .. '…'
	else
		return flex_part .. string.rep(' ', -diff_value + 1)
	end
end

return {
	get_path_and_tail = get_path_and_tail,
	get_valid_width = get_valid_width,
	process_string = process_string,
}
