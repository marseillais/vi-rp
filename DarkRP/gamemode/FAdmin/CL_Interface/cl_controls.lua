FAdmin.PlayerIcon = {}
FAdmin.PlayerIcon.RightClickOptions = {}

function FAdmin.PlayerIcon.AddRightClickOption(name, func)
	FAdmin.PlayerIcon.RightClickOptions[name] = func
end

-- FAdminPanelList
local PANEL = {}

function PANEL:SizeToContents()
	local w, h = self.pnlCanvas:GetSize()
	
	w = math.Clamp(w, ScrW()*0.9, ScrW()*0.9) -- Fix size of w to have the same size as the scoreboard
	h = math.Min(h, ScrH()*0.95)
	if #self.Items == 1 then -- It fucks up when there's only one icon in
		h = math.Max(y or 0, 120)
	end
	
	self:SetSize(w, h)
	self:PerformLayout()
end

function PANEL:Paint()
end

derma.DefineControl("FAdminPanelList", "DPanellist adapted for FAdmin", PANEL, "DPanelList")

-- FAdminPlayerCatagoryHeader
local PANEL2 = {}

function PANEL2:ApplySchemeSettings()
	self:SetFont("Trebuchet24")
end



derma.DefineControl("FAdminPlayerCatagoryHeader", "DCatagoryCollapse header adapted for FAdmin", PANEL2, "DCategoryHeader")

-- FAdminPlayerCatagory
local PANEL3 = {}

function PANEL3:Init()
	if self.Header then
		self.Header:Remove() -- the old header is still there don't ask me why
	end
	self.Header = vgui.Create("FAdminPlayerCatagoryHeader", self)
	self.Header:SetTall(25)
	self:SetPadding(5)
	
	self:SetExpanded(true)
	self:SetMouseInputEnabled(true)
	
	self:SetAnimTime(0.2)
	self.animSlide = Derma_Anim("Anim", self, self.AnimSlide)
	
	self:SetDrawBackground(true)

end

function PANEL3:Paint()
	if self.CatagoryColor then
		//self.Header:SetBGColor(self.CatagoryColor)
		draw.RoundedBox(4, 0, 0, self:GetWide(), self.Header:GetTall(), self.CatagoryColor)
	end
end

derma.DefineControl("FAdminPlayerCatagory", "DCatagoryCollapse adapted for FAdmin", PANEL3, "DCollapsibleCategory")


-- FAdminPlayerIcon
local PANEL4 = {}

function PANEL4:Init()
	self:SetSize(96, 116)
	self.Icon = vgui.Create("SpawnIcon", self)
	self.Icon:SetMouseInputEnabled(false)
	self.Icon:SetKeyboardInputEnabled(false)
	
	
	self.animPress = Derma_Anim("Press", self.Icon, self.Icon.PressedAnim)
	self.Icon:SetIconSize(96)
	self.NameLabel = vgui.Create("DLabel", self)
	self.NameLabel:SetText("PlayerName")
	self.NameLabel:SetTextColor(Color(255, 255, 255, 250))
	self.NameLabel:SetMouseInputEnabled(false)
end

function PANEL4:PerformLayout()
	self.Icon:SetIconSize(94)
	self.NameLabel:SetPos(10, self:GetTall() - self.NameLabel:GetTall())
	self.NameLabel:SetWide(self:GetWide() - 20)
	self.NameLabel:SetContentAlignment(5)
	self.NameLabel:SetZPos(100)
	
	local size = self:GetTall() - self.NameLabel:GetTall()
	self.Icon:SetSize(self:GetWide()-2, self:GetTall()-2)
	self.Icon:SetPos(1, 1)

end

function PANEL4:OnMousePressed(mcode)

	if (mcode == MOUSE_LEFT) then
		self:DoClick()
		self.animPress:Start(0.2)
	end
	
	if (mcode == MOUSE_RIGHT) then
		self:OpenMenu()
	end

end

function PANEL4:DoClick(mcode)
end

function PANEL4:OnCursorEntered()
	self:SetSize(96, 116)
	self.PaintOverOld = self.PaintOver
	self.PaintOver = self.PaintOverHovered
end

function PANEL4:OnCursorExited()
	if (self.PaintOver == self.PaintOverHovered) then
		self.PaintOver = self.PaintOverOld
	end
end

function PANEL4:Think()
	self.animPress:Run()
end

