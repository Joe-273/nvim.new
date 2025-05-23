---@diagnostic disable: undefined-field
local heirline_utils = require('heirline.utils')

local icons = require('kaiho.helper.icons')
local utils = require('kaiho.helper.utils')
local colors = require('kaiho.helper.colors')
local public = require('kaiho.plugins.heirline.public')

local edge_char = icons.edge_char

-- Function used to detect whether exist trouble window
local function is_trouble_window(win)
	local bufnr = vim.api.nvim_win_get_buf(win)
	return vim.bo[bufnr].filetype == 'trouble'
end
local function is_regular_window(win)
	local win_config = vim.api.nvim_win_get_config(win)
	return not win_config.relative or win_config.relative == ''
end
local function is_right_split_window(win)
	local win_config = vim.api.nvim_win_get_config(win)
	return win_config.split == 'right'
end

local function tabline_creator()
	local C = colors.get_colors()

	local bg = C.main_dark_bg
	local fg = C.main_dark_fg

	local active_colors = {
		fg = C.main_light_fg,
		bg = function()
			local vicolor = public.vimode.current_color()
			return utils.lighten(bg, 0.65, vicolor)
		end,
	}
	local inactive_colors = {
		fg = utils.darken(fg, 0.65),
		bg = bg,
	}

	-- Retrieve buffers
	local get_bufs = function()
		return vim.tbl_filter(function(bufnr)
			return vim.api.nvim_get_option_value('buflisted', { buf = bufnr })
		end, vim.api.nvim_list_bufs())
	end
	-- initialize the buflist cache
	local buflist_cache = {}
	-- autocmd to update buflist_cache
	vim.api.nvim_create_autocmd({ 'UIEnter', 'BufEnter', 'BufAdd', 'BufDelete', 'ModeChanged' }, {
		callback = function()
			vim.schedule(function()
				local buffers = get_bufs()
				for i, v in ipairs(buffers) do
					buflist_cache[i] = v
				end
				for i = #buffers + 1, #buflist_cache do
					buflist_cache[i] = nil
				end

				-- check how many buffers we have and set showtabline accordingly
				if #buflist_cache > 1 then
					vim.o.showtabline = 2 -- always
				elseif vim.o.showtabline ~= 1 then -- don't reset the option if it's already at default value
					vim.o.showtabline = 1 -- only when #tabpages > 1
				end
			end)
		end,
	})

	local TablinePicker = {
		condition = function(self)
			return self._show_picker
		end,
		init = function(self)
			local bufname = vim.api.nvim_buf_get_name(self.bufnr)
			bufname = vim.fn.fnamemodify(bufname, ':t')
			local label = bufname:sub(1, 1)
			local i = 2
			while self._picker_labels[label] do
				if i > #bufname then
					break
				end
				label = bufname:sub(i, i)
				i = i + 1
			end
			self._picker_labels[label] = self.bufnr
			self.label = label
		end,
		provider = function(self)
			return self.label .. ' '
		end,
		hl = { fg = C.main_statement, bold = true },
	}

	local function pick_buffer()
		local tabline = require('heirline').tabline
		local buflist = tabline._buflist[1]
		buflist._picker_labels = {}
		buflist._show_picker = true
		vim.cmd.redrawtabline()
		local char = vim.fn.getcharstr()
		local bufnr = buflist._picker_labels[char]
		if bufnr then
			vim.api.nvim_win_set_buf(0, bufnr)
		end
		buflist._show_picker = false
		vim.cmd.redrawtabline()
	end

	utils.map('n', '<leader>pw', pick_buffer, 'pick [w]inbar buffer', { noremap = true, silent = true })

	local BufferIconAndName = {
		init = function(self)
			local bufnr = self.bufnr and self.bufnr or 0
			self.filename = vim.api.nvim_buf_get_name(bufnr)
		end,
		on_click = {
			callback = function(_, minwid, _, button)
				if button == 'm' then -- close on mouse middle click
					vim.schedule(function()
						-- vim.api.nvim_buf_delete(minwid, { force = false })
						require('bufdelete').bufdelete(minwid, false) -- use bufdelete plugin
					end)
				else
					vim.api.nvim_win_set_buf(0, minwid)
				end
			end,
			minwid = function(self)
				return self.bufnr
			end,
			name = 'heirline_tabline_buffer_callback',
		},
		TablinePicker,
		{
			condition = function(self)
				return not self._show_picker
			end,
			public.fileicon_creator(),
		},
		{
			public.filename_creator(),
			hl = function(self)
				return { italic = self.is_active }
			end,
		},
	}

	local BufferFlag = {
		{
			condition = function(self)
				return not vim.api.nvim_get_option_value('modified', { buf = self.bufnr })
			end,
			provider = ' ✘ ',
			on_click = {
				callback = function(_, minwid)
					vim.schedule(function()
						require('bufdelete').bufdelete(minwid, false) -- use bufdelete plugin
						vim.cmd.redrawtabline()
					end)
				end,
				minwid = function(self)
					return self.bufnr
				end,
				name = 'heirline_tabline_close_buffer_callback',
			},
		},
		{
			condition = function(self)
				return vim.api.nvim_get_option_value('modified', { buf = self.bufnr })
			end,
			provider = '  ',
			hl = { fg = C.main_string },
		},
		{
			condition = function(self)
				return not vim.api.nvim_get_option_value('modifiable', { buf = self.bufnr })
					or vim.api.nvim_get_option_value('readonly', { buf = self.bufnr })
			end,
			provider = '  ',
			hl = { fg = C.main_constant },
		},
	}
	local BufferBlock = heirline_utils.surround({ edge_char.left, edge_char.right }, function(self)
		return self.is_active and active_colors.bg() or inactive_colors.bg
	end, {
		public.spacer_creator(),
		BufferIconAndName,
		BufferFlag,
	})

	local NeotreeOffset = {
		condition = function(self)
			local win = vim.api.nvim_tabpage_list_wins(0)[1]
			local bufnr = vim.api.nvim_win_get_buf(win)
			self.winid = win

			if vim.bo[bufnr].filetype == 'neo-tree' then
				self.title = '<-- Explore -->'
				self.hl = { fg = fg, bg = C.main_dark_bg, bold = true }
				return true
			end
		end,

		{
			provider = function(self)
				local title = self.title
				local width = vim.api.nvim_win_get_width(self.winid)
				local pad = math.ceil((width - #title) / 2)
				return string.rep(' ', pad) .. title .. string.rep(' ', pad)
			end,
		},
		public.spacer_creator(),
	}
	local TroubleOffset = {
		condition = function(self)
			local wins = vim.api.nvim_tabpage_list_wins(0)
			for _, win in ipairs(wins) do
				if is_trouble_window(win) and is_regular_window(win) and is_right_split_window(win) then
					self.winid = win
					self.title = '<-- Outline -->'
					self.hl = { fg = fg, bg = C.main_dark_bg, bold = true }
					return true
				end
			end
		end,

		{
			provider = function(self)
				local title = self.title
				local width = vim.api.nvim_win_get_width(self.winid)
				local pad = math.ceil((width - #title) / 2)
				return string.rep(' ', pad) .. title .. string.rep(' ', pad)
			end,
		},
		public.spacer_creator(),
	}

	return {
		NeotreeOffset,
		heirline_utils.make_buflist({
			public.spacer_creator(),
			BufferBlock,
			hl = function(self)
				return { fg = self.is_active and C.main_fg or inactive_colors.fg, bg = bg }
			end,
		}, { provider = ' ', hl = { fg = fg, bg = bg } }, {
			provider = ' ',
			hl = { fg = fg, bg = bg },
		}),
		{ provider = '%=' },
		TroubleOffset,
	}
end

return tabline_creator
