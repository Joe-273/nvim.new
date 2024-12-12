local conditions = require('heirline.conditions')

local public = require('kaiho.plugins.heirline.public')
local heirline_utils = require('kaiho.plugins.heirline.utils')
local utils = require('kaiho.helper.utils')
local icons = require('kaiho.helper.icons')

local edge_char = icons.edge_char
local diag_sign = icons.diag_sign

local Spacer = function(provider, condition)
	provider = provider or ' '
	condition = condition or function()
		return true
	end
	return { provider = provider, condition = condition }
end

local LeftPart = heirline_utils.creator(function(colors)
	local bg = colors.main_dark_bg
	local fg = colors.main_dark_fg
	local mid_rate = 0.65
	local hight_rate = 0.8

	local ViMode_Part = {
		{ provider = '  ' },
		{
			provider = function()
				return '%2(' .. public.ViMode.current_name() .. '%) '
			end,
		},
		{
			provider = edge_char.right,
			hl = function()
				local vicolor = public.ViMode.current_color()
				return { fg = vicolor, bg = utils.lighten(bg, mid_rate, vicolor) }
			end,
		},
		hl = function()
			return {
				fg = bg,
				bg = public.ViMode.current_color(),
				bold = true,
			}
		end,
	}

	local BufferName_Part = {
		{ public.FileIcon },
		{ public.FileName },
		Spacer(),
		{ public.FileFlag },
		Spacer(' ', function()
			return vim.bo.modified or not vim.bo.modifiable or vim.bo.readonly
		end),
		{
			provider = edge_char.right,
			hl = function()
				local vicolor = public.ViMode.current_color()
				local dyn_bg = conditions.is_git_repo() and utils.lighten(bg, hight_rate, vicolor) or bg
				return { fg = utils.lighten(bg, mid_rate, vicolor), bg = dyn_bg }
			end,
		},
		hl = function()
			local vicolor = public.ViMode.current_color()
			return {
				fg = colors.main_fg,
				bg = utils.lighten(bg, mid_rate, vicolor),
			}
		end,
	}

	local Git_Part = {
		condition = conditions.is_git_repo,
		init = function(self)
			self.status_dict = vim.b.gitsigns_status_dict
			self.has_changes = self.status_dict.added or self.status_dict.removed or self.status_dict.changed
		end,
		Spacer(),
		{
			provider = function(self)
				return ' ' .. self.status_dict.head
			end,
		},
		{
			condition = function(self)
				return self.has_changes
			end,
			provider = '(',
		},
		{
			provider = function(self)
				local count = self.status_dict.added or 0
				return count > 0 and ('+' .. count)
			end,
			hl = { fg = colors.git_add },
		},
		{
			provider = function(self)
				local count = self.status_dict.removed or 0
				return count > 0 and ('-' .. count)
			end,
			hl = { fg = colors.git_delete },
		},
		{
			provider = function(self)
				local count = self.status_dict.changed or 0
				return count > 0 and ('~' .. count)
			end,
			hl = { fg = colors.git_change },
		},
		{
			condition = function(self)
				return self.has_changes
			end,
			provider = ')',
		},
		Spacer(),
		{
			provider = edge_char.right,
			hl = function()
				local vicolor = public.ViMode.current_color()
				return { fg = utils.lighten(bg, hight_rate, vicolor), bg = bg }
			end,
		},
		hl = function()
			local vicolor = public.ViMode.current_color()
			return {
				fg = fg,
				bg = utils.lighten(bg, hight_rate, vicolor),
			}
		end,
	}

	local Diagnostics_Part = {
		condition = conditions.has_diagnostics,
		static = {
			error_icon = diag_sign.error,
			warn_icon = diag_sign.warn,
			info_icon = diag_sign.info,
			hint_icon = diag_sign.hint,
		},
		init = function(self)
			self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
			self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
			self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
			self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
		end,
		update = { 'DiagnosticChanged', 'BufEnter' },

		Spacer('  '),
		{
			provider = function(self)
				local dynamic_space = (self.warnings > 0 or self.info > 0 or self.hints > 0) and ' ' or ''
				return self.errors > 0 and (self.error_icon .. self.errors .. dynamic_space)
			end,
			hl = { fg = colors.diagnostic_error },
		},
		{
			provider = function(self)
				local dynamic_space = self.info > 0 or self.hints > 0 and ' ' or ''
				return self.warnings > 0 and (self.warn_icon .. self.warnings .. dynamic_space)
			end,
			hl = { fg = colors.diagnostic_warn },
		},
		{
			provider = function(self)
				local dynamic_space = self.hints > 0 and ' ' or ''
				return self.info > 0 and (self.info_icon .. self.info .. dynamic_space)
			end,
			hl = { fg = colors.diagnostic_info },
		},
		{
			provider = function(self)
				return self.hints > 0 and (self.hint_icon .. self.hints)
			end,
			hl = { fg = colors.diagnostic_hint },
		},
		hl = { fg = colors.main_operator, bg = bg },
	}

	return {
		ViMode_Part,
		BufferName_Part,
		Git_Part,
		Diagnostics_Part,
	}
end)

