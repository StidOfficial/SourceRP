local DMapEditor = DMapEditor or nil

local WidthMenu ,HeightMenu = 320, 25
local MouseWidthMenuLeft, MouseWidthMenuRight = WidthMenu, WidthMenu

function OpenMapEditor()
	gui.EnableScreenClicker(true)
	
	DMapEditor = vgui.Create("DPanel")
	DMapEditor:Dock(FILL)
	function DMapEditor:Paint(w, h) end
	
	local DMapEditorMenuBar = vgui.Create("DMenuBar", DMapEditor)

	local MenuMapEditor = DMapEditorMenuBar:AddMenu("Map Editor")
	local OptionSave = MenuMapEditor:AddOption("Save", function()
		Msg("Chose File:New\n")
	end)
	OptionSave:SetIcon("icon16/disk.png")
	local MenuMapEditor = MenuMapEditor:AddOption("Close", function()
		net.Start("ExitMapEditor")
		net.SendToServer()
		DMapEditor:Remove()
		gui.EnableScreenClicker(false)
		LocalPlayer().EntitySelect = nil
	end)
	MenuMapEditor:SetIcon("icon16/door_in.png")

	local MenuEditor = DMapEditorMenuBar:AddMenu("Edit")
	local OptionPaste = MenuEditor:AddOption("Paste", function()
		Msg("Chose Edit:Paste\n")
	end)
	OptionPaste:SetImage("icon16/page_paste.png")
	local OptionCopy = MenuEditor:AddOption("Copy", function()
		Msg("Chose Edit:Copy\n")
	end)
	OptionCopy:SetImage("icon16/page_copy.png")
	
	local DMapEditorButtonPanel = vgui.Create("DPanel", DMapEditor)
	DMapEditorButtonPanel:Dock(TOP)
	DMapEditorButtonPanel:DockMargin(0, 0, 0, 5)
	DMapEditorButtonPanel:SetSize(0, 30)
	
	local DButtonSelect = vgui.Create("DButton", DMapEditorButtonPanel)
	DButtonSelect:Dock(LEFT)
	DButtonSelect:DockMargin(2, 2, 2, 2)
	DButtonSelect:SetText("")
	DButtonSelect:SetImage("icon16/cursor.png")
	DButtonSelect:SetSize(25, 0)
	
	local DButtonMove = vgui.Create("DButton", DMapEditorButtonPanel)
	DButtonMove:Dock(LEFT)
	DButtonMove:DockMargin(2, 2, 2, 2)
	DButtonMove:SetText("")
	DButtonMove:SetImage("icon16/arrow_out.png")
	DButtonMove:SetSize(25, 0)
	
	local DButtonRotate = vgui.Create("DButton", DMapEditorButtonPanel)
	DButtonRotate:Dock(LEFT)
	DButtonRotate:DockMargin(2, 2, 2, 2)
	DButtonRotate:SetText("")
	DButtonRotate:SetImage("icon16/arrow_rotate_anticlockwise.png")
	DButtonRotate:SetSize(25, 0)
	
	function DButtonSelect:OnMousePressed(mousecode)
		self:SetEnabled(false)
		DButtonMove:SetEnabled(true)
		DButtonRotate:SetEnabled(true)
		return DLabel.OnMousePressed(self, mousecode)
	end
	function DButtonMove:OnMousePressed(mousecode)
		self:SetEnabled(false)
		DButtonSelect:SetEnabled(true)
		DButtonRotate:SetEnabled(true)
		return DLabel.OnMousePressed(self, mousecode)
	end
	function DButtonRotate:OnMousePressed(mousecode)
		self:SetEnabled(false)
		DButtonSelect:SetEnabled(true)
		DButtonMove:SetEnabled(true)
		return DLabel.OnMousePressed(self, mousecode)
	end
	
	local DMapEditorInfoBar = vgui.Create("DPanel", DMapEditor)
	DMapEditorInfoBar:Dock(BOTTOM)
	DMapEditorInfoBar:SetSize(0, 25)
	function DMapEditorInfoBar:Paint(w, h)
		surface.SetDrawColor(140, 140, 140)
		surface.DrawRect(0, 0, w, 1)
		
		surface.SetDrawColor(241, 241, 241)
		surface.DrawRect(0, 1, w, (h / 2) - 1)
		
		surface.SetDrawColor(233, 233, 233)
		surface.DrawRect(0, (h / 2), w, (h / 2) + 1)
		
		if !LocalPlayer():GetViewEntity():IsValid() then return end
		local CamPos = LocalPlayer():GetViewEntity():GetPos()
		
		local TraceEntity = util.TraceEntity({
			start = CamPos,
			endpos = CamPos + LocalPlayer():GetViewEntity():GetForward() * 10000,
			filter = LocalPlayer():GetViewEntity()
		}, LocalPlayer():GetViewEntity())
		
		draw.SimpleText("X : "..math.Round(CamPos.x, 2), "DermaDefault", 10, 5, Color(0, 0, 0), TEXT_ALIGN_LEFT)
		draw.SimpleText("Y : "..math.Round(CamPos.y, 2), "DermaDefault", 10 + 80, 5, Color(0, 0, 0), TEXT_ALIGN_LEFT)
		draw.SimpleText("Z : "..math.Round(CamPos.z, 2), "DermaDefault", 10 + 80 + 10 + 80, 5, Color(0, 0, 0), TEXT_ALIGN_LEFT)
		draw.SimpleText("Distance : "..math.Round(CamPos:Distance(TraceEntity.HitPos), 2), "DermaDefault", 10 + 80 + 10 + 80 + 10 + 80, 5, Color(0, 0, 0), TEXT_ALIGN_LEFT)
	end
	
	local DPropertySheetNavigationMenu = vgui.Create("DPropertySheet", DMapEditor)
	DPropertySheetNavigationMenu:Dock(LEFT)
	DPropertySheetNavigationMenu:DockMargin(0, 1, 0, 1)
	DPropertySheetNavigationMenu:SetSize(WidthMenu, ScrH() - DMapEditorMenuBar:GetTall() * 2)
	
	local DPanelMapEntities = vgui.Create("DTree", DPropertySheetNavigationMenu)
	DPanelMapEntities:Dock(FILL)
	DPanelMapEntities:DockMargin(5, 0, 5, 5)
	
	local WorldEntities = DPanelMapEntities:AddNode("Map Entities")
	local Players = DPanelMapEntities:AddNode("Players")
	local Entities = DPanelMapEntities:AddNode("Entities")
	local Weapons = DPanelMapEntities:AddNode("Weapons")
	local NPCs = DPanelMapEntities:AddNode("NPCs")
	local Vehicles = DPanelMapEntities:AddNode("Vehicles")
	
	for k, v in pairs(ents.GetAll()) do
		if v:IsPlayer() then
			Players:AddNode(tostring(v))
		elseif v:IsWeapon() then
			Weapons:AddNode(tostring(v))
		elseif v:IsNPC() then
			NPCs:AddNode(tostring(v))
		elseif v:IsVehicle() then
			Vehicles:AddNode(tostring(v))
		elseif v:IsWorld() then
			WorldEntities:AddNode(tostring(v))
		else
			Entities:AddNode(tostring(v))
		end
	end
	DPropertySheetNavigationMenu:AddSheet("Entities", DPanelMapEntities, "icon16/application_view_tile.png")
	
	local DPanelCamView = vgui.Create("DPanel", DMapEditor)
	DPanelCamView:Dock(FILL)
	DPanelCamView:SetDrawBackground(false)
	DPanelCamView:Receiver("MapItem", function(receiver, tableOfDroppedPanels, isDropped, menuIndex, mouseX, mouseY)
		gui.EnableScreenClicker(true)
	end, {})
	function DPanelCamView:OnMousePressed(keyCode)
		if keyCode == MOUSE_LEFT then
			self.OldMouseX, self.OldMouseY = self:LocalCursorPos()
		end
	end
	DPanelCamView.Paint = function()
		if gui.IsGameUIVisible() || !DPanelCamView.OldMouseX then return end
		
		local MouseX, MouseY = DPanelCamView:LocalCursorPos()
		
		if input.IsMouseDown(MOUSE_LEFT) && MouseX > 0 && MouseY > 0 && MouseX < DPanelCamView:GetWide() && MouseY < DPanelCamView:GetTall() then
			local Width, Height = MouseX - DPanelCamView.OldMouseX, MouseY - DPanelCamView.OldMouseY
			
			surface.SetDrawColor(Color( 255, 255, 255))
			if Width > 0 && Height > 0 then
				surface.DrawOutlinedRect(DPanelCamView.OldMouseX, DPanelCamView.OldMouseY, Width, Height)
			elseif Width < 0 && Height < 0 then
				surface.DrawOutlinedRect(MouseX, MouseY, -Width, -Height)
			elseif Width < 0 && Height > 0 then
				surface.DrawOutlinedRect(MouseX, DPanelCamView.OldMouseY, -Width, Height)
			elseif Width > 0 && Height < 0 then
				surface.DrawOutlinedRect(MouseX - Width, DPanelCamView.OldMouseY + Height, Width, -Height)
			end
		end
	end
	
	local DPropertySheetSpawnMenu = vgui.Create( "DPropertySheet", DMapEditor)
	DPropertySheetSpawnMenu:Dock(RIGHT)
	DPropertySheetSpawnMenu:DockMargin(0, 1, 0, 1)
	DPropertySheetSpawnMenu:SetSize(WidthMenu, ScrH() - DMapEditorMenuBar:GetTall() * 2)

	local DTreeProps = vgui.Create("DTree", DPropertySheetSpawnMenu)
	DTreeProps:Dock(FILL)
	DTreeProps:DockMargin(5, 0, 5, 5)
	
	local GamesList = engine.GetGames()
	
	table.insert(GamesList, {
		title = "All",
		folder = "GAME",
		icon = "all",
		mounted = true
	})
	
	table.insert(GamesList, {
		title = "Garry's Mod",
		folder = "garrysmod",
		mounted = true
	})
	
	local GamesNode = DTreeProps:AddNode("Games")
	GamesNode.Icon:SetImage("icon16/joystick.png")
	
	function CreateDTree(path, folder, node)
		local Files, Dirs = file.Find(path.."/*", folder)
		if table.Count(Dirs) == 0 then return end
		
		for k, v in pairs(Dirs) do
			local FilesModel, DirsModel = file.Find(path.."/"..v.."/*.mdl", folder)
			
			local Node = node:AddNode(v)
			if table.Count(FilesModel) > 0 then
				local DIconLayoutModels = vgui.Create("DIconLayout")
				DIconLayoutModels:SetSize(200, 200)
				DIconLayoutModels:SetSpaceY(5)
				DIconLayoutModels:SetSpaceX(5)
				function DIconLayoutModels:SetDrawLines(bool) end
				function DIconLayoutModels:SetLastChild(bool) end
				function DIconLayoutModels:FilePopulate() return true end
				
				for kModel, vModel in pairs(FilesModel) do
					local SpawnIcon = DIconLayoutModels:Add("SpawnIcon")
					SpawnIcon:SetSize(64, 64)
					SpawnIcon:SetModel(path.."/"..v.."/"..vModel, 0, 0)
					function SpawnIcon:PaintOver() end
					function SpawnIcon:PerformLayout() end
					SpawnIcon:Droppable("MapItem")
				end
				
				DIconLayoutModels:SizeToContents()
				Node:AddPanel(DIconLayoutModels)
			end
			CreateDTree(path.."/"..v, folder, Node)
		end
	end
	
	for k, v in pairs(GamesList) do
		if v.mounted == false then continue end
		
		--local GameNode = GamesNode:AddFolder(v.title, "models", v.folder, false)
		local GameNode = GamesNode:AddNode(v.title)
		GameNode.Icon:SetImage("games/16/"..(v.icon or v.folder)..".png")
		
		CreateDTree("models", v.folder, GameNode)
	end
	
	DPropertySheetSpawnMenu:AddSheet("Props", DTreeProps, "icon16/application_view_tile.png")
	
	local WeaponList = {}
	for k, v in pairs(list.Get("Weapon")) do
		if WeaponList[v.Category] == nil then
			WeaponList[v.Category] = {}
		end
		
		WeaponList[v.Category][v.ClassName] = {
			Author = v.Author,
			PrintName = v.PrintName,
			Spawnable = v.Spawnable,
			AdminOnly = v.AdminOnly
		}
	end
	
	local DTreeWeapon = vgui.Create("DTree", DPropertySheetSpawnMenu)
	DTreeWeapon:Dock(FILL)
	DTreeWeapon:DockMargin(5, 0, 5, 5)
	
	for k, v in pairs(WeaponList) do
		local DIconLayoutItems = vgui.Create("DIconLayout")
		DIconLayoutItems:SetSpaceY(5)
		DIconLayoutItems:SetSpaceX(5)
		function DIconLayoutItems:SetDrawLines(bool) end
		function DIconLayoutItems:SetLastChild(bool) end
		function DIconLayoutItems:FilePopulate() return true end
		
		for kItem, vItem in pairs(v) do
			local ContentIconItem = DIconLayoutItems:Add("ContentIcon")
			ContentIconItem:SetMaterial("entities/"..kItem..".png")
			ContentIconItem:SetName(vItem.PrintName)
			ContentIconItem:SetAdminOnly(vItem.AdminOnly)
			function ContentIconItem:SetLastChild(bool) end
			function ContentIconItem:FilePopulate() return true end
			ContentIconItem:Droppable("MapItem")
		end
		
		DIconLayoutItems:SizeToContents()
		DTreeWeapon:AddNode(k):AddPanel(DIconLayoutItems)
	end
	
	DPropertySheetSpawnMenu:AddSheet("Weapons", DTreeWeapon, "icon16/gun.png")
	
	local NPCList = {}
	for k, v in pairs(list.Get("NPC")) do
		if NPCList[v.Category] == nil then
			NPCList[v.Category] = {}
		end
		
		NPCList[v.Category][v.Class] = {
			Name = v.Name
		}
	end	
	
	local DTreeNPC = vgui.Create("DTree", DPropertySheetSpawnMenu)
	DTreeNPC:Dock(FILL)
	DTreeNPC:DockMargin(5, 0, 5, 5)
	
	for k, v in pairs(NPCList) do		
		local DIconLayoutItems = vgui.Create("DIconLayout")
		DIconLayoutItems:SetSpaceY(5)
		DIconLayoutItems:SetSpaceX(5)
		function DIconLayoutItems:SetDrawLines(bool) end
		function DIconLayoutItems:SetLastChild(bool) end
		function DIconLayoutItems:FilePopulate() return true end
		
		for kItem, vItem in pairs(v) do
			local ContentIconItem = DIconLayoutItems:Add("ContentIcon")
			ContentIconItem:SetMaterial("entities/"..kItem..".png")
			ContentIconItem:SetName(vItem.Name)
			function ContentIconItem:SetLastChild(bool) end
			function ContentIconItem:FilePopulate() return true end
			ContentIconItem:Droppable("MapItem")
		end
		
		DIconLayoutItems:SizeToContents()
		DTreeNPC:AddNode(k):AddPanel(DIconLayoutItems)
	end
	
	DPropertySheetSpawnMenu:AddSheet("NPCs", DTreeNPC, "icon16/monkey.png")
	
	local SpawnableEntitiesList = {}
	for k, v in pairs(list.Get("SpawnableEntities")) do
		if k == "base_npc" then continue end
		if SpawnableEntitiesList[v.Category] == nil then
			SpawnableEntitiesList[v.Category] = {}
		end
		
		SpawnableEntitiesList[v.Category][v.ClassName] = {
			Author = v.Author,
			PrintName = v.PrintName
		}
	end	
	
	local DTreeSpawnableEntities = vgui.Create("DTree", DPropertySheetSpawnMenu)
	DTreeSpawnableEntities:Dock(FILL)
	DTreeSpawnableEntities:DockMargin(5, 0, 5, 5)
	
	for k, v in pairs(SpawnableEntitiesList) do		
		local DIconLayoutItems = vgui.Create("DIconLayout")
		DIconLayoutItems:SetSpaceY(5)
		DIconLayoutItems:SetSpaceX(5)
		function DIconLayoutItems:SetDrawLines(bool) end
		function DIconLayoutItems:SetLastChild(bool) end
		function DIconLayoutItems:FilePopulate() return true end
		
		for kItem, vItem in pairs(v) do
			local ContentIconItem = DIconLayoutItems:Add("ContentIcon")
			ContentIconItem:SetMaterial("entities/"..kItem..".png")
			ContentIconItem:SetName(vItem.PrintName)
			function ContentIconItem:SetLastChild(bool) end
			function ContentIconItem:FilePopulate() return true end
			ContentIconItem:Droppable("MapItem")
		end
		
		DIconLayoutItems:SizeToContents()
		DTreeSpawnableEntities:AddNode(k):AddPanel(DIconLayoutItems)
	end
	
	DPropertySheetSpawnMenu:AddSheet("Entities", DTreeSpawnableEntities, "icon16/bricks.png")
	
	local VehiclesList = {}
	for k, v in pairs(list.Get("Vehicles")) do
		if VehiclesList[v.Category] == nil then
			VehiclesList[v.Category] = {}
		end
		
		VehiclesList[v.Category][k] = {
			Author = v.Author,
			Name = v.Name,
			Information = v.Information
		}
	end	
	
	local DTreeVehicles = vgui.Create("DTree", DPropertySheetSpawnMenu)
	DTreeVehicles:Dock(FILL)
	DTreeVehicles:DockMargin(5, 0, 5, 5)
	
	for k, v in pairs(VehiclesList) do		
		local DIconLayoutItems = vgui.Create("DIconLayout")
		DIconLayoutItems:SetSpaceY(5)
		DIconLayoutItems:SetSpaceX(5)
		function DIconLayoutItems:SetDrawLines(bool) end
		function DIconLayoutItems:SetLastChild(bool) end
		function DIconLayoutItems:FilePopulate() return true end
		
		for kItem, vItem in pairs(v) do
			local ContentIconItem = DIconLayoutItems:Add("ContentIcon")
			ContentIconItem:SetMaterial("entities/"..kItem..".png")
			ContentIconItem:SetName(vItem.Name)
			function ContentIconItem:SetLastChild(bool) end
			function ContentIconItem:FilePopulate() return true end
			ContentIconItem:Droppable("MapItem")
		end
		
		DIconLayoutItems:SizeToContents()
		DTreeVehicles:AddNode(k):AddPanel(DIconLayoutItems)
	end
	DPropertySheetSpawnMenu:AddSheet("Vehicles", DTreeVehicles, "icon16/car.png")
	
	local ScriptedEntitiesList = {}
	for k, v in pairs(list.Get("Vehicles")) do
		if ScriptedEntitiesList[v.Category] == nil then
			ScriptedEntitiesList[v.Category] = {}
		end
		
		ScriptedEntitiesList[v.Category][k] = {
			Author = v.Author,
			Name = v.Name,
			Information = v.Information
		}
	end	
	
	local DTreeScriptedEntities = vgui.Create("DTree", DPropertySheetSpawnMenu)
	DTreeScriptedEntities:Dock(FILL)
	DTreeScriptedEntities:DockMargin(5, 0, 5, 5)
	
	for k, v in pairs(ScriptedEntitiesList) do		
		local DIconLayoutItems = vgui.Create("DIconLayout")
		DIconLayoutItems:SetSpaceY(5)
		DIconLayoutItems:SetSpaceX(5)
		function DIconLayoutItems:SetDrawLines(bool) end
		function DIconLayoutItems:SetLastChild(bool) end
		function DIconLayoutItems:FilePopulate() return true end
		
		for kItem, vItem in pairs(v) do
			local ContentIconItem = DIconLayoutItems:Add("ContentIcon")
			ContentIconItem:SetMaterial("entities/"..kItem..".png")
			ContentIconItem:SetName(vItem.Name)
			function ContentIconItem:SetLastChild(bool) end
			function ContentIconItem:FilePopulate() return true end
			ContentIconItem:Droppable("MapItem")
		end
		
		DIconLayoutItems:SizeToContents()
		DTreeScriptedEntities:AddNode(k):AddPanel(DIconLayoutItems)
	end
	DPropertySheetSpawnMenu:AddSheet("Scripted Entity", DTreeScriptedEntities, "icon16/brick.png")
	
	local DButtonMinimizeLeft = vgui.Create("DButton", DMapEditor)
	DButtonMinimizeLeft:SetPos(DPropertySheetNavigationMenu:GetWide() + 1, DMapEditorMenuBar:GetTall() + DMapEditorButtonPanel:GetTall() + 5 + 1)
	DButtonMinimizeLeft:SetSize(23, 22)
	DButtonMinimizeLeft:SetImage("icon16/application_side_contract.png")
	DButtonMinimizeLeft:SetText("")
	DButtonMinimizeLeft.DoClick = function()
		if DButtonMinimizeLeft.Minimized then
			DButtonMinimizeLeft:SetPos(DPropertySheetNavigationMenu:GetWide() + 1, DMapEditorMenuBar:GetTall() + DMapEditorButtonPanel:GetTall() + 5 + 1)
			DButtonMinimizeLeft:SetImage("icon16/application_side_contract.png")
			DPropertySheetNavigationMenu:SetVisible(true)
			MouseWidthMenuLeft = WidthMenu
		else
			DButtonMinimizeLeft:SetPos(1, DMapEditorMenuBar:GetTall() + DMapEditorButtonPanel:GetTall() + 5 + 1)
			DButtonMinimizeLeft:SetImage("icon16/application_side_expand.png")
			DPropertySheetNavigationMenu:SetVisible(false)
			MouseWidthMenuLeft = 0
		end
		DButtonMinimizeLeft.Minimized = !DButtonMinimizeLeft.Minimized
	end
	
	local DButtonMinimizeRight = vgui.Create("DButton", DMapEditor)
	DButtonMinimizeRight:SetPos(ScrW() - DPropertySheetSpawnMenu:GetWide() - 1 - 23, DMapEditorMenuBar:GetTall() + DMapEditorButtonPanel:GetTall() + 5 + 1)
	DButtonMinimizeRight:SetSize(23, 22)
	DButtonMinimizeRight:SetImage("icon16/application_side_expand.png")
	DButtonMinimizeRight:SetText("")
	DButtonMinimizeRight.DoClick = function()
		if DButtonMinimizeRight.Minimized then
			DButtonMinimizeRight:SetPos(ScrW() - DPropertySheetSpawnMenu:GetWide() - 1 - 23, DMapEditorMenuBar:GetTall() + DMapEditorButtonPanel:GetTall() + 5 + 1)
			DButtonMinimizeRight:SetImage("icon16/application_side_expand.png")
			DPropertySheetSpawnMenu:SetVisible(true)
			MouseWidthMenuRight = WidthMenu
		else
			DButtonMinimizeRight:SetPos(ScrW() - 1 - 23, DMapEditorMenuBar:GetTall() + DMapEditorButtonPanel:GetTall() + 5 + 1)
			DButtonMinimizeRight:SetImage("icon16/application_side_contract.png")
			DPropertySheetSpawnMenu:SetVisible(false)
			MouseWidthMenuRight = 0
		end
		DButtonMinimizeRight.Minimized = !DButtonMinimizeRight.Minimized
	end
