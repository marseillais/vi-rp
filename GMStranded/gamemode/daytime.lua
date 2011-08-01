
NightLight = string.byte('a')
DayLight = string.byte('m')

TargetPattern = DayLight
CurrentPattern = DayLight

DayTime = 330
NightTime = 1170
ZombieTime = 1400
Time = DayTime + 1

IsNight = false

if (CLIENT) then
	timer.Simple(5, function()
		RunConsoleCommand('pp_sunbeams', '1')
		RunConsoleCommand('pp_sunbeams_darken', '0.75')
		RunConsoleCommand('pp_sunbeams_multiply', '1')
		RunConsoleCommand('pp_sunbeams_sunsize', '0.25')
	end)

	timer.Create("DayTime.TimerClient", 1, 0, function()
		Time = Time + 1
		if(Time > 1440) then Time = 0 end
	end)
elseif (SERVER) then
	timer.Create("DayTime.TimerServer", 1, 0, function()
		Time = Time + 1
		if(Time > 1440) then Time = 0 end
		local suns = ents.FindByClass("env_sun")
		if (#suns > 0) then
			for id, sun in pairs(suns) do
				sun:SetKeyValue("pitch", math.NormalizeAngle((Time / 1440 * 360) + 90))
				sun:Activate() -- Update it!
			end
		end

		local light_environments = ents.FindByClass('light_environment')
		if (#light_environments > 0) then
			for _,light in pairs(light_environments) do
				if (Time < DayTime or Time > NightTime) then
					TargetPattern = NightLight
					IsNight = true
				elseif (Time > DayTime or Time < NightTime) then
					TargetPattern = DayLight
					IsNight = false
				end

				if ((Time % 3) == 0 and TargetPattern != CurrentPattern) then
					if (TargetPattern > CurrentPattern) then
						CurrentPattern = math.Clamp(CurrentPattern + 1, NightLight, DayLight)
					else
						CurrentPattern = math.Clamp(CurrentPattern - 1, NightLight, DayLight)
					end

					light:Fire('FadeToPattern', string.char(CurrentPattern), 0)
					light:Activate()    
				end
			end
		end

		if (Time == ZombieTime) then // >:)
			local boxes = {}
			local res = ents.FindByClass("gms_resourcedrop")
			if (#res > 10) then
				for _, v in ipairs(res) do
					if (math.random(0, 100) > 50 and #boxes < math.floor(#res / 2)) then
						table.insert(boxes, v)
					end
				end
				
				for id, box in pairs(boxes) do // To do: add admin no delete?
					box:Fadeout()
				end
				
				for i=0, math.random(2, 10) do
					local pos = Vector(math.random(-6000, 6000), math.random(-6000, 6000), 1800)
				
					local trace = {}
					trace.start = pos
					trace.endpos = pos - Vector(0, 0, 9999)
					local tr = util.TraceLine(trace)
				
					local aah = ents.Create('npc_zombie')
					aah:SetPos(tr.HitPos + Vector(0, 0, 64))
					aah:SetNWString("Owner", "World")
					aah:Spawn()
				end
				
				for id, ply in pairs(player.GetAll()) do
					ply:SendMessage("Something happened outside...", 5, Color(255, 10, 10, 255))
					
					timer.Simple(10, function()
						ply:SendMessage("So they didn't get stolen at night.", 5, Color(255, 150, 150, 255))
						ply:SendMessage("Remember to store your resources in resoucepack, ", 5, Color(255, 150, 150, 255))
					end)
				end
			end
		end
	end)
end

/*sky_overlay = ents.FindByName( 'skyoverlay*' )
if(sky_overlay) then
print("Skyoverlay found. Initialized.")
end
// setup the sky color.
if ( sky_overlay ) then
local brush
for _ , brush in pairs( sky_overlay ) do
print(brush)
// enable the brush if it isn't already.
brush:Fire( 'Enable' , '' , 0 )
// turn it black.
brush:Fire( 'Color' , '0 0 0' , 0.01 )
end
end
*/