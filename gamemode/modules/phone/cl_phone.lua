local ForceClose = true
local isClose = true
local PhoneCallNumber = ""
local PhoneCallID = 0
local PhonePanel

local PhoneContentPanel_Home

local PhoneContentPanel_Phone
local lDNumberTextEntry
local PhoneContentPanel_Phone_PadNum

local PhoneContentPanel_Call
local PhoneContentPanel_Call_Header
local PhoneContentPanel_Call_Avatar
local PhoneContentPanel_Call_Button
local PhoneContentPanel_Call_PanelButton
local PhoneContentPanel_Call_PanelButton_Accept
local PhoneContentPanel_Call_PanelButton_Decline

local PhoneContentPanel_Contact

local PhoneContentPanel_Message

-- SOUND
local SPhoneCalling
local SPhoneSuspended

surface.CreateFont("GPhoneTimer",
{
	font = "Arial",
	size = 12,
	weight = 900
})

function GM:PhoneEnable()
	return LocalPlayer():Alive()
end

local function CallIn(number)

	PhoneContentPanel_Home:SetVisible(false)
	PhoneContentPanel_Phone:SetVisible(false)
	PhoneContentPanel_Call:SetVisible(true)
	PhoneContentPanel_Contact:SetVisible(false)
	PhoneContentPanel_Message:SetVisible(false)

	PhoneContentPanel_Call_Button:SetVisible(false)
	PhoneContentPanel_Call_PanelButton:SetVisible(true)
	PhoneContentPanel_Call_Header:SetText(number)
	PhoneContentPanel_Call_Avatar:SetPlayer(LocalPlayer(), 184)
end

local function CallAcceptIn()
	net.Start("PlayerPhoneAcceptCall")
		net.WriteDouble(PhoneCallID)
	net.SendToServer()
	timer.Destroy("TSPhoneRing")
end

local function CallDeclineIn()
	net.Start("PlayerPhoneDeclineCall")
		net.WriteDouble(PhoneCallID)
	net.SendToServer()
	timer.Destroy("TSPhoneRing")
end

local function CallCancelIn()
	net.Start("PlayerPhoneCancelCall")
		net.WriteString(PhoneCallID)
	net.SendToServer()
	timer.Destroy("TSPhoneRing")
end

local function CallFinish()
	print("Player Finish Call")
	SPhoneSuspended = CreateSound(LocalPlayer(), "phone/suspended.wav")
	SPhoneSuspended:Play()

	timer.Create("TSPhoneSuspended", SoundDuration("phone/suspended.wav"), 0, function()
		SPhoneSuspended:Stop()
		SPhoneSuspended:Play()
	end)
end

local function CallCancelFinish()
	timer.Destroy("TSPhoneSuspended")
	SPhoneSuspended:Stop()
	SPhoneSuspended = nil
end

local function CallOut(number)
	GAMEMODE:PlayerPhoneCall(number)
	SPhoneCalling = CreateSound(LocalPlayer(), "phone/calling.wav")
	SPhoneCalling:Play()

	timer.Create("TSPhoneCalling", SoundDuration("phone/calling.wav"), 0, function()
		SPhoneCalling:Stop()
		SPhoneCalling:Play()
	end) 
end

local function CallCancelOut()
	net.Start("PlayerPhoneCancelCall")
		net.WriteString(PhoneCallID)
	net.SendToServer()
	timer.Destroy("TSPhoneCalling")
	if !SPhoneCalling then return end
	SPhoneCalling:Stop()
	SPhoneCalling = nil
end

