local oocState = true
local inputState = false

RegisterNetEvent("receiveOOCMessage", function(message)
	SendNUIMessage({
		message = message,
	})
end)

RegisterCommand("clearooc", function()
	SendNUIMessage({
		clear = true,
	})
end)

RegisterCommand("togooc", function()
	oocState = not oocState

	SendNUIMessage({
		visible = oocState,
	})
end)

CreateThread(function()
	local oldVisible = false

	while true do
		local visible = not IsPauseMenuActive()
		if oldVisible ~= visible then
			SendNUIMessage({
				visible = visible,
			})
			oldVisible = visible
		end
		Wait(400)
	end
end)

function setOOCState(state)
	inputState = state

	SetNuiFocus(state, false)
	SendNUIMessage({
		inputState = state,
	})
end

RegisterCommand("oocChat", function()
	inputState = not inputState

	setOOCState(inputState)
end, false)
RegisterKeyMapping("oocChat", "OOC Chat", "keyboard", "b")

RegisterNUICallback("sendMessage", function(data)
	setOOCState(false)

	print(data.message, data.message:len())

	if data.message:len() <= 1 then
		return
	end

	local myCoords = GetEntityCoords(PlayerPedId())
	local nearbyPlayers = {}

	for _, targetPlayer in pairs(GetActivePlayers()) do
		local targetPed = GetPlayerPed(targetPlayer)
		local distance = #(GetEntityCoords(targetPed) - myCoords)

		if not DoesEntityExist(targetPed) or distance > DISTANCES.ooc then
			goto skip
		end

		table.insert(nearbyPlayers, GetPlayerServerId(targetPlayer))

		::skip::
	end

	TriggerServerEvent("sendOOCMessage", nearbyPlayers, data.message)
end)

RegisterNUICallback("cancelOOC", function()
	setOOCState(false)
end)
