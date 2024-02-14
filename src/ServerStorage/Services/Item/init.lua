local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Item = require(ReplicatedStorage.Source.Components.Item)

local ItemService = Knit.CreateService({
    Name = "ItemService"
})

function ItemService:KnitStart() end

function ItemService:KnitInit()
    for _, item in pairs(CollectionService:GetTagged("Item")) do
        local itemInstance = Item.new(item)
        itemInstance:Init()
    end
end

return ItemService