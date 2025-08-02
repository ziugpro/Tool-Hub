game.StarterGui:SetCore("SendNotification", {
    Title = "Aura Hub",
    Text = "Success Loading",
    Icon = "rbxthumb://type=Asset&id=111167393120231&w=420&h=420",
    Duration = 5,
    Callback = function()
    end
})
repeat task.wait() until game:IsLoaded()

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

local UI = SkUI:CreateWindow("Dead Rails")

local Tab = UI:Create("General")

Tab:AddTextLabel("Left", "Player")
Tab:AddToggle("Left", "Full Bright", false, function(v)
    if v then
        if not game.Lighting:FindFirstChild("FullBrightEffect") then
            local effect = Instance.new("ColorCorrectionEffect")
            effect.Name = "FullBrightEffect"
            effect.Brightness = 1
            effect.Contrast = 1
            effect.Saturation = 0
            effect.TintColor = Color3.new(1, 1, 1)
            effect.Parent = game.Lighting
        end

        game.Lighting.Brightness = 5
        game.Lighting.ClockTime = 12
        game.Lighting.FogEnd = 1e10
        game.Lighting.GlobalShadows = false
    else
        if game.Lighting:FindFirstChild("FullBrightEffect") then
            game.Lighting.FullBrightEffect:Destroy()
        end

        game.Lighting.Brightness = 2
        game.Lighting.ClockTime = 14
        game.Lighting.FogEnd = 1000
        game.Lighting.GlobalShadows = true
    end
end)
local currentSpeed = 50
_G.SuperSpeed = false

Tab:AddSlider("Left", "Speed", 1, 100, currentSpeed, function(val)
    currentSpeed = val
end)

Tab:AddToggle("Left", "Super Speed", false, function(v)
    _G.SuperSpeed = v

    if _G.SuperSpeed and not _G._SuperSpeedConnection then
        _G._SuperSpeedConnection = game:GetService("RunService").RenderStepped:Connect(function()
            local human = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if human and _G.SuperSpeed then
                human.WalkSpeed = currentSpeed
            end
        end)
    elseif not _G.SuperSpeed and _G._SuperSpeedConnection then
        _G._SuperSpeedConnection:Disconnect()
        _G._SuperSpeedConnection = nil

        local human = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if human then
            human.WalkSpeed = 16
        end
    end
end)
Tab:AddToggle("Left", "Auto Walk", false, function(v)
    local runService = game:GetService("RunService")
    local player = game.Players.LocalPlayer
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local connection

    if v then
        connection = runService.RenderStepped:Connect(function()
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char:TranslateBy(char.HumanoidRootPart.CFrame.LookVector * 0.5)
            end
        end)
        script:SetAttribute("AutoWalkConnection", connection)
    else
        local con = script:GetAttribute("AutoWalkConnection")
        if typeof(con) == "RBXScriptConnection" then
            con:Disconnect()
        end
    end
end)
Tab:AddToggle("Left", "Noclip", false, function(v)
    local player = game.Players.LocalPlayer
    local runService = game:GetService("RunService")
    local connection

    if v then
        connection = runService.Stepped:Connect(function()
            local char = player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
        script:SetAttribute("NoclipConnection", connection)
    else
        local con = script:GetAttribute("NoclipConnection")
        if typeof(con) == "RBXScriptConnection" then
            con:Disconnect()
        end

        local char = player.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)
Tab:AddToggle("Left", "Unlock Camera", false, function(v)
    local camera = workspace.CurrentCamera
    if v then
        camera.CameraType = Enum.CameraType.Scriptable
    else
        camera.CameraType = Enum.CameraType.Custom
    end
end)
Tab:AddButton("Left", "Unlock Zoom", function()
    local player = game.Players.LocalPlayer
    player.CameraMaxZoomDistance = 10000
    player.CameraMinZoomDistance = 0.5
end)
Tab:AddButton("Left", "Bring Bond", function()
    local player = game.Players.LocalPlayer
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("bond") then
            obj.CFrame = root.CFrame + Vector3.new(0, 3, -5)
        elseif obj:IsA("Model") and obj.Name:lower():find("bond") and obj:FindFirstChild("PrimaryPart") then
            obj:SetPrimaryPartCFrame(root.CFrame + Vector3.new(0, 3, -5))
        end
    end
end)
Tab:AddTextLabel("Left", "Esp")
Tab:AddToggle("Left", "ESP Player", false, function(v)
    local espFolder = game.CoreGui:FindFirstChild("PlayerESP") or Instance.new("Folder", game.CoreGui)
    espFolder.Name = "PlayerESP"

    if not v then
        espFolder:ClearAllChildren()
        return
    end

    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = player.Name .. "_ESP"
                billboard.Adornee = char.HumanoidRootPart
                billboard.Size = UDim2.new(0, 150, 0, 30)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true
                billboard.LightInfluence = 0
                billboard.MaxDistance = 10000
                billboard.Parent = espFolder

                local text = Instance.new("TextLabel")
                text.BackgroundTransparency = 1
                text.Size = UDim2.new(1, 0, 1, 0)
                text.Position = UDim2.new(0, 0, 0, 0)
                text.Text = player.Name .. " | " .. math.floor(char.Humanoid.Health)
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
Tab:AddToggle("Left", "ESP Mob", false, function(v)
    local espFolder = game.CoreGui:FindFirstChild("MobESP") or Instance.new("Folder", game.CoreGui)
    espFolder.Name = "MobESP"

    if not v then
        espFolder:ClearAllChildren()
        return
    end

    for _, mob in pairs(workspace:GetDescendants()) do
        if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid") and not game.Players:GetPlayerFromCharacter(mob) then
            local hrp = mob:FindFirstChild("HumanoidRootPart")

            local billboard = Instance.new("BillboardGui")
            billboard.Name = mob.Name .. "_ESP"
            billboard.Adornee = hrp
            billboard.Size = UDim2.new(0, 150, 0, 30)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true
            billboard.LightInfluence = 0
            billboard.MaxDistance = 10000
            billboard.Parent = espFolder

            local text = Instance.new("TextLabel")
            text.BackgroundTransparency = 1
            text.Size = UDim2.new(1, 0, 1, 0)
            text.Position = UDim2.new(0, 0, 0, 0)
            local distance = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
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
Tab:AddToggle("Left", "ESP Item", false, function(v)
    local espFolder = game.CoreGui:FindFirstChild("ItemESP") or Instance.new("Folder", game.CoreGui)
    espFolder.Name = "ItemESP"

    if not v then
        espFolder:ClearAllChildren()
        return
    end

    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("Tool") or item.Name:lower():find("item") or item.Name:lower():find("loot") then
            if item:IsA("Model") and item:FindFirstChild("PrimaryPart") then
                local part = item.PrimaryPart
                local name = item.Name
                local pos = part.Position
                local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = math.floor((hrp.Position - pos).Magnitude)

                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = name .. "_ESP"
                    billboard.Adornee = part
                    billboard.Size = UDim2.new(0, 150, 0, 30)
                    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
                    billboard.AlwaysOnTop = true
                    billboard.LightInfluence = 0
                    billboard.MaxDistance = 10000
                    billboard.Parent = espFolder

                    local label = Instance.new("TextLabel")
                    label.BackgroundTransparency = 1
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.Position = UDim2.new(0, 0, 0, 0)
                    label.Text = name .. " | " .. dist .. "m"
                    label.TextColor3 = Color3.fromRGB(0, 255, 255)
                    label.TextStrokeTransparency = 0.5
                    label.TextStrokeColor3 = Color3.new(0, 0, 0)
                    label.TextScaled = true
                    label.Font = Enum.Font.Gotham
                    label.Parent = billboard
                end
            elseif item:IsA("BasePart") then
                local name = item.Name
                local pos = item.Position
                local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = math.floor((hrp.Position - pos).Magnitude)

                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = name .. "_ESP"
                    billboard.Adornee = item
                    billboard.Size = UDim2.new(0, 150, 0, 30)
                    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
                    billboard.AlwaysOnTop = true
                    billboard.LightInfluence = 0
                    billboard.MaxDistance = 10000
                    billboard.Parent = espFolder

                    local label = Instance.new("TextLabel")
                    label.BackgroundTransparency = 1
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.Position = UDim2.new(0, 0, 0, 0)
                    label.Text = name .. " | " .. dist .. "m"
                    label.TextColor3 = Color3.fromRGB(0, 255, 255)
                    label.TextStrokeTransparency = 0.5
                    label.TextStrokeColor3 = Color3.new(0, 0, 0)
                    label.TextScaled = true
                    label.Font = Enum.Font.Gotham
                    label.Parent = billboard
                end
            end
        end
    end
end)
Tab:AddToggle("Left", "ESP Unicorn", false, function(v)
    local espFolder = game.CoreGui:FindFirstChild("UnicornESP") or Instance.new("Folder", game.CoreGui)
    espFolder.Name = "UnicornESP"

    if not v then
        espFolder:ClearAllChildren()
        return
    end

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("unicorn") then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = obj.Name .. "_ESP"
            billboard.Adornee = obj
            billboard.Size = UDim2.new(0, 150, 0, 30)
            billboard.StudsOffset = Vector3.new(0, 2.5, 0)
            billboard.AlwaysOnTop = true
            billboard.LightInfluence = 0
            billboard.MaxDistance = 10000
            billboard.Parent = espFolder

            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, 0, 1, 0)
            label.Position = UDim2.new(0, 0, 0, 0)
            label.Text = obj.Name
            label.TextColor3 = Color3.fromRGB(255, 105, 255)
            label.TextStrokeTransparency = 0.5
            label.TextStrokeColor3 = Color3.new(0, 0, 0)
            label.TextScaled = true
            label.Font = Enum.Font.GothamBold
            label.Parent = billboard
        elseif obj:IsA("Model") and obj.Name:lower():find("unicorn") and obj:FindFirstChild("PrimaryPart") then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = obj.Name .. "_ESP"
            billboard.Adornee = obj.PrimaryPart
            billboard.Size = UDim2.new(0, 150, 0, 30)
            billboard.StudsOffset = Vector3.new(0, 2.5, 0)
            billboard.AlwaysOnTop = true
            billboard.LightInfluence = 0
            billboard.MaxDistance = 10000
            billboard.Parent = espFolder

            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, 0, 1, 0)
            label.Position = UDim2.new(0, 0, 0, 0)
            label.Text = obj.Name
            label.TextColor3 = Color3.fromRGB(255, 105, 255)
            label.TextStrokeTransparency = 0.5
            label.TextStrokeColor3 = Color3.new(0, 0, 0)
            label.TextScaled = true
            label.Font = Enum.Font.GothamBold
            label.Parent = billboard
        end
    end
end)
Tab:AddTextbox("Right", "Webhook Url", function(text)
end)
Tab:AddToggle("Right", "Start Webhook", false, function(v)
end)
Tab:AddToggle("Right", "When Win Game", false, function(v)
end)
Tab:AddToggle("Right", "When Bond Game", false, function(v)
end)
Tab:AddTextLabel("Right", "Misc")
Tab:AddButton("Right", "Unlock All Power", function()
    local player = game.Players.LocalPlayer
    if player and player.CameraMaxZoomDistance then
        player.CameraMaxZoomDistance = 99999
        player.CameraMinZoomDistance = 0
    end

    local settings = UserSettings()
    if settings then
        pcall(function()
            settings.GameSettings.ControlMode = Enum.ControlMode.MouseLockSwitch
            settings.GameSettings.ComputerCameraMovementMode = Enum.ComputerCameraMovementMode.Classic
        end)
    end

    workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
end)
Tab:AddTextLabel("Right", "Farming")
Tab:AddToggle("Right", "Aimbot Mob", false, function(state)
    local rs = game:GetService("RunService")
    local cam = workspace.CurrentCamera
    local circle = Drawing.new("Circle")
    circle.Radius = 40
    circle.Thickness = 2
    circle.Filled = false
    circle.Transparency = 1
    circle.Color = Color3.fromRGB(255, 0, 0)
    circle.Visible = state

    local conn
    if state then
        conn = rs.RenderStepped:Connect(function()
            circle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
            local closest, dist = nil, math.huge
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
                    if not game.Players:GetPlayerFromCharacter(v) then
                        local pos, vis = cam:WorldToViewportPoint(v.HumanoidRootPart.Position)
                        local mag = (Vector2.new(pos.X, pos.Y) - circle.Position).Magnitude
                        if vis and mag < dist and mag <= circle.Radius then
                            closest = v
                            dist = mag
                        end
                    end
                end
            end
            if closest then
                cam.CFrame = CFrame.new(cam.CFrame.Position, closest.HumanoidRootPart.Position)
            end
        end)
    else
        circle:Remove()
        if conn then conn:Disconnect() end
    end
end)
Tab:AddToggle("Right", "Auto Attack", false, function(v)
    _G.AutoClick = v

    if _G.AutoClick and not _G._AutoClickConnection then
        _G._AutoClickConnection = game:GetService("RunService").RenderStepped:Connect(function()
            if _G.AutoClick then
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 0)
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end
        end)
    elseif not _G.AutoClick and _G._AutoClickConnection then
        _G._AutoClickConnection:Disconnect()
        _G._AutoClickConnection = nil
    end
end)
