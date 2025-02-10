-- Docs: https://github.com/uga-rosa/translate.nvim/blob/main/doc/translate-nvim.txt
require('translate').setup({
	silent = true,
	default = {
		-- output = 'insert',
		command = 'translate_shell',
		parse_after = 'head,out_to_noice',
	},
	preset = {
		output = {
			floating = {
				border = 'rounded',
			},
		},
	},
	parse_after = {
		out_to_noice = {
			cmd = function(lines)
				local content = ' 󰊿 Translate\n' .. table.concat(lines, '\n'):match('^%s*(.-)%s*$')
				vim.notify(content)
				return lines
			end,
		},
	},
})
