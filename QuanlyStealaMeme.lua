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
local HttpService = game:GetService("HttpService")
local SaveFileName = "AuraUISettings.json"
local function FileExists(path)
    local success, result = pcall(function() return isfile(path) end)
    if success then return result else return false end
end
local function ReadFileSafe(path)
    local success, content = pcall(function() return readfile(path) end)
    if success then return content else return nil end
end
local function WriteFileSafe(path, content)
    local success, err = pcall(function() writefile(path, content) end)
    return success, err
end
local function DeleteFileSafe(path)
    local success, err = pcall(function() delfile(path) end)
    return success, err
end
local function DecodeJSONSafe(jsonStr)
    local success, data = pcall(function() return HttpService:JSONDecode(jsonStr) end)
    if success and type(data) == "table" then return data else return nil end
end
local function EncodeJSONSafe(data)
    local success, jsonStr = pcall(function() return HttpService:JSONEncode(data) end)
    if success then return jsonStr else return nil end
end
local function LoadAllSettings()
    if not FileExists(SaveFileName) then return {} end
    local content = ReadFileSafe(SaveFileName)
    if not content or content == "" then return {} end
    local data = DecodeJSONSafe(content)
    if not data then
        DeleteFileSafe(SaveFileName)
        return {}
    end
    return data
end
local function SaveAllSettings(data)
    local jsonStr = EncodeJSONSafe(data)
    if jsonStr then
        local success, err = WriteFileSafe(SaveFileName, jsonStr)
        return success, err
    else
        return false, "Encode failed"
    end
end
local SettingsData = LoadAllSettings()
local function LoadSetting(key, default)
    if SettingsData[key] ~= nil then return SettingsData[key] end
    return default
end
local function SaveSetting(key, value)
    SettingsData[key] = value
    local success, err = SaveAllSettings(SettingsData)
    if not success then warn("Save failed:", err) end
end
game.StarterGui:SetCore("SendNotification", {
    Title = "Aura Hub",
    Text = "Success Loading",
    Icon = "rbxthumb://type=Asset&id=111167393120231&w=420&h=420",
    Duration = 5,
    Callback = function()
    end
})
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

local UI = SkUI:CreateWindow("Aura - Hub")
local Tab = UI:Create(105, "General")
local Web = UI:Create(110, "Webhook")

Tab:AddTextLabel("Left", "Main")
_G.Noclip = false
_G.NoclipConnection = nil
local savedValue = LoadSetting("Noclip", false)
Tab:AddToggle("Left", "Noclip", savedValue, function(v)
    SaveSetting("Noclip", v)
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
local savedValue = LoadSetting("Infinity Jumb", false)
Tab:AddToggle("Left", "Infinity Jumb", savedValue, function(v)
    SaveSetting("Infinity Jumb", v)
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
Tab:AddTextLabel("Left", "Farming")
Tab:AddToggle("Left", "Anti-Hitbox", false, function(v)
    _G.AntiHitbox = v

    local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.CanCollide = not v
            part.Massless = v
            part.Size = v and Vector3.new(0.1, 0.1, 0.1) or Vector3.new(2, 2, 1)
        end
    end
end)
Tab:AddSlider("Left", "Aimbot Radius", 50, 500, 150, function(v)
    _G.AimbotRadius = v
end)

Tab:AddToggle("Left", "Aimbot Circle", false, function(v)
    _G.AimbotCircle = v

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local Mouse = LocalPlayer:GetMouse()
    local Camera = workspace.CurrentCamera

    local AimPart = "Head"
    local Circle = Drawing.new("Circle")
    Circle.Radius = _G.AimbotRadius or 150
    Circle.Thickness = 2
    Circle.Color = Color3.fromRGB(0, 255, 0)
    Circle.Transparency = 1
    Circle.Filled = false

    local function getClosest()
        local closest = nil
        local shortest = _G.AimbotRadius or 150
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(AimPart) then
                local pos, onScreen = Camera:WorldToViewportPoint(v.Character[AimPart].Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if dist < shortest then
                        shortest = dist
                        closest = v.Character[AimPart]
                    end
                end
            end
        end
        return closest
    end

    local conn
    if v then
        conn = RunService.RenderStepped:Connect(function()
            Circle.Visible = true
            Circle.Position = Vector2.new(Mouse.X, Mouse.Y)
            Circle.Radius = _G.AimbotRadius or 150

            local target = getClosest()
            if target then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            end
        end)
    else
        if conn then
            conn:Disconnect()
        end
        Circle:Remove()
    end
end)
Tab:AddToggle("Left", "Kill Player (Improved)", false, function(v)
    _G.AutoKill = v

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local lp = Players.LocalPlayer
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") or nil

    if not hrp then
        lp.CharacterAdded:Wait()
        hrp = lp.Character:WaitForChild("HumanoidRootPart")
    end

    if not _G.AutoKillConnection then
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1, 1, 1) * 1e6
        bv.P = 1e6
        bv.Velocity = Vector3.zero
        bv.Parent = hrp

        _G.AutoKillConnection = RunService.RenderStepped:Connect(function()
            if not _G.AutoKill or not lp.Character or not hrp then
                bv.Velocity = Vector3.zero
                return
            end

            local closest = nil
            local min = math.huge
            for _, p in ipairs(Players:GetPlayers()) do
                local c = p.Character
                if p ~= lp and c then
                    local tHrp = c:FindFirstChild("HumanoidRootPart")
                    local hum = c:FindFirstChild("Humanoid")
                    if tHrp and hum and hum.Health > 0 then
                        local d = (hrp.Position - tHrp.Position).Magnitude
                        if d < min then
                            min = d
                            closest = {hrp = tHrp, hum = hum}
                        end
                    end
                end
            end

            if closest then
                local targetPos = closest.hrp.Position + Vector3.new(0, 3, 0)
                local dir = targetPos - hrp.Position
                local mag = dir.Magnitude
                local speed = math.clamp(mag * 6, 20, 150)
                bv.Velocity = dir.Unit * speed
                if mag < 3.5 then
                    closest.hum:TakeDamage(30)
                end
            else
                bv.Velocity = Vector3.zero
            end
        end)
    end
end)
Tab:RealLine("Left")
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
Tab:AddTextLabel("Right", "Player")
local savedSpeed = LoadSetting("Speed", 50)
Tab:AddSlider("Right", "Speed", 16, 500, savedSpeed, function(val)
    SaveSetting("Speed", val)
    if typeof(v) == "number" then
        _G.SuperSpeedValue = v
    end
end)

local savedValue = LoadSetting("Super Speed", false)
Tab:AddToggle("Right", "Super Speed", savedValue, function(v)
    SaveSetting("Super Speed", v)
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

local savedSpeed = LoadSetting("Jumb", 50)
Tab:AddSlider("Right", "Jumb", 1, 1000, savedSpeed, function(val)
    SaveSetting("Jumb", val)
    jumpPower = val
    if autoKillEnabled then
        local player = game.Players.LocalPlayer
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.JumpPower = jumpPower
        end
    end
end)

local savedValue = LoadSetting("Super Jumb", false)
Tab:AddToggle("Right", "Super Jumb", savedValue, function(v)
    SaveSetting("Super Jumb", v)
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
Web:AddToggle("Right", "When Steal Meme", false, function(v)
end)
Web:AddToggle("Right", "When Meme Lost", false, function(v)
end)
Web:AddToggle("Right", "When Buy Meme", false, function(v)
end)
Web:RealLine("Right")
