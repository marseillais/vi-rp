/*---------------------------------------------------------
  ChatCommand system
---------------------------------------------------------*/
GMS.ChatCommands = {}
function GMS.RegisterChatCmd(tbl)
    GMS.ChatCommands[tbl.Command] = tbl
end

function GMS.RunChatCmd(ply, ...)
	if (#arg > 0 and (string.Left(arg[1], 1) == "/" or string.Left(arg[1], 1) == "!")) then
		local cmd = string.sub(arg[1], 2, string.len(arg[1]))
		table.remove(arg, 1)
		if ((ply:GetNWString("AFK") != 1 or cmd == "afk") and GMS.ChatCommands[cmd] != nil) then
			GMS.ChatCommands[cmd]:Run(ply, unpack(arg))
			return ""
		end
	end
end

/* Help List */
local CHATCMD = {}

CHATCMD.Command = "help"
CHATCMD.Desc = "This help command"

function CHATCMD:Run(ply)
	ply:PrintMessage(HUD_PRINTTALK, "GMStranded Chat Commands:")
	for _, v in pairs(GMS.ChatCommands) do
		if (v.Command != nil) then
			local desc = v.Desc or "No description given."
			local syntax = v.Syntax or ""
			if (syntax != "") then syntax = syntax .. " " end
			ply:PrintMessage(HUD_PRINTTALK, "   " .. v.Command .. " " .. syntax .. "- " .. v.Desc)
		end
	end
	ply:PrintMessage(HUD_PRINTTALK, "Open console to read easier.")
end

GMS.RegisterChatCmd(CHATCMD)

/* Resource Drop */
local CHATCMD = {}

CHATCMD.Command = "drop"
CHATCMD.Desc = "No amount will drop all"
CHATCMD.Syntax = "<Resource Type> <Amount>"
CHATCMD.CCName = "gms_dropresources"

function CHATCMD:Run(ply, ...)
	args = {}
	args[1] = self.CCName
	args[2] = {...}

	GAMEMODE.DropResource(ply, unpack(args))
end

GMS.RegisterChatCmd(CHATCMD)

/* Sleep */
local CHATCMD = {}

CHATCMD.Command = "sleep"
CHATCMD.Desc = "Goto sleep"
CHATCMD.CCName = "gms_sleep"

function CHATCMD:Run(ply)
	GAMEMODE.PlayerSleep(ply)
end

GMS.RegisterChatCmd(CHATCMD)

/* Stuck */
local CHATCMD = {}

CHATCMD.Command = "stuck"
CHATCMD.Desc = "In case you are stuck"
CHATCMD.CCName = "gms_stuck"

function CHATCMD:Run(ply)
	GAMEMODE.PlayerStuck(ply)
end

GMS.RegisterChatCmd(CHATCMD)

/* Admin Resource Drop */
local CHATCMD = {}

CHATCMD.Command = "adrop"
CHATCMD.Desc = "Drops a specified of resources out of nowhere. Admin only."
CHATCMD.Syntax = "<Resource Type> <Amount>"
CHATCMD.CCName = "gms_adropresources"

function CHATCMD:Run(ply, ...)
	args = {}
	args[1] = self.CCName
	args[2] = {...}

	GAMEMODE.ADropResource(ply, unpack(args))
end

GMS.RegisterChatCmd(CHATCMD)

/* Wakeup */
local CHATCMD = {}

CHATCMD.Command = "wakeup"
CHATCMD.Desc = "Wakeup from sleep."
CHATCMD.CCName = "gms_wakeup"

function CHATCMD:Run(ply)
	GAMEMODE.PlayerWake(ply)
end

GMS.RegisterChatCmd(CHATCMD)

/* CampFire */
local CHATCMD = {}
CHATCMD.Command = "campfire"
CHATCMD.Desc = "Make wood into a camp fire."
CHATCMD.CCName = "gms_makefire"

function CHATCMD:Run(ply)
	GAMEMODE.MakeCampfire(ply)
end
GMS.RegisterChatCmd(CHATCMD)

/* Drink */
local CHATCMD = {}

CHATCMD.Command = "drink"
CHATCMD.Desc = "Drink a water bottle."
CHATCMD.CCName = "gms_drinkbottle"

function CHATCMD:Run(ply)
	GAMEMODE.DrinkFromBottle(ply)
end

GMS.RegisterChatCmd(CHATCMD)

/* Plant Melon */
local CHATCMD = {}

CHATCMD.Command = "melon"
CHATCMD.Desc = "Plant a watermelon."
CHATCMD.CCName = "gms_plantmelon"

function CHATCMD:Run(ply)
	GAMEMODE.PlantMelon(ply)
end

GMS.RegisterChatCmd(CHATCMD)

/* Plant Banana */
local CHATCMD = {}

CHATCMD.Command = "banana"
CHATCMD.Desc = "Plant a banana."
CHATCMD.CCName = "gms_plantbanana"

function CHATCMD:Run(ply)
	GAMEMODE.PlantBanana(ply)
end

GMS.RegisterChatCmd(CHATCMD)

/* Plant Orange */
local CHATCMD = {}

CHATCMD.Command = "orange"
CHATCMD.Desc = "Plant an orange."
CHATCMD.CCName = "gms_plantorange"

function CHATCMD:Run(ply)
	GAMEMODE.PlantOrange(ply)
end

GMS.RegisterChatCmd(CHATCMD)

/* Plant Grain */
local CHATCMD = {}

CHATCMD.Command = "grain"
CHATCMD.Desc = "Plant grain."
CHATCMD.CCName = "gms_plantgrain"

function CHATCMD:Run(ply)
	GAMEMODE.PlantGrain(ply)
end

GMS.RegisterChatCmd(CHATCMD)

/*---------------------------------------------------------
  Plant Berry Bush
---------------------------------------------------------*/
local CHATCMD = {}

CHATCMD.Command = "berrybush"
CHATCMD.Desc = "Plant berry bush."
CHATCMD.CCName = "gms_plantbush"

function CHATCMD:Run(ply)
	GAMEMODE.PlantBush(ply)
end

GMS.RegisterChatCmd(CHATCMD)

/* Plant Tree */
local CHATCMD = {}

CHATCMD.Command = "tree"
CHATCMD.Desc = "Plant a tree."
CHATCMD.CCName = "gms_planttree"

function CHATCMD:Run(ply)
	GAMEMODE.PlantTree(ply)
end

GMS.RegisterChatCmd(CHATCMD)

/* Drop Weapon */
local CHATCMD = {}

CHATCMD.Command = "dropweapon"
CHATCMD.Desc = "Drop your weapon."
CHATCMD.CCName = "gms_dropweapon"

function CHATCMD:Run(ply)
	GAMEMODE.DropWeapon(ply)
end

GMS.RegisterChatCmd(CHATCMD)

/* Resource Take */
local CHATCMD = {}

CHATCMD.Command = "take"
CHATCMD.Desc = "No amount will take as much as you can carry."
CHATCMD.Syntax = "<Resource Type> <Amount>"
CHATCMD.CCName = "gms_takeresources"
function CHATCMD:Run(ply, ...)
	args = {}
	args[1] = self.CCName
	args[2] = {...}

	GAMEMODE.TakeResource(ply, unpack(args))
end

GMS.RegisterChatCmd(CHATCMD)

/* Take Medicine */
local CHATCMD = {}

CHATCMD.Command = "medicine"
CHATCMD.Desc = "Take a Medicine."
CHATCMD.CCName = "gms_takemedicine"

function CHATCMD:Run(ply)
	GAMEMODE.TakeAMedicine(ply)
end

GMS.RegisterChatCmd(CHATCMD)

/* Go Afk */
local CHATCMD = {}

CHATCMD.Command = "afk"
CHATCMD.Desc = "Go away from keyboard"
CHATCMD.CCName = "gms_afk"

function CHATCMD:Run(ply)
	GAMEMODE.AFK(ply)
	ply:ConCommand("-menu")
end

GMS.RegisterChatCmd(CHATCMD)

/* ADMIN: Reset needs */
local CHATCMD = {}

CHATCMD.Command = "rn"
CHATCMD.Desc = "Reset your / someone needs"

function CHATCMD:Run(ply, ...)
	if (!ply:IsAdmin()) then return end
	if (#arg > 0) then
		pl = player.FindByName(arg[1])
		if (!pl) then ply:SendMessage("Player not found!", 3, Color(200, 10, 10, 255)) return end
		pl.Hunger = 1000
		pl.Thirst = 1000
		pl.Sleepiness = 1000
		pl:UpdateNeeds()
	else
		ply.Hunger = 1000
		ply.Thirst = 1000
		ply.Sleepiness = 1000
		ply:UpdateNeeds()
	end
end

GMS.RegisterChatCmd(CHATCMD)

/* ADMIN: Give resources */
local CHATCMD = {}

CHATCMD.Command = "r"
CHATCMD.Desc = "Give resources to yourself / someone"
CHATCMD.Syntax = "[player] <Resource> <Amount>"

function CHATCMD:Run(ply, ...)
	if (!ply:IsAdmin()) then return end
	if (#arg > 2) then
		local pl = player.FindByName(arg[1])
		if (!pl) then ply:SendMessage("Player not found!", 3, Color(200, 10, 10, 255)) return end
		pl:IncResource(arg[2], tonumber(arg[3]))
	elseif (#arg == 2) then
		ply:IncResource(arg[1], tonumber(arg[2]))
	end
end

GMS.RegisterChatCmd(CHATCMD)

/* Create tribe */
local CHATCMD = {}

CHATCMD.Command = "createtribe"
CHATCMD.Desc = "Create a tribe."
CHATCMD.Syntax = "<Tribe Name> <Red 0-255> <Green 0-255> <Blue 0-255> [Tribe Password]"
CHATCMD.CCName = "gms_createtribe"

function CHATCMD:Run(ply, ...)
	args = {}
	args[1] = self.CCName
	args[2] = {...}

	GAMEMODE.CreateTribeCmd(ply, unpack(args))
end

GMS.RegisterChatCmd(CHATCMD)

/* Invite to tribe */
local CHATCMD = {}

CHATCMD.Command = "invite"
CHATCMD.Desc = "Invite someone to your tribe"
CHATCMD.Syntax = "<player>"

function CHATCMD:Run(ply, ...)
	local him = player.FindByName(arg[1])
	if (!him) then ply:SendMessage("Player not found!", 3, Color(200, 10, 10, 255)) return end
	if (him == ply) then return end
	local mahTribe = GAMEMODE.FindTribeByID(ply:Team())

	if (!mahTribe) then ply:SendMessage("Something went wrong! Report this to admins: " .. ply:Team(), 3, Color(200, 10, 10, 255)) return end
	umsg.Start("gms_invite", him)
		umsg.String(mahTribe.name)
		umsg.String(tostring(mahTribe.Password))
	umsg.End()
end

GMS.RegisterChatCmd(CHATCMD)

/* Join tribe */
local CHATCMD = {}

CHATCMD.Command = "join"
CHATCMD.Desc = "Join a tribe."
CHATCMD.Syntax = "<Tribe Name> [Tribe Password]"
CHATCMD.CCName = "gms_join"

function CHATCMD:Run(ply, ...)
	args = {}
	args[1] = self.CCName
	args[2] = {...}

	GAMEMODE.JoinTribeCmd(ply, unpack(args))
end

GMS.RegisterChatCmd(CHATCMD)

/* Leave tribe */
local CHATCMD = {}

CHATCMD.Command = "leave"
CHATCMD.Desc = "Leave a tribe."
CHATCMD.CCName = "gms_leave"

function CHATCMD:Run(ply, ...)
	args = {}
	args[1] = self.CCName
	args[2] = {...}

	GAMEMODE.LeaveTribeCmd(ply, unpack(args))
end

GMS.RegisterChatCmd(CHATCMD)

/* Steal */
local CHATCMD = {}

CHATCMD.Command = "steal"
CHATCMD.Desc = "Steal a prop."
CHATCMD.CCName = "gms_steal"

function CHATCMD:Run(ply)
	ply.ConCommand(ply, "gms_steal")
end

GMS.RegisterChatCmd(CHATCMD)