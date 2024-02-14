local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local function PickUpItem(player, item) 
    local backpack = player.Backpack
    local clonedItem: Instance = item:Clone()
    clonedItem.Parent = backpack
    clonedItem:FindFirstChild("Handle").ProximityPrompt:Destroy()
end

local Item = {}
Item.__index = Item

function Item.new(owner)
    local self = setmetatable({}, Item)
    self.Owner = owner
    return self
end

function Item:Init()
    self.Owner.CanBeDropped = false
    self.Owner.Handle.TouchInterest:Destroy()

    local InteractionService = Knit.GetService("InteractionService")
    local ProximityPrompt = InteractionService:CreateProximityPrompt({ActionText = "Take item", Parent = self.Owner.Handle})

    ProximityPrompt.Triggered:Connect(function(playerWhoTriggered)
        local item = self.Owner
        local PlayerProfileService = Knit.GetService("PlayerProfileService")
        local quest = PlayerProfileService:GetProp(playerWhoTriggered, "Quest")

        if quest.objective == item and not PlayerProfileService:HasItem(playerWhoTriggered, quest.objective.Name) then
            PickUpItem(playerWhoTriggered, item)
         end
    end)
end

return Item