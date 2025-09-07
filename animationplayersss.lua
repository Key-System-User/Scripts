local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

local accessoriesFolder = RS:FindFirstChild(player.Name .. "_SavedAccessories")
if not accessoriesFolder then
    accessoriesFolder = Instance.new("Folder")
    accessoriesFolder.Name = player.Name .. "_SavedAccessories"
    accessoriesFolder.Parent = RS
end

local accToggle = false
local function toggleAccessories()
    local char = player.Character or player.CharacterAdded:Wait()
    if not char then return end
    if not accToggle then
        for _, v in ipairs(char:GetChildren()) do
            if v:IsA("Accessory") then
                v.Parent = accessoriesFolder
            end
        end
        accToggle = true
    else
        for _, v in ipairs(accessoriesFolder:GetChildren()) do
            v.Parent = char
        end
        accToggle = false
    end
end

player.CharacterAdded:Connect(function(char)
    task.wait(1)
    if accToggle then
        for _, v in ipairs(char:GetChildren()) do
            if v:IsA("Accessory") then
                v.Parent = accessoriesFolder
            end
        end
    end
end)

local savedParts = {HRP=nil, Humanoid=nil}
local toggleHRP = false
local toggleHumanoid = false

local function toggleHumanoidRootPart()
    local char = player.Character or player.CharacterAdded:Wait()
    if not char then return end
    if not toggleHRP then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            savedParts.HRP = hrp
            hrp.Parent = nil
        end
        toggleHRP = true
    else
        if savedParts.HRP and savedParts.HRP.Parent == nil then
            savedParts.HRP.Parent = char
        end
        savedParts.HRP = nil
        toggleHRP = false
    end
end

local function toggleHumanoidObj()
    local char = player.Character or player.CharacterAdded:Wait()
    if not char then return end
    if not toggleHumanoid then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            savedParts.Humanoid = hum
            hum.Parent = nil
        end
        toggleHumanoid = true
    else
        if savedParts.Humanoid and savedParts.Humanoid.Parent == nil then
            savedParts.Humanoid.Parent = char
        end
        savedParts.Humanoid = nil
        toggleHumanoid = false
    end
end

player.CharacterAdded:Connect(function(char)
    if toggleHRP and savedParts.HRP then
        savedParts.HRP.Parent = char
        savedParts.HRP = nil
        toggleHRP = false
    end
    if toggleHumanoid and savedParts.Humanoid then
        savedParts.Humanoid.Parent = char
        savedParts.Humanoid = nil
        toggleHumanoid = false
    end
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 40)
frame.Position = UDim2.new(0.5, -200, 0.9, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true
frame.Visible = false

local stopButton = Instance.new("TextButton")
stopButton.Size = UDim2.new(0, 80, 1, 0)
stopButton.Position = UDim2.new(0, 0, 0, 0)
stopButton.Text = "Stop Anim"
stopButton.BackgroundColor3 = Color3.fromRGB(90, 40, 40)
stopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stopButton.Parent = frame

local playButton = Instance.new("TextButton")
playButton.Size = UDim2.new(0, 80, 1, 0)
playButton.Position = UDim2.new(0, 80, 0, 0)
playButton.Text = "Play Anim"
playButton.BackgroundColor3 = Color3.fromRGB(40, 90, 40)
playButton.TextColor3 = Color3.fromRGB(255, 255, 255)
playButton.Parent = frame

local accButton = Instance.new("TextButton")
accButton.Size = UDim2.new(0, 120, 1, 0)
accButton.Position = UDim2.new(0, 160, 0, 0)
accButton.Text = "Toggle Accessories"
accButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
accButton.TextColor3 = Color3.fromRGB(255, 255, 255)
accButton.Parent = frame
accButton.MouseButton1Click:Connect(toggleAccessories)

local idBox = Instance.new("TextBox")
idBox.Size = UDim2.new(0, 120, 1, 0)
idBox.Position = UDim2.new(0, 280, 0, 0)
idBox.Text = ""
idBox.PlaceholderText = "Anim ID"
idBox.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
idBox.TextColor3 = Color3.fromRGB(255, 255, 255)
idBox.ClearTextOnFocus = false
idBox.Parent = frame

local function createOrUpdateAnimation(id)
    local anim = RS:FindFirstChild("Animation")
    if not anim then
        anim = Instance.new("Animation")
        anim.Name = "Animation"
        anim.Parent = RS
    end
    anim.AnimationId = "rbxassetid://" .. id
    return anim
end

local currentTrack
local function stopAnim()
    if currentTrack then
        currentTrack:Stop()
        currentTrack = nil
    end
end

stopButton.MouseButton1Click:Connect(stopAnim)

playButton.MouseButton1Click:Connect(function()
    local id = idBox.Text
    if id ~= "" then
        local char = player.Character or player.CharacterAdded:Wait()
        local humanoid = char:WaitForChild("Humanoid")
        local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
        local anim = createOrUpdateAnimation(id)
        stopAnim()
        currentTrack = animator:LoadAnimation(anim)
        currentTrack.Priority = Enum.AnimationPriority.Action
        currentTrack:Play()
    end
end)

player.CharacterAdded:Connect(stopAnim)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.PageDown then
        frame.Visible = not frame.Visible
    elseif input.KeyCode == Enum.KeyCode.F8 then
        toggleAccessories()
    elseif input.KeyCode == Enum.KeyCode.F7 then
        toggleHumanoidRootPart()
    elseif input.KeyCode == Enum.KeyCode.F6 then
        toggleHumanoidObj()
    end
end)
