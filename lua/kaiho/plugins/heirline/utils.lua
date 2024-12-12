local colors = require('kaiho.helper.colors').get_colors()

---@param func fun(colors: Colors): table
local function creator(func)
	return func(colors)
end

return {
	colors = colors,
	creator = creator,
}
