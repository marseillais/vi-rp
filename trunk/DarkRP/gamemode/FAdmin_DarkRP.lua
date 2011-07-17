FAdmin = FAdmin or {}

FAdmin.PlayerActions = {}
FAdmin.StartHooks = {}

if SERVER then
	local function AddDir(dir) // recursively adds everything in a directory to be downloaded by client
		local List = file.FindDir("../"..dir.."/*")

		for _, fdir in pairs(List) do
			if fdir != ".svn" then // don't spam people with useless .svn folders
				AddDir(dir.."/"..fdir)
			end
		end
	 
		for k,v in pairs(file.Find("../"..dir.."/*")) do
			resource.AddFile(dir.."/"..v)
		end
	end
	
	AddDir("materials/FAdmin")
	
	AddCSLuaFile("FAdmin.lua")
	
	local function AddCSLuaFolder(fol)
		for _, folder in SortedPairs(file.FindInLua(fol.."*"), true) do
			if folder ~= "." and folder ~= ".." then
				for _, File in SortedPairs(file.FindInLua(fol .. folder .."/sh_*.lua"), true) do
					AddCSLuaFile(fol..folder .. "/" ..File)
					include(fol.. folder .. "/" ..File)
				end
				
				for _, File in SortedPairs(file.FindInLua(fol .. folder .."/sv_*.lua"), true) do
					include(fol.. folder .. "/" ..File)
				end
				
				for _, File in SortedPairs(file.FindInLua(fol .. folder .."/cl_*.lua"), true) do
					AddCSLuaFile(fol.. folder .. "/" ..File)
				end
			end
		end
	end
	AddCSLuaFolder(GM.FolderName.."/gamemode/FAdmin/")
	AddCSLuaFolder(GM.FolderName.."/gamemode/FAdmin/PlayerActions/")
elseif CLIENT then
	local function IncludeFolder(fol)
		for _, folder in SortedPairs(file.FindInLua(fol.."*"), true) do
			if folder ~= "." and folder ~= ".." then
				for _, File in SortedPairs(file.FindInLua(fol .. folder .."/sh_*.lua"), true) do
					include(fol.. folder .. "/" ..File) 
				end
				
				for _, File in SortedPairs(file.FindInLua(fol .. folder .."/cl_*.lua"), true) do
					include(fol.. folder .. "/" ..File)
				end
			end
		end
	end
	IncludeFolder(GM.FolderName.."/gamemode/FAdmin/")
	IncludeFolder(GM.FolderName.."/gamemode/FAdmin/PlayerActions/")
