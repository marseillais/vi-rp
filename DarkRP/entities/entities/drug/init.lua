AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local function DrugPlayer(ply)
	if not ValidEntity(ply) then return end
	local RP = RecipientFilter()
	RP:RemoveAllPlayers()
	RP:AddPlayer(ply)
	umsg.Start("DarkRPEffects", RP)
		umsg.String("Drugged")
		umsg.String("1")
	umsg.End()
	
	RP:AddAllPlayers()
	
	ply:SetJumpPower(300)
	GAMEMODE:SetPlayerSpeed(ply, GetConVarNumber("wspd") * 2, GetConVarNumber("rspd") * 2)
	
	local IDSteam = string.gsub(ply:SteamID(), ":", "")
	if not timer.IsTimer(IDSteam.."DruggedHealth") and not timer.IsTimer(IDSteam) then
		ply:SetHealth(ply:Health() + 100)
		timer.Create(IDSteam.."DruggedHealth", 60/(100 + 5), 100 + 5, function() 
			if ValidEntity(ply) then ply:SetHealth(ply:Health() - 1) end 
			if ply:Health() <= 0 then ply:Kill() end 
		end)
		timer.Create(IDSteam, 60, 1, UnDrugPlayer, ply)
	end
end

function UnDrugPlayer(ply) -- Global function, used in sv_gamemode_functions
	if not ValidEntity(ply) then return end
	local RP = RecipientFilter()
	RP:RemoveAllPlayers()
	RP:AddPlayer(ply)
	local IDSteam = string.gsub(ply:SteamID(), ":", "")
	timer.Remove(IDSteam.."DruggedHealth")
	timer.Remove(IDSteam)
	umsg.Start("DarkRPEffects", RP)
		umsg.String("Drugged")
		umsg.String("0")
	umsg.End()
	RP:AddAllPlayers()
	ply:SetJumpPower(190)
	GAMEMODE:SetPlayerSpeed(ply, GetConVarNumber("wspd"), GetConVarNumber("rspd") )	
end

function ENT:Initialize()
	self.Entity:SetModel("models/props_lab/jar01a.mdl") 
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.CanUse = true
	local phys = self.Entity:GetPhysicsObject()

	if phys and phys:IsValid() then phys:Wake() end

	self.damage = 10
	self.dt.price = self.dt.price or 100
end

function ENT:OnTakeDamage(dmg)
	self.damage = self.damage - dmg:GetDamage()

	if (self.damage <= 0) then
		local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos())
		effectdata:SetMagnitude(2)
		effectdata:SetScale(2)
		effectdata:SetRadius(3)
		util.Effect("Sparks", effectdata)
		self.Entity:Remove()
	end
end

function ENT:Use(activator,caller)
	if not self.CanUse then return false end
	local Owner = self.dt.owning_ent
	if activator ~= Owner then
		if not activator:CanAfford(self.dt.price) then
			return false
		end
		DB.PayPlayer(activator, Owner, self.dt.price)
		Notify(activator, 0, 4, "You have paid " .. CUR .. self.dt.price .. " for using drugs.")
		Notify(Owner, 0, 4, "You have received " .. CUR .. self.dt.price .. " for selling drugs.")
	end
	DrugPlayer(caller)
	self.CanUse = false
	self.Entity:Remove()
end

function ENT:OnRemove()
	local ply = self.dt.owning_ent
	if not ValidEntity(ply) then return end
	ply.maxDrugs = ply.maxDrugs - 1
end