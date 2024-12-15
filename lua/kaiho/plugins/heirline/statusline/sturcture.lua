local conditions = require('heirline.conditions')
local heirline_utils = require('heirline.utils')

local icons = require('kaiho.helper.icons')
local utils = require('kaiho.helper.utils')
local colors = require('kaiho.helper.colors')
local public = require('kaiho.plugins.heirline.public')

local edge_char = icons.edge_char

local function structure_creator()
	local C = colors.get_colors()
	local bg = C.main_dark_bg
	local fg = C.main_dark_fg

	local function init_func(self)
		local vicolor = public.vimode.current_color()
		self.color1 = conditions.is_active() and vicolor or utils.lighten(bg, 0.8, vicolor)
		self.color2 = utils.lighten(bg, 0.7, self.color1)
		self.color3 = utils.lighten(bg, 0.8, self.color1)
	end

	local function left_structure(p1, p2, p3)
		return {
			init = init_func,
			{
				heirline_utils.surround({ '', edge_char.right }, function(self)
					return self.color1
				end, p1),
				hl = function(self)
					return {
						fg = bg,
						bg = self.color2,
					}
				end,
			},
			{
				heirline_utils.surround({ '', edge_char.right }, function(self)
					return self.color2
				end, p2),
				hl = function(self)
					return {
						fg = C.main_light_fg,
						bg = self.color3,
					}
				end,
			},
			{
				heirline_utils.surround({ '', edge_char.right }, function(self)
					return self.color3
				end, p3),
				hl = { fg = fg, bg = bg },
			},
		}
	end

	local function right_structure(p1, p2, p3)
		return {
			init = init_func,
			{
				heirline_utils.surround({ edge_char.left, '' }, function(self)
					return self.color3
				end, p3),
				hl = { fg = fg, bg = bg },
			},
			{
				heirline_utils.surround({ edge_char.left, '' }, function(self)
					return self.color2
				end, p2),
				hl = function(self)
					return {
						fg = C.main_light_fg,
						bg = self.color3,
					}
				end,
			},
			{
				heirline_utils.surround({ edge_char.left, '' }, function(self)
					return self.color1
				end, p1),
				hl = function(self)
					return {
						fg = bg,
						bg = self.color2,
					}
				end,
			},
		}
	end

	return {
		left_structure = left_structure,
		right_structure = right_structure,
	}
end

return structure_creator
