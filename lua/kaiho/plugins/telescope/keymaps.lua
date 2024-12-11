local Builtin = require('telescope.builtin')

local Pickers = require('kaiho.plugins.telescope.preference.pickers')
local utils = require('kaiho.helper.utils')

local opts = { noremap = true, silent = true }
local build_func = utils.build_func
local group_map = utils.group_map

local find_nvim_files = build_func(Pickers.find_files, { cwd = vim.fn.stdpath('config') })
group_map('Find', {
	-- Use custom Pickers
	{ 'n', '<leader><leader>', Pickers.buffers, 'existing buffer' },
	{ 'n', '<leader>ff', Pickers.find_files, '[f]iles', opts },
	{ 'n', '<leader>fw', Pickers.grep_string, 'current [w]ord', opts },
	{ 'n', '<leader>fl', Pickers.live_grep, 'by [l]ive_grep', opts },
	{ 'n', '<leader>f.', Pickers.oldfiles, 'Recent Files', opts },
	{ 'n', '<leader>ft', Pickers.find_todo, '[t]odo', opts },
	{ 'n', '<leader>fn', find_nvim_files, '[n]eovim files', opts },
	-- Use default Pickers
	-- {'n', '<leader><leader>', Builtin.buffers, 'existing buffer', opts},
	-- {'n', '<leader>ff', Builtin.find_files, '[f]iles', opts},
	-- {'n', '<leader>fw', Builtin.grep_string, 'current [w]ord', opts},
	-- {'n', '<leader>fl', Builtin.live_grep, 'by [l]ive_grep', opts},
	-- {'n', '<leader>f.', Builtin.oldfiles, 'Recent Files ("." for repeat)', opts},
	-- {'n', '<leader>fn', function() Builtin.find_files({ cwd = vim.fn.stdpath('config') }) end, '[n]eovim files', opts},
	{ 'n', '<leader>fh', Builtin.help_tags, '[h]elp', opts },
	{ 'n', '<leader>fk', Builtin.keymaps, '[k]eymaps', opts },
	{ 'n', '<leader>fT', Builtin.builtin, 'Select [T]elescope', opts },
	{ 'n', '<leader>fr', Builtin.resume, '[r]esume', opts },
})