end
/*

Utilities!

*/
function FAdmin.FindPlayer(info)
	if not info then return nil end
	local pls = player.GetAll()
	local PlayersFound = {}
	
	if string.lower(info) == "*" or string.lower(info) == "<all>" then return pls end
	
	local InfoPlayers = {}
	for A in string.gmatch(info..";", "([a-zA-Z0-9:_.]*)[;(,%s)%c]") do
		if A ~= "" then table.insert(InfoPlayers, A) end
	end

	for k, v in pairs(pls) do
		for _, PlayerInfo in pairs(InfoPlayers) do
			-- Find by UserID (status in console)
			if tonumber(PlayerInfo) == v:UserID() and not table.HasValue(PlayersFound, v) then
				table.insert(PlayersFound, v)
			end
			
			-- Find by Steam ID
			if (PlayerInfo == v:SteamID() or v:SteamID() == "UNKNOWN") and not table.HasValue(PlayersFound, v)  then
				table.insert(PlayersFound, v)
			end
			
			-- Find by Partial Nick
			if string.find(string.lower(v:Name()), string.lower(tostring(PlayerInfo)), 1, true) ~= nil and not table.HasValue(PlayersFound, v)  then
				table.insert(PlayersFound, v)
			end
			
			if v.SteamName and string.find(string.lower(v:SteamName()), string.lower(tostring(PlayerInfo)), 1, true) ~= nil and not table.HasValue(PlayersFound, v)  then -- DarkRP
				table.insert(PlayersFound, v)
			end
		end
	end

	return (#PlayersFound > 0 and PlayersFound) or nil
end

function FAdmin.IsEmpty(vector)
	local point = util.PointContents(vector)
	local a = point ~= CONTENTS_SOLID 
	and point ~= CONTENTS_MOVEABLE 
	and point ~= CONTENTS_LADDER 
	and point ~= CONTENTS_PLAYERCLIP 
	and point ~= CONTENTS_MONSTERCLIP
	local b = true
	
	for k,v in pairs(ents.FindInSphere(vector, 35)) do
		if v:IsNPC() or v:IsPlayer() or v:GetClass() == "prop_physics" then
			b = false
		end
	end
	return a and b
end

function FAdmin.SteamToProfile( steamid ) -- Thanks decodaman
		local x, y, z = string.match( steamid, "STEAM_(%d+):(%d+):(%d+)" )
	if ( x and y and z ) then
		local friendid = string.format( "765%0.f", z * 2 + 61197960265728 + y )
		return "http://steamcommunity.com/profiles/"..friendid
	else
		return "http://steamcommunity.com/profiles/"..steamid
	end
end

hook.Add("CanTool", "EntityCanTool", function(ply, trace, mode)
	if trace.Entity.CanTool and not FPP then
		return trace.Entity:CanTool(ply, trace, mode)
	end
end)

hook.Add("PhysgunPickup", "EntityPhysgunPickup", function(ply, ent)
	if ent.PhysgunPickup and not FPP then --FPP has this function too
		return ent:PhysgunPickup(ply)
	end
end)

hook.Add("OnPhysgunFreeze", "EntityPhysgunFreeze", function(weapon, physobj, ent, ply, ...)
	if ent.OnPhysgunFreeze and not FPP then
		return ent:OnPhysgunFreeze(weapon, physobj, ent, ply, ...)
	end
end)

local IP = ""
if SERVER then
	http.Get("http://automation.whatismyip.com/n09230945.asp", "", function(content, size)
		local ip = string.match(content, "([0-9.]+)")
		IP = ip..":"..GetConVarString("hostport") 
	end)
	timer.Simple(5, function()
		if not IP then -- if the other site is down?
			http.Get("http://checkip.dyndns.org/", "", function(content1, size1) -- check a different site
				local ip1 = string.match(content1, "([0-9.]+)")
				if not ip1 then return end -- nope.
				IP = ip1..":"..GetConVarString("hostport") 
			end)
			return
		end
	end)
end

/*
	FAdmin global settings
*/
FAdmin.GlobalSetting = {}


function _R.Player:FAdmin_GetGlobal(setting)
	return self.GlobalSetting and self.GlobalSetting[setting]
end

if SERVER then
	local SetTypes = {Angle = "Angle",
	boolean = "Bool",
	Entity = "Entity",
	number = "Float",
	Player = "Entity",
	string = "String",
	Vector = "Vector"}
	
	function FAdmin.SetGlobalSetting(setting, value)
		if FAdmin.GlobalSetting[setting] == value then return end -- If the value didn't change, we don't need to resend it.
		FAdmin.GlobalSetting[setting] = value
		umsg.Start("FAdmin_GlobalSetting")
			umsg.String(setting)
			umsg.String(type(value))

			umsg[SetTypes[type(value)]](value)
		umsg.End()
	end
	
	function _R.Player:FAdmin_SetGlobal(setting, value)
		self.GlobalSetting = self.GlobalSetting or {}
		if self.GlobalSetting[setting] == value then return end -- If the value didn't change, we don't need to resend it.
		self.GlobalSetting[setting] = value
		umsg.Start("FAdmin_PlayerSetting")
			umsg.Entity(self)
			umsg.String(setting)
			umsg.String(type(value))
			umsg[SetTypes[type(value)]](value)
		umsg.End()
	end
	
	hook.Add("PlayerInitialSpawn", "FAdmin_GlobalSettings", function(ply)
		for k, v in pairs(FAdmin.GlobalSetting) do
			umsg.Start("FAdmin_GlobalSetting")
				umsg.String(k)
				umsg.String(type(v))
				umsg[SetTypes[type(v)]](v)
			umsg.End()
		end
		for _, ply in pairs(player.GetAll()) do
			for k,v in pairs(ply.GlobalSetting or {}) do
				umsg.Start("FAdmin_PlayerSetting")
					umsg.Entity(ply)
					umsg.String(k)
					umsg.String(type(v))
					umsg[SetTypes[type(v)]](v)
				umsg.End()
			end
		end
	end)
	FAdmin.SetGlobalSetting("FAdmin", true)
	
	timer.Create("FAdmin_ServerInformation", 1, 0, function()
		FAdmin.SetGlobalSetting("FAdmin_ServerFPS", math.floor(1/FrameTime()))
		if IP ~= "" then FAdmin.SetGlobalSetting("FAdmin_ServerIP", IP) end
	end)
elseif CLIENT then
	local GetTypes = {Angle = "ReadAngle",
	boolean = "ReadBool",
	Entity = "ReadEntity",
	number = "ReadFloat",
	Player = "ReadEntity",
	string = "ReadString",
	Vector = "ReadVector"}
	usermessage.Hook("FAdmin_GlobalSetting", function(um)
		FAdmin.GlobalSetting = FAdmin.GlobalSetting or {}
		FAdmin.GlobalSetting[um:ReadString()] = um[GetTypes[um:ReadString()]](um)
	end)
	usermessage.Hook("FAdmin_PlayerSetting", function(um)
		local ply = um:ReadEntity()
		if not ply:IsValid() then return end
		ply.GlobalSetting = ply.GlobalSetting or {}
		ply.GlobalSetting[um:ReadString()] = um[GetTypes[um:ReadString()]](um)
	end)
end

/*Dependency solver:
	Many plugins are dependant of one another.
	To prevent plugins calling functions from other plugins that haven't been opened yet
	there will be a hook that is called when all plugins are loaded.
	This way there will be no hassle with which plugin loads first, which one next etc.
*/
for k,v in pairs(FAdmin.StartHooks) do if type(k) ~= "string" then FAdmin.StartHooks[k] = nil end end
for k,v in SortedPairs(FAdmin.StartHooks) do
	v()
end