game.StarterGui:SetCore("SendNotification", {
    Title = "Aura Hub",
    Text = "Success Loading",
    Icon = "rbxthumb://type=Asset&id=131484641795167&w=420&h=420",
    Duration = 5,
    Callback = function()
    end
})
game.StarterGui:SetCore("SendNotification", {
    Title = "Aura Hub",
    Text = "Keybind: RightShift",
    Icon = "rbxthumb://type=Asset&id=131484641795167&w=420&h=420",
    Duration = 5,
    Callback = function()
    end
})
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
getgenv().Image = "rbxthumb://type=Asset&id=106019376492019&w=420&h=420"
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
        ImageButton.Position = UDim2.new(0, 20, 0, 25)
        ImageButton.Size = UDim2.new(0, 50, 0, 50)
        ImageButton.Image = getgenv().Image
        ImageButton.Draggable = true
        ImageButton.Transparency = 1
        UICorner.CornerRadius = UDim.new(0,13)
        UICorner.Parent = ImageButton
        ImageButton.MouseButton1Click:Connect(function()
            game:GetService("VirtualInputManager"):SendKeyEvent(true, getgenv().ToggleUI, false, game)
        end)
    end
end)
local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()
 
local Window = Library:CreateWindow{
    Title = `Aura Hub | {Library.Version}`,
    SubTitle = "by Ziugpro",
    TabWidth = 160,
    Size = UDim2.fromOffset(550, 380),
    Acrylic = true, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
}

local Tabs = {
    Esp = Window:CreateTab{
        Title = "Esp",
        Icon = "map-pin"
    },
    Main = Window:CreateTab{
        Title = "Main",
        Icon = "phosphor-users-bold"
    },
    Visual = Window:CreateTab{
        Title = "Visuals",
        Icon = "file"
    },
    Settings = Window:CreateTab{
        Title = "Settings",
        Icon = "settings"
    }
}
local Options = Library.Options
local Main = Tabs.Main:AddSection("Tree")
local AutoTree = Tabs.Main:CreateToggle("AutoTree", {Title = "Auto Cut Tree", Default = false })
AutoTree:OnChanged(function()
_G.AutoChopTP = v
        if v then
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            local originalPos = hrp and hrp.CFrame
            while _G.AutoChopTP do
                task.wait(0.3)
                local trees = {}
                for _, tree in pairs(workspace:GetDescendants()) do
                    if tree:IsA("Model") and tree.Name == "Small Tree" and tree.PrimaryPart then
                        table.insert(trees, tree)
                    end
                end
                for _, tree in ipairs(trees) do
                    if not _G.AutoChopTP then break end
                    if hrp and tree.PrimaryPart then
                        hrp.CFrame = tree.PrimaryPart.CFrame + Vector3.new(0,0,-3)
                        UIS.InputBegan:Fire({UserInputType=Enum.UserInputType.MouseButton1, Position=tree.PrimaryPart.Position}, false)
                        task.wait(0.1)
                        UIS.InputEnded:Fire({UserInputType=Enum.UserInputType.MouseButton1, Position=tree.PrimaryPart.Position}, false)
                        task.wait(0.5)
                    end
                end
            end
            if hrp and originalPos then
                hrp.CFrame = originalPos
            end
        else
            _G.AutoChopTP = false
    end
end)
Options.AutoTree:SetValue(false)
local Main = Tabs.Main:AddSection("Chest")

local AutoOpenChestNearToggle = Tabs.Main:CreateToggle("AutoChestNearby", {Title = "Auto Open Chest", Default = false })

AutoOpenChestNearToggle:OnChanged(function(value)
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    if not _G.AutoChestNearby then
        _G.AutoChestNearby = {running = false}
    end

    local function getPromptsInRange(range)
        local prompts = {}
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and string.find(obj.Name, "Item Chest") then
                local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    local dist = (humanoidRootPart.Position - part.Position).Magnitude
                    if dist <= range then
                        for _, p in ipairs(obj:GetDescendants()) do
                            if p:IsA("ProximityPrompt") then
                                table.insert(prompts, p)
                            end
                        end
                    end
                end
            end
        end
        return prompts
    end

    if value then
        if _G.AutoChestNearby.running then return end
        _G.AutoChestNearby.running = true
        task.spawn(function()
            while _G.AutoChestNearby.running do
                local prompts = getPromptsInRange(chestRange)
                for _, prompt in ipairs(prompts) do
                    fireproximityprompt(prompt, math.huge)
                end
                task.wait(0.5)
            end
        end)
    else
        _G.AutoChestNearby.running = false
    end
end)

