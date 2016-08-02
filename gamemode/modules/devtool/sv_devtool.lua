local DevToolOpenList = {}

util.AddNetworkString("DevToolLuaRunServer")
net.Receive("DevToolLuaRunServer", function(len, ply)
	if (IsValid(ply) and ply:IsPlayer() && ply:IsSuperAdmin()) then
		RunString(net.ReadString(), "DevToolConsole")
	end
end)

util.AddNetworkString("DevToolLuaRunShared")
net.Receive("DevToolLuaRunShared", function(len, ply)
	if (IsValid(ply) and ply:IsPlayer() && ply:IsSuperAdmin()) then
		local LuaCode = net.ReadString()
		RunString(LuaCode, "DevToolConsole")
		
		for k, v in pairs(player.GetAll()) do
			v:SendLua(LuaCode)
		end
	end
end)

util.AddNetworkString("DevToolLuaRunClient")
net.Receive("DevToolLuaRunClient", function(len, ply)
	if (IsValid(ply) and ply:IsPlayer() && ply:IsSuperAdmin()) then
		local Player = net.ReadEntity()
		local LuaCode = net.ReadString()
		
		if Player:IsPlayer() then
			Player:SendLua(LuaCode)
		else
			for k, v in pairs(player.GetAll()) do
				v:SendLua(LuaCode)
			end
		end
	end
end)

util.AddNetworkString("DevToolConsoleServerAdd")
function GM:OnConsolePrint(text, file, line)
	for k, v in pairs(DevToolOpenList) do
		net.Start("DevToolConsoleServerAdd")
			net.WriteString("info")
			net.WriteString(text)
			net.WriteString(file)
			net.WriteFloat(line)
		net.Send(k)
	end
end

function GM:OnConsolePrintError(text, file, line)
	for k, v in pairs(DevToolOpenList) do
		net.Start("DevToolConsoleServerAdd")
			net.WriteString("error")
			net.WriteString(text)
			net.WriteString(file)
			net.WriteFloat(line)
		net.Send(k)
	end
end

util.AddNetworkString("DevToolHookServerAdd")
function GM:OnHookAdd(event_name, name)
	for k, v in pairs(DevToolOpenList) do
		net.Start("DevToolHookServerAdd")
			net.WriteString(event_name)
			net.WriteString(name)
		net.Send(k)
	end
end

util.AddNetworkString("DevToolHTTPServerAdd")
function GM:OnHTTPRequest(method, url)
	for k, v in pairs(DevToolOpenList) do
		net.Start("DevToolHTTPServerAdd")
			net.WriteString(method)
			net.WriteString(url)
		net.Send(k)
	end
end

util.AddNetworkString("DevToolOpen")
util.AddNetworkString("DevToolConsoleServer")
util.AddNetworkString("DevToolHookServer")
util.AddNetworkString("DevToolHTTPServer")
net.Receive("DevToolOpen", function(len, ply)
	if (IsValid(ply) and ply:IsPlayer()) then
		if !ply:IsSuperAdmin() then return end
		DevToolOpenList[ply] = true
		
		net.Start("DevToolConsoleServer")
			net.WriteTable(console.GetInfo())
			net.WriteTable(console.GetError())
		net.Send(ply)
		
		net.Start("DevToolHookServer")
			net.WriteTable(hook.GetAll())
		net.Send(ply)
		
		net.Start("DevToolHTTPServer")
			net.WriteTable(http.GetRequests())
		net.Send(ply)
	end
end)

util.AddNetworkString("DevToolClose")
net.Receive("DevToolClose", function(len, ply)
	if (IsValid(ply) and ply:IsPlayer()) then
		if !ply:IsSuperAdmin() then return end
		DevToolOpenList[ply] = nil
	end
end)