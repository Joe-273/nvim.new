local Config = require('todo-comments.config')
local Highlight = require('todo-comments.highlight')
local make_entry = require('telescope.make_entry')
local pickers = require('telescope.builtin')

local utils = require('kaiho.plugins.telescope.preference.utils')
local previewers = require('kaiho.plugins.telescope.preference.previewers')

local get_path_and_tail = utils.get_path_and_tail
local process_string = utils.process_string
local get_valid_width = utils.get_valid_width

local function keywords_filter(opts_keywords)
	assert(not opts_keywords or type(opts_keywords) == 'string', '\'keywords\' must be a comma separated string or nil')
	local all_keywords = vim.tbl_keys(Config.keywords)
	if not opts_keywords then
		return all_keywords
	end
	local filters = vim.split(opts_keywords, ',')
	return vim.tbl_filter(function(kw)
		return vim.tbl_contains(filters, kw)
	end, all_keywords)
end

local function todo_picker(opts)
	opts = opts or {}
	opts.vimgrep_arguments = { Config.options.search.command }
	vim.list_extend(opts.vimgrep_arguments, Config.options.search.args)

	opts.search = Config.search_regex(keywords_filter(opts.keywords))
	opts.prompt_title = 'Find Todo'
	opts.use_regex = true
	opts.previewer = previewers.dyn_title_previewer_maker
	local entry_maker = make_entry.gen_from_vimgrep(opts)
	opts.entry_maker = function(line)
		local ret = entry_maker(line)
		ret.display = function(entry)
			local tail, path_display = get_path_and_tail(entry.filename)
			local width = get_valid_width(0.6, 40, 50)
			path_display = process_string(path_display, tail, width)
			local display
			local text = entry.text
			local start, finish, kw = Highlight.match(text)

			local hl = {}

			if start then
				kw = Config.keywords[kw] or kw
				local icon = Config.options.keywords[kw].icon or ' '
				display = icon .. tail .. ' ' .. path_display
				table.insert(hl, { { 0, #icon }, 'TodoFg' .. kw })
				table.insert(hl, { { #icon + #tail, #display }, 'TelescopeResultsComment' })
				display = display .. '│ '

				text = vim.trim(text:sub(start))
				table.insert(hl, {
					{ #display, #display + finish - start + 2 },
					'TodoBg' .. kw,
				})
				table.insert(hl, {
					{ #display + finish - start + 1, #display + finish + 1 + #text },
					'TodoFg' .. kw,
				})

				display = display .. text
			end

			return display, hl
		end
		return ret
	end
	opts.previewers = pickers.grep_string(opts)
end

return todo_picker
