AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_light"

ENT.PrintName = "Lamp Fixture 1"
ENT.Category = "Light"

ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.Model = "models/props_c17/lampfixture01a.mdl"
ENT.SkinOn = 1
ENT.SkinOff = 0
ENT.Lights = {
	{
		Forward = -10,
		Up = -2,
		Right = 0,
		Color = Color(255, 255, 255),
		Brightness = 2,
		Decay = 200,
		Size = 100
	}
}
ENT.DevMode = true