AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_light"

ENT.PrintName = "Prision Lamp 1"
ENT.Category = "Light"

ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.Model = "models/props_wasteland/prison_lamp001c.mdl"
ENT.SkinOn = 0
ENT.SkinOff = 1
ENT.Lights = {
	{
		Forward = 0,
		Up = 3,
		Right = 0,
		Color = Color(255, 255, 255),
		Brightness = 2,
		Decay = 1000,
		Size = 200
	}
}
ENT.DevMode = false