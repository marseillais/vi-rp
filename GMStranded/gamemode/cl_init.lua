/*---------------------------------------------------------
  Gmod Stranded
---------------------------------------------------------*/

DeriveGamemode("sandbox")

include("shared.lua")
include("cl_scoreboard.lua")
include("qmenu.lua")
include("cl_panels.lua") -- Custom panels
include("unlocks.lua") -- Unlocks
include("combinations.lua") -- Combis

--Clientside player variables
StrandedColorTheme = Color(0, 0, 0, 240)
StrandedBorderTheme = Color(0, 0, 0, 180)
Tribes = {}
Skills = {}
Resources = {}
Experience = {}
FeatureUnlocks = {}
MaxResources = 25

Sleepiness = 1000
Hunger = 1000
Thirst = 1000
Oxygen = 1000

CampFires = {}

-- Locals
local PlayerMeta = FindMetaTable("Player")

/* Language */
language.Add('gms_stonefurnace', "Stone Furnace")
language.Add('gms_stoneworkbench', "Stone Workbench")
language.Add('gms_copperfurnace', "Copper Furnace")
language.Add('gms_copperworkbench', "Copper Workbench")
language.Add('gms_ironfurnace', "Iron Furnace")
language.Add('gms_ironworkbench', "Iron Workbench")
language.Add('gms_factory', "Factory")
language.Add('gms_gunlab', "Gun Lab")

/* The chat hints */
HintsRus = {
	"Держите свои ресурсы в ресурс паке, чтобы их не украли ночью.",
	"А знаете ли вы, что ресурсы в меню ресурсов (F2) нажимаемы мышью?",
	"Храните вашу еду в холодильнике, чтобы она не портилась.",
	"Чтобы племя могло использовать вещи друг друга, это племя должно иметь пароль."
}

HintsEng = {
	"Store your resources in resource pack, so they wont get stolen at night.",
	"Did you know that resources in Resources menu (F2) are clickable?",
	"Keep your food in fridge, so it does not spoil.",
	"In order to share items within a tribe, the tribe must have a password."
}

