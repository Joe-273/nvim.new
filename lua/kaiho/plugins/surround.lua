return {
	'echasnovski/mini.surround',
	event = 'VeryLazy',
	version = false,
	config = function()
		-- Examples:
		-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
		-- - sd'   - [S]urround [D]elete [']quotes
		-- - sr)'  - [S]urround [R]eplace [)] [']
		require('mini.surround').setup({
			mappings = { add = 'sa', delete = 'sd', replace = 'sr' },
		})
	end,
}
