local entry_makers = require('kaiho.plugins.telescope.preference.entry-maker')
local previewers = require('kaiho.plugins.telescope.preference.previewers')

local function get_pickers(picker, entry_maker, previewer)
	return function(opts)
		opts = opts or {}
		opts.entry_maker = entry_maker(opts)
		opts.previewer = previewer or previewers.dyn_title_previewer_maker
		require('telescope.builtin')[picker](opts)
	end
end

local M = {}

M.buffers = get_pickers('buffers', entry_makers.buffer_entry_maker)
M.find_files = get_pickers('find_files', entry_makers.files_entry_maker)
M.git_files = get_pickers('git_files', entry_makers.files_entry_maker)
M.oldfiles = get_pickers('oldfiles', entry_makers.files_entry_maker)
M.grep_string = get_pickers('grep_string', entry_makers.grep_entry_maker)
M.live_grep = get_pickers('live_grep', entry_makers.grep_entry_maker)
M.lsp_references = get_pickers('lsp_references', entry_makers.quickfix_entry_maker)
M.lsp_definitions = get_pickers('lsp_definitions', entry_makers.quickfix_entry_maker)
M.lsp_implementations = get_pickers('lsp_implementations', entry_makers.quickfix_entry_maker)
M.lsp_type_definitions = get_pickers('lsp_type_definitions', entry_makers.quickfix_entry_maker)
M.lsp_document_symbols = get_pickers('lsp_document_symbols', entry_makers.symbol_entry_maker)
M.lsp_dynamic_workspace_symbols = get_pickers('lsp_dynamic_workspace_symbols', entry_makers.symbol_entry_maker)
M.find_todo = require('kaiho.plugins.telescope.preference.todo-picker')

return M