Options.AutoChestNearby:SetValue(false)

local Main = Tabs.Main:AddSection("Cooked")
local AutoCookedTeleportToggle = Tabs.Main:CreateToggle("AutoMorsel", {Title = "Auto Cooked (Teleport)", Default = false })

AutoCookedTeleportToggle:OnChanged(function(value)
    if value then
        _G.AutoMorsel = true
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local originalPos = hrp and hrp.CFrame
        task.spawn(function()
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
        end)
    else
        _G.AutoMorsel = false
    end
end)

Options.AutoMorsel:SetValue(false)

local AutoCookedBringToggle = Tabs.Main:CreateToggle("BringMorsels", {Title = "Auto Cooked (Bring)", Default = false })

AutoCookedBringToggle:OnChanged(function(value)
    if value then
        _G.BringMorsels = true
        task.spawn(function()
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
        end)
    else
        _G.BringMorsels = false
    end
end)

Options.BringMorsels:SetValue(false)

local Main = Tabs.Main:AddSection("Camp")
local AutoFireTeleportLogToggle = Tabs.Main:CreateToggle("AutoLog", {Title = "Auto Fire (Teleport)", Default = false })

AutoFireTeleportLogToggle:OnChanged(function(value)
    if value then
        _G.AutoLog = true
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local originalPos = hrp and hrp.CFrame
        task.spawn(function()
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
        end)
    else
        _G.AutoLog = false
    end
end)

Options.AutoLog:SetValue(false)
local AutoFireTeleportCoalToggle = Tabs.Main:CreateToggle("AutoCoal", {Title = "Auto Fire (Teleport - Coal)", Default = false })

AutoFireTeleportCoalToggle:OnChanged(function(value)
    if value then
        _G.AutoCoal = true
        local player = game.Players.LocalPlayer
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local originalPos = hrp and hrp.CFrame
        task.spawn(function()
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
        end)
    else
        _G.AutoCoal = false
    end
end)

Options.AutoCoal:SetValue(false)
local AutoFireBringToggle = Tabs.Main:CreateToggle("BringLogs", {Title = "Auto Fire (Bring)", Default = false })

AutoFireBringToggle:OnChanged(function(value)
    if value then
        _G.BringLogs = true
        task.spawn(function()
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
        end)
    else
        _G.BringLogs = false
    end
end)

Options.BringLogs:SetValue(false)

local Main = Tabs.Visual:AddSection("Fly Up")

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local player = game.Players.LocalPlayer

local flyUpLoop = false
local flyUpNightLoop = false
local connAllTime
local connNightOnly

local FlyUpAllTimeToggle = Tabs.Visual:CreateToggle("FlyUpAllTime", {Title = "Fly Up (All Time)", Default = false })

