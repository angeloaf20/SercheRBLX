-- local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local InteractionService = require(ServerStorage.Source.Services.Interaction)
local PlayerProfileService = require(ServerStorage.Source.Services.PlayerProfile)
local QuestService = Knit.GetService("QuestService")
local DoorService = Knit.GetService("DoorService")

local function GiveQuest(player) 
    QuestService.PlayerTriggered = player
    QuestService:AssignQuest()
    QuestService.Client.GivenQuest:Set(true)
    QuestService:UpdateInfoGUI(player, PlayerProfileService:GetProp(player, "Quest"))
end

local function FoundQuest(player, quest) 
    PlayerProfileService:IncreaseSolved(player)
    DoorService:CloseDoor(PlayerProfileService:GetProp(player, "Quest").location.Structure.Door)
    QuestService.Client.GivenQuest:Set(false)
    QuestService:UpdateInfoGUI(player, PlayerProfileService:GetProp(player, "Quest"))
    PlayerProfileService:RemoveItem(player, quest.objective.Name)
    PlayerProfileService:RemoveQuest(player)
    player:SetAttribute("FinishedMinigame", false)    
end

local QuestGiver = {}
QuestGiver.__index = QuestGiver

function QuestGiver.new(owner)
    local self = setmetatable({}, QuestGiver)
    self.Owner = owner
    return self
end

function QuestGiver:Init()
    local ProximityPrompt = InteractionService:CreateProximityPrompt({ActionText = "Talk to", Parent = self.Owner})

    ProximityPrompt.Triggered:Connect(function(playerWhoTriggered)

        if not playerWhoTriggered:GetAttribute("HasQuest") then
            GiveQuest(playerWhoTriggered)
            return
        end

        if playerWhoTriggered:GetAttribute("HasQuest") == true then
            local quest = PlayerProfileService:GetProp(playerWhoTriggered, "Quest")

            if not PlayerProfileService:HasItem(playerWhoTriggered, quest.objective.Name) then
                print("go find item")
            else 
                FoundQuest(playerWhoTriggered, quest)
            end
        end
    end)
end

return QuestGiver