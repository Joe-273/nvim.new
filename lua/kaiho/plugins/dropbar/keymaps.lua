local dropbar_utils = require('dropbar.utils')
local dropbar_api = require('dropbar.api')

local function open_item_and_close_menu()
	local menu = dropbar_utils.menu.get_current()
	if not menu then
		return
	end

	local cursor = vim.api.nvim_win_get_cursor(menu.win)
	local entry = menu.entries[cursor[1]]
	-- stolen from https://github.com/Bekaboo/dropbar.nvim/issues/66
	local component = entry:first_clickable(entry.padding.left + entry.components[1]:bytewidth())
	if component then
		menu:click_on(component, nil, 1, 'l')
	end
end

local function open_dir_or_file()
	local menu = dropbar_utils.menu.get_current()
	if not menu then
		return
	end
	local cursor = vim.api.nvim_win_get_cursor(menu.win)
	local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
	if component then
		menu:click_on(component, nil, 1, 'l')
	end
end

local function parent_dir_or_close_menu()
	local menu = dropbar_utils.menu.get_current()
	if not menu then
		menu:close()
		return
	end
	if menu.prev_menu then
		menu:close()
	else
		local bar = require('dropbar.utils.bar').get({ win = menu.prev_win })
		if bar then
			local barComponents = bar.components[1]._.bar.components
			for _, component in ipairs(barComponents) do
				if component.menu then
					local idx = component._.bar_idx
					menu:close()
					dropbar_api.pick(idx - 1)
				end
			end
		end
	end
end

local function close_all_menu()
	local menu = dropbar_utils.menu.get_current()
	while menu and menu.prev_menu do
		menu = menu.prev_menu
	end
	if menu then
		menu:close()
	end
end

return {
	['h'] = parent_dir_or_close_menu,
	['l'] = open_dir_or_file,
	['<CR>'] = open_item_and_close_menu,
	['o'] = open_item_and_close_menu,
	['q'] = close_all_menu,
	['<Esc>'] = close_all_menu,
}
