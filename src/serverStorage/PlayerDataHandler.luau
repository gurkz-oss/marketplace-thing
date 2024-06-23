local PlayerDataHandler = {}

local dataTemplate = {
	RobuxSpent = 0,
}

local ProfileService = require(game.ServerStorage.ProfileService)
local Players = game:GetService("Players")

local ProfileStore = ProfileService.GetProfileStore("PlayerProfile", dataTemplate)

local Profiles = {}

local function playerAdded(player: Player)
	local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)

	if profile then
		profile:AddUserId(player.UserId)
		profile:Reconcile()

		profile:ListenToRelease(function()
			Profiles[player] = nil

			player:Kick()
		end)

		if not player:IsDescendantOf(Players) then
			profile:Release()
		else
			Profiles[player] = profile

			print(Profiles[player].Data)
		end
	else
		player:Kick()
	end
end

function PlayerDataHandler:Init()
	for _, player in game.Players:GetPlayers() do
		task.spawn(playerAdded, player)
	end

	game.Players.PlayerAdded:Connect(playerAdded)

	game.Players.PlayerRemoving:Connect(function(player)
		if Profiles[player] then
			Profiles[player]:Release()
		end
	end)
end

local function getProfile(player: Player)
	assert(Profiles[player], string.format("profile does not exist for %s", player.UserId))

	return Profiles[player]
end

function PlayerDataHandler:Get(player: Player, key: string)
	local profile = getProfile(player)

	assert(profile.Data[key], string.format("data does not exist for key: %s", key))

	return profile.Data[key]
end

function PlayerDataHandler:Set(player: Player, key: string, value: any)
	local profile = getProfile(player)

	assert(profile.Data[key], string.format("data does not exist for key: %s", key))

	assert(type(profile.Data[key]) == type(value), string.format("data is wrong type for key: %s", key))

	profile.Data[key] = value
end

function PlayerDataHandler:Update(player: Player, key: string, callback)
	local profile = getProfile(player)

	local oldData = self:Get(player, key)
	local newData = callback(oldData)

	self:Set(player, key, newData)
end

return PlayerDataHandler
