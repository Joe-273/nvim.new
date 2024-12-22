local colors = require('kaiho.helper.colors')
local hl_utils = require('kaiho.helper.highlight.utils')

local hex2int = hl_utils.hex2int
local hls_link = hl_utils.hls_link
local new_hlgroups = hl_utils.new_hlgroups
local change_hls_gui = hl_utils.change_hls_gui

---@type ChangeHls
local change_hls_map = {
	{ { 'Comment', 'Keyword', 'Statement', 'Conditional' }, 'gui=italic' },
	{ { 'NonText', 'CursorLineNr' }, 'guifg=NONE' },
}

---@type HlsLink
local hl_link_map = {
	{
		{ -- Base
			'NormalFloat',
			'TabLine',
			'TabLineFill',
			-- Telescope
			'TelescopeNormal',
			-- WhichKey
			'WhichKeyNormal',
		},
		'Normal',
	},
	{
		{ -- Base
			'FloatTitle',
			'FloatBorder',
			-- Telescope
			'TelescopeBorder',
			'TelescopePromptBorder',
			'TelescopePromptTitle',
		},
		'Function',
	},
	{
		{ -- Base
			'StatusLine',
			'StatusLineNC',
			-- Neotree
			'NeoTreeStatusLine',
			'NeoTreeStatusLineNC',
		},
		'DarkBoth',
	},
	{
		{ -- Base
			'WinSeparator',
			-- NeoTree
			'NeoTreeWinSeparator',
		},
		'DarkEntire',
	},
	{
		{
			-- Neotree
			'NeoTreeNormal',
			'NeoTreeNormalNC',
			'NeoTreeEndOfBuffer',
			-- Noice
			'NoiceSplit',
			-- Trouble
			'TroubleNormal',
			'TroubleNormalNC',
		},
		'DarkOnlyBg',
	},

	{ { 'SignColumn', 'FoldColumn', 'CursorLineSign', 'CursorLineFold' }, 'LineNr' },
	-- NeoTree
	{ { 'NeoTreeExpander', 'NeoTreeDirectoryIcon' }, 'Directory' },
	-- LspKind
	{ { 'LspKindFile' }, 'LspKindText' },
}

local function setup_hl()
	local C = colors.get_colors()
	local fg = hex2int(C.main_dark_fg)
	local bg = hex2int(C.main_dark_bg)

	---@type NewHlgroups
	local new_groups_map = {
		{ 'DarkBoth', { fg = fg, bg = bg } },
		{ 'DarkOnlyBg', { bg = bg } },
		{ 'DarkEntire', { fg = bg, bg = bg } },
	}
	new_hlgroups(new_groups_map)
	change_hls_gui(change_hls_map)
	hls_link(hl_link_map)
end

return {
	setup_hl = setup_hl,
}
