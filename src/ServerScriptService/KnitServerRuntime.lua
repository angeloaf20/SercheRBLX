--@script:server

--Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")

--Knit
local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.AddServices(ServerStorage.Source.Services)

function InitQuestGiver()

    for _, value in pairs(CollectionService:GetTagged("QuestGiver")) do


        if value.ProximityPrompt == nil then return end

        local ProximityPrompt: ProximityPrompt = value.ProximityPrompt

        ProximityPrompt.Triggered:Connect(function(playerWhoTriggered)
            local QuestService = Knit.GetService("QuestService")
            local PlayerProfileService = Knit.GetService("PlayerProfileService")
            local character = playerWhoTriggered.Character
            local backpack = playerWhoTriggered.Backpack
            QuestService.PlayerTriggered = playerWhoTriggered

            if PlayerProfileService:GetProp(playerWhoTriggered, "HasQuest") then
                local player = playerWhoTriggered
                local quest = PlayerProfileService:GetProp(player, "Quest")
                print(player, "already has a quest. Find the item.")
                print(quest)
                local item = quest.objective

                if playerWhoTriggered.Backpack == nil or playerWhoTriggered.Character == nil then return end

                if backpack:FindFirstChild(item.Name) or character:FindFirstChild(item.Name) then
                    print(player, "found the item")
                    item:Destroy()
                    PlayerProfileService:IncreaseSolved(player)
                    PlayerProfileService:RemoveQuest(player)
                    print(PlayerProfileService:GetProp(player, "Solved"))
                end

                return
            end

            QuestService:AssignQuest()
        end)
    end
end

function InitItem()
    for _, value:Tool in pairs(CollectionService:GetTagged("Item")) do


        value.CanBeDropped = false
        value.Handle.TouchInterest:Destroy()

        local ProximityPrompt = Instance.new("ProximityPrompt")
        ProximityPrompt.ActionText = "Pick up item"
        ProximityPrompt.Parent = value.Handle

        ProximityPrompt.Triggered:Connect(function(playerWhoTriggered)
            local PlayerProfileService = Knit.GetService("PlayerProfileService")
            local quest = PlayerProfileService:GetProp(playerWhoTriggered, "Quest")
            print(quest.objective)
            if quest.objective == value then
                local backpack = playerWhoTriggered.Backpack
                value.Parent =  backpack
                value.Handle.ProximityPrompt:Destroy()
            end
        end)
    end
end

Knit.Start():andThen(function() 
    print("Knit Server started")
    InitQuestGiver()
    InitItem()
end):catch(warn)