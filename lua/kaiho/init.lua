require('kaiho.config.initial') -- User Preferences
require('kaiho.config.options')
require('kaiho.config.keymaps')
require('kaiho.config.autocmds')

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
---@diagnostic disable-next-line: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
	local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
			{ out, 'WarningMsg' },
			{ '\nPress any key to exit...' },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

function _G.set_wezterm_theme(theme)
	-- 生成 Base64 编码（确保无换行符）
	local encoded = vim.fn.system({ 'echo', '-n', theme }):gsub('\n', '')
	encoded = vim.fn.system({ 'base64', '-w0' }, encoded)

	-- 构造 OSC 转义序列
	local osc = string.format(
		'\x1b]1337;SetUserVar=theme=%s\x07', -- \x1b=ESC, \x07=BEL
		encoded
	)

	-- 直接向终端发送原始字节（绕过 Shell 解析）
	vim.api.nvim_chan_send(vim.v.stderr, osc)
end

-- [[ Configure and install plugins ]]
require('lazy').setup({
	spec = {
		{ import = 'kaiho.plugins' },
	},
	ui = {
		border = 'rounded',
		backdrop = 100,
	},
})
