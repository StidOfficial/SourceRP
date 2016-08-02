AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_light"

ENT.PrintName = "Furniture Lamp 1"
ENT.Category = "Light"

ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.Model = "models/props_interiors/Furniture_Lamp01a.mdl"
ENT.Lights = {
	{
		Forward = 0,
		Up = -25,
		Right = 0,
		Color = Color(255, 255, 255),
		Brightness = 3,
		Decay = 200,
		Size = 100
	}
}
ENT.DevMode = false