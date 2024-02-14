local Profile = {}
Profile.__init = Profile

local function CreateLeaderboard(player: Player)
    local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

    return leaderstats
end

local function SetupLeaderboard(leaderstats, self)
    local Solved = Instance.new("IntValue")
    Solved.Name = "Solved"
    Solved.Value = self.Solved
    Solved.Parent = leaderstats

    local Rewards = Instance.new("IntValue")
    Rewards.Name = "Rewards"
    Rewards.Value = 0
    Rewards.Parent = leaderstats
end

function Profile.new(player: Player)
    local self = setmetatable({}, Profile)
    self.Player = player
    self.Quest = {}
    self.HasQuest = false
    self.Solved = 0

    local leaderstats = CreateLeaderboard(player)
    SetupLeaderboard(leaderstats, self)
    return self
end

return Profile