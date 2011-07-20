
/*---------------------------------------------------------
  DProp Spawn Menu
---------------------------------------------------------*/
local PANEL = { }
local ValueTable = {}
function PANEL:Init( )
	CategoryList = vgui.Create( "DPanelList", self)
	CategoryList:SetPos( 5,5 )
	CategoryList:SetSize(ScrW() / 2 - 32, ScrH() - 64)

	CategoryList:SetSpacing( 5 )
	CategoryList:EnableHorizontal( false )
	CategoryList:EnableVerticalScrollbar( true )
	CollapsibleCategoryTable = {}
	self.IconList = {}

	local iteration = 1
	for k,v in pairs( GMS_SpawnLists ) do
		ValueTable.iteration = k
		CollapsibleCategoryTable[k] = {}
		CollapsibleCategoryTable[k] = vgui.Create("DCollapsibleCategory", CategoryList)
		CollapsibleCategoryTable[k]:SetPos( 25,50*iteration )
		CollapsibleCategoryTable[k]:SetSize( ScrW() / 2 - 76, 50 )
		CollapsibleCategoryTable[k]:SetExpanded( 0 )
		CollapsibleCategoryTable[k]:SetLabel( k )
		iteration = iteration + 1
		self.IconList[k] = {}
		self.IconList[k] = vgui.Create( "DPanelList", CollapsibleCategoryTable[k] )
		self.IconList[k]:EnableVerticalScrollbar( true ) 
		self.IconList[k]:EnableHorizontal( true ) 
		self.IconList[k]:SetAutoSize( true )
		self.IconList[k]:SetSpacing( 5 )
		self.IconList[k]:SetPadding( 4 ) 
		self.IconList[k]:SetVisible( true )
		CollapsibleCategoryTable[k]:SetContents( self.IconList[k] )
		CategoryList:AddItem(CollapsibleCategoryTable[k])
		for key,value in pairs (v) do
		local Icon = vgui.Create( "SpawnIcon", self.IconList[k] )
		Icon:SetModel(value)
		Icon.DoClick = function( Icon ) RunConsoleCommand("gm_spawn", value, 0) end
		Icon:SetIconSize( 64 ) 
		Icon:InvalidateLayout( true ) 
		Icon:SetToolTip( Format( "%s", value ) ) 
		self.IconList[k]:AddItem( Icon )
		end
	end
end

function PANEL:PerformLayout( )
	self:StretchToParent( 2, 24, 2, 2 )
	for k,v in pairs (ValueTable) do
		self.IconList[v]:StretchToParent( 4, 26, 4, 4 ) 
		self.IconList[v]:InvalidateLayout() 
	end
end

vgui.Register( "stranded_PropSpawn", PANEL, "DPanel" )

/*---------------------------------------------------------
  DTool Menu
---------------------------------------------------------*/
local PANEL = {}

function PANEL:Init()
	CategoryList = vgui.Create( "DPanelList", self)
	CategoryList:SetPos( 5,5 )
	CategoryList:SetSize(ScrW() / 2 - 32, ScrH() - 64)
	CategoryList:SetSpacing( 5 )
	CategoryList:SetPadding( 0 )
	CategoryList:EnableHorizontal( true )
	CategoryList:EnableVerticalScrollbar( false )
	
	self.Tools = vgui.Create( "DPanelList" )
	CategoryList:AddItem( self.Tools )	
	self.Tools:EnableVerticalScrollbar( true )
	self.Tools:SetSize( CategoryList:GetWide()*.33, CategoryList:GetTall() )
	self.Tools:SetPos( 0, 0 )
	self.Tools:SetAutoSize( false )
	self.Tools:SetSpacing( 0 )
	self.Tools:SetPadding( 0 )

	self.ContextPanel = vgui.Create( "DPanelList" )
	CategoryList:AddItem( self.ContextPanel )	
	self.ContextPanel:SetSize( CategoryList:GetWide()*.66, CategoryList:GetTall() )
	self.ContextPanel:EnableVerticalScrollbar( false )
	self.ContextPanel:SetSpacing( 0 )
	self.ContextPanel:SetPadding( 5 )
  
	if ToolsLoad == false || ToolsLoad == nil || ToolsLoad == NULL || ToolsLoad == "" then
		AllTools = spawnmenu.GetTools()
		Msg("-==Tool Tables loaded successfully==-\n")
		local ToolsLoad = true
	end

	local ToolTables = AllTools

	if ToolTables then
		for k, v in pairs( ToolTables[1].Items ) do 
			if ( type( v ) == "table" ) then 	 
				local Name = v.ItemName 
				local Label = v.Text 
				v.ItemName = nil 
				v.Text = nil 
				self:AddCategory( Name, Label, v ) 
			end
		end
	else
		LocalPlayer():ChatPrint( "ERROR: Tools List could not be loaded." )
	end

