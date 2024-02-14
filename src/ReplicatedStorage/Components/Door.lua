local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Door = {}
Door.__index = Door

function Door.new(owner)
    local self = setmetatable({}, Door)
    self.Owner = owner
    return self
end

function Door:Init()
    local QuestService = Knit.GetService("QuestService")
    local InteractionService = Knit.GetService("InteractionService")
    local ProximityPrompt = InteractionService:CreateProximityPrompt({ActionText = "Open door", Parent = self.Owner.PrimaryPart})

    ProximityPrompt.Triggered:Connect(function(playerWhoTriggered)
        QuestService:StartMinigame(playerWhoTriggered)
        print("Starting minigame for ", playerWhoTriggered)
    end)

end

return Door