--@script:server

--Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

--Knit
local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.AddServices(ServerStorage.Source.Services)

Knit.Start():andThen(function() 
    print("Knit Server started")
end):catch(warn)