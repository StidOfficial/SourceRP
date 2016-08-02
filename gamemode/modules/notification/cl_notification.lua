net.Receive("AddNotification", function()
	notification.AddLegacy(net.ReadString(), net.ReadFloat(), net.ReadFloat())
end)