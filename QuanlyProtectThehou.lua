local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KaitunUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 99
ScreenGui.Parent = PlayerGui

local FullBlack = Instance.new("Frame")
FullBlack.Size = UDim2.new(1, 0, 1, 36)
FullBlack.Position = UDim2.new(0, 0, -0.03, 0)
FullBlack.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
FullBlack.BorderSizePixel = 0
FullBlack.ZIndex = 19999999
FullBlack.BackgroundTransparency = 1
FullBlack.Parent = ScreenGui

local Image = Instance.new("ImageLabel")
Image.Size = UDim2.new(0, 100, 0, 100)
Image.Position = UDim2.new(0.5, -50, 0.5, -90)
Image.BackgroundTransparency = 1
Image.Image = "rbxthumb://type=Asset&id=131484641795167&w=420&h=420"
Image.ZIndex = 29999999
Image.Parent = ScreenGui

local Version = Instance.new("TextLabel")
Version.AnchorPoint = Vector2.new(0.5, 0.5)
Version.Position = UDim2.new(0.5, 0, 0.5, 40)
Version.Size = UDim2.new(0, 600, 0, 50)
Version.BackgroundTransparency = 1
Version.Text = "Aura Hub"
Version.Font = Enum.Font.PermanentMarker
Version.TextSize = 55
Version.TextColor3 = Color3.fromRGB(255, 255, 255)
Version.ZIndex = 39999999
Version.Parent = ScreenGui

task.spawn(function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local hrp

local function setupCharacter(character)
    hrp = character:WaitForChild("HumanoidRootPart")
end

if player.Character then
    setupCharacter(player.Character)
end
player.CharacterAdded:Connect(setupCharacter)

local function getAllGoldcoins()
    local coins = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and string.find(string.lower(obj.Name), "goldcoin") then
            table.insert(coins, obj)
        end
    end
    return coins
end

RunService.RenderStepped:Connect(function()
    if hrp then
        local coins = getAllGoldcoins()
        for _, coin in ipairs(coins) do
            if coin and coin.Parent then
                hrp.CFrame = coin.CFrame + Vector3.new(0, 0, 0)
            end
        end
    end
end)
end)
task.spawn(function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local function getAliveMobs()
    local mobs = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 and not Players:GetPlayerFromCharacter(obj) then
            table.insert(mobs, obj)
        end
    end
    return mobs
end

local function aimAtHead(mob)
    local head = mob:FindFirstChild("Head")
    if head then
        local direction = (head.Position - camera.CFrame.Position).Unit
        camera.CFrame = CFrame.new(camera.CFrame.Position, head.Position)
    end
end

RunService.RenderStepped:Connect(function()
    local mobs = getAliveMobs()
    if #mobs > 0 then
        local closest = mobs[1]
        local minDist = (camera.CFrame.Position - closest.PrimaryPart.Position).Magnitude
        for _, mob in ipairs(mobs) do
            if mob.PrimaryPart then
                local dist = (camera.CFrame.Position - mob.PrimaryPart.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = mob
                end
            end
        end
        aimAtHead(closest)
    end
end)
    end)
