local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local accessoriesFolder = RS:FindFirstChild(player.Name .. "_SavedAccessories")
if not accessoriesFolder then
	accessoriesFolder = Instance.new("Folder")
	accessoriesFolder.Name = player.Name .. "_SavedAccessories"
	accessoriesFolder.Parent = RS
end

local toggle = false

local function toggleAccessories()
	local char = player.Character or player.CharacterAdded:Wait()
	if not char then return end

	if toggle == false then
		for _, v in ipairs(char:GetChildren()) do
			if v:IsA("Accessory") then
				v.Parent = accessoriesFolder
			end
		end
		toggle = true
	else
		for _, v in ipairs(accessoriesFolder:GetChildren()) do
			v.Parent = char
		end
		toggle = false
	end
end

player.CharacterAdded:Connect(function(char)
	task.wait(1)
	if toggle then
		for _, v in ipairs(char:GetChildren()) do
			if v:IsA("Accessory") then
				v.Parent = accessoriesFolder
			end
		end
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

local idBox = Instance.new("TextBox")
idBox.Size = UDim2.new(0, 120, 1, 0)
idBox.Position = UDim2.new(0, 280, 0, 0)
idBox.Text = ""
idBox.PlaceholderText = "Anim ID"
idBox.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
idBox.TextColor3 = Color3.fromRGB(255, 255, 255)
idBox.ClearTextOnFocus = false
idBox.Parent = frame

accButton.MouseButton1Click:Connect(toggleAccessories)

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
