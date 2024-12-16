require('kaiho.config.options')
require('kaiho.config.keymaps')
require('kaiho.config.autocmds')

-- NOTE: Choose a colorscheme here
---@type Colorschemes|string
vim.g.Colorscheme = 'tokyonight-moon'

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
