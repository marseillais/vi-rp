include( 'shared.lua' )

usermessage.Hook("Runners", function()
	surface.PlaySound("music/VLVX_song23.mp3")
end)

usermessage.Hook("Killers", function()
	surface.PlaySound("music/your_team_lost.mp3")
end)
