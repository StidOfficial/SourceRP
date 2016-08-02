AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_light"

ENT.PrintName = "Wall Lamp 3"
ENT.Category = "Light"

ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.Model = "models/props/de_inferno/wall_lamp3.mdl"
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