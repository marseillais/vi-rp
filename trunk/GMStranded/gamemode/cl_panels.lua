
Active = false

/*---------------------------------------------------------
  Spawnpanel
---------------------------------------------------------*/
function GM:OnSpawnMenuOpen()
	if (LocalPlayer():GetNWString("AFK") != 1) then
		if (GAMEMODE.MENU == nil or not GAMEMODE.MENU:IsValid()) then
			GAMEMODE.MENU = vgui.Create("GMS_menu")
		else
			GAMEMODE.MENU:SetVisible(true)
		end
		gui.EnableScreenClicker(true)
		RestoreCursorPosition()
	end
end

function GM:OnSpawnMenuClose()
	if (GAMEMODE.MENU and GAMEMODE.MENU:IsValid() and GAMEMODE.MENU:IsVisible()) then GAMEMODE.MENU:SetVisible(false) end
	RememberCursorPosition()
	gui.EnableScreenClicker(false)
end

local PANEL = {}

function PANEL:Init()
	self:SetTitle("Stranded Menu")
	self:ShowCloseButton(false)
	
	self.ContentPanel = vgui.Create("DPropertySheet", self)
	self.ContentPanel:AddSheet("Construction", vgui.Create("stranded_PropSpawn", self.ContentPanel), "gui/silkicons/brick_add", false, false)
	self.ContentPanel:AddSheet("ToolMenu", vgui.Create("stranded_ToolMenu", self.ContentPanel), "gui/silkicons/wrench", true, true)
	self.ContentPanel:AddSheet("Planting", vgui.Create("stranded_PlantSpawn", self.ContentPanel), "gui/silkicons/box", false, false)
	self.ContentPanel:AddSheet("Commands", vgui.Create("stranded_Commands", self.ContentPanel), "gui/silkicons/application", true, true)
	self.ContentPanel:AddSheet("Prop Protection", vgui.Create("stranded_SPPMenu", self.ContentPanel), "gui/silkicons/shield", true, true)
end

function PANEL:Close()
	menuup = false
 	self:Remove()
end

function PANEL:PerformLayout()
	self:SetSize(ScrW() / 2 - 10, ScrH() - 10)
	self:SetPos(ScrW() / 2 + 5, 5)
	self.ContentPanel:StretchToParent(5, 21, 5, 5)
	
	DFrame.PerformLayout(self)
end

vgui.Register("GMS_menu", PANEL, "DFrame")

/*---------------------------------------------------------
  Unlock window
---------------------------------------------------------*/
local PANEL = {}

function PANEL:Init()
	self:SetTitle("You have unlocked a new ability!")
	self:SetMouseInputEnabled(true)
	self:MakePopup()

	self.Name = "Name"

	self:SetSize(ScrW() / 2, 250)
	self:Center()

	self.DescWindow = vgui.Create("RichText", self)
	self.DescWindow:SetPos(5, 100)
	self.DescWindow:SetSize(self:GetWide() - 10, self:GetTall() - 140)
	self.DescWindow:SetText("Description.")

	self.Okay = vgui.Create("DButton", self)
	self.Okay:SetSize(self:GetWide() - 10, 30)
	self.Okay:SetPos(5, self:GetTall() - 35)
	self.Okay:SetText("Okay")
	self.Okay.DoClick = function()
		self:Close()
	end
end

function PANEL:Paint()
	DFrame.Paint(self)
	draw.SimpleTextOutlined(self.Name, "ScoreboardHead", self:GetWide() / 2, 60, Color(10, 200, 10, 255), 1, 1, 0.5, Color(100, 100, 100, 160))
	return true
end

function PANEL:SetUnlock(text)
	local unlock = GMS.FeatureUnlocks[text]
	if (!unlock) then return end

	self.Name = unlock.Name
	self.DescWindow:SetText(unlock.Description)
end

vgui.Register("GMS_UnlockWindow", PANEL, "DFrame") // The hax.


/*---------------------------------------------------------
  Tribe Menu
---------------------------------------------------------*/
local PANEL = {}

function PANEL:Init()
	self:SetTitle("Create-A-Tribe")
	self:SetKeyboardInputEnabled(true)
	self:SetMouseInputEnabled(true)
	self:MakePopup()
	self:SetSize(275, 305)
	self:Center()

	local tnamelabel = vgui.Create("DLabel", self)
	tnamelabel:SetPos(5, 21)
	tnamelabel:SetText("Tribe name")

	local tname = vgui.Create("DTextEntry", self)
	tname:SetSize(self:GetWide() - 10, 20)
	tname:SetPos(5, 40)

	local tpwlabel = vgui.Create("DLabel", self)
	tpwlabel:SetPos(5, 65)
	tpwlabel:SetText("Tribe password (Optional)")
	tpwlabel:SizeToContents()

	local tpw = vgui.Create("DTextEntry", self)
	tpw:SetSize(self:GetWide() - 10, 20)
	tpw:SetPos(5, 80)

	local tcollabel = vgui.Create("DLabel", self)
	tcollabel:SetPos(5, 105)
	tcollabel:SetText("Tribe color")

	local tcolor = vgui.Create("DColorMixer", self)
	tcolor:SetSize(self:GetWide() + 15, 150)
	tcolor:SetPos(5, 125)

	local button = vgui.Create("DButton", self)
	button:SetSize(self:GetWide() - 10, 20)
	button:SetPos(5, 280)
	button:SetText("Create Tribe!")
	button.DoClick = function()
		RunConsoleCommand("gms_createtribe", tname:GetValue(), tcolor:GetColor().r, tcolor:GetColor().g, tcolor:GetColor().b, tpw:GetValue())
		self:SetVisible(false)
	end
end
vgui.Register("GMS_TribeMenu", PANEL, "DFrame")

/*---------------------------------------------------------
  Tribes List
---------------------------------------------------------*/
local PANEL = {}

function PANEL:Init()
    self:SetTitle("Join-A-Tribe")
    self:SetKeyboardInputEnabled(true)
    self:SetMouseInputEnabled(true)
    self:MakePopup()

	local tid = 0 
	
	for id, tabl in pairs(Tribes) do
		local name = tabl.name
		local hazpass = tabl.pass
		id = id - 1
        local button = vgui.Create("DButton", self)
        button:SetSize(ScrW() / 4 - 10, 20)
        button:SetPos(5, 28 + id * 25)
        button.DoClick = function()
			if (hazpass) then
				Derma_StringRequest("Please enter password", "Please enter password for the tribe.", "", function(text) RunConsoleCommand("gms_join", name, text) end)
			else
				RunConsoleCommand("gms_join", name)
			end
			self:Close()
		end
        button:SetText(name)
		tid = id
    end
	
	self:SetSize(ScrW() / 4, tid * 25 + 53)
	self:Center()
end
vgui.Register("GMS_TribesList", PANEL, "DFrame")

/*---------------------------------------------------------
  Need HUD
---------------------------------------------------------*/
local PANEL = {}

function PANEL:Init()
    self:SetPos(0, 0)
    self:SetSize(ScrW() / 6, 7 * 13 + 5)
    self:SetVisible(true)
