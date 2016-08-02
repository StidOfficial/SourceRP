local GameUI = {IsOpen = false, IsClose = true}

hook.Add("Think", "GMGameUI", function()
	if gui.IsGameUIVisible() then
		if GameUI.IsOpen == false then
			GameUI.IsOpen = true
			GameUI.IsClose = false
			GAMEMODE:OpenGameUI()
			hook.Call("OpenGameUI")
		end
	else
		if GameUI.IsClose == false then
			GameUI.IsOpen = false
			GameUI.IsClose = true
			GAMEMODE:CloseGameUI()
			hook.Call("CloseGameUI")
		end
	end
end)