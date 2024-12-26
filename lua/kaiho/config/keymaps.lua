local utils = require('kaiho.helper.utils')

local opts = { noremap = true, silent = true }
local group_map = utils.group_map
local map = utils.map

map('n', '<Esc>', '<CMD>nohlsearch<CR>', 'Clear highlights')
map('t', '<Esc><Esc>', '<C-\\><C-n>', 'Exit terminal mode', opts)

group_map('Buffer', {
	-- Keybinds to process buffer
	{ 'n', '<C-q>', '<CMD>qall<CR>', '[q]uit all buffer', opts },
	{ 'n', '<leader>w', '<CMD>silent w<CR>', '[w]rite current buffer', opts },
	{ 'n', '<leader>W', '<CMD>wall<CR>', '[W]rite all buffers', opts },
	{ 'n', '<leader>r', '<CMD>e!<CR>', '[r]eflesh buffer', opts },
})

group_map('Window', {
	-- Adjust windows panel size
	{ 'n', '<S-A-l>', '3<C-w>>', 'Increase width', opts },
	{ 'n', '<S-A-h>', '3<C-w><', 'Decrease width', opts },
	{ 'n', '<S-A-j>', '2<C-w>+', 'Increase height', opts },
	{ 'n', '<S-A-k>', '2<C-w>-', 'Decrease height', opts },
	-- Keymaps to move normal window
	{ 'n', '<C-h>', '<C-w><C-h>', 'Move focus to the left', opts },
	{ 'n', '<C-l>', '<C-w><C-l>', 'Move focus to the right', opts },
	{ 'n', '<C-j>', '<C-w><C-j>', 'Move focus to the lower', opts },
	{ 'n', '<C-k>', '<C-w><C-k>', 'Move focus to the upper', opts },
	-- Keymaps to move terminal window
	{ 't', '<C-h>', '<CMD>wincmd h<CR>', 'Move focus to the left', opts },
	{ 't', '<C-j>', '<CMD>wincmd j<CR>', 'Move focus to the lower', opts },
	{ 't', '<C-k>', '<CMD>wincmd k<CR>', 'Move focus to the upper', opts },
	{ 't', '<C-l>', '<CMD>wincmd l<CR>', 'Move focus to the right', opts },
})