local function Init()
	PhonePanel = vgui.Create("DPanel")

	-- CONTENT
	PhoneContentPanel_Home = vgui.Create("DPanel", PhonePanel)

	PhoneContentPanel_Phone = vgui.Create("DPanel", PhonePanel)
	DNumberTextEntry = vgui.Create("DTextEntry", PhoneContentPanel_Phone)
	PhoneContentPanel_Phone_PadNum = vgui.Create("DIconLayout", PhoneContentPanel_Phone)

	PhoneContentPanel_Call = vgui.Create("DPanel", PhonePanel)
	PhoneContentPanel_Call_Header = vgui.Create("DLabel", PhoneContentPanel_Call)
	PhoneContentPanel_Call_Avatar = vgui.Create("AvatarImage", PhoneContentPanel_Call)
	PhoneContentPanel_Call_Button = vgui.Create("DButton", PhoneContentPanel_Call)
	PhoneContentPanel_Call_PanelButton = vgui.Create("DPanel", PhoneContentPanel_Call)
	PhoneContentPanel_Call_PanelButton_Accept = vgui.Create("DButton", PhoneContentPanel_Call_PanelButton)
	PhoneContentPanel_Call_PanelButton_Decline = vgui.Create("DButton", PhoneContentPanel_Call_PanelButton)

	PhoneContentPanel_Contact = vgui.Create("DPanel", PhonePanel)

	PhoneContentPanel_Message = vgui.Create("DPanel", PhonePanel)

	PhonePanel:SetPos(ScrW() - 350, ScrH())
	PhonePanel:SetSize(345, 685)
	PhonePanel.Paint = function(self, w, h)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(Material("phone/front.png"))
		surface.DrawTexturedRect(0, 0, w, h)

		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(Material("phone/background01.png"))
		surface.DrawTexturedRect(18, 55, w - 36, h - 136)

		surface.SetDrawColor(0, 0, 0, 250)
		surface.DrawRect(18, 55, w - 36, 20)

		surface.SetFont("GPhoneTimer")
		surface.SetTextColor(255, 255, 255, 255)
		surface.SetTextPos(295, 58)
		surface.DrawText(os.date("%H:%M" , os.time()))

		-- Network
		surface.SetDrawColor(0, 255, 0, 255)
		surface.DrawRect(270, 69, 3, 4)
		surface.SetDrawColor(0, 255, 0, 255)
		surface.DrawRect(275, 65, 3, 8)
		surface.SetDrawColor(0, 255, 0, 255)
		surface.DrawRect(280, 62, 3, 11)
		surface.SetDrawColor(0, 255, 0, 255)
		surface.DrawRect(285, 58, 3, 15)

		-- Bottoms
		--surface.SetDrawColor(0, 0, 0, 250)
		--surface.DrawRect(18, (55 + h - 136) - 50, w - 36, 50)

		if input.IsMouseDown(MOUSE_LEFT) && ForceClose then
			ForceClose = false
		end
	end

	-- PANEL

	PhoneContentPanel_Home:SetPos(18, 55 + 20)
	PhoneContentPanel_Home:SetSize(345 - 36, 474)
	PhoneContentPanel_Home:SetBackgroundColor(Color(0, 0 ,0, 200))
	PhoneContentPanel_Home:SetVisible(true)

	PhoneContentPanel_Phone:SetPos(18, 55 + 20)
	PhoneContentPanel_Phone:SetSize(345 - 36, 474)
	PhoneContentPanel_Phone:SetBackgroundColor(Color(0, 0 ,0, 200))
	PhoneContentPanel_Phone:SetVisible(false)

	PhoneContentPanel_Call:SetPos(18, 55 + 20)
	PhoneContentPanel_Call:SetSize(345 - 36, 474)
	PhoneContentPanel_Call:SetBackgroundColor(Color(0, 0 ,0, 250))
	PhoneContentPanel_Call:SetVisible(false)

	PhoneContentPanel_Contact:SetPos(18, 55 + 20)
	PhoneContentPanel_Contact:SetSize(345 - 36, 474)
	PhoneContentPanel_Contact:SetBackgroundColor(Color(0, 0 ,0, 200))
	PhoneContentPanel_Contact:SetVisible(false)

	PhoneContentPanel_Message:SetPos(18, 55 + 20)
	PhoneContentPanel_Message:SetSize(345 - 36, 474)
	PhoneContentPanel_Message:SetBackgroundColor(Color(0, 0 ,0, 200))
	PhoneContentPanel_Message:SetVisible(false)

	-- PHONE

	DNumberTextEntry:Dock(TOP)
	DNumberTextEntry:DockMargin(10, 10, 10, 10)
	DNumberTextEntry:SetSize(PhoneContentPanel_Phone:GetWide(), 40)
	DNumberTextEntry:SetValue("")
	DNumberTextEntry.OnEnter = function(self)
		chat.AddText( self:GetValue() )
	end

	PhoneContentPanel_Phone_PadNum:Dock(BOTTOM)
	PhoneContentPanel_Phone_PadNum:DockMargin(10, 10, 10, 10)
	PhoneContentPanel_Phone_PadNum:SetSize(PhoneContentPanel_Phone:GetWide(), PhoneContentPanel_Phone:GetTall() - (20 + 40))
	PhoneContentPanel_Phone_PadNum:SetSpaceY(5)
	PhoneContentPanel_Phone_PadNum:SetSpaceX(5)

	local KeysList = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "#"}
	for k,v in pairs(KeysList) do
		local PhoneContentPanel_Phone_PadNum_Button = PhoneContentPanel_Phone_PadNum:Add("DButton")
		PhoneContentPanel_Phone_PadNum_Button:SetText(v == "#" and "##" or v)
		PhoneContentPanel_Phone_PadNum_Button.DoClick = function()
			DNumberTextEntry:SetValue(DNumberTextEntry:GetValue()..v)
		end
		PhoneContentPanel_Phone_PadNum_Button:SetSize(PhoneContentPanel_Phone_PadNum:GetWide() / 3 - (5*2), PhoneContentPanel_Phone_PadNum:GetTall() / 5 - (5*2))
	end

	local PhoneContentPanel_Phone_PadNum_Call = PhoneContentPanel_Phone_PadNum:Add("DButton")
	PhoneContentPanel_Phone_PadNum_Call:SetSize((PhoneContentPanel_Phone_PadNum:GetWide() / 3 - 8) * 2, PhoneContentPanel_Phone_PadNum:GetTall() / 5 - (5*2))
	PhoneContentPanel_Phone_PadNum_Call:SetText("Call")
	PhoneContentPanel_Phone_PadNum_Call.DoClick = function()
		if string.len(DNumberTextEntry:GetValue()) > 2 then
			CallOut(DNumberTextEntry:GetValue())
			DNumberTextEntry:SetValue("")
			PhoneContentPanel_Home:SetVisible(false)
			PhoneContentPanel_Phone:SetVisible(false)
			PhoneContentPanel_Call:SetVisible(true)
			PhoneContentPanel_Contact:SetVisible(false)
			PhoneContentPanel_Message:SetVisible(false)

			PhoneContentPanel_Call_Button:SetVisible(true)
			PhoneContentPanel_Call_PanelButton:SetVisible(false)
			PhoneContentPanel_Call_Header:SetText(DNumberTextEntry:GetValue())
			PhoneContentPanel_Call_Avatar:SetPlayer(LocalPlayer(), 184)
		end
	end

	local PhoneContentPanel_Phone_PadNum_Return = PhoneContentPanel_Phone_PadNum:Add("DButton")
	PhoneContentPanel_Phone_PadNum_Return:SetSize(PhoneContentPanel_Phone_PadNum:GetWide() / 3 - (5*2), PhoneContentPanel_Phone_PadNum:GetTall() / 5 - (5*2))
	PhoneContentPanel_Phone_PadNum_Return:SetText("<-")
	PhoneContentPanel_Phone_PadNum_Return.DoClick = function()
		local ValueLength = string.len(DNumberTextEntry:GetValue())
		if ValueLength > 0 then
			DNumberTextEntry:SetValue(string.sub(DNumberTextEntry:GetValue(), 1, ValueLength - 1))
		end
	end

	-- CALL

	PhoneContentPanel_Call_Header:Dock(TOP)
	PhoneContentPanel_Call_Header:SetSize(PhoneContentPanel_Call:GetWide(), 40)
	PhoneContentPanel_Call_Header:SetContentAlignment(5)
	PhoneContentPanel_Call_Header:SetText("")
	PhoneContentPanel_Call_Header.Paint = function(self, w, h) end

	PhoneContentPanel_Call_Avatar:Dock(FILL)
	PhoneContentPanel_Call_Avatar:DockMargin(20, 40, 20, 40)

	PhoneContentPanel_Call_Button:Dock(BOTTOM)
	PhoneContentPanel_Call_Button:SetSize(PhoneContentPanel_Call:GetWide(), 50)
	PhoneContentPanel_Call_Button:SetText("")
	PhoneContentPanel_Call_Button:SetVisible(true)
	PhoneContentPanel_Call_Button.Paint = function(self, w, h)
		surface.SetDrawColor(233, 39, 40)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(Material("phone/icons/system_end-call.png"))
		surface.DrawTexturedRect(w / 2 - 20, 5, h - 10, h - 10)
	end
	PhoneContentPanel_Call_Button.DoClick = function()
		CallCancelOut()
		PhoneContentPanel_Home:SetVisible(true)
		PhoneContentPanel_Phone:SetVisible(false)
		PhoneContentPanel_Call:SetVisible(false)
		PhoneContentPanel_Contact:SetVisible(false)
		PhoneContentPanel_Message:SetVisible(false)
		if SPhoneSuspended then
			CallCancelFinish()
		end
	end

	PhoneContentPanel_Call_PanelButton:Dock(BOTTOM)
	PhoneContentPanel_Call_PanelButton:SetSize(PhoneContentPanel_Call:GetWide(), 50)
	PhoneContentPanel_Call_PanelButton:SetBackgroundColor(Color(0, 0, 0, 0))
	PhoneContentPanel_Call_PanelButton:SetVisible(false)

	PhoneContentPanel_Call_PanelButton_Accept:Dock(LEFT)
	PhoneContentPanel_Call_PanelButton_Accept:SetSize(PhoneContentPanel_Call_PanelButton:GetWide() / 2, PhoneContentPanel_Call_PanelButton:GetTall())
	PhoneContentPanel_Call_PanelButton_Accept:SetText("")
	PhoneContentPanel_Call_PanelButton_Accept.Paint = function(self, w, h)
		surface.SetDrawColor(73, 196, 72)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(Material("phone/icons/system_start-call.png"))
		surface.DrawTexturedRect(w / 2 - 20, 5, h - 10, h - 10)
	end
	PhoneContentPanel_Call_PanelButton_Accept.DoClick = function()
		CallAcceptIn()
		PhoneContentPanel_Call_Button:SetVisible(true)
		PhoneContentPanel_Call_PanelButton:SetVisible(false)
	end

	PhoneContentPanel_Call_PanelButton_Decline:Dock(RIGHT)
	PhoneContentPanel_Call_PanelButton_Decline:SetSize(PhoneContentPanel_Call_PanelButton:GetWide() / 2, PhoneContentPanel_Call_PanelButton:GetTall())
	PhoneContentPanel_Call_PanelButton_Decline:SetText("")
	PhoneContentPanel_Call_PanelButton_Decline.Paint = function(self, w, h)
		surface.SetDrawColor(233, 39, 40)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(Material("phone/icons/system_end-call.png"))
		surface.DrawTexturedRect(w / 2 - 20, 5, h - 10, h - 10)
	end
	PhoneContentPanel_Call_PanelButton_Decline.DoClick = function()
		CallDeclineIn()
		PhoneContentPanel_Home:SetVisible(true)
		PhoneContentPanel_Phone:SetVisible(false)
		PhoneContentPanel_Call:SetVisible(false)
		PhoneContentPanel_Contact:SetVisible(false)
		PhoneContentPanel_Message:SetVisible(false)
		-- Send Decline
	end

	-- BOTTOM MENU

	local PhoneMenuPanel = vgui.Create("DPanel", PhonePanel)
	PhoneMenuPanel:SetPos(18, (55 + PhonePanel:GetTall() - 136) - 55)
	PhoneMenuPanel:SetSize(PhonePanel:GetWide() - 36, 55)
	PhoneMenuPanel:SetBackgroundColor(Color(0, 0 ,0, 200))


	local PhoneMenuPanel_Home = vgui.Create("DButton", PhoneMenuPanel)
	PhoneMenuPanel_Home:Dock(LEFT)
	PhoneMenuPanel_Home:SetSize(PhoneMenuPanel:GetWide() / 4, PhoneMenuPanel:GetTall())
	PhoneMenuPanel_Home:SetText("")
	PhoneMenuPanel_Home.DoClick = function()
		PhoneContentPanel_Home:SetVisible(true)
		PhoneContentPanel_Phone:SetVisible(false)
		PhoneContentPanel_Call:SetVisible(false)
		PhoneContentPanel_Contact:SetVisible(false)
		PhoneContentPanel_Message:SetVisible(false)
	end
	PhoneMenuPanel_Home.Paint = function(self, w, h)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(Material("phone/icons/system_home.png"))
		surface.DrawTexturedRect(15, 5, h - 10, h - 10)
	end

	local PhoneMenuPanel_Phone = vgui.Create("DButton", PhoneMenuPanel)
	PhoneMenuPanel_Phone:Dock(LEFT)
	PhoneMenuPanel_Phone:SetSize(PhoneMenuPanel:GetWide() / 4, PhoneMenuPanel:GetTall())
	PhoneMenuPanel_Phone:SetText("")
	PhoneMenuPanel_Phone.DoClick = function()
		PhoneContentPanel_Home:SetVisible(false)
		PhoneContentPanel_Phone:SetVisible(true)
		PhoneContentPanel_Call:SetVisible(false)
		PhoneContentPanel_Contact:SetVisible(false)
		PhoneContentPanel_Message:SetVisible(false)
	end
	PhoneMenuPanel_Phone.Paint = function(self, w, h)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(Material("phone/icons/system_phone.png"))
		surface.DrawTexturedRect(15, 5, h - 10, h - 10)
	end

	local PhoneMenuPanel_Contact = vgui.Create("DButton", PhoneMenuPanel)
	PhoneMenuPanel_Contact:Dock(LEFT)
	PhoneMenuPanel_Contact:SetSize(PhoneMenuPanel:GetWide() / 4, PhoneMenuPanel:GetTall())
	PhoneMenuPanel_Contact:SetText("")
	PhoneMenuPanel_Contact.DoClick = function()
		PhoneContentPanel_Home:SetVisible(false)
		PhoneContentPanel_Phone:SetVisible(false)
		PhoneContentPanel_Call:SetVisible(false)
		PhoneContentPanel_Contact:SetVisible(true)
		PhoneContentPanel_Message:SetVisible(false)
	end
	PhoneMenuPanel_Contact.Paint = function(self, w, h)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(Material("phone/icons/system_contacts.png"))
		surface.DrawTexturedRect(15, 5, h - 10, h - 10)
	end

	local PhoneMenuPanel_Message = vgui.Create("DButton", PhoneMenuPanel)
	PhoneMenuPanel_Message:Dock(LEFT)
	PhoneMenuPanel_Message:SetSize(PhoneMenuPanel:GetWide() / 4, PhoneMenuPanel:GetTall())
	PhoneMenuPanel_Message:SetText("")
	PhoneMenuPanel_Message.DoClick = function()
		PhoneContentPanel_Home:SetVisible(false)
		PhoneContentPanel_Phone:SetVisible(false)
		PhoneContentPanel_Call:SetVisible(false)
		PhoneContentPanel_Contact:SetVisible(false)
		PhoneContentPanel_Message:SetVisible(true)
	end
	PhoneMenuPanel_Message.Paint = function(self, w, h)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(Material("phone/icons/system_messages.png"))
		surface.DrawTexturedRect(15, 5, h - 10, h - 10)
	end
