
AddCSLuaFile("sh_spp.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_cppi.lua")

SPropProtection = {}
SPropProtection.Version = 2

CPPI = {}
CPPI_NOTIMPLEMENTED = 26
CPPI_DEFER = 16

include("sh_cppi.lua")

if(SERVER) then
	include("sv_init.lua")
else
	include("cl_init.lua")
end

Msg("==========================================================\n")
Msg("Simple Prop Protection Version " .. SPropProtection.Version .. " by Spacetech has loaded\n")
Msg("Edit by Robotboy655\n")
Msg("==========================================================\n")
