local theme_configs = require('kaiho.plugins.colorscheme.themes-configs')

local function register_themes(configs, flavor)
	local nt = {}

	for k, v in pairs(configs) do
		if flavor and flavor:match(k) then
			v.event = nil
			v.priority = nil
		end
		table.insert(nt, v)
	end

	return nt
end

---@param flavor Colorschemes
---@return table: configs of themes
local function apply_theme(flavor)
	vim.api.nvim_create_autocmd('VimEnter', {
		group = vim.api.nvim_create_augroup('SetupTheme', { clear = true }),
		callback = function()
			pcall(vim.cmd.colorscheme, flavor)
			require('kaiho.helper.highlight').setup_hlgroup()
		end,
	})
	return register_themes(theme_configs, flavor)
end

return apply_theme
