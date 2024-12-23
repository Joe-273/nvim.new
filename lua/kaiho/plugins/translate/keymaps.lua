local function run_cmd_to_aword(cmd)
	return function()
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.cmd('normal! viw')
		vim.cmd(cmd)
		vim.api.nvim_input('<Esc>')
		vim.api.nvim_win_set_cursor(0, cursor_pos)
	end
end

local keys = {
	{ 'mw', run_cmd_to_aword('Translate ZH'), desc = 'Trans to Chinese', mode = { 'n' } },
	{ 'mm', '<CMD>Translate ZH<CR>', desc = 'Trans to Chinese', mode = { 'n', 'v' } },
	{ 'mW', run_cmd_to_aword('Translate EN'), desc = 'Trans to English', mode = { 'n' } },
	{ 'mM', '<CMD>Translate EN<CR>', desc = 'Trans to English', mode = { 'n', 'v' } },
}

return keys
