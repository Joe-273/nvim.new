local gitsigns = require('gitsigns')

local utils = require('kaiho.helper.utils')

local opts = { noremap = true, silent = true }
local group_map = utils.group_map
local build_func = utils.build_func

local arg = { vim.fn.line('.'), vim.fn.line('v') }
local stage_choose_hunk = build_func(gitsigns.stage_hunk, arg)
local reset_choose_hunk = build_func(gitsigns.reset_hunk, arg)
local prev_hunk = build_func(gitsigns.nav_hunk, 'prev')
local next_hunk = build_func(gitsigns.nav_hunk, 'next')
group_map('Hunk', {
	-- visual mode
	{ 'v', '<leader>hs', stage_choose_hunk, '[s]tage hunk', opts },
	{ 'v', '<leader>hr', reset_choose_hunk, '[r]eset hunk', opts },
	-- normal mode
	{ 'n', '<leader>hs', gitsigns.stage_hunk, '[s]tage hunk', opts },
	{ 'n', '<leader>hS', gitsigns.stage_buffer, '[S]tage buffer', opts },
	{ 'n', '<leader>hr', gitsigns.reset_hunk, '[r]eset hunk', opts },
	{ 'n', '<leader>hR', gitsigns.reset_buffer, '[R]eset buffer', opts },
	{ 'n', '<leader>hu', gitsigns.undo_stage_hunk, '[u]ndo stage hunk', opts },
	{ 'n', '<leader>hp', gitsigns.preview_hunk, '[p]review hunk', opts },
	{ 'n', '<leader>hb', gitsigns.blame_line, '[b]lame line', opts },
	{ 'n', '[h', prev_hunk, 'previous [h]unk', opts },
	{ 'n', ']h', next_hunk, 'next [h]unk', opts },
})

local git_diff_last_commit = build_func(gitsigns.diffthis, '@')
group_map('Git', {
	{ 'n', '<leader>gd', gitsigns.diffthis, '[d]iff against index', opts },
	{ 'n', '<leader>gD', git_diff_last_commit, '[D]iff against last commit', opts },
})

group_map('Git Toggle', {
	{ 'n', '<leader>tb', gitsigns.toggle_current_line_blame, '[b]lame line' },
	{ 'n', '<leader>ts', gitsigns.toggle_signs, '[s]ign' },
	{ 'n', '<leader>td', gitsigns.toggle_deleted, '[d]eleted' },
})
