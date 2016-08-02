local PLAYER = FindMetaTable("Player")

function PLAYER:MapEditor(isin)
	self:SetNWBool("InMapEditor", isin)
end

function GM:MapEditorEnabled(ply)
	return true --ply:IsSuperAdmin()
end

function GM:EnterMapEditor(ply)
	ply.MapEditorEntity = ents.Create("prop_physics")
	ply.MapEditorEntity:SetModel("models/maxofs2d/camera.mdl")
	ply.MapEditorEntity:SetPos(ply:GetPos() + ply:GetUp() * 100)
	ply.MapEditorEntity:SetAngles(ply:GetAngles())
	ply.MapEditorEntity:Spawn()
	
	ply.MapEditorEntity:PhysicsInit(SOLID_NONE)
	ply.MapEditorEntity:SetMoveType(MOVETYPE_NONE)
	ply.MapEditorEntity:SetSolid(SOLID_NONE)
	
	drive.PlayerStartDriving(ply, ply.MapEditorEntity, "drive_mapeditor")
	ply:GodEnable()
end

function GM:ExitMapEditor(ply)
	ply:GodDisable()
	
	drive.PlayerStopDriving(ply) 
	ply.MapEditorEntity:Remove()
	ply.MapEditorEntity = nil
end

util.AddNetworkString("EnterMapEditor")
net.Receive("EnterMapEditor", function(len, ply)
	if (IsValid(ply) and ply:IsPlayer()) then
		if !GAMEMODE:MapEditorEnabled(ply) then return end
		ply:MapEditor(true)
		GAMEMODE:EnterMapEditor(ply)
	end
end)

util.AddNetworkString("ExitMapEditor")
net.Receive("ExitMapEditor", function(len, ply)
	if (IsValid(ply) and ply:IsPlayer()) then
		if !GAMEMODE:MapEditorEnabled(ply) then return end
		ply:MapEditor(false)
		GAMEMODE:ExitMapEditor(ply)
	end
end)