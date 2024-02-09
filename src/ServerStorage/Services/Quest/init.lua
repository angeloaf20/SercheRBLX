local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Knit = require(ReplicatedStorage.Packages.Knit)
local QuestConfig = require(ServerScriptService.Source.QuestConfig)

local QuestService = Knit.CreateService({
    Name = "QuestService",
    PlayerTriggered = nil
})

function QuestService:KnitStart()
    print("Quest service started")
end

function QuestService:KnitInit()
    print("Quest service initialized")
end

function QuestService:CreateQuest()

    local descIndex = math.random(1, #QuestConfig.descriptions)
    local rewardIndex = math.random(1, #QuestConfig.rewards)
    local locationIndex = math.random(1, #QuestConfig.locations)

    local newQuest = {
        description = QuestConfig.descriptions[descIndex],
        objective = QuestConfig.objectives[locationIndex],
        reward = QuestConfig.rewards[rewardIndex],
        location = QuestConfig.locations[locationIndex]
    }

    return newQuest
end

function QuestService:StartQuest()
    --start timer or something
end

function QuestService:EndQuest()
    
end

function QuestService:AssignQuest()
    local playerTrig: Player = self.PlayerTriggered
    local PlayerProfileService = Knit.GetService("PlayerProfileService")

    PlayerProfileService:AssignQuest(playerTrig, self:CreateQuest())
end

return QuestService