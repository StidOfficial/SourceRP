resource.AddFile("materials/phone/background01.png")
resource.AddFile("materials/phone/front.png")

resource.AddFile("materials/phone/icons/system_home.png")
resource.AddFile("materials/phone/icons/system_phone.png")
resource.AddFile("materials/phone/icons/system_contacts.png")
resource.AddFile("materials/phone/icons/system_messages.png")
resource.AddFile("materials/phone/icons/system_end-call.png")
resource.AddFile("materials/phone/icons/system_start-call.png")

resource.AddFile("sound/phone/calling.wav")
resource.AddFile("sound/phone/ring.wav")
resource.AddFile("sound/phone/suspended.wav")

local PhoneCallList = {}

util.AddNetworkString("PlayerPhoneCall")
net.Receive("PlayerPhoneCall", function(lenght, ply)
	local PhoneNumber = net.ReadString()

	if (IsValid(ply) && ply:IsPlayer() && PhoneNumber) then
		print(ply:Name().." call "..PhoneNumber)
		callid = table.Count(PhoneCallList)
		PhoneCallList[callid] = {
			Caller = ply,
			CallNumber = PhoneNumber
		}
		timer.Create("PhoneCall_"..ply:UserID(), 10, 1, function()
			GAMEMODE:PlayerPhoneCalling(ply, callid, PhoneNumber)
		end) 
	end
end)

util.AddNetworkString("PlayerPhoneCancelCall")
net.Receive("PlayerPhoneCancelCall", function(lenght, ply)
	local callid = net.ReadDouble()

	if (IsValid(ply) && ply:IsPlayer() && callid) then
		print(ply:Name().." cancel")
		timer.Destroy("PhoneCall_"..ply:UserID())
		if PhoneCallList[callid] and PhoneCallList[callid].Calling then
			timer.Destroy("TSPhoneRing_"..PhoneCallList[callid].Calling:UserID())
		end
		PhoneCallList[callid] = nil
	end
end)

util.AddNetworkString("PlayerPhoneAcceptCall")
net.Receive("PlayerPhoneAcceptCall", function(lenght, ply)
	local callid = net.ReadDouble()

	if (IsValid(ply) && ply:IsPlayer() && callid) then
		print(ply:Name().." accept")
		timer.Destroy("TSPhoneRing_"..ply:UserID())
		print(callid)
		if PhoneCallList[callid] and PhoneCallList[callid].Calling then return end
		net.Start("PlayerPhoneCalling")
			net.WriteString("accept")
		net.Send(PhoneCallList[callid].Calling)
	end
end)

util.AddNetworkString("PlayerPhoneDeclineCall")
net.Receive("PlayerPhoneDeclineCall", function(lenght, ply)
	local callid = net.ReadDouble()

	if (IsValid(ply) && ply:IsPlayer() && callid) then
		print(ply:Name().." decline")
		timer.Destroy("TSPhoneRing_"..ply:UserID())
		if PhoneCallList[callid] and PhoneCallList[callid].Calling then return end
		net.Start("PlayerPhoneCalling")
			net.WriteString("not-found")
		net.Send(PhoneCallList[callid].Calling)
	end
end)

util.AddNetworkString("PlayerPhoneCalling")
function GM:PlayerPhoneCalling(ply, callid, number)
	print("find player "..callid)
	for k,v in pairs(player.GetAll()) do
		if v == ply or v:GetPhoneNumber() != number then continue end
		PhoneCallList[callid].Calling = v
		net.Start("PlayerPhoneCalling")
			net.WriteDouble(callid)
			net.WriteString(number)
		net.Send(v)
		v:EmitSound("phone/ring.wav")
		timer.Create("TSPhoneRing_"..v:UserID(), SoundDuration("phone/call_ring-effect.wav"), 0, function()
			v:EmitSound("phone/ring.wav")
		end)
		print("Calling "..v:Name())
		return
	end

	net.Start("PlayerPhoneCalling")
		net.WriteDouble(callid)
		net.WriteString("not-found")
	net.Send(ply)
	print("Not found "..number)
end

concommand.Add("call", function(ply)
	GAMEMODE:PlayerPhoneCalling(ply, "10")
end)