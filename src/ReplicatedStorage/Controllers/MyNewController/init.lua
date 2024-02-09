local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local MyNewController = Knit.CreateController({ 
    Name = "MyNewController",
})

function MyNewController:KnitStart()
    print("MyNewController controller start")
end

function MyNewController:KnitInit()
    print("MyNewController controller init")
end

return MyNewController