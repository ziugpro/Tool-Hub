local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")
if not humanoid then return end

local function heavyLoadStep()
    local sum = 0
    for i = 1, 1e6 do
        for j = 1, 20  do
            sum = sum + math.sin(i * j)
        end
    end
    return sum
end

for step = 1, 1 do
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
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local player = game.Players.LocalPlayer

local flyUpLoop = false
local flyUpNightLoop = false
local connAllTime
local connNightOnly

Tab:AddToggle("Left", "Fly Up (All Time)", false, function(v)
    local character = player.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end

    flyUpLoop = v
    humanoid.PlatformStand = v

    if v then
        local ray = Ray.new(hrp.Position, Vector3.new(0, -1000, 0))
        local part, pos = workspace:FindPartOnRay(ray, hrp.Parent)
        local targetY = (part and pos.Y or hrp.Position.Y) + 30
        connAllTime = RunService.Heartbeat:Connect(function()
            if not flyUpLoop or not hrp.Parent then return end
            hrp.Velocity = Vector3.new(0, 0, 0)
            hrp.CFrame = CFrame.new(hrp.Position.X, targetY, hrp.Position.Z)
        end)
    else
        if connAllTime then connAllTime:Disconnect() end
    end
end)

Tab:AddToggle("Left", "Fly Up (Night Only)", false, function(v)
    local character = player.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end

    flyUpNightLoop = v
    if v then
        local currentTime = Lighting.ClockTime
        if currentTime >= 18 or currentTime < 6 then
            humanoid.PlatformStand = true
            local ray = Ray.new(hrp.Position, Vector3.new(0, -1000, 0))
            local part, pos = workspace:FindPartOnRay(ray, hrp.Parent)
            local targetY = (part and pos.Y or hrp.Position.Y) + 30
            connNightOnly = RunService.Heartbeat:Connect(function()
                if not flyUpNightLoop or not hrp.Parent then return end
                local t = Lighting.ClockTime
                if t >= 18 or t < 6 then
                    hrp.Velocity = Vector3.new(0, 0, 0)
                    hrp.CFrame = CFrame.new(hrp.Position.X, targetY, hrp.Position.Z)
                end
            end)
        else
            Tab:SetValue("Fly Up (Night Only)", false)
        end
    else
        if connNightOnly then connNightOnly:Disconnect() end
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
Tab:AddTextlabel("Right", "Esp")
local rs = game:GetService("RunService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer

Tab:AddToggle("Right", "ESP Player", false, function(v)
    local folder = game.CoreGui:FindFirstChild("PlayerESP") or Instance.new("Folder", game.CoreGui)
    folder.Name = "PlayerESP"

    if _G.PlayerESPConn then
        _G.PlayerESPConn:Disconnect()
        _G.PlayerESPConn = nil
    end
    folder:ClearAllChildren()

    if not v then return end

    _G.PlayerESPConn = rs.RenderStepped:Connect(function()
        folder:ClearAllChildren()
        local localHRP = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not localHRP then return end

        for _, player in pairs(players:GetPlayers()) do
            if player ~= localPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local distance = math.floor((hrp.Position - localHRP.Position).Magnitude)
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = player.Name .. "_ESP"
                    billboard.Adornee = hrp
                    billboard.Size = UDim2.new(0, 150, 0, 30)
                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                    billboard.AlwaysOnTop = true
                    billboard.LightInfluence = 0
                    billboard.MaxDistance = 10000
                    billboard.Parent = folder

                    local text = Instance.new("TextLabel")
                    text.BackgroundTransparency = 1
                    text.Size = UDim2.new(1, 0, 1, 0)
                    text.Text = distance .. " | " .. player.Name
                    text.TextColor3 = Color3.fromRGB(255, 255, 255)
                    text.TextStrokeTransparency = 0.5
                    text.TextStrokeColor3 = Color3.new(0, 0, 0)
                    text.TextScaled = true
                    text.Font = Enum.Font.GothamBold
                    text.Parent = billboard
                end
            end
        end
    end)
end)

Tab:AddToggle("Right", "ESP Mob", false, function(v)
    local folder = game.CoreGui:FindFirstChild("MobESP") or Instance.new("Folder", game.CoreGui)
    folder.Name = "MobESP"

    if _G.MobESPConn then
        _G.MobESPConn:Disconnect()
        _G.MobESPConn = nil
    end
    folder:ClearAllChildren()

    if not v then return end

    _G.MobESPConn = rs.RenderStepped:Connect(function()
        folder:ClearAllChildren()
        local localHRP = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not localHRP then return end

        for _, mob in pairs(workspace:GetDescendants()) do
            if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid") and not players:GetPlayerFromCharacter(mob) then
                local hrp = mob.HumanoidRootPart
                local distance = math.floor((localHRP.Position - hrp.Position).Magnitude)

                local billboard = Instance.new("BillboardGui")
                billboard.Name = mob.Name .. "_ESP"
                billboard.Adornee = hrp
                billboard.Size = UDim2.new(0, 150, 0, 30)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true
                billboard.LightInfluence = 0
                billboard.MaxDistance = 10000
                billboard.Parent = folder

                local text = Instance.new("TextLabel")
                text.BackgroundTransparency = 1
                text.Size = UDim2.new(1, 0, 1, 0)
                text.Text = mob.Name .. " | " .. tostring(distance) .. "m"
                text.TextColor3 = Color3.fromRGB(255, 255, 0)
                text.TextStrokeTransparency = 0.5
                text.TextStrokeColor3 = Color3.new(0, 0, 0)
                text.TextScaled = true
                text.Font = Enum.Font.GothamBold
                text.Parent = billboard
            end
        end
    end)
end)

Tab:AddToggle("Right", "ESP Item", false, function(v)
    local folder = game.CoreGui:FindFirstChild("ItemESP") or Instance.new("Folder", game.CoreGui)
    folder.Name = "ItemESP"

    if _G.ItemESPConn then
        _G.ItemESPConn:Disconnect()
        _G.ItemESPConn = nil
    end
    folder:ClearAllChildren()

    if not v then return end

    _G.ItemESPConn = rs.RenderStepped:Connect(function()
        folder:ClearAllChildren()
        local localHRP = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not localHRP then return end

        for _, item in pairs(workspace:GetDescendants()) do
            if item:IsA("Tool") or item.Name:lower():find("item") or item.Name:lower():find("loot") then
                local targetPart
                if item:IsA("Model") and item.PrimaryPart then
                    targetPart = item.PrimaryPart
                elseif item:IsA("BasePart") then
                    targetPart = item
                end

                if targetPart then
                    local distance = math.floor((localHRP.Position - targetPart.Position).Magnitude)
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = item.Name .. "_ESP"
                    billboard.Adornee = targetPart
                    billboard.Size = UDim2.new(0, 150, 0, 30)
                    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
                    billboard.AlwaysOnTop = true
                    billboard.LightInfluence = 0
                    billboard.MaxDistance = 10000
                    billboard.Parent = folder

                    local label = Instance.new("TextLabel")
                    label.BackgroundTransparency = 1
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.Text = item.Name .. " | " .. distance .. "m"
                    label.TextColor3 = Color3.fromRGB(0, 255, 255)
                    label.TextStrokeTransparency = 0.5
                    label.TextStrokeColor3 = Color3.new(0, 0, 0)
                    label.TextScaled = true
                    label.Font = Enum.Font.Gotham
                    label.Parent = billboard
                end
            end
        end
    end)
end)
Tab:RealLine("Right")
