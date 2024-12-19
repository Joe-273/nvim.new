local utils = require('kaiho.helper.utils')

-- Lazygit
local Terminal = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({
	cmd = 'lazygit',
	dir = 'git_dir',
	direction = 'float',
	float_opts = {
		border = 'rounded',
	},
	highlights = {
		NormalFloat = { link = 'NormalFloat' },
		FloatBorder = { link = 'FloatBorder' },
	},
	-- function to run on opening the terminal
	on_open = function(term)
		local cur_opts = { noremap = true, silent = true, buffer = term.bufnr }
		vim.cmd('startinsert!')
		utils.map('n', 'q', '<CMD>close<CR>', 'quit lazygit', cur_opts)
	end,
	-- function to run on closing the terminal
	on_close = function()
		vim.cmd('startinsert!')
	end,
})

local function _lazygit_toggle()
	lazygit:toggle()
end

local opts = { noremap = true, silent = true }
local toggleterm_vertical = '<CMD>execute v:count . "ToggleTerm direction=vertical"<CR>'
local toggleterm_horizontal = '<CMD>execute v:count . "ToggleTerm direction=horizontal"<CR>'
utils.group_map('Toggleterm', {
	{ 'n', '|', toggleterm_vertical, 'split vertical', opts },
	{ 'n', '<C-\\>', toggleterm_horizontal, 'split horizontal', opts },
	{ 't', '|', '<Esc><CMD>ToggleTerm<CR>', 'toggle  window', opts },
	{ 't', '<C-\\>', '<Esc><CMD>ToggleTerm<CR>', 'toggle window', opts },
})
utils.map('n', '<leader>gl', _lazygit_toggle, 'Git: open [l]azygit', opts)
