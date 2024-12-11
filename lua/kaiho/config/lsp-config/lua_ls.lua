local lua_ls = {
	settings = {
		Lua = {
			hint = {
				enable = true,
				arrayIndex = 'Enable',
				setType = true,
			},
			completion = { callSnippet = 'Replace' },
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
}

return lua_ls
