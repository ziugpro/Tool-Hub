game.StarterGui:SetCore("SendNotification", {
    Title = "Aura Hub",
    Text = "Success Loading",
    Icon = "rbxthumb://type=Asset&id=111167393120231&w=420&h=420",
    Duration = 5,
    Callback = function()
    end
})
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")
if not humanoid then return end

local function heavyLoadStep()
    local sum = 0
    for i = 1, 1e6 do
        for j = 1, 10 do
            sum = sum + math.sin(i * j)
        end
    end
    return sum
end

for step = 1, 5 do
    task.spawn(function()
        heavyLoadStep()
    end)
    task.wait(1)
end
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
getgenv().Image = "rbxthumb://type=Asset&id=111167393120231&w=420&h=420"
getgenv().ToggleUI = "LeftControl"

task.spawn(function()
    if not getgenv().LoadedMobileUI then
        getgenv().LoadedMobileUI = true
        local OpenUI = Instance.new("ScreenGui")
        local ImageButton = Instance.new("ImageButton")
        local UICorner = Instance.new("UICorner")
        OpenUI.Name = "OpenUI"
        OpenUI.Parent = game:GetService("CoreGui")
        OpenUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ImageButton.Parent = OpenUI
        ImageButton.BackgroundColor3 = Color3.fromRGB(105, 105, 105)
        ImageButton.BackgroundTransparency = 0.8
        ImageButton.Position = UDim2.new(0, 5, 0, 5)
        ImageButton.Size = UDim2.new(0, 55, 0, 55)
        ImageButton.Image = getgenv().Image
        ImageButton.Draggable = true
        ImageButton.Transparency = 1
        UICorner.CornerRadius = UDim.new(0,10)
        UICorner.Parent = ImageButton
        ImageButton.MouseButton1Click:Connect(function()
            game:GetService("VirtualInputManager"):SendKeyEvent(true, getgenv().ToggleUI, false, game)
        end)
    end
end)

local SkUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ziugpro/Tool-Hub/refs/heads/main/Tool-Hub-Ui"))()

local UI = SkUI:CreateWindow("SkUI V1.73 - By Ziugpro")

local Tab = UI:Create(105, "General")

Tab:AddTextLabel("Left", "Main")
Tab:AddToggle("Left", "Auto Open Chest", false, function(v)
end)
Tab:AddSlider("Left", "Kill Range", 1, 50, 10, function(val)
    _G.killRange = val
end)

Tab:AddToggle("Left", "Kill Aura", false, function(enabled)
    if _G.killAuraConn then
        _G.killAuraConn:Disconnect()
        _G.killAuraConn = nil
    end

    if enabled then
        _G.killAuraConn = game:GetService("RunService").Heartbeat:Connect(function()
            local player = game.Players.LocalPlayer
            if not player or not player.Character or not player.Character:FindFirstChildOfClass("Humanoid") then return end
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            for _, target in pairs(game.Players:GetPlayers()) do
                if target ~= player and target.Character and target.Character:FindFirstChildOfClass("Humanoid") and target.Character:FindFirstChild("HumanoidRootPart") then
                    local targetHrp = target.Character.HumanoidRootPart
                    local distance = (hrp.Position - targetHrp.Position).Magnitude
                    if distance <= (_G.killRange or 10) then
                        target.Character.Humanoid.Health = 0
                    end
                end
            end
        end)
    end
end)
Tab:AddToggle("Left", "Fly Up", false, function(v)
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end

    if v then
        hrp.CFrame = hrp.CFrame + Vector3.new(0, 30, 0)
        humanoid.PlatformStand = true
    else
        humanoid.PlatformStand = false
    end
end)
Tab:AddToggle("Left", "Fly Up (Night Only)", false, function(v)
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end

    local Lighting = game:GetService("Lighting")
    local currentTime = Lighting.ClockTime

    if v then
        if currentTime >= 18 or currentTime < 6 then
            hrp.CFrame = hrp.CFrame + Vector3.new(0, 30, 0)
            humanoid.PlatformStand = true
        else
            Tab:SetValue("Fly Up (Night Only)", false)
        end
    else
        humanoid.PlatformStand = false
    end
end)
local noclipEnabled = false

Tab:AddToggle("Left", "Noclip", false, function(v)
    noclipEnabled = v
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return end

    local character = player.Character

    if noclipEnabled then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)
Tab:AddToggle("Left", "Infinity Jump", false, function(v)
    if _G.infinityJumpConn then
        _G.infinityJumpConn:Disconnect()
        _G.infinityJumpConn = nil
    end

    if v then
        _G.infinityJumpConn = game:GetService("UserInputService").JumpRequest:Connect(function()
            local player = game.Players.LocalPlayer
            if player and player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    end
end)
Tab:RealLine("Left")
Tab:AddTextLabel("Right", "Item")
local selectedModel = "Carrot"

Tab:AddMultiDropdown("Right", "Select Item", {"Carrot", "Old", "Tree", "Bunny"}, "Carrot", function(choice)
    selectedModel = choice
end)

Tab:AddButton("Right", "Bring Model", function()
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return end

    local model = workspace.Models:FindFirstChild(selectedModel)
    if model then
        local character = player.Character
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            model:SetPrimaryPartCFrame(rootPart.CFrame * CFrame.new(0, 0, -5))
        end
    end
end)
Tab:AddTextLabel("Right", "Local")
local speed = 50

Tab:AddSlider("Right", "Speed", 1, 300, 50, function(val)
    speed = val
end)

Tab:AddButton("Right", "Set Speed", function()
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return end

    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed
    end
end)
Tab:RealLine("Right")
