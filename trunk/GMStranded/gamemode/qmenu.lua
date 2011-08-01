
/* DPropSpawnMenu */
local PANEL = {}

function PANEL:Init()
	self:SetSpacing(5)
	self:SetPadding(5)
	self:EnableHorizontal(false)
	self:EnableVerticalScrollbar(true)  
	function self:Paint()
		draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), Color(75, 75, 75))
	end

	for k, v in pairs(GMS_SpawnLists) do
		local cat = vgui.Create("DCollapsibleCategory", self)
		cat:SetExpanded(0)
		cat:SetLabel(k)

		local IconList = vgui.Create("DPanelList", cat)
		IconList:EnableVerticalScrollbar(true) 
		IconList:EnableHorizontal(true) 
		IconList:SetAutoSize(true)
		IconList:SetSpacing(5)
		IconList:SetPadding(5)

		cat:SetContents(IconList)
		self:AddItem(cat)

		for key, value in pairs(v) do
			local Icon = vgui.Create("SpawnIcon", IconList)
			Icon:SetModel(value)
			Icon.DoClick = function(Icon) RunConsoleCommand("gm_spawn", value, 0) end
			Icon:SetIconSize(64) 
			Icon:InvalidateLayout(true) 
			Icon:SetToolTip(Format("%s", value)) 
			IconList:AddItem(Icon)
		end
	end
end

vgui.Register("stranded_propspawn", PANEL, "DPanelList")

/* DToolMenu */
local PANEL = {}

function PANEL:Init()
	self.Tools = vgui.Create("DPanelList", self)
	self.Tools:EnableVerticalScrollbar(true)
	self.Tools:SetAutoSize(false)
	self.Tools:SetSpacing(5)
	self.Tools:SetPadding(5)

	self.ContextPanel = vgui.Create("DPanelList", self)
	self.ContextPanel:EnableVerticalScrollbar(false)
	self.ContextPanel:SetSpacing(0)
	self.ContextPanel:SetPadding(5)
  
	if (ToolsLoad == false || ToolsLoad == nil || ToolsLoad == NULL || ToolsLoad == "") then
		AllTools = spawnmenu.GetTools()
		Msg("-==Tool Tables loaded successfully==-\n")
		local ToolsLoad = true
	end

	local ToolTables = AllTools

	if (ToolTables) then
		for k, v in pairs(ToolTables[1].Items) do 
			if (type(v) == "table") then 	 
				local Name = v.ItemName 
				local Label = v.Text 
				v.ItemName = nil 
				v.Text = nil 
				self:AddCategory(Name, Label, v) 
			end
		end
	else
		LocalPlayer():ChatPrint("ERROR: Tools List could not be loaded.")
	end
end

function PANEL:AddCategory(Name, Label, ToolItems)
	self.Category = vgui.Create("DCollapsibleCategory") 
	self.Tools:AddItem(self.Category)
 	self.Category:SetLabel(Label) 
 	self.Category:SetCookieName("ToolMenu." .. tostring(Name)) 

 	self.CategoryContent = vgui.Create("DPanelList") 
 	self.CategoryContent:SetAutoSize(true) 
 	self.CategoryContent:SetDrawBackground(false) 
 	self.CategoryContent:SetSpacing(0) 
 	self.CategoryContent:SetPadding(0) 
 	self.Category:SetContents(self.CategoryContent) 

	local bAlt = true

 	for k, v in pairs(ToolItems) do 
		local prohibit = nil
		for p, q in pairs (GMS.ProhibitedStools) do
			if (q == v.ItemName) then
				prohibit = true
			end
		end

		if (prohibit != true) then
			local Item = vgui.Create("ToolMenuButton", self) 
			Item:SetText(v.Text) 
			Item.OnSelect = function(button) self:EnableControlPanel(button) end 
			concommand.Add(Format("tool_%s", v.ItemName), function() Item:OnSelect() end) 
			
			if (v.SwitchConVar) then 
				Item:AddCheckBox(v.SwitchConVar) 
			end 

			Item.ControlPanelBuildFunction = v.CPanelFunction 
			Item.Command = v.Command 
			Item.Name = v.ItemName 
			Item.Controls = v.Controls 
			Item.Text = v.Text 

			Item:SetAlt(bAlt) 
			bAlt = !bAlt 

			self.CategoryContent:AddItem(Item)
		end
 	end
end

