--@script:client
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

for _, v in pairs(ReplicatedStorage.Source.Controllers:GetChildren()) do
    if not v:IsA("ModuleScript") then
        continue
    end

    require(v)
end

Knit.Start():andThen(function()
    print("Knit client started")
end):catch(warn)