---@alias NewHlgroups [string, vim.api.keyset.highlight][]
---@alias HlsLink [string[], string][]
---@alias ChangeHls [string[],string][]

local function hex2int(hex)
	return tonumber(hex:match('^#?(%x+)$'), 16)
end

---@param tbl NewHlgroups
local function new_hlgroups(tbl)
	for _, hlgroup_map in pairs(tbl) do
		local name = hlgroup_map[1]
		local val = hlgroup_map[2]
		vim.api.nvim_set_hl(0, name, val)
	end
end

---@param tbl HlsLink
local function hls_link(tbl)
	for _, link_map in pairs(tbl) do
		local groups_arr = link_map[1]
		local target_group = link_map[2]
		for _, group in pairs(groups_arr) do
			vim.api.nvim_set_hl(0, group, { link = target_group })
		end
	end
end

---@param tbl ChangeHls
local function change_hls_gui(tbl)
	for _, hlgroups_map in pairs(tbl) do
		local hlgroups = hlgroups_map[1]
		local change_txt = hlgroups_map[2]
		for _, group in pairs(hlgroups) do
			local cmd = 'highlight ' .. group .. ' ' .. change_txt
			vim.cmd(cmd)
		end
	end
end

return {
	hex2int = hex2int,
	new_hlgroups = new_hlgroups,
	hls_link = hls_link,
	change_hls_gui = change_hls_gui,
}
