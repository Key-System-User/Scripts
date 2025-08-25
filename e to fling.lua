local Config = {
    FlingHotkey = "C",
    HalfFlingHotkey = "V",
    Permanent = false
}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

for _, x in next, Config do
    if type(x) == "string" then
        Config[_] = x:upper()
    end
end

local function setupCharacter(Character)
    local Humanoid = Character:WaitForChild("Humanoid")
    local RootPart = Humanoid:WaitForChild("HumanoidRootPart")

    local function Fling(power)
        RootPart.Velocity = (RootPart.Velocity + Vector3.new(0, 50, 0)) + (RootPart.CFrame.LookVector * power)
        RootPart.RotVelocity = Vector3.new(
            math.random(200, 300), 
            math.random(-200, 300), 
            math.random(200, 300)
        )
    end

    local connection
    connection = UserInputService.InputBegan:Connect(function(Key, Typing)
        if not Typing then
            if Key.KeyCode == Enum.KeyCode[Config.FlingHotkey] then
                Fling(100)
            elseif Key.KeyCode == Enum.KeyCode[Config.HalfFlingHotkey] then
                Fling(50)
            end
        end
    end)

    if not Config.Permanent then
        Humanoid.Died:Connect(function()
            connection:Disconnect()
        end)
    end
end

if Player.Character then
    setupCharacter(Player.Character)
end

Player.CharacterAdded:Connect(setupCharacter)