timer.Create("Client.HINTS", 300, 0, function()
	if (math.random(0, 100) > 50) then
		chat.AddText(Color(50, 255, 50), "[HINT] ", Color(255, 255, 255), HintsRus[math.random(1, #HintsRus)])
	else
		chat.AddText(Color(50, 255, 50), "[HINT] ", Color(255, 255, 255), HintsEng[math.random(1, #HintsEng)])
	end
end)

/* Find tribe by ID */
function GM.FindTribeByID(Tid)
	for id, tabl in pairs(Tribes) do
		if (tabl.id == Tid) then
			return tabl
		end
	end
	return false
end

/* Res pack GUI */
concommand.Add("gms_openrespackmenu", function(ply, cmd, args)
    local resPack = ply:GetEyeTrace().Entity
    
    local frame = vgui.Create("DFrame")
    frame:SetSize(ScrW() / 2, ScrH() / 2)
    frame:MakePopup()
	if (resPack:GetClass() == "gms_fridge") then
		frame:SetTitle("Fridge")
	else
		frame:SetTitle("Resource pack")
	end
   
    frame:Center()
    
    local panelList = vgui.Create("DPanelList", frame)
    panelList:SetPos(5, 25)
    panelList:SetSize(frame:GetWide() - 10, frame:GetTall() - 30)
    panelList:SetSpacing(5)
    panelList:SetPadding(5)
    panelList:EnableHorizontal(false)
    panelList:EnableVerticalScrollbar(true)
    
    for res, num in SortedPairs(resPack.Resources) do
        local reso = vgui.Create("gms_resourceLine")
		if (resPack:GetClass() == "gms_fridge") then
			reso:SetRes(res, num, false)
		else
			reso:SetRes(res, num, true)
		end
        panelList:AddItem(reso)
    end
end)

/* Receive the campfires */
usermessage.Hook("addCampFire", function(data)
	table.insert(CampFires, Entity(data:ReadShort()))
end)

usermessage.Hook("removeCampFire", function(data)
	local ent = Entity(data:ReadShort())

	for id, e in pairs(CampFires) do
		if (e == ent) then
			table.remove(CampFires, id)
		end
	end
end)

hook.Add("Think", "CampFireLight", function()
	for id, e in pairs(CampFires) do
		if (!e or e == NULL or e:WaterLevel() > 0) then
			table.remove(CampFires, id)
		else
			local Hax = DynamicLight(e:EntIndex())
			if (Hax) then
				Hax.Pos = e:GetPos()// + Vector(0, 0, offset)
				Hax.r = 255
				Hax.g = 128
				Hax.b = 0
				Hax.Brightness = math.random(2, 3)
				Hax.Size = math.random(448, 512) 
				Hax.Decay = 400 * 5
				Hax.DieTime = CurTime() + 0.25
			end
		end
	end
end)

/*---------------------------------------------------------
  General / utility
---------------------------------------------------------*/
function GM:HUDShouldDraw(name) --Hide other sandbox stuff
    if (name != "CHudHealth" and name != "CHudBattery") then
        return true
    end
end

function GM:HUDPaint()
	self.BaseClass:HUDPaint()
	if (ProcessCompleteTime) then
		local col = StrandedColorTheme
		local bordcol = StrandedBorderTheme

		local wid = ScrW() / 3
		local hei = ScrH() / 30
		surface.SetDrawColor(col.r, col.g, col.b, math.Clamp(col.a - 60, 1, 255))
		surface.DrawRect(ScrW() * 0.5 - wid * 0.5, ScrH() / 30, wid, hei)

		local width = math.min(((RealTime() - ProcessStart) / ProcessCompleteTime) * wid, wid)
		if (width > wid) then GAMEMODE.StopProgressBar() end
		surface.SetDrawColor(0, 128, 176, 220)
		surface.DrawRect(ScrW() * 0.5 - wid * 0.5, ScrH() / 30, width, hei)

		surface.SetDrawColor(bordcol.r, bordcol.g, bordcol.b, math.Clamp(bordcol.a - 60, 1, 255))
		surface.DrawOutlinedRect(ScrW() * 0.5 - wid * 0.5, ScrH() / 30, wid, hei)

		local str = CurrentProcess
		if (ProcessCancelAble) then
			str = str .. " (F4 to Cancel)"
		end
		draw.SimpleText(str , "ScoreboardText", ScrW() * 0.5, hei * 1.5, Color(255, 255, 255, 255), 1, 1)
	end
end

function GM.CreateHUD()
	GAMEMODE.NeedHud = vgui.Create("gms_NeedHud")
	GAMEMODE.SkillsHud = vgui.Create("gms_SkillsHud")
	GAMEMODE.CommandsHud = vgui.Create("gms_CommandsHud")
	GAMEMODE.ResourcesHud = vgui.Create("gms_ResourcesHud")
	GAMEMODE.LoadingBar = vgui.Create("gms_LoadingBar")
	GAMEMODE.LoadingBar:SetVisible(false)
	GAMEMODE.SavingBar = vgui.Create("gms_SavingBar")
	GAMEMODE.SavingBar:SetVisible(false)
end
usermessage.Hook("gms_CreateInitialHUD", GM.CreateHUD)

function GM.MakeProgressBar(um)
	CurrentProcess = um:ReadString()
	ProcessStart = RealTime()
	ProcessCompleteTime = um:ReadShort()
	ProcessCancelAble = um:ReadBool()
end
usermessage.Hook("gms_MakeProcessBar", GM.MakeProgressBar)

function GM.StopProgressBar()
	ProcessCompleteTime = false
end
usermessage.Hook("gms_StopProcessBar", GM.StopProgressBar)

function GM.MakeLoadingBar(um)
	GAMEMODE.LoadingBar:Show(um:ReadString())
end
usermessage.Hook("gms_MakeLoadingBar",GM.MakeLoadingBar)

function GM.StopLoadingBar(um)
	GAMEMODE.LoadingBar:Hide()
end
usermessage.Hook("gms_StopLoadingBar", GM.StopLoadingBar)

function GM.MakeSavingBar(um)
	GAMEMODE.SavingBar:Show(um:ReadString())
end
usermessage.Hook("gms_MakeSavingBar", GM.MakeSavingBar)

function GM.StopSavingBar(um)
	GAMEMODE.SavingBar:Hide()
end
usermessage.Hook("gms_StopSavingBar", GM.StopSavingBar)

function GetSkill(skill)
	return Skills[skill] or 0
end

function GM.SetSkill(um)
	Skills[um:ReadString()] = um:ReadShort()
	MaxResources = 25 + (GetSkill("Survival") * 5)
	GAMEMODE.SkillsHud:RefreshSkills()
end
usermessage.Hook("gms_SetSkill", GM.SetSkill)

function GetXP(skill)
	return Experience[skill] or 0
end

function GM.SetXP(um)
	Experience[um:ReadString()] = um:ReadShort()
end
usermessage.Hook("gms_SetXP", GM.SetXP)

function GetResource(resource)
	return Resources[resource] or 0
end

usermessage.Hook("gms_SetResource", function(um)
	local res = um:ReadString()
	local amount = um:ReadShort()

	Resources[res] = amount
	GAMEMODE.ResourcesHud:RefreshResources()
end)

usermessage.Hook("gms_SetMaxResources", function(um)
	MaxResources = um:ReadShort()
	GAMEMODE.ResourcesHud:RefreshResources()
end)

usermessage.Hook("gms_toggleskillsmenu", function(um)
	GAMEMODE.SkillsHud:ToggleExtend()
end)

usermessage.Hook("gms_toggleresourcesmenu", function(um)
	GAMEMODE.ResourcesHud:ToggleExtend()
end)

usermessage.Hook("gms_togglecommandsmenu", function(um)
	GAMEMODE.CommandsHud:ToggleExtend()
end)

usermessage.Hook("gms_cancelprocess", function(um)
	RunConsoleCommand("gms_cancelprocess")
end)

usermessage.Hook("gms_OpenCombiMenu", function(um)
	if (GAMEMODE.CombiMenu) then GAMEMODE.CombiMenu:Remove() end
	GAMEMODE.CombiMenu = vgui.Create("GMS_CombinationWindow")
	GAMEMODE.CombiMenu:SetTable(um:ReadString())
end)

function TraceFromEyes(dist)
	local trace = {}
	trace.start = self:GetShootPos()
	trace.endpos = trace.start + (self:GetAimVector() * dist)
	trace.filter = self

	return util.TraceLine(trace)
end

GM.InfoMessages = {}
GM.InfoMessageLine = 0

function GM.SendMessage(um)
	local text = um:ReadString()
	local dur = um:ReadShort()
	local col = um:ReadString()
	local str = string.Explode(",", col)
	local col = Color(tonumber(str[1]), tonumber(str[2]), tonumber(str[3]), tonumber(str[4]))

	for k,v in pairs(GAMEMODE.InfoMessages) do
		v.drawline = v.drawline + 1
	end

	local message = {}
	message.Text = text
	message.Col = col
	message.Tab = 5
	message.drawline = 1

	GAMEMODE.InfoMessages[#GAMEMODE.InfoMessages + 1] = message
	GAMEMODE.InfoMessageLine = GAMEMODE.InfoMessageLine + 1

	timer.Simple(dur, GAMEMODE.DropMessage, message)
end

usermessage.Hook("gms_sendmessage", GM.SendMessage)

function CheckName(ent, nametable)
	for k, v in pairs(nametable) do
		if (ent:GetClass() == v) then return true end		
	end
end

function GM.GMS_ResourceDropsHUD()
	local ply = LocalPlayer()
	local str = nil
	local draw_loc = nil
	local w, h = nil, nil
	local tr = nil
	local cent = nil
	local pos = ply:GetShootPos()

	for _, v in ipairs(ents.GetAll()) do
		match = CheckName(v, GMS.StructureEntities)
		if (v:GetClass() == "gms_resourcedrop") then
			cent = v:LocalToWorld(v:OBBCenter())
			
			tr = {}
			tr.start = pos
			tr.endpos = cent
			tr.filter = ply

			if ((cent - pos):Length() <= 200 and util.TraceLine(tr).Entity == v) then
				str = (v.Res or "Loading") .. ": " .. tostring(v.Amount or 0)
				draw_loc = cent:ToScreen()
				surface.SetFont("ChatFont")
				w, h = surface.GetTextSize(str)
 				draw.RoundedBox(4, draw_loc.x - (w / 2) - 3, draw_loc.y - (h / 2) - 3, w + 6, h + 6, Color(50, 50, 50, 200))
				surface.SetTextColor(255, 255, 255, 200)
				surface.SetTextPos(draw_loc.x - (w / 2), draw_loc.y -(h / 2))
				surface.DrawText(str)
			end
		end
		
		if (v:GetClass() == "gms_resourcepack" or v:GetClass() == "gms_fridge") then
			cent = v:LocalToWorld(v:OBBCenter())
			
			tr = {}
			tr.start = pos
			tr.endpos = cent
			tr.filter = ply

			if ((cent - pos):Length() <= 200 and util.TraceLine(tr).Entity == v) then
				draw_loc = cent:ToScreen()
				surface.SetFont("ChatFont")
				str = "Resource pack"
				if (v:GetClass() == "gms_fridge") then str = "Fridge" end
				for res, num in pairs(v.Resources) do
					str = str .. "\n" .. res .. ": " .. num
				end
				w, h = surface.GetTextSize(str)
 				draw.RoundedBox(4, draw_loc.x - (w / 2) - 3, draw_loc.y - (h / 2) - 3, w + 6, h + 6, Color(50, 50, 50, 200))
				surface.SetTextColor(255, 255, 255, 200)
				for id, st in pairs(string.Explode("\n", str)) do
					id = id - 1
					w2, h2 = surface.GetTextSize(st)
					surface.SetTextPos(draw_loc.x - (w / 2), draw_loc.y - (h / 2) + (id * h2))
					surface.DrawText(st)
				end
			end
		end

		if (match) then
			cent = v:LocalToWorld(v:OBBCenter())
			local minimum = v:LocalToWorld(v:OBBMins())
			local maximum = v:LocalToWorld(v:OBBMaxs())
			local loc = Vector(0, 0, 0)
			local distance = (maximum - minimum):Length()
			if (distance < 200) then distance = 200 end

			tr2 = {}
			tr2.start = pos
			tr2.endpos = Vector(cent.x, cent.y, pos.z)
			tr2.filter = ply

			if ((cent - pos):Length() <= distance and (util.TraceLine(tr2).Entity == v or !util.TraceLine(tr2).Hit)) then
				str = (v:GetNetworkedString('Name') or "Loading")
				if (v:GetClass() == "gms_buildsite") then
					str = str .. v:GetNetworkedString('Resources')
				end
				if (minimum.z <= maximum.z) then
					if (pos.z > maximum.z) then
						loc.z = maximum.z
					elseif (pos.z < minimum.z) then
						loc.z = minimum.z
					else
						loc.z = pos.z
					end
				else
					if (pos.z < maximum.z) then
						loc.z = maximum.z
					elseif (pos.z > minimum.z) then
						loc.z = minimum.z
					else
						loc.z = pos.z
					end
				end
				draw_loc = Vector(cent.x, cent.y, loc.z):ToScreen()
				surface.SetFont("ChatFont")
				w, h = surface.GetTextSize(str)
 				draw.RoundedBox(4, draw_loc.x - (w / 2) - 3, draw_loc.y - (h / 2) - 3, w + 6, h + 6, Color(50, 50, 50, 200))
				surface.SetTextColor(255, 255, 255, 200)
				surface.SetTextPos(draw_loc.x - (w / 2), draw_loc.y - (h / 2))
				surface.DrawText(str)
			end
		end
	end
end
hook.Add("HUDPaint", "GMS_ResourceDropsHUD", GM.GMS_ResourceDropsHUD)

function GM.DrawMessages()
	for k,msg in pairs(GAMEMODE.InfoMessages) do
		local txt = msg.Text
		local line = ScrH() / 2 + (msg.drawline * 20)
		local tab = msg.Tab
		local col = msg.Col
		draw.SimpleTextOutlined(txt, "ScoreboardText", tab, line, col, 0, 0, 0.5, Color(100, 100, 100, 150))

		if (msg.Fading) then
			msg.Tab = msg.Tab - (msg.InitTab - msg.Tab - 0.05)

			if (msg.Tab > ScrW() + 10) then
				GAMEMODE.RemoveMessage(msg)
			end
		end
	end
end

hook.Add("HUDPaint", "gms_drawmessages", GM.DrawMessages)

function GM.DropMessage(msg)
	msg.InitTab = msg.Tab
	msg.Fading = true
end

function GM.RemoveMessage(msg)
	for k, v in pairs(GAMEMODE.InfoMessages) do
		if (v == msg) then
			GAMEMODE.InfoMessages[k] = nil
			GAMEMODE.InfoMessageLine = GAMEMODE.InfoMessageLine - 1
			table.remove(GAMEMODE.InfoMessages, k)
		end
	end
end

/*---------------------------------------------------------
  Prop fading
---------------------------------------------------------*/
GM.FadingProps = {}
function GM.AddFadingProp(um)
	local mdl = um:ReadString()
	local pos = um:ReadVector()
	local dir = um:ReadVector()
	local speed = um:ReadShort()

	if (!mdl or !pos or !dir or !speed) then return end

	local ent = ents.Create("prop_physics")
	ent:SetModel(mdl)
	ent:SetPos(pos)
	ent:SetAngles(dir:Angle())
	ent:Spawn()

	ent.Alpha = 255
	ent.Speed = speed

	table.insert(GAMEMODE.FadingProps, ent)
end
usermessage.Hook("gms_CreateFadingProp", GM.AddFadingProp)

function GM.FadeFadingProps()
	local GM = GAMEMODE

	for k, v in pairs(GM.FadingProps) do
		if (v.Alpha) then
			if (v.Alpha <= 0) then
				v.Entity:Remove()
				table.remove(GM.FadingProps, k)
			else
				v.Alpha = v.Alpha - (1 * v.Speed)
				v.Entity:SetColor(255, 255, 255, v.Alpha)
			end
		end
	end
end
hook.Add("Think", "gms_FadeFadingPropsHook", GM.FadeFadingProps)

/*---------------------------------------------------------
  Achievement Messages
---------------------------------------------------------*/
GM.AchievementMessages = {}

function GM.SendAchievement(um)
	local text = um:ReadString()

	local tbl = {}
	tbl.Text = text
	tbl.Alpha = 255

	table.insert(GAMEMODE.AchievementMessages, tbl)
end
usermessage.Hook("gms_sendachievement", GM.SendAchievement)

function GM.DrawAchievementMessages()
	for k, msg in pairs(GAMEMODE.AchievementMessages) do
		msg.Alpha = msg.Alpha - 1
		draw.SimpleTextOutlined(msg.Text, "ScoreboardHead", ScrW() / 2, ScrH() / 2, Color(255, 255, 255, msg.Alpha), 1, 1, 0.5, Color(100, 100, 100, msg.Alpha))

		if (msg.Alpha <= 0) then
			table.remove(GAMEMODE.AchievementMessages, k)
		end
	end
end
hook.Add("HUDPaint", "gms_drawachievementmessages", GM.DrawAchievementMessages)

/*---------------------------------------------------------
  Needs
---------------------------------------------------------*/
function GM.SetNeeds(um)
	Sleepiness = um:ReadShort()
	Hunger = um:ReadShort()
	Thirst = um:ReadShort()
	Oxygen = um:ReadShort()
	Time = um:ReadShort()
end
usermessage.Hook("gms_setneeds", GM.SetNeeds)

/*---------------------------------------------------------
  Help Menu
---------------------------------------------------------*/
concommand.Add("gms_help", function()
	local GM = GAMEMODE

	GM.HelpMenu = vgui.Create("DFrame")
	GM.HelpMenu:MakePopup()
	GM.HelpMenu:SetMouseInputEnabled(true)
	GM.HelpMenu:SetSize(ScrW() - 100, ScrH() - 100)
	GM.HelpMenu:Center()
	GM.HelpMenu:SetTitle("Welcome to Custom GMStranded 2.5")

	GM.HelpMenu.HTML = vgui.Create("HTML", GM.HelpMenu)
	GM.HelpMenu.HTML:SetSize(GM.HelpMenu:GetWide() - 10, GM.HelpMenu:GetTall() - 30)
	GM.HelpMenu.HTML:SetPos(5, 25)
	GM.HelpMenu.HTML:SetHTML(file.Read("../gamemodes/GMStranded/content/help/helpnew.htm"))
end)

/*---------------------------------------------------------
  Sleep
---------------------------------------------------------*/
function GM.SleepOverlay()
	if (!SleepFadeIn and !SleepFadeOut) then return end

	if (SleepFadeIn and SleepFade < 250) then
		SleepFade = SleepFade + 5
	elseif (SleepFadeIn and SleepFade >= 255) then
		SleepFadeIn = false
	end

	if (SleepFadeOut and SleepFade > 0) then
		SleepFade = SleepFade - 5
	elseif (SleepFadeOut and SleepFade <= 0) then
		SleepFadeOut = false
	end

	surface.SetDrawColor(0, 0, 0, SleepFade)
	surface.DrawRect(0, 0, ScrW(), ScrH())

	draw.SimpleText("Use the command \"!wakeup\" to wake up.", "ScoreboardSub", ScrW() / 2, ScrH() / 2, Color(255, 255, 255, SleepFade), 1, 1)
end
hook.Add("HUDPaint", "gms_sleepoverlay", GM.SleepOverlay)

function GM.StartSleep(um)
	SleepFadeIn = true
	SleepFade = 0
end
usermessage.Hook("gms_startsleep", GM.StartSleep)

function GM.StopSleep(um)
	SleepFadeOut = true
	SleepFade = 255
end
usermessage.Hook("gms_stopsleep", GM.StopSleep)

/*---------------------------------------------------------
  AFK
---------------------------------------------------------*/
function GM.AFKOverlay()
	if (!AFKFadeIn and !AFKFadeOut) then return end
	if (AFKFadeIn and AFKFade < 250) then
		AFKFade = AFKFade + 5
	elseif (AFKFadeIn and AFKFade >= 255) then
		AFKFadeIn = false
	end

	if (AFKFadeOut and AFKFade > 0) then
		AFKFade = AFKFade - 5
	elseif (AFKFadeOut and AFKFade <= 0) then
		AFKFadeOut = false
	end

	surface.SetDrawColor(0, 0, 0, AFKFade)
	surface.DrawRect(0, 0, ScrW(), ScrH())

	draw.SimpleText("Use the command \"!afk\" to stop being afk.", "ScoreboardSub", ScrW() / 2, ScrH() / 2, Color(255, 255, 255, AFKFade), 1, 1)
end
hook.Add("HUDPaint", "gms_afkoverlay", GM.AFKOverlay)

function GM.StartAFK(um)
	AFKFadeIn = true
	AFKFade = 0
end
usermessage.Hook("gms_startafk", GM.StartAFK)

function GM.StopAFK(um)
	AFKFadeOut = true
	AFKFade = 255
end
usermessage.Hook("gms_stopafk", GM.StopAFK)

/*---------------------------------------------------------
  Unlock system
---------------------------------------------------------*/
usermessage.Hook("gms_AddUnlock", function(um)
	local UnlockWindow = vgui.Create("GMS_UnlockWindow")
	UnlockWindow:SetMouseInputEnabled(true)
	UnlockWindow:SetUnlock(um:ReadString())
end)

/*---------------------------------------------------------
  Admin menu
---------------------------------------------------------*/
concommand.Add("gms_admin", function()
	if (!LocalPlayer():IsAdmin()) then return end

	if (!GAMEMODE.AdminMenu) then
		GAMEMODE.AdminMenu = vgui.Create("GMS_AdminMenu")
		GAMEMODE.AdminMenu:SetVisible(false)
	end

	GAMEMODE.AdminMenu:SetVisible(!GAMEMODE.AdminMenu:IsVisible())
end)

usermessage.Hook("gms_AddLoadGameToList", function(um)
	if (!GAMEMODE.AdminMenu) then GAMEMODE.AdminMenu = vgui.Create("GMS_AdminMenu") end

	local str = um:ReadString()
	GAMEMODE.AdminMenu.LoadGameEntry:AddItem(str, str)
	GAMEMODE.AdminMenu:SetVisible(false)
end)

usermessage.Hook("gms_RemoveLoadGameFromList", function(um)
	if (!GAMEMODE.AdminMenu) then GAMEMODE.AdminMenu = vgui.Create("GMS_AdminMenu") end

	GAMEMODE.AdminMenu.LoadGameEntry:RemoveItem(um:ReadString())
end)

/*---------------------------------------------------------
  Tribe menu
---------------------------------------------------------*/
concommand.Add("gms_tribemenu", function()
	if (!GAMEMODE.TribeMenu) then
		GAMEMODE.TribeMenu = vgui.Create("GMS_TribeMenu")
		GAMEMODE.TribeMenu:SetDeleteOnClose(false)
		GAMEMODE.TribeMenu:SetVisible(false)
	end

	GAMEMODE.TribeMenu:SetVisible(!GAMEMODE.TribeMenu:IsVisible())
end)

/*---------------------------------------------------------
  Tribes list
---------------------------------------------------------*/
concommand.Add("gms_tribes", function()
	if (#Tribes > 0) then
		local TribesMenu = vgui.Create("GMS_TribesList")
	else
		chat.AddText(Color(255, 255, 255), "No tribes created so far. Why not create one?")
	end
end)

/*---------------------------------------------------------
   Tribe system
---------------------------------------------------------*/
usermessage.Hook("recvTribes", function(data)
	local id = data:ReadShort()
	local name = data:ReadString()
	local red = data:ReadShort()
	local green = data:ReadShort()
	local blue = data:ReadShort()
	local hazpass = data:ReadBool()
	team.SetUp(id, name, Color(red, green, blue))
	
	table.insert(Tribes, {name = name, pass = hazpass, id = id, r = red, g = green, b = blue})
end)

function GM.ReceiveTribe(data)
	local name = data:ReadString()
	local id = data:ReadShort()
	local red = data:ReadShort()
	local green = data:ReadShort()
	local blue = data:ReadShort()
	local hazpass = data:ReadBool()
	team.SetUp(id, name, Color(red, green, blue))
	
	table.insert(Tribes, {name = name, pass = hazpass, id = id, r = red, g = green, b = blue})
end
usermessage.Hook("newTribe", GM.ReceiveTribe)