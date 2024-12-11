local telescope_utils = require('telescope.utils')
local previewers = require('telescope.previewers')
local from_entry = require('telescope.from_entry')
local conf = require('telescope.config').values

local M = {}

local ns = vim.api.nvim_create_namespace('')
local function jump_to_line(self, bufnr, entry)
	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
	vim.api.nvim_buf_add_highlight(bufnr, ns, 'TelescopePreviewLine', entry.lnum - 1, 0, -1)
	vim.api.nvim_win_set_cursor(self.state.winid, { entry.lnum, 0 })
	vim.api.nvim_buf_call(bufnr, function()
		vim.cmd('norm! zt')
	end)
end
M.dyn_title_previewer_maker = previewers.new_buffer_previewer({
	title = 'Preview',
	get_buffer_by_name = function(_, entry)
		return from_entry.path(entry, false)
	end,
	dyn_title = function(_, entry)
		local path_display = telescope_utils.transform_path({
			path_display = { 'smart' },
		}, entry.filename)
		local title = '[' .. path_display .. ']'
		return title ~= '[No Name]' and title
	end,
	define_preview = function(self, entry)
		local path = from_entry.path(entry, true, false)
		if path == nil or path == '' then
			return
		end
		conf.buffer_previewer_maker(path, self.state.bufnr, {
			bufname = self.state.bufname,
			winid = self.state.winid,
			callback = function(bufnr)
				pcall(jump_to_line, self, bufnr, entry)
			end,
		})
	end,
})

return M