local MiddlePart = heirline_utils.creator(function(colors)
	local bg = colors.main_dark_bg
	local fg = colors.main_dark_fg

	local Fill = { provider = '%=', hl = { fg = fg, bg = bg } }

	local WorkDir = {
		condition = function()
			return conditions.width_percent_below(#vim.fn.getcwd(0), 0.25)
		end,
		provider = function(self)
			local cwd = vim.fn.getcwd()
			cwd = vim.fn.fnamemodify(cwd, ':~')
			local path_separator = package.config:sub(1, 1)
			local trail = cwd:sub(-1) == path_separator and '' or path_separator
			return ' ' .. cwd .. trail
		end,
		hl = { fg = colors.main_fg, bg = bg },
	}

	return {
		Fill,
		WorkDir,
		Fill,
	}
end)

local RightPart = heirline_utils.creator(function(colors)
	local function check_treesitter()
		local has_treesitter, _ = pcall(require, 'nvim-treesitter')
		if not has_treesitter then
			return false
		end
		local parsers = require('nvim-treesitter.parsers').get_parser_configs()
		if not parsers then
			return false
		end
		local ts = vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()]
		if ts then
			return ts
		end
		return false
	end

	local bg = colors.main_dark_bg
	local fg = colors.main_dark_fg
	local rate = 0.8

	local Ruler_Part = {
		condition = function()
			local char = ' %7(%l/%3L%):%2c | %P '
			return conditions.width_percent_below(#char, 0.25)
		end,
		{
			provider = edge_char.left,
			hl = function()
				local vicolor = public.ViMode.current_color()
				local dyn_bg = check_treesitter() and utils.lighten(bg, rate, vicolor) or bg
				return { fg = vicolor, bg = dyn_bg }
			end,
		},
		{
			provider = ' %7(%l/%3L%):%2c | %P ',
			hl = function()
				local vicolor = public.ViMode.current_color()
				return { fg = bg, bg = vicolor }
			end,
		},
	}

	local TS_Part = {
		condition = check_treesitter,
		{
			provider = edge_char.left,
			hl = function()
				local vicolor = public.ViMode.current_color()
				return { fg = utils.lighten(bg, rate, vicolor), bg = bg }
			end,
		},
		{
			provider = function()
				return ' 󰪥 TS(' .. require('nvim-treesitter.parsers').get_buf_lang(vim.api.nvim_get_current_buf()) .. ')'
			end,
		},
		Spacer(),
		hl = function()
			local vicolor = public.ViMode.current_color()
			return {
				fg = fg,
				bg = utils.lighten(bg, rate, vicolor),
			}
		end,
	}

	local Lsp_Part = {
		condition = conditions.lsp_attached,
		update = { 'LspAttach', 'LspDetach' },
		{
			provider = function()
				local names = {}
				for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
					table.insert(names, server.name)
				end
				return '󰲒 (' .. table.concat(names, ' ') .. ')'
			end,
		},
		Spacer(),
		hl = { fg = colors.main_special, bg = bg },
	}

	return {
		Lsp_Part,
		TS_Part,
		Ruler_Part,
	}
end)

return {
	LeftPart,
	MiddlePart,
	RightPart,
}
