local function set_shell()
	if vim.fn.has('win32') == 1 then
		return 'pwsh'
	else
		return '/bin/zsh'
	end
end

require('toggleterm').setup({
	size = function(term)
		if term.direction == 'horizontal' then
			return 20
		elseif term.direction == 'vertical' then
			return vim.o.columns * 0.4
		end
	end,
	-- open_mapping = [[<c-\>]],
	shade_terminals = false,
	shell = set_shell,
	winblend = 0,
	highlights = {
		WinSeparator = { link = 'WinSeparator' },
		StatusLine = { link = 'StatusLine' },
		StatusLineNC = { link = 'StatusLineNC' },
	},
})