end

function PANEL:AddCategory( Name, Label, ToolItems )
	
	self.Category = vgui.Create( "DCollapsibleCategory" ) 
	self.Tools:AddItem( self.Category )
 	self.Category:SetLabel( Label ) 
 	self.Category:SetCookieName( "ToolMenu."..tostring(Name) ) 
 	 
 	self.CategoryContent = vgui.Create( "DPanelList" ) 
 	self.CategoryContent:SetAutoSize( true ) 
 	self.CategoryContent:SetDrawBackground( false ) 
 	self.CategoryContent:SetSpacing( 0 ) 
 	self.CategoryContent:SetPadding( 0 ) 
 	self.Category:SetContents( self.CategoryContent ) 
	 	 
	local bAlt = true
	 
 	for k, v in pairs( ToolItems ) do 
		local prohibit = nil
		for p, q in pairs ( GMS.ProhibitedStools ) do
			if q == v.ItemName then
				prohibit = true
			end
		end
		
		if prohibit != true then
		
		local Item = vgui.Create( "ToolMenuButton", self ) 
		Item:SetText( v.Text ) 
		Item.OnSelect = function( button ) self:EnableControlPanel( button ) end 
		concommand.Add( Format( "tool_%s", v.ItemName ), function() Item:OnSelect() end ) 
		
		if ( v.SwitchConVar ) then 
			Item:AddCheckBox( v.SwitchConVar ) 
		end 

		Item.ControlPanelBuildFunction = v.CPanelFunction 
		Item.Command = v.Command 
		Item.Name = v.ItemName 
		Item.Controls = v.Controls 
		Item.Text = v.Text 

		Item:SetAlt( bAlt ) 
		bAlt = !bAlt 

		self.CategoryContent:AddItem( Item ) 
		end
 	end
end

function PANEL:EnableControlPanel( button ) 

	if ( self.LastSelected ) then 
		self.LastSelected:SetSelected( false )
	end 

	button:SetSelected( true ) 
	self.LastSelected = button 

	local cp = controlpanel.Get( button.Name ) 
	if ( !cp:GetInitialized() ) then 
		cp:FillViaTable( button ) 
	end 

	self.ContextPanel:Clear() 
	self.ContextPanel:AddItem( cp ) 
	self.ContextPanel:Rebuild() 

	g_ActiveControlPanel = cp 

	if ( button.Command ) then 
		LocalPlayer():ConCommand( button.Command ) 
	end 

end

function PANEL:PerformLayout( )
	self:StretchToParent( 2, 24, 2, 2 )
end

vgui.Register("stranded_ToolMenu",PANEL,"DPanel")

/*---------------------------------------------------------
  DSPP Menu
---------------------------------------------------------*/
local PANEL = {}

