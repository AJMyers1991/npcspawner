local initialSpawn = true

--Relationship Setup
AddRelationshipGroup("SUB_CREW") --creates a new relationship group for submarine crew
SetRelationshipBetweenGroups(5, "SUB_CREW", "PLAYER") --sets submarine crew to hate player peds
SetRelationshipBetweenGroups(0, "SUB_CREW", "SUB_CREW") --sets submarine crew to be companions with each other

-- local SubmarineInteriorZone = BoxZone:Create(vector3(514.34, 4862.39, -64.99), 100.0, 30.0, { --establishes submarine interior zone
-- 	name="SubmarineInteriorZone",
-- 	heading = 180.11,
-- 	useZ = true,
-- 	debugPoly = false
-- })

-- function checkifinSubmarineInteriorZone() --checks if ped is in submarine interior zone
-- 	while true do
-- 		local ped = PlayerPedId()
-- 		local coord = GetEntityCoords(ped)
-- 		inSubmarineInteriorZone = SubmarineInteriorZone:isPointInside(coord)
-- 		if inSubmarineInteriorZone then
-- 			return true
-- 		else
-- 			return false
-- 		end
-- 	end
-- end

RegisterNetEvent("spawnnpcs")
AddEventHandler("spawnnpcs", function()
    Wait(0)
	for k,v in ipairs(Config.Peds) do
		RequestModel(GetHashKey(v.model))
		while not HasModelLoaded(GetHashKey(v.model)) do
			Citizen.Wait(20)
		end
		if v.anim ~= nil and v.animName ~= nil then
			RequestAnimDict(v.anim)
			while not HasAnimDictLoaded(v.anim) do
				Citizen.Wait(20)
			end
		end
		local npcSpawn = CreatePed(4, GetHashKey(v.model), v.x, v.y, v.z, v.a, true, true)
		SetModelAsNoLongerNeeded(GetHashKey(v.model))
		SetEntityAsMissionEntity(npcSpawn, true, true)
		SetNetworkIdExistsOnAllMachines(netid, true)
		if v.relationship ~= nil then
			SetPedRelationshipGroupHash(npcSpawn, GetHashKey(v.relationship))
		end
		if v.stoic == true then
			SetBlockingOfNonTemporaryEvents(npcSpawn, true)
			SetPedFleeAttributes(npcSpawn, 0, 0)
		end
		if v.extrahealth == true and v.voice == male then
			SetPedMaxHealth(npcSpawn, 200)
			SetEntityHealth(npcSpawn, 200)
		else
			SetPedMaxHealth(npcSpawn, 100)
			SetEntityHealth(npcSpawn, 100)
		end
		if v.soldier == true then
			SetPedSeeingRange(npcSpawn, 100.0)
			SetPedHearingRange(npcSpawn, 100.0)
			SetPedCombatAttributes(npcSpawn, 46, 1)
			SetPedFleeAttributes(npcSpawn, 0, true)
			SetPedCombatRange(npcSpawn,2)
			SetPedArmour(npcSpawn, 100)
			SetPedAccuracy(npcSpawn, 100)
		end
		if v.lightarms == true then
			GiveWeaponToPed(npcSpawn, GetHashKey('weapon_pistol_mk2'), 999, false, true)
		elseif v.mediumarms == true then
			GiveWeaponToPed(npcSpawn, GetHashKey('weapon_combatpdw'), 999, false, true)
		elseif v.heavyarms == true then
			GiveWeaponToPed(npcSpawn, GetHashKey('weapon_militaryrifle'), 999, false, true)
		end
		if v.god == true then
			SetEntityProofs(npcSpawn, true, true, true, false, true, true, true, true)
		end
		if v.task ~= nil then
			local ped = GetPlayerPed(-1)
			if v.task == "taskcombatplayer" then
				TaskCombatPed(npcSpawn, ped, 0, 16)
			--elseif v.task == "someothervariable" then
			--	insertnewtaskhere
			--elseif v.task == "someothervariable" then
			--	insertnewtaskhere
			end
		end
		if v.anim ~= nil and v.animName ~= nil then
			TaskPlayAnim(npcSpawn, v.anim, v.animName, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
		end
	end
end)

AddEventHandler("playerSpawned", function()
	if initialSpawn and GetNumberOfPlayers() == 1 then
		TriggerServerEvent("collectnpcs")
		initialSpawn = false
	end
end)