FlyUpAllTimeToggle:OnChanged(function(value)
    local character = player.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end

    flyUpLoop = value
    humanoid.PlatformStand = value

    if value then
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

Options.FlyUpAllTime:SetValue(false)

local FlyUpNightOnlyToggle = Tabs.Visual:CreateToggle("FlyUpNightOnly", {Title = "Fly Up (Night Only)", Default = false })

FlyUpNightOnlyToggle:OnChanged(function(value)
    local character = player.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end

    flyUpNightLoop = value

    if value then
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
            FlyUpNightOnlyToggle:SetValue(false)
        end
    else
        if connNightOnly then connNightOnly:Disconnect() end
        humanoid.PlatformStand = false
    end
end)

Options.FlyUpNightOnly:SetValue(false)
local Main = Tabs.Visual:AddSection("Visual")

Tabs.Visual:CreateButton{
    Title = "Through Wall",
    Description = "",
    Callback = function()
        local Players = game:GetService("Players")
        local Workspace = game:GetService("Workspace")
        local RunService = game:GetService("RunService")

        local LocalPlayer = Players.LocalPlayer
        if not LocalPlayer then return end

        local Character = LocalPlayer.Character
        if not Character then
            Character = LocalPlayer.CharacterAdded:Wait()
        end

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
    end
}

local InfinityJumpToggle = Tabs.Visual:CreateToggle("InfinityJump", {Title = "Infinity Jump", Default = false})

InfinityJumpToggle:OnChanged(function(value)
    if _G.infinityJumpConn then
        _G.infinityJumpConn:Disconnect()
        _G.infinityJumpConn = nil
    end

    if value then
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

Options.InfinityJump:SetValue(false)
local Main = Tabs.Visual:AddSection("Speed")
local Speed = 50

local SpeedSlider = Tabs.Visual:CreateSlider("SpeedSlider", {
    Title = "Speed",
    Description = "",
    Default = 50,
    Min = 1,
    Max = 300,
    Rounding = 1,
    Callback = function(val)
        Speed = val
    end
})

local SetSpeedButton = Tabs.Visual:CreateButton{
    Title = "Set Speed",
    Description = "",
    Callback = function()
        local player = game.Players.LocalPlayer
        if not player or not player.Character then return end

        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Speed
        end
    end
}

local SpeedBoostToggle = Tabs.Visual:CreateToggle("SpeedBoost", {Title = "Speed Boost", Default = false})

SpeedBoostToggle:OnChanged(function(Value)
    _G.Speed100 = Value

    local player = game:GetService("Players").LocalPlayer
    if not player then return end

    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if _G.Speed100 then
        humanoid.WalkSpeed = 100
    else
        humanoid.WalkSpeed = 16
    end
end)

Options.SpeedBoost:SetValue(false)

local ESP_Toggle = Tabs.Esp:CreateToggle("ESP_Toggle", {Title = "ESP Player", Default = false})

ESP_Toggle:OnChanged(function()
    if ESP_Toggle.Value then
        for i, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                local head = player.Character:FindFirstChild("Head")
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if head and humanoid then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Adornee = head
                    billboard.AlwaysOnTop = true
                    billboard.Size = UDim2.new(0,120,0,50)
                    billboard.MaxDistance = math.huge
                    billboard.StudsOffset = Vector3.new(0,2,0)
                    billboard.Parent = game.CoreGui

                    local frame = Instance.new("Frame")
                    frame.Size = UDim2.new(1,0,0,5)
                    frame.Position = UDim2.new(0,0,1,0)
                    frame.BackgroundColor3 = Color3.new(0,1,0)
                    frame.BorderSizePixel = 0
                    frame.Parent = billboard

                    local textLabel = Instance.new("TextLabel")
                    textLabel.Text = player.Name
                    textLabel.Size = UDim2.new(1,0,1,0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.TextColor3 = Color3.new(1,0,0)
                    textLabel.TextScaled = true
                    textLabel.Parent = billboard

                    game:GetService("RunService").RenderStepped:Connect(function()
                        if humanoid.Health > 0 then
                            frame.Size = UDim2.new(humanoid.Health/humanoid.MaxHealth,0,0,5)
                        else
                            billboard:Destroy()
                        end
                    end)
                end
            end
        end
    else
        for _, gui in pairs(game.CoreGui:GetChildren()) do
            if gui:IsA("BillboardGui") then
                gui:Destroy()
            end
        end
    end
end)
Options.ESP_Toggle:SetValue(false)
local MobESP = Tabs.Esp:CreateToggle("MobESP", {Title = "ESP Mob", Default = false})

MobESP:OnChanged(function()
    if MobESP.Value then
        for i, mob in pairs(workspace:GetDescendants()) do
            if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                local hrp = mob.HumanoidRootPart
                local humanoid = mob.Humanoid

                local billboard = Instance.new("BillboardGui")
                billboard.Adornee = hrp
                billboard.AlwaysOnTop = true
                billboard.Size = UDim2.new(0,120,0,50)
                billboard.MaxDistance = math.huge
                billboard.StudsOffset = Vector3.new(0,2,0)
                billboard.Parent = game.CoreGui

                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1,0,0,5)
                frame.Position = UDim2.new(0,0,1,0)
                frame.BackgroundColor3 = Color3.new(0,1,0)
                frame.BorderSizePixel = 0
                frame.Parent = billboard

                local textLabel = Instance.new("TextLabel")
                textLabel.Text = mob.Name
                textLabel.Size = UDim2.new(1,0,1,0)
                textLabel.BackgroundTransparency = 1
                textLabel.TextColor3 = Color3.new(1,0,0)
                textLabel.TextScaled = true
                textLabel.Parent = billboard

                game:GetService("RunService").RenderStepped:Connect(function()
                    if humanoid.Health > 0 then
                        frame.Size = UDim2.new(humanoid.Health/humanoid.MaxHealth,0,0,5)
                    else
                        billboard:Destroy()
                    end
                end)
            end
        end
    else
        for _, gui in pairs(game.CoreGui:GetChildren()) do
            if gui:IsA("BillboardGui") then
                gui:Destroy()
            end
        end
    end
end)
Options.MobESP:SetValue(false)
local LogESP = Tabs.Esp:CreateToggle("LogESP", {Title = "ESP Log", Default = false})
LogESP:OnChanged(function()
    if LogESP.Value then
        for i, model in pairs(workspace:GetDescendants()) do
            if model:IsA("Model") and model.Name == "Log" and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
                local hrp = model.HumanoidRootPart
                local humanoid = model.Humanoid

                local billboard = Instance.new("BillboardGui")
                billboard.Adornee = hrp
                billboard.AlwaysOnTop = true
                billboard.Size = UDim2.new(0,120,0,50)
                billboard.MaxDistance = math.huge
                billboard.StudsOffset = Vector3.new(0,2,0)
                billboard.Parent = game.CoreGui

                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1,0,0,5)
                frame.Position = UDim2.new(0,0,1,0)
                frame.BackgroundColor3 = Color3.new(0,1,0)
                frame.BorderSizePixel = 0
                frame.Parent = billboard

                local textLabel = Instance.new("TextLabel")
                textLabel.Text = model.Name
                textLabel.Size = UDim2.new(1,0,1,0)
                textLabel.BackgroundTransparency = 1
                textLabel.TextColor3 = Color3.new(1,0,0)
                textLabel.TextScaled = true
                textLabel.Parent = billboard

                game:GetService("RunService").RenderStepped:Connect(function()
                    if humanoid.Health > 0 then
                        frame.Size = UDim2.new(humanoid.Health/humanoid.MaxHealth,0,0,5)
                    else
                        billboard:Destroy()
                    end
                end)
            end
        end
    else
        for _, gui in pairs(game.CoreGui:GetChildren()) do
            if gui:IsA("BillboardGui") then
                gui:Destroy()
            end
        end
    end
end)

Options.LogESP:SetValue(false)
local BoltESP = Tabs.Esp:CreateToggle("BoltESP", {Title = "ESP Bolt", Default = false})
BoltESP:OnChanged(function()
    if BoltESP.Value then
        for i, model in pairs(workspace:GetDescendants()) do
            if model:IsA("Model") and model.Name == "Bolt" and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
                local hrp = model.HumanoidRootPart
                local humanoid = model.Humanoid

                local billboard = Instance.new("BillboardGui")
                billboard.Adornee = hrp
                billboard.AlwaysOnTop = true
                billboard.Size = UDim2.new(0,120,0,50)
                billboard.MaxDistance = math.huge
                billboard.StudsOffset = Vector3.new(0,2,0)
                billboard.Parent = game.CoreGui

                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1,0,0,5)
                frame.Position = UDim2.new(0,0,1,0)
                frame.BackgroundColor3 = Color3.new(0,1,0)
                frame.BorderSizePixel = 0
                frame.Parent = billboard

                local textLabel = Instance.new("TextLabel")
                textLabel.Text = model.Name
                textLabel.Size = UDim2.new(1,0,1,0)
                textLabel.BackgroundTransparency = 1
                textLabel.TextColor3 = Color3.new(1,0,0)
                textLabel.TextScaled = true
                textLabel.Parent = billboard

                game:GetService("RunService").RenderStepped:Connect(function()
                    if humanoid.Health > 0 then
                        frame.Size = UDim2.new(humanoid.Health/humanoid.MaxHealth,0,0,5)
                    else
                        billboard:Destroy()
                    end
                end)
            end
        end
    else
        for _, gui in pairs(game.CoreGui:GetChildren()) do
            if gui:IsA("BillboardGui") then
                gui:Destroy()
            end
        end
    end
end)

Options.BoltESP:SetValue(false)
--{ Lưu Conifg }--
SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes{}
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()
