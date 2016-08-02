AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_light"

ENT.PrintName = "Lamp Standard 1"
ENT.Category = "Light"

ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.Model = "models/props_c17/lamp_standard_off01.mdl"
ENT.Lights = {
	{
		Forward = 0,
		Up = -4,
		Right = 0,
		Color = Color(255, 255, 255),
		Brightness = 2,
		Decay = 1000,
		Size = 200
	}
}
ENT.DevMode = false