end

function PANEL:Paint()
    local col = StrandedColorTheme
    local bordcol = StrandedBorderTheme

    surface.SetDrawColor(col.r, col.g, col.b, math.Clamp(col.a - 60, 1, 255))
    surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

	surface.SetDrawColor(bordcol.r, bordcol.g, bordcol.b, math.Clamp(bordcol.a - 60, 1, 255))
	surface.DrawLine(self:GetWide() - 1, 0, self:GetWide() - 1, self:GetTall()) -- Nice line instead of messy outlined rect
	surface.DrawLine(0, self:GetTall() - 1, self:GetWide(), self:GetTall() - 1)
	
    local w = self:GetWide() - 10

    //Health
    local h = math.floor((LocalPlayer():Health() / 200) * w)
    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawRect(5, 5, w, 8)

    surface.SetDrawColor(170,0,0,255)
	surface.DrawRect(5, 5, h, 8)

	draw.SimpleTextOutlined("Health", "DefaultSmall", self:GetWide() / 2, 9, Color(255, 255, 255, 255), 1, 1, 0.5, Color(100, 100, 100, 140))

    //Hunger
    local h = math.floor((Hunger / 1000) * w)
    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawRect(5, 18, w, 8)

    surface.SetDrawColor(0, 170, 0, 255)
    surface.DrawRect(5, 18, h, 8)

	draw.SimpleTextOutlined("Hunger","DefaultSmall",self:GetWide() / 2, 22, Color(255, 255, 255, 255), 1, 1, 0.5, Color(100, 100, 100, 140))

    //Thirst
    local h = math.floor((Thirst / 1000) * w)
    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawRect(5, 31, w, 8)

    surface.SetDrawColor(0, 0, 170, 255)
    surface.DrawRect(5, 31, h, 8)

	draw.SimpleTextOutlined("Thirst", "DefaultSmall", self:GetWide() / 2, 35, Color(255, 255, 255, 255), 1, 1, 0.5, Color(100, 100, 100, 140))

    //Sleepiness
    local h = math.floor((Sleepiness / 1000) * w)
    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawRect(5, 44, w, 8)

    surface.SetDrawColor(170, 0, 140, 255)
    surface.DrawRect(5, 44, h, 8)

	draw.SimpleTextOutlined("Fatigue", "DefaultSmall", self:GetWide() / 2, 48, Color(255, 255, 255, 255), 1, 1, 0.5, Color(100, 100, 100, 140))
	
	//Oxygen
	if (Oxygen < 1000) then
		local h = math.floor((Oxygen / 1000) * w)
		surface.SetDrawColor(0, 0, 0,255)
		surface.DrawRect(5, 57, w, 8)

		surface.SetDrawColor(0, 255, 255, 255)
		surface.DrawRect(5, 57, h, 8)

		draw.SimpleTextOutlined("Oxygen", "DefaultSmall", self:GetWide() / 2, 61, Color(255, 255, 255, 255), 1, 1, 0.5, Color(100, 100, 100, 140))
	end
	
	// Time
	local hours = tostring(math.floor(Time / 60))
	local mins = tostring(Time % 60)
	local tim = ""
	if (string.len(hours) == 1) then tim = "0" .. hours else tim = hours end
	if (string.len(mins) == 1) then tim = tim .. ":0" .. mins else tim = tim .. ":" .. mins end
	draw.SimpleText(tim, "ScoreboardSub", self:GetWide() / 2, 82, Color(255, 255, 255, 255), 1, 1)
	return true
end

vgui.Register("gms_NeedHud", PANEL, "DPanel")

/*---------------------------------------------------------
  Skills panel
---------------------------------------------------------*/
local PANEL = {}

function PANEL:Init()
    self:SetPos(0, GAMEMODE.NeedHud:GetTall())
    self:SetSize(ScrW() / 6, 34)

    self:SetVisible(true)

    self.Extended = false
    self.SkillLabels = {}
	
	self:RefreshSkills()
end

function PANEL:Paint()
    local col = StrandedColorTheme
    local bordcol = StrandedBorderTheme

	surface.SetDrawColor(col.r, col.g, col.b, math.Clamp(col.a - 60, 1, 255))
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
	
	surface.SetDrawColor(bordcol.r, bordcol.g, bordcol.b, math.Clamp(bordcol.a - 60, 1, 255))
	surface.DrawLine(self:GetWide() - 1, 0, self:GetWide() - 1, self:GetTall()) -- Nice line instead of messy outlined rect
	surface.DrawLine(0, self:GetTall() - 1, self:GetWide(), self:GetTall() - 1)
	if (self.Extended) then 
		surface.DrawLine(0, 33, self:GetWide(), 33)
	end

	draw.SimpleText("Skills (F1)", "ScoreboardSub", self:GetWide() / 2, 17, Color(255, 255, 255, 255), 1, 1)
	return true
end

function PANEL:RefreshSkills()
	for k, v in pairs(self.SkillLabels) do v:Remove() end

	self.SkillLabels = {}
	self.Line = 39

	for k, v in SortedPairs(Skills) do
		local lbl = vgui.Create("gms_SkillPanel", self)
		lbl:SetPos(0, self.Line)
		lbl:SetSize(self:GetWide(), 16)
		local val = string.gsub(k, "_", " ")
		lbl:SetSkill(val)

		self.Line = self.Line + lbl:GetTall() + 5
		table.insert(self.SkillLabels, lbl)
		if (!self.Extended) then lbl:SetVisible(false) end
	end

	if (self.Extended) then 
		self:SetSize(ScrW() / 6, 40 + (table.Count(self.SkillLabels) * 21)) 
    end
end

function PANEL:ToggleExtend()
	if (!self.Extended) then
		self:SetSize(ScrW() / 6, 40 + (table.Count(self.SkillLabels) * 21))
		self.Extended = true

		for k, v in pairs(self.SkillLabels) do v:SetVisible(true) end
	else
		self:SetSize(ScrW() / 6, 34)
		self.Extended = false

		for k, v in pairs(self.SkillLabels) do v:SetVisible(false) end
	end
end

function PANEL:OnMousePressed(mc)
	if (mc == 107) then
		self:ToggleExtend()
	end
end

vgui.Register("gms_SkillsHud", PANEL, "Panel")

/*---------------------------------------------------------
  Skill Sub-Panel
---------------------------------------------------------*/
local PANEL = {}

function PANEL:Init()
end

function PANEL:Paint()
	surface.SetDrawColor(0, 0, 0, 178) -- XP bar background
	surface.DrawRect(5, 0, self:GetWide() - 10, self:GetTall())

	local XP = math.floor(Experience[self.Skill] / 100 * (self:GetWide() - 10))
	surface.SetDrawColor(0, 128, 0, 220) -- XP bar
	if (self.TxtSkill == "Survival") then
		surface.SetDrawColor(0, 128, 176, 220) -- XP bar
	end
	surface.DrawRect(5, 0, XP, self:GetTall())

	draw.SimpleText(self.TxtSkill .. ": " .. Skills[self.Skill] .. " (" .. Experience[self.Skill] .. " / 100)", "DefaultBold", self:GetWide() / 2, self:GetTall() / 2 - 1, Color(255, 255, 255, 255), 1, 1)
	return true
