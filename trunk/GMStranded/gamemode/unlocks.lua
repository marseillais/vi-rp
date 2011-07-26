
GMS.FeatureUnlocks = {}
function GMS.RegisterUnlock(tbl)
	GMS.FeatureUnlocks[string.Replace(tbl.Name, " ", "_")] = tbl
end

/* Sprinting I */
local UNLOCK = {}

UNLOCK.Name = "Sprinting I"
UNLOCK.Description = "You can now hold down shift to sprint."

UNLOCK.Req = {}
UNLOCK.Req["Survival"] = 3

GMS.RegisterUnlock(UNLOCK)

/* Sprinting II */
local UNLOCK = {}

UNLOCK.Name = "Sprinting II"
UNLOCK.Description = "Your movement speed has got permanent increase. Also, your sprint is now walk."

UNLOCK.Req = {}
UNLOCK.Req["Survival"] = 10

function UNLOCK.OnUnlock(ply)
	GAMEMODE:SetPlayerSpeed(ply, 400, 100)
end

GMS.RegisterUnlock(UNLOCK)

/* Adept Survivalist */
local UNLOCK = {}

UNLOCK.Name = "Adept Survivalist"
UNLOCK.Description = "Your max health has been increased by 50%."

UNLOCK.Req = {}
UNLOCK.Req["Survival"] = 15

function UNLOCK.OnUnlock(ply)
	ply:Heal(25)
end
GMS.RegisterUnlock(UNLOCK)

/* Master Survivalist*/
local UNLOCK = {}

UNLOCK.Name = "Master Survivalist"
UNLOCK.Description = "Your max health has been increased by 33%."

UNLOCK.Req = {}
UNLOCK.Req["Survival"] = 30

function UNLOCK.OnUnlock(ply)
	ply:Heal(25)
end
GMS.RegisterUnlock(UNLOCK)

/* Extreme Survivalist */
local UNLOCK = {}

UNLOCK.Name = "Extreme Survivalist"
UNLOCK.Description = "You can now become a pigeon and fly around."

UNLOCK.Req = {}
UNLOCK.Req["Survival"] = 50

function UNLOCK.OnUnlock(ply)
	ply:Give("pill_pigeon")
end

GMS.RegisterUnlock(UNLOCK)

/* Sprout Collecting */
local UNLOCK = {}

UNLOCK.Name = "Sprout Collecting"
UNLOCK.Description = "You can now press use on a tree to attempt to loosen a sprout.\nSprouts can be planted if you have the skill, and they will grow into trees."

UNLOCK.Req = {}
UNLOCK.Req["Lumbering"] = 5
UNLOCK.Req["Harvesting"] = 5

GMS.RegisterUnlock(UNLOCK)

/* Grain Planting */
local UNLOCK = {}

UNLOCK.Name = "Grain Planting"
UNLOCK.Description = "You can now plant grain."

UNLOCK.Req = {}
UNLOCK.Req["Planting"] = 3

GMS.RegisterUnlock(UNLOCK)

/* Sprout Planting */
local UNLOCK = {}

UNLOCK.Name = "Sprout Planting"
UNLOCK.Description = "You can now plant sprouts, which will grow into trees."

UNLOCK.Req = {}
UNLOCK.Req["Planting"] = 5

GMS.RegisterUnlock(UNLOCK)

/* Adept Farmer */
local UNLOCK = {}

UNLOCK.Name = "Adept Farmer"
UNLOCK.Description = "Your melon vines can now carry up to three 2 melons instead of one."

UNLOCK.Req = {}
UNLOCK.Req["Planting"] = 13

GMS.RegisterUnlock(UNLOCK)

/* Expert Farmer */
local UNLOCK = {}

UNLOCK.Name = "Expert Farmer"
UNLOCK.Description = "Your melon vines can now carry up to three 3 melons instead of one."

UNLOCK.Req = {}
UNLOCK.Req["Planting"] = 22

GMS.RegisterUnlock(UNLOCK)
