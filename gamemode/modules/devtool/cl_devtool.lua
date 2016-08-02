function InitDevTool()
	DFrameDevTool = vgui.Create("DFrame")
	DFrameDevTool:SetPos(350, 30)
	DFrameDevTool:SetSize(ScrW() - 350 - 10, ScrH() - 85)
	DFrameDevTool:SetTitle("Dev Tool")
	DFrameDevTool:SetDraggable(true)
	-- TEMP
	DFrameDevTool:SetSizable(false)
	-- END
	DFrameDevTool:SetDeleteOnClose(true)
	function DFrameDevTool:OnClose()
		net.Start("DevToolClose")
		net.SendToServer()
	end
	
	DFrameDevTool:MakePopup()

	local DPropertySheet = vgui.Create("DPropertySheet", DFrameDevTool)
	DPropertySheet:Dock(TOP)
	DPropertySheet:SetSize(0, DFrameDevTool:GetTall() - 300)
	
	local DPropertySheetConsole = vgui.Create("DPropertySheet", DPropertySheet)
	DPropertySheetConsole:Dock(FILL)
	DPropertySheetConsole:DockMargin(5, 5, 5, 5)
	
	local DScrollPanelLogClient = vgui.Create("DScrollPanel", DPropertySheetConsole)
	DScrollPanelLogClient:Dock(TOP)
	DScrollPanelLogClient:DockMargin(5, 0, 5, 0)
	DScrollPanelLogClient:SetSize(DFrameDevTool:GetWide(), 500)
	
	function DFrameDevTool:AddClientLog(text, source, type)
		local DPanelLog = vgui.Create("DPanel", DScrollPanelLogClient)
		DPanelLog.Type = type
		DPanelLog:Dock(TOP)
		DPanelLog:SetSize(DFrameDevTool:GetWide() - 5 * 2, 25)
		function DPanelLog:Paint(w, h)
			if self.Type == "error" then
				surface.SetDrawColor(200, 0, 0, 100)
			elseif self.Type == "info" then
				surface.SetDrawColor(255, 255, 255)
			end
			surface.DrawRect(0, 0, w, h)
			
			if self.Type == "error" then
				surface.SetDrawColor(255, 0, 0)
			elseif self.Type == "info" then
				surface.SetDrawColor(131, 131, 131)
			end
			surface.DrawRect(5, 0, 5, h)
		end
		
		local Icon = vgui.Create("DPanel", DPanelLog)
		Icon:Dock(LEFT)
		Icon:DockMargin(15, 0, 5, 0)
		Icon:SetSize(20, 0)
		Icon.Material = Material("icon16/bullet_error.png")
		function Icon:Paint(w, h)
			if (DPanelLog.Type != "error") then return end

			surface.SetMaterial(self.Material)
			surface.SetDrawColor(255, 255, 255)
			surface.DrawTexturedRect(0, 7, 16, 16)
		end
		
		local RichTextLog = vgui.Create("RichText", DPanelLog)
		RichTextLog:Dock(FILL)
		RichTextLog:SetWrap(true)
		RichTextLog:SetTextInset(0, 0)
		RichTextLog:InsertColorChange(0, 0, 0, 255)
		RichTextLog:AppendText(text)
		RichTextLog:SetContentAlignment(7)
		RichTextLog:SetVerticalScrollbarEnabled(false)

		local DLabelScriptLink = vgui.Create("DLabelURL", DPanelLog)
		DLabelScriptLink:Dock(RIGHT)
		DLabelScriptLink:SetText(source)
		DLabelScriptLink:SetTextColor(Color(0, 0, 255))
		DLabelScriptLink:SizeToContentsX()
		
		DPanelLog:SetSize(0, RichTextLog:GetTall() + 10)
	end
	
	local DScrollPanelLogServer = vgui.Create("DScrollPanel", DPropertySheetConsole)
	DScrollPanelLogServer:Dock(TOP)
	DScrollPanelLogServer:DockMargin(5, 0, 5, 0)
	DScrollPanelLogServer:SetSize(DFrameDevTool:GetWide(), 500)
	
	function DFrameDevTool:AddServerLog(text, source, type)
		local DPanelLog = vgui.Create("DPanel", DScrollPanelLogServer)
		DPanelLog.Type = type
		DPanelLog:Dock(TOP)
		DPanelLog:SetMinimumSize(DFrameDevTool:GetWide() - 5 * 2, 24)
		function DPanelLog:Paint(w, h)
			if self.Type == "error" then
				surface.SetDrawColor(200, 0, 0, 100)
			elseif self.Type == "info" then
				surface.SetDrawColor(255, 255, 255)
			end
			surface.DrawRect(0, 0, w, h)
			
			if self.Type == "error" then
				surface.SetDrawColor(255, 0, 0)
			elseif self.Type == "info" then
				surface.SetDrawColor(131, 131, 131)
			end
			surface.DrawRect(5, 0, 5, h)
		end
		
		local Icon = vgui.Create("DPanel", DPanelLog)
		Icon:Dock(LEFT)
		Icon:DockMargin(15, 0, 5, 0)
		Icon:SetSize(20, 0)
		Icon.Material = Material("icon16/bullet_error.png")
		function Icon:Paint(w, h)
			if (DPanelLog.Type != "error") then return end

			surface.SetMaterial(self.Material)
			surface.SetDrawColor(255, 255, 255)
			surface.DrawTexturedRect(0, 7, 16, 16)
		end
		
		local RichTextLog = vgui.Create("RichText", DPanelLog)
		RichTextLog:Dock(FILL)
		RichTextLog:SetFontInternal("DermaDefault")
		RichTextLog:SetWrap(true)
		RichTextLog:SetTextInset(0, 0)
		RichTextLog:InsertColorChange(0, 0, 0, 255)
		RichTextLog:AppendText(text)
		RichTextLog:SetContentAlignment(7)
		RichTextLog:SetVerticalScrollbarEnabled(false)

		local DLabelScriptLink = vgui.Create("DLabelURL", DPanelLog)
		DLabelScriptLink:Dock(RIGHT)
		DLabelScriptLink:SetContentAlignment(9)
		DLabelScriptLink:SetText(source)
		DLabelScriptLink:SetTextColor(Color(0, 0, 255))
		DLabelScriptLink:SizeToContents()
	end
	
	DPropertySheetConsole:AddSheet("Client", DScrollPanelLogClient, "icon16/user.png")
	DPropertySheetConsole:AddSheet("Server", DScrollPanelLogServer, "icon16/server.png")
	
	DPropertySheet:AddSheet("Console", DPropertySheetConsole, "icon16/application_xp_terminal.png")

	--[[local DPropertySheetNetwork = vgui.Create("DPropertySheet", DPropertySheet)
	DPropertySheetNetwork:Dock(FILL)
	DPropertySheetNetwork:DockMargin(5, 5, 5, 5)
	
	local NetworkClientTrafficList = vgui.Create("DListView", DPropertySheetNetwork)
	NetworkClientTrafficList:Dock(FILL)
	NetworkClientTrafficList:SetMultiSelect(false)
	NetworkClientTrafficList:AddColumn("ID"):SetMaxWidth(100)
	NetworkClientTrafficList:AddColumn("Name")
	NetworkClientTrafficList:AddColumn("Status"):SetMaxWidth(150)
	NetworkClientTrafficList:AddColumn("Length"):SetMaxWidth(100)
	
	function DFrameDevTool:AddClientTrafficNetwork(id, name, status,length)
		NetworkClientTrafficList:AddLine(id, name, status, length)
	end
	
	DPropertySheetNetwork:AddSheet("Client Traffic", NetworkClientTrafficList, "icon16/user.png")
	
	local NetworkServerTrafficList = vgui.Create("DListView", DPropertySheetNetwork)
	NetworkServerTrafficList:Dock(FILL)
	NetworkServerTrafficList:SetMultiSelect(false)
	NetworkServerTrafficList:AddColumn("ID"):SetMaxWidth(100)
	NetworkServerTrafficList:AddColumn("Name")
	NetworkServerTrafficList:AddColumn("Status"):SetMaxWidth(150)
	NetworkServerTrafficList:AddColumn("Length"):SetMaxWidth(100)
	NetworkServerTrafficList:AddColumn("Client"):SetMaxWidth(200)

	function DFrameDevTool:AddServerTrafficNetwork(id, name, status, length, client)
		NetworkServerTrafficList:AddLine(id, name, status, length, client)
	end
	DPropertySheetNetwork:AddSheet("Server Traffic", NetworkServerTrafficList, "icon16/server.png")
	DPropertySheet:AddSheet("Network", DPropertySheetNetwork, "icon16/drive_network.png")]]
	
	local DPropertySheetHook = vgui.Create("DPropertySheet", DPropertySheet)
	DPropertySheetHook:Dock(FILL)
	DPropertySheetHook:DockMargin(5, 5, 5, 5)
	
	local HookClientList = vgui.Create("DListView", DPropertySheetHook)
	HookClientList:Dock(FILL)
	HookClientList:SetMultiSelect(false)
	HookClientList:AddColumn("Name")
	HookClientList:AddColumn("Identifier")
	
	function DFrameDevTool:AddClientHook(name, identifier)
		HookClientList:AddLine(name, identifier)
	end
	
	for k, v in pairs(hook.GetAll()) do
		for kHook, vHook in pairs(v) do
			DFrameDevTool:AddClientHook(k, kHook)
		end
	end
	
	DPropertySheetHook:AddSheet("Client", HookClientList, "icon16/user.png")
	
	local HookServerList = vgui.Create("DListView", DPropertySheetNetwork)
	HookServerList:Dock(FILL)
	HookServerList:SetMultiSelect(false)
	HookServerList:AddColumn("Name")
	HookServerList:AddColumn("Identifier")

	function DFrameDevTool:AddServerHook(name, identifier)
		HookServerList:AddLine(name, identifier)
	end
	DPropertySheetHook:AddSheet("Server", HookServerList, "icon16/server.png")
	
	DPropertySheet:AddSheet("Hook", DPropertySheetHook, "icon16/brick.png")
	
	local DPropertySheetHTTP = vgui.Create("DPropertySheet", DPropertySheet)
	DPropertySheetHTTP:Dock(FILL)
	DPropertySheetHTTP:DockMargin(5, 5, 5, 5)
	
	local HTTPClientList = vgui.Create("DListView", DPropertySheetHTTP)
	HTTPClientList:Dock(FILL)
	HTTPClientList:SetMultiSelect(false)
	HTTPClientList:AddColumn("Type"):SetMaxWidth(50)
	HTTPClientList:AddColumn("URL")
	
	function DFrameDevTool:AddClientHTTP(type, url)
		HTTPClientList:AddLine(type, url)
	end
	
	for k, v in pairs(http.GetRequests()) do
		DFrameDevTool:AddClientHTTP(v.method, v.url)
	end
	DPropertySheetHTTP:AddSheet("Client", HTTPClientList, "icon16/user.png")
	
	local HTTPServerList = vgui.Create("DListView", DPropertySheetNetwork)
	HTTPServerList:Dock(FILL)
	HTTPServerList:SetMultiSelect(false)
	HTTPServerList:AddColumn("Type"):SetMaxWidth(50)
	HTTPServerList:AddColumn("URL")

	function DFrameDevTool:AddServerHTTP(type, url)
		HTTPServerList:AddLine(type, url)
	end
	DPropertySheetHTTP:AddSheet("Server", HTTPServerList, "icon16/server.png")
	
	DPropertySheet:AddSheet("HTTP", DPropertySheetHTTP, "icon16/world.png")	
	
	local DHTMLWiki = vgui.Create("DHTML" , DFrameDevTool)
	DHTMLWiki:Dock(FILL)
	DHTMLWiki:DockMargin(5, 0, 5, 5)
	DHTMLWiki:OpenURL("http://wiki.garrysmod.com")
	
	DPropertySheet:AddSheet("Documentation", DHTMLWiki, "icon16/book.png")	
	
	local DLabelLuaConsole = vgui.Create("DLabel", DFrameDevTool)
	DLabelLuaConsole:Dock(TOP)
	DLabelLuaConsole:DockMargin(5, 5, 5, 0)
	DLabelLuaConsole:SetText("Lua console :")

	local DTextEntryLua = vgui.Create("DTextEntry", DFrameDevTool)
	DTextEntryLua:Dock(FILL)
	DTextEntryLua:DockMargin(1, 5, 1, 5)
	DTextEntryLua:SetSize(0, 200)
	DTextEntryLua:SetMultiline(true)
	DTextEntryLua:SetDrawLanguageID(false)
	DTextEntryLua:SetText("")

	local DPanelButton = vgui.Create("DPanel", DFrameDevTool)
	DPanelButton:Dock(BOTTOM)
	DPanelButton:SetSize(0, 30)

	local DButtonShared = vgui.Create("DButton", DPanelButton)
	DButtonShared:Dock(LEFT)
	DButtonShared:DockMargin(5, 5, 5, 5)
	DButtonShared:SetText("Shared")
	DButtonShared:SetSize(120, 0)
	DButtonShared.DoClick = function()
		net.Start("DevToolLuaRunShared")
			net.WriteString(DTextEntryLua:GetText())
		net.SendToServer()
	end

	local DButtonServer = vgui.Create("DButton", DPanelButton)
	DButtonServer:Dock(LEFT)
	DButtonServer:DockMargin(5, 5, 5, 5)
	DButtonServer:SetText("Server")
	DButtonServer:SetSize(120, 0)
	DButtonServer.DoClick = function()
		net.Start("DevToolLuaRunServer")
			net.WriteString(DTextEntryLua:GetText())
		net.SendToServer()
	end
	
	local DButtonClient = vgui.Create("DButton", DPanelButton)
	DButtonClient:Dock(LEFT)
	DButtonClient:DockMargin(5, 5, 5, 5)
	DButtonClient:SetText("Client")
	DButtonClient:SetSize(120, 0)
	DButtonClient.DoClick = function()
		local PlayerList = DermaMenu()
		for k, v in pairs(player.GetAll()) do
			PlayerList:AddOption(tostring(v), function()
				net.Start("DevToolLuaRunClient")
					net.WriteEntity(v)
					net.WriteString(DTextEntryLua:GetText())
				net.SendToServer()
			end)
		end
		
		PlayerList:AddOption("All", function()
			net.Start("DevToolLuaRunClient")
				net.WriteEntity(Entity(0))
				net.WriteString(DTextEntryLua:GetText())
			net.SendToServer()
		end)
		
		PlayerList:Open()
	end

	local DButtonLocalClient = vgui.Create("DButton", DPanelButton)
	DButtonLocalClient:Dock(RIGHT)
	DButtonLocalClient:DockMargin(5, 5, 5, 5)
	DButtonLocalClient:SetText("Local Client")
	DButtonLocalClient:SetSize(120, 0)
	DButtonLocalClient.DoClick = function()
		RunString(DTextEntryLua:GetText(), "DevToolConsole")
	end
	
	for k, v in pairs(console.GetInfo()) do
		DFrameDevTool:AddClientLog(v.text, v.file..":"..tostring(v.line), "info")
	end
	
	return DFrameDevTool
