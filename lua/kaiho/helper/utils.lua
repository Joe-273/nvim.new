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
		return func(unpack(args))
	end
end

---@param color string Hex color (e.g., "#RRGGBB")
---@return table RGB values {R, G, B}
local function rgb(color)
	color = string.lower(color)
	return { tonumber(color:sub(2, 3), 16), tonumber(color:sub(4, 5), 16), tonumber(color:sub(6, 7), 16) }
end

---@param foreground string Foreground hex color
---@param alpha number|string Transparency (0-1 or "00"-"FF")
---@param background string Background hex color
---@return string Blended hex color
local function blend(foreground, alpha, background)
	alpha = type(alpha) == 'string' and (tonumber(alpha, 16) / 0xff) or alpha
	local bg, fg = rgb(background), rgb(foreground)

	local function blendChannel(i)
		return math.floor(math.min(math.max(0, alpha * fg[i] + (1 - alpha) * bg[i]), 255) + 0.5)
	end

	return string.format('#%02x%02x%02x', blendChannel(1), blendChannel(2), blendChannel(3))
end

---@param color string Hex color
---@param amount number Blend ratio (0 = bg, 1 = original)
---@param bg string? Background color (default: black)
---@return string Darkened hex color
local function darken(color, amount, bg)
	return blend(color, amount, bg or '#000000')
end

---@param color string Hex color
---@param amount number Blend ratio (0 = fg, 1 = original)
---@param fg string? Foreground color (default: white)
---@return string Lightened hex color
local function lighten(color, amount, fg)
	return blend(color, amount, fg or '#FFFFFF')
end

return {
	map = map,
	group_map = group_map,
	build_func = build_func,
	darken = darken,
	lighten = lighten,
}
