-- Bring the workspace to the focused monitor and switch to it;
-- pressing the bind for the already-active workspace toggles back
-- to the previous one.
local function open_workspace_on_current_monitor(workspace)
	return function()
		local active = hl.get_active_workspace()
		if active ~= nil and active.id == workspace then
			hl.dispatch(hl.dsp.focus({ workspace = "previous" }))
			return
		end
		local monitor = hl.get_active_monitor()
		hl.dispatch(hl.dsp.workspace.move({ workspace = workspace, monitor = monitor.name }))
		hl.dispatch(hl.dsp.focus({ workspace = workspace }))
	end
end

local M = {
	open_workspace_on_current_monitor = open_workspace_on_current_monitor,
}

return M
