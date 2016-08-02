NOTIFY_GENERIC = 0
NOTIFY_ERROR = 1
NOTIFY_UNDO = 2
NOTIFY_HINT = 3
NOTIFY_CLEANUP = 4

local PLAYER = FindMetaTable("Player")

util.AddNetworkString("AddNotification") 
function PLAYER:AddNotification(text, type, length)
	net.Start("AddNotification")
		net.WriteString(text)
		net.WriteFloat(type)
		net.WriteFloat(length)
	net.Send(self)
end