AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_light"

ENT.PrintName = "Light Splotlight 1"
ENT.Category = "Light"

ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.Model = "models/props_wasteland/light_spotlight01_lamp.mdl"
ENT.SkinOn = 0
ENT.SkinOff = 1
ENT.Lights = {
	{
		Forward = -9,
		Up = -4,
		Right = 0,
		Color = Color(255, 255, 255),
		Brightness = 4,
		Decay = 1000,
		Size = 400
	}
}
ENT.DevMode = false