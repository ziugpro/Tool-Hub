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
Tab:AddLabelBox("Left", "Main")
Tab:Line("Left")
Tab:Line("Right")
Tab:AddToggle("Left", "Noclip", false, function(v)
    _G.NoclipEnabled = v

    if _G._NoclipConnection then
        _G._NoclipConnection:Disconnect()
        _G._NoclipConnection = nil
    end

    if v then
        task.wait(0.1)
        _G._NoclipConnection = game:GetService("RunService").RenderStepped:Connect(function()
            local c = game.Players.LocalPlayer.Character
            if not c then return end
            for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = false
                    if p.Name == "HumanoidRootPart" or p.Name == "Torso" or p.Name == "UpperTorso" then
                        p.Velocity = Vector3.zero
                    end
                end
            end
        end)
    else
        local c = game.Players.LocalPlayer.Character
        if c then
            for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = true
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
Tab:AddSlider("Left", "Speed", 50, 500, 100, function(v)
    if typeof(v) == "number" then
        _G.SuperSpeedValue = v
    end
end)

Tab:AddToggle("Left", "Super Speed", false, function(v)
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
Tab:AddLabelBox("Right", "Webhook")
Tab:AddTextbox("Right", "Webhook", "", function(text)
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
Tab:Line("Left")
Tab:Line("Right")