end

concommand.Add("mapeditor", function(ply)
	if ply:InMapEditor() then return end
	OpenMapEditor()
	net.Start("EnterMapEditor")
	net.SendToServer()
end)

--[[hook.Add("Think", "MapEditorMoveAngle", function()
	if !LocalPlayer():InMapEditor() then return end
	local Entity = LocalPlayer():GetNWEntity("CameraMapEditor")
	if !input.IsMouseDown(MOUSE_RIGHT) then
		Entity.MouseX, Entity.MouseY = gui.MousePos()
		return
	end
	if !Entity:IsValid() then return end
	
	local MoveX, MoveY = gui.MousePos()
	if Entity.MouseX == MoveX && Entity.MouseY == MoveY then return end
	if MoveX < 0 || MoveX > ScrW() || MoveY < 0 || MoveY > ScrH() then return end
	
	local AngleP, AngleY = Entity:GetAngles().p + -((Entity.MouseY || MoveY) - MoveY), Entity:GetAngles().y + ((Entity.MouseX || MoveX) - MoveX)
	if AngleP <= -90 then
		AngleP = -90
	end
	if AngleP >= 90 then
		AngleP = 90
	end
	net.Start("MapEditorMoveEntity")
		net.WriteAngle(Angle(AngleP, AngleY, 0))
	net.SendToServer()
	
	Entity.MouseX, Entity.MouseY = gui.MousePos()
end)]]

