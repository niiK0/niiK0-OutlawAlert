ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			job = identity['job']
		}
	else
		return nil
	end
end

RegisterServerEvent('esx_outlawalert:carJackInProgress')
AddEventHandler('esx_outlawalert:carJackInProgress', function(targetCoords, streetName, vehicleLabel, playerGender)
	if playerGender == 0 then
		playerGender = _U('male')
	else
		playerGender = _U('female')
	end
	
	local trabalho = getIdentity(source)
	
	if trabalho.job == "police" then
	TriggerClientEvent('chatMessage', -1, "^0[^1Alerta^0] ^1Carro Roubado! ^3Sexo: ^0" .. playerGender .. " ^4Rua: ^0".. streetName)	
	-- TriggerClientEvent('esx_outlawalert:outlawNotify', -1, _U('carjack', playerGender, vehicleLabel, streetName))
	TriggerClientEvent('esx_outlawalert:carJackInProgress', -1, targetCoords)
	end
end)

RegisterServerEvent('esx_outlawalert:combatInProgress')
AddEventHandler('esx_outlawalert:combatInProgress', function(targetCoords, streetName, playerGender)
	if playerGender == 0 then
		playerGender = _U('male')
	else
		playerGender = _U('female')
	end

	-- TriggerClientEvent('esx_outlawalert:outlawNotify', -1, _U('combat', playerGender, streetName))
	TriggerClientEvent('esx_outlawalert:combatInProgress', -1, targetCoords)
end)

RegisterServerEvent('esx_outlawalert:gunshotInProgress')
AddEventHandler('esx_outlawalert:gunshotInProgress', function(targetCoords, streetName, playerGender)
	if playerGender == 0 then
		playerGender = _U('male')
	else
		playerGender = _U('female')
	end
	
	TriggerClientEvent('esx_outlawalert:outlawNotify', -1)
	TriggerClientEvent('esx_outlawalert:gunshotInProgress', -1, targetCoords)
end)

ESX.RegisterServerCallback('esx_outlawalert:isVehicleOwner', function(source, cb, plate)
	local identifier = GetPlayerIdentifier(source, 0)

	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE owner = @owner AND plate = @plate', {
		['@owner'] = identifier,
		['@plate'] = plate
	}, function(result)
		if result[1] then
			cb(result[1].owner == identifier)
		else
			cb(false)
		end
	end)
end)
