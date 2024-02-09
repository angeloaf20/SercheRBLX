local house1 = game.Workspace:FindFirstChild("Houses").House1
local house2 = game.Workspace:FindFirstChild("Houses").House2
local house3 = game.Workspace:FindFirstChild("Houses").House3
local house4 = game.Workspace:FindFirstChild("Houses").House4
local house5 = game.Workspace:FindFirstChild("Houses").House5

return {
    descriptions = {
        "I have a vendetta against this person. Get me the item.",
        "No reason I just want this item.",
        "You'll find out why I need this later.",
        "Get this item and we both win.",
        "I need this ASAP."
    },

    objectives = {
        house1.Item,
        house2.Item,
        house3.Item,
        house4.Item,
        house5.Item
    },

    rewards = {
        500,
        1000,
        200,
        650,
        880
    },

    locations = {
        house1,
        house2,
        house3,
        house4,
        house5
    }
}