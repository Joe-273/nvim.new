local colors = require('kaiho.helper.colors')

---@param hex string like '#eeeeee'
local function hex_to_integer(hex)
	return tonumber(hex:match('^#?(%x+)$'), 16)
end

local hl_link = function(hl_group, target_group)
	-- hl_group link to target_group
	vim.api.nvim_set_hl(0, hl_group, { link = target_group })
end

---@param hl_group string
---@param callback fun(tbl: vim.api.keyset.hl_info): table
---@param target_group? string
local hl_change = function(hl_group, callback, target_group)
	target_group = target_group or hl_group
	local hl_tbl = vim.api.nvim_get_hl(0, { name = target_group })
	vim.api.nvim_set_hl(0, hl_group, callback(hl_tbl))
end

---@param groups string[]
local setup_hlgroups = function(groups, callback)
	for i = 1, #groups do
		local hl_group = groups[i]
		hl_change(hl_group, callback)
	end
end

-- TODO: 重新配置高亮组
-- 1.Toggleterm 分割线
-- 2.某些主题下的窗口分割线（垂直分割线）
local function setup_hlgroup()
	local C = colors.get_colors()

	setup_hlgroups({ 'StatusLine', 'TabLine' }, function(tbl)
		tbl.bg = hex_to_integer(C.main_dark_bg)
		tbl.fg = hex_to_integer(C.main_dark_fg)
		return tbl
	end)

	setup_hlgroups({ 'NeoTreeWinSeparator', 'WinSeparator' }, function(tbl)
		tbl.fg = hex_to_integer(C.main_dark_bg)
		tbl.bg = hex_to_integer(C.main_dark_bg)
		return tbl
	end)

	setup_hlgroups({ 'NonText', 'NormalFloat' }, function(tbl)
		tbl.bg = nil
		return tbl
	end)

	-- Base
	hl_link('TabLineFill', 'Normal')
	hl_link('FloatBorder', 'Function')

	-- SignColumn
	hl_link('SignColumn', 'LineNr')
	hl_link('CursorLineNr', 'LineNr')
	hl_link('FoldColumn', 'SignColumn')
	hl_link('CursorLineSign', 'SignColumn')
	hl_link('CursorLineFold', 'SignColumn')

	-- Telescope
	hl_link('TelescopeNormal', 'Normal')
	hl_link('TelescopeBorder', 'FloatBorder')

	-- Neotree
	-- hl_link('NeoTreeNormal', 'Normal')
	-- hl_link('NeoTreeNormalNC', 'NormalNC')
	-- hl_link('NeoTreeWinSeparator', 'WinSeparator')
	-- hl_link('NeoTreeDirectoryIcon', 'Directory')
end

return {
	setup_hlgroup = setup_hlgroup,
}
