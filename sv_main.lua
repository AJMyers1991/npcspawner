local npcsspawned = false

Citizen.CreateThread(function()
    RegisterServerEvent("collectnpcs")
    AddEventHandler("collectnpcs", function()
        if npcsspawned == false then
			local _source = source
			TriggerClientEvent("spawnnpcs", _source)
			npcsspawned = true
		end
    end)
end)

