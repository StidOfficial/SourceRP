local oldHookAdd = hook.Add
local Hooks = {}

function GM:OnHookAdd(event_name, name)
end

function hook.GetAll()
	return Hooks
end

function hook.Add(event_name, name, func)
	if (!isstring(event_name) || !isfunction(func)) then return end

	if (Hooks[event_name] == nil) then
			Hooks[event_name] = {}
	end
	
	Hooks[event_name][tostring(name)] = true
	if GAMEMODE then
		GAMEMODE:OnHookAdd(event_name, tostring(name))
	end

	oldHookAdd(event_name, name, func)
end