hook.Add("CustomMouseKeyDown", "MapEditorSelectEntity", function(key)
	if LocalPlayer():InMapEditor() && key == MOUSE_LEFT then
		local tr = util.TraceLine({
			start = LocalPlayer():GetViewEntity():GetPos(),
			endpos = LocalPlayer():GetViewEntity():GetPos() + gui.ScreenToVector(gui.MousePos()) * 1024 * 5
		})
		
		if !IsEntity(tr.Entity) then return end
		
		if !input.IsKeyDown(KEY_LCONTROL)  then
			if !input.IsKeyDown(KEY_RCONTROL) then
				LocalPlayer().EntitySelect = {}
			end
		end
		
		if !tr.Entity:IsValid() then return end
		if table.FindNext(LocalPlayer().EntitySelect, tr.Entity) == tr.Entity || tr.Entity:GetClass() == "worldspawn" then return end
		LocalPlayer().EntitySelect[table.Count(LocalPlayer().EntitySelect)] = tr.Entity
	end
end)

hook.Add("CustomMouseKeyPress", "MapEditorHideMouse", function(key)
	if LocalPlayer():InMapEditor() && key == MOUSE_RIGHT then
		local x, y = gui.MousePos()
		if x > MouseWidthMenuLeft && x < ScrW() - MouseWidthMenuRight && y > HeightMenu && y < ScrH() - HeightMenu then
			gui.EnableScreenClicker(false)
		end
	end
end)

