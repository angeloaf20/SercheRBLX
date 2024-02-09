--@script:client
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)


Knit.Start():andThen(function()
    print("Knit client started")
    Knit.AddControllers(script.Parent.Controllers)

end):catch(warn)