end

function GM:OpenGameUI()
	if !DFrameDevTool then return end
	if !DFrameDevTool:IsValid() then return end
	DFrameDevTool:Show()
end

function GM:CloseGameUI()
	if !DFrameDevTool then return end
	if !DFrameDevTool:IsValid() then return end
	DFrameDevTool:Hide()
end

concommand.Add("devtool", function()
	DFrameDevTool = InitDevTool()
	net.Start("DevToolOpen")
	net.SendToServer()
end)

net.Receive("DevToolConsoleServer", function()
	if !DFrameDevTool then return end
	if !DFrameDevTool:IsValid() then return end
	
	for k, v in pairs(net.ReadTable()) do
		DFrameDevTool:AddServerLog(v.text, v.file..":"..tostring(v.line), "info")
	end
end)

net.Receive("DevToolConsoleServerAdd", function()
	if !DFrameDevTool then return end
	if !DFrameDevTool:IsValid() then return end
	
	local TypeLog = net.ReadString()
	DFrameDevTool:AddServerLog(net.ReadString(), net.ReadString()..":"..tostring(net.ReadFloat()), TypeLog)
end)

net.Receive("DevToolHookServer", function()
	if !DFrameDevTool then return end
	if !DFrameDevTool:IsValid() then return end
	
	for k, v in pairs(net.ReadTable()) do
		for kHook, vHook in pairs(v) do
			DFrameDevTool:AddServerHook(k, kHook)
		end
	end
end)

