function sendToNearby(msg, coords, maxDistance, color)
	if not msg or not coords then
		return
	end

	color = color or { 255, 255, 255 }
	maxDistance = maxDistance or 20

	for _, targetPlayer in pairs(GetPlayers()) do
		local targetPed = GetPlayerPed(targetPlayer)
		local distance = #(GetEntityCoords(targetPed) - coords)

		if not DoesEntityExist(targetPed) or distance > maxDistance then
			goto skip
		end

		TriggerClientEvent("chat:addMessage", targetPlayer, {
			color = { color[1] or 255, color[2] or 255, color[3] or 255 },
			args = msg,
			template = template,
		})

		::skip::
	end
end

AddEventHandler("chatMessage", function(player, playerName, msg)
	if msg:find("/") then
		return
	end

	local xPlayer = ESX.GetPlayerFromId(player)
	if not xPlayer then
		CancelEvent()
		return
	end

	local sourcePed = GetPlayerPed(player)

	sendToNearby({ xPlayer.getName() .. " mondja: ", msg }, GetEntityCoords(sourcePed), DISTANCES.speak)

	CancelEvent()
end)

function sendLocalMeMessage(player, msg)
	local xPlayer = ESX.GetPlayerFromId(player)
	if not xPlayer then
		return
	end

	local sourcePed = GetPlayerPed(player)

	sendToNearby(
		{ "^*" .. "***" .. xPlayer.getName() .. " " .. msg },
		GetEntityCoords(sourcePed),
		DISTANCES.me,
		{ 194, 162, 218 }
	)
end
exports("sendLocalMeMessage", sendLocalMeMessage)

function sendLocalDoAction(player, msg)
	local xPlayer = ESX.GetPlayerFromId(player)
	if not xPlayer then
		return
	end

	local sourcePed = GetPlayerPed(player)

	sendToNearby(
		{ "^*" .. "* " .. msg .. " ((" .. xPlayer.getName() .. "))" },
		GetEntityCoords(sourcePed),
		DISTANCES.me,
		{ 255, 51, 102 }
	)
end
exports("sendLocalDoAction", sendLocalDoAction)

--
-- Commands
--

for cmd, data in pairs(COMMANDS) do
	RegisterCommand(cmd, function(player, args, cmd)
		local xPlayer = ESX.GetPlayerFromId(player)
		if not xPlayer then
			return
		end

		local msg = table.concat(args, " ")
		local sourcePed = GetPlayerPed(player)

		sendToNearby(
			{ xPlayer.getName() .. " " .. (data.extender or "") .. ": ", msg },
			GetEntityCoords(sourcePed),
			DISTANCES[data.distance]
		)
	end)
end

RegisterCommand("me", function(player, args, cmd)
	local msg = table.concat(args, " ")

	sendLocalMeMessage(player, msg)
end)

RegisterCommand("do", function(player, args, cmd)
	local msg = table.concat(args, " ")

	sendLocalDoAction(player, msg)
end)