PANEL.ACommands = {}
PANEL.ACommands["SPropProtection_toggle"] = "Prop Protection On/Off"
PANEL.ACommands["SPropProtection_admin"] = "Admins Can Do Everything On/Off"
PANEL.ACommands["SPropProtection_use"] = "Use Protection On/Off"
PANEL.ACommands["SPropProtection_edmg"] = "Entity Damage Protection On/Off"
PANEL.ACommands["SPropProtection_pgr"] = "Physgun Reload Protection On/Off"
PANEL.ACommands["SPropProtection_awp"] = "Admins Can Touch World Props On/Off"
PANEL.ACommands["SPropProtection_dpd"] = "Disconnect Prop Deletion On/Off"
PANEL.ACommands["SPropProtection_dae"] = "Delete Admin Entities On/Off"

PANEL.Sliders = {};
PANEL.Sliders["SPropProtection_delay"] = "Deletion Delay in seconds"

PANEL.AButtons = {};

PANEL.PlCBoxes = {};

PANEL.pnlCanvas = nil;

PANEL.LastThink = CurTime();


function PANEL:Init()
	CreateClientConVar("SPropProtection_toggle", 1, false, true)
	CreateClientConVar("SPropProtection_admin", 1, false, true)
	CreateClientConVar("SPropProtection_use", 1, false, true)
	CreateClientConVar("SPropProtection_edmg", 1, false, true)
	CreateClientConVar("SPropProtection_pgr", 1, false, true)
	CreateClientConVar("SPropProtection_awp", 1, false, true)
	CreateClientConVar("SPropProtection_dpd", 1, false, true)
	CreateClientConVar("SPropProtection_dae", 0, false, true)
	CreateClientConVar("SPropProtection_delay", 120, false, true)
	self.pnlCanvas = vgui.Create( "DPanel", self)
	self.pnlCanvas:SetPos( 5,5 )
	self.pnlCanvas:SetSize(ScrW() / 2 - 32, 2000)--ScrH() - 104
	self.pnlCanvas.Paint = function()
		surface.SetDrawColor(50, 50, 50, 255)
		surface.DrawRect( 0, 0, self.pnlCanvas:GetWide(), self.pnlCanvas:GetTall() ) 
	end 
	
	self.VBar = vgui.Create("DVScrollBar", self);
	self.VBar:SetPos( (ScrW() / 2)  - 32, 25 ) 
	self.VBar:SetSize( 16,  ScrH() - 130 )
	self.VBar:SetUp( self.VBar:GetTall(), self.pnlCanvas:GetTall() ) 

	
	

	--self.pnlCanvas:SetSpacing( 0 )
	--self.pnlCanvas:EnableHorizontal( true )
	--self.pnlCanvas:EnableVerticalScrollbar( true )

	
	
	local line = 25
	local size = ScrH() / 35
	/*
	------------------------------------------------------------------------------------------------------Admin-----------------------------------------------------------------------------------------------------
	*/
	
	if(LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin())then
		for cmd,txt in pairs(self.ACommands) do
	        local cbox = vgui.Create("DCheckBoxLabel",self.pnlCanvas)
	        cbox:SetSize(self.pnlCanvas:GetWide() / 2, 100)
	        cbox:SetPos(self.pnlCanvas:GetWide() / 2, line)
	        cbox:SetConVar(cmd)
	        cbox:SetText(txt)
		cbox:SetValue(1);
	             
	        line = line + 30 + 10
	    end
		
		for cmd,txt in pairs(self.Sliders) do
	        local slider = vgui.Create("DNumSlider",self.pnlCanvas)
	        slider:SetSize(200, 100)
	        slider:SetPos(self.pnlCanvas:GetWide() / 2, line)
	        slider:SetConVar(cmd)
	        slider:SetText(txt)
			slider:SetValue(600);
			slider:SetMin(0);
			slider:SetMax(1200);
			slider:SetDecimals(0);
	             
	        line = line + 50 + 10
	    end
		--print("Line nach Admincheckboxen: " ..line);
		AplAdmin = vgui.Create("gms_CommandButton",self.pnlCanvas)
		AplAdmin:SetSize(self.pnlCanvas:GetWide() / 2.5, size)
		AplAdmin:SetPos(self.pnlCanvas:GetWide() / 2, line)
		AplAdmin:SetConCommand("SPropProtection_ApplyAdminSettings\n")
		AplAdmin:SetText("Apply Admin Settings");
		line = line + AplAdmin:GetTall() + 10
		
		RelAdmin = vgui.Create("gms_CommandButton",self.pnlCanvas)
		RelAdmin:SetSize(self.pnlCanvas:GetWide() / 4, size)
		RelAdmin:SetPos(self.pnlCanvas:GetWide() / 2, line)
		RelAdmin:SetConCommand("SPropProtection_AdminReload\n")
		RelAdmin:SetText("Reload Settings");
		line = line + RelAdmin:GetTall() + 10
		
		
		line = 25;
		
		for k, ply in pairs(player.GetAll()) do
			if(ply and ply:IsValid())then
				PANEL.AButtons[k] = vgui.Create("gms_CommandButton",self.pnlCanvas)
		        PANEL.AButtons[k]:SetSize(self.pnlCanvas:GetWide() / 3, size)
		        PANEL.AButtons[k]:SetPos(10, line)
		        PANEL.AButtons[k]:SetConCommand("SPropProtection_CleanupProps " ..ply:GetNWString("SPPSteamID") .."\n")
		        PANEL.AButtons[k]:SetText("Cleanup " ..ply:Nick())
				
		        line = line + PANEL.AButtons[k]:GetTall() + 10
			end
		end
		local a = table.getn(PANEL.AButtons)+1;
		PANEL.AButtons[a] = vgui.Create("gms_CommandButton",self.pnlCanvas)
		PANEL.AButtons[a]:SetSize(self.pnlCanvas:GetWide() / 3, size)
		PANEL.AButtons[a]:SetPos(10, line)
		PANEL.AButtons[a]:SetConCommand("SPropProtection_CleanupDisconnectedProps\n")
		PANEL.AButtons[a]:SetText("Cleanup Disconnected");
		line = line + PANEL.AButtons[a]:GetTall() + 10
		
		if(line<550)then
			line = 550;
		end
	end
	
	/*
	-----------------------------------------------------------------------------------------------------Client-----------------------------------------------------------------------------------------------------
	*/
	AplBuddy = vgui.Create("gms_CommandButton",self.pnlCanvas)
	AplBuddy:SetSize(self.pnlCanvas:GetWide() / 4, size)
	AplBuddy:SetPos(self.pnlCanvas:GetWide() / 2, 550)
	AplBuddy:SetConCommand("SPropProtection_ApplyBuddySettings\n")
	AplBuddy:SetText("Apply Settings");
	
	ClBuddy = vgui.Create("gms_CommandButton",self.pnlCanvas)
	ClBuddy:SetSize(self.pnlCanvas:GetWide() / 4, size)
	ClBuddy:SetPos(self.pnlCanvas:GetWide() / 2, 550 + AplBuddy:GetTall() + 10)
	ClBuddy:SetConCommand("SPropProtection_ClearBuddies\n")
	ClBuddy:SetText("Clear All Buddies");
	
	local Players = player.GetAll()

	for k, ply in pairs(Players) do
			if(ply and ply:IsValid() and ply != LocalPlayer()) then
				local BCommand = "SPropProtection_BuddyUp_"..ply:GetNWString("SPPSteamID")
				if(!LocalPlayer():GetInfo(BCommand)) then
					CreateClientConVar(BCommand, 0, false, true)
				end
			PANEL.PlCBoxes[k] = vgui.Create("DCheckBoxLabel",self.pnlCanvas)
	        PANEL.PlCBoxes[k]:SetSize(self.pnlCanvas:GetWide() / 4, size)
	        PANEL.PlCBoxes[k]:SetPos(10, line)
	        PANEL.PlCBoxes[k]:SetConVar(BCommand)
	        PANEL.PlCBoxes[k]:SetText(ply:Nick())
			PANEL.PlCBoxes[k]:SetValue(0);
			PANEL.PlCBoxes[k]:SizeToContents();
	             
	        line = line + 30 + 10
		end
	end
	

	

