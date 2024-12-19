local bufdelete = require('bufdelete')

local utils = require('kaiho.helper.utils')

local opts = { noremap = true, silent = true }
local group_map = utils.group_map
local build_func = utils.build_func

local delete_current_buffer = build_func(bufdelete.bufdelete, 0, false)
local function delete_other_buffers()
	local filetypes = { 'OverseerList', 'toggleterm', 'quickfix', 'terminal', 'trouble', 'noice', 'cmp_menu', 'cmp_docs' }
	local buftypes = { 'terminal', 'nofile' }
	local current_buf = vim.fn.bufnr('%')
	local buffers = vim.fn.getbufinfo({ bufloaded = 1 })
	for _, buffer in ipairs(buffers) do
		local bufnr = buffer.bufnr
		local filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
		local buftype = vim.api.nvim_get_option_value('buftype', { buf = bufnr })
		local useless = { '[Preview]' }
		if
			bufnr ~= current_buf
			and not vim.tbl_contains(filetypes, filetype)
			and not vim.tbl_contains(buftypes, buftype)
		then
			require('bufdelete').bufdelete(bufnr, vim.tbl_contains(useless, vim.fn.bufname(bufnr)))
		end
	end
end

group_map('Buffer', {
	{ 'n', '<leader>c', delete_current_buffer, '[c]lose current buffer', opts },
	{ 'n', '<leader>C', delete_other_buffers, '[C]lose other buffers', opts },
})
