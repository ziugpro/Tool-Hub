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
local Misc = UI:Create("Misc")
local Web = UI:Create("Webhook")
function ForceTeleport(cf, holdTime)
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")

    local t0 = tick()
    while tick() - t0 < (holdTime or 0.75) do
        root.CFrame = cf
        root.Velocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        task.wait()
    end
end

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
Tab:RealLine("Left")
Tab:AddTextLabel("Left", "Esp")
Tab:AddToggle("Left", "ESP Player", false, function(v)
    local espFolder = game.CoreGui:FindFirstChild("PlayerESP") or Instance.new("Folder", game.CoreGui)
    espFolder.Name = "PlayerESP"

    if not v then
        espFolder:ClearAllChildren()
        return
    end

    local localPlayer = game.Players.LocalPlayer
    local localChar = localPlayer.Character
    local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")

    espFolder:ClearAllChildren()

    if not localHRP then return end

    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
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
                billboard.Parent = espFolder

                local text = Instance.new("TextLabel")
                text.BackgroundTransparency = 1
                text.Size = UDim2.new(1, 0, 1, 0)
                text.Position = UDim2.new(0, 0, 0, 0)
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
Tab:RealLine("Left")
Tab:AddTextLabel("Right", "Misc")
Tab:AddButton("Right", "Unlock Camera (Fixed)", function()
    local player = game.Players.LocalPlayer
    local cam = workspace.CurrentCamera

    game:GetService("RunService").RenderStepped:Connect(function()
        pcall(function()
            player.CameraMode = Enum.CameraMode.Classic
            player.CameraMaxZoomDistance = 1000
            player.CameraMinZoomDistance = 0
            cam.CameraType = Enum.CameraType.Custom
        end)
    end)
end)
Tab:AddToggle("Right", "Aimbot Mob", false, function(state)
    local rs = game:GetService("RunService")
    local cam = workspace.CurrentCamera
    local circle
    local conn

    if state then
        circle = Drawing.new("Circle")
        circle.Radius = 40
        circle.Thickness = 2
        circle.Filled = false
        circle.Transparency = 0.7
        circle.Color = Color3.fromRGB(255, 0, 0)
        circle.Visible = true

        conn = rs.RenderStepped:Connect(function()
            if not circle then return end
            circle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)

            local closest
            local dist = circle.Radius
            for _, mob in pairs(workspace:GetChildren()) do
                if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") then
                    if mob.Humanoid.Health > 0 and not game.Players:GetPlayerFromCharacter(mob) then
                        local pos, vis = cam:WorldToViewportPoint(mob.HumanoidRootPart.Position)
                        if vis then
                            local mag = (Vector2.new(pos.X, pos.Y) - circle.Position).Magnitude
                            if mag <= dist then
                                closest = mob
                                dist = mag
                            end
                        end
                    end
                end
            end

            if closest then
                cam.CFrame = CFrame.new(cam.CFrame.Position, closest.HumanoidRootPart.Position)
            end
        end)
    else
        if conn then
            conn:Disconnect()
            conn = nil
        end
        if circle then
            circle.Visible = false
            circle:Remove()
            circle = nil
        end
    end
end)
Tab:AddToggle("Right", "Auto Attack", false, function(v)
    _G.AutoClick = v

    if _G.AutoClick and not _G._AutoClickConnection then
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        local maxDistance = 10

        _G._AutoClickConnection = RunService.RenderStepped:Connect(function()
            if not _G.AutoClick then return end

            local character = localPlayer.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local canClick = false
            for _, mob in pairs(workspace:GetChildren()) do
                if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") then
                    if mob.Humanoid.Health > 0 and not Players:GetPlayerFromCharacter(mob) then
                        local distance = (mob.HumanoidRootPart.Position - hrp.Position).Magnitude
                        if distance <= maxDistance then
                            canClick = true
                            break
                        end
                    end
                end
            end

            if canClick then
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 0)
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end
        end)
    elseif not _G.AutoClick and _G._AutoClickConnection then
        _G._AutoClickConnection:Disconnect()
        _G._AutoClickConnection = nil
    end
end)
Tab:RealLine("Right")
Tab:AddTextLabel("Right", "Teleport")
Tab:AddButton("Right", "Teleport To End", function()
ForceTeleport(CFrame.new(-428.74591064453125, 28.072837829589844, -49040.90625), 15)
end)
Tab:AddButton("Right", "Teleport To Teslalab", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    local function findBasePartRecursive(model)
        if model:IsA("BasePart") then
            return model
        elseif model:IsA("Model") then
            if model.PrimaryPart then
                return model.PrimaryPart
            end
            for _, child in pairs(model:GetChildren()) do
                local part = findBasePartRecursive(child)
                if part then
                    return part
                end
            end
        end
        return nil
    end

    local function findTeslaLab()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v.Name:lower():find("teslalab") then
                local basePart = findBasePartRecursive(v)
                if basePart then
                    return basePart
                end
            end
        end
        return nil
    end

    local function findNearestChair(position)
        local nearestSeat = nil
        local nearestDist = math.huge
        for _, seat in pairs(workspace:GetDescendants()) do
            if seat:IsA("Seat") or seat:IsA("VehicleSeat") then
                local dist = (seat.Position - position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearestSeat = seat
                end
            end
        end
        return nearestSeat
    end

    local targetPart = findTeslaLab()
    if targetPart then
        character:MoveTo(targetPart.Position + Vector3.new(0, 5, 0))
        wait(0.5)
        local chair = findNearestChair(targetPart.Position)
        if chair then
            chair:Sit(character:FindFirstChildOfClass("Humanoid"))
        else
            warn("Không tìm thấy ghế gần TeslaLab.")
        end
    else
        warn("Không tìm thấy BasePart trong model chứa 'TeslaLab'.")
    end
end)
Tab:RealLine("Right")
Misc:AddLabel("Left", "Time:")
local remainingTime = 600
local function formatTime(seconds)
    local hrs = math.floor(seconds / 3600)
    local mins = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d:%02d", hrs, mins, secs)
end
Misc:AddButton("Left", "Start Countdown: " .. formatTime(remainingTime), function(self)
    local timeLeft = remainingTime
    task.spawn(function()
        while timeLeft > 0 do
            self:SetText("Start Countdown: " .. formatTime(timeLeft))
            task.wait(1)
            timeLeft -= 1
        end
        self:SetText("Time's up")
    end)
end)
Misc:RealLine("Left")
Web:AddTextLabel("Left", "Main")
Web:AddTextbox("Left", "Webhook Url", "", function(text)
end)
Web:AddToggle("Left", "Tag Everyone", false, function(v)
end)
Web:AddToggle("Left", "Start Webhook", false, function(v)
end)
Web:AddText("Left", "Please see webhook activity status below if 🔴 is inactive 🟢 is active 🟡 is maintenance")
Web:AddLabel("Left", "Status : 🔴")
Web:RealLine("Left")
Web:AddTextLabel("Right", "Setting")
Web:AddToggle("Right", "When Win Game", false, function(v)
end)
Web:AddToggle("Right", "When You Die", false, function(v)
end)
Web:AddToggle("Right", "When Pick Up Item", false, function(v)
end)
Web:AddToggle("Right", "When Comlect Bond", false, function(v)
end)
Web:RealLine("Right")
