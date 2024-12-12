local heirline_utils = require('kaiho.plugins.heirline.utils')

local colors = heirline_utils.colors

local vimode_names = {
	n = 'N',
	no = 'N?',
	nov = 'N?',
	noV = 'N?',
	['no\22'] = 'N?',
	niI = 'Ni',
	niR = 'Nr',
	niV = 'Nv',
	nt = 'Nt',
	v = 'V',
	vs = 'Vs',
	V = 'V_',
	Vs = 'Vs',
	['\22'] = '^V',
	['\22s'] = '^V',
	s = 'S',
	S = 'S_',
	['\19'] = '^S',
	i = 'I',
	ic = 'Ic',
	ix = 'Ix',
	R = 'R',
	Rc = 'Rc',
	Rx = 'Rx',
	Rv = 'Rv',
	Rvc = 'Rv',
	Rvx = 'Rv',
	c = 'C',
	cv = 'Ex',
	r = '...',
	rm = 'M',
	['r?'] = '?',
	['!'] = '!',
	t = 'T',
}

local vimode_colors = {
	n = colors.main_operator,
	i = colors.main_string,
	v = colors.main_statement,
	V = colors.main_statement,
	['\22'] = colors.main_statement,
	c = colors.main_function,
	s = colors.main_function,
	S = colors.main_function,
	['\19'] = colors.main_function,
	R = colors.main_special,
	r = colors.main_special,
	['!'] = colors.main_constant,
	t = colors.main_constant,
}

local ViMode = {
	---@return string
	current_color = function()
		return vimode_colors[vim.fn.mode(1):sub(1, 1)]
	end,
	---@return string
	current_name = function()
		return vimode_names[vim.fn.mode(1)]
	end,
}

local FileIcon = {
	init = function(self)
		self = self or {}
		self.filename = vim.api.nvim_buf_get_name(0)
		local filename = vim.fn.fnamemodify(self.filename, ':t')
		local extension = vim.fn.fnamemodify(self.filename, ':e')
		self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
	end,
	provider = function(self)
		return self.icon and (' ' .. self.icon .. ' ')
	end,
	hl = function(self)
		return {
			fg = self.icon_color,
		}
	end,
}

local FileName = {
	init = function(self)
		self = self or {}
		self.filename = vim.api.nvim_buf_get_name(0)
	end,
	provider = function(self)
		local filename = vim.fn.fnamemodify(self.filename, ':t')
		local term_id = filename:match('::toggleterm::(%d+)$')

		if filename == '' then
			return 'NONE'
		elseif filename == 'neo-tree filesystem [1]' then
			return 'NEO-TREE'
		elseif term_id then
			return 'TREMINAL_' .. term_id
		else
			return filename
		end
	end,
}

local FileFlag = {
	{
		condition = function()
			return vim.bo.modified
		end,
		provider = '',
		hl = { fg = colors.main_string },
	},
	{
		condition = function()
			return not vim.bo.modifiable or vim.bo.readonly
		end,
		provider = '',
		hl = { fg = colors.main_constant },
	},
}
return {
	ViMode = ViMode,
	FileIcon = FileIcon,
	FileFlag = FileFlag,
	FileName = FileName,
}