end
Init()

function GM:PhoneOpen()
	PhonePanel:SetVisible(true)
	PhonePanel:MoveTo(ScrW() - 350,  ScrH() - 685, 1, 0, -10, function()
		gui.EnableScreenClicker(true)
		isClose = false
	end)
end

function GM:PhoneClose()
	if ForceClose == false then	return end
	PhonePanel:MoveTo(ScrW() - 350,  ScrH(), 1, 0, -10, function()
		PhonePanel:SetVisible(false)
		gui.EnableScreenClicker(false)
		isClose = true
	end)
end

hook.Add("CustomKeyPress", "PhoneKeyPress", function(key)
	if key == KEY_P then
		if isClose then
			if !GAMEMODE:PhoneEnable() then return end
			GAMEMODE:PhoneOpen()
		else
			ForceClose = true
		end
	end
end)

hook.Add("CustomKeyDown", "PhoneKeyDown", function(key)
	if key == KEY_P then
		if !isClose then
			GAMEMODE:PhoneClose()
		end
	end
end)

net.Receive("PlayerPhoneCalling", function()
	local CallID = net.ReadDouble()
	
	local ReturnMessage = net.ReadString()

	PhoneCallID = CallID

	if ReturnMessage == "not-found" then
		if SPhoneCalling then
			CallCancelOut()
			CallFinish()
		end
	elseif ReturnMessage == PhoneCallNumber then
		print("com ok")
	else
		GAMEMODE:PlayerPhoneCalling(ReturnMessage)
	end
end)

function GM:PlayerPhoneCall(number)
	print("LocalPlayer call : "..number)
	PhoneCallNumber = number
	net.Start("PlayerPhoneCall")
		net.WriteString(number)
	net.SendToServer()
end

function GM:PlayerPhoneCalling(number)
	print(number.." calling LocalPlayer")
	CallIn(number)
end