hook.Add("CustomMouseKeyDown", "MapEditorShowMouse", function(key)
	if LocalPlayer():InMapEditor() && key == MOUSE_RIGHT then
		gui.EnableScreenClicker(true)
	end
end)

local mat_wireframe = Material( "models/wireframe" )
hook.Add("PostDrawOpaqueRenderables", "MapEditorDrawEntitySelect", function()
	if !LocalPlayer().EntitySelect then return end
	for k, v in pairs(LocalPlayer().EntitySelect) do
		if !IsEntity(v) || !v:IsValid() then continue end
		if v:GetPos():Distance(LocalPlayer():GetViewEntity():GetPos()) > 3000 then continue end
		
		local EntityAngle = v:IsPlayer() and Angle(0, v:GetAngles().y, v:GetAngles().r) or v:GetAngles()
		local ColorLine = Color(255, 165, 0)
		
		render.SetColorMaterial()
		render.DrawBox(v:GetPos(), EntityAngle, v:OBBMins(), v:OBBMaxs(), Color(255, 165, 0, 20))
		
		cam.Start3D2D(v:GetPos(), EntityAngle, 1)
			render.DrawLine(v:OBBMins() - Vector(0, v:OBBCenter().y * 2, 0), Vector(v:OBBMins().x, v:OBBMins().y, v:OBBMaxs().z) - Vector(0, v:OBBCenter().y * 2, 0), ColorLine)
			render.DrawLine(v:OBBMins() - Vector(0, v:OBBCenter().y * 2, 0), v:OBBMins() - Vector(0, v:OBBMins().y - v:OBBMaxs().y, 0) - Vector(0, v:OBBCenter().y * 2, 0), ColorLine)
			render.DrawLine(v:OBBMins() - Vector(0, v:OBBMins().y - v:OBBMaxs().y, 0) - Vector(0, v:OBBCenter().y * 2, 0), Vector(v:OBBMins().x, v:OBBMaxs().y, v:OBBMaxs().z) - Vector(0, v:OBBCenter().y * 2, 0), ColorLine)
			render.DrawLine(Vector(v:OBBMins().x, v:OBBMins().y, v:OBBMaxs().z) - Vector(0, v:OBBCenter().y * 2, 0), Vector(v:OBBMins().x, v:OBBMaxs().y, v:OBBMaxs().z) - Vector(0, v:OBBCenter().y * 2, 0), ColorLine)
			
			render.DrawLine(Vector(v:OBBMins().x, v:OBBMaxs().y, v:OBBMaxs().z) - Vector(0, v:OBBCenter().y * 2, 0), v:OBBMaxs() - Vector(0, v:OBBCenter().y * 2, 0), ColorLine)
			render.DrawLine(Vector(v:OBBMaxs().x, v:OBBMaxs().y, v:OBBMins().z) - Vector(0, v:OBBCenter().y * 2, 0), v:OBBMaxs() - Vector(0, v:OBBCenter().y * 2, 0), ColorLine)
			render.DrawLine(v:OBBMins() - Vector(0, v:OBBMins().y - v:OBBMaxs().y, 0) - Vector(0, v:OBBCenter().y * 2, 0), Vector(v:OBBMaxs().x, v:OBBMaxs().y, v:OBBMins().z) - Vector(0, v:OBBCenter().y * 2, 0), ColorLine)
			
			render.DrawLine(Vector(v:OBBMaxs().x, v:OBBMaxs().y, v:OBBMins().z) - Vector(0, v:OBBCenter().y * 2, 0), v:OBBMins() - Vector(v:OBBMins().x - v:OBBMaxs().x, 0, 0) - Vector(0, v:OBBCenter().y * 2, 0), ColorLine)
			render.DrawLine(v:OBBMaxs() + Vector(0, v:OBBMins().y - v:OBBMaxs().y, 0) - Vector(0, v:OBBCenter().y * 2, 0), v:OBBMins() - Vector(v:OBBMins().x - v:OBBMaxs().x, 0, 0) - Vector(0, v:OBBCenter().y * 2, 0), ColorLine)
			render.DrawLine(v:OBBMaxs() - Vector(0, v:OBBCenter().y * 2, 0), v:OBBMaxs() + Vector(0, v:OBBMins().y - v:OBBMaxs().y, 0) - Vector(0, v:OBBCenter().y * 2, 0), ColorLine)
			
			render.DrawLine(Vector(v:OBBMins().x, v:OBBMins().y, v:OBBMaxs().z) - Vector(0, v:OBBCenter().y * 2, 0), v:OBBMaxs() + Vector(0, v:OBBMins().y - v:OBBMaxs().y, 0) - Vector(0, v:OBBCenter().y * 2, 0),ColorLine)
			render.DrawLine(v:OBBMins() - Vector(v:OBBMins().x - v:OBBMaxs().x, 0, 0) - Vector(0, v:OBBCenter().y * 2, 0), v:OBBMins() - Vector(0, v:OBBCenter().y * 2, 0), ColorLine)
		cam.End3D2D()
	end
end)

hook.Add("HUDPaint", "MapEditorMoveCursor", function()
	if !istable(LocalPlayer().EntitySelect) then return end
	if table.Count(LocalPlayer().EntitySelect) <= 0 then return end
	if LocalPlayer().EntitySelect[0]:GetPos():Distance(LocalPlayer():GetViewEntity():GetPos()) > 3000 then return end
	
	local Entity = LocalPlayer().EntitySelect[0]:GetPos():ToScreen()
	local Forward = (LocalPlayer().EntitySelect[0]:GetPos() + LocalPlayer().EntitySelect[0]:GetForward() * 50):ToScreen()
	local Right = (LocalPlayer().EntitySelect[0]:GetPos() + LocalPlayer().EntitySelect[0]:GetRight() * 50):ToScreen()
	local Up = (LocalPlayer().EntitySelect[0]:GetPos() + LocalPlayer().EntitySelect[0]:GetUp() * 50):ToScreen()
	
	if !Entity.visible then return end
	--surface.SetDrawColor(0, 0, 255)
	--surface.DrawLine(Entity.x, Entity.y, Forward.x, Forward.y)
	
	draw.NoTexture()
	surface.SetDrawColor(0, 0, 255)
	surface.DrawTexturedRectRotated(Entity.x, Entity.y, 400, 5, math.atan2(Forward.x - Entity.x, Forward.y - Entity.y) * (180 / math.pi) + 90)
	
	surface.SetDrawColor(0, 255, 0)
	surface.DrawLine(Entity.x, Entity.y, Right.x, Right.y)
	
	surface.SetDrawColor(255, 0, 0)
	surface.DrawLine(Entity.x, Entity.y, Up.x, Up.y)
end)