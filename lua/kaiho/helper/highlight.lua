local colors = require('kaiho.helper.colors')

---@param hex string like '#eeeeee'
local function hex_to_integer(hex)
	return tonumber(hex:match('^#?(%x+)$'), 16)
end

-- hl_group link to target_group
---@param hl_group string
---@param target_group string
local function hl_link(hl_group, target_group)
	vim.api.nvim_set_hl(0, hl_group, { link = target_group })
end

---@param hl_group string
---@param callback fun(tbl: vim.api.keyset.hl_info): table
---@param target_group? string
local function setup_hl(hl_group, callback, target_group)
	target_group = target_group or hl_group
	local hl_tbl = vim.api.nvim_get_hl(0, { name = target_group })
	vim.api.nvim_set_hl(0, hl_group, callback(hl_tbl))
end

---@param groups string[]
local function change_hl_opts(groups, callback)
	for i = 1, #groups do
		local hl_group = groups[i]
		setup_hl(hl_group, callback)
	end
end

--- Link multiple highlight groups
---@param hl_links table<string, string[]> Array of pairs, where each pair links a source group to a target group
local function chang_hl_links(hl_links)
	for _, link in ipairs(hl_links) do
		hl_link(link[1], link[2])
	end
end

local make_dark_fg_bg_groups = {
	'StatusLine',
	'StatusLineNC',
	'NeoTreeStatusLineNC',
	'TabLine',
}
local separator_groups = {
	'WinSeparator',
	'NeoTreeWinSeparator',
}
local neotree_normal_bg_groups = {
	'NeoTreeNormal',
	'NeoTreeNormalNC',
}
local to_clear_bg_groups = {
	'NonText',
	'NormalFloat',
	'TelescopePromptTitle',
}
local links_groups = {
	-- Base
	{ 'NormalFloat', 'Normal' },
	{ 'TabLineFill', 'Normal' },
	{ 'FloatBorder', 'Function' },
	{ 'StatusLineNC', 'StatusLine' },

	-- SignColumn
	{ 'SignColumn', 'LineNr' },
	{ 'CursorLineNr', 'LineNr' },
	{ 'FoldColumn', 'SignColumn' },
	{ 'CursorLineSign', 'SignColumn' },
	{ 'CursorLineFold', 'SignColumn' },

	-- Telescope
	{ 'TelescopeNormal', 'Normal' },
	{ 'TelescopeBorder', 'FloatBorder' },
	{ 'TelescopePromptBorder', 'FloatBorder' },
}

-- TODO: 重新配置高亮组
local function setup_hlgroup()
	local C = colors.get_colors()

	change_hl_opts(make_dark_fg_bg_groups, function(tbl)
		tbl.bg = hex_to_integer(C.main_dark_bg)
		tbl.fg = hex_to_integer(C.main_dark_fg)
		return tbl
	end)

	change_hl_opts(separator_groups, function(tbl)
		local dark_bg = hex_to_integer(C.main_dark_bg)
		tbl.bg = dark_bg
		tbl.fg = dark_bg
		return tbl
	end)

	change_hl_opts(neotree_normal_bg_groups, function(tbl)
		tbl.bg = hex_to_integer(C.main_dark_bg)
		return tbl
	end)

	change_hl_opts(to_clear_bg_groups, function(tbl)
		tbl.bg = nil
		return tbl
	end)

	chang_hl_links(links_groups)
end

return {
	setup_hlgroup = setup_hlgroup,
}