end

function PANEL:SetSkill(str)
    self.TxtSkill = str
    self.Skill = string.gsub(str, " ", "_")
end

vgui.Register("gms_SkillPanel", PANEL, "Panel")

/*---------------------------------------------------------
  Resource panel
---------------------------------------------------------*/
local PANEL = {}

function PANEL:Init()
    self:SetPos(ScrW() - (ScrW() / 6) + 1, 0)
    self:SetSize(ScrW() / 6, 34)
    self:SetVisible(true)
    self.Extended = false
    self.ResourceLabels = {}
	
	self:RefreshResources()
end

function PANEL:Paint()
    local col = StrandedColorTheme
    local bordcol = StrandedBorderTheme

    surface.SetDrawColor(col.r, col.g, col.b, math.Clamp(col.a - 60, 1, 255))
    surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

    surface.SetDrawColor(bordcol.r, bordcol.g, bordcol.b, math.Clamp(bordcol.a - 60, 1, 255))
	surface.DrawLine(0, 0, 0, self:GetTall()) -- Nice line instead of messy outlined rect
	surface.DrawLine(0, self:GetTall() - 1, self:GetWide(), self:GetTall() - 1)
	if (self.Extended) then 
		surface.DrawLine(0, 33, self:GetWide(), 33)
	end

    draw.SimpleText("Resources (F2)", "ScoreboardSub", self:GetWide() / 2, 17, Color(255, 255, 255, 255), 1, 1)
    return true
end

function PANEL:RefreshResources()
	for k, v in pairs(self.ResourceLabels) do v:Remove() end

	self.ResourceLabels = {}
	self.Line = 39
	self.Resourcez = 0

	for k, v in SortedPairs(Resources) do
		if (v > 0) then
			local lbl = vgui.Create("gms_ResourcePanel", self)
			lbl:SetPos(0, self.Line)
			lbl:SetSize(self:GetWide(), 16)
			lbl:SetResource(k)
			self.Resourcez = self.Resourcez + v

			self.Line = self.Line + lbl:GetTall() + 5
			table.insert(self.ResourceLabels, lbl)
			if (!self.Extended) then lbl:SetVisible(false) end
		end
	end
	
	self.Line = self.Line + 21
	
	local lblT = vgui.Create("gms_ResourcePanelTotal", self)
	lblT:SetPos(0, self.Line)
	lblT:SetSize(self:GetWide(), 16)
	lblT:SetResources(self.Resourcez)

	table.insert(self.ResourceLabels, lblT)
	if (!self.Extended) then lblT:SetVisible(false) end

	if (self.Extended) then 
		self:SetSize(ScrW() / 6, 40 + ((table.Count(self.ResourceLabels) + 1) * 21)) 
    end
	
	if (GAMEMODE.CommandsHud) then GAMEMODE.CommandsHud:SetPos(ScrW() - (ScrW() / 6) + 1, self:GetTall()) end
end

function PANEL:ToggleExtend()
    if (!self.Extended) then
        self:SetSize(ScrW() / 6, 40 + ((table.Count(self.ResourceLabels) + 1) * 21))
        self.Extended = true
		for k,v in pairs(self.ResourceLabels) do
			v:SetVisible(true)
		end
    else
		self:SetSize(ScrW() / 6, 34)
        self.Extended = false
		for k, v in pairs(self.ResourceLabels) do
			v:SetVisible(false)
		end
    end
	if (GAMEMODE.CommandsHud) then GAMEMODE.CommandsHud:SetPos(ScrW() - (ScrW() / 6) + 1, self:GetTall()) end
end

function PANEL:OnMousePressed(mc)
    if (mc == 107) then
        self:ToggleExtend()
    end
end
vgui.Register("gms_ResourcesHud", PANEL, "Panel")

/*---------------------------------------------------------
  Resource Sub-Panel
---------------------------------------------------------*/
local PANEL = {}

PANEL.Actions = {}
PANEL.Actions["Sprouts"] = {cmd = "gms_planttree", name = "Plant"}
PANEL.Actions["Banana Seeds"] = {cmd = "gms_plantbanana", name = "Plant"}
PANEL.Actions["Orange Seeds"] = {cmd = "gms_plantorange", name = "Plant"}
PANEL.Actions["Grain Seeds"] = {cmd = "gms_plantgrain", name = "Plant"}
PANEL.Actions["Melon Seeds"] = {cmd = "gms_plantmelon", name = "Plant"}
PANEL.Actions["Berries"] = {cmd = "gms_plantbush", name = "Plant"}
PANEL.Actions["Medicine"] = {cmd = "gms_TakeMedicine", name = "Take"}
PANEL.Actions["Water Bottles"] = {cmd = "gms_DrinkBottle", name = "Drink"}

PANEL.MoreActions = {}
PANEL.MoreActions["Berries"] = {
	{cmd = "gms_EatBerry", name = "Eat"}
}

function PANEL:Init()
	self:SetText("")
end

function PANEL:Paint()
	surface.SetDrawColor(0, 0, 0, 178) -- Resource bar background
	surface.DrawRect(5, 0, self:GetWide() - 10, self:GetTall())

	local XP = math.floor(Resources[self.Resource] / MaxResources * (self:GetWide() - 10))
	surface.SetDrawColor(0, 128, 0, 200) -- Resource bar
	surface.DrawRect(5, 0, XP, self:GetTall())

	if (self.Hovered) then
		surface.SetDrawColor(255, 255, 255, 64) -- Resource bar background
		surface.DrawRect(5, 0, self:GetWide() - 10, self:GetTall())
	end
	
	draw.SimpleText(self.TxtResource .. ": " .. Resources[self.Resource], "DefaultBold", self:GetWide() / 2, self:GetTall() / 2 - 1, Color(255, 255, 255, 255), 1, 1)
	return true
end

function PANEL:DoRightClick()
	local menu = DermaMenu()
	
	if (self.Actions[self.TxtResource]) then
		menu:AddOption(self.Actions[self.TxtResource].name, function() RunConsoleCommand(self.Actions[self.TxtResource].cmd) end)
		menu:AddSpacer()
	end
	
	if (self.MoreActions[self.TxtResource]) then
		for res, t in pairs(self.MoreActions[self.TxtResource]) do
			menu:AddOption(t.name, function() RunConsoleCommand(t.cmd) end)
		end
		menu:AddSpacer()
	end
	
    menu:AddOption("Drop x1", function() RunConsoleCommand("say", "!drop " .. self.Resource .. " 1") end)
    menu:AddOption("Drop x10", function() RunConsoleCommand("say", "!drop " .. self.Resource .. " 10") end)
    menu:AddOption("Drop All", function() RunConsoleCommand("say", "!drop " .. self.Resource) end)
    menu:AddOption("Cancel", function() end)
    menu:Open()
end

function PANEL:DoClick()
	if (self.Actions[self.TxtResource]) then
		RunConsoleCommand(self.Actions[self.TxtResource].cmd)
	end
end

function PANEL:SetResource(str)
    self.TxtResource = string.gsub(str, "_", " ")
    self.Resource = str
end

vgui.Register("gms_ResourcePanel", PANEL, "DButton")

/*---------------------------------------------------------
  Resource Total Sub-Panel
---------------------------------------------------------*/
local PANEL = {}

function PANEL:Init()
	self.Res = 0
end

function PANEL:Paint()
	surface.SetDrawColor(0, 0, 0, 178) -- Resource bar background
	surface.DrawRect(5, 0, self:GetWide() - 10, self:GetTall())

	local XP = math.floor(self.Res / MaxResources * (self:GetWide() - 10))
	surface.SetDrawColor(0, 128, 176, 220) -- Resource bar
	surface.DrawRect(5, 0, XP, self:GetTall())

	draw.SimpleText("Total: " .. self.Res .. " / " .. MaxResources, "DefaultBold", self:GetWide() / 2, self:GetTall() / 2 - 1, Color(255, 255, 255, 255), 1, 1)
	return true
end

function PANEL:SetResources(num)
	self.Res = num
end

vgui.Register("gms_ResourcePanelTotal", PANEL, "Panel")


/*---------------------------------------------------------
  Command panel
---------------------------------------------------------*/
local PANEL = {}

PANEL.Commands = {}
PANEL.Commands["AFK"] = {cmd = "gms_afk", clr = Color(0, 128, 255, 176)}
PANEL.Commands["Sleep"] = {cmd = "gms_sleep", clr = Color(0, 128, 255, 176)}
PANEL.Commands["Wake up"] = {cmd = "gms_wakeup", clr = Color(0, 128, 255, 176)}

PANEL.Commands["Make campfire"] = {cmd = "gms_makefire", clr = Color(255, 0, 0, 176)}
PANEL.Commands["Drop all resources"] = {cmd = "gms_dropall", clr = Color(255, 0, 0, 176)}

PANEL.Commands["Combinations"] = {cmd = "gms_GenericCombi", clr = Color(255, 255, 0, 176)}
PANEL.Commands["Structures"] = {cmd = "gms_BuildingsCombi", clr = Color(255, 255, 0, 176)}
PANEL.Commands["Salvage prop"] = {cmd = "gms_salvage", clr = Color(255, 255, 0, 176)}
PANEL.Commands["Drop weapon"] = {cmd = "gms_DropWeapon", clr = Color(255, 255, 0, 176)}

PANEL.Commands["Help"] = {cmd = "gms_help", clr = Color(255, 64, 255, 176)}

PANEL.Commands["Tribe: Create"] = {cmd = "gms_tribemenu", clr = Color(0, 128, 0, 176)}
PANEL.Commands["Tribe: Join"] = {cmd = "gms_tribes", clr = Color(0, 128, 0, 176)}
PANEL.Commands["Tribe: Leave"] = {cmd = "gms_leave", clr = Color(0, 128, 0, 176)}
PANEL.Commands["Save character"] = {cmd = "gms_savecharacter", clr = Color(0, 128, 0, 176)}
/*
function checkAdmin(ply)
	if (ply:IsAdmin()) then 
		PANEL.Commands["Admin menu"] = {cmd = "gms_admin", clr = Color(0, 128, 0, 176)}
	end
end*/

function PANEL:Init()
	//checkAdmin(LocalPlayer())
    self:SetPos(ScrW() - (ScrW() / 6) + 1, 33)
    self:SetSize(ScrW() / 6, 34)
    self:SetVisible(true)
    self.Extended = false
    self.CommandLabels = {}

	self:RefreshCommands()
end

function PANEL:Paint()
    local col = StrandedColorTheme
    local bordcol = StrandedBorderTheme

    surface.SetDrawColor(col.r, col.g, col.b, math.Clamp(col.a - 60, 1, 255))
    surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

    surface.SetDrawColor(bordcol.r, bordcol.g, bordcol.b, math.Clamp(bordcol.a - 60, 1, 255))
	surface.DrawLine(0, 0, 0, self:GetTall()) -- Nice line instead of messy outlined rect
	surface.DrawLine(0, self:GetTall() - 1, self:GetWide(), self:GetTall() - 1)
	if (self.Extended) then 
		surface.DrawLine(0, 33, self:GetWide(), 33)
	end

    draw.SimpleText("Commands (F3)", "ScoreboardSub", self:GetWide() / 2, 17, Color(255, 255, 255, 255), 1, 1)
    return true
end

function PANEL:RefreshCommands()
	for k, v in pairs(self.CommandLabels) do v:Remove() end

	self.CommandLabels = {}
	self.Line = 39

	for name, tabl in SortedPairs(self.Commands) do
		local lbl = vgui.Create("gms_CommandPanel", self)
		lbl:SetPos(0, self.Line)
		lbl:SetSize(self:GetWide(), 16)
		lbl:SetCommand(tabl.cmd, name, tabl.clr)

		self.Line = self.Line + lbl:GetTall() + 5
		table.insert(self.CommandLabels, lbl)
		if (!self.Extended) then lbl:SetVisible(false) end
	end

	if (self.Extended) then 
		self:SetSize(ScrW() / 6, 40 + (table.Count(self.CommandLabels) * 21)) 
    end
end

function PANEL:ToggleExtend()
    if (!self.Extended) then
        self:SetSize(ScrW() / 6, 40 + (table.Count(self.CommandLabels) * 21))
        self.Extended = true
		for k,v in pairs(self.CommandLabels) do
			v:SetVisible(true)
		end

		gui.EnableScreenClicker(true)
		RestoreCursorPosition()
    else
		self:SetSize(ScrW() / 6, 34)
        self.Extended = false
		for k, v in pairs(self.CommandLabels) do
			v:SetVisible(false)
		end
		
		RememberCursorPosition()
		gui.EnableScreenClicker(false)
    end
end

function PANEL:OnMousePressed(mc)
    if (mc == 107) then
        self:ToggleExtend()
    end
end
vgui.Register("gms_CommandsHud", PANEL, "Panel")

/*---------------------------------------------------------
  Command Sub-Panel
---------------------------------------------------------*/
local PANEL = {}

function PANEL:Init()
	self:SetText("")
	self.Cmd = ""
	self.Text = ""
	self.Clr = Color(0, 128, 0, 178)
end

function PANEL:Paint()
	surface.SetDrawColor(self.Clr.r, self.Clr.g, self.Clr.b, self.Clr.a) -- Resource bar background
	surface.DrawRect(5, 0, self:GetWide() - 10, self:GetTall())

	if (self.Hovered) then
		surface.SetDrawColor(255, 255, 255, 64)
		surface.DrawRect(5, 0, self:GetWide() - 10, self:GetTall())
	end
	
	draw.SimpleText(self.Text, "DefaultBold", self:GetWide() / 2, self:GetTall() / 2 - 1, Color(255, 255, 255, 255), 1, 1)
	return true
end

function PANEL:DoClick()
	RunConsoleCommand(self.Cmd)
end

function PANEL:SetCommand(str, text, clr)
    self.Cmd = str
	self.Text = text
	self.Clr = clr
end

vgui.Register("gms_CommandPanel", PANEL, "DButton")

/*---------------------------------------------------------
  HUDHint
---------------------------------------------------------*/
local PANEL = {}

function PANEL:Init()
	self:SetText("")
	self.Text = ""
end

function PANEL:Paint()
	local col = StrandedColorTheme
	local bordcol = StrandedBorderTheme

	surface.SetDrawColor(col.r, col.g, col.b, math.Clamp(col.a - 60, 1, 255))
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

	surface.SetDrawColor(bordcol.r, bordcol.g, bordcol.b, math.Clamp(bordcol.a - 60, 1, 255))
	surface.DrawLine(0, 0, 0, self:GetTall()) -- Nice line instead of messy outlined rect
	surface.DrawLine(self:GetWide() - 1, 0, self:GetWide() - 1, self:GetTall())
	surface.DrawLine(0, 0, self:GetWide(), 0)
	surface.DrawLine(0, self:GetTall() - 1, self:GetWide(), self:GetTall() - 1)
    
	local strs = string.Explode('\n', self.Text)
	for id, str in pairs(strs) do
		id = id - 1
		draw.SimpleText(str, "DefaultBold", 5, 5 + id * 12, Color(255, 255, 255))
	end

	return true
end

function PANEL:DoClick()
	self:Remove()
end

function PANEL:SetHint(text)
	self.Text = text

	surface.SetFont("DefaultBold")
	local w, h = surface.GetTextSize(self.Text)
	self:SetSize(w + 10, h)
end

vgui.Register("gms_HUDHint", PANEL, "DButton") // The hax.

/*---------------------------------------------------------
  GMS dropdown
---------------------------------------------------------*/
local PANEL = {}

function PANEL:Init()
         self.Children = {}
         self.Extended = false
         self.Active = nil
end

function PANEL:SetInitSize(w,h)
         self.InitW = w
         self.InitH = h
         
         self:SetSize(w,h)
end

function PANEL:AddItem(text,value)
         local item = vgui.Create("GMS_DropDown_Item",self)
         item:SetPos(0,self.InitH)
         item:SetSize(self:GetWide(),self.InitH)
         item:SetInfo(text,value)
         
         if !self.Extended then item:SetVisible(false) end
         table.insert(self.Children,item)
end

function PANEL:RemoveItem(text)
         self.Active = nil

         for k,item in pairs(self.Children) do
             if item.Text == text then
                item:Remove()
                item = nil
                table.remove(self.Children,k)
             end
         end
         
         if self.Extended then
            self:Retract()
         else
            self:Extend()
            self:Retract()
         end
end

function PANEL:Clear()
         for k,v in pairs(self.Children) do
             v:Remove()
         end

         self.Children = {}
         self.Active = nil
         self:Retract()
end

function PANEL:SetActive(item)
         if self.Active then
            self.Active.Active = false
         end
         
         if item then item.Active = true end
         self.Active = item
end

function PANEL:Extend()
         self.Extended = true
         local line = self.InitH

         for k,item in pairs(self.Children) do
             item:SetPos(0,line)
             item:SetVisible(true)
             
             line = line + self.InitH
         end
         
         self:SetSize(self.InitW,self.InitH + (#self.Children * self.InitH))
         self:SetZPos(310)
end

function PANEL:Retract()
         self.Extended = false
         
         for k,item in pairs(self.Children) do
             item:SetPos(0,0)
             item:SetVisible(false)
         end
         
         self:SetZPos(300)
         self:SetSize(self.InitW,self.InitH)
end

function PANEL:Paint()
         local col = StrandedColorTheme
         local bordcol = StrandedBorderTheme

         surface.SetDrawColor(0,0,0,255)
         surface.DrawRect(0,0,self:GetWide(),self:GetTall())
         
         surface.SetDrawColor(0,0,0,180)
         surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
         
         if self.Active then
            draw.SimpleText(self.Active.Text,"Default",5,5,Color(255,255,255,255))
         else
            draw.SimpleText("< select >","Default",5,5,Color(255,255,255,255))
         end

         return true
end

function PANEL:GetValue()
         if self.Active then
            return self.Active.Value or nil
         end
         
         return false
end

function PANEL:GetText()
         if self.Active then
            return self.Active.Text or ""
         end
         
         return ""
end

function PANEL:OnMousePressed(mc)
         if mc != 107 then return end
         if !self.Extended then self:Extend() end
end

vgui.Register("GMS_DropDown",PANEL,"Panel")

/*---------------------------------------------------------
  GMS dropdown item
---------------------------------------------------------*/
local PANEL = {}

function PANEL:Init()
         self.Text = ""
         self.Value = nil
         self.Color = Color(11,11,11,255)
end

function PANEL:SetInfo(text,value)
         self.Text = text
         self.Value = value
end

function PANEL:Paint()
         surface.SetDrawColor(self.Color.r,self.Color.g,self.Color.b,255)
         surface.DrawRect(0,0,self:GetWide(),self:GetTall())

         draw.SimpleText(self.Text,"Default",5,5,Color(255,255,255,255))
         return true
end

function PANEL:OnMousePressed(mc)
         if mc != 107 then return end
         self:GetParent():SetActive(self)
         self:GetParent():Retract()
end

function PANEL:OnCursorEntered()
         self.Color = Color(55,55,55,255)
end

function PANEL:OnCursorExited()
         self.Color = Color(11,11,11,255)
end


vgui.Register("GMS_DropDown_Item",PANEL,"Panel")

/*---------------------------------------------------------
  Admin menu
---------------------------------------------------------*/
local PANEL = {}

PANEL.CmdButtons = {}
PANEL.CmdButtons["gms_admin_makefood"] = "Spawn food"
PANEL.CmdButtons["gms_admin_makerock"] = "Spawn rock"
PANEL.CmdButtons["gms_admin_maketree"] = "Spawn tree"
PANEL.CmdButtons["gms_admin_makebush"] = "Spawn random plant"
PANEL.CmdButtons["gms_admin_saveallcharacters"] = "Save all characters"

function PANEL:Init()
	self:SetTitle("Admin Menu")
	self:SetDeleteOnClose(false)
	self:SetKeyboardInputEnabled(true)
	self:SetMouseInputEnabled(true)
	self:MakePopup()
	local size = ScrH() / 30
	local space = 10
	self:SetSize(ScrW() / 1.5, ScrH() - 100)
	self:SetPos(ScrW() / 2 - (self:GetWide() / 2), 50)

	local line = 30
	local tab = 0

	//Populate area command stuff
	local button = vgui.Create("gms_CommandButton",self)
	button:SetSize(self:GetWide() / 5, size)
	button:SetPos(10, line)
	button:SetText("Populate Area")

	local tab = tab + button:GetWide() + space + 10

	self.PopulateType = vgui.Create("DMultiChoice",self)
	self.PopulateType:SetSize(button:GetWide(),button:GetTall())
	self.PopulateType:SetPos(tab,line)
	self.PopulateType:AddChoice("Trees","forest")
	self.PopulateType:AddChoice("Rocks","rocks")
	self.PopulateType:AddChoice("Random_Plant","plant")

	local label = vgui.Create("DLabel",self)
	label:SetPos(tab,line - 20)
	label:SetSize(button:GetWide(),20)
	label:SetText("Type")

	local tab = tab + self.PopulateType:GetWide() + space

	self.PopulateAmount = vgui.Create("DTextEntry",self)
	self.PopulateAmount:SetSize(button:GetWide(),button:GetTall())
	self.PopulateAmount:SetPos(tab,line)

	local label = vgui.Create("DLabel",self)
	label:SetPos(tab,line - 20)
	label:SetSize(button:GetWide(),20)
	label:SetText("Amount")

	local tab = tab + self.PopulateType:GetWide() + space

	self.PopulateRadius = vgui.Create("DTextEntry",self)
	self.PopulateRadius:SetSize(button:GetWide(),button:GetTall())
	self.PopulateRadius:SetPos(tab,line)

	local label = vgui.Create("DLabel",self)
	label:SetPos(tab,line - 20)
	label:SetSize(button:GetWide(),20)
	label:SetText("Max radius")

	function button:DoClick()
		local p = self:GetParent()
		local strType = p.PopulateType.TextEntry:GetValue() or ""
		RunConsoleCommand("gms_admin_PopulateArea", strType, string.Trim(p.PopulateAmount:GetValue()), string.Trim(p.PopulateRadius:GetValue()))
	end

	//Set ConVar stuff
	line = line + button:GetTall() + 30
	local tab = 0
	local button = vgui.Create("gms_CommandButton",self)
	button:SetSize(self:GetWide() / 5, size)
	button:SetPos(10, line)
	button:SetText("Set Convar")

	local tab = tab + button:GetWide() + space + 10

	self.ConVarList = vgui.Create("DMultiChoice",self)
	self.ConVarList:SetSize(button:GetWide() * 2 + space,button:GetTall())
	self.ConVarList:SetPos(tab,line)

	for k,v in pairs(GMS.ConVarList) do
	self.ConVarList:AddChoice(v,v)
	end

	local label = vgui.Create("DLabel",self)
	label:SetPos(tab,line - 20)
	label:SetSize(button:GetWide(),20)
	label:SetText("Convar")

	local tab = tab + self.ConVarList:GetWide() + space

	self.ConVarValue = vgui.Create("DTextEntry",self)
	self.ConVarValue:SetSize(button:GetWide(),button:GetTall())
	self.ConVarValue:SetPos(tab,line)

	local label = vgui.Create("DLabel",self)
	label:SetPos(tab,line - 20)
	label:SetSize(button:GetWide(),20)
	label:SetText("Value")

	function button:DoClick()
		local p = self:GetParent()
		local ConVar = p.ConVarList.TextEntry:GetValue() or ""
		RunConsoleCommand(ConVar, string.Trim(p.ConVarValue:GetValue()))
	end
	//Save game stuff
	line = line + button:GetTall() + 30
	local tab = space
	local button = vgui.Create("gms_CommandButton",self)
	button:SetSize(self:GetWide() / 5, size)
	button:SetPos(tab, line)
	button:SetText("Save Game")

	local tab = tab + button:GetWide() + space

	self.SaveGameEntry = vgui.Create("TextEntry",self)
	self.SaveGameEntry:SetSize(button:GetWide(),button:GetTall())
	self.SaveGameEntry:SetPos(tab,line)

	local label = vgui.Create("Label",self)
	label:SetPos(tab,line - 20)
	label:SetSize(button:GetWide(),20)
	label:SetText("Save name")

	function button:DoClick()
		self:GetParent():SetVisible(false)
		RunConsoleCommand("gms_admin_savemap", self:GetParent().SaveGameEntry:GetValue())
	end

	//Load game stuff
	line = line + button:GetTall() + 30
	local tab = space
	local button = vgui.Create("gms_CommandButton",self)
	button:SetSize(self:GetWide() / 5, size)
	button:SetPos(tab, line)
	button:SetText("Load Game")

	local tab = tab + button:GetWide() + space

	local Dbutton = vgui.Create("gms_CommandButton",self)
	Dbutton:SetSize(self:GetWide() / 5, size)
	Dbutton:SetPos(tab, line)
	Dbutton:SetText("Delete")

	local tab = tab + button:GetWide() + space

	self.LoadGameEntry = vgui.Create("GMS_DropDown",self)
	self.LoadGameEntry:SetInitSize(button:GetWide(),button:GetTall())
	self.LoadGameEntry:SetPos(tab,line)

	local label = vgui.Create("Label",self)
	label:SetPos(tab,line - 20)
	label:SetSize(button:GetWide(),20)
	label:SetText("Load name")

	function button:DoClick()
		self:GetParent():SetVisible(false)
		local name = self:GetParent().LoadGameEntry:GetValue() or ""
		RunConsoleCommand("gms_admin_loadmap", name)
	end

	function Dbutton:DoClick()
		local name = self:GetParent().LoadGameEntry:GetValue() or ""
		RunConsoleCommand("gms_admin_deletemap", name)
	end

	//Spawn antlion barrow stuff
	line = line + button:GetTall() + 30
	local tab = space
	local button = vgui.Create("gms_CommandButton",self)
	button:SetSize(self:GetWide() / 5, size)
	button:SetPos(tab, line)
	button:SetText("Make antlion barrow")

	local tab = tab + button:GetWide() + space

	self.MaxAntlions = vgui.Create("DTextEntry",self)
	self.MaxAntlions:SetSize(button:GetWide(),button:GetTall())
	self.MaxAntlions:SetPos(tab,line)

	local label = vgui.Create("DLabel",self)
	label:SetPos(tab,line - 20)
	label:SetSize(button:GetWide(),20)
	label:SetText("Max antlions")

	function button:DoClick()
		RunConsoleCommand("gms_admin_MakeAntlionBarrow", string.Trim(self:GetParent().MaxAntlions:GetValue()))
	end


	//Static command buttons
	line = line + button:GetTall() + 10

	for cmd,txt in pairs(self.CmdButtons) do
		local button = vgui.Create("gms_CommandButton",self)
		button:SetSize(self:GetWide() / 5, size)
		button:SetPos(10, line)
		button:SetConCommand(cmd.."\n")
		button:SetText(txt)

		line = line + button:GetTall() + 10
	end
end

vgui.Register("GMS_AdminMenu",PANEL,"DFrame")

/*---------------------------------------------------------
  Loading bar
---------------------------------------------------------*/
local PANEL = {}

function PANEL:Init()
         self:SetSize(ScrW() / 2.7,ScrH() / 10)
         self:SetPos(ScrW() / 2 - (self:GetWide() / 2),ScrH() / 2 - (self:GetTall() / 2))
         
         self.Dots = "."
         self.Message = ""
end

function PANEL:Paint()
         //Background
         draw.RoundedBox(8,0,0,self:GetWide(),self:GetTall(),Color(100,100,100,150))

         //Text
         draw.SimpleText("Loading"..self.Dots, "ScoreboardHead",self:GetWide() / 2, self:GetTall() / 2,Color(255,255,255,255),1,1)
         draw.SimpleText(self.Text, "ScoreboardText",self:GetWide() / 2, self:GetTall() / 1.2,Color(255,255,255,255),1,1)
         return true
end

function PANEL:Show(msg)
         self.IsStopped = false
         
         self.Text = msg
         timer.Simple(0.5,self.UpdateDots,self)
         self:SetVisible(true)
end

function PANEL:Hide()
         self.IsStopped = true
         self:SetVisible(false)
end

function PANEL:UpdateDots()
         if self.IsStopped then return end

         if self.Dots == "...." then
            self.Dots = "."
         else
            self.Dots = self.Dots.."."
         end

         timer.Simple(0.5,self.UpdateDots,self)
end

vgui.Register("gms_LoadingBar",PANEL,"Panel")

/*---------------------------------------------------------
 Saving bar
---------------------------------------------------------*/
local PANEL = {}

function PANEL:Init()
         self:SetSize(ScrW() / 2.7,ScrH() / 10)
         self:SetPos(ScrW() / 2 - (self:GetWide() / 2),ScrH() / 2 - (self:GetTall() / 2))
         
         self.Dots = "."
         self.Message = ""
end

function PANEL:Paint()
         //Background
         draw.RoundedBox(8,0,0,self:GetWide(),self:GetTall(),Color(100,100,100,150))

         //Text
         draw.SimpleText("Saving"..self.Dots, "ScoreboardHead",self:GetWide() / 2, self:GetTall() / 2,Color(255,255,255,255),1,1)
         draw.SimpleText(self.Text, "ScoreboardText",self:GetWide() / 2, self:GetTall() / 1.2,Color(255,255,255,255),1,1)
         return true
end

function PANEL:Show(msg)
         self.IsStopped = false
         
         self.Text = msg
         timer.Simple(0.5,self.UpdateDots,self)
         self:SetVisible(true)
end

function PANEL:Hide()
         self.IsStopped = true
         self:SetVisible(false)
end

function PANEL:UpdateDots()
         if self.IsStopped then return end

         if self.Dots == "...." then
            self.Dots = "."
         else
            self.Dots = self.Dots.."."
         end

         timer.Simple(0.5,self.UpdateDots,self)
end

vgui.Register("gms_SavingBar",PANEL,"Panel")

/*---------------------------------------------------------
  Command button
---------------------------------------------------------*/
local PANEL = {}

function PANEL:Init()
end

function PANEL:DoClick()
    LocalPlayer():ConCommand(self.Command.."\n")
    surface.PlaySound(Sound("ui/buttonclickrelease.wav"))
end

function PANEL:SetConCommand(cmd)
	self.Command = cmd
end

function PANEL:OnCursorEntered()
    surface.PlaySound(Sound("ui/buttonrollover.wav"))
end
vgui.Register("gms_CommandButton",PANEL,"DButton")
/*---------------------------------------------------------
  Info Panel
---------------------------------------------------------*/
local PANEL = {}

function PANEL:Paint()
    local bordcol = StrandedBorderTheme
    surface.SetDrawColor(50,50,25,255)
    surface.DrawRect(0,0,self:GetWide(),self:GetTall())
    surface.SetDrawColor(bordcol.r,bordcol.g,bordcol.b,bordcol.a)
    surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
    return true
end
vgui.Register("GMS_InfoPanel",PANEL,"Panel")
/*---------------------------------------------------------
  Combination Window
---------------------------------------------------------*/
local PANEL = {}

function PANEL:Init()
    self:SetKeyboardInputEnabled(true)
    self:SetMouseInputEnabled(true)
	self:SetDeleteOnClose(false)
	self:MakePopup()
    self:SetPos(100,50)
    self:SetSize(ScrW() - 200, ScrH() - 100)
    local space = self:GetTall() / 30
    --Add bordered subwindows
    self.CombiList = vgui.Create("DPanel",self)
		self.CombiList:SetPos(self:GetWide() / 30,self:GetTall() / 20)
		local x,y = self.CombiList:GetPos()
		self.CombiList:SetSize(self:GetWide() - (self:GetWide() / 30) * 2, self:GetTall() / 1.5 - space - y)
    self.Info = vgui.Create("DPanel",self)
        self.Info:SetPos(self:GetWide() / 30, self:GetTall() / 1.5)
        local x2,y2 = self.Info:GetPos()
        self.Info:SetSize(self:GetWide() - (x2 * 2), self:GetTall() / 3 - space - y)
        self.Info:SetZPos(290)
    self.Info.NameLabel = vgui.Create("DLabel",self.Info)
        self.Info.NameLabel:SetPos(10,5)
        self.Info.NameLabel:SetSize(self.Info:GetWide(),20)
        self.Info.NameLabel:SetFont("ScoreboardSub")
    self.Info.DescLabel = vgui.Create("DLabel",self.Info)
        self.Info.DescLabel:SetName("GMS_TempLblName")
        self.Info.DescLabel:LoadControlsFromString([["GMS_TempLblName"{"GMS_TempLblName"{"wrap" "1"}}]])
        self.Info.DescLabel:SetPos(10,20)
        self.Info.DescLabel:SetSize(self.Info:GetWide(),self.Info:GetTall() - 20)
        self.Info.NameLabel:SetText("Select a recipe")
        self.Info.DescLabel:SetText("")
    local button = vgui.Create("gms_CommandButton",self)
        button:SetPos(self:GetWide() / 30,y2 + self.Info:GetTall() + 5)
        button:SetSize(self:GetWide() / 6, self:GetTall() / 17 - 10)
        button:SetText("Make")
    function button:DoClick()
        local p = self:GetParent()
        local combi = p.CombiGroupName or ""
        local active = p.ActiveCombi or ""
        LocalPlayer():ConCommand("gms_MakeCombination "..combi.." "..active.."\n")
    end
        --Make limits
    self.IconSize = 80
    self.Spacing = 10
    self.MaxLines = math.Round(self.CombiList:GetTall() / (self.IconSize + self.Spacing))
    self.MaxPerLine = math.Round(self.CombiList:GetWide() / (self.IconSize + self.Spacing))
    self.CombiPanels = {}
end

function PANEL:SetTable(str)
    self:SetTitle(str)
    self.CombiGroupName = str		 
    self.CombiGroup = GMS.Combinations[str]
    self:Clear()
    local line = self.Spacing
    local tab = self.Spacing
    local num = 0
	for name,tbl in pairs(self.CombiGroup) do
		local icon = vgui.Create("GMS_CombiIcon",self.CombiList)
        icon:SetPos(tab,line)
        icon:SetSize(self.IconSize,self.IconSize)
        icon:SetInfo(name,tbl)
        icon:SetZPos(400)
        table.insert(self.CombiPanels,icon)
        tab = tab + self.Spacing + icon:GetWide()
        num = num + 1
		if num >= self.MaxPerLine then
			tab = self.Spacing
            line = line + self.Spacing + self.IconSize
			num = 0
        end
	end
    self:ClearActive()
end

function PANEL:SetActive(combi,tbl)
    self.ActiveCombi = combi
    self.ActiveTable = tbl
    self.Info.NameLabel:SetText(tbl.Name)
    self.Info.DescLabel:SetText(tbl.Description)
end

function PANEL:ClearActive()
    self.ActiveCombi = nil
    self.ActiveTable = nil 
    self.Info.NameLabel:SetText("Select a recipe")
    self.Info.DescLabel:SetText("")
end

function PANEL:Clear()
    for k,v in pairs(self.CombiPanels) do
        v:Remove()
    end
	self.CombiPanels = {}
end
vgui.Register("GMS_CombinationWindow",PANEL,"DFrame")
/*---------------------------------------------------------
  Empty Combi Icon
---------------------------------------------------------*/
local PANEL = {}

function PANEL:Paint()
    local bordcol = StrandedBorderTheme
    surface.SetDrawColor(0,0,0,255)
    surface.DrawRect(0,0,self:GetWide(),self:GetTall())
	surface.SetDrawColor(bordcol.r,bordcol.g,bordcol.b,bordcol.a)
    surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
    return true
end

function PANEL:OnMousePressed(mc)
    if mc != 107 then return end
    surface.PlaySound(Sound("ui/buttonclickrelease.wav"))
    self:GetParent():GetParent():ClearActive()
end
vgui.Register("GMS_EmptyCombiIcon",PANEL,"DPanel")

/*---------------------------------------------------------
  Combi Icon
---------------------------------------------------------*/
local PANEL = {}
PANEL.TexID = surface.GetTextureID( "gui/gmod_logo" )

function PANEL:Paint()
    local bordcol = StrandedBorderTheme
    surface.SetDrawColor(200,200,200,255)
    surface.DrawRect(0,0,self:GetWide(),self:GetTall())
    surface.SetTexture(self.TexID)
    surface.DrawTexturedRect(0,5,self:GetWide(),self:GetTall())
    surface.SetDrawColor(bordcol.r,bordcol.g,bordcol.b,bordcol.a)
    surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
    local hasskill = true
    if self.CombiTable.SkillReq then
        for k,v in pairs(self.CombiTable.SkillReq) do
            if GetSkill(k) < v then
                hasskill = false
            end
        end
    end
    local hasres = true
    if self.CombiTable.Req then
        for k,v in pairs(self.CombiTable.Req) do
            if GetResource(k) < v then
                hasres = false
            end
        end
    end
	if !hasskill then
        surface.SetDrawColor(200,200,0,150)
        surface.DrawRect(0,0,self:GetWide(),self:GetTall())
    elseif !hasres then
        surface.SetDrawColor(200,0,0,100)
        surface.DrawRect(0,0,self:GetWide(),self:GetTall())
    end
    local x = self:GetWide()/2
    local y = self:GetTall()/2 
    draw.SimpleTextOutlined(self.CombiTable.Name,"DefaultSmall",x,y,Color(255,255,255,255),1,1,0.5,Color(100,100,100,140))		 
	return true
end

function PANEL:SetInfo(name,tbl)
    if tbl.Texture then 
		self.TexID = surface.GetTextureID( tbl.Texture ) 
	end
    self.Combi = name
    self.CombiTable = tbl
end

function PANEL:OnMousePressed(mc)
         if mc != 107 then return end
         surface.PlaySound(Sound("ui/buttonclickrelease.wav"))
         self:GetParent():GetParent():SetActive(self.Combi,self.CombiTable)
end

function PANEL:OnCursorEntered()
         for k,icon in pairs(self:GetParent():GetParent().CombiPanels) do
             icon:SetZPos(400)
         end
         
         self:SetZPos(410)
         self.BeingHovered = true
         surface.PlaySound(Sound("ui/buttonrollover.wav"))
end

function PANEL:OnCursorExited()
	self.BeingHovered = false
end

vgui.Register("GMS_CombiIcon", PANEL, "DPanel")

/* RESOURCE PACK GUI */

local PANEL = {}

function PANEL:Init()
	self.Text = ""
	self.Num = 0

	self.TakeX = vgui.Create("gms_takeButton", self)
	self.TakeAll = vgui.Create("gms_takeButton", self)
end

function PANEL:Paint()
	draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), Color(176, 176, 176, 255))
	draw.SimpleText(self.Text .. ": " .. self.Num, "DefaultBold", 5, self:GetTall() / 2 - 1, Color(255, 255, 255, 255), 0, 1)
