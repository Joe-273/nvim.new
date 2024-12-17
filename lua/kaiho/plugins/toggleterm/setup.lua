local utils = require('kaiho.helper.utils')

local function set_shell()
	if vim.fn.has('win32') == 1 then
		return 'pwsh'
	else
		return '/bin/zsh'
	end
end

require('toggleterm').setup({
	size = function(term)
		if term.direction == 'horizontal' then
			return 20
		elseif term.direction == 'vertical' then
			return vim.o.columns * 0.4
		end
	end,
	-- open_mapping = [[<c-\>]],
	shade_terminals = false,
	shell = set_shell,
	winblend = 0,
	highlights = {
		WinSeparator = { link = 'WinSeparator' },
		StatusLine = { link = 'StatusLine' },
		StatusLineNC = { link = 'StatusLineNC' },
	},
})

local opts = { noremap = true, silent = true }
local toggleterm_vertical = '<CMD>execute v:count . "ToggleTerm direction=vertical"<CR>'
local toggleterm_horizontal = '<CMD>execute v:count . "ToggleTerm direction=horizontal"<CR>'
utils.group_map('Toggleterm', {
	{ 'n', '|', toggleterm_vertical, 'split vertical', opts },
	{ 'n', '<C-\\>', toggleterm_horizontal, 'split horizontal', opts },
	{ 't', '|', '<Esc><CMD>ToggleTerm<CR>', 'toggle  window', opts },
	{ 't', '<C-\\>', '<Esc><CMD>ToggleTerm<CR>', 'toggle window', opts },
})

-- Setting lazygit
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

utils.map('n', '<leader>gl', _lazygit_toggle, 'Git: open [l]azygit', opts)
