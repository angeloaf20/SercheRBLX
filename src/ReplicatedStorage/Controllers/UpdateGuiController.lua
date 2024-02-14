local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local function CreateHighlight(location) 
    local Highlight = Instance.new("Highlight")
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.FillColor = Color3.new(1, 1, 1)
    Highlight.FillTransparency = 1
    Highlight.OutlineColor = Color3.new(1, 1, 1)
    Highlight.Parent = location
end
    
local function RemoveHighlight(location) 
    location:FindFirstChild("Highlight"):Destroy()
end

local UpdateGuiController = Knit.CreateController {
    Name = "UpdateGuiController"
}

function UpdateGuiController:KnitStart()
    print("UpdateGuiController started")
end

function UpdateGuiController:KnitInit()
    print("Update gui INIT")
    local QuestService = Knit.GetService("QuestService")
    local QuestGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("QuestGui")

    QuestService.InfoGui:Connect(function(quest)
        if QuestService.GivenQuest:Get() then
            QuestGui:FindFirstChild("MainQuestFrame").CurrentReward.Text = quest.reward
            QuestGui:FindFirstChild("MainQuestFrame").CurrentDescription.Text = `Go find the {quest.objective}`
            CreateHighlight(quest.location)  
        else
            RemoveHighlight(quest.location)  
            QuestGui:FindFirstChild("MainQuestFrame").CurrentReward.Text = 0
            QuestGui:FindFirstChild("MainQuestFrame").CurrentDescription.Text = "None"
        end
    end)
end

return UpdateGuiController