end

function PANEL:SetRes(str, num)
	self.Text = str
	self.Num = num
	self.TakeX:SetRes(str, nil, false)
	self.TakeAll:SetRes(str, num, true)
end

function PANEL:PerformLayout()
	self.TakeAll:SetSize(64, self:GetTall())
	self.TakeAll:SetPos(self:GetWide() - 68, 0)
    
	self.TakeX:SetSize(64, self:GetTall())
	self.TakeX:SetPos(self:GetWide() - 136, 0)
end

vgui.Register("gms_resourceLine", PANEL, "Panel")

local PANEL = {}

function PANEL:Init()
	self.Text = ""
	self.Num = 0
	self.IsAll = false
	self:SetText("")
end

function PANEL:Paint()
	if (self:GetDisabled()) then
		draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(50, 50, 50, 255))
	elseif (self.Depressed || self:GetSelected()) then
		draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(50, 50, 176, 255))
	elseif (self.Hovered) then
		draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(100, 100, 255, 255))
	else
		draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(100, 100, 100, 255))
	end

	if (self.IsAll) then
		draw.SimpleText("Take All", "DefaultBold", self:GetWide() / 2, self:GetTall() / 2 - 1, Color(255, 255, 255, 255), 1, 1)
	else
		draw.SimpleText("Take X", "DefaultBold", self:GetWide() / 2, self:GetTall() / 2 - 1, Color(255, 255, 255, 255), 1, 1)
	end
end

function PANEL:DoClick()
	if (self.IsAll) then
		RunConsoleCommand("gms_TakeResources", string.gsub(self.Text, " ", "_"), self.Num)
	else
		local res = self.Text
		Derma_StringRequest("Please enter amount", "Please enter amount of " ..  res .. " to take.", "", function(text)
			RunConsoleCommand("gms_TakeResources", string.gsub(res, " ", "_"), text)
		end)
	end
	self:GetParent():GetParent():GetParent():GetParent():Remove()
end

function PANEL:SetRes(str, num, isAll)
	self.Text = str
	self.Num = num
	self.IsAll = isAll
end

vgui.Register("gms_takeButton", PANEL, "DButton")