function PANEL:EnableControlPanel(button) 
	if (self.LastSelected) then 
		self.LastSelected:SetSelected(false)
	end 

	button:SetSelected(true) 
	self.LastSelected = button 

	local cp = controlpanel.Get(button.Name) 
	if (!cp:GetInitialized()) then 
		cp:FillViaTable(button) 
	end 

	self.ContextPanel:Clear() 
	self.ContextPanel:AddItem(cp) 
	self.ContextPanel:Rebuild() 

	g_ActiveControlPanel = cp 

	if (button.Command) then 
		LocalPlayer():ConCommand(button.Command) 
	end 
end

function PANEL:Paint()
end

function PANEL:PerformLayout()
	self:StretchToParent(0, 21, 0, 5)
	self.Tools:SetPos(5, 5)
	self.Tools:SetSize(self:GetWide() * 0.35, self:GetTall() - 5)
	self.ContextPanel:SetPos(self:GetWide() * 0.35 + 10, 5)
	self.ContextPanel:SetSize(self:GetWide() - (self:GetWide() * 0.35) - 14, self:GetTall() - 5)
end

vgui.Register("stranded_toolmenu", PANEL, "DPanel")

/* DCommandsMenu */
local PANEL = {}

PANEL.SmallButs = {}
PANEL.SmallButs["Sleep"] = "gms_sleep"
PANEL.SmallButs["Wake up"] = "gms_wakeup"
PANEL.SmallButs["Drop weapon"] = "gms_dropweapon"
PANEL.SmallButs["Steal"] = "gms_steal"
PANEL.SmallButs["Make campfire"] = "gms_makefire"
PANEL.SmallButs["Drink bottle of water"] = "gms_drinkbottle"
PANEL.SmallButs["Take medicine"] = "gms_takemedicine"
PANEL.SmallButs["Combinations"] = "gms_combinations"
PANEL.SmallButs["Structures"] = "gms_structures"
PANEL.SmallButs["Help"] = "gms_help"
PANEL.SmallButs["Drop all resources"] = "gms_dropall"
PANEL.SmallButs["Salvage prop"] = "gms_salvage"
PANEL.SmallButs["Eat some berries"] = "gms_eatberry"

function checkAdmin()
	if (LocalPlayer():IsAdmin()) then 
		PANEL.SmallButs["Admin menu"] = "gms_admin"
	end
end

PANEL.BigButs = {}
PANEL.BigButs["Tribe: Create"] = "gms_tribemenu"
PANEL.BigButs["Tribe: Join"] = "gms_tribes"
PANEL.BigButs["Tribe: Leave"] = "gms_leave"
PANEL.BigButs["Save character"] = "gms_savecharacter"

PANEL.Plantables = {}
PANEL.Plantables["Plant Melon"] = "gms_plantmelon"
PANEL.Plantables["Plant Banana"] = "gms_plantbanana"
PANEL.Plantables["Plant Orange"] = "gms_plantorange"
PANEL.Plantables["Plant Tree"] = "gms_planttree"
PANEL.Plantables["Plant Grain"] = "gms_plantgrain"
PANEL.Plantables["Plant BerryBush"] = "gms_plantbush"

function PANEL:Init()
	checkAdmin()

	self.SmallButtons = vgui.Create("DPanelList", self)
	self.SmallButtons:EnableVerticalScrollbar(true)
	self.SmallButtons:SetSpacing(5)
	self.SmallButtons:SetPadding(5)

	self.BigButtons = vgui.Create("DPanelList", self)
	self.BigButtons:EnableVerticalScrollbar(false)
	self.BigButtons:SetAutoSize(false)
	self.BigButtons:SetSpacing(5)
	self.BigButtons:SetPadding(5)
	
	self.Planting = vgui.Create("DPanelList", self)
	self.Planting:EnableVerticalScrollbar(false)
	self.Planting:SetSpacing(5)
	self.Planting:SetPadding(5)
	
	for txt, cmd in SortedPairs(self.SmallButs) do
        local button = vgui.Create("gms_CommandButton")
        button:SetConCommand(cmd)
        button:SetText(txt)
		self.SmallButtons:AddItem(button)
    end
	
	for txt, cmd in SortedPairs(self.BigButs) do
        local button = vgui.Create("gms_CommandButton")
		button:SetSize(self.BigButtons:GetWide() - 10, 70)
        button:SetConCommand(cmd)
        button:SetText(txt)
		self.BigButtons:AddItem(button)
    end
	
	for txt, cmd in SortedPairs(self.Plantables) do
        local button = vgui.Create("gms_CommandButton")
        button:SetConCommand(cmd)
        button:SetText(txt)
		self.Planting:AddItem(button)
    end
end

function PANEL:Paint()
end

function PANEL:PerformLayout()
	self:StretchToParent(0, 21, 0, 5)
	self.SmallButtons:SetPos(5, 5)
	self.SmallButtons:SetSize(self:GetWide() * 0.45, self:GetTall() - 5)

	self.BigButtons:SetPos(self:GetWide() * 0.45 + 10, 5)
	self.BigButtons:SetSize(self:GetWide() - (self:GetWide() * 0.45) - 14, self:GetTall() / 2 - 5)

	self.Planting:SetPos(self:GetWide() * 0.45 + 10, self:GetTall() / 2 + 5)
	self.Planting:SetSize(self:GetWide() - (self:GetWide() * 0.45) - 14, self:GetTall() / 2 - 5)
end

vgui.Register("stranded_commands", PANEL, "DPanel")

/* DSPP Menu */
local PANEL = {}

PANEL.LastThink = CurTime()
PANEL.Settings = {
	{Label = "Prop protection enabled", VGui = "DCheckBoxLabel", Command = "SPropProtection_toggle"},
	{Label = "Admins can do everything", VGui = "DCheckBoxLabel", Command = "SPropProtection_admin"},
	{Label = "Use key protection", VGui = "DCheckBoxLabel", Command = "SPropProtection_use"},
	{Label = "Entity damage protection", VGui = "DCheckBoxLabel", Command = "SPropProtection_edmg"},
	{Label = "Physgun reload protection", VGui = "DCheckBoxLabel", Command = "SPropProtection_pgr"},
	{Label = "Admins can touch world props", VGui = "DCheckBoxLabel", Command = "SPropProtection_awp"},
	{Label = "Disconnect prop deletion", VGui = "DCheckBoxLabel", Command = "SPropProtection_dpd"},
	{Label = "Delete admin entities", VGui = "DCheckBoxLabel", Command = "SPropProtection_dae"},
	{Label = "Deletion delay in seconds", VGui = "DNumSlider", Command = "SPropProtection_delay", Min = 10, Max = 600},
	{Label = "Apply settings", VGui = "DButton", Command = "SPropProtection_ApplyAdminSettings"},
	{Label = "Reload settings", VGui = "DButton", Command = "SPropProtection_ReloadAdminSettings"}
}

function PANEL:Init()
	if (!LocalPlayer():IsAdmin()) then
		self.Settings = {
			{Label = "You are not an admin.", VGui = "DLabel"}
		}
	end

	self.Buddies = vgui.Create("DPanelList", self)
	self.Buddies:EnableVerticalScrollbar(true)
	self.Buddies:SetSpacing(5)
	self.Buddies:SetPadding(5)

	self.AdminSettings = vgui.Create("DPanelList", self)
	self.AdminSettings:EnableVerticalScrollbar(true)
	self.AdminSettings:SetSpacing(5)
	self.AdminSettings:SetPadding(5)

	self.AdminCleanUp = vgui.Create("DPanelList", self)
	self.AdminCleanUp:EnableVerticalScrollbar(true)
	self.AdminCleanUp:SetSpacing(5)
	self.AdminCleanUp:SetPadding(5)

	/* Admin settings */
	for txt, t in pairs(self.Settings) do
		local item = vgui.Create(t.VGui)
		if (t.VGui == "DButton") then item:SetConsoleCommand(t.Command) elseif (t.VGui != "DLabel") then item:SetConVar(t.Command) end
		if (t.VGui == "DNumSlider") then item:SetMin(t.Min) item:SetMax(t.Max) end
		item:SetText(t.Label)
		self.AdminSettings:AddItem(item)
	end

	/* Admin cleanup */
	for i, p in pairs(player.GetAll()) do
		local item = vgui.Create("DButton")
		item:SetConsoleCommand("SPropProtection_CleanupProps", p:GetNWString("SPPSteamID"))
		item:SetText(p:Name())
		self.AdminCleanUp:AddItem(item)
	end

	local item = vgui.Create("DButton")
	item:SetConsoleCommand("SPropProtection_CleanupDisconnectedProps")
	item:SetText("Cleanup disconnected players props")
	self.AdminCleanUp:AddItem(item)
    
	/* Client */
	for i, p in pairs(player.GetAll()) do
		if (p != LocalPlayer()) then
			local item = vgui.Create("DCheckBoxLabel")

			local BCommand = "SPropProtection_BuddyUp_" .. p:GetNWString("SPPSteamID")
			if (!LocalPlayer():GetInfo(BCommand)) then CreateClientConVar(BCommand, 0, false, true) end
			item:SetConVar(BCommand)
			item:SetText(p:Name())
			self.Buddies:AddItem(item)
		end
    end

	local item = vgui.Create("DButton")
	item:SetConsoleCommand("SPropProtection_ApplyBuddySettings")
	item:SetText("Apply settings")
	self.Buddies:AddItem(item)
    
	local item = vgui.Create("DButton")
	item:SetConsoleCommand("SPropProtection_ClearBuddies")
	item:SetText("Clear all buddies")
	self.Buddies:AddItem(item)