net.Receive("DevToolHookServerAdd", function()
	if !DFrameDevTool then return end
	if !DFrameDevTool:IsValid() then return end
	
	DFrameDevTool:AddServerHook(net.ReadString(), net.ReadString())
end)

net.Receive("DevToolHTTPServerAdd", function()
	if !DFrameDevTool then return end
	if !DFrameDevTool:IsValid() then return end
	
	DFrameDevTool:AddServerHTTP(net.ReadString(), net.ReadString())
end)

function GM:OnConsolePrint(text, file, line)
	if !DFrameDevTool then return end
	if !DFrameDevTool:IsValid() then return end
	
	DFrameDevTool:AddClientLog(text, file..":"..tostring(line), "info")
end

function GM:OnConsolePrintError(text, file, line)
	if !DFrameDevTool then return end
	if !DFrameDevTool:IsValid() then return end
	
	DFrameDevTool:AddClientLog(text, file..":"..tostring(line), "error")
end

function GM:OnHookAdd(event_name, name)
	if !DFrameDevTool then return end
	if !DFrameDevTool:IsValid() then return end
	
	DFrameDevTool:AddClientHook(event_name, name)
end

function GM:OnHTTPRequest(method, url)
	if !DFrameDevTool then return end
	if !DFrameDevTool:IsValid() then return end
	
	DFrameDevTool:AddClientHTTP(method, url)
end