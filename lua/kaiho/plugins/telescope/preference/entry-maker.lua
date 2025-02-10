local telescope_utils = require('telescope.utils')
local telescope_make_entry = require('telescope.make_entry')
local telescope_entry_display = require('telescope.pickers.entry_display')

local icons = require('kaiho.helper.icons').kind_icons
local utils = require('kaiho.plugins.telescope.preference.utils')

local get_path_and_tail = utils.get_path_and_tail
local process_string = utils.process_string
local get_valid_width = utils.get_valid_width

local M = {}

M.files_entry_maker = function(opts)
	return function(line)
		local entry_maker = telescope_make_entry.gen_from_file(opts)
		local entry_opts = entry_maker(line)
		entry_opts.display = function(entry)
			local displayer = telescope_entry_display.create({
				separator = ' ',
				items = {
					{ width = 1 },
					{ width = nil },
					{ remaining = true },
				},
			})
			local tail, path_display = get_path_and_tail(entry.value)
			local icon, icon_hl = telescope_utils.get_devicons(tail)
			return displayer({
				{ icon, icon_hl },
				tail,
				{ path_display, 'TelescopeResultsComment' },
			})
		end
		return entry_opts
	end
end
M.buffer_entry_maker = function(opts)
	return function(line)
		local entry_maker = telescope_make_entry.gen_from_buffer(opts)
		local entry_opts = entry_maker(line)
		entry_opts.display = function(entry)
			local displayer = telescope_entry_display.create({
				separator = ' ',
				items = {
					{ width = 1 },
					{ width = nil },
					{ remaining = true },
				},
			})
			local tail, path_display = get_path_and_tail(entry.value)
			local icon, icon_hl = telescope_utils.get_devicons(tail)
			return displayer({
				{ icon, icon_hl },
				tail,
				{ path_display, 'TelescopeResultsComment' },
			})
		end
		return entry_opts
	end
end

M.grep_entry_maker = function(opts)
	return function(line)
		local entry_maker = telescope_make_entry.gen_from_vimgrep(opts)
		local entry_opts = entry_maker(line)
		entry_opts.display = function(entry)
			local displayer = telescope_entry_display.create({
				separator = ' ',
				items = {
					{ width = 1 },
					{ width = nil },
					{ width = nil },
					{ remaining = true },
				},
			})
			local tail, path_display = get_path_and_tail(entry.filename)
			local width = get_valid_width(0.6, 35, 50)
			path_display = process_string(path_display, tail, width)
			local icon, icon_hl = telescope_utils.get_devicons(tail)
			local text = entry.text:match('^%s*(.-)%s*$')
			return displayer({
				{ icon, icon_hl },
				tail,
				{ path_display, 'TelescopeResultsComment' },
				'│ ' .. text,
			})
		end
		return entry_opts
	end
end

M.quickfix_entry_maker = function(opts)
	return function(line)
		local entry_maker = telescope_make_entry.gen_from_quickfix(opts)
		local entry_opts = entry_maker(line)
		entry_opts.display = function(entry)
			local displayer = telescope_entry_display.create({
				separator = ' ',
				items = {
					{ width = 1 },
					{ width = nil },
					{ width = nil },
					{ remaining = true },
				},
			})
			local tail, path_display = get_path_and_tail(entry.filename)
			local width = get_valid_width(0.6, 40, 50)
			path_display = process_string(path_display, tail, width)
			local icon, icon_hl = telescope_utils.get_devicons(tail)
			local text = entry.text:match('^%s*(.-)%s*$')
			return displayer({
				{ icon, icon_hl },
				tail,
				{ path_display, 'TelescopeResultsComment' },
				'│ ' .. text,
			})
		end
		return entry_opts
	end
end
M.symbol_entry_maker = function(opts)
	return function(line)
		local entry_maker = telescope_make_entry.gen_from_lsp_symbols(opts)
		local entry_opts = entry_maker(line)
		entry_opts.display = function(entry)
			local displayer = telescope_entry_display.create({
				separator = ' ',
				items = {
					{ width = 1 },
					{ width = 10 },
					{ remaining = true },
				},
			})
			local icon = string.format('%s', icons[(entry.symbol_type:lower():gsub('^%l', string.upper))])
			local hl = 'LspKind' .. entry.symbol_type
			return displayer({
				{ icon, hl },
				{ entry.symbol_type, hl },
				{ entry.symbol_name, hl },
			})
		end
		return entry_opts
	end
end

return M
