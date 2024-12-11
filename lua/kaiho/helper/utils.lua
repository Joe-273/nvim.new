-- [[ Provide util functions ]]

--- Sets a keymap with optional description and options.
--- @param mode string|table The mode(s) to map the key (e.g., 'n', 'i', {'n', 'v'}).
--- @param keys string The key(s) to be mapped.
--- @param func function|string The function or command to execute.
--- @param desc string The description for the keymap.
--- @param opts table|nil Optional keymap settings.
local function map(mode, keys, func, desc, opts)
	opts = opts or {}
	opts = vim.tbl_extend('keep', { desc = desc }, opts)

	vim.keymap.set(mode, keys, func, opts)
end

--- Maps multiple keys with a group description.
--- @param group_desc string The description prefix for all keymaps in the group.
--- @param map_table table A table of keymap definitions. Each entry is a table containing {mode, keys, func, desc, opts}.
local function group_map(group_desc, map_table)
	for _, t in ipairs(map_table) do
		local mode, keys, func, desc, opts = unpack(t)
		opts = opts or {}
		desc = group_desc .. ': ' .. desc
		map(mode, keys, func, desc, opts)
	end
end

--- Creates a new function with preset arguments.
--- @param func function The original function to wrap.
--- @param ... any Variable number of preset arguments to pass to the function.
--- @return function A new function that, when called, executes `func` with the preset arguments.
local function build_func(func, ...)
	local args = { ... }
	return function()
		func(unpack(args))
	end
end

return {
	map = map,
	group_map = group_map,
	build_func = build_func,
}
