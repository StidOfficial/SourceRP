AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_chair"

ENT.PrintName = "Bench 1"
ENT.Category = "Chair"

ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.Model = "models/props_c17/bench01a.mdl"
ENT.Chairs = {
	{
		Forward = 3,
		Up = 0,
		Right = 25,
		Rotate = 0
	},
	{
		Forward = 3,
		Up = 0,
		Right = 0,
		Rotate = 0
	},
	{
		Forward = 3,
		Up = 0,
		Right = -25,
		Rotate = 0
	}
}
ENT.DevMode = false