local conditions = require('heirline.conditions')

local colors = require('kaiho.helper.colors')

local components_creator = require('kaiho.plugins.heirline.statusline.components')
local structure_creator = require('kaiho.plugins.heirline.statusline.sturcture')

local function statusline_creator()
	local C = colors.get_colors()
	local bg = C.main_dark_bg
	local fg = C.main_dark_fg
	local comps = components_creator()
	local structure = structure_creator()

	return {
		structure.left_structure(comps.Vimode, comps.BufferName, {
			condition = conditions.is_active,
			comps.Git,
		}),
		{
			condition = conditions.is_active,
			comps.Diagnostics,
			hl = { fg = C.main_special },
		},
		{ provider = '%=' },
		{
			condition = conditions.is_active,
			comps.WorkDir,
		},
		{ provider = '%=' },
		{
			condition = conditions.is_active,
			flexible = 5,
			comps.Lsp,
			{ provider = '' },
			hl = { fg = C.main_function },
		},
		{
			condition = function()
				return conditions.is_active()
					and not conditions.buffer_matches({ filetype = { 'neo-tree' }, buftype = { 'nofile' } })
			end,
			structure.right_structure(comps.Ruler, comps.Ts, comps.Record),
		},
		hl = { fg = fg, bg = bg },
	}
end

return statusline_creator