function PANEL4:PaintOverHovered()
	self.Icon:PaintOverHovered()
	surface.SetDrawColor(255, 155, 20, 255)
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
	self.Icon:PaintManual()
	self.NameLabel:PaintManual()
end


function PANEL4:Paint()
	surface.SetDrawColor(255, 255, 255, 50)
	
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
end

function PANEL4:SetPlayer(ply)
	self.Player = ply
	self.NameLabel:SetText(ply:Nick())
	self.Icon:SetModel(ply:GetModel() or "models/player/Kleiner.mdl", ply:GetSkin())
	self:SetToolTip(ply:Nick())
end

function PANEL4:OpenMenu()
	if table.Count(FAdmin.PlayerIcon.RightClickOptions) < 1 then return end
	local menu = DermaMenu()
	
	menu:SetPos(gui.MouseX(), gui.MouseY())
	
	for Name, func in pairs(FAdmin.PlayerIcon.RightClickOptions) do
		menu:AddOption(Name, function() func(self.Player, self) end)
	end
	
	menu:Open()
end
derma.DefineControl("FAdminPlayerIcon", "Icon for Player in scoreboard", PANEL4, "Panel")

-- FAdmin player row (from the sandbox player row)
PANEL = {}

CreateClientConVar("FAdmin_PlayerRowSize", 30, true, false)
function PANEL:Init()
	self.Size = GetConVarNumber("FAdmin_PlayerRowSize")
	
	self.lblName 	= vgui.Create("Label", self)
	self.lblFrags 	= vgui.Create("Label", self)
	self.lblTeam	= vgui.Create("Label", self)
	self.lblDeaths 	= vgui.Create("Label", self)
	self.lblPing 	= vgui.Create("Label", self)
	
	// If you don't do this it'll block your clicks
	self.lblName:SetMouseInputEnabled(false)
	self.lblTeam:SetMouseInputEnabled(false)
	self.lblFrags:SetMouseInputEnabled(false)
	self.lblDeaths:SetMouseInputEnabled(false)
	self.lblPing:SetMouseInputEnabled(false)
	
	self.imgAvatar = vgui.Create("AvatarImage", self)
	
	self:SetCursor("hand")
end

function PANEL:Paint()
	if not ValidEntity(self.Player) then return end
	
	self.Size = GetConVarNumber("FAdmin_PlayerRowSize")
	self.imgAvatar:SetSize(self.Size - 4, self.Size - 4)
	
	local color = Color(100, 150, 245, 255)

	
	if GAMEMODE.Name == "Sandbox" then
		color = Color(100, 150, 245, 255)
		if self.Player:Team() == TEAM_CONNECTING then
			color = Color(200, 120, 50, 255)
		elseif self.Player:IsAdmin() then
			color = Color(30, 200, 50, 255)
		end

		if self.Player:GetFriendStatus() == "friend" then
			color = Color(236, 181, 113, 255)	
		end
	else
		color = team.GetColor(self.Player:Team())
	end
	
	local hooks = hook.GetTable().FAdmin_PlayerRowColour
	if hooks then
		for k,v in pairs(hooks) do
			color = (v and v(self.Player, color)) or color
			break
		end
	end
	
	draw.RoundedBox(4, 0, 0, self:GetWide(), self.Size, color)
	
	surface.SetTexture(texGradient)
	if self.Player == LocalPlayer() or self.Player:GetFriendStatus() == "friend" then
		surface.SetDrawColor(255, 255, 255, 50 + math.sin(RealTime() * 2) * 50)
	end
	surface.DrawTexturedRect(0, 0, self:GetWide(), self.Size) 	
	return true
end

function PANEL:SetPlayer(ply)
	self.Player = ply
	
	self.imgAvatar:SetPlayer(ply)
	
	self:UpdatePlayerData()
end

function PANEL:UpdatePlayerData()
	if not self.Player then return end
	if not self.Player:IsValid() then return end

	self.lblName:SetText(self.Player:Nick())
	self.lblTeam:SetText((self.Player.DarkRPVars and self.Player.DarkRPVars.job) or team.GetName(self.Player:Team()))
	self.lblTeam:SizeToContents()
	self.lblFrags:SetText(self.Player:Frags())
	self.lblDeaths:SetText(self.Player:Deaths())
	self.lblPing:SetText(self.Player:Ping())
end

function PANEL:ApplySchemeSettings()
	self.lblName:SetFont("ScoreboardPlayerNameBig")
	self.lblTeam:SetFont("ScoreboardPlayerNameBig")
	self.lblFrags:SetFont("ScoreboardPlayerName")
	self.lblDeaths:SetFont("ScoreboardPlayerName")
	self.lblPing:SetFont("ScoreboardPlayerName")
	
	self.lblName:SetFGColor(color_white)
	self.lblTeam:SetFGColor(color_white)
	self.lblFrags:SetFGColor(color_white)
	self.lblDeaths:SetFGColor(color_white)
	self.lblPing:SetFGColor(color_white)
end

function PANEL:DoClick(x, y)
	if not ValidEntity(self.Player) then self:Remove() return end
	FAdmin.ScoreBoard.ChangeView("Player", self.Player)
end

function PANEL:DoRightClick()
	if table.Count(FAdmin.PlayerIcon.RightClickOptions) < 1 then return end
	local menu = DermaMenu()
	
	menu:SetPos(gui.MouseX(), gui.MouseY())
	
	for Name, func in pairs(FAdmin.PlayerIcon.RightClickOptions) do
		menu:AddOption(Name, function() func(self.Player, self) end)
	end
	
	menu:Open()
end

function PANEL:Think()
	if not self.PlayerUpdate or self.PlayerUpdate < CurTime() then
		self.PlayerUpdate = CurTime() + 0.5
		self:UpdatePlayerData()
	end
end

function PANEL:PerformLayout()
	self.imgAvatar:SetPos(2, 2)
	self.imgAvatar:SetSize(32, 32)

	self:SetSize(self:GetWide(), self.Size)
	
	self.lblName:SizeToContents()
	self.lblName:SetPos(24, 2)
	self.lblName:MoveRightOf(self.imgAvatar, 8)
	
	local COLUMN_SIZE = 75
	
	self.lblPing:SetPos(self:GetWide() - COLUMN_SIZE * 0.4, 0)
	self.lblDeaths:SetPos(self:GetWide() - COLUMN_SIZE * 1.4, 0)
	self.lblFrags:SetPos(self:GetWide() - COLUMN_SIZE * 2.4, 0)
	
	self.lblTeam:SetPos(self:GetWide() / 2 - (0.5*self.lblTeam:GetWide()))
end
vgui.Register("FadminPlayerRow", PANEL, "Button")

-- FAdminActionButton
local PANEL6 = {}

function PANEL6:Init()
	self:SetDrawBackground(false)
	self:SetDrawBorder(false)
	self:SetStretchToFit(false)
	self:SetSize(120, 40)
	
	self.TextLabel = vgui.Create("DLabel", self)
	self.TextLabel:SetFont("ChatFont")
	
	self.m_Image2 = vgui.Create("DImage", self)
	
	self.BorderColor = Color(190,40,0,255)
end

function PANEL6:SetText(text)
	self.TextLabel:SetText(text)
	self.TextLabel:SizeToContents()

	self:SetWide(self.TextLabel:GetWide() + 44)
end

function PANEL6:PerformLayout()
	self.m_Image:SetSize(32,32)
	self.m_Image:SetPos(4,4)
	
	self.m_Image2:SetSize(32, 32)
	self.m_Image2:SetPos(4,4)
	
	self.TextLabel:SetPos(38, 8)
end

function PANEL6:SetImage2(Mat, bckp)
	self.m_Image2:SetImage(Mat, bckp)
end

function PANEL6:SetBorderColor(Col)
	self.BorderColor = Col or Color(190,40,0,255)
end

function PANEL6:Paint()
	local BorderColor = self.BorderColor
	if self.Hovered then
		BorderColor = Color(math.Min(BorderColor.r + 40, 255), math.Min(BorderColor.g + 40, 255), math.Min(BorderColor.b + 40, 255), BorderColor.a)
	end
	if self.Depressed then
		BorderColor = Color(0,0,0,0)
	end
	draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), BorderColor)
	draw.RoundedBox(4, 2, 2, self:GetWide()-4, self:GetTall()-4, Color(40,40,40,255))
end

function PANEL6:OnMousePressed(mouse)
	self.m_Image:SetSize(24,24)
	self.m_Image:SetPos(8,8)
	self.Depressed = true
end

function PANEL6:OnMouseReleased(mouse)
	self.m_Image:SetSize(32,32)
	self.m_Image:SetPos(4,4)
	self.Depressed = false
	self:DoClick()
end

derma.DefineControl("FAdminActionButton", "Button for doing actions", PANEL6, "DImageButton")