
AddCSLuaFile("SPropProtection/sh_SPropProtection.lua")
AddCSLuaFile("SPropProtection/cl_Init.lua")
AddCSLuaFile("SPropProtection/sh_CPPI.lua")

SPropProtection = {}
SPropProtection.Version = 1.5

CPPI = {}
CPPI_NOTIMPLEMENTED = 26
CPPI_DEFER = 16

include("sh_CPPI.lua")

if(SERVER) then
	include("sv_Init.lua")
else
	include("cl_Init.lua")
end

Msg("==========================================================\n")
Msg("Simple Prop Protection Version " .. SPropProtection.Version .. " by Spacetech has loaded\n")
Msg("Little edits by Robotboy655\n")
Msg("==========================================================\n")
