local Players = game:GetService("Players")

local LeaderboardHandler = require(game.ServerStorage:WaitForChild("LeaderboardHandler", 300))

Players.PlayerAdded:Connect(function(player: Player)
	task.wait(2)
	LeaderboardHandler:Init(player)
end)
