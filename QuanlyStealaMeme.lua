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
local UI = SkUI:CreateWindow("Aura - Hub")
local Tab = UI:Create("General")
Tab:AddTextLabel("Left", "Main")
_G.Noclip = false
_G.NoclipConnection = nil
Tab:AddToggle("Left", "Noclip", false, function(v)
    _G.Noclip = v

    if v then
        if not _G.NoclipConnection then
            _G.NoclipConnection = game:GetService("RunService").Stepped:Connect(function()
                local player = game.Players.LocalPlayer
                local character = player and player.Character
                if character then
                    for _, part in pairs(character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    else
        if _G.NoclipConnection then
            _G.NoclipConnection:Disconnect()
            _G.NoclipConnection = nil
        end
        local player = game.Players.LocalPlayer
        local character = player and player.Character
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)
Tab:AddToggle("Left", "Infinity Jump", false, function(v)
    _G.InfinityJumpEnabled = v

    if _G.InfinityJumpEnabled then
        if not _G.InfinityJumpConnection then
            local UserInputService = game:GetService("UserInputService")
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local Humanoid = Character:WaitForChild("Humanoid")

            _G.InfinityJumpConnection = UserInputService.JumpRequest:Connect(function()
                if _G.InfinityJumpEnabled and Humanoid and Humanoid.Parent then
                    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    else
        if _G.InfinityJumpConnection then
            _G.InfinityJumpConnection:Disconnect()
            _G.InfinityJumpConnection = nil
        end
    end
end)
Tab:AddToggle("Left", "Inf Money (In Dev)", false, function(v)
end)
Tab:AddButton("Left", "Dash Through Wall", function()
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
Tab:RealLine("Left")
Tab:Line("Left")
Tab:AddTextLabel("Left", "Trolling")
Tab:AddToggle("Left", "Pose hand (Hitler)°", false, function(v)
    local char = game.Players.LocalPlayer.Character
    if not char then return end

    local rArm = char:FindFirstChild("RightUpperArm")
    local rShoulder = rArm and rArm:FindFirstChild("RightShoulder") or char:FindFirstChild("RightShoulder")
    local motor = char:FindFirstChild("RightShoulder") or char:FindFirstChild("RightUpperArm"):FindFirstChildOfClass("Motor6D")
    
    if not motor then
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("Motor6D") and v.Name == "RightShoulder" then
                motor = v
                break
            end
        end
    end

    if not motor then return end

    if v then
        _G._OriginalC0 = motor.C0
        motor.C0 = CFrame.new(1, 0.5, 0) * CFrame.Angles(math.rad(90), 0, 0)
    else
        if _G._OriginalC0 then
            motor.C0 = _G._OriginalC0
            _G._OriginalC0 = nil
        end
    end
end)
Tab:AddToggle("Left", "Freeze Others", false, function(v)
    if v then
        _G._FreezeConnection = game:GetService("RunService").Stepped:Connect(function()
            for _, plr in pairs(game.Players:GetPlayers()) do
                if plr ~= game.Players.LocalPlayer then
                    local char = plr.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if hum then hum.WalkSpeed = 0 hum.JumpPower = 0 end
                    if root then root.Velocity = Vector3.new(0, 0, 0) end
                end
            end
        end)
    else
        if _G._FreezeConnection then
            _G._FreezeConnection:Disconnect()
            _G._FreezeConnection = nil
        end
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer then
                local char = plr.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = 16 hum.JumpPower = 50 end
            end
        end
    end
end)
Tab:AddToggle("Left", "Burn Mode", false, function(v)
    local char = game.Players.LocalPlayer.Character
    if not char then return end

    if v then
        if not char:FindFirstChild("Fire") then
            local fire = Instance.new("Fire")
            fire.Size = 10
            fire.Heat = 25
            fire.Parent = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
        end
    else
        local fire = char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart:FindFirstChild("Fire")
        if fire then fire:Destroy() end
    end
end)
Tab:AddToggle("Left", "Infinite Light Buddha", false, function(v)
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if v then
        local light = Instance.new("PointLight")
        light.Name = "_PhatQuang"
        light.Brightness = 10000
        light.Range = 100
        light.Color = Color3.fromRGB(255, 255, 200)
        light.Shadows = true
        light.Parent = hrp

        local bloom = Instance.new("BloomEffect")
        bloom.Name = "_PhatQuangBloom"
        bloom.Intensity = 5
        bloom.Size = 100
        bloom.Threshold = 0
        bloom.Parent = game.Lighting
    else
        local light = hrp:FindFirstChild("_PhatQuang")
        if light then light:Destroy() end
        local bloom = game.Lighting:FindFirstChild("_PhatQuangBloom")
        if bloom then bloom:Destroy() end
    end
end)
Tab:RealLine("Left")
Tab:AddTextLabel("Right", "Webhook")
Tab:AddTextbox("Right", "Webhook Url", "", function(text)
    _G.WebhookURL = text
end)

Tab:AddToggle("Right", "Start Webhook ", false, function(v)
    if v and _G.WebhookURL and _G.WebhookURL ~= "" then
        local Data = {
            ["content"] = "🚨 Webhook Started",
            ["username"] = "Webhook Bot",
            ["embeds"] = {{
                ["title"] = "Status",
                ["description"] = "Webhook successfully started at: " .. os.date("%Y-%m-%d %H:%M:%S"),
                ["color"] = 65280
            }}
        }

        local HttpService = game:GetService("HttpService")
        local Success, Response = pcall(function()
            game:HttpPostAsync(_G.WebhookURL, HttpService:JSONEncode(Data))
        end)
    end
end)

Tab:AddToggle("Right", "When Steal Meme", false, function(v)
    if v and _G.WebhookURL and _G.WebhookURL ~= "" then
        local HttpService = game:GetService("HttpService")
        local Content = {
            ["content"] = "😂 Someone just stole a meme!",
            ["username"] = "Meme Logger",
            ["embeds"] = {{
                ["title"] = "Stolen Meme",
                ["description"] = "A meme was taken at " .. tick(),
                ["color"] = 16753920
            }}
        }

        pcall(function()
            game:HttpPostAsync(_G.WebhookURL, HttpService:JSONEncode(Content))
        end)
    end
end)

Tab:AddToggle("Right", "When You Die", false, function(v)
    if v and _G.WebhookURL and _G.WebhookURL ~= "" then
        local player = game.Players.LocalPlayer
        if player and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and not _G._WebhookDeathConn then
                _G._WebhookDeathConn = humanoid.Died:Connect(function()
                    local HttpService = game:GetService("HttpService")
                    local Payload = {
                        ["content"] = "☠️ You died!",
                        ["username"] = "Death Logger",
                        ["embeds"] = {{
                            ["title"] = "Player Death",
                            ["description"] = "Player died at: " .. os.date("%H:%M:%S"),
                            ["color"] = 16711680
                        }}
                    }
                    pcall(function()
                        game:HttpPostAsync(_G.WebhookURL, HttpService:JSONEncode(Payload))
                    end)
                end)
            end
        end
    elseif not v and _G._WebhookDeathConn then
        _G._WebhookDeathConn:Disconnect()
        _G._WebhookDeathConn = nil
    end
end)
Tab:RealLine("Right")
Tab:Line("Right")
Tab:AddTextLabel("Right", "Player")
Tab:AddSlider("Right", "Speed", 50, 500, 100, function(v)
    if typeof(v) == "number" then
        _G.SuperSpeedValue = v
    end
end)

Tab:AddToggle("Right", "Super Speed", false, function(v)
    _G.SuperSpeed = v

    if v and not _G._SuperSpeedConnection then
        local RunService = game:GetService("RunService")
        _G._SuperSpeedConnection = RunService.RenderStepped:Connect(function()
            local player = game.Players.LocalPlayer
            if player then
                local character = player.Character
                if character then
                    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = _G.SuperSpeedValue or 100
                    end
                end
            end
        end)
    elseif not v and _G._SuperSpeedConnection then
        _G._SuperSpeedConnection:Disconnect()
        _G._SuperSpeedConnection = nil

        local player = game.Players.LocalPlayer
        if player then
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChildWhichIsA("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 16
                end
            end
        end
    end
end)
local jumpPower = 50
local autoKillEnabled = false

Tab:AddSlider("Right", "Jumb", 1, 10000, 50, function(val)
    jumpPower = val
    if autoKillEnabled then
        local player = game.Players.LocalPlayer
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.JumpPower = jumpPower
        end
    end
end)

Tab:AddToggle("Right", "Super Jumb", false, function(v)
    autoKillEnabled = v
    local player = game.Players.LocalPlayer
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        if v then
            hum.JumpPower = jumpPower
        else
            hum.JumpPower = 50
        end
    end
end)
Tab:RealLine("Right")
