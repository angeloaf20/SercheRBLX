local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Door = require(ReplicatedStorage.Source.Components.Door)

local DoorService = Knit.CreateService {
    Name = "DoorService",
    Opener = {},
    Client = {
        OpenDoor = Knit.CreateSignal()
    }
}

function DoorService:KnitStart()
    print("Door service started")
end

function DoorService:KnitInit()
    local newDoor

    for _, door in pairs(CollectionService:GetTagged("Door")) do
        newDoor = Door.new(door)
        newDoor:Init()
    end

    self:OpenDoor()
end

function DoorService:OpenDoor()
    local PlayerProfileService = Knit.GetService("PlayerProfileService")
    self.Client.OpenDoor:Connect(function(player)
        print(player)
        local door = PlayerProfileService:GetProp(player, "Quest").location.Structure.Door
        door.PrimaryPart.ProximityPrompt.Enabled = false
        door.PrimaryPart.Transparency = 1
        door.DoorHandle.Transparency = 1
        door.PrimaryPart.CanCollide = false
    end)
end

function DoorService:CloseDoor(door)
    door.PrimaryPart.ProximityPrompt.Enabled = true
    door.PrimaryPart.Transparency = 0
    door.DoorHandle.Transparency = 0
    door.PrimaryPart.CanCollide = true
end

return DoorService