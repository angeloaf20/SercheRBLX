local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local QuestConfig = require(ReplicatedStorage.Source.Configs.QuestConfig)

local function GetObjective(location, tag)
    for _, child in pairs(location:GetChildren()) do
        if CollectionService:HasTag(child, tag) then
            return child
        end
    end
end

local function LoadInstances(tag) 
    local instances = {}
    for _, location in pairs(CollectionService:GetTagged(tag)) do
        table.insert(instances, location)
    end
    return instances
end

local QuestService = Knit.CreateService({
    Name = "QuestService",
    PlayerTriggered = nil,
    Client = {
        GivenQuest = Knit.CreateProperty(false),
        InfoGui = Knit.CreateSignal(),
        ShowMinigame = Knit.CreateSignal(),
    }
})

function QuestService:KnitStart()
    print("Quest service started")
end

function QuestService:KnitInit()
    print("Quest service initialized")
end

function QuestService:CreateQuest()

    local locations = LoadInstances("Location")
    local locationsIndex = math.random(1, #locations)
    local descIndex = math.random(1, #QuestConfig.descriptions)
    local randomReward = math.random(200, 1500)


    local newQuest = {
        description = QuestConfig.descriptions[descIndex],
        reward = randomReward,
        location = locations[locationsIndex],
        objective = GetObjective(locations[locationsIndex], "Item")
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

function QuestService:DeleteQuest(quest)
    quest = {}
end

function QuestService:UpdateInfoGUI(player, quest)
    self.Client.InfoGui:Fire(player, quest)
end

function QuestService:StartMinigame(player)
    self.Client.ShowMinigame:Fire(player)
end

return QuestService