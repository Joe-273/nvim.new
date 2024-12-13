local colors = require('kaiho.helper.colors')

local M = {}

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
	n = 'main_function',
	i = 'main_string',
	v = 'main_statement',
	V = 'main_statement',
	['\22'] = 'main_statement',
	c = 'main_operator',
	s = 'main_operator',
	S = 'main_operator',
	['\19'] = 'main_operator',
	R = 'main_special',
	r = 'main_special',
	['!'] = 'main_constant',
	t = 'main_constant',
}

M.vimode = {
	---@return string
	current_color = function()
		local c = colors.get_colors()
		return c[vimode_colors[vim.fn.mode(1):sub(1, 1)]]
	end,
	---@return string
	current_name = function()
		return vimode_names[vim.fn.mode(1)]
	end,
}

function M.spacer_creator(provider, condition)
	provider = provider or ' '
	condition = condition or function()
		return true
	end
	return { provider = provider, condition = condition }
end

function M.fileicon_creator()
	return {
		init = function(self)
			self.__filename = self.filename or vim.api.nvim_buf_get_name(0)
			local filename = vim.fn.fnamemodify(self.__filename, ':t')
			local extension = vim.fn.fnamemodify(self.__filename, ':e')
			self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
		end,
		provider = function(self)
			return self.icon and (self.icon .. ' ')
		end,
		hl = function(self)
			return {
				fg = self.icon_color,
			}
		end,
	}
end

function M.filename_creator()
	return {
		init = function(self)
			self.__filename = self.filename or vim.api.nvim_buf_get_name(0)
		end,
		provider = function(self)
			local filename = vim.fn.fnamemodify(self.__filename, ':t')
			-- NOTE: For personal situations only
			local term_id = filename:match('::toggleterm::(%d+)$') or filename:match('#toggleterm#(%d+)$')

			if filename == '' then
				return 'NONE'
			elseif filename == 'neo-tree filesystem [1]' then
				return 'NEO-TREE'
			elseif term_id then
				return 'TREMINAL#' .. term_id
			else
				return filename
			end
		end,
	}
end

return M
