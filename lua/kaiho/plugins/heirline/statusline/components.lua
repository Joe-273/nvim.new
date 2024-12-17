local conditions = require('heirline.conditions')

local colors = require('kaiho.helper.colors')
local public = require('kaiho.plugins.heirline.public')
local icons = require('kaiho.helper.icons')

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

local function components_creator()
	local C = colors.get_colors()

	local Vimode = {
		flexible = 5,
		{
			provider = function()
				return '  %-2(' .. public.vimode.current_name() .. '%)'
			end,
		},
		{
			provider = function()
				return ''
			end,
		},
	}

	local BufferName = {
		public.spacer_creator(),
		public.fileicon_creator(),
		public.filename_creator(),
		{
			{
				condition = function()
					return vim.bo.modified
				end,
				provider = '  ',
				hl = { fg = C.main_string },
			},
			{
				condition = function()
					return not vim.bo.modifiable or vim.bo.readonly
				end,
				provider = '  ',
				hl = { fg = C.main_constant },
			},
		},
	}

	local Git = {
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
				provider = ')',
			},
		},
		{
			{
				provider = function(self)
					return '  ' .. self.status_dict.head
				end,
			},
		},
	}

	local Diagnostics = {
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

		{
			provider = function(self)
				return self.errors > 0 and (' ' .. self.error_icon .. self.errors)
			end,
			hl = { fg = C.diagnostic_error },
		},
		{
			provider = function(self)
				return self.warnings > 0 and (' ' .. self.warn_icon .. self.warnings)
			end,
			hl = { fg = C.diagnostic_warn },
		},
		{
			provider = function(self)
				return self.info > 0 and (' ' .. self.info_icon .. self.info)
			end,
			hl = { fg = C.diagnostic_info },
		},
		{
			provider = function(self)
				return self.hints > 0 and (' ' .. self.hint_icon .. self.hints)
			end,
			hl = { fg = C.diagnostic_hint },
		},
	}

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
	}

	local Ruler = {
		flexible = 2,
		{
			provider = '%7(%l/%3L%):%2c | %P ',
		},
		{
			provider = '',
		},
	}

	local Ts = {
		condition = check_treesitter,
		flexible = 3,
		{
			provider = function()
				return '󰪥 TS(' .. require('nvim-treesitter.parsers').get_buf_lang(vim.api.nvim_get_current_buf()) .. ') '
			end,
		},
		{
			provider = '',
		},
	}

	local Lsp = {
		condition = conditions.lsp_attached,
		update = { 'LspAttach', 'LspDetach' },
		{
			provider = function()
				local names = {}
				for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
					table.insert(names, server.name)
				end
				return ' 󰲒 (' .. table.concat(names, ' ') .. ') '
			end,
		},
	}

	return {
		Vimode = Vimode,
		BufferName = BufferName,
		Git = Git,
		Diagnostics = Diagnostics,
		WorkDir = WorkDir,
		Ruler = Ruler,
		Ts = Ts,
		Lsp = Lsp,
	}
end

return components_creator
