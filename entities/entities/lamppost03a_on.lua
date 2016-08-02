AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_light"

ENT.PrintName = "Lamp Post 3"
ENT.Category = "Light"

ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.Model = "models/props_c17/lamppost03a_off.mdl"
ENT.ModelOn = "models/props_c17/lamppost03a_on.mdl"
ENT.ModelOff = "models/props_c17/lamppost03a_off.mdl"
ENT.Lights = {
	{
		Forward = 0,
		Up = -440,
		Right = 95,
		Color = Color(255, 255, 255),
		Brightness = 2,
		Decay = 1000,
		Size = 1000
	}
}
ENT.DevMode = false