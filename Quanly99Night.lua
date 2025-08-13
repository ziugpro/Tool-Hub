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
local SkUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ziugpro/Tool-Hub/refs/heads/main/Tool-Hub-Ui"))()

local UI = SkUI:CreateWindow("SkUI V1.73 - By Ziugpro")

local Tab = UI:Create(105, "General")

Tab:AddTextLabel("Left", "Chest")
Tab:AddToggle("Left", "Auto Open Chest", false, function(v)
end)
Tab:AddTextLabel("Left", "Kill")
_G.killRange = _G.killRange or 10
_G.killAuraConn = _G.killAuraConn or nil

Tab:AddSlider("Left", "Kill Range", 1, 50, _G.killRange, function(val)
    _G.killRange = val
end)

Tab:AddToggle("Left", "Kill Aura", false, function(enabled)
    if _G.killAuraConn then
        _G.killAuraConn:Disconnect()
        _G.killAuraConn = nil
    end

    if enabled then
        local player = game.Players.LocalPlayer
        if not player then return end
        _G.killAuraConn = game:GetService("RunService").Heartbeat:Connect(function()
            local char = player.Character
            if not char then return end
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not humanoid or not hrp then return end

            local range = _G.killRange or 10
            local players = game.Players:GetPlayers()

            for i = 1, #players do
                local target = players[i]
                if target ~= player then
                    local targetChar = target.Character
                    if targetChar then
                        local targetHum = targetChar:FindFirstChildOfClass("Humanoid")
                        local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
                        if targetHum and targetHrp then
                            if (hrp.Position - targetHrp.Position).Magnitude <= range then
                                targetHum.Health = 0
                            end
                        end
                    end
                end
            end
        end)
    end
end)
Tab:AddTextLabel("Left", "Fly Up")
local flyUpLoop = false
local flyUpNightLoop = false
Tab:AddToggle("Left", "Fly Up (All Time)", false, function(v)
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end

    flyUpLoop = v
    humanoid.PlatformStand = v

    spawn(function()
        while flyUpLoop and hrp.Parent do
            hrp.CFrame = hrp.CFrame + Vector3.new(0, 30, 0)
            wait(0.03)
        end
    end)
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
            flyUpNightLoop = true
            humanoid.PlatformStand = true

            spawn(function()
                while flyUpNightLoop and hrp.Parent do
                    hrp.CFrame = hrp.CFrame + Vector3.new(0, 30, 0)
                    wait(0.03)
                end
            end)
        else
            Tab:SetValue("Fly Up (Night Only)", false)
        end
    else
        flyUpNightLoop = false
        humanoid.PlatformStand = false
    end
end)
Tab:AddTextLabel("Left", "Misc")
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
