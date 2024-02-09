local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Profile = require(ServerScriptService.Source.Profile)

local function FindPlayer(player, list)
    local playerIndex
    for index, profile in ipairs(list) do
        if profile.Player == player then
            playerIndex = index
            return playerIndex
        end
    end
    print(player, "not found")
    return nil
end

local PlayerProfileService = Knit.CreateService({
    Name = "PlayerProfileService",
    Profiles = {}
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
    table.insert(self.Profiles, newProfile)
end

function PlayerProfileService:RemoveProfile(player) 
    local indexToRemove = FindPlayer(player, self.Profiles)

    if indexToRemove then
        table.remove(self.Profiles, indexToRemove)
    end

    print(self.Profiles)
end

function PlayerProfileService:GetProp(profile, prop)
    local playerIndex = FindPlayer(profile, self.Profiles)

    if playerIndex == nil then
        return
    end

    return self.Profiles[playerIndex][prop]
end

function PlayerProfileService:AssignQuest(profile, quest)
    local playerIndex = FindPlayer(profile, self.Profiles)
    local player

    if playerIndex == nil then
        print(playerIndex, " not found")
        return
    end

    player = self.Profiles[playerIndex]

    player.Quest = quest
    player.HasQuest = true
end

function PlayerProfileService:RemoveQuest(profile)
    local playerIndex = FindPlayer(profile, self.Profiles)
    local player

    if playerIndex == nil then
        print(playerIndex, " not found")
        return
    end

    player = self.Profiles[playerIndex]

    player.Quest = {}
    player.HasQuest = false
end

function PlayerProfileService:IncreaseSolved(profile)
    local playerIndex = FindPlayer(profile, self.Profiles)
    local currentProfile = self.Profiles[playerIndex]

    if playerIndex == nil then
        return
    end

    currentProfile.Solved += 1
    currentProfile.Player:FindFirstChild("leaderstats").Solved.Value = currentProfile.Solved
    currentProfile.Player:FindFirstChild("leaderstats").Rewards.Value += currentProfile.Quest.reward
end

return PlayerProfileService