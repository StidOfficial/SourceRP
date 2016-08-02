if ispanel(DPanelWeaponSelection) then
	DPanelWeaponSelection:Remove()
end

surface.CreateFont("GHudWeaponSelectionNumber",
{
	font = "Roboto Bk",
	size = 14,
	weight = 800
})

local WeaponSlot = 6
DPanelWeaponSelection = vgui.Create("DPanel")
DPanelWeaponSelection:SetSize(0, 100)
DPanelWeaponSelection:SetPaintBackground(false)

DPanelWeaponSelectionTop = vgui.Create("DPanel", DPanelWeaponSelection)
DPanelWeaponSelectionTop:Dock(TOP)
DPanelWeaponSelectionTop:SetSize(0, 20)
DPanelWeaponSelectionTop:SetPaintBackground(false)

DPanelWeaponSelectionBottom = vgui.Create("DPanel", DPanelWeaponSelection)
DPanelWeaponSelectionBottom:Dock(BOTTOM)
DPanelWeaponSelectionBottom:SetSize(0, DPanelWeaponSelection:GetTall() - 20)
DPanelWeaponSelectionBottom:SetPaintBackground(false)

local SlotSelected = 0

for i=1, WeaponSlot do
	local DPanelWeaponNumber = vgui.Create("DPanel", DPanelWeaponSelectionTop)
	DPanelWeaponNumber:Dock(LEFT)
	DPanelWeaponNumber:DockMargin(0, 0, 5, 0)
	DPanelWeaponNumber:SetSize(DPanelWeaponSelectionBottom:GetTall(), 0)
	
	function DPanelWeaponNumber:Paint(w, h)
		if gui.IsGameUIVisible() || !LocalPlayer():Alive() then return end
		if i == SlotSelected then
			surface.SetDrawColor(255, 255, 255, 200)
		else
			surface.SetDrawColor(0, 0, 0, 200)
		end
		surface.DrawRect((w / 2) - 10, 0, 20, h)
	
		surface.SetFont("GHudWeaponSelectionNumber")
		local wText, hText = surface.GetTextSize(i)
		if i == SlotSelected then
			surface.SetTextColor(0, 0, 0)
		else
			surface.SetTextColor(255, 255, 255)
		end
		surface.SetTextPos((w / 2) - (wText / 2), (h / 2) - (hText / 2))
		surface.DrawText(i)
	end
	
	local DPanelWeaponItem = vgui.Create("DPanel", DPanelWeaponSelectionBottom)
	DPanelWeaponItem:Dock(LEFT)
	DPanelWeaponItem:DockMargin(0, 0, 5, 0)
	DPanelWeaponItem:SetSize(DPanelWeaponSelectionBottom:GetTall(), 0)
	
	function DPanelWeaponItem:Paint(w, h)
		if gui.IsGameUIVisible() || !LocalPlayer():Alive() then return end
		
		surface.SetDrawColor(0, 0, 0, 200)
		surface.DrawRect(0, 0, w, h)
		
		if i != SlotSelected then return end
		surface.SetDrawColor(255, 255, 255)
		surface.DrawRect(0, 0, 2, h)
		surface.SetDrawColor(255, 255, 255)
		surface.DrawRect(0, 0, w, 2)
		surface.SetDrawColor(255, 255, 255)
		surface.DrawRect(w - 2, 0, 2, h)
		surface.SetDrawColor(255, 255, 255)
		surface.DrawRect(0, h - 2, w, 2)
	end
end

DPanelWeaponSelection:SetSize((DPanelWeaponSelectionBottom:GetTall() * WeaponSlot) + (5 * WeaponSlot - 5), DPanelWeaponSelection:GetTall())
DPanelWeaponSelection:SetPos((ScrW() / 2) - (DPanelWeaponSelection:GetWide() / 2), ScrH() - DPanelWeaponSelection:GetTall() - 15)

local LastSelection = 0
hook.Add("CreateMove", "MouseWeaponSelection", function(cmd)
	if LastSelection > CurTime() then return end
	
	local MouseWheel = cmd:GetMouseWheel()
	if MouseWheel >= 1 then
		LastSelection = CurTime() + 0.009
		SlotSelected = SlotSelected + 1
		if SlotSelected > WeaponSlot then
			SlotSelected = 0
		end
	elseif MouseWheel <= -1 then
		LastSelection = CurTime() + 0.009
		SlotSelected = SlotSelected - 1
		if SlotSelected < 0 then
			SlotSelected = 6
		end
	end
end)

hook.Add("CustomKeyPress", "WeaponSelectionNumberKeyDown", function(key)
	key = key - 1
	if key < 10 && key > -1 then
		SlotSelected = key
	end
end)