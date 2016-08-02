local ForceClose = true
local DInventory

surface.CreateFont("GInventoryPing",
{
	font = "Roboto Bk",
	size = 30,
	weight = 1000
})

surface.CreateFont("GInventoryTitle", {
	font = "Roboto Bk",
	size = 25,
	weight = 400
})

function GM:OpenInventory(ply)
	--[[InventoryPanel = vgui.Create("DPanel")
	InventoryPanel:SetPos(0, 0)
	InventoryPanel:SetSize(ScrW(), ScrH())
	function InventoryPanel:Paint(w, h)
		surface.SetDrawColor(0, 0, 0, 220)
		surface.DrawRect(0, 0, w, h) 
		local InventoryBackground = {
			texture = surface.GetTextureID("gui/gradient"),
			color	= Color(0, 0, 0),
			x 	= 0,
			y 	= 0,
			w 	= w,
			h 	= h
		}
		draw.TexturedQuad(InventoryBackground)

		local PlayerName = {}
		PlayerName.font = "GInventoryPlayerName"
		PlayerName.color = Color(255, 255, 255)
		PlayerName.pos = {50, 20}
		PlayerName.text = LocalPlayer():GetName()
		draw.TextShadow(PlayerName, 2)

		if input.IsMouseDown(MOUSE_LEFT) && ForceClose then
			ForceClose = false
		end
	end

	local PlayerModelPanel = vgui.Create("DModelPanel", InventoryPanel)
	PlayerModelPanel:SetPos(0, 0)
	PlayerModelPanel:SetSize(400, ScrH() - 200)
	PlayerModelPanel:SetFOV(25)
	PlayerModelPanel:SetCamPos(Vector(0, 0, 0))
	PlayerModelPanel:SetDirectionalLight(BOX_RIGHT, Color(255, 160, 80, 255))
	PlayerModelPanel:SetDirectionalLight(BOX_LEFT, Color(80, 160, 255, 255))
	PlayerModelPanel:SetAmbientLight(Vector(-64, -64, -64))
	PlayerModelPanel:SetAnimated(true)
	PlayerModelPanel.Angles = Angle(0, 0, 0)
	PlayerModelPanel:SetLookAt(Vector(-100, 0, -22))
	PlayerModelPanel:SetModel(LocalPlayer():GetModel())
	PlayerModelPanel.Entity:SetPos(Vector(-100, 0, -61))
	function PlayerModelPanel:LayoutEntity(Entity) return end
	function PlayerModelPanel.Entity:GetPlayerColor() return Vector(1, 0, 0) end]]
	
	DInventory = vgui.Create("DPropertySheet", DPanelInventory)
	DInventory:SetPos(20, 20)
	DInventory:SetSize(ScrW() - 20 * 2, ScrH() - 220)

	local DPanelPlayer = vgui.Create("DPanel", DInventory)
	DPanelPlayer:SetPaintBackground(false)
	
	local DPanelPlayerInformation = vgui.Create("DPanel", DPanelPlayer)
	DPanelPlayerInformation:Dock(LEFT)
	DPanelPlayerInformation:DockMargin(0, 0, 5, 0)
	DPanelPlayerInformation:SetSize(DInventory:GetWide() / 3, 0)
	DPanelPlayerInformation:SetPaintBackground(false)
	
	local DModelPanelPlayer = vgui.Create("DModelPanel", DPanelPlayerInformation)
	DModelPanelPlayer:Dock(FILL)
	DModelPanelPlayer:SetFOV(36)
	DModelPanelPlayer:SetCamPos(Vector(0, 0, 0))
	DModelPanelPlayer:SetDirectionalLight(BOX_RIGHT, Color(255, 160, 80, 255))
	DModelPanelPlayer:SetDirectionalLight(BOX_LEFT, Color(80, 160, 255, 255))
	DModelPanelPlayer:SetAmbientLight(Vector(-64, -64, -64))
	DModelPanelPlayer:SetAnimated(true)
	DModelPanelPlayer.Angles = Angle(0, 0, 0)
	DModelPanelPlayer:SetLookAt(Vector(-110, 0, -22))
	DModelPanelPlayer:SetModel(ply:GetModel())
	--DModelPanelPlayer.Entity:SetBodygroup(pnl.typenum, math.Round(val))
	DModelPanelPlayer.Entity:SetSkin(ply:GetSkin())
	DModelPanelPlayer.Entity.GetPlayerColor = function() return ply:GetPlayerColor() end
	DModelPanelPlayer.Entity:SetPos(Vector(-110, 0, -61))
	
	function DModelPanelPlayer:Paint(w, h)
		DModelPanel.Paint(self, w, h)
		
		surface.SetFont("GInventoryPing")
		surface.SetTextColor(255, 255, 255)
		surface.SetTextPos(0, 0)
		surface.DrawText("Hello World")
	end
	
	function DModelPanelPlayer:DragMousePress()
		self.PressX, self.PressY = gui.MousePos()
		self.Pressed = true
	end
	function DModelPanelPlayer:DragMouseRelease() self.Pressed = false end
	function DModelPanelPlayer:LayoutEntity(Entity)
		if (self.bAnimated) then self:RunAnimation() end
		if (self.Pressed) then
			local mx, my = gui.MousePos()
			self.Angles = self.Angles - Angle(0, (self.PressX or mx) - mx, 0)
			self.PressX, self.PressY = gui.MousePos()
		end
		Entity:SetAngles(self.Angles)
	end
	
	DPanelPlayerEntityInventory = vgui.Create("DIconLayout", DPanelPlayerInformation)
	DPanelPlayerEntityInventory:Dock(BOTTOM)
	DPanelPlayerEntityInventory:SetSize(0, 80)
	DPanelPlayerEntityInventory:SetSpaceX(5)
	
	for i=1,6 do
		local DPanelItem = DPanelPlayerEntityInventory:Add("DPanel")
		DPanelItem:SetSize(80, 80)
	end
	
	local DPanelPlayerInventoryInformation = vgui.Create("DPanel", DPanelPlayer)
	DPanelPlayerInventoryInformation:Dock(FILL)
	DPanelPlayerInventoryInformation:DockMargin(5, 0, 5, 0)
	DPanelPlayerInventoryInformation:SetPaintBackground(false)
	
	local DLabelItemTitle = vgui.Create("DLabel", DPanelPlayerInventoryInformation)
	DLabelItemTitle:Dock(TOP)
	DLabelItemTitle:DockMargin(0, 0, 0, 10)
	DLabelItemTitle:SetFont("GInventoryTitle")
	DLabelItemTitle:SetTextColor(Color(255, 255, 255))
	DLabelItemTitle:SetText("Item Name")
	
	DPanelItemInformation = vgui.Create("DPanel", DPanelPlayerInventoryInformation)
	DPanelItemInformation:Dock(TOP)
	DPanelItemInformation:SetSize(0, DInventory:GetTall() - (80 * 6) - 70)
	
	DIconLayoutPlayerInventory = vgui.Create("DIconLayout", DPanelPlayerInventoryInformation)
	DIconLayoutPlayerInventory:Dock(BOTTOM)
	DIconLayoutPlayerInventory:SetSize(0, 80 * 6)
	DIconLayoutPlayerInventory:SetSpaceX(5)
	DIconLayoutPlayerInventory:SetSpaceY(5)
	
	for i=1,6*4 do
		local DPanelItem = DIconLayoutPlayerInventory:Add("DPanel")
		DPanelItem:SetSize(80, 80)
	end
	
	local DLabelPlayerInventoryTitle = vgui.Create("DLabel", DPanelPlayerInventoryInformation)
	DLabelPlayerInventoryTitle:Dock(BOTTOM)
	DLabelPlayerInventoryTitle:DockMargin(0, 0, 0, 10)
	DLabelPlayerInventoryTitle:SetFont("GInventoryTitle")
	DLabelPlayerInventoryTitle:SetTextColor(Color(255, 255, 255))
	DLabelPlayerInventoryTitle:SetText("Inventory")
	
	local DPanelSubInventory = vgui.Create("DPanel", DPanelPlayer)
	DPanelSubInventory:Dock(RIGHT)
	DPanelSubInventory:DockMargin(5, 0, 0, 0)
	DPanelSubInventory:SetSize(80 * 6 + 130, 0)
	DPanelSubInventory:SetPaintBackground(false)
	
	DInventory:AddSheet(ply:Name(), DPanelPlayer, "icon16/user.png")
end

function GM:CloseInventory()
	if ForceClose == false then	return end
	DInventory:Remove()
	DInventory = nil

	gui.EnableScreenClicker(false)
end

function GM:InventoryOpen()
	return DInventory != nil
end

hook.Add("CustomKeyPress", "InventoryKeyPress", function(key)
	if key == KEY_I then
		if ForceClose then
			GAMEMODE:OpenInventory(LocalPlayer())
			gui.EnableScreenClicker(true)
		else
			ForceClose = true
		end
	end
end)

hook.Add("CustomKeyDown", "InventoryKeyDown", function(key)
	if key == KEY_I then
		GAMEMODE:CloseInventory()
	end
end)

hook.Add("CustomMouseKeyDown", "InventoryMouseKeyDown", function(key)
	if !DInventory then return end
	if key == MOUSE_LEFT then
		ForceClose = false
	end
end)