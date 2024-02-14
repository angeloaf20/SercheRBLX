local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local function PopulateTypes(componentFolder) 
    local npcComponents = {}
    for _, npc in pairs(componentFolder) do
        if npc:IsA("ModuleScript") then
            npcComponents[npc.Name] = require(npc)
        end
    end

    return npcComponents
end

local NPCService = Knit.CreateService({
    Name = "NPCService",
})

function NPCService:KnitStart()
    print("Starting NPCService")
end

function NPCService:KnitInit()
    local npcTypes = PopulateTypes(ReplicatedStorage.Source.Components.NPC:GetChildren())

    for npcTag, componentMod in pairs(npcTypes) do
        for _, npc in pairs(CollectionService:GetTagged(npcTag)) do
            local npcInstance = componentMod.new(npc)
            npcInstance:Init()
        end
    end
end

return NPCService