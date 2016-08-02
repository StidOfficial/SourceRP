net.Receive("SetMoney", function()
	LocalPlayer().Money = net.ReadDouble()
end)