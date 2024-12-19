local dropbar_utils = require('dropbar.utils')
local dropbar_api = require('dropbar.api')

local utils = require('kaiho.helper.utils')
local icons = require('kaiho.helper.icons')

local function add_padding(t)
	local nt = {}
	for k, v in pairs(t) do
		nt[k] = v .. ' '
	end
	return nt
end

utils.map('n', '<leader>pn', dropbar_api.pick, 'pick [n]avigator', { noremap = true, silent = true })

require('dropbar').setup({
	bar = {
		-- Use the same labels as flash.
		pick = { pivots = 'asdfghjklqwertyuiopzxcvbnm' },
		-- only display path in the winbar
		-- sources = { require('dropbar.sources').path },
	},
	icons = {
		enable = true,
		ui = {
			bar = { separator = ' ', extends = '…' },
			menu = { separator = ' ', indicator = '' },
		},
		kinds = { symbols = add_padding(icons.kind_icons) },
	},
	menu = {
		preview = false,
		quick_navigation = false,
		win_configs = { border = 'rounded' },
		keymaps = require('kaiho.plugins.dropbar.keymaps'),
	},
})
