local LAYOUT = CreateClientConVar("FAdmin_ScoreBoardLayout", 1, true, false)

local Sorted, SortDown = CreateClientConVar("FAdmin_SortPlayerList", "Team", true), CreateClientConVar("FAdmin_SortPlayerListDown", 1, true)
function FAdmin.ScoreBoard.Main.Show()
	local ScreenWidth, ScreenHeight = ScrW(), ScrH()
	
	FAdmin.ScoreBoard.X = ScreenWidth*0.05
	FAdmin.ScoreBoard.Y = ScreenHeight*0.025
	FAdmin.ScoreBoard.Width = ScreenWidth*0.9
	FAdmin.ScoreBoard.Height = ScreenHeight*0.95
	
	FAdmin.ScoreBoard.ChangeView("Main")
	
	FAdmin.ScoreBoard.Main.Controls.FAdminPanelList = FAdmin.ScoreBoard.Main.Controls.FAdminPanelList or vgui.Create("FAdminPanelList")
	FAdmin.ScoreBoard.Main.Controls.FAdminPanelList:EnableVerticalScrollbar(true)
	FAdmin.ScoreBoard.Main.Controls.FAdminPanelList:SetSpacing(3)
	FAdmin.ScoreBoard.Main.Controls.FAdminPanelList:SetVisible(true)
	FAdmin.ScoreBoard.Main.Controls.FAdminPanelList:Clear(true)
	
	local ResetScoreboard
	
	local IconView = vgui.Create("DImageButton")
	IconView:SetMaterial("FAdmin/IconView")
	IconView:SetPos(FAdmin.ScoreBoard.X + FAdmin.ScoreBoard.Height/8, FAdmin.ScoreBoard.Y + 90)
	IconView:SetSize(24,24)
	function IconView:DoClick()
		RunConsoleCommand("FAdmin_ScoreBoardLayout", "1")
	end
	table.insert(FAdmin.ScoreBoard.Main.Controls, IconView)
	
	local ListView = vgui.Create("DImageButton")
	ListView:SetMaterial("FAdmin/ListView")
	ListView:SetPos(FAdmin.ScoreBoard.X + FAdmin.ScoreBoard.Height/8 + 25, FAdmin.ScoreBoard.Y + 90)
	ListView:SetSize(24,24)
	function ListView:DoClick()
		RunConsoleCommand("FAdmin_ScoreBoardLayout", "0")
	end
	table.insert(FAdmin.ScoreBoard.Main.Controls, ListView)
	
	cvars.AddChangeCallback("FAdmin_ScoreBoardLayout", function() ResetScoreboard() end)
	
	local Sort = {}
	ResetScoreboard = function()
		FAdmin.ScoreBoard.Main.Controls.FAdminPanelList:Clear(true)
		if tobool(GetConVarNumber("FAdmin_ScoreBoardLayout")) then
			for k,v in pairs(Sort) do
				if ValidPanel(v) then v:SetVisible(false) end
				if ValidPanel(v.BtnSort) then v.BtnSort:SetVisible(false) end
			end
			FAdmin.ScoreBoard.Main.Controls.FAdminPanelList:SetPos(FAdmin.ScoreBoard.X+20, FAdmin.ScoreBoard.Y + 90 + 30)
			FAdmin.ScoreBoard.Main.Controls.FAdminPanelList:SetSize(FAdmin.ScoreBoard.Width - 40, FAdmin.ScoreBoard.Height - 90 - 30 - 20)
			
			FAdmin.ScoreBoard.Main.Controls.FAdminPanelList:EnableHorizontal(true)
			FAdmin.ScoreBoard.Main.PlayerIconView()
		else
			FAdmin.ScoreBoard.Main.Controls.FAdminPanelList:SetPos(FAdmin.ScoreBoard.X + 20, FAdmin.ScoreBoard.Y + 90 + 30 + 20)
			FAdmin.ScoreBoard.Main.Controls.FAdminPanelList:SetSize(FAdmin.ScoreBoard.Width - 40, FAdmin.ScoreBoard.Height - 90 - 30 - 20 - 20)
			
			Sort = {}
			
			Sort.Name = Sort.Name or vgui.Create("DLabel")
			Sort.Name:SetText("Sort by:     Name")
			Sort.Name:SetPos(FAdmin.ScoreBoard.X + 20, FAdmin.ScoreBoard.Y + 90 + 30)
			Sort.Name.Type = "Name"
			Sort.Name:SetVisible(true)
			
			Sort.Team = Sort.Team or vgui.Create("DLabel")
			Sort.Team:SetText("Team")
			Sort.Team:SetPos(ScreenWidth * 0.5 - 30, FAdmin.ScoreBoard.Y + 90 + 30)
			Sort.Team.Type = "Team"
			Sort.Team:SetVisible(true)
			
			Sort.Frags = Sort.Frags or vgui.Create("DLabel")
			Sort.Frags:SetText("Kills")
			Sort.Frags:SetPos(FAdmin.ScoreBoard.X + FAdmin.ScoreBoard.Main.Controls.FAdminPanelList:GetWide() - 200,  FAdmin.ScoreBoard.Y + 90 + 30)
			Sort.Frags.Type = "Frags"
			Sort.Frags:SetVisible(true)
			
			Sort.Deaths = Sort.Deaths or vgui.Create("DLabel")
			Sort.Deaths:SetText("Deaths")
			Sort.Deaths:SetPos(FAdmin.ScoreBoard.X + FAdmin.ScoreBoard.Main.Controls.FAdminPanelList:GetWide() - 140, FAdmin.ScoreBoard.Y + 90 + 30)
			Sort.Deaths.Type = "Deaths"
			Sort.Deaths:SetVisible(true)

			Sort.Ping = Sort.Ping or vgui.Create("DLabel")
			Sort.Ping:SetText("Ping")
			Sort.Ping:SetPos(FAdmin.ScoreBoard.X + FAdmin.ScoreBoard.Main.Controls.FAdminPanelList:GetWide() - 50, FAdmin.ScoreBoard.Y + 90 + 30)
			Sort.Ping.Type = "Ping"
			Sort.Ping:SetVisible(true)
			
			FAdmin.ScoreBoard.Main.Controls.FAdminPanelList:EnableHorizontal(false)
			FAdmin.ScoreBoard.Main.PlayerListView(Sorted:GetString(), SortDown:GetBool())
			for k,v in pairs(Sort) do
				v:SetFont("Trebuchet20")
				v:SizeToContents()
				
				local X, Y = v:GetPos()
				
				v.BtnSort = vgui.Create("DSysButton")
				v.BtnSort:SetType("down")
				v.BtnSort.Type = "down"
				if Sorted:GetString() == v.Type then
					v.BtnSort.Depressed = true
					v.BtnSort:SetType((SortDown:GetBool() and "down") or "up")
					v.BtnSort.Type = (SortDown:GetBool() and "down") or "up"
				end
				v.BtnSort:SetSize(16, 16)
				v.BtnSort:SetPos(X + v:GetWide() + 5, Y + 4)
				function v.BtnSort.DoClick()
					for a,b in pairs(Sort) do
						b.BtnSort.Depressed = (b.BtnSort == v.BtnSort)
					end
					v.BtnSort:SetType((v.BtnSort.Type == "down" and "up") or "down")
					v.BtnSort.Type = (v.BtnSort.Type == "down" and "up") or "down"
					
					RunConsoleCommand("FAdmin_SortPlayerList", v.Type)
					RunConsoleCommand("FAdmin_SortPlayerListDown", (v.BtnSort.Type == "down" and "1") or "0")
					FAdmin.ScoreBoard.Main.Controls.FAdminPanelList:Clear(true)
					FAdmin.ScoreBoard.Main.PlayerListView(v.Type, v.BtnSort.Type == "down")
				end
				table.insert(FAdmin.ScoreBoard.Main.Controls, v) -- Add them to the table so they get removed when you close the scoreboard
				table.insert(FAdmin.ScoreBoard.Main.Controls, v.BtnSort)
			end
		end
	end
	ResetScoreboard()
end

function FAdmin.ScoreBoard.Main.AddPlayerRightClick(Name, func)
	FAdmin.PlayerIcon.RightClickOptions[Name] = func
end