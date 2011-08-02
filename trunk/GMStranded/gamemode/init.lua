
DeriveGamemode("sandbox")

-- Send clientside files
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile('qmenu.lua')
AddCSLuaFile("cl_panels.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("unlocks.lua")
AddCSLuaFile("combinations.lua")
AddCSLuaFile('daytime.lua')

include("shared.lua")
include("processes.lua") -- Processes
include("unlocks.lua") -- Unlocks
include("combinations.lua") -- Combinations
include("resources.lua") -- Resources
include("chatcommands.lua") -- Chat commands

--Convars
CreateConVar("gms_FreeBuild", "0")
CreateConVar("gms_FreeBuildSA", "0")
CreateConVar("gms_AllTools", "0", FCVAR_ARCHIVE)
CreateConVar("gms_AutoSave", "1", FCVAR_ARCHIVE)
CreateConVar("gms_AutoSaveTime", "3", FCVAR_ARCHIVE)
CreateConVar("gms_physgun", "1")
CreateConVar("gms_ReproduceTrees", "0")
CreateConVar("gms_MaxReproducedTrees", "50", FCVAR_ARCHIVE)
CreateConVar("gms_AllowSWEPSpawn", "0")
CreateConVar("gms_AllowSENTSpawn", "0")
CreateConVar("gms_SpreadFire", "0")
CreateConVar("gms_FadeRocks", "0")
CreateConVar("gms_CostsScale", "0.50")
CreateConVar("gms_Alerts", "1")
CreateConVar("gms_Campfire", "1")
CreateConVar("gms_PlantLimit", "25")

SetGlobalInt("plantlimit", GetConVarNumber("gms_PlantLimit"))

--Vars
GM.NextSaved = 0
GM.NextLoaded = 0

--Locals
local PlayerMeta = FindMetaTable("Player")
local EntityMeta = FindMetaTable("Entity")

--Tribes table
GM.Tribes = {}
GM.Tribes["The Stranded"] = {id = 1, red = 200, green = 200, blue = 0, Password = false}
GM.Tribes["Survivalists"] = {id = 2, red = 225, green = 225, blue = 225, Password = false}
GM.Tribes["Anonymous"] = {id = 3, red = 0, green = 145, blue = 145, Password = false}
GM.Tribes["The Gummies"] = {id = 4, red = 255, green = 23, blue = 0, Password = false}
GM.Tribes["The Dynamics"] = {id = 5, red = 0, green = 72, blue = 255, Password = false}
GM.Tribes["Scavengers"] = {id = 6, red = 8, green = 255, blue = 0, Password = false}
GM.NumTribes = 6

GM.AntlionBarrowSpawns = {}
GM.AntlionBarrowSpawns['gms_rollinghills'] = {Vector(3131.2876, -980.5972, 519.5605), Vector(-4225.0200, 6009.3516, 513.1411)}
GM.AntlionBarrowSpawns['gms_rollinghills_daynight'] = GM.AntlionBarrowSpawns['gms_rollinghills']
GM.AntlionBarrowSpawns['gms_rollinghills_daynight_b1'] = GM.AntlionBarrowSpawns['gms_rollinghills']

/* Custom auto anlion barrow auto placement */
timer.Simple(3, function()	
	if (GAMEMODE.AntlionBarrowSpawns[game.GetMap()]) then
		for id, pos in pairs(GAMEMODE.AntlionBarrowSpawns[game.GetMap()]) do
			local ent = ents.Create("gms_antlionbarrow")
			ent:SetPos(pos)
			ent:Spawn()
			ent:SetNetworkedString("Owner", "World")
			ent:SetKeyValue("MaxAntlions", 7)
		end
	end
end)

/* Find tribe by ID */
function GM.FindTribeByID(id)
	for name, tabl in pairs(GAMEMODE.Tribes) do
		if (tabl.id == id) then
			tabl.name = name
			return tabl
		end
	end
	return false
end

/* Cancel process */
concommand.Add("gms_cancelprocess", function(ply, cmd, args)
	if (!ply.InProcess) then return end
	v = ply.ProcessTable
	if (!v.Cancel) then return end
	
	if (v.Owner and v.Owner != NULL and v.Owner:IsValid()) then 
		v.Owner:Freeze(false)
		v.Owner:StopProcessBar()
		v.Owner.InProcess = false
		v.Owner:SendMessage("Cancelled.", 3, Color(200, 0, 0, 255))
	end

	v.IsStopped = true
	timer.Destroy("GMS_ProcessTimer_" .. v.TimerID)
	GAMEMODE.RemoveProcessThink(v)
end)

/* Custom player messages */
function PlayerMeta:SendMessage(text, duration, color)
	local duration = duration or 3
	local color = color or Color(255, 255, 255, 255)

	umsg.Start("gms_sendmessage", self)
		umsg.String(text)
		umsg.Short(duration)
		umsg.String(color.r .. "," .. color.g .. "," .. color.b .. "," .. color.a)
	umsg.End()
end

/* Menu toggles */
function GM:ShowHelp(ply)
	umsg.Start("gms_toggleskillsmenu", ply)
	umsg.End()
end

function GM:ShowTeam(ply)
	umsg.Start("gms_toggleresourcesmenu", ply)
	umsg.End()
end

function GM:ShowSpare1(ply)
	umsg.Start("gms_togglecommandsmenu", ply)
	umsg.End()
end

function GM:ShowSpare2(ply)
	umsg.Start("gms_cancelprocess", ply)
	umsg.End()
end

/*------------------------ Player Meta ------------------------*/

/* Open combination menu */
function PlayerMeta:OpenCombiMenu(str)
	umsg.Start("gms_OpenCombiMenu", self)
		umsg.String(str)
	umsg.End()
end

/* Achievements */
function PlayerMeta:SendAchievement(text)
	umsg.Start("gms_sendachievement", self)
		umsg.String(text)
	umsg.End()

	local sound = CreateSound(self, Sound("music/hl1_song11.mp3"))
	sound:Play()
	timer.Simple(5.5, function(snd) snd:Stop() end, sound)
end

/* Skill functions */
function PlayerMeta:SetSkill(skill, int)
	skill = string.Capitalize(skill)
	if (!self.Skills[skill]) then self.Skills[skill] = 0 end

	if (skill != "Survival") then
		int = math.Clamp(int, 0, 200)
	end
	self.Skills[skill] = int

	umsg.Start("gms_SetSkill", self)
		umsg.String(skill)
		umsg.Short(self:GetSkill(skill))
	umsg.End()
end

function PlayerMeta:GetSkill(skill)
	skill = string.Capitalize(skill)
	self:SetNWInt(skill, self.Skills[skill]) 
	return self.Skills[skill] or 0	
end

function PlayerMeta:IncSkill(skill, int)
	skill = string.Capitalize(skill)
	if (!self.Skills[skill]) then self:SetSkill(skill, 0) end
	if (!self.Experience[skill]) then self:SetXP(skill, 0) end

	if (skill != "Survival") then
		int = math.Clamp(int, 0, 200)
		for id = 1, int do self:IncXP("Survival", 20) end
		self:SendMessage(string.Replace(skill, "_", " ") .. " +" .. int, 3, Color(10, 200, 10, 255))
	else
		self.MaxResources = self.MaxResources + 5
		self:SendAchievement("Level Up!")
	end

	self.Skills[skill] = self.Skills[skill] + int

	umsg.Start("gms_SetSkill", self)
	umsg.String(skill)
	umsg.Short(self:GetSkill(skill))
	umsg.End()

	self:CheckForUnlocks()
end

function PlayerMeta:DecSkill(skill, int)
	skill = string.Capitalize(skill)
	self.Skills[skill] = math.max(self.Skills[skill] - int, 0)

	umsg.Start("gms_SetSkill", self)
		umsg.String(skill)
		umsg.Short(self:GetSkill(skill))
	umsg.End()
end

/* XP functions */
function PlayerMeta:SetXP(skill, int)
	skill = string.Capitalize(skill)
	if (!self.Skills[skill]) then self:SetSkill(skill, 0) end
	if (!self.Experience[skill]) then self.Experience[skill] = 0 end

	self.Experience[skill] = int

	umsg.Start("gms_SetXP", self)
		umsg.String(skill)
		umsg.Short(self:GetXP(skill))
	umsg.End()
end

function PlayerMeta:GetXP(skill)
	skill = string.Capitalize(skill)
	return self.Experience[skill] or 0
end

function PlayerMeta:IncXP(skill, int)
	skill = string.Capitalize(skill)
	if (!self.Skills[skill]) then self.Skills[skill] = 0 end
	if (!self.Experience[skill]) then self.Experience[skill] = 0 end

	if (self.Experience[skill] + int >= 100) then
		self.Experience[skill] = 0
		self:IncSkill(skill, 1)
		if (skill == "Survival" and self.Skills[skill] > 14) then
			self:AddProfits(1500, false, true)
		end
	else
		self.Experience[skill] = self.Experience[skill] + int
	end

	umsg.Start("gms_SetXP", self)
		umsg.String(skill)
		umsg.Short(self:GetXP(skill))
	umsg.End()
end

function PlayerMeta:DecXP(skill, int)
	skill = string.Capitalize(skill)
	self.Experience[skill] = self.Experience[skill] - int

	umsg.Start("gms_SetXP", self)
		umsg.String(skill)
		umsg.Short(self:GetXP(skill))
	umsg.End()
end

/* Resource functions */
function PlayerMeta:SetResource(resource, int)
	resource = string.Capitalize(resource)
	if (!self.Resources[resource]) then self.Resources[resource] = 0 end

	self.Resources[resource] = int

	umsg.Start("gms_SetResource", self)
		umsg.String(resource)
		umsg.Short(int)
	umsg.End()
end

function PlayerMeta:GetResource(resource)
	resource = string.Capitalize(resource)
	return self.Resources[resource] or 0
end

function PlayerMeta:IncResource(resource, int)
	resource = string.Capitalize(resource)

	if (!self.Resources[resource]) then self.Resources[resource] = 0 end
	local all = self:GetAllResources()
	local max = self.MaxResources

	if (all + int > max) then
		self.Resources[resource] = self.Resources[resource] + (max - all)
		self:DropResource(resource, (all + int) - max)
		self:SendMessage("You can't carry anymore!", 3, Color(200, 0, 0, 255))
	else
		self.Resources[resource] = self.Resources[resource] + int
	end

	umsg.Start("gms_SetResource", self)
		umsg.String(resource)
		umsg.Short(self:GetResource(resource))
	umsg.End()
end

function PlayerMeta:DecResource(resource, int)
	if (!self.Resources[resource]) then self.Resources[resource] = 0 end
	self.Resources[resource] = self.Resources[resource] - int

	umsg.Start("gms_SetResource", self)
		umsg.String(resource)
		umsg.Short(self:GetResource(resource))
	umsg.End()
end

function PlayerMeta:GetAllResources()
	local num = 0

	for k, v in pairs(self.Resources) do
		num = num + v
	end

	return num
end

/* Gmods spawn function already autocorrects. Would be a waste to not use it. */
function PlayerMeta:CreateBuildingSite(pos, angle, model, class, cost)
	local rep = ents.Create("gms_buildsite")
	local tbl = rep:GetTable()
	rep:SetAngles(angle)
	rep.Costs = cost
	tbl:Setup(model, class)
	rep:SetPos(pos)
	rep:Spawn()
	rep.Player = self
	self:SetNetworkedEntity('Hasbuildingsite', rep)
	SPropProtection.PlayerMakePropOwner(self , rep)
	return rep
end

/* pawning from a trace needs some correction... */
function PlayerMeta:CreateStructureBuildingSite(pos, angle, model, class, cost, name)
	local rep = ents.Create("gms_buildsite")
	local tbl = rep:GetTable()
	local str = ":"
	for k, v in pairs(cost) do
		str = str .. " " .. string.Replace(k, "_", " ") .. " (" .. v .. "x)"
	end
	rep:SetAngles(angle)
	rep.Costs = cost
	tbl:Setup(model, class)
	rep:SetPos(pos)
	rep.Name = name
	rep:SetNetworkedString('Name', name)
	rep:SetNetworkedString('Resources', str)
	rep:Spawn()

	local cormin,cormax = rep:WorldSpaceAABB()
	local offset = cormax-cormin
	if (model == "models/props_c17/FurnitureFridge001a.mdl") then pos = pos + Vector(0, 0, 10) end
	rep:SetPos(Vector(pos.x, pos.y, pos.z + (offset.z / 2)))
	if (model != "models/props_c17/factorymachine01.mdl" and model != "models/props_c17/furniturefireplace001a.mdl" and model != "models/Gibs/airboat_broken_engine.mdl" and model != "models/props_c17/furniturestove001a.mdl" and model != "models/props_wasteland/controlroom_desk001b.mdl" and model != "models/props_c17/FurnitureFridge001a.mdl") then
		rep:DropToGround()	
	end
	self:SetNetworkedEntity('Hasbuildingsite', rep)
	rep.Player = self
	SPropProtection.PlayerMakePropOwner(self, rep)
	return rep
end

function PlayerMeta:GetBuildingSite()
	return self:GetNetworkedEntity("Hasbuildingsite")
end

function PlayerMeta:DropResource(resource, int)
	local nearby = {}

	for k, v in pairs(ents.FindByClass("gms_resource*")) do
		if (v:GetPos():Distance(self:GetPos()) < 150) then
			if (v:GetClass() == "gms_resourcedrop" and v.Type != resource) then
			else
				table.insert(nearby, v)
			end
		end
	end

	if (#nearby > 0) then
		local ent = nearby[1]
		if (ent:GetClass() == "gms_resourcedrop") then
			ent.Amount = ent.Amount + int
			ent:SetResourceDropInfoInstant(ent.Type, ent.Amount)
		else
			if (ent.Resources[resource]) then
				ent.Resources[resource] = ent.Resources[resource] + int
			else
				ent.Resources[resource] = int
			end
			ent:SetResPackInfo(resource, ent.Resources[resource])
		end
	else
		local ent = ents.Create("gms_resourcedrop")
		ent:SetPos(self:TraceFromEyes(60).HitPos + Vector(0, 0, 15))
		ent:SetAngles(self:GetAngles())
		ent:Spawn()

		ent:GetPhysicsObject():Wake()

		ent.Type = resource
		ent.Amount = int

		ent:SetResourceDropInfo(ent.Type, ent.Amount)
		SPropProtection.PlayerMakePropOwner(self, ent)
	end
end

/* Food functions */
function PlayerMeta:SetFood(int)
	if (int > 1000) then
		int = 1000
	end

	self.Hunger = int
	self:UpdateNeeds()
end

/* Water functions */
function PlayerMeta:SetThirst(int)
	if (int > 1000) then
		int = 1000
	end

	self.Thirst = int
	self:UpdateNeeds()
end

/* Custom health functions */
function PlayerMeta:Heal(int)
	self:SetHealth(math.min(self:Health() + int, self:GetMaxHealth()))
end

/* Unlock functions */
function PlayerMeta:AddUnlock(text)
	self.FeatureUnlocks[text] = 1

	umsg.Start("gms_AddUnlock", self)
		umsg.String(text)
	umsg.End()

	if (GMS.FeatureUnlocks[text].OnUnlock) then GMS.FeatureUnlocks[text].OnUnlock(self) end
end

function PlayerMeta:HasUnlock(text)
	if (self.FeatureUnlocks[text]) then return true end
	return false
end

function PlayerMeta:CheckForUnlocks()
	for k, unlock in pairs(GMS.FeatureUnlocks) do
		if (!self:HasUnlock(k)) then
			local NrReqs = 0

			for skill, value in pairs(unlock.Req) do
				if (self:GetSkill(skill) >= value) then
					NrReqs = NrReqs + 1
				end
			end

			if (NrReqs == table.Count(unlock.Req)) then
				self:AddUnlock(k)
			end
		end
	end
end

function PlayerMeta:TraceFromEyes(dist)
	local trace = {}
	trace.start = self:GetShootPos()
	trace.endpos = trace.start + (self:GetAimVector() * dist)
	trace.filter = self

	return util.TraceLine(trace)
end

function PlayerMeta:UpdateNeeds()
	umsg.Start("gms_setneeds", self)
		umsg.Short(self.Sleepiness)
		umsg.Short(self.Hunger)
		umsg.Short(self.Thirst)
		umsg.Short(self.Oxygen)
		umsg.Short(self.Power)
		umsg.Short(Time)
	umsg.End()
end

function PlayerMeta:PickupResourceEntity(ent)
	if (!(SPropProtection.PlayerIsPropOwner(self, ent) or SPropProtection.IsBuddy(self, ent)) and !(tonumber(SPropProtection["Config"]["use"]) != 1)) then return end

	local int = ent.Amount
	local room = self.MaxResources - self:GetAllResources()

	if (room <= 0) then self:SendMessage("You can't carry anymore!", 3, Color(200, 0, 0, 255)) return end
	if (room < int) then int = room end
	ent.Amount = ent.Amount - int
	if (ent.Amount <= 0) then ent:Fadeout() else ent:SetResourceDropInfo(ent.Type, ent.Amount) end

	self:IncResource(ent.Type, int)
	self:SendMessage("Picked up " .. string.Replace(ent.Type, "_", " ") .. " (" .. int .. "x)", 4, Color(10, 200, 10, 255))
end

function PlayerMeta:PickupResourceEntityPack(ent)
	if (!(SPropProtection.PlayerIsPropOwner(self, ent) or SPropProtection.IsBuddy(self, ent)) and !(tonumber(SPropProtection["Config"]["use"]) != 1)) then return end

	if (table.Count(ent.Resources) > 0) then
		for res, int in pairs(ent.Resources) do
			local room = self.MaxResources - self:GetAllResources()

			if (room <= 0) then self:SendMessage("You can't carry anymore!", 3, Color(200, 0, 0, 255)) return end
			if (room < int) then int = room end
			ent.Resources[res] = ent.Resources[res] - int

			ent:SetResPackInfo(res, ent.Resources[res])
			if (ent.Resources[res] <= 0) then ent.Resources[res] = nil end

			self:IncResource(res, int)
			self:SendMessage("Picked up " .. string.Replace(res, "_", " ") .. " (" .. int .. "x)", 4, Color(10, 200, 10, 255))
		end
	end
end

/* Saving / loading functions */
function PlayerMeta:MakeLoadingBar(msg)
	umsg.Start("gms_MakeLoadingBar", self)
		umsg.String(msg)
	umsg.End()
end

function PlayerMeta:StopLoadingBar()
	umsg.Start("gms_StopLoadingBar",self)
	umsg.End()
end

function PlayerMeta:MakeSavingBar(msg)
	umsg.Start("gms_MakeSavingBar", self)
		umsg.String(msg)
	umsg.End()
end

function PlayerMeta:StopSavingBar()
	umsg.Start("gms_StopSavingBar", self)
	umsg.End()
end

/* All Smelt Function */
function PlayerMeta:AllSmelt(ResourceTable)
	local resourcedata = {}
	resourcedata.Req = {}
	resourcedata.Results = {}
	local AmountReq = 0
	for k, v in pairs(ResourceTable.Req) do
		if (self:GetResource(k) > 0) then
			if (self:GetResource(k) <= ResourceTable.Max) then
				resourcedata.Req[k] = self:GetResource(k)
				AmountReq = AmountReq + self:GetResource(k)				
			else
				resourcedata.Req[k] = ResourceTable.Max
				AmountReq = AmountReq + ResourceTable.Max
				self:SendMessage("You can only do " .. tostring(ResourceTable.Max) .. " " .. k .. " at a time.", 3, Color(200, 0, 0, 255))
			end
		else
			resourcedata.Req[k] = 1
		end
	end
	for k, v in pairs(ResourceTable.Results) do
		resourcedata.Results[k] = AmountReq
	end
	return resourcedata
end

/*------------------------ Entity Meta ------------------------*/

/* Resource packs and drops */
function EntityMeta:SetResourceDropInfo(strType, int)
	timer.Simple(0.5, self.SetResourceDropInfoInstant, self, strType, int)
end

function EntityMeta:SetResourceDropInfoInstant(strType, int)
	for k, v in pairs(player.GetAll()) do
		local strType = strType or "Error"
		umsg.Start("gms_SetResourceDropInfo", v)
		umsg.String(self:EntIndex())
		umsg.String(string.gsub(strType, "_", " "))
		umsg.Short(self.Amount)
		umsg.End()
	end
end

function EntityMeta:SetResPackInfo(strType, int)
	for k, v in pairs(player.GetAll()) do
		local strType = strType or "Error"
		umsg.Start("gms_SetResPackInfo", v)
		umsg.String(self:EntIndex())
		umsg.String(string.gsub(strType, "_", " "))
		umsg.Short(int)
		umsg.End()
	end
end


function EntityMeta:SetFoodInfo(strType)
	timer.Simple(0.5, self.SetFoodInfoInstant, self, strType)
end

function EntityMeta:SetFoodInfoInstant(strType)
	for k, v in pairs(player.GetAll()) do
		local strType = strType or "Error"
		umsg.Start("gms_SetFoodDropInfo", v)
			umsg.String(self:EntIndex())
			umsg.String(string.gsub(strType, "_", " "))
		umsg.End()
	end
end

/* Model check functions */
function EntityMeta:IsTreeModel()
	if (!self or !self:IsValid()) then return false end

	local trees = table.Add(GMS.TreeModels, GMS.AdditionalTreeModels)
	for k, v in pairs(trees) do
		if (string.lower(v) == self:GetModel() or string.gsub(string.lower(v), "/", "\\") == self:GetModel()) then
			return true
		end
	end

	return false
end

function EntityMeta:IsBerryBushModel()
	if (!self or !self:IsValid()) then return false end

	local mdl = "models/props/pi_shrub.mdl"
	if (mdl == self:GetModel() or string.gsub(string.lower(mdl), "/", "\\") == self:GetModel()) then
		return true
	end

	return false
end

function EntityMeta:IsGrainModel()
	if (!self or !self:IsValid()) then return false end

	local mdl = "models/props_foliage/cattails.mdl"
	if (mdl == self:GetModel() or string.gsub(string.lower(mdl), "/", "\\") == self:GetModel()) then
		return true
	end

	return false
end

function EntityMeta:IsFoodModel()
	if (!self or !self:IsValid()) then return false end

	for k, v in pairs(GMS.EdibleModels) do
		if (string.lower(v) == self:GetModel() or string.gsub(string.lower(v), "/", "\\") == self:GetModel()) then
			return true
		end
	end

	return false
end

function EntityMeta:IsRockModel()
	if (!self or !self:IsValid()) then return false end

	local rocks = table.Add(GMS.RockModels, GMS.AdditionalRockModels)
	for k, v in pairs(rocks) do
		if (string.lower(v) == self:GetModel() or string.gsub(string.lower(v), "/", "\\") == self:GetModel()) then
			return true
		end
	end

	return false
end

function EntityMeta:IsProp()
	local cls = self:GetClass()

	if (cls == "prop_physics" or cls == "prop_physics_multiplayer" or cls == "prop_dynamic") then
		return true
	end

	return false
end

function EntityMeta:GetVolume()
	local min, max = self:OBBMins(), self:OBBMaxs()
	local vol = math.abs(max.x - min.x) * math.abs(max.y - min.y) * math.abs(max.z - min.z)
	return vol / (16 ^ 3)
end

function EntityMeta:IsSleepingFurniture()
	for _, v in ipairs(GMS.SleepingFurniture) do
		if (string.lower(v) == self:GetModel() or string.gsub(string.lower(v), "/", "\\") == self:GetModel()) then
			return true
		end
	end

	return false
end

function EntityMeta:DropToGround()
	local trace = {}
	trace.start = self:GetPos()
	trace.endpos = trace.start + Vector(0, 0, -100000)
	trace.mask = MASK_SOLID_BRUSHONLY
	trace.filter = self

	local tr = util.TraceLine(trace)

	self:SetPos(tr.HitPos)
end

/* Automatic tree reproduction */
function GM.ReproduceTrees()
	local GM = GAMEMODE
	if (GetConVarNumber("gms_ReproduceTrees") == 1) then
		local trees = {}
		for k, v in pairs(ents.GetAll()) do
			if (v:IsTreeModel()) then
				table.insert(trees, v)
			end
		end

		if (#trees < GetConVarNumber("gms_MaxReproducedTrees")) then
			for k, ent in pairs(trees) do
				local num = math.random(1, 3)

				if (num == 1) then
					local nearby = {}
					for k, v in pairs(ents.FindInSphere(ent:GetPos(), 50)) do
						if (v:GetClass() == "gms_seed" or v:IsProp()) then
							table.insert(nearby, v)
						end
					end

					if (#nearby < 3) then
						local pos = ent:GetPos() + Vector(math.random(-500, 500), math.random(-500, 500), 0)
						local retries = 50

						while ((pos:Distance(ent:GetPos()) < 200 or GMS.ClassIsNearby(pos, "prop_physics", 100)) and retries > 0) do
							pos = ent:GetPos() + Vector(math.random(-300, 300),math.random(-300, 300), 0)
							retries = retries - 1
						end

						local pos = pos + Vector(0, 0, 500)

						local seed = ents.Create("gms_seed")
						seed:SetPos(pos)
						seed:DropToGround()
						seed:Setup("tree", 180)
						seed:SetNetworkedString("Owner", "World")
						seed:Spawn()		
					end
				end
			end
		end
		if (#trees == 0) then
			local info = {}
			for i = 1, 20 do
				info.pos = Vector(math.random(-10000, 10000), math.random(-10000, 10000), 1000)
				info.Retries = 50

				--Find pos in world
				while (util.IsInWorld(info.pos) == false and info.Retries > 0) do
					info.pos = Vector(math.random(-10000, 10000),math.random(-10000, 10000), 1000)
					info.Retries = info.Retries - 1
				end

				--Find ground
				local trace = {}
				trace.start = info.pos
				trace.endpos = trace.start + Vector(0, 0, -100000)
				trace.mask = MASK_SOLID_BRUSHONLY

				local groundtrace = util.TraceLine(trace)

				--Assure space
				local nearby = ents.FindInSphere(groundtrace.HitPos, 200)
				info.HasSpace = true

				for k, v in pairs(nearby) do
					if (v:IsProp()) then
						info.HasSpace = false
					end
				end

				--Find sky
				local trace = {}
				trace.start = groundtrace.HitPos
				trace.endpos = trace.start + Vector(0, 0, 100000)

				local skytrace = util.TraceLine(trace)

				--Find water?
				local trace = {}
				trace.start = groundtrace.HitPos
				trace.endpos = trace.start + Vector(0, 0, 1)
				trace.mask = MASK_WATER

				local watertrace = util.TraceLine(trace)

				--All a go, make entity
				if (info.HasSpace and skytrace.HitSky and !watertrace.Hit and (groundtrace.MatType == MAT_DIRT or groundtrace.MatType == MAT_GRASS or groundtrace.MatType == MAT_SAND)) then
					local seed = ents.Create("gms_seed")
					seed:SetPos(groundtrace.HitPos)
					seed:DropToGround()
					seed:Setup("tree", 180 + math.random(-20, 20))
					seed:SetNetworkedString("Owner", "World")
					seed:Spawn()
				end
			end
		end
	end

	timer.Simple(math.random(1, 3) * 60, GM.ReproduceTrees)
end
timer.Simple(60, GM.ReproduceTrees)

/* Loot-Able npcs */
GMS.LootableNPCs = {"npc_antlion", "npc_antlionguard", "npc_crow", "npc_seagull", "npc_pigeon"}

function EntityMeta:IsLootableNPC()
	if table.HasValue(GMS.LootableNPCs, self:GetClass()) then
		return true
	end
	return false
end

/* Campfire */
function EntityMeta:MakeCampfire()
	if (GetConVarNumber("gms_Campfire") == 1) then
		self:Ignite(360, 0)

		self.CampFireMaxHP = self:Health()
		self.CampFireLifeTime = CurTime()

		table.insert(GAMEMODE.CampFireProps, self)

		local mdl = self:GetModel()

		for k, v in pairs(ents.FindInSphere(self:GetPos(),100)) do
			local cls = v:GetClass()
			if (v != ent and v:IsProp()) then
				if (v:GetModel() == mdl) then
					GetConVarNumber("gms_MaxReproducedTrees")
					if (GetConVarNumber("gms_SpreadFire") == 1) then
						v:Ignite(360, (v:OBBMins() - v:OBBMaxs()):Length() * 0.50 + 10)
					else
						v:Ignite(360, 0)
					end

					v.CampFireMaxHP = v:Health()
					v.CampFireLifeTime = CurTime()

					table.insert(GAMEMODE.CampFireProps, v)

					local rp = RecipientFilter()
					rp:AddAllPlayers()
					umsg.Start("addCampFire", rp)
						umsg.Short(v:EntIndex())
					umsg.End()
				end
			end
		end
	end
end

/*------------------------ Console commands ------------------------*/

/* Admin terraforming */
concommand.Add("gms_admin_maketree", function(ply)
	if (!ply:IsAdmin()) then ply:SendMessage("You need admin rights for this!", 3, Color(200, 0, 0, 255)) return end
	local tr = ply:TraceFromEyes(10000)
	GAMEMODE.MakeTree(tr.HitPos)
end)

concommand.Add("gms_admin_makerock", function(ply)
	if (!ply:IsAdmin()) then ply:SendMessage("You need admin rights for this!", 3, Color(200, 0, 0, 255)) return end
	local tr = ply:TraceFromEyes(10000)
	local ent = ents.Create("prop_physics")
	ent:SetAngles(Angle(0, math.random(1, 360), 0))
	ent:SetModel(GMS.RockModels[math.random(1, #GMS.RockModels)])
	ent:SetPos(tr.HitPos)
	ent:Spawn()
	ent:SetNetworkedString("Owner", "World")
	ent:Fadein()
	ent:GetPhysicsObject():EnableMotion(false)
	ent.StrandedProtected = true
end)

concommand.Add("gms_admin_makefood", function(ply)
	if (!ply:IsAdmin()) then ply:SendMessage("You need admin rights for this!", 3, Color(200, 0, 0, 255)) return end

	local tr = ply:TraceFromEyes(10000)
	local ent = ents.Create("prop_physics")
	ent:SetAngles(Angle(0, math.random(1, 360), 0))
	ent:SetModel(GMS.EdibleModels[math.random(1, #GMS.EdibleModels)])
	ent:SetPos(tr.HitPos + Vector(0, 0, 10))		 
	ent:Spawn()
	SPropProtection.PlayerMakePropOwner(ply, ent)
end)

concommand.Add("gms_admin_makeantlionbarrow", function(ply, cmd, args)
	if (!ply:IsAdmin()) then ply:SendMessage("You need admin rights for this!", 3, Color(200, 0, 0, 255)) return end
	if (!args[1]) then ply:SendMessage("Specify max antlions!", 3, Color(200, 0, 0, 255)) return end

	local tr = ply:TraceFromEyes(10000)
	local ent = ents.Create("gms_antlionbarrow")
	ent:SetPos(tr.HitPos)
	ent:Spawn()
	ent:SetNetworkedString("Owner", "World")
	ent:SetKeyValue("MaxAntlions", args[1])
end)

concommand.Add("gms_admin_makebush", function(ply)
	if (!ply:IsAdmin()) then ply:SendMessage("You need admin rights for this!", 3, Color(200, 0, 0, 255)) return end

	local tr = ply:TraceFromEyes(10000)
	local typ = math.random(1, 5)
	local pos = tr.HitPos

	if (typ == 1) then
		GAMEMODE.MakeMelon(pos, math.random(1, 2), ply)
	elseif (typ == 2) then
		GAMEMODE.MakeBanana(pos, math.random(1, 2), ply)
	elseif (typ == 3) then
		GAMEMODE.MakeOrange(pos, math.random(1, 2), ply)
	elseif (typ == 4) then
		GAMEMODE.MakeBush(pos, ply)
	elseif (typ == 5) then
		GAMEMODE.MakeGrain(pos, ply)
	end
end)

concommand.Add("gms_admin_populatearea", function(ply, cmd, args)
	if (!ply:IsAdmin()) then ply:SendMessage("You need admin rights for this!", 3, Color(200, 0, 0, 255)) return end
	if (!args[1] or !args[2] or !args[3]) then ply:SendMessage("You need to specify <type> <amount> <radius>", 3, Color(200, 0, 0, 255)) return end

	for k, v in pairs(player.GetAll()) do
		v:SendMessage("Populating area...", 3, Color(255, 255, 255, 255))
	end

	--Population time
	local Amount = tonumber(args[2])
	local info = {}
	info.Amount = Amount

	if (Amount > 200) then 
		ply:SendMessage("Auto-capped at 200 props.", 3, Color(200, 0, 0, 255))
		info.Amount = 200
	end

	local Type = args[1]
	local Amount = info.Amount
	local Radius = tonumber(args[3])

	--Find playertrace
	local plytrace = ply:TraceFromEyes(10000)

	for i = 1, Amount do
		info.pos = plytrace.HitPos + Vector(math.random(-Radius, Radius), math.random(-Radius, Radius), 1000)
		info.Retries = 50

		--Find pos in world
		while (util.IsInWorld(info.pos) == false and info.Retries > 0) do
			info.pos = plytrace.HitPos + Vector(math.random(-Radius, Radius), math.random(-Radius, Radius), 1000)
			info.Retries = info.Retries - 1
		end

		--Find ground
		local trace = {}
		trace.start = info.pos
		trace.endpos = trace.start + Vector(0, 0, -100000)
		trace.mask = MASK_SOLID_BRUSHONLY

		local groundtrace = util.TraceLine(trace)

		--Assure space
		local nearby = ents.FindInSphere(groundtrace.HitPos, 200)
		info.HasSpace = true

		for k, v in pairs(nearby) do
			if (v:IsProp()) then
				info.HasSpace = false
			end
		end

		--Find sky
		local trace = {}
		trace.start = groundtrace.HitPos
		trace.endpos = trace.start + Vector(0, 0, 100000)

		local skytrace = util.TraceLine(trace)

		--Find water?
		local trace = {}
		trace.start = groundtrace.HitPos
		trace.endpos = trace.start + Vector(0, 0, 1)
		trace.mask = MASK_WATER

		local watertrace = util.TraceLine(trace)

		--All a go, make entity
		if (Type == "Trees") then
			if (info.HasSpace and skytrace.HitSky and !watertrace.Hit and (groundtrace.MatType == MAT_DIRT or groundtrace.MatType == MAT_GRASS or groundtrace.MatType == MAT_SAND)) then
				GAMEMODE.MakeTree(groundtrace.HitPos)
			end
		elseif (Type == "Rocks") then
			if (!watertrace.Hit and (groundtrace.MatType == MAT_DIRT or groundtrace.MatType == MAT_GRASS or groundtrace.MatType == MAT_SAND)) then
				local ent = ents.Create("prop_physics")
				ent:SetAngles(Angle(0, math.random(1, 360), 0))
				ent:SetModel(GMS.RockModels[math.random(1, #GMS.RockModels)])
				ent:SetPos(groundtrace.HitPos)
				ent:Spawn()
				ent:SetNetworkedString("Owner", "World")
				ent:Fadein()
				ent.StrandedProtected = true
				ent:GetPhysicsObject():EnableMotion(false)
			end
		elseif (Type == "Random_Plant" and info.HasSpace) then
			if (!watertrace.Hit and (groundtrace.MatType == MAT_DIRT or groundtrace.MatType == MAT_GRASS or groundtrace.MatType == MAT_SAND)) then
				local typ = math.random(1, 5)
				local pos = groundtrace.HitPos

				if (typ == 1) then
					GAMEMODE.MakeMelon(pos,math.random(1, 2), ply)
				elseif (typ == 2) then
					GAMEMODE.MakeBanana(pos,math.random(1, 2), ply)
				elseif (typ == 3) then
					GAMEMODE.MakeOrange(pos,math.random(1, 2), ply)
				elseif (typ == 4) then
					GAMEMODE.MakeBush(pos, ply)
				elseif (typ == 5) then
					GAMEMODE.MakeGrain(pos, ply)
				end
			end
		end
	end

	--Finished
	for k, v in pairs(player.GetAll()) do
		v:SendMessage("Done!", 3, Color(255, 255, 255, 255))
	end
end)

concommand.Add("gms_admin_clearmap", function(ply)
	if (!ply:IsAdmin()) then ply:SendMessage("You need admin rights for this!", 3, Color(200, 0, 0, 255)) return end

	for k, v in pairs(ents.GetAll()) do
		if (v:IsRockModel() or v:IsTreeModel()) then
			for k, tbl in pairs(GAMEMODE.RisingProps) do
				if (tbl.Entity == v) then
					table.remove(GAMEMODE.RisingProps, k)
				end
			end
			for k, tbl in pairs(GAMEMODE.SinkingProps) do
				if (tbl.Entity == v) then
					table.remove(GAMEMODE.SinkingProps, k)
				end
			end
			for k, ent in pairs(GAMEMODE.FadingInProps) do
				if (ent == v) then
					table.remove(GAMEMODE.FadingInProps, k)
				end
			end
			v:Fadeout()
		end
	end
	
	for k, v in pairs(player.GetAll()) do v:SendMessage("Cleared map.", 3, Color(255, 255, 255, 255)) end
end)

concommand.Add("gms_admin_saveallcharacters", function(ply)
	if (!ply:IsAdmin()) then ply:SendMessage("You need admin rights for this!", 3, Color(200, 0, 0, 255)) return end

	for k, v in pairs(player.GetAll()) do
		GAMEMODE.SaveCharacter(v)
	end

	ply:SendMessage("Saved characters on all current players.", 3, Color(255, 255, 255, 255))
end)

/* Drop all Command */
concommand.Add("gms_dropall", function(ply)
	local DeltaTime = 0
	for k, v in pairs(ply.Resources) do
		if (v > 0) then
			timer.Simple(DeltaTime, function() ply:DecResource(k, v) ply:DropResource(k, v) end, ply, k, v)
			DeltaTime = DeltaTime + 0.3
		end
	end
	ply.NextSpawnTime = CurTime() + DeltaTime + 0.5
end)

/* Salvage Props */
concommand.Add("gms_salvage", function(ply)
	if (ply.InProcess) then return end
	
	local tr = ply:TraceFromEyes(100)
	if (tr.HitNonWorld) then
		ent = tr.Entity
	else
		return
	end 

	if ((ent:GetClass() != "gms_buildsite" and ent.NormalProp == true) and ((SPropProtection.PlayerIsPropOwner(ply, ent) or SPropProtection.IsBuddy(ply, ent)) or tonumber(SPropProtection["Config"]["use"]) != 1)) then
		local vol = ent:GetVolume()

		local res = GMS.MaterialResources[tr.MatType]
		local cost = math.Round(0.6 * math.ceil(vol * GetConVarNumber("gms_CostsScale")))
		ply:IncResource(res, cost)
		ply:SendMessage("Gained " .. string.Replace(res, "_", " ") .. " (" .. cost .. "x) from salvaging.", 3, Color(255, 255, 255, 255))
		ent:Fadeout()
	else
		ply:SendMessage("Cannot salvage this kind of prop.", 5, Color(255, 255, 255, 255))
	end
end)

/* Stealing */
concommand.Add("gms_steal", function(ply, cmd, args)
	local tr = ply:TraceFromEyes(100)
	local ent = tr.Entity

	if (ent != NULL and tr.HitNonWorld) then
		if (IsNight) then
			local cls = ent:GetClass()
			if (ent:GetNetworkedString("Owner", "N/A") != "World" and !ent:IsProp() and cls != "gms_buildsite" and cls != "gms_seed" and !SPropProtection.PlayerIsPropOwner(ply, ent)) then //Add: cant steal own props
				local time = math.max(ent:GetVolume(), 1)
				
				if (cls == "gms_resourcedrop") then
					time = ent.Amount * 0.5
				elseif (cls == "gms_resourcepack" or cls == "gms_fridge") then
					time = 0
					for r, n in pairs(ent.Resources) do
						time = time + (n * 0.25)
					end
				end

				local data = {}
				data.Ent = ent
				ply:DoProcess("Steal", time, data)
			else
				ply:SendMessage("You can't steal this.", 3, Color(200, 0, 0, 255))
			end
		else
			ply:SendMessage("You can steal only at night.", 3, Color(200, 0, 0, 255))
		end
	else
		ply:SendMessage("Aim at the prop to steal.", 3, Color(200, 0, 0, 255))
	end
end)

/* Planting */
function GM.PlantMelon(ply, cmd, args)
	if (ply:GetNWInt("plants") >= GetConVarNumber("gms_PlantLimit")) then 
		ply:SendMessage("You have hit the plant limit.", 3, Color(200, 0, 0, 255))
		return 
	end
	local tr = ply:TraceFromEyes(150)

	if (tr.HitWorld) then
		if (tr.MatType == MAT_DIRT or tr.MatType == MAT_GRASS or tr.MatType == MAT_SAND) and !GMS.IsInWater(tr.HitPos) then
			if (ply:GetResource("Melon_Seeds") >= 1) then
				if (!GMS.ClassIsNearby(tr.HitPos, "gms_seed", 30) and !GMS.ClassIsNearby(tr.HitPos, "prop_physics", 50)) then
					local data = {}
					data.Pos = tr.HitPos
					ply:DoProcess("PlantMelon", 3, data)
				else
					ply:SendMessage("You need more distance between seeds/props.", 3, Color(200, 0, 0, 255))
				end
			else
				ply:SendMessage("You need a watermelon seed.", 3, Color(200, 0, 0, 255))
			end
		else
			ply:SendMessage("You cannot plant on this terrain.", 3, Color(200, 0, 0, 255))
		end
	else
		ply:SendMessage("Aim at the ground to plant.", 3, Color(200, 0, 0, 255))
	end
end
concommand.Add("gms_plantmelon", GM.PlantMelon)

function GM.PlantBanana(ply, cmd, args)
	if (ply:GetNWInt("plants") >= GetConVarNumber("gms_PlantLimit")) then ply:SendMessage("You have hit the plant limit.", 3, Color(200, 0, 0, 255)) return end
	local tr = ply:TraceFromEyes(150)

	if (tr.HitWorld) then
		if ((tr.MatType == MAT_DIRT or tr.MatType == MAT_GRASS or tr.MatType == MAT_SAND) and !GMS.IsInWater(tr.HitPos)) then
			if (ply:GetResource("Banana_Seeds") >= 1) then
				if (!GMS.ClassIsNearby(tr.HitPos, "gms_seed", 30) and !GMS.ClassIsNearby(tr.HitPos, "prop_physics", 50)) then
					local data = {}
					data.Pos = tr.HitPos
					ply:DoProcess("PlantBanana", 3, data)
				else
					ply:SendMessage("You need more distance between seeds/props.", 3, Color(200, 0, 0, 255))
				end
			else
				ply:SendMessage("You need a banana seed.", 3, Color(200, 0, 0, 255))
			end
		else
			ply:SendMessage("You cannot plant on this terrain.", 3, Color(200, 0, 0, 255))
		end
	else
		ply:SendMessage("Aim at the ground to plant.", 3, Color(200, 0, 0, 255))
	end
end
concommand.Add("gms_plantbanana", GM.PlantBanana)

function GM.PlantOrange(ply, cmd, args)
	if (ply:GetNWInt("plants") >= GetConVarNumber("gms_PlantLimit")) then ply:SendMessage("You have hit the plant limit.",3,Color(200,0,0,255)) return end
	local tr = ply:TraceFromEyes(150)

	if (tr.HitWorld) then
		if ((tr.MatType == MAT_DIRT or tr.MatType == MAT_GRASS or tr.MatType == MAT_SAND) and !GMS.IsInWater(tr.HitPos)) then
			if (ply:GetResource("Orange_Seeds") >= 1) then
				if (!GMS.ClassIsNearby(tr.HitPos, "gms_seed", 30) and !GMS.ClassIsNearby(tr.HitPos, "prop_physics", 50)) then
					local data = {}
					data.Pos = tr.HitPos
					ply:DoProcess("PlantOrange", 3, data)
				else
					ply:SendMessage("You need more distance between seeds/props.", 3, Color(200, 0, 0, 255))
				end
			else
				ply:SendMessage("You need an orange seed.", 3, Color(200, 0, 0, 255))
			end
		else
			ply:SendMessage("You cannot plant on this terrain.", 3, Color(200, 0, 0, 255))
		end
	else
		ply:SendMessage("Aim at the ground to plant.", 3, Color(200 ,0, 0, 255))
	end
end
concommand.Add("gms_plantorange", GM.PlantOrange)

function GM.PlantGrain(ply, cmd, args)
	if (!ply:HasUnlock("Grain_Planting")) then ply:SendMessage("You need more planting skill.", 3, Color(200, 0, 0, 255)) return end
	if (ply:GetNWInt("plants") >= GetConVarNumber("gms_PlantLimit")) then ply:SendMessage("You have hit the plant limit.", 3, Color(200, 0, 0, 255)) return end
	local tr = ply:TraceFromEyes(150)

	if (tr.HitWorld) then
		local nearby = false

		for k, v in pairs(ents.FindInSphere(tr.HitPos, 50)) do
			if ((v:IsGrainModel() or v:IsProp() or v:GetClass() == "gms_seed") and (tr.HitPos-Vector(v:LocalToWorld(v:OBBCenter()).x, v:LocalToWorld(v:OBBCenter()).y, tr.HitPos.z)):Length() <= 50) then
				nearby = true
			end
		end

		if ((tr.MatType == MAT_DIRT or tr.MatType == MAT_GRASS or tr.MatType == MAT_SAND) and !GMS.IsInWater(tr.HitPos)) then
			if (ply:GetResource("Grain_Seeds") >= 1) then
				if (!nearby) then
					local data = {}
					data.Pos = tr.HitPos
					ply:DoProcess("PlantGrain", 3, data)
				else
					ply:SendMessage("You need more distance between seeds/props.", 3, Color(200, 0, 0, 255))
				end
			else
				ply:SendMessage("You need a grain seed.", 3, Color(200, 0, 0, 255))
			end
		else
			ply:SendMessage("You cannot plant on this terrain.", 3, Color(200, 0, 0, 255))
		end
	else
		ply:SendMessage("Aim at the ground to plant.", 3, Color(200, 0, 0, 255))
	end
end
concommand.Add("gms_plantgrain", GM.PlantGrain)

function GM.PlantBush(ply, cmd, args)
	if (ply:GetNWInt("plants") >= GetConVarNumber("gms_PlantLimit")) then ply:SendMessage("You have hit the plant limit.", 3, Color(200, 0, 0, 255)) return end
	local tr = ply:TraceFromEyes(150)

	if (tr.HitWorld) then
		local nearby = false

		for k, v in pairs(ents.FindInSphere(tr.HitPos, 50)) do
			if ((v:IsBerryBushModel() or v:IsProp() or v:GetClass() == "gms_seed") and (tr.HitPos-Vector(v:LocalToWorld(v:OBBCenter()).x, v:LocalToWorld(v:OBBCenter()).y, tr.HitPos.z)):Length() <= 50) then
				nearby = true
			end
		end

		if ((tr.MatType == MAT_DIRT or tr.MatType == MAT_GRASS or tr.MatType == MAT_SAND) and !GMS.IsInWater(tr.HitPos)) then
			if (ply:GetResource("Berries") >= 1) then
				if (!nearby) then
					local data = {}
					data.Pos = tr.HitPos
					ply:DoProcess("PlantBush", 3, data)
				else
					ply:SendMessage("You need more distance between seeds/props.", 3, Color(200, 0, 0, 255))
				end
			else
				ply:SendMessage("You need a berry.", 3, Color(200, 0, 0, 255))
			end
		else
			ply:SendMessage("You cannot plant on this terrain.", 3, Color(200, 0, 0, 255))
		end
	else
		ply:SendMessage("Aim at the ground to plant.", 3, Color(200, 0, 0, 255))
	end
end
concommand.Add("gms_plantbush", GM.PlantBush)

function GM.PlantTree(ply, cmd, args)
	if (!ply:HasUnlock("Sprout_Planting")) then ply:SendMessage("You need more planting skill.", 3, Color(200, 0, 0, 255)) return end
	local tr = ply:TraceFromEyes(150)

	if (tr.HitWorld) then 
		if ((tr.MatType == MAT_DIRT or tr.MatType == MAT_GRASS or tr.MatType == MAT_SAND) and !GMS.IsInWater(tr.HitPos)) then
			if (ply:GetResource("Sprouts") >= 1) then
				local data = {}
				data.Pos = tr.HitPos
				ply:DoProcess("PlantTree", 5, data)
			else
				ply:SendMessage("You need a sprout.", 3, Color(200, 0, 0, 255))
			end
		else
			ply:SendMessage("You cannot plant on this terrain.", 3, Color(200, 0, 0, 255))
		end
	else
		ply:SendMessage("Aim at the ground to plant.", 3, Color(200, 0, 0, 255))
	end
end
concommand.Add("gms_planttree", GM.PlantTree)

/* Drink command */
function GM.DrinkFromBottle(ply, cmd, args)
	if (ply:GetResource("Water_Bottles") < 1) then ply:SendMessage("You need a water bottle.", 3, Color(200, 0, 0, 255)) return end
	ply:DoProcess("DrinkBottle", 1.5)
end
concommand.Add("gms_drinkbottle", GM.DrinkFromBottle)

/* Eat berry command */
function GM.DrinkFromBottle(ply, cmd, args)
	if (ply:GetResource("Berries") < 1) then ply:SendMessage("You need some berries.", 3, Color(200, 0, 0, 255)) return end
	ply:DoProcess("EatBerry", 1.5)
end
concommand.Add("gms_eatberry", GM.DrinkFromBottle)

/* Take Medicine command */
function GM.TakeAMedicine(ply, cmd, args)
	if (ply:GetResource("Medicine") < 1) then ply:SendMessage("You need Medicine.", 3, Color(200, 0, 0, 255)) return end
	ply:DoProcess("TakeMedicine", 1.5)
end
concommand.Add("gms_takemedicine", GM.TakeAMedicine)

/* Drop weapon command */
function GM.DropWeapon(ply, cmd, args)
	if (!ply:Alive()) then return end
	//if (ply:GetActiveWeapon():GetClass() == "gms_hands") then ply:SendMessage("You cannot drop your hands!", 3, Color(200, 0, 0, 255))
	//elseif (ply:GetActiveWeapon():GetClass() == "gmod_camera" or ply:GetActiveWeapon():GetClass() == "weapon_physgun" or ply:GetActiveWeapon():GetClass() == "pill_pigeon" or ply:GetActiveWeapon():GetClass() == "weapon_physcannon") then
	if (table.HasValue(GMS.NonDropWeapons, ply:GetActiveWeapon():GetClass())) then
		ply:SendMessage("You cannot drop this!", 3, Color(200, 0, 0, 255))
	else
		ply:DropWeapon(ply:GetActiveWeapon())
	end
end
concommand.Add("gms_dropweapon", GM.DropWeapon)

/* Drop resource command */
function GM.DropResource(ply, cmd, args)
	if (args == nil or args[1] == nil) then ply:SendMessage("You need to at least give a resource type!", 3, Color(200, 0, 0, 255)) return end

	args[1] = string.Capitalize(args[1])
	if (!ply.Resources[args[1]] or ply.Resources[args[1]] == 0) then ply:SendMessage("You don't have this kind of resource.", 3, Color(200, 0, 0, 255)) return end
	if (args[2] == nil or string.lower(args[2]) == "all") then args[2] = tostring(ply:GetResource(args[1])) end

	if (tonumber(args[2]) <= 0) then ply:SendMessage("No zeros/negatives!", 3, Color(200, 0, 0, 255)) return end

	local int = tonumber(args[2])
	local Type = args[1]
	local res = ply:GetResource(Type)

	if (int > res) then
		int = res
	end
	ply:DropResource(Type, int)
	ply:DecResource(Type, int)

	ply:SendMessage("Dropped " .. string.Replace(Type, "_", " ") .. " (" .. int .. "x)", 3, Color(10, 200, 10, 255))
end
concommand.Add("gms_DropResources", GM.DropResource)

/* Admin Drop resource command */
function GM.ADropResource(ply, cmd, args)
	if (!ply:IsAdmin()) then ply:SendMessage("You need admin rights for this!", 3, Color(200, 0, 0, 255)) return end
	if (args == nil or args[1] == nil) then ply:SendMessage("You need to at least give a resource type!", 3, Color(200, 0, 0, 255)) return end

	args[1] = string.Capitalize(args[1])
	if (args[2] == nil or string.lower(args[2]) == "all") then args[2] = tostring(ply:GetResource(args[1])) end
	if (tonumber(args[2]) <= 0) then ply:SendMessage("No zeros/negatives!", 3, Color(200, 0, 0, 255)) return end

	local int = tonumber(args[2])
	local Type = args[1] 

	ply:DropResource(Type, int)
	ply:SendMessage("Dropped " .. string.Replace(Type, "_", " ") .. " (" .. int .. "x)", 3, Color(10, 200, 10, 255))
end
concommand.Add("gms_ADropResources", GM.ADropResource)

/* Take resource command */
function GM.TakeResource(ply, cmd, args)
	if (ply.InProcess) then return end

	if (args == nil or args[1] == nil) then ply:SendMessage("You need to at least give a resource type!", 3, Color(200, 0, 0, 255)) return end
	
	local int = tonumber(args[2]) or 99999
	
	if (int <= 0) then ply:SendMessage("No zeros/negatives!", 3, Color(200, 0, 0, 255)) return end
	args[1] = string.Capitalize(args[1])

	local tr = ply:TraceFromEyes(150)
	local ent = tr.Entity
	local cls = ent:GetClass()

	if (cls != "gms_resourcedrop" and cls != "gms_resourcepack" and cls != "gms_fridge") then return end
	if (!(SPropProtection.PlayerIsPropOwner(ply, ent) or SPropProtection.IsBuddy(ply, ent)) and !(tonumber(SPropProtection["Config"]["use"]) != 1)) then return end
	if ((ply:GetPos() - ent:LocalToWorld(ent:OBBCenter())):Length() >= 100) then return end

	if (cls == "gms_resourcedrop") then
		if (ent.Type != args[1]) then return end
	
		local room = ply.MaxResources - ply:GetAllResources()
		if (int >= ent.Amount) then int = ent.Amount end
		if (room <= 0) then ply:SendMessage("You can't carry anymore!", 3, Color(200, 0, 0, 255)) return end
		if (room < int) then int = room end
		ent.Amount = ent.Amount - int
		if (ent.Amount <= 0) then ent:Fadeout() else ent:SetResourceDropInfo(ent.Type, ent.Amount) end
		
		ply:IncResource(ent.Type, int)
		ply:SendMessage("Picked up " .. string.Replace(ent.Type, "_", " ") .. " (" .. int .. "x)", 4, Color(10, 200, 10, 255))
	end
	
	if (cls == "gms_resourcepack") then
		for res, num in pairs(ent.Resources) do
			if (res == args[1]) then
				local room = ply.MaxResources - ply:GetAllResources()
				if (int >= num) then int = num end
				if (room <= 0) then ply:SendMessage("You can't carry anymore!", 3, Color(200, 0, 0, 255)) return end
				if (room < int) then int = room end
				ent.Resources[res] = num - int
				ent:SetResPackInfo(res, ent.Resources[res]) 
				if (ent.Resources[res] <= 0) then ent.Resources[res] = nil end

				ply:IncResource(res, int)
				ply:SendMessage("Picked up " .. string.Replace(res, "_", " ") .. " (" .. int .. "x)", 4, Color(10, 200, 10, 255))
			end
		end
	end
	
	if (cls == "gms_fridge") then
		for res, num in pairs(ent.Resources) do
			if (res == args[1]) then
				ent.Resources[res] = num - 1
				ent:SetResPackInfo(res, ent.Resources[res]) 
				if (ent.Resources[res] <= 0) then ent.Resources[res] = nil end

				local food = ents.Create("gms_food")
				food:SetPos(ent:GetPos() + Vector(0, 0, ent:OBBMaxs().z + 16))
				SPropProtection.PlayerMakePropOwner(ply, food)
				food.Value = GMS.Combinations["Cooking"][string.Replace(res, " ", "_")].FoodValue
				food.Name = res
				food:Spawn()
				food:SetFoodInfo(res)
				
				timer.Simple(300, function(food) if (food:IsValid()) then food:Fadeout(2) end end, food)
			end
		end
	end
end
concommand.Add("gms_TakeResources", GM.TakeResource) // ply:PickupResourceEntityPack(ent)

/* Buildings menu */
concommand.Add("gms_structures", function(ply)
	ply:OpenCombiMenu("Structures")
end)

/* Generic combi menu */
concommand.Add("gms_combinations", function(ply)
	ply:OpenCombiMenu("Combinations")
end)

/* Make combination */
concommand.Add("gms_MakeCombination", function(ply, cmd, args)
	if (!args[1] or !args[2]) then ply:SendMessage("Please specify a valid combination.", 3, Color(255, 255, 255, 255)) return end

	local group = args[1]
	local combi = args[2]

	if (!GMS.Combinations[group]) then return end
	if (!GMS.Combinations[group][combi]) then return end

	local tbl = GMS.Combinations[group][combi]

	if (group == "Cooking" and tbl.Entity) then
		local nearby = false

		for k, v in pairs(ents.FindInSphere(ply:GetPos(), 100)) do
			if ((v:IsProp() and v:IsOnFire()) or v:GetClass() == tbl.Entity) then nearby = true end
		end

		if (!nearby) then ply:SendMessage("You need to be close to a fire!", 3, Color(200, 0 ,0, 255)) return end
	elseif (tbl.Entity) then
		local nearby = false

		for k, v in pairs(ents.FindInSphere(ply:GetPos(), 100)) do
			if (v:GetClass() == tbl.Entity) then nearby = true end
		end

		if (!nearby) then ply:SendMessage("You need to be close to a " .. tbl.Entity .. "!", 3, Color(200, 0, 0, 255)) return end
	end

	--Check for skills
	local numreq = 0

	if (tbl.SkillReq) then
		for k, v in pairs(tbl.SkillReq) do
			if (ply:GetSkill(k) >= v) then
				numreq = numreq + 1
			end
		end

		if (numreq < table.Count(tbl.SkillReq)) then ply:SendMessage("Not enough skill.", 3, Color(200, 0, 0, 255)) return end
	end

	--Check for resources
	local numreq = 0

	for k, v in pairs(tbl.Req) do
		if (ply:GetResource(k)) >= v then
			numreq = numreq + 1
		end
	end

	if (numreq < table.Count(tbl.Req) and group != "Structures") then ply:SendMessage("Not enough resources.", 3, Color(200, 0, 0, 255)) return end

	--All well, make stuff:
	if (group == "Cooking") then
		local data = {}
		data.Name = tbl.Name
		data.FoodValue = tbl.FoodValue
		data.Cost = table.Copy(tbl.Req)
		local time = 5

		if ply:GetActiveWeapon():GetClass() == "gms_fryingpan" then
			time = 2
		end

		ply:DoProcess("Cook", time, data)
	elseif (group == "Combinations") then
		local data = {}
		data.Name = tbl.Name
		data.Res = tbl.Results
		data.Cost = table.Copy(tbl.Req)
		local time = 5

		ply:DoProcess("MakeGeneric", time, data)
	elseif (group == "gms_gunlab" or group == "gms_gunchunks") then
		local data = {}
		data.Name = tbl.Name
		if (tbl.AllSmelt == true) then
			local sourcetable = ply:AllSmelt(tbl)
			data.Res  = sourcetable.Results
			data.Cost = table.Copy(sourcetable.Req)
		else		
			data.Res = tbl.Results
			data.Cost = table.Copy(tbl.Req)
		end
		local timecount = 1
		for k, v in pairs(data.Cost) do
			timecount  = timecount + v
		end 
		local time = timecount * 0.3

		if (tbl.SwepClass != nil) then
			data.Class = tbl.SwepClass
			ply:DoProcess("MakeWeapon", time, data)
		else		
			ply:DoProcess("Processing", time, data)
		end
	elseif (group == "gms_factory") then
		local data = {}
		data.Name = tbl.Name
		if (tbl.AllSmelt == true) then
			local sourcetable = ply:AllSmelt(tbl)
			data.Res = sourcetable.Results
			data.Cost = table.Copy(sourcetable.Req)
		else		
			data.Res = tbl.Results
			data.Cost = table.Copy(tbl.Req)
		end
		local timecount = 1
		for k, v in pairs(data.Cost) do
			timecount  = timecount + v
		end 
		local time = timecount * 0.3

		if (tbl.SwepClass != nil) then
			data.Class = tbl.SwepClass
			ply:DoProcess("MakeWeapon", time, data)
		else		
			time = math.max(time - math.floor(ply:GetSkill("Smelting") / 5), math.max(timecount * 0.15, 2))
			ply:DoProcess("Smelt", time, data)
		end
	elseif (group == "gms_stoneworkbench" or group == "gms_copperworkbench" or group == "gms_ironworkbench") then
		local data = {}
		data.Name = tbl.Name
		data.Class = tbl.SwepClass
		data.Cost = table.Copy(tbl.Req)
		
		local time = 10
		if (ply:GetActiveWeapon():GetClass() == "gms_copperknife") then time = 7 end
		time = math.max(time - math.floor(math.max(ply:GetSkill("Weapon_Crafting") - 8, 0) / 4), 4)

		ply:DoProcess("MakeWeapon", time, data)
	elseif (group == "Structures") then
		local data = {}
		local trs = {}
		data.Name = tbl.Name
		data.Class = tbl.Results
		data.Cost = table.Copy(tbl.Req) 
		local time = 20
		data.BuildSiteModel = tbl.BuildSiteModel
		trs = ply:TraceFromEyes(250)
		if (!trs.HitWorld) then ply:SendMessage("Aim at the ground to construct a structure.", 3, Color(200, 0, 0, 255)) return end

		ply:DoProcess("MakeBuilding", time, data)
	elseif (group == "gms_stonefurnace") then
		local data = {}
		data.Name = tbl.Name
		if (tbl.AllSmelt == true) then
			local sourcetable = ply:AllSmelt(tbl)
			data.Res  = sourcetable.Results
			data.Cost = table.Copy(sourcetable.Req)
		else		
			data.Res = tbl.Results
			data.Cost = table.Copy(tbl.Req)
		end
		local timecount = 1
		for k, v in pairs(data.Cost) do
			timecount = timecount + v
		end 
		
		local time = timecount * 0.5
		time = math.max(time - math.floor(ply:GetSkill("Smelting") / 5), math.max(timecount * 0.25, 2))

		ply:DoProcess("Smelt", time, data)
	elseif (group == "gms_copperfurnace") then
		local data = {}
		data.Name = tbl.Name
		if (tbl.AllSmelt == true) then
			local sourcetable = ply:AllSmelt(tbl)
			data.Res  = sourcetable.Results
			data.Cost = table.Copy(sourcetable.Req)
		else		
			data.Res = tbl.Results
			data.Cost = table.Copy(tbl.Req)
		end
		local timecount = 1
		for k, v in pairs(data.Cost) do
			timecount = timecount + v
		end 
		local time = timecount * 0.6
		time = math.max(time - math.floor(ply:GetSkill("Smelting") / 5), math.max(timecount * 0.3, 2))

		ply:DoProcess("Smelt", time, data)
	elseif (group == "gms_ironfurnace") then
		local data = {}
		data.Name = tbl.Name
		if (tbl.AllSmelt == true) then
			local sourcetable = ply:AllSmelt(tbl)
			data.Res  = sourcetable.Results
			data.Cost = table.Copy(sourcetable.Req)
		else		
			data.Res = tbl.Results
			data.Cost = table.Copy(tbl.Req)
		end
		local timecount = 1
		for k, v in pairs(data.Cost) do
			timecount = timecount + v
		end 
		local time = timecount * 0.7
		time = math.max(time - math.floor(ply:GetSkill("Smelting") / 5), math.max(timecount * 0.35, 2))

		ply:DoProcess("Smelt", time, data)
	elseif (group == "gms_grindingstone") then
		local data = {}
		data.Name = tbl.Name
		data.Res = tbl.Results
		data.Cost = table.Copy(tbl.Req)
		local timecount = 1
		for k, v in pairs(data.Cost) do
			timecount = timecount + v
		end 
		local time = timecount * 0.75

		ply:DoProcess("Crush", time, data)
	end
end)

/* Sleep */
function GM.PlayerSleep(ply, cmd, args)
	if (ply.Sleeping or !ply:Alive() or ply.AFK == true) then return end
	if (ply.Sleepiness > 700) then ply:SendMessage("You're not tired enough.", 3, Color(255, 255, 255, 255)) return end

	ply.Sleeping = true
	umsg.Start("gms_startsleep", ply)
	umsg.End()

	ply:Freeze(true)

	--Check for shelter
	local trace = {}
	trace.start = ply:GetShootPos()
	trace.endpos = trace.start + (ply:GetUp() * 300)
	trace.filter = ply

	local tr = util.TraceLine(trace)

	if (!tr.HitWorld and !tr.HitNonWorld) then
		ply.NeedShelter = true
	else
		ply.NeedShelter = false
	end
end
concommand.Add("gms_sleep", GM.PlayerSleep)

function GM.PlayerWake(ply, cmd, args)
	if (!ply.Sleeping) then return end
	ply.Sleeping = false
	umsg.Start("gms_stopsleep", ply)
	umsg.End()

	ply:Freeze(false)

	--Check for shelter
	local trace = {}
	trace.start = ply:GetShootPos()
	trace.endpos = trace.start + (ply:GetUp() * 300)
	trace.filter = ply

	local tr = util.TraceLine(trace)

	if (ply.NeedShelter) then
		ply:SendMessage("You should find some shelter!", 5, Color(200, 0, 0, 255))
	else
		ply:SendMessage("Ah, nothing like a good nights sleep!", 5, Color(255, 255, 255, 255))
	end
end
concommand.Add("gms_wakeup", GM.PlayerWake)

/* AFK */
function GM.AFK(ply, cmd, args)
	if (ply.Sleeping or !ply:Alive()) then return end
	if (ply.InProcess) then return end
	if (ply.AFK == false or ply.AFK == nil) then
		ply:SetNWString("AFK", 1)
		ply.AFK = true			
		umsg.Start("gms_startafk", ply)
		umsg.End()
	else
		ply:SetNWString("AFK", 0)
		ply.AFK = false			
		umsg.Start("gms_stopafk", ply)
		umsg.End()
	end

	ply:Freeze(ply.AFK)
end
concommand.Add("gms_afk", GM.AFK)

/* Player Stuck */
function GM.PlayerStuck(ply, cmd, args)
	if (ply.InProcess) then return end
	if (ply.Spam == true) then ply:SendMessage("No spamming!", 3, Color(200, 0, 0, 255)) return end
	if (ply.Spam == false or ply.Spam == nil) then ply:SetPos(ply:GetPos() + Vector(0, 0, 64)) end

	ply.Spam = true
	timer.Simple(0.2, function() ply.Spam = false end, ply)
end
concommand.Add("gms_stuck", GM.PlayerStuck)

/* Make Campfire command */
function GM.MakeCampfire(ply, cmd, args)
	if (GetConVarNumber("gms_Campfire") == 1) then
		local tr = ply:TraceFromEyes(150)

		if (!tr.HitNonWorld or !tr.Entity) then ply:SendMessage("Aim at the prop(s) to use for campfire.", 3, Color(255, 255, 255, 255)) return end

		local ent = tr.Entity
		local cls = tr.Entity:GetClass()

		if (ent:IsOnFire() or cls != "prop_physics" and cls != "prop_physics_multiplayer" and cls != "prop_dynamic") then
			ply:SendMessage("Aim at the prop(s) to use for campfire.", 3, Color(255, 255, 255, 255))
			return
		end

		local mat = tr.MatType

		if (ply:GetResource("Wood") < 5) then ply:SendMessage("You need at least 5 wood to make a fire.", 5, Color(255, 255, 255, 255)) return end

		if (mat != MAT_WOOD) then ply:SendMessage("Prop has to be wood, or if partially wood, aim at the wooden part.", 5, Color(255, 255, 255, 255)) return end

		local data = {}
		data.Entity = ent
		
		if ((SPropProtection.PlayerIsPropOwner(ply, ent) or SPropProtection.IsBuddy(ply, ent)) or tonumber(SPropProtection["Config"]["use"]) != 1) then		
			ply:DoProcess("Campfire", 5, data)
			return
		end
	end
end
concommand.Add("gms_makefire", GM.MakeCampfire)

/*------------------------ Prop fadeout ------------------------*/
GMS.FadingOutProps = {}
GMS.FadingInProps = {}

function EntityMeta:Fadeout(speed)
	if (!self or !self:IsValid()) then return end
	local speed = speed or 1

	for k, v in pairs(player.GetAll()) do
		umsg.Start("gms_CreateFadingProp", v)
			umsg.String(self:GetModel())
			umsg.Vector(self:GetPos())
			umsg.Vector(self:GetAngles():Forward())
			umsg.Short(math.Round(speed))
		umsg.End()
	end

	self:Remove()
end

--Fadein is serverside
function EntityMeta:Fadein()
	self.AlphaFade = 0
	self:SetColor(255, 255, 255, 0)
	table.insert(GMS.FadingInProps, self)
end

hook.Add("Think", "gms_FadePropsThink", function()
	for k, ent in pairs(GMS.FadingInProps) do
		if (!ent or ent == NULL) then
			table.remove(GMS.FadingInProps, k)
		elseif (!ent:IsValid()) then
			table.remove(GMS.FadingInProps, k)
		elseif (ent.AlphaFade >= 255) then
			table.remove(GMS.FadingInProps, k)
		else
			ent.AlphaFade = ent.AlphaFade + 5
			ent:SetColor(255, 255, 255, ent.AlphaFade)
		end
	end
end)

/*------------------------ Prop rising / lowering (Used by gms_seed) ------------------------*/
GM.RisingProps = {}
GM.SinkingProps = {}

function EntityMeta:RiseFromGround(speed, altmax)
	local speed = speed or 1
	local max;

	if (!altmax) then
		min, max = self:WorldSpaceAABB()
		max = max.z
	else
		max = altmax
	end

	local tbl = {}
	tbl.Origin = self:GetPos().z
	tbl.Speed = speed
	tbl.Entity = self

	self:SetPos(self:GetPos() + Vector(0, 0, -max + 10))
	table.insert(GAMEMODE.RisingProps, tbl)
end

function EntityMeta:SinkIntoGround(speed)
	local speed = speed or 1

	local tbl = {}
	tbl.Origin = self:GetPos().z
	tbl.Speed = speed
	tbl.Entity = self
	tbl.Height = max

	table.insert(GAMEMODE.SinkingProps, tbl)
end

hook.Add("Think", "gms_RiseAndSinkPropsHook", function()
	for k, tbl in pairs(GAMEMODE.RisingProps) do
		if (tbl.Entity:GetPos().z >= tbl.Origin) then
			table.remove(GAMEMODE.RisingProps, k)
		else
			tbl.Entity:SetPos(tbl.Entity:GetPos() + Vector(0, 0, 1 * tbl.Speed))
		end
	end

	for k, tbl in pairs(GAMEMODE.SinkingProps) do
		if tbl.Entity:GetPos().z <= tbl.Origin - tbl.Height then
			table.remove(GAMEMODE.SinkingProps, k)
			tbl.Entity:Remove()
		else
			tbl.Entity:SetPos(tbl.Entity:GetPos() + Vector(0, 0, -1 * tbl.Speed))
		end
	end
end)

/*------------------------ Spawn / death ------------------------*/
function GM:PlayerInitialSpawn(ply)
	--Create HUD
	umsg.Start("gms_CreateInitialHUD", ply)
	umsg.End()

	ply:SetTeam(1)

	--Serverside player variables
	ply.Skills = {}
	ply.Resources = {}
	ply.Experience = {}
	ply.FeatureUnlocks = {}	
	ply.Loaded = false

	--Admin info, needed clientside
	if (ply:IsAdmin()) then
		for k, v in pairs(file.Find("GMStranded/Gamesaves/*.txt")) do
			local name = string.sub(v, 1, string.len(v) - 4)

			if (string.Right(name, 5) != "_info") then
				umsg.Start("gms_AddLoadGameToList", ply)
				umsg.String(name)
				umsg.End()
			end
		end
	end

	--Character loading
	if (file.Exists("GMStranded/saves_glon/" .. ply:UniqueID() .. ".txt")) then
		local tbl = glon.decode(file.Read("GMStranded/saves_glon/" .. ply:UniqueID() .. ".txt"))

		if (tbl["skills"]) then
			for k, v in pairs(tbl["skills"]) do
				ply:SetSkill(k, v)
			end
		end

		if (tbl["experience"]) then
			for k, v in pairs(tbl["experience"]) do
				ply:SetXP(k, v)
			end
		end

		if (tbl["unlocks"]) then 
			for k, v in pairs(tbl["unlocks"]) do
				if (k == "Sprint_Mki") then k = "Sprinting_I" end
				if (k == "Sprint_Mkii") then k = "Sprinting_II" end
				if (k == "Sprinting_Ii") then k = "Sprinting_II" end
				if (k == "Sprout_Collect") then k = "Sprout_Collecting" end
				ply.FeatureUnlocks[k] = v
			end
		end

		if (tbl["resources"]) then
			for k, v in pairs(tbl["resources"]) do
				ply:SetResource(k, v)
			end
		end
		
		if (tbl["weapons"]) then
			for k, v in pairs(tbl["weapons"]) do
				ply:Give(v)
			end
		end
		
		ply:StripAmmo()
		
		if (tbl["ammo"]) then
			for k, v in pairs(tbl["ammo"]) do
				ply:GiveAmmo(v, k)
			end
		end

		if (!ply.Skills["Survival"]) then ply.Skills["Survival"] = 0 end
		ply.MaxResources = (ply.Skills["Survival"] * 5) + 25
		ply.Loaded = true
		ply:SendMessage("Loaded character successfully.", 3, Color(255, 255, 255, 255))
		ply:SendMessage("Last visited on " .. tbl.date .. ", enjoy your stay.", 10, Color(255, 255, 255, 255))
	elseif (file.Exists("GMStranded/Saves/" .. ply:UniqueID() .. ".txt")) then
		local tbl = util.KeyValuesToTable(file.Read("GMStranded/Saves/" .. ply:UniqueID() .. ".txt"))

		if (tbl["skills"]) then
			for k, v in pairs(tbl["skills"]) do
				ply:SetSkill(string.Capitalize(k), v)
			end
		end

		if (tbl["experience"]) then
			for k, v in pairs(tbl["experience"]) do
				ply:SetXP(string.Capitalize(k), v)
			end
		end

		if (tbl["unlocks"]) then 
			for k, v in pairs(tbl["unlocks"]) do
				k = string.Capitalize(k)
				if (k == "Sprint_Mki") then k = "Sprinting_I" end
				if (k == "Sprint_Mkii") then k = "Sprinting_II" end
				if (k == "Sprinting_Ii") then k = "Sprinting_II" end
				if (k == "Sprout_Collect") then k = "Sprout_Collecting" end
				ply.FeatureUnlocks[k] = v
			end
		end

		if (tbl["resources"]) then
			for k, v in pairs(tbl["resources"]) do
				ply:SetResource(string.Capitalize(k), v)
			end
		end
		
		if (tbl["weapons"]) then
			for k, v in pairs(tbl["weapons"]) do
				ply:Give(v)
			end
		end
		
		ply:StripAmmo()
		
		if (tbl["ammo"]) then
			for k, v in pairs(tbl["ammo"]) do
				ply:GiveAmmo(v, k)
			end
		end

		if (!ply.Skills["Survival"]) then ply.Skills["Survival"] = 0 end
		ply.MaxResources = (ply.Skills["Survival"] * 5) + 25
		ply.Loaded = true
		ply:SendMessage("Loaded character successfully.", 3, Color(255, 255, 255, 255))
		ply:SendMessage("Last visited on " .. tbl.date .. ", enjoy your stay.", 10, Color(255, 255, 255, 255))
		GAMEMODE.SaveCharacter(ply)
	else
		ply:SetSkill("Survival", 0)
		ply:SetXP("Survival", 0)
		ply.MaxResources = 25
		ply.Loaded = true
	end

	ply:SetNWInt("plants", 0)
	for k, v in pairs(ents.GetAll()) do
		if (v and v:IsValid() and v:GetNWEntity("plantowner") and v:GetNWEntity("plantowner"):IsValid() and v:GetNWEntity("plantowner") == ply) then
			ply:SetNWInt("plants", ply:GetNWInt("plants") + 1)
		end
	end
	
	timer.Simple(3, function()
		for i, v in pairs(GAMEMODE.CampFireProps) do
			umsg.Start("addCampFire", ply)
				umsg.Short(v:EntIndex())
			umsg.End()
		end
	end)
	
	timer.Simple(4, function()
		for i, v in pairs(GAMEMODE.Tribes) do
			umsg.Start("recvTribes", ply)
			umsg.Short(v.id)
			umsg.String(i)
			umsg.Short(v.red)
			umsg.Short(v.green)
			umsg.Short(v.blue)
			if (v.Password == false) then 
				umsg.Bool(false)
			else
				umsg.Bool(true)
			end
			umsg.End()
		end
	end)
	
	timer.Simple(5, function()
		for _, v in ipairs(ents.FindByClass("gms_resourcedrop")) do
			umsg.Start("gms_SetResourceDropInfo", ply)
				umsg.String(v:EntIndex())
				umsg.String(string.gsub(v.Type, "_", " "))
				umsg.Short(v.Amount)
			umsg.End()
		end
	end)
	
	local time = 7
	for _, v in ipairs(ents.FindByClass("gms_resourcepack")) do
		for res, num in pairs(v.Resources) do
			timer.Simple(time, function(ply)
				umsg.Start("gms_SetResPackInfo", ply)
				umsg.String(v:EntIndex())
				umsg.String(string.gsub(res, "_", " "))
				umsg.Short(num)
				umsg.End()
			end, ply)
			time = time + 0.5
		end
		time = time + 1
	end
	for _, v in ipairs(ents.FindByClass("gms_fridge")) do
		for res, num in pairs(v.Resources) do
			timer.Simple(time, function(ply)
				umsg.Start("gms_SetResPackInfo", ply)
				umsg.String(v:EntIndex())
				umsg.String(string.gsub(res, "_", " "))
				umsg.Short(num)
				umsg.End()
			end, ply)
			time = time + 0.5
		end
		time = time + 1
	end
	
	timer.Simple(6, function()
		for _, v in ipairs(ents.FindByClass("gms_food")) do
			umsg.Start("gms_SetFoodDropInfo", ply)
				umsg.String(v:EntIndex())
				umsg.String(string.gsub(v.Name, "_", " "))
			umsg.End()
		end
	end)
end

function GM:PlayerSpawn(ply)
	SetGlobalInt("plantlimit", GetConVarNumber("gms_PlantLimit"))

	GAMEMODE:SetPlayerSpeed(ply, 250, 250)
	ply:SetMaxHealth(100)
	
	for k, v in pairs(GMS.FeatureUnlocks) do
		if (ply:HasUnlock(k) and v.OnUnlock) then
			v.OnUnlock(ply)
		end
	end

	self:PlayerLoadout(ply)
	self:PlayerSetModel(ply)

	ply.Sleepiness = 1000
	ply.Hunger = 1000
	ply.Thirst = 1000
	ply.Oxygen = 1000
	ply.Power = 50
	ply:UpdateNeeds()
end

function GM:PlayerLoadout(ply)
	ply:Give("gms_hands") --Tools

	if (GetConVarNumber("gms_AllTools") == 1) then
		for id, wep in pairs(GMS.AllWeapons) do
			ply:Give(wep)
		end
	end

	if (GetConVarNumber("gms_physgun") == 1 or ply:IsAdmin()) then ply:Give("weapon_physgun") end
	if (ply:IsAdmin() or ply:IsSuperAdmin()) then ply:Give("gmod_tool") ply:Give("pill_pigeon") end
	ply:Give("weapon_physcannon")
	ply:SelectWeapon("weapon_physgun")
	ply:SelectWeapon("gms_hands")
end

function GM:PlayerCanPickupWeapon(ply, wep)
	if (ply:HasWeapon(wep:GetClass())) then return false end
	return true
end

hook.Add("PlayerDeath", "Death", function(ply)
	ply:ConCommand("gms_dropall")

	for _, v in pairs(ply:GetWeapons()) do
		if (!table.HasValue(GMS.NonDropWeapons, v:GetClass())) then
			ply:DropWeapon(v)
			SPropProtection.PlayerMakePropOwner(ply, v)
		end
	end
	
	if (ply.AFK == true) then
		ply:Freeze(false)
		ply.AFK = false
		umsg.Start("gms_stopafk", ply)
		umsg.End()
	end
end)

function GM.AutoSaveAllCharacters()
	SetGlobalInt("plantlimit", GetConVarNumber("gms_PlantLimit"))
	if (GetConVarNumber("gms_AutoSave") == 1) then
		for k, v in pairs(player.GetAll()) do
			v:SendMessage("Autosaving..", 3, Color(255, 255, 255, 255))
			GAMEMODE.SaveCharacter(v)
		end
	end
end
timer.Create("GMS.AutoSaveAllCharacters", math.Clamp(GetConVarNumber("gms_AutoSaveTime"), 1, 60) * 60, 0, GM.AutoSaveAllCharacters)

function GM:PlayerDisconnected(ply)
	Msg("Saving character of disconnecting player " .. ply:Nick() .. "...\n")
	self.SaveCharacter(ply)
end

function GM:ShutDown()
	for k, v in pairs(player.GetAll()) do
		self.SaveCharacter(v)
	end
end

function GM.SaveCharacter(ply,cmd,args)
	if (!file.IsDir("GMStranded")) then file.CreateDir("GMStranded") end
	if (!file.IsDir("GMStranded/saves_glon")) then file.CreateDir("GMStranded/saves_glon") end
	if (!ply.Loaded) then
		print("Player " .. ply:Name() .. " tried to save before he has loaded!")
		ply:SendMessage("Character save failed: Not yet loaded!", 3, Color(255, 50, 50, 255))
		return
	end

	local tbl = {}
	tbl["skills"] = {}
	tbl["experience"] = {}
	tbl["unlocks"] = {}
	tbl["date"] = os.date("%A %m/%d/%y")
	tbl["name"] = ply:Nick()
	
	tbl["resources"] = {}
	tbl["weapons"] = {}
	tbl["ammo"] = {}

	for k, v in pairs(ply.Skills) do
		tbl["skills"][k] = v
	end

	for k, v in pairs(ply.Experience) do
		tbl["experience"][k] = v
	end

	for k, v in pairs(ply.FeatureUnlocks) do
		tbl["unlocks"][k] = v
	end
	
	for k, v in pairs(ply.Resources) do
		if v > 0  then
			tbl["resources"][k] = v
		end
	end
	
	for id, wep in pairs(ply:GetWeapons()) do
		if (wep:GetClass() != "gms_hands" or wep:GetClass() != "weapon_physgun" or wep:GetClass() != "weapon_physcannon") then
			table.insert(tbl["weapons"], wep:GetClass())
		end
	end
	
	local ammo_types = {"ar2", "smg1", "pistol", "buckshot", "357", "grenade", "alyxgun", "xbowbolt", "AlyxGun", "RPG_Round","SMG1_Grenade", "SniperRound",
		"SniperPenetratedRound", "Grenade", "Thumper", "Gravity", "Battery", "GaussEnergy", "CombineCannon", "AirboatGun", "StriderMinigun", "StriderMinigunDirect",
		"HelicopterGun", "AR2AltFire", "Grenade", "Hopwire", "CombineHeavyCannon", "ammo_proto1"}

	for id, str in pairs(ammo_types) do
		local ammo = ply:GetAmmoCount(str)
		if (ammo > 0) then
			tbl["ammo"][str] = ammo
		end
	end

	file.Write("GMStranded/saves_glon/" .. ply:UniqueID() .. ".txt", glon.encode(tbl))
	if (file.Exists("GMStranded/Saves/" .. ply:UniqueID() .. ".txt")) then // Since we are using GLON, we don't need the old save games... Or do we? Maybe in case of something it is good to have a backup, but i am confident in own code ;)
		file.Delete("GMStranded/Saves/" .. ply:UniqueID() .. ".txt")
	end
	ply:SendMessage("Saved character!", 3, Color(255, 255, 255, 255))
end
concommand.Add("gms_savecharacter", GM.SaveCharacter)

/*------------------------ STOOLs and Physgun ------------------------*/

function GM:PhysgunPickup(ply, ent)
	if (ply:IsAdmin()) then return true end

	if (ent.StrandedProtected or ent:IsRockModel() or ent:IsTreeModel() or ent:IsPlayer() or table.HasValue(GMS.PickupProhibitedClasses, ent:GetClass())) then
		return false
	else
		return true
	end
end

function GM:GravGunPunt(ply, ent)
	return ply:IsAdmin()
end

function GM:CanTool(ply, tr ,mode)
	local ent = tr.Entity

	if (mode == "remover") then
		if (!ply:IsAdmin() and (ent:IsFoodModel() or ent:IsTreeModel() or ent:IsRockModel() or table.HasValue(GMS.PickupProhibitedClasses, ent:GetClass()))) then
			ply:SendMessage("This is prohibited!", 3, Color(200, 0, 0, 255))
			return false
		end
	end
	
	if (mode == "rope") then
		if (ply:GetResource("Rope") < 1) then ply:SendMessage("You need rope to use this tool.", 3, Color(200, 0, 0, 255)) return false end
	end
	
	if (mode == "weld" or mode == "weld_ez") then
		if (ply:GetResource("Welder") < 1) then ply:SendMessage("You need a Welder to use this tool.", 3, Color(200, 0, 0, 255)) return false end
	end

	if (table.HasValue(GMS.ProhibitedStools, mode)) then ply:SendMessage("This sTOOL is prohibited.", 3, Color(200, 0, 0, 255)) return false end

	return true
end

/*------------------------ Prop spawning ------------------------*/
function GM:PlayerSpawnedProp(ply, mdl, ent)
	SPropProtection.PlayerMakePropOwner(ply, ent)
	if (GetConVarNumber("gms_FreeBuild") == 1) then return end
	if (GetConVarNumber("gms_FreeBuildSA") == 1 and ply:IsSuperAdmin()) then return end
	if (ply.InProcess) then ent:Remove() return end
	
	ent.NormalProp = true
	
	if (ply.CanSpawnProp == false) then ent:Remove() ply:SendMessage("No spamming!", 3, Color(200, 0, 0, 255)) return end

	ply.CanSpawnProp = false
	timer.Simple(0.2, self.PlayerSpawnedPropDelay, self, ply, mdl, ent)
end

function GM:PlayerSpawnedPropDelay(ply, mdl, ent)
	ply.CanSpawnProp = true
	if (ply.InProcess) then return end
	if (!ent or !ent:IsValid()) then return end
	
	--Admin only models
	if ((ent:IsRockModel() or ent:IsTreeModel() or ent:IsFoodModel()) and !ply:IsAdmin()) then
		ent:Remove() ply:SendMessage("You cannot spawn this prop unless you're admin.", 5, Color(255, 255, 255, 255))
		return
	end

	--Trace
	ent.EntOwner = ply

	-- Do volume in cubic "feet"
	local vol = ent:GetVolume()

	local x = 0
	local trace = nil
	local tr = nil
	trace = {}
	trace.start = ent:GetPos() + Vector((math.random() * 200) - 100, (math.random() * 200) - 100, (math.random() * 200) - 100)
	trace.endpos = ent:GetPos()
	tr = util.TraceLine(trace)

	while (tr.Entity != ent and x < 5) do
		x = x + 1
		trace = {}
		trace.start = ent:GetPos() + Vector((math.random() * 200) - 100, (math.random() * 200) - 100, (math.random() * 200) - 100)
		trace.endpos = ent:GetPos()
		tr = util.TraceLine(trace)
	end

	--Faulty trace
	if (tr.Entity != ent) then ent:Remove() ply:SendMessage("You need more space to spawn.", 3, Color(255, 255, 255, 255)) return end

	local res = GMS.MaterialResources[tr.MatType]
	local cost = math.ceil(vol * GetConVarNumber("gms_CostsScale"))

	if (cost > ply:GetResource(res)) then
		if (ply:GetBuildingSite() and ply:GetBuildingSite():IsValid()) then ply:GetBuildingSite():Remove() end
		local site = ply:CreateBuildingSite(ent:GetPos(), ent:GetAngles(), ent:GetModel(), ent:GetClass())
		local tbl = site:GetTable()
		site.EntOwner = ply
		site.NormalProp = true
		local costtable = {}
		costtable[res] = cost

		tbl.Costs = table.Copy(costtable)
		ply:DoProcess("Assembling", 2)
		ply:SendMessage("Not enough resources, creating buildsite.", 3, Color(255, 255, 255, 255))
		local str = ":"
		for k, v in pairs(site.Costs) do
			str = str .. " " .. string.Replace(k, "_", " ") .. " (" .. v .. "x)"
		end
		site:SetNetworkedString('Resources', str)
		local Name = "Prop"
		site:SetNetworkedString('Name', Name)
		ent:Remove()
		return
	end

	--Resource cost
	if ply:GetResource(res) < cost then
		ent:Remove()
		ply:SendMessage("You need " .. string.Replace(res, "_", " ") .. " (" .. cost .. "x) to spawn this prop.", 3, Color(200, 0, 0, 255))
	else
		ply:DecResource(res,cost)
		ply:SendMessage("Used " .. string.Replace(res, "_", " ") .. " (" .. cost .. "x) to spawn this prop.", 3, Color(255, 255, 255, 255))
		ply:DoProcess("Assembling", 5)
	end
end

function GM:PlayerSpawnedEffect(ply, mdl, ent)
	if (GetConVarNumber("gms_FreeBuild") == 1) then return end
	ent:Remove()
end

function GM:PlayerSpawnedNPC(ply, ent)
	if (GetConVarNumber("gms_FreeBuild") == 1) then return end
	ent:Remove()
end

function GM:PlayerSpawnedVehicle(ply, ent)
	if (GetConVarNumber("gms_FreeBuild") == 1) then return end
	ent:Remove()
end

function GM:PlayerSpawnedSENT(ply, prop)
	if (GetConVarNumber("gms_AllowSENTSpawn") == 1) then return end
	prop:Remove()
end

function CCSpawnSWEP(player, command, arguments) 
	if (GetConVarNumber("gms_AllowSWEPSpawn") == 0) then player:SendMessage("SWEP spawning is disabled.", 3, Color(200, 0, 0, 255)) return end
	if (arguments[1] == nil) then return end 

	-- Make sure this is a SWEP 
	local swep = weapons.GetStored(arguments[1]) 
	if (swep == nil) then return end 

	-- You're not allowed to spawn this! 
	if (!swep.Spawnable && !player:IsAdmin()) then return end 

	MsgAll("Giving " .. player:Nick() .. " a " .. swep.Classname .. "\n") 
	player:Give(swep.Classname) 

end 
concommand.Add("gm_giveswep", CCSpawnSWEP)
 
/*------------------------ Needs ------------------------*/
function GM.SubtractNeeds()
	for k, ply in pairs(player.GetAll()) do
		if (ply:Alive()) then
			--Sleeping
			if (ply.Sleeping) then
				if (ply.Sleepiness <= 950) then
					local trace = {}
					trace.start = ply:GetShootPos()
					trace.endpos = trace.start - (ply:GetUp() * 300)
					trace.filter = ply

					local tr = util.TraceLine(trace)
					if (Entity(tr.Entity) and tr.Entity:IsSleepingFurniture()) then
						ply.Sleepiness = ply.Sleepiness + 100
					else
						ply.Sleepiness = ply.Sleepiness + 50
					end
				elseif (ply.Sleepiness > 950) then
					ply.Sleepiness = 1000
					GAMEMODE.PlayerWake(ply)
				end

				if (ply.Thirst - 20 < 0) then
					ply.Thirst = 0
				else
					ply.Thirst = ply.Thirst - 20
				end

				if (ply.Hunger - 20 < 0) then
					ply.Hunger = 0
				else
					ply.Hunger = ply.Hunger - 20
				end

				if (ply.NeedShelter) then
					if (ply:Health() >= 11) then
						ply:SetHealth(ply:Health() - 10)
					else
						ply:Kill()
						for k, v in pairs(player.GetAll()) do v:SendMessage(ply:Nick() .. " didn't survive.", 3, Color(170, 0, 0, 255)) end
					end
				end
			end

			--Kay you're worn out
			if (ply.AFK != true) then
				if (ply.Sleepiness > 0) then ply.Sleepiness = ply.Sleepiness - 2 end // 2
				if (ply.Thirst > 0) then ply.Thirst = ply.Thirst - 6 end // 6
				if (ply.Hunger > 0) then ply.Hunger = ply.Hunger - 3 end // 3
			end

			ply:UpdateNeeds()

			--Are you dying?
			if (ply.Sleepiness <= 0 or ply.Thirst <= 0 or ply.Hunger <= 0) then
				if (ply:Health() >= 3) then
					ply:SetHealth(ply:Health() - 2)
				else
					ply:Kill()
					for k, v in pairs(player.GetAll()) do v:SendMessage(ply:Nick() .. " didn't survive.", 3, Color(170, 0, 0, 255)) end
				end
			end
			
			if (ply.Oxygen <= 0) then
				if (ply:Health() >= 11) then
					ply:SetHealth(ply:Health() - 10)
				else
					ply:Kill()
					for k, v in pairs(player.GetAll()) do v:SendMessage(ply:Nick() .. " has drowned.", 3, Color(170, 0, 0, 255)) end
				end
			end
		end
	end
end
timer.Create("GMS.SubtractNeeds", 3, 0, GM.SubtractNeeds)

/* NPC Looting and hunting */
function GM:OnNPCKilled(npc, killer, weapon)
	if (npc:IsLootableNPC()) then
		if (killer:IsPlayer()) then
			local loot = ents.Create("gms_loot")
			local tbl = loot:GetTable()
			local num = math.random(1, 3)

			local res = {}
			SPropProtection.PlayerMakePropOwner(killer, loot)
			res["Meat"] = num
			tbl.Resources = res
			loot:SetPos(npc:GetPos() + Vector(0, 0, 64))
			loot:Spawn()
			timer.Simple(180, function(loot) if (loot:IsValid()) then loot:Fadeout(2) end end, loot)
			npc:Fadeout(5)

			killer:IncXP("Hunting", math.Clamp(math.Round(50 / killer:GetSkill("Hunting")), 1, 1000))
		else
			npc:Fadeout(5)			
		end
	end
end

/* Campfire timer */
GM.CampFireProps = {}
function GM.CampFireTimer()
	if (GetConVarNumber("gms_Campfire") == 1) then
		local GM = GAMEMODE

		for k, ent in pairs(GM.CampFireProps) do
			if (!ent or ent == NULL) then
				table.remove(GM.CampFireProps, k)
			else
				if (CurTime() - ent.CampFireLifeTime >= 360) then
					ent:Fadeout()
					table.remove(GM.CampFireProps, k)
				elseif (ent:WaterLevel() > 0) then
					ent:Extinguish()
					table.remove(GM.CampFireProps, k)
				else	
					ent:SetHealth(ent.CampFireMaxHP)
				end
			end
		end
	end
end
timer.Create("GMS.Campfire", 1, 0, GM.CampFireTimer)

/* Use Hook */
hook.Add("KeyPress", "GMS_UseKeyHook", function(ply, key)
	if (key != IN_USE) then return end
	if (ply:KeyDown(1)) then return end
		
	local tr = ply:TraceFromEyes(150)
	if (tr.HitNonWorld) then
		if (tr.Entity and !GMS.IsInWater(tr.HitPos)) then
			local ent = tr.Entity
			if (!ent or ent == NULL or !ent:IsValid()) then return end
			local mdl = tr.Entity:GetModel()
			local cls = tr.Entity:GetClass()

			if ((ent:IsFoodModel() or cls == "gms_food") and ((ply:GetPos() - ent:LocalToWorld(ent:OBBCenter())):Length() <= 65) and ((SPropProtection.PlayerIsPropOwner(ply, ent) or SPropProtection.IsBuddy(ply, ent)) or tonumber(SPropProtection["Config"]["use"]) != 1)) then
				if (cls == "gms_food") then
					ply:SendMessage("Restored " .. tostring((ent.Value / 1000) * 100) .. "% food.", 3, Color(10, 200, 10, 255))
					ply:SetFood(ply.Hunger + ent.Value)
					ent:Fadeout(2)
					ply:Heal(ent.Value / 20)
					ply:SendMessage("Regained " .. tostring(ent.Value / 20) .. " hp.", 3, Color(255, 0, 0, 255))
				else
					local data = {}
					data.Entity = ent
					ply:DoProcess("EatFruit", 2, data)
				end
			elseif (ent:IsTreeModel()) then
				if (!ply:HasUnlock("Sprout_Collecting")) then ply:SendMessage("You don't have enough skill.", 3, Color(200, 0, 0, 255)) return end
				ply:DoProcess("SproutCollect", 5)
			elseif (cls == "gms_resourcedrop" and (ply:GetPos() - tr.HitPos):Length() <= 100 and ((SPropProtection.PlayerIsPropOwner(ply, ent) or SPropProtection.IsBuddy(ply, ent)) or tonumber(SPropProtection["Config"]["use"]) != 1)) then
				ply:PickupResourceEntity(ent)
			elseif ((cls == "gms_resourcepack" or cls == "gms_fridge") and (ply:GetPos() - tr.HitPos):Length() <= 100 and ((SPropProtection.PlayerIsPropOwner(ply, ent) or SPropProtection.IsBuddy(ply, ent)) or tonumber(SPropProtection["Config"]["use"]) != 1)) then
				ply:ConCommand("gms_openrespackmenu")
			elseif (ent:IsOnFire() and ((SPropProtection.PlayerIsPropOwner(ply, ent) or SPropProtection.IsBuddy(ply, ent)) or tonumber(SPropProtection["Config"]["use"]) != 1)) then
				if (GetConVarNumber("gms_CampFire") == 1) then ply:OpenCombiMenu("Cooking") end
			end
		end
	elseif (tr.HitWorld) then
		for k, v in pairs(ents.FindInSphere(tr.HitPos, 100)) do
			if (v:IsGrainModel() and ((SPropProtection.PlayerIsPropOwner(ply, v) or SPropProtection.IsBuddy(ply, v)) or tonumber(SPropProtection["Config"]["use"]) != 1)) then
				local data = {}
				data.Entity = v
				ply:DoProcess("HarvestGrain", 3, data)
				return
			elseif (v:IsBerryBushModel() and ((SPropProtection.PlayerIsPropOwner(ply, v) or SPropProtection.IsBuddy(ply, v)) or tonumber(SPropProtection["Config"]["use"]) != 1)) then
				local data = {}
				data.Entity = v
				ply:DoProcess("HarvestBush", 3, data)
				return
			end
		end
		if ((tr.MatType == MAT_DIRT or tr.MatType == MAT_GRASS or tr.MatType == MAT_SAND or tr.MatType == MAT_SNOW) and !GMS.IsInWater(tr.HitPos)) then
			local time = 5
			if (ply:GetActiveWeapon():GetClass() == "gms_shovel") then time = 2 end

			ply:DoProcess("Foraging", time)
		end
	end
	local trace = {}
	trace.start = ply:GetShootPos()
	trace.endpos = trace.start + (ply:GetAimVector() * 150)
	trace.mask = MASK_WATER | MASK_SOLID
	trace.filter = ply

	local tr2 = util.TraceLine(trace)
	if ((tr2.Hit and tr2.MatType == MAT_SLOSH and ply:WaterLevel() > 0) or ply:WaterLevel() == 3) then
		if (ply.Thirst > 950) then
			ply.Thirst = 1000
			ply:UpdateNeeds()
			if (ply.Hasdrunk == false or ply.Hasdrunk == nil) then
				ply:EmitSound(Sound("npc/barnacle/barnacle_gulp" .. math.random(1, 2) .. ".wav"))
				ply.Hasdrunk = true
				timer.Simple(0.9, function() ply.Hasdrunk = false end, ply)
			end				
		elseif (ply.Thirst <= 950) then
			ply.Thirst = ply.Thirst + 50
			if (ply.Hasdrunk == false or ply.Hasdrunk == nil) then
				ply:EmitSound(Sound("npc/barnacle/barnacle_gulp" .. math.random(1, 2) .. ".wav"))
				ply.Hasdrunk = true
				timer.Simple(0.9, function() ply.Hasdrunk = false end, ply)
			end				
			ply:UpdateNeeds()
		end
	elseif (GMS.IsInWater(tr.HitPos) and !tr.HitNonWorld) then
		ply:DoProcess("BottleWater", 3)
	end
end)

/* Saving / loading functions */
--Find pre-existing entities
function GM:FindMapSpecificEntities()
	self.MapSpecificEntities = ents.GetAll()
end
timer.Simple(3, GM.FindMapSpecificEntities, GM)

--Commands
function GM.SaveMapCommand(ply, cmd, args)
	if (!ply:IsAdmin()) then ply:SendMessage("You need admin rights for this!", 3, Color(200, 0, 0, 255)) return end
	if (!args[1] or string.Trim(args[1]) == "") then return end
	GAMEMODE:PreSaveMap(string.Trim(args[1]))
end
concommand.Add("gms_admin_savemap", GM.SaveMapCommand)

function GM.LoadMapCommand(ply, cmd, args)
	if (!ply:IsAdmin()) then ply:SendMessage("You need admin rights for this!", 3, Color(200, 0 ,0, 255)) return end

	if (!args[1] or string.Trim(args[1]) == "") then return end
	GAMEMODE:PreLoadMap(string.Trim(args[1]))
end
concommand.Add("gms_admin_loadmap", GM.LoadMapCommand)

function GM.DeleteMapCommand(ply, cmd, args)
	if (!ply:IsAdmin()) then ply:SendMessage("You need admin rights for this!", 3, Color(200, 0, 0, 255)) return end

	if (!args[1] or string.Trim(args[1]) == "") then return end
	GAMEMODE:DeleteSavegame(string.Trim(args[1]))
end
concommand.Add("gms_admin_deletemap", GM.DeleteMapCommand)

--Delete map
function GM:DeleteSavegame(name)
	if !file.Exists("GMStranded/Gamesaves/" .. name .. ".txt") then return end

	file.Delete("GMStranded/Gamesaves/" .. name .. ".txt")
	if (file.Exists("GMStranded/Gamesaves/" .. name .. "_info.txt")) then file.Delete("GMStranded/Gamesaves/" .. name .. "_info.txt") end

	for k, ply in pairs(player.GetAll()) do
		if( ply:IsAdmin()) then
			umsg.Start("gms_RemoveLoadGameFromList", ply)
				umsg.String(name)
			umsg.End()
		end
	end
end

--Save map
function GM:PreSaveMap(name)
	if (CurTime() < 3) then return end
	if (CurTime() < self.NextSaved) then return end

	for k, ply in pairs(player.GetAll()) do
		ply:MakeSavingBar("Saving game as \"" .. name .. "\"")
	end

	self.NextSaved = CurTime() + 0.6
	timer.Simple(0.5, self.SaveMap, self, name)
end

function GM:SaveMap(name)
	local savegame = {}
	savegame["name"] = name
	savegame["entries"] = {}

	savegame_info = {}
	savegame_info["map"] = game.GetMap()
	savegame_info["date"] = os.date("%A %m/%d/%y")

	local num = 0

	for k, ent in pairs(ents.GetAll()) do
		if (ent and ent != NULL and ent:IsValid() and !table.HasValue(self.MapSpecificEntities, ent)) then
			if (table.HasValue(GMS.SavedClasses, ent:GetClass())) then
				local entry = {}

				entry["class"] = ent:GetClass()
				entry["model"] = ent:GetModel()
				if (ent:GetNetworkedString("Owner") == "World") then entry["owner"] = ent:GetNetworkedString("Owner") end
				if (ent.Children != nil) then entry["Children"] = ent.Children end
				if (ent.PlantParent != NULL) then entry["PlantParent"] = ent.PlantParent end
				if (ent:GetNWEntity("plantowner") != NULL) then entry["Plantowner"] = ent:GetNWEntity("plantowner") end
				
				local pos = ent:GetPos()
				local ang = ent:GetAngles()
				local colr, colg, colb, cola = ent:GetColor()

				entry["color"] = colr .. " " .. colg .. " " .. colb .. " " .. cola
				entry["pos"] =   pos.x .. " " .. pos.y .. " " .. pos.z
				entry["angles"] = ang.p .. " " .. ang.y .. " " .. ang.r
				entry["material"] = ent:GetMaterial() or "0"
				entry["keyvalues"] = ent:GetKeyValues()
				entry["table"] = ent:GetTable()

				local phys = ent:GetPhysicsObject()

				if (phys and phys != NULL and phys:IsValid()) then
					entry["freezed"] = phys:IsMoveable()
					entry["sleeping"] = phys:IsAsleep()
				end   

				if (entry["class"] == "gms_resourcedrop") then entry["type"] = ent.Type entry["amount"] = ent.Amount end // RP

				num = num + 1
				savegame["entries"][#savegame["entries"] + 1] = entry
			end
		end
	end

	file.Write("GMStranded/Gamesaves/" .. name .. ".txt", util.TableToKeyValues(savegame))
	file.Write("GMStranded/Gamesaves/" .. name .. "_info.txt", util.TableToKeyValues(savegame_info))

	for k, ply in pairs(player.GetAll()) do
		ply:SendMessage("Saved game \"" .. name .. "\".", 3, Color(255, 255, 255, 255))
		ply:StopSavingBar()

		if (ply:IsAdmin()) then
			umsg.Start("gms_AddLoadGameToList", ply)
			umsg.String(name)
			umsg.End()
		end
	end
end

--Load map
function GM:PreLoadMap(name)
	if (CurTime() < 3) then return end
	if (CurTime() < self.NextLoaded) then return end
	if (!file.Exists("GMStranded/Gamesaves/" .. name .. ".txt")) then return end

	for k, ply in pairs(player.GetAll()) do ply:MakeLoadingBar("Savegame \"" .. name .. "\"") end

	self.NextLoaded = CurTime() + 0.6
	timer.Simple(0.5, self.LoadMap, self, dname)
end

function GM:LoadMap(name)
	local savegame = util.KeyValuesToTable(file.Read("GMStranded/Gamesaves/" .. name .. ".txt"))
	local num = table.Count(savegame["entries"])

	if (num == 0) then Msg("This savegame is empty!\n") return end

	self:LoadMapEntity(savegame, num, 1)
end

--Don't load it all at once
function GM:LoadMapEntity(savegame, max, k)
	local entry = savegame["entries"][tostring(k)]

	local ent = ents.Create(entry["class"])
	ent:SetModel(entry["model"])

	local pos = string.Explode(" ", entry["pos"])
	local ang = string.Explode(" ", entry["angles"])
	local col = string.Explode(" ", entry["color"])
	

	ent:SetColor(tonumber(col[1]), tonumber(col[2]), tonumber(col[3]), tonumber(col[4]))
	ent:SetPos(Vector(tonumber(pos[1]), tonumber(pos[2]), tonumber(pos[3])))
	ent:SetAngles(Angle(tonumber(ang[1]), tonumber(ang[2]), tonumber(ang[3])))
	if (entry["owner"] == "World") then ent:SetNetworkedString('Owner', entry["owner"]) end
	if (entry["Children"] != NULL) then ent.Children = entry["Children"] end
	if (entry["PlantParent"] != NULL) then ent.PlantParent = entry["PlantParent"] end
	if (entry["Plantowner"] != NULL) then ent:SetNWEntity('plantowner', entry["Plantowner"]) end
	if (entry["material"] != "0") then ent:SetMaterial(entry["material"]) end

	for k, v in pairs(entry["keyvalues"]) do ent:SetKeyValue(k, v) end

	for k, v in pairs(entry["table"]) do ent[k] = v end
	ent:Spawn()

	if (entry["class"] == "gms_resourcedrop") then // RP
		ent.Type = entry["type"]
		ent.Amount = entry["amount"]
		ent:SetResourceDropInfo(ent.Type, ent.Amount)
	end

	local phys = ent:GetPhysicsObject()
	if (phys and phys != NULL and phys:IsValid()) then
		phys:EnableMotion(entry["freezed"])
		if (entry["sleeping"]) then phys:Sleep() else phys:Wake() end
	end

	if (k >= max) then
		for k, ply in pairs(player.GetAll()) do
			ply:SendMessage("Loaded game \"" .. savegame["name"] .. "\" (" .. max .. " entries)", 3, Color(255, 255, 255, 255))
			ply:StopLoadingBar()
		end
	else
		timer.Simple(0.05, self.LoadMapEntity, self, savegame, max, k + 1)
	end
end

/* Misc functions */
hook.Add("Think", "GM_WaterExtinguish", function()
	for _, v in ipairs(ents.GetAll()) do
		if (v:WaterLevel() > 0 and v:IsOnFire()) then
			v:Extinguish()
		end 
	end
end)

/* Oxygen */
timer.Create("Oxygen.Timer", 1, 0, function()
	for _, v in ipairs(player.GetAll()) do
		if (v:WaterLevel() > 2) then
			if (v.Oxygen > 0) then
				v.Oxygen = math.max(v.Oxygen - math.min(1600 / v:GetSkill("Swimming"), 500), 0)
				v:UpdateNeeds()
				if (v.AFK != true) then
					v:IncXP("Swimming", math.Clamp(math.Round(50 / v:GetSkill("Swimming")), 1, 1000))
				end
			end
		else
			if (v.Oxygen < 1000) then
				v.Oxygen = math.min(v.Oxygen + 100, 1000)
				v:UpdateNeeds()
			end
		end 
	end
end)

/* Power */
timer.Create("Power.Timer", 1, 0, function()
	for _, v in ipairs(player.GetAll()) do
		if (v:FlashlightIsOn()) then
			if (v.Power > 0) then
				v.Power = math.max(v.Power - 5, 0)
				if (v.Power < 5) then
					v:Flashlight(false)
				end
				v:UpdateNeeds()
			end
		else
			local maxPow = 50
			if (v.Resources['Batteries']) then
				maxPow = math.min(maxPow + v.Resources['Batteries'] * 50, 500)
			end
			if (v.Power < maxPow) then
				v.Power = math.min(v.Power + 10, maxPow)
				v:UpdateNeeds()
			end
		end 
	end
end)

function GM:PlayerSwitchFlashlight(ply, SwitchOn)
	return (ply.Power > 25 or !SwitchOn) and (ply.Resources['Flashlight'] != nil and ply.Resources['Flashlight'] > 0)
end

local AlertSounds = {"citizen_beaten1.wav", "citizen_beaten4.wav", "citizen_beaten5.wav", "cough1.wav", "cough2.wav", "cough3.wav", "cough4.wav"}

/* Alert Message: Thirst */
timer.Create("AlertTimerT", 5, 0, function(ply)
	if (GetConVarNumber("gms_Alerts") == 1) then
		for k, ply in pairs(player.GetAll()) do 
			if (ply.Thirst < 125 and ply:Alive()) then
				ply:EmitSound(Sound(AlertSounds[math.random(1, #AlertSounds)]))
			end
		end
	end
end)

/* Alert Message: Hunger */
timer.Create("AlertTimerH", 5, 0, function()
	if (GetConVarNumber("gms_Alerts") == 1) then
		for k, ply in pairs(player.GetAll()) do 
			if (ply.Hunger < 125 and ply:Alive()) then
				ply:EmitSound(Sound(AlertSounds[math.random(1, #AlertSounds)]))
			end
		end
	end
end)

/* Alert Message: Sleepiness */
timer.Create("AlertTimerS", 5, 0, function()
	if (GetConVarNumber("gms_Alerts") == 1) then
		for k, ply in pairs(player.GetAll()) do 
			if (ply.Sleepiness < 125 and ply:Alive()) then
				ply:EmitSound(Sound(AlertSounds[math.random(1, #AlertSounds)]))
			end
		end
	end
end)

/* Tribe system */
function CreateTribe(ply, name, red, green, blue, password)
	local Password = false
	if (password and password != "") then Password = password end

	name = string.Trim(name) -- No space bars!
	if (name == "") then ply:SendMessage("You should enter tribe name!", 5, Color(255, 50, 50, 255)) return end
	if (GAMEMODE.Tribes[name] != nil) then ply:SendMessage("Tribe with this name already exists!", 5, Color(255, 50, 50, 255)) return end
	
	GAMEMODE.NumTribes = GAMEMODE.NumTribes + 1
	GAMEMODE.Tribes[name] = {
		id = GAMEMODE.NumTribes,
		red = red,
		green = green,
		blue = blue,
		Password = Password
	}
	local rp = RecipientFilter()
	rp:AddAllPlayers()
	umsg.Start("newTribe", rp)
		umsg.String(name)
		umsg.Short(GAMEMODE.NumTribes)
		umsg.Short(red)
		umsg.Short(green)
		umsg.Short(blue)
		if (Password == false) then
			umsg.Bool(false)
		else
			umsg.Bool(true)
		end
	umsg.End()
	
	team.SetUp(GAMEMODE.NumTribes, name, Color(red, green, blue, 255))
	ply:SetTeam(GAMEMODE.NumTribes)
	SPropProtection.TribePP(ply)
	ply:SendMessage("Successfully created " .. name, 5, Color(255, 255, 255, 255))
end

function GM:PlayerSay(ply, text, public)
	local args = string.Explode(" ", text)
	if (args == nil) then args = {} end

	if (public) then
		return GMS.RunChatCmd(ply, unpack(args)) or text
	else
		if (GMS.RunChatCmd(ply, unpack(args)) != "") then
			for k, v in pairs(player.GetAll()) do
				if (v and v:IsValid() and v:IsPlayer() and v:Team() == ply:Team()) then
					v:PrintMessage(3, "[TRIBE] " .. ply:Nick() .. ": " .. text)
				end
			end
		end
		return ""
	end
end

function GM.CreateTribeCmd(ply, cmd, args, argv)
	if (!args[4] or args[4] == "") then ply:ChatPrint("Syntax is: gms_createtribe \"tribename\" red green blue [password(optional)]") return end
	if (args[5] and args[5] != "") then
		CreateTribe(ply, args[1], args[2], args[3], args[4], args[5])
	else
		CreateTribe(ply, args[1], args[2], args[3], args[4], "")
	end
end
concommand.Add("gms_createtribe", GM.CreateTribeCmd)

function GM.JoinTribeCmd(ply, cmd, args)
	local pw = ""
	if (!args[1] or args[1] == "") then ply:ChatPrint("Syntax is: gms_join \"tribename\" [password(if needed)]") return end
	if (args[2] and args[2] != "") then pw = args[2] end
	for i, v in pairs(GAMEMODE.Tribes) do
		if (string.lower(i) == string.lower(args[1])) then
			if (v.Password and v.Password != pw) then ply:SendMessage("Incorrcet tribal password", 3, Color(255, 50, 50, 255)) return end
			ply:SetTeam(v.id)
			SPropProtection.TribePP(ply)
			ply:SendMessage("Successfully joined " .. i, 5, Color(255, 255, 255, 255))
		end
	end
end
concommand.Add("gms_join", GM.JoinTribeCmd)

function GM.LeaveTribeCmd(ply, cmd, args)
	ply:SetTeam(1)
	SPropProtection.TribePP(ply)
	ply:SendMessage("Successfully left the tribe", 5, Color(255, 255, 255, 255))
end
concommand.Add("gms_leave", GM.LeaveTribeCmd)

/* Resource Box Touch */
function big_gms_combineresource(ent_a, ent_b)
	local ent_a_owner = ent_a:GetNetworkedString("Owner")
	local ent_b_owner = ent_b:GetNetworkedString("Owner")
	local ply = player.GetByID(ent_a:GetNetworkedString("Ownerid"))
	local plyb = player.GetByID(ent_b:GetNetworkedString("Ownerid"))

	if (ent_a_owner != nil and ent_b_owner != nil and ply != nil) then
		if (ent_a_owner == ent_b_owner or (SPropProtection.PlayerCanTouch(ply, ent_b) and SPropProtection.PlayerCanTouch(plyb, ent_a))) then
			ent_a.Amount = ent_a.Amount + ent_b.Amount
			ent_a:SetResourceDropInfoInstant(ent_a.Type, ent_a.Amount)
			ent_b:Remove()
		end
	end 	
end

/* Resource box touches Resource pack */
function big_gms_combineresourcepack(respack, ent_b)
	local ent_a_owner = respack:GetNetworkedString("Owner")
	local ent_b_owner = ent_b:GetNetworkedString("Owner")
	local ply = player.GetByID(respack:GetNetworkedString("Ownerid"))
	local plyb = player.GetByID(ent_b:GetNetworkedString("Ownerid"))

	if (ent_a_owner != nil and ent_b_owner != nil and ply != nil) then
		if (ent_a_owner == ent_b_owner or (SPropProtection.PlayerCanTouch(ply, ent_b) and SPropProtection.PlayerCanTouch(plyb, respack))) then
			if (respack.Resources[ent_b.Type]) then
				respack.Resources[ent_b.Type] = respack.Resources[ent_b.Type] + ent_b.Amount
			else
				respack.Resources[ent_b.Type] = ent_b.Amount
			end
			respack:SetResPackInfo(ent_b.Type, respack.Resources[ent_b.Type])
			ent_b:Remove()
		end
	end 	
end

/* Food touches Fridge */
function big_gms_combinefood(fridge, food)
	local ent_a_owner = fridge:GetNetworkedString("Owner")
	local ent_b_owner = food:GetNetworkedString("Owner")
	local ply = player.GetByID(fridge:GetNetworkedString("Ownerid"))
	local plyb = player.GetByID(food:GetNetworkedString("Ownerid"))
	local foodname = string.gsub(food.Name, " ", "_")

	if (ent_a_owner != nil and ent_b_owner != nil and ply != nil) then
		if (ent_a_owner == ent_b_owner or (SPropProtection.PlayerCanTouch(ply, food) and SPropProtection.PlayerCanTouch(plyb, fridge))) then
			if (fridge.Resources[foodname]) then
				fridge.Resources[foodname] = fridge.Resources[foodname] + 1
			else
				fridge.Resources[foodname] = 1
			end
			fridge:SetResPackInfo(foodname, fridge.Resources[foodname])
			food:Remove()
		end
	end 	
end

/* Resource Box Buildsite Touch */
function gms_addbuildsiteresource(ent_resourcedrop, ent_buildsite)
	local ent_resourcedrop_owner = ent_resourcedrop:GetNetworkedString("Owner")
	local ent_buildsite_owner = ent_buildsite:GetNetworkedString("Owner")
	local ply = player.GetByID(ent_resourcedrop:GetNetworkedString("Ownerid"))

	if (ent_resourcedrop_owner != nil and ent_buildsite_owner != nil and ply != nil and ent_resourcedrop:IsPlayerHolding()) then
		if ((SPropProtection.PlayerIsPropOwner(ply, ent_buildsite) or SPropProtection.IsBuddy(ply, ent_buildsite)) or tonumber(SPropProtection["Config"]["use"]) != 1)  then
			if (ent_resourcedrop.Amount > ent_buildsite.Costs[ent_resourcedrop.Type]) then	
				ent_resourcedrop.Amount = ent_resourcedrop.Amount - ent_buildsite.Costs[ent_resourcedrop.Type]
				ent_resourcedrop:SetResourceDropInfo(ent_resourcedrop.Type, ent_resourcedrop.Amount)
				ent_buildsite.Costs[ent_resourcedrop.Type] = nil
			elseif (ent_resourcedrop.Amount <= ent_buildsite.Costs[ent_resourcedrop.Type]) then
				ent_buildsite.Costs[ent_resourcedrop.Type] = ent_buildsite.Costs[ent_resourcedrop.Type] - ent_resourcedrop.Amount
				ent_resourcedrop:Remove() 
			end
			for k, v in pairs(ent_buildsite.Costs) do
				if (ent_buildsite.Costs[ent_resourcedrop.Type]) then
					if (ent_buildsite.Costs[ent_resourcedrop.Type] <= 0) then
						ent_buildsite.Costs[ent_resourcedrop.Type] = nil
					end
				end				
			end 

			if (table.Count(ent_buildsite.Costs) > 0) then
				local str = "You need: "
				for k, v in pairs(ent_buildsite.Costs) do
					str = str .. " " .. string.Replace(k, "_", " ") .. " (" .. v .. "x)"
				end

				str = str .. " to finish."
				ply:SendMessage(str, 5, Color(255, 255, 255, 255))
			else
				ply:SendMessage("Finished!", 3, Color(10, 200, 10, 255))
				ent_buildsite:Finish()
			end
			
			local str = ":"
			for k, v in pairs(ent_buildsite.Costs) do
				str = str .. " " .. string.Replace(k, "_", " ") .. " (" .. v .. "x)"
			end
			ent_buildsite:SetNetworkedString("Resources", str)
		end
	end
end

/* Resource Pack Buildsite Touch */
function gms_addbuildsiteresourcePack(ent_resourcepack, ent_buildsite)
	local ent_resourcedrop_owner = ent_resourcepack:GetNetworkedString("Owner")
	local ent_buildsite_owner = ent_buildsite:GetNetworkedString("Owner")
	local ply = player.GetByID(ent_resourcepack:GetNetworkedString("Ownerid"))

	if (ent_resourcedrop_owner != nil and ent_buildsite_owner != nil and ply != nil and ent_resourcepack:IsPlayerHolding()) then
		if ((SPropProtection.PlayerIsPropOwner(ply, ent_buildsite) or SPropProtection.IsBuddy(ply, ent_buildsite)) or tonumber(SPropProtection["Config"]["use"]) != 1)  then
			for res, num in pairs(ent_resourcepack.Resources) do
				if (ent_buildsite.Costs[res] and num > ent_buildsite.Costs[res]) then	
					ent_resourcepack.Resources[res] = num - ent_buildsite.Costs[res]
					ent_resourcepack:SetResPackInfo(res, ent_resourcepack.Resources[res])
					ent_buildsite.Costs[res] = nil
				elseif (ent_buildsite.Costs[res] and num <= ent_buildsite.Costs[res]) then
					ent_buildsite.Costs[res] = ent_buildsite.Costs[res] - num
					ent_resourcepack:SetResPackInfo(res, 0)
					ent_resourcepack.Resources[res] = nil
				end
				for k, v in pairs(ent_buildsite.Costs) do
					if (ent_buildsite.Costs[res]) then
						if (ent_buildsite.Costs[res] <= 0) then
							ent_buildsite.Costs[res] = nil
						end
					end				
				end
			end

			if (table.Count(ent_buildsite.Costs) > 0) then
				local str = "You need: "
				for k, v in pairs(ent_buildsite.Costs) do
					str = str .. " " .. string.Replace(k, "_", " ") .. " (" .. v .. "x)"
				end

				str = str .. " to finish."
				ply:SendMessage(str, 5, Color(255, 255, 255, 255))
			else
				ply:SendMessage("Finished!", 3, Color(10, 200, 10, 255))
				ent_buildsite:Finish()            
			end
			
			local str = ":"
			for k, v in pairs(ent_buildsite.Costs) do
				str = str .. " " .. string.Replace(k, "_", " ") .. " (" .. v .. "x)"
			end
			ent_buildsite:SetNetworkedString("Resources", str)
		end
	end
end	

/* Resource Box versus Player Damage */
hook.Add("PlayerShouldTakeDamage", "playershouldtakedamage", function(victim, attacker)
	if (victim:IsPlayer() and (attacker:GetClass() == "gms_resourcedrop" or attacker:IsPlayerHolding() or attacker:GetClass() == "gms_resourcepack" or attacker:GetClass() == "gms_fridge" or attacker:GetClass() == "gms_food")) then
		return false
	end
	return true
end)
