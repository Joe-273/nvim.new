local cmp = require('cmp')
local luasnip = require('luasnip')

require('luasnip.loaders.from_vscode').lazy_load() -- Load friend snippets plugin

-- Init lspkind plugin and overwrite its default icons
local lspkind = require('lspkind')
lspkind.init({ symbol_map = require('kaiho.helper.icons').kind_icons })

local function cmp_format(entry, item)
	local color_item = require('nvim-highlight-colors').format(entry, { kind = item.kind })
	item = lspkind.cmp_format()(entry, item)

	if color_item.abbr_hl_group then
		item.kind_hl_group = color_item.abbr_hl_group
	end

	return item
end

cmp.setup({
	formatting = {
		format = cmp_format,
		expandable_indicator = true,
		fields = { 'abbr', 'kind', 'menu' },
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	completion = { completeopt = 'menu,menuone,noinsert' },
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<C-n>'] = cmp.mapping.select_next_item(), -- Select the [n]ext item
		['<C-p>'] = cmp.mapping.select_prev_item(), -- Select the [p]revious item
		['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept ([y]es) the completion.

		-- Scroll the documentation window [u]p / [d]own
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),

		-- <c-l> will move you to the right of each of the expansion locations.
		-- <c-h> is similar, except moving you backwards.
		['<C-l>'] = cmp.mapping(function()
			if luasnip.locally_jumpable(1) then
				luasnip.jump(1)
			end
		end, { 'i', 's' }),
		['<C-h>'] = cmp.mapping(function()
			if luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			end
		end, { 'i', 's' }),

		-- <C-e> will close cmp menu
		['<C-e>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.abort()
			else
				fallback()
			end
		end, { 'i', 's' }),

		-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
		--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
	}),
	sources = {
		{
			name = 'lazydev',
			group_index = 0,
		},
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'buffer' },
		{ name = 'path' },
	},
})
