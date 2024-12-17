local conditions = require('heirline.conditions')

local icons = require('kaiho.helper.icons')
local utils = require('kaiho.helper.utils')
local colors = require('kaiho.helper.colors')
local public = require('kaiho.plugins.heirline.public')

local edge_char = icons.edge_char
local diag_sign = icons.diag_sign

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

local function Left_Structor(p1, p2, p3)
	local C = colors.get_colors()
	local bg = C.main_dark_bg
	local fg = C.main_dark_fg
	local mid_rate = 0.65
	local high_rate = 0.8
	local vimode = public.vimode
	local lighten = utils.lighten

	local function edge_char_creator(hl)
		hl = hl or nil
		return {
			provider = edge_char.right,
			hl = hl,
		}
	end

	return {
		{
			init = function(self)
				self.vicolor = vimode.current_color()
			end,
			public.spacer_creator(),
			p1,
			edge_char_creator(function(self)
				return { fg = self.vicolor }
			end),
			hl = function(self)
				return { fg = self.vicolor }
			end,
		},
		{
			public.spacer_creator(),
			p2,
			edge_char_creator(),
		},
		{
			public.spacer_creator(),
			p3,
			edge_char_creator(),
		},
	}
end

local function statusline_creator()
	local C = colors.get_colors()
	local bg = C.main_dark_bg
	local fg = C.main_dark_fg
	local mid_rate = 0.65
	local high_rate = 0.8

	local ViMode_Part = {
		{ provider = '  ' },
		{
			provider = function()
				return '%2(' .. public.vimode.current_name() .. '%) '
			end,
		},
		{
			provider = edge_char.right,
			hl = function()
				local vicolor = public.vimode.current_color()
				return { fg = vicolor, bg = utils.lighten(bg, mid_rate, vicolor) }
			end,
		},
		hl = function()
			return {
				fg = bg,
				bg = public.vimode.current_color(),
				bold = true,
			}
		end,
	}

	local BufferName_Part = {
		public.spacer_creator(),
		public.fileicon_creator(),
		public.filename_creator(),
		public.spacer_creator(),
		{
			{
				condition = function()
					return vim.bo.modified
				end,
				provider = '',
				hl = { fg = C.main_string },
			},
			{
				condition = function()
					return not vim.bo.modifiable or vim.bo.readonly
				end,
				provider = '',
				hl = { fg = C.main_constant },
			},
		},
		public.spacer_creator(' ', function()
			return vim.bo.modified or not vim.bo.modifiable or vim.bo.readonly
		end),
		{
			provider = edge_char.right,
			hl = function()
				local vicolor = public.vimode.current_color()
				local dyn_bg = conditions.is_git_repo() and utils.lighten(bg, high_rate, vicolor) or bg
				return { fg = utils.lighten(bg, mid_rate, vicolor), bg = dyn_bg }
			end,
		},
		hl = function()
			local vicolor = public.vimode.current_color()
			return {
				fg = C.main_light_fg,
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
		flexible = 4,
		{
			{
				provider = function(self)
					return '  ' .. self.status_dict.head
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
				hl = { fg = C.git_added },
			},
			{
				provider = function(self)
					local count = self.status_dict.removed or 0
					return count > 0 and ('-' .. count)
				end,
				hl = { fg = C.git_deleted },
			},
			{
				provider = function(self)
					local count = self.status_dict.changed or 0
					return count > 0 and ('~' .. count)
				end,
				hl = { fg = C.git_changed },
			},
			{
				condition = function(self)
					return self.has_changes
				end,
				provider = ') ',
			},
			{
				provider = edge_char.right,
				hl = function()
					local vicolor = public.vimode.current_color()
					return { fg = utils.lighten(bg, high_rate, vicolor), bg = bg }
				end,
			},
		},
		{
			{
				provider = function(self)
					local count = self.status_dict.added or 0
					return count > 0 and ('+' .. count)
				end,
				hl = { fg = C.git_added },
			},
			{
				provider = function(self)
					local count = self.status_dict.removed or 0
					return count > 0 and ('-' .. count)
				end,
				hl = { fg = C.git_deleted },
			},
			{
				provider = function(self)
					local count = self.status_dict.changed or 0
					return count > 0 and ('~' .. count)
				end,
				hl = { fg = C.git_changed },
			},
			{
				provider = edge_char.right,
				hl = function()
					local vicolor = public.vimode.current_color()
					return { fg = utils.lighten(bg, high_rate, vicolor), bg = bg }
				end,
			},
		},
		{
			{
				provider = edge_char.right,
				hl = function()
					local vicolor = public.vimode.current_color()
					return { fg = utils.lighten(bg, high_rate, vicolor), bg = bg }
				end,
			},
		},
		hl = function()
			local vicolor = public.vimode.current_color()
			return {
				fg = fg,
				bg = utils.lighten(bg, high_rate, vicolor),
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

		public.spacer_creator('  '),
		{
			provider = function(self)
				local dynamic_space = (self.warnings > 0 or self.info > 0 or self.hints > 0) and ' ' or ''
				return self.errors > 0 and (self.error_icon .. self.errors .. dynamic_space)
			end,
			hl = { fg = C.diagnostic_error },
		},
		{
			provider = function(self)
				local dynamic_space = self.info > 0 or self.hints > 0 and ' ' or ''
				return self.warnings > 0 and (self.warn_icon .. self.warnings .. dynamic_space)
			end,
			hl = { fg = C.diagnostic_warn },
		},
		{
			provider = function(self)
				local dynamic_space = self.hints > 0 and ' ' or ''
				return self.info > 0 and (self.info_icon .. self.info .. dynamic_space)
			end,
			hl = { fg = C.diagnostic_info },
		},
		{
			provider = function(self)
				return self.hints > 0 and (self.hint_icon .. self.hints)
			end,
			hl = { fg = C.diagnostic_hint },
		},
		hl = { fg = C.main_operator, bg = bg },
	}

	local Left_Part = {
		ViMode_Part,
		BufferName_Part,
		Git_Part,
		Diagnostics_Part,
	}

	local Fill = { provider = '%=', hl = { fg = fg, bg = bg } }

	local WorkDir = {
		flexible = 1,
		{
			provider = function()
				local cwd = vim.fn.getcwd()
				cwd = vim.fn.fnamemodify(cwd, ':~')
				local path_separator = package.config:sub(1, 1)
				local trail = cwd:sub(-1) == path_separator and '' or path_separator
				return '  ' .. cwd .. trail .. ' '
			end,
		},
		{
			provider = '',
		},
		hl = { fg = C.main_comment, bg = bg },
	}

	local Middle_Part = {
		Fill,
		WorkDir,
		Fill,
	}

	local Ruler_Part = {
		flexible = 2,
		{
			{
				provider = edge_char.left,
				hl = function()
					local vicolor = public.vimode.current_color()
					local dyn_bg = check_treesitter() and utils.lighten(bg, high_rate, vicolor) or bg
					return { fg = vicolor, bg = dyn_bg }
				end,
			},
			{
				provider = ' %7(%l/%3L%):%2c | %P ',
				hl = function()
					local vicolor = public.vimode.current_color()
					return { fg = bg, bg = vicolor }
				end,
			},
		},
		{
			provider = '',
		},
	}

	local TS_Part = {
		condition = check_treesitter,
		flexible = 3,
		{
			{
				provider = edge_char.left,
				hl = function()
					local vicolor = public.vimode.current_color()
					return { fg = utils.lighten(bg, high_rate, vicolor), bg = bg }
				end,
			},
			{
				provider = function(self)
					local content = ' 󰪥 TS('
						.. require('nvim-treesitter.parsers').get_buf_lang(vim.api.nvim_get_current_buf())
						.. ') '
					self.content_size = #content
					return content
				end,
			},
		},
		{
			{
				provider = edge_char.left,
				hl = function()
					local vicolor = public.vimode.current_color()
					return { fg = utils.lighten(bg, high_rate, vicolor), bg = bg }
				end,
			},
		},
		hl = function()
			local vicolor = public.vimode.current_color()
			return {
				fg = fg,
				bg = utils.lighten(bg, high_rate, vicolor),
			}
		end,
	}

	local Lsp_Part = {
		condition = function()
			return conditions.is_active() and conditions.lsp_attached()
		end,
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
		public.spacer_creator(),
		hl = { fg = C.main_function, bg = bg },
	}

	local Right_Part = {
		Lsp_Part,
		TS_Part,
		Ruler_Part,
	}

	return {
		Left_Part,
		Middle_Part,
		Right_Part,
	}
end

return statusline_creator