end

function PANEL:Paint()
end

function PANEL:Think()
	if (CurTime() >= self.LastThink + 3)then
		self.LastThink = CurTime()
		self.AdminCleanUp:Clear(true)
		self.Buddies:Clear(true)
		
		/* Admin cleanup */
		if (LocalPlayer():IsAdmin()) then
			for i, p in pairs(player.GetAll()) do
				local item = vgui.Create("DButton")
				item:SetConsoleCommand("SPropProtection_CleanupProps", p:GetNWString("SPPSteamID"))
				item:SetText(p:Name())
				self.AdminCleanUp:AddItem(item)
			end

			local item = vgui.Create("DButton")
			item:SetConsoleCommand("SPropProtection_CleanupDisconnectedProps")
			item:SetText("Cleanup disconnected players props")
			self.AdminCleanUp:AddItem(item)
		else
			local item = vgui.Create("DLabel")
			item:SetText("You are not an admin.")
			self.AdminCleanUp:AddItem(item)
		end
		
		/* Client */
		for i, p in pairs(player.GetAll()) do
			if (p != LocalPlayer()) then
				local item = vgui.Create("DCheckBoxLabel")

				local BCommand = "SPropProtection_BuddyUp_" .. p:GetNWString("SPPSteamID")
				if (!LocalPlayer():GetInfo(BCommand)) then CreateClientConVar(BCommand, 0, false, true) end
				item:SetConVar(BCommand)
				item:SetText(p:Name())
				self.Buddies:AddItem(item)
			end
		end
		
		local item = vgui.Create("DButton")
		item:SetConsoleCommand("SPropProtection_ApplyBuddySettings")
		item:SetText("Apply settings")
		self.Buddies:AddItem(item)
		
		local item = vgui.Create("DButton")
		item:SetConsoleCommand("SPropProtection_ClearBuddies")
		item:SetText("Clear all buddies")
		self.Buddies:AddItem(item)
	end
end

function PANEL:PerformLayout()
	self:StretchToParent(0, 21, 0, 5)

	self.Buddies:SetPos(5, 5)
	self.Buddies:SetSize(self:GetWide() * 0.45, self:GetTall() - 5)

	self.AdminSettings:SetPos(self:GetWide() * 0.45 + 10, 5)
	self.AdminSettings:SetSize(self:GetWide() - (self:GetWide() * 0.45) - 14, self:GetTall() / 2 - 5)

	self.AdminCleanUp:SetPos(self:GetWide() * 0.45 + 10, self:GetTall() / 2 + 5)
	self.AdminCleanUp:SetSize(self:GetWide() - (self:GetWide() * 0.45) - 14, self:GetTall() / 2 - 5)
end

vgui.Register("stranded_sppmenu", PANEL, "DPanel")

/* Spawnpanel */
local PANEL = {}

function PANEL:Init()
	self:SetTitle("")
	self:ShowCloseButton(false)
	
	self.ContentPanel = vgui.Create("DPropertySheet", self)
	self.ContentPanel:AddSheet("Props", vgui.Create("stranded_propspawn", self.ContentPanel), "gui/silkicons/brick_add", false, false)
	self.ContentPanel:AddSheet("Tools", vgui.Create("stranded_toolmenu", self.ContentPanel), "gui/silkicons/wrench", true, true)
	self.ContentPanel:AddSheet("Commands", vgui.Create("stranded_commands", self.ContentPanel), "gui/silkicons/application", true, true)
	self.ContentPanel:AddSheet("Prop Protection", vgui.Create("stranded_sppmenu", self.ContentPanel), "gui/silkicons/shield", true, true)
end

function PANEL:Paint()
end

function PANEL:PerformLayout()
	self:SetSize(ScrW() / 2 - 10, ScrH() - 10)
	self:SetPos(ScrW() / 2 + 5, 5)
	self.ContentPanel:StretchToParent(0, 0, 0, 0)
	
	DFrame.PerformLayout(self)
end

vgui.Register("gms_menu", PANEL, "DFrame")

/* Spawn menu override */
function GM:OnSpawnMenuOpen()
	if (LocalPlayer():GetNWString("AFK") != 1) then
		if (GAMEMODE.MENU == nil or not GAMEMODE.MENU:IsValid()) then
			GAMEMODE.MENU = vgui.Create("gms_menu")
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