end

function PANEL:Think()
	if(CurTime() >= PANEL.LastThink+1)then
		PANEL.LastThink = CurTime()
		--print("SPP Menu Update");
		local line = 25
		local size = ScrH() / 30
		
	/*
	------------------------------------------------------------------------------------------------------Admin-----------------------------------------------------------------------------------------------------
	*/
		if(LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin())then
			for k, v in pairs(PANEL.AButtons) do
				PANEL.AButtons[k]:Remove()
				PANEL.AButtons[k] = nil;
			end
			
			for k, ply in pairs(player.GetAll()) do
				if(ply and ply:IsValid())then
					PANEL.AButtons[k] = vgui.Create("gms_CommandButton",self.pnlCanvas)
			        PANEL.AButtons[k]:SetSize(self.pnlCanvas:GetWide() / 3, size)
			        PANEL.AButtons[k]:SetPos(10, line)
			        PANEL.AButtons[k]:SetConCommand("SPropProtection_CleanupProps " ..ply:GetNWString("SPPSteamID") .."\n")
			        PANEL.AButtons[k]:SetText("Cleanup " ..ply:Nick())
					
			        line = line + PANEL.AButtons[k]:GetTall() + 10
				end
			end
			
			local a = table.getn(PANEL.AButtons)+1;
			PANEL.AButtons[a] = vgui.Create("gms_CommandButton",self.pnlCanvas)
			PANEL.AButtons[a]:SetSize(self.pnlCanvas:GetWide() / 3, size)
			PANEL.AButtons[a]:SetPos(10, line)
			PANEL.AButtons[a]:SetConCommand("SPropProtection_CleanupDisconnectedProps\n")
			PANEL.AButtons[a]:SetText("Cleanup Disconnected");
			line = line + PANEL.AButtons[a]:GetTall() + 10
			
			if(line < 550)then
				line = 550;
			end
		end
	/*
	------------------------------------------------------------------------------------------------------Client-----------------------------------------------------------------------------------------------------
	*/
		for k, v in pairs(PANEL.PlCBoxes)do
			PANEL.PlCBoxes[k]:Remove()
			PANEL.PlCBoxes[k] = nil;
		end
		
		for k, ply in pairs(player.GetAll()) do
			if(ply and ply:IsValid() and ply != LocalPlayer()) then
				local BCommand = "SPropProtection_BuddyUp_"..ply:GetNWString("SPPSteamID")
				if(!LocalPlayer():GetInfo(BCommand)) then
					CreateClientConVar(BCommand, 0, false, true)
				end
				PANEL.PlCBoxes[k] = vgui.Create("DCheckBoxLabel",self.pnlCanvas)
		        PANEL.PlCBoxes[k]:SetPos(10, line)
		        PANEL.PlCBoxes[k]:SetConVar(BCommand)
		        PANEL.PlCBoxes[k]:SetText(ply:Nick())
				PANEL.PlCBoxes[k]:SetValue(0);
				PANEL.PlCBoxes[k]:SizeToContents();
		             
		        line = line + 30 + 10
			end
		end
		
	end
	
end


function PANEL:PerformLayout( )
	self:StretchToParent( 2, 24, 2, 2 )
end

function PANEL:OnVScroll( iOffset ) 
	self.pnlCanvas:SetPos( 5, 5 + iOffset )
end 

function PANEL:OnMouseWheeled( dlta ) 
	if ( self.VBar ) then 
		return self.VBar:OnMouseWheeled( dlta ) 
	end
end 

vgui.Register("stranded_SPPMenu",PANEL,"DPanel")