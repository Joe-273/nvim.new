local default_im = vim.g.DefaultIM
local im_select_command = 'im-select'

local prev_im = nil

local function switch_default_im()
	local ok, im = pcall(vim.fn.system, im_select_command)
	if not ok then
		return
	end
	prev_im = im
	return pcall(vim.fn.system, im_select_command .. ' ' .. default_im)
end

local function restore_prev_im()
	if prev_im then
		return pcall(vim.fn.system, im_select_command .. ' ' .. prev_im)
	end
	return pcall(vim.fn.system, im_select_command .. ' ' .. default_im)
end

return {
	switch_default_im = switch_default_im,
	restore_prev_im = restore_prev_im,
}
