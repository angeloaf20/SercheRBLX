local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Profile = require(ReplicatedStorage.Source.Components.Profile)

local function FindInList(target, prop: string, list)
    for index, key in ipairs(list) do
        if key[prop] == target then
            return index
        end
    end
    print(target, "not found")
    return nil
end


local PlayerProfileService = Knit.CreateService({
    Name = "PlayerProfileService",
    Profiles = {},
})

function PlayerProfileService:KnitStart()
    print("PlayerProfileService started")
end

function PlayerProfileService:KnitInit()
    print("PlayerProfileService initialized")

    Players.PlayerAdded:Connect(function(player)
        self:CreateProfile(player)
    end)

    Players.PlayerRemoving:Connect(function(player)
        self:RemoveProfile(player)
    end)
end

function PlayerProfileService:CreateProfile(player)
    local newProfile = Profile.new(player)
    print(newProfile.Player, newProfile.Quest)
    player:SetAttribute("HasQuest", false)
    table.insert(self.Profiles, newProfile)
end

function PlayerProfileService:RemoveProfile(targetPlayer) 
    local indexToRemove = FindInList(targetPlayer, "Player", self.Profiles)
    
    if indexToRemove then
        table.remove(self.Profiles, indexToRemove)
    end

    print(self.Profiles)
end

function PlayerProfileService:GetProp(targetPlayer, prop)
    local playerIndex = FindInList(targetPlayer, "Player", self.Profiles)

    if playerIndex == nil then
        print(playerIndex, " not found")
        return
    end

    local player = self.Profiles[playerIndex]

    return player[prop]
end

function PlayerProfileService:AssignQuest(targetPlayer, quest)
    local playerIndex = FindInList(targetPlayer, "Player", self.Profiles)

    if playerIndex == nil then
        print(playerIndex, " not found")
        return
    end

    local player = self.Profiles[playerIndex]

    player.Quest = quest
    player.Player:SetAttribute("HasQuest", true)
end

function PlayerProfileService:RemoveQuest(targetPlayer)
    local playerIndex = FindInList(targetPlayer, "Player", self.Profiles)

    if playerIndex == nil then
        print(playerIndex, " not found")
        return
    end

    local player = self.Profiles[playerIndex]

    player.Quest = {}
    player.Player:SetAttribute("HasQuest", false)
end

function PlayerProfileService:IncreaseSolved(targetPlayer)
    local playerIndex = FindInList(targetPlayer, "Player", self.Profiles)

    if playerIndex == nil then
        print(playerIndex, " not found")
        return
    end

    local player = self.Profiles[playerIndex]

    player.Solved += 1
    player.Player:FindFirstChild("leaderstats").Solved.Value = player.Solved
    player.Player:FindFirstChild("leaderstats").Rewards.Value += player.Quest.reward
end

function PlayerProfileService:HasItem(targetPlayer, itemName)
    local playerIndex = FindInList(targetPlayer, "Player", self.Profiles)

    if playerIndex == nil then
        print(playerIndex, " not found")
        return
    end

    local player = self.Profiles[playerIndex]

    local backpack = player.Player.Backpack
    local character = player.Player.Character

    if backpack:FindFirstChild(itemName) or (character and character:FindFirstChild(itemName)) then
        -- print(backpack:GetChildren())
        -- print(character:GetChildren())
        return true
    end

    return false
end

function PlayerProfileService:RemoveItem(targetPlayer, item)
    local playerIndex = FindInList(targetPlayer, "Player", self.Profiles)

    if playerIndex == nil then
        print(playerIndex, " not found")
        return
    end

    local player = self.Profiles[playerIndex]

    local backpack: Backpack = player.Player.Backpack
    local character = player.Player.Character
    
    if backpack:FindFirstChild(item) then
        backpack[item]:Destroy()
        print("Item", item, "removed from backpack of", player.Player.Name)
    elseif character and character:FindFirstChild(item) then
        character[item]:Destroy()
        print("Item", item, "removed from character of", player.Player.Name)
    else
        print("Item", item, "not found in backpack or character of", player.Player.Name)
    end
end

return PlayerProfileService