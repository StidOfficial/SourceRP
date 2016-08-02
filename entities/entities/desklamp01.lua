AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_light"

ENT.PrintName = "Desklamp 1"
ENT.Category = "Light"

ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.Model = "models/props_lab/desklamp01.mdl"
ENT.Lights = {
	{
		Forward = -4,
		Up = -4,
		Right = 0,
		Color = Color(255, 255, 255),
		Brightness = 3,
		Decay = 200,
		Size = 15
	}
}
ENT.DevMode = false