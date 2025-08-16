game.StarterGui:SetCore("SendNotification", {
    Title = "Aura Hub",
    Text = "Success Loading",
    Icon = "rbxthumb://type=Asset&id=83230952715744&w=420&h=420",
    Duration = 5,
    Callback = function()
    end
})
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
getgenv().Image = "rbxthumb://type=Asset&id=83230952715744&w=420&h=420"
getgenv().ToggleUI = "MouseButton1"

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
local uilibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/ziugpro/Tool-Hub/refs/heads/main/rac.txt"))()
local windowz = uilibrary:CreateWindow("Aura Hub", "Premium", true)

local Page1 = windowz:CreatePage("General")


local AuraKill = Page1:CreateSection("Kill Aura")
_G.killRange = _G.killRange or 10
_G.killAuraConn = _G.killAuraConn or nil

AuraKill:CreateSlider("Kill Range", {Min = 1, Max = 50, DefaultValue = _G.killRange}, function(val)
    _G.killRange = val
end)

AuraKill:CreateToggle("Kill Aura", {Toggled = false, Description = false}, function(enabled)
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
            for _, target in pairs(game.Players:GetPlayers()) do
                if target ~= player then
                    local targetChar = target.Character
                    if targetChar then
                        local targetHum = targetChar:FindFirstChildOfClass("Humanoid")
                        local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
                        if targetHum and targetHrp and (hrp.Position - targetHrp.Position).Magnitude <= range then
                            targetHum.Health = 0
                        end
                    end
                end
            end
        end)
    end
end)

--{ Phần Player }--
local Player = Page1:CreateSection("Player")
local noclipEnabled = false

Player:CreateToggle("Noclip", {Toggled = false, Description = false}, function(v)
    noclipEnabled = v
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return end
    local character = player.Character

    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = not v and true or false
        end
    end
end)

Player:CreateButton("Through Wall", function()
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    if not LocalPlayer then return end
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    if not RootPart then return end

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
    local StartTime = tick()
    local Connection
    Connection = RunService.RenderStepped:Connect(function()
        if tick() - StartTime >= DashDuration then
            BodyPosition:Destroy()
            if Connection then
                Connection:Disconnect()
            end
        end
    end)
end)

Player:CreateToggle("Infinity Jump", {Toggled = false, Description = false}, function(v)
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

Player:CreateToggle("No Shadows", {Toggled = false, Description = false}, function(v)
    _G.NoShadows = v
    if v then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("SpotLight") or obj:IsA("PointLight") or obj:IsA("SurfaceLight") then
                obj.Enabled = false
            end
        end
        if workspace:FindFirstChildOfClass("Terrain") then
            workspace.Terrain.CastShadow = false
        end
        local lighting = game:GetService("Lighting")
        lighting.GlobalShadows = false
        lighting.ShadowSoftness = 0
    else
        local lighting = game:GetService("Lighting")
        lighting.GlobalShadows = true
        lighting.ShadowSoftness = 0.5
    end
end)
local speed = 50

Player:CreateSlider("Speed", {Min = 1, Max = 300, DefaultValue = speed}, function(val)
    speed = val
end)

Player:CreateButton("Set Speed", function()
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed
    end
end)
local FlyUp = Page1:CreateSection("Fly Up")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local player = game.Players.LocalPlayer

local flyUpLoop = false
local flyUpNightLoop = false
local connAllTime
local connNightOnly

FlyUp:CreateToggle("Fly Up (All Time)", {Toggled = false, Description = false}, function(v)
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

FlyUp:CreateToggle("Fly Up (Night Only)", {Toggled = false, Description = false}, function(v)
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
            FlyUp:SetValue("Fly Up (Night Only)", false)
        end
    else
        if connNightOnly then connNightOnly:Disconnect() end
        humanoid.PlatformStand = false
    end
end)

local Tree = Page1:CreateSection("Tree")
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

Tree:CreateToggle("Auto Chop Tree", {Toggled = false, Description = false}, function(v)
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
local Fire = Page1:CreateSection("Camp")
local player = game.Players.LocalPlayer

Fire:CreateToggle("Auto Fire (Teleport)", {Toggled = false, Description = false}, function(v)
    _G.AutoLog = v
    if v then
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
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

Fire:CreateToggle("Auto Fire (Teleport - Coal)", {Toggled = false, Description = false}, function(v)
    _G.AutoCoal = v
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local originalPos = hrp and hrp.CFrame
    if v then
        while _G.AutoCoal do
            task.wait()
            for _, m in pairs(workspace:GetDescendants()) do
                if not _G.AutoCoal then break end
                if m:IsA("Model") and m.Name == "Coal" and m.PrimaryPart then
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
    end
end)

Fire:CreateToggle("Auto Cooked (Teleport)", {Toggled = false, Description = false}, function(v)
    _G.AutoMorsel = v
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local originalPos = hrp and hrp.CFrame
    if v then
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
    end
end)

Fire:CreateToggle("Auto Fire (Bring)", {Toggled = false, Description = false}, function(v)
    _G.BringLogs = v
    if v then
        while _G.BringLogs do
            task.wait()
            for _, m in pairs(workspace:GetDescendants()) do
                if not _G.BringLogs then break end
                if m:IsA("Model") and m.Name == "Log" and m.PrimaryPart then
                    m:SetPrimaryPartCFrame(CFrame.new(-0.5468149185180664, 7.632332801818848, 0.11174965649843216))
                    task.wait(0.2)
                end
            end
        end
    end
end)

Fire:CreateToggle("Auto Cooked (Bring)", {Toggled = false, Description = false}, function(v)
    _G.BringMorsels = v
    if v then
        while _G.BringMorsels do
            task.wait()
            for _, m in pairs(workspace:GetDescendants()) do
                if not _G.BringMorsels then break end
                if m:IsA("Model") and m.Name == "Morsel" and m.PrimaryPart then
                    m:SetPrimaryPartCFrame(CFrame.new(-0.5468149185180664, 7.632332801818848, 0.11174965649843216))
                    task.wait(0.2)
                end
            end
        end
    end
end)

Fire:CreateButton("Teleport To Camp", function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(0.5406733155250549, 12.499372482299805, -0.718663215637207)
    end
end)

local Create = Page1:CreateSection("Create")
local player = game.Players.LocalPlayer

Create:CreateToggle("Auto Log (Bring)", {Toggled = false, Description = false}, function(v)
    _G.CollectLogs = v
    if v then
        while _G.CollectLogs do
            task.wait()
            for _, m in pairs(workspace:GetDescendants()) do
                if not _G.CollectLogs then break end
                if m:IsA("Model") and m.Name == "Log" and m.PrimaryPart then
                    m:SetPrimaryPartCFrame(CFrame.new(20.82342529296875, 7.753311634063721, -5.534992694854736))
                    task.wait(0.2)
                end
            end
        end
    else
        _G.CollectLogs = false
    end
end)

Create:CreateToggle("Auto Bolt (Bring)", {Toggled = false, Description = false}, function(v)
    _G.CollectBolt = v
    if v then
        while _G.CollectBolt do
            task.wait()
            for _, m in pairs(workspace:GetDescendants()) do
                if not _G.CollectBolt then break end
                if m:IsA("Model") and m.Name == "Bolt" and m.PrimaryPart then
                    m:SetPrimaryPartCFrame(CFrame.new(20.82342529296875, 7.753311634063721, -5.534992694854736))
                    task.wait(0.2)
                end
            end
        end
    else
        _G.CollectBolt = false
    end
end)

Create:CreateToggle("Auto Log (Teleport)", {Toggled = false, Description = false}, function(v)
    _G.AutoLogs = v
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local originalPos = hrp and hrp.CFrame
    if v then
        while _G.AutoLogs do
            task.wait()
            for _, m in pairs(workspace:GetDescendants()) do
                if not _G.AutoLogs then break end
                if m:IsA("Model") and m.Name == "Log" and m.PrimaryPart then
                    if hrp then
                        hrp.CFrame = m.PrimaryPart.CFrame
                        m:SetPrimaryPartCFrame(CFrame.new(20.82342529296875, 7.753311634063721, -5.534992694854736))
                        task.wait(0.2)
                    end
                end
            end
        end
        if hrp and originalPos then
            hrp.CFrame = originalPos
        end
    else
        _G.AutoLogs = false
    end
end)

Create:CreateToggle("Auto Bolt (Teleport)", {Toggled = false, Description = false}, function(v)
    _G.AutoBolts = v
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local originalPos = hrp and hrp.CFrame
    if v then
        while _G.AutoBolts do
            task.wait()
            for _, m in pairs(workspace:GetDescendants()) do
                if not _G.AutoBolts then break end
                if m:IsA("Model") and m.Name == "Bolt" and m.PrimaryPart then
                    if hrp then
                        hrp.CFrame = m.PrimaryPart.CFrame
                        m:SetPrimaryPartCFrame(CFrame.new(20.82342529296875, 7.753311634063721, -5.534992694854736))
                        task.wait(0.2)
                    end
                end
            end
        end
        if hrp and originalPos then
            hrp.CFrame = originalPos
        end
    else
        _G.AutoBolts = false
    end
end)
