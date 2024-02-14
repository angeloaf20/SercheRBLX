local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local directionY = 1

local function TouchKillLine(controller, gameFrame)
	local KillLine = gameFrame.KillLine 

	if not (controller.Position.Y.Scale + controller.Size.Y.Scale <= KillLine.Position.Y.Scale or 
		controller.Position.Y.Scale >= KillLine.Position.Y.Scale + KillLine.Size.Y.Scale) then		
		controller:Destroy()
	end
end

local function Move(controller, gameFrame, newMinigame) 

	if gameFrame.Controllers:FindFirstChild(controller.Name) == nil then return end

	local newPos = controller.Position.Y.Scale + (5 * directionY) 

	if newPos + controller.Size.Y.Scale >= 1 or newPos <= 0 then
		directionY = -directionY 
		newPos = math.clamp(newPos, 0, 1 - controller.Size.Y.Scale) 
	end

	controller:TweenPosition(UDim2.new(controller.Position.X.Scale, 0, newPos, 0), "Out", "Linear")


	UserInputService.InputBegan:Connect(function(_input)
		if _input.UserInputType == Enum.UserInputType.MouseButton1 and newMinigame.Parent ~= nil then
			TouchKillLine(controller, gameFrame)
			return 
		end
	end)


end

local function MoveKillLine(KillLine)
	local newPos = KillLine.Position.Y.Scale + (5 * directionY) 

	if newPos + KillLine.Size.Y.Scale >= 1 or newPos <= 0 then
		directionY = -directionY 
		newPos = math.clamp(newPos, 0, 1 - KillLine.Size.Y.Scale) 
	end

	KillLine:TweenPosition(UDim2.new(KillLine.Position.X.Scale, 0, newPos, 0), "Out", "Linear")
end

local function MinigameLogic(gameFrame, newMinigame)

	for _, child in pairs(gameFrame.Controllers:GetChildren()) do
		if child then
			Move(child, gameFrame, newMinigame)
			break
		end
	end

end

local MinigameController = Knit.CreateController {
    Name = "MinigameController",
}

function MinigameController:KnitStart()
    print("minigame controller started")
end

function MinigameController:KnitInit()
	print("minigame init")
	local QuestService = Knit.GetService("QuestService")
	local DoorService = Knit.GetService("DoorService")
	local UnlockMinigameGui = ReplicatedStorage.GUI:WaitForChild("UnlockMinigameGui")

	QuestService.ShowMinigame:Connect(function()
		print("got here")
		local newMinigame = UnlockMinigameGui:Clone()

		if game.Players.LocalPlayer:GetAttribute("HasQuest") == false or game.Players.LocalPlayer.PlayerGui:FindFirstChild("UnlockMinigameGui") ~= nil then print("minigame open") return end

		newMinigame.Parent = game.Players.LocalPlayer.PlayerGui
		local gameFrame = newMinigame:FindFirstChild("GameFrame")

		local connection

		local function onHeartbeat()
			if not gameFrame.Controllers:FindFirstChild("Controller1") and not gameFrame.Controllers:FindFirstChild("Controller2") and not gameFrame.Controllers:FindFirstChild("Controller3") then
				newMinigame:Destroy()
				game.Players.LocalPlayer:SetAttribute("FinishedMinigame", true)
				DoorService.OpenDoor:Fire(game.Players.LocalPlayer)
				game:GetService("SoundService").Unlock:Play()
				connection:Disconnect()
				return
			else
				MinigameLogic(gameFrame, newMinigame)

				while newMinigame ~= nil and newMinigame.Parent ~= nil do
					MoveKillLine(gameFrame.KillLine)
					task.wait(0.1)
				end
			end
		end
		
		connection = RunService.Heartbeat:Connect(onHeartbeat)
	end)

end

return MinigameController