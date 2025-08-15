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
Tab:AddButton("Left", "Through Wall", function()
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")

    local LocalPlayer = Players.LocalPlayer
    if not LocalPlayer then
        return
    end

    local Character = LocalPlayer.Character
    if not Character then
        Character = LocalPlayer.CharacterAdded:Wait()
    end

    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    if not RootPart then
        return
    end

    local CurrentPosition = RootPart.Position
    local CurrentCFrame = RootPart.CFrame
    local FacingDirection = CurrentCFrame.LookVector

    local DashMagnitude = 30
    local DashOffset = Vector3.new(0, 1.25, 0)

    local DashVector = FacingDirection * DashMagnitude
    local Destination = CurrentPosition + DashVector + DashOffset

    local BodyPosition = Instance.new("BodyPosition")
    BodyPosition.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    BodyPosition.P = 1e5
    BodyPosition.D = 2000
    BodyPosition.Position = Destination
    BodyPosition.Parent = RootPart

    local DashDuration = 0.2
    local Connection = nil
    local StartTime = tick()

    Connection = RunService.RenderStepped:Connect(function()
        if tick() - StartTime >= DashDuration then
            BodyPosition:Destroy()
            if Connection then
                Connection:Disconnect()
            end
        end
    end)
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

Tab:AddMultiDropdown("Right", "Select Item", {"Carrot", "Morsel", "Tree", "Bunny", "Log", "Rife"}, "Carrot", function(choice)
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
Tab:AddTextLabel("Right", "Camp Fire")
Tab:AddToggle("Right", "Auto Fire (Teleport)", false, function(v)
    if v then
        _G.AutoLog = true
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local originalPos = hrp and hrp.CFrame
        while _G.AutoLog do
            task.wait()
            for _, m in pairs(workspace:GetDescendants()) do
                if not _G.AutoLog then break end
                if m:IsA("Model") and m.Name == "Log" and m.PrimaryPart then
                    if hrp then
                        hrp.CFrame = m.PrimaryPart.CFrame
                        m:SetPrimaryPartCFrame(CFrame.new(0.5406733155250549, 12.499372482299805, -0.718663215637207))
                        task.wait(0.2)
                    end
                end
            end
        end
        if hrp and originalPos then
            hrp.CFrame = originalPos
        end
    else
        _G.AutoLog = false
    end
end)

Tab:AddToggle("Right", "Auto Cooked (Teleport)", false, function(v)
    if v then
        _G.AutoMorsel = true
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local originalPos = hrp and hrp.CFrame
        while _G.AutoMorsel do
            task.wait()
            for _, m in pairs(workspace:GetDescendants()) do
                if not _G.AutoMorsel then break end
                if m:IsA("Model") and m.Name == "Morsel" and m.PrimaryPart then
                    if hrp then
                        hrp.CFrame = m.PrimaryPart.CFrame
                        m:SetPrimaryPartCFrame(CFrame.new(0.5406733155250549, 12.499372482299805, -0.718663215637207))
                        task.wait(0.2)
                    end
                end
            end
        end
        if hrp and originalPos then
            hrp.CFrame = originalPos
        end
    else
        _G.AutoMorsel = false
    end
end)
Tab:AddToggle("Right", "Auto Fire (Bring)", false, function(v)
    if v then
        _G.BringLogs = true
        while _G.BringLogs do
            task.wait()
            for _, m in pairs(workspace:GetDescendants()) do
                if not _G.BringLogs then break end
                if m:IsA("Model") and m.Name == "Log" and m.PrimaryPart then
                    m:SetPrimaryPartCFrame(CFrame.new(0.5406733155250549, 12.499372482299805, -0.718663215637207))
                    task.wait(0.2)
                end
            end
        end
    else
        _G.BringLogs = false
    end
end)

Tab:AddToggle("Right", "Auto Cooked (Bring)", false, function(v)
    if v then
        _G.BringMorsels = true
        while _G.BringMorsels do
            task.wait()
            for _, m in pairs(workspace:GetDescendants()) do
                if not _G.BringMorsels then break end
                if m:IsA("Model") and m.Name == "Morsel" and m.PrimaryPart then
                    m:SetPrimaryPartCFrame(CFrame.new(0.5406733155250549, 12.499372482299805, -0.718663215637207))
                    task.wait(0.2)
                end
            end
        end
    else
        _G.BringMorsels = false
    end
end)
Tab:AddButton("Right", "Teleport To Camp", function()
    local player = game.Players.LocalPlayer
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(0.5406733155250549, 12.499372482299805, -0.718663215637207)
    end
end)
Tab:AddText("Right", "Using Auto Fire and Auto Cooked Teleport will be more effective than Bring and Bring may be buggy")
Tab:AddTextLabel("Right", "Tree")
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

Tab:AddToggle("Right", "Auto Chop Tree", false, function(v)
    _G.AutoChop = v
    if v then
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local originalPos = hrp and hrp.CFrame
        while _G.AutoChop do
            task.wait()
            local trees = {}
            for _, m in pairs(workspace:GetDescendants()) do
                if m:IsA("Model") and m.Name == "Smell Tree" and m.PrimaryPart then
                    table.insert(trees, m)
                end
            end
            if #trees == 0 then break end
            for _, tree in ipairs(trees) do
                if not _G.AutoChop then break end
                if hrp and tree.PrimaryPart then
                    hrp.CFrame = tree.PrimaryPart.CFrame + Vector3.new(0, 0, -3)
                    UIS.InputBegan:Fire({UserInputType = Enum.UserInputType.MouseButton1}, false)
                    task.wait(1)
                end
            end
        end
        if hrp and originalPos then
            hrp.CFrame = originalPos
        end
    else
        _G.AutoChop = false
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
Tab:AddTextLabel("Right", "Esp")
Tab:AddToggle("Right", "🧍 Player ESP", false, function(v)
    _G.ToggleESPPlayers = v

    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local existingESP = char:FindFirstChild("SUPER_ESP_GUI")

                if v and not existingESP then
                    local ESPGui = Instance.new("BillboardGui")
                    ESPGui.Name = "SUPER_ESP_GUI"
                    ESPGui.Adornee = char:FindFirstChild("HumanoidRootPart")
                    ESPGui.Size = UDim2.new(0, 200, 0, 50)
                    ESPGui.StudsOffset = Vector3.new(0, 5, 0)
                    ESPGui.AlwaysOnTop = true
                    ESPGui.ResetOnSpawn = false
                    ESPGui.Parent = char

                    local BackgroundFrame = Instance.new("Frame")
                    BackgroundFrame.Name = "BackgroundFrame"
                    BackgroundFrame.Size = UDim2.new(1, 0, 1, 0)
                    BackgroundFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    BackgroundFrame.BackgroundTransparency = 0.5
                    BackgroundFrame.BorderSizePixel = 0
                    BackgroundFrame.Parent = ESPGui

                    local StrokeFrame = Instance.new("UIStroke")
                    StrokeFrame.Color = Color3.fromRGB(255, 85, 85)
                    StrokeFrame.Thickness = 2
                    StrokeFrame.Transparency = 0.1
                    StrokeFrame.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    StrokeFrame.Parent = BackgroundFrame

                    local Label = Instance.new("TextLabel")
                    Label.Name = "PlayerName"
                    Label.Size = UDim2.new(1, 0, 1, 0)
                    Label.Position = UDim2.new(0, 0, 0, 0)
                    Label.BackgroundTransparency = 1
                    Label.Text = "🧍 " .. player.DisplayName
                    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Label.TextStrokeTransparency = 0
                    Label.TextScaled = true
                    Label.Font = Enum.Font.GothamBold
                    Label.Parent = BackgroundFrame
                elseif not v and existingESP then
                    existingESP:Destroy()
                end
            end
        end
    end
end)
Tab:AddToggle("Right", "🤖 NPC ESP", false, function(v)
    _G.ToggleESPNPCs = v

    for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
            local isPlayerChar = false
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player.Character == model then
                    isPlayerChar = true
                    break
                end
            end

            local existingESP = model:FindFirstChild("SUPER_ESP_GUI")

            if v and not isPlayerChar and not existingESP then
                local ESPGui = Instance.new("BillboardGui")
                ESPGui.Name = "SUPER_ESP_GUI"
                ESPGui.Adornee = model:FindFirstChild("HumanoidRootPart")
                ESPGui.Size = UDim2.new(0, 200, 0, 50)
                ESPGui.StudsOffset = Vector3.new(0, 5, 0)
                ESPGui.AlwaysOnTop = true
                ESPGui.ResetOnSpawn = false
                ESPGui.Parent = model

                local BackgroundFrame = Instance.new("Frame")
                BackgroundFrame.Size = UDim2.new(1, 0, 1, 0)
                BackgroundFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                BackgroundFrame.BackgroundTransparency = 0.5
                BackgroundFrame.BorderSizePixel = 0
                BackgroundFrame.Parent = ESPGui

                local StrokeFrame = Instance.new("UIStroke")
                StrokeFrame.Color = Color3.fromRGB(255, 255, 0)
                StrokeFrame.Thickness = 2
                StrokeFrame.Transparency = 0.1
                StrokeFrame.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                StrokeFrame.Parent = BackgroundFrame

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 1, 0)
                Label.Position = UDim2.new(0, 0, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = "🤖 " .. model.Name
                Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                Label.TextStrokeTransparency = 0
                Label.TextScaled = true
                Label.Font = Enum.Font.GothamBold
                Label.Parent = BackgroundFrame

            elseif not v and existingESP then
                existingESP:Destroy()
            end
        end
    end
end)
Tab:AddToggle("Right", "ESP Mob/Animal", false, function(v)
    _G.ToggleESPMobs = v
    for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
            local isPlayerChar = false
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player.Character == model then
                    isPlayerChar = true
                    break
                end
            end
            local existingESP = model:FindFirstChild("SUPER_ESP_GUI")
            if v and not isPlayerChar and not existingESP then
                local ESPGui = Instance.new("BillboardGui")
                ESPGui.Name = "SUPER_ESP_GUI"
                ESPGui.Adornee = model:FindFirstChild("HumanoidRootPart")
                ESPGui.Size = UDim2.new(0, 200, 0, 50)
                ESPGui.StudsOffset = Vector3.new(0, 5, 0)
                ESPGui.AlwaysOnTop = true
                ESPGui.ResetOnSpawn = false
                ESPGui.Parent = model
                local BackgroundFrame = Instance.new("Frame")
                BackgroundFrame.Size = UDim2.new(1, 0, 1, 0)
                BackgroundFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                BackgroundFrame.BackgroundTransparency = 0.5
                BackgroundFrame.BorderSizePixel = 0
                BackgroundFrame.Parent = ESPGui
                local StrokeFrame = Instance.new("UIStroke")
                StrokeFrame.Color = Color3.fromRGB(255, 255, 0)
                StrokeFrame.Thickness = 2
                StrokeFrame.Transparency = 0.1
                StrokeFrame.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                StrokeFrame.Parent = BackgroundFrame
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 1, 0)
                Label.Position = UDim2.new(0, 0, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = "🐾 " .. model.Name
                Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                Label.TextStrokeTransparency = 0
                Label.TextScaled = true
                Label.Font = Enum.Font.GothamBold
                Label.Parent = BackgroundFrame
            elseif not v and existingESP then
                existingESP:Destroy()
            end
        end
    end
end)
Tab:RealLine("Right")
