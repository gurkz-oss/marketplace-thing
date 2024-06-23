local LeaderboardHandler = {}

local PlayerDataHandler = require(game.ServerStorage:WaitForChild("PlayerDataHandler", 300))

type UpdateCallback = (oldValue: number) -> number

function LeaderboardHandler:Init(player: Player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local robuxSpent = Instance.new("IntValue")
	robuxSpent.Name = "Robux Spent"
	robuxSpent.Value = PlayerDataHandler:Get(player, "RobuxSpent")
	robuxSpent.Parent = leaderstats
end

function LeaderboardHandler:UpdateRobuxSpent(player: Player, callback: UpdateCallback)
	local oldData: number = PlayerDataHandler:Get(player, "RobuxSpent")
	local newData = callback(oldData)
	local playerLeaderstats = player.leaderstats

	PlayerDataHandler:Set(player, "RobuxSpent", newData)
	playerLeaderstats["Robux Spent"].Value = newData
end

function LeaderboardHandler:SetRobuxSpent(player: Player, value: number)
	local playerLeaderstats = player.leaderstats

	PlayerDataHandler:Set(player, "RobuxSpent", value)
	playerLeaderstats["Robux Spent"].Value = value
end

return LeaderboardHandler
