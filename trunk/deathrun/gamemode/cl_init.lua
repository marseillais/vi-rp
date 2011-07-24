include('shared.lua')

usermessage.Hook("Win", function()
	surface.PlaySound("music/your_team_win.mp3")
end)

usermessage.Hook("Fail", function()
	surface.PlaySound("music/your_team_lost.mp3")
end)
