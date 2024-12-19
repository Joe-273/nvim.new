local utils = require('kaiho.helper.utils')

local function toggle_noice()
	-- set noice flag
	local noice_opened = false
	local noice_win_id = nil

	-- Check if the noice window is open
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local win_config = vim.api.nvim_win_get_config(win)

		if vim.bo[buf].filetype == 'noice' and vim.bo[buf].buftype == 'nofile' then
			if win_config.anchor == nil and win_config.focusable then
				-- ignore float window
				noice_opened = true
				noice_win_id = win
				break
			end
		end
	end

	if noice_opened and noice_win_id then
		vim.api.nvim_win_close(noice_win_id, true)
	else
		require('noice').cmd('history')
	end
end

utils.map('n', '<leader>n', toggle_noice, 'Toggle: [n]oice history', { noremap = true, silent = true })
