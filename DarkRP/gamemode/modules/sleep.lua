KnockoutTime = 5

local function ResetKnockouts(player)
	player.SleepRagdoll = nil
	player.KnockoutTimer = 0
end
hook.Add("PlayerSpawn", "Knockout", ResetKnockouts)


function KnockoutToggle(player, command, args, caller)
	if not player.SleepSound then
		player.SleepSound = CreateSound(player, "npc/ichthyosaur/water_breath.wav")
	end
	
	if player:Alive() then
		if (player.KnockoutTimer and player.KnockoutTimer + KnockoutTime < CurTime()) or command == "force" then
			if (player.Sleeping and ValidEntity(player.SleepRagdoll)) then
				player.OldHunger = player.DarkRPVars.Energy
				player.SleepSound:Stop()
				local ragdoll = player.SleepRagdoll
				local health = player:Health()
				player:Spawn()
				player:SetHealth(health)
				player:SetPos(ragdoll:GetPos())
				player:SetAngles(Angle(0, ragdoll:GetPhysicsObjectNum(10):GetAngles().Yaw, 0))
				player:UnSpectate()
				player:StripWeapons()
				ragdoll:Remove()
				if player.WeaponsForSleep and player:GetTable().BeforeSleepTeam == player:Team() then
					for k,v in pairs(player.WeaponsForSleep) do
						local wep = player:Give(v[1])
						player:RemoveAllAmmo()
						player:SetAmmo(v[2], v[3], false)
						player:SetAmmo(v[4], v[5], false)
						
						wep:SetClip1(v[6])
						wep:SetClip2(v[7])
						
					end
					local cl_defaultweapon = player:GetInfo( "cl_defaultweapon" )
					if ( player:HasWeapon( cl_defaultweapon )  ) then
						player:SelectWeapon( cl_defaultweapon ) 
					end
					player:GetTable().BeforeSleepTeam = nil
				else
					GAMEMODE:PlayerLoadout(player)
				end 
				player.WeaponsForSleep = {}
				local RP = RecipientFilter()
				RP:RemoveAllPlayers()
				RP:AddPlayer(player)
				umsg.Start("DarkRPEffects", RP)
					umsg.String("colormod")
					umsg.String("0")
				umsg.End()
				RP:AddAllPlayers()
				if command == true then
					player:Arrest()
				end
				player.Sleeping = false
				player:SetDarkRPVar("Energy", player.OldHunger)
				player.OldHunger = nil
				
				if player.DarkRPVars.Arrested then
					GAMEMODE:SetPlayerSpeed(player, GetConVarNumber("aspd"), GetConVarNumber("aspd") )
				end
			else
				for k,v in pairs(ents.FindInSphere(player:GetPos(), 30)) do 
					if v:GetClass() == "func_door" then
						Notify(player, 1, 4, string.format(LANGUAGE.unable, "sleep", "func_door exploit"))
						return ""
					end
				end

				player.WeaponsForSleep = {}
				for k,v in pairs(player:GetWeapons( )) do
					player.WeaponsForSleep[k] = {v:GetClass(), player:GetAmmoCount(v:GetPrimaryAmmoType()), 
					v:GetPrimaryAmmoType(), player:GetAmmoCount(v:GetSecondaryAmmoType()), v:GetSecondaryAmmoType(),
					v:Clip1(), v:Clip2()}
					/*{class, ammocount primary, type primary, ammo count secondary, type secondary, clip primary, clip secondary*/
				end
				local ragdoll = ents.Create("prop_ragdoll")
				ragdoll:SetPos(player:GetPos())
				ragdoll:SetAngles(Angle(0,player:GetAngles().Yaw,0))
				ragdoll:SetModel(player:GetModel())
				ragdoll:Spawn()
				ragdoll:Activate()
				ragdoll:SetVelocity(player:GetVelocity())
				ragdoll.OwnerINT = player:EntIndex()
				ragdoll.PhysgunPickup = false
				ragdoll.CanTool = false
				player:StripWeapons()
				player:Spectate(OBS_MODE_CHASE)
				player:SpectateEntity(ragdoll)
				player.IsSleeping = true
				player.SleepRagdoll = ragdoll
				player.KnockoutTimer = CurTime()
				player:GetTable().BeforeSleepTeam = player:Team()
				--Make sure noone can pick it up:
				ragdoll.Owner = player
				local RP = RecipientFilter()
				RP:RemoveAllPlayers()
				RP:AddPlayer(player)
				umsg.Start("DarkRPEffects",RP)
					umsg.String("colormod")
					umsg.String("1")
				umsg.End()
				RP:AddAllPlayers()
				player.SleepSound = CreateSound(ragdoll, "npc/ichthyosaur/water_breath.wav")
				player.SleepSound:PlayEx(0.10, 100)
				player.Sleeping = true
			end
		end
		return ""
	else
		Notify(player, 1, 4, string.format(LANGUAGE.disabled, "/sleep", ""))
		return ""
	end
end
AddChatCommand("/sleep", KnockoutToggle)
AddChatCommand("/wake", KnockoutToggle)
AddChatCommand("/wakeup", KnockoutToggle)

local function DamageSleepers(ent, inflictor, attacker, amount, dmginfo)
	local ownerint = ent.OwnerINT
	if ownerint and ownerint ~= 0 then
		for k,v in pairs(player.GetAll()) do 
			if v:EntIndex() == ownerint then
				if attacker == GetWorldEntity() then
					amount = 10
					dmginfo:ScaleDamage(0.1)
				end
				v:SetHealth(v:Health() - amount)
				if v:Health() <= 0 and v:Alive() then
					v:Spawn()
					v:UnSpectate()
					v:SetPos(ent:GetPos())
					v:SetHealth(1)
					v:TakeDamage(1, inflictor, attacker)
					if v.SleepSound then
						v.SleepSound:Stop()
					end
					ent:Remove()
				end
			end
		end
	end
end
hook.Add("EntityTakeDamage", "Sleepdamage", DamageSleepers)
