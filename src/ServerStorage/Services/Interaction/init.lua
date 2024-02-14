local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local InteractionService = Knit.CreateService({
    Name = "InteractionService"
})

function InteractionService:KnitStart() end

function InteractionService:KnitInit() end

function InteractionService:CreateProximityPrompt(proxPromptParams: table)

    local ProximityPrompt = Instance.new("ProximityPrompt")

    for key, child in pairs(proxPromptParams) do
        ProximityPrompt[key] = child
    end

    return ProximityPrompt
end

return InteractionService