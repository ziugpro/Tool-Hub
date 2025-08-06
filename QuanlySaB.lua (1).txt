game.StarterGui:SetCore("SendNotification", {
    Title = "Aura Hub",
    Text = "Success Loading",
    Icon = "rbxthumb://type=Asset&id=111167393120231&w=420&h=420",
    Duration = 5,
    Callback = function()
    end
})
repeat wait(5) until game:IsLoaded() and game.Players.LocalPlayer

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
local Teleport = UI:Create("Teleport")
local Esp = UI:Create("Esp")
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
Tab:AddTextLabel("Left", "Main")
Tab:AddToggle("Left", "Auto Buy Brainrot", false, function(v)
    _G.AutoWalkToTargetActive = v

    local x1 = -411.5451354980469
    local y1 = -6.275163173675537
    local z1 = -128.6896209716797

    local x2 = 0.0 + x1
    local y2 = 0.0 + y1
    local z2 = 0.0 + z1

    local vecX = x2 * 1
    local vecY = y2 * 1
    local vecZ = z2 * 1

    local finalTargetPosition = Vector3.new(vecX, vecY, vecZ)

    local playersService = game:GetService("Players")
    local runService = game:GetService("RunService")
    local workspaceService = game:GetService("Workspace")
    local lightingService = game:GetService("Lighting")

    local currentPlayer = playersService.LocalPlayer

    if v and _G._AutoWalkToTargetConnection == nil then
        _G._AutoWalkToTargetConnection = runService.RenderStepped:Connect(function()
            local getPlayer = playersService.LocalPlayer
            if getPlayer == nil then
                return
            end

            local getChar = getPlayer.Character
            if getChar == nil then
                return
            end

            local getHRP = getChar:FindFirstChild("HumanoidRootPart")
            if getHRP == nil then
                return
            end

            local getHumanoid = getChar:FindFirstChildOfClass("Humanoid")
            if getHumanoid == nil then
                return
            end

            local currentPosX = getHRP.Position.X
            local currentPosY = getHRP.Position.Y
            local currentPosZ = getHRP.Position.Z

            local currentVector = Vector3.new(currentPosX, currentPosY, currentPosZ)

            local diffVector = currentVector - finalTargetPosition

            local distX = diffVector.X * diffVector.X
            local distY = diffVector.Y * diffVector.Y
            local distZ = diffVector.Z * diffVector.Z

            local distSqr = distX + distY + distZ
            local distance = math.sqrt(distSqr)

            local shouldMove = false
            if distance > 3.0 then
                shouldMove = true
            end

            if shouldMove == true then
                getHumanoid:MoveTo(finalTargetPosition)
            end
        end)
    elseif not v and _G._AutoWalkToTargetConnection ~= nil then
        local disconnectConn = _G._AutoWalkToTargetConnection
        disconnectConn:Disconnect()
        _G._AutoWalkToTargetConnection = nil
    end
end)
Tab:AddToggle("Left", "Lock Base (Coming Soon)", false, function(v)
end)
Tab:AddToggle("Left", "Anti Hit", false, function(v)
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")

    if hrp == nil then return end

    if v then
        if not char:FindFirstChild("FakeRoot") then
            local fake = hrp:Clone()
            fake.Name = "FakeRoot"
            fake.Parent = char
            fake.Anchored = true
            fake.CanCollide = false
            fake.Transparency = 1
        end
        hrp.Position = Vector3.new(9999, 9999, 9999)
    else
        hrp.Position = char:FindFirstChild("FakeRoot") and char.FakeRoot.Position or char:GetPivot().Position
        if char:FindFirstChild("FakeRoot") then
            char.FakeRoot:Destroy()
        end
    end
end)
Tab:AddToggle("Left", "Anti Hit (v2)", false, function(v)
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if v then
        if not char:FindFirstChild("OriginalRootPosition") then
            local value = Instance.new("Vector3Value")
            value.Name = "OriginalRootPosition"
            value.Value = hrp.Position
            value.Parent = char
        end
        hrp.Anchored = true
        hrp.Position = Vector3.new(99999, 99999, 99999)
    else
        local saved = char:FindFirstChild("OriginalRootPosition")
        if saved then
            hrp.Position = saved.Value
            saved:Destroy()
        else
            hrp.Position = char:GetPivot().Position
        end
        task.wait(0.1)
        hrp.Anchored = false
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
Tab:RealLine("Left")
local currentSpeed = 50
_G.SuperSpeed = false

Tab:AddSlider("Right", "Speed", 1, 100, currentSpeed, function(val)
    currentSpeed = val
end)

Tab:AddToggle("Right", "Super Speed", false, function(v)
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
Tab:AddToggle("Right", "Super Jump", false, function(v)
    _G.SuperJump = v

    if _G.SuperJump and not _G._SuperJumpConnection then
        _G._SuperJumpConnection = game:GetService("RunService").RenderStepped:Connect(function()
            local human = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if human and _G.SuperJump then
                human.JumpPower = 150
            end
        end)
    elseif not _G.SuperJump and _G._SuperJumpConnection then
        _G._SuperJumpConnection:Disconnect()
        _G._SuperJumpConnection = nil

        local human = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if human then
            human.JumpPower = 50
        end
    end
end)
Tab:RealLine("Right")
Tab:AddTextLabel("Right", "Bug Game")
Tab:AddToggle("Right", "Spam Remotes", false, function(v)
    _G.SpamRemotes = v

    while _G.SpamRemotes do
        for _, obj in ipairs(game:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                pcall(function()
                    obj:FireServer()
                end)
            elseif obj:IsA("RemoteFunction") then
                pcall(function()
                    obj:InvokeServer()
                end)
            end
        end
        wait(1)
    end
end)
Tab:RealLine("Right")
Tab:AddTextLabel("Right", "Misc")
Tab:AddButton("Right", "Become Black", function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Color = Color3.fromRGB(15, 15, 15)
        end
    end
end)
Tab:AddButton("Right", "Become While ", function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Color = Color3.fromRGB(255, 255, 255)
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
Web:AddToggle("Right", "When Steal Brainrot", false, function(v)
end)
Web:AddToggle("Right", "When Brainrot Lost", false, function(v)
end)
Web:AddToggle("Right", "When Buy Brainrot", false, function(v)
end)
Web:RealLine("Right")
Teleport:AddTextLabel("Left", "Teleport")
Teleport:AddButton("Left", "TP To Sky", function()
ForceTeleport(CFrame.new(-412.1122741699219, 133.4999957084656, 120.07735443115234), 5)
end)
Teleport:AddButton("Left", "TP To Down", function()
ForceTeleport(CFrame.new(-412.1122741699219, 6.4999957084656, 120.07735443115234), 1)
end)
Teleport:AddButton("Left", "TP To Center", function()
ForceTeleport(CFrame.new(-410.9408874511719, -5.56812047958374, -129.55369567871094), 3)
end)
Teleport:RealLine("Left")
Esp:AddTextLabel("Right", "Esp")
Esp:AddToggle("Right", "ESP Player", false, function(v)
    _G.PlayerESP = v

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer

    if v and not _G._PlayerESPConnection then
        _G._PlayerESPConnection = RunService.RenderStepped:Connect(function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    if not plr.Character:FindFirstChild("ESPTag") then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Name = "ESPTag"
                        billboard.Adornee = plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChild("HumanoidRootPart")
                        billboard.Size = UDim2.new(0, 200, 0, 50)
                        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
                        billboard.AlwaysOnTop = true
                        billboard.LightInfluence = 0
                        billboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

                        local label = Instance.new("TextLabel")
                        label.Name = "Text"
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.TextStrokeTransparency = 0.5
                        label.TextScaled = true
                        label.Font = Enum.Font.GothamBold
                        label.TextXAlignment = Enum.TextXAlignment.Center

                        local function getTeamColor(p)
                            return p.Team and p.Team.TeamColor.Color or Color3.fromRGB(255, 255, 255)
                        end

                        label.TextColor3 = getTeamColor(plr)
                        local health = math.floor((plr.Character:FindFirstChildOfClass("Humanoid") or {}).Health or 0)
                        label.Text = plr.Name .. " | HP: " .. health

                        label.Parent = billboard
                        billboard.Parent = plr.Character
                    else
                        local tag = plr.Character:FindFirstChild("ESPTag")
                        local label = tag:FindFirstChild("Text")
                        local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")

                        if tag and label and humanoid then
                            label.Text = plr.Name .. " | HP: " .. math.floor(humanoid.Health)
                            label.TextColor3 = plr.Team and plr.Team.TeamColor.Color or Color3.fromRGB(255, 255, 255)
                        end
                    end
                end
            end
        end)
    elseif not v and _G._PlayerESPConnection then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("ESPTag") then
                plr.Character.ESPTag:Destroy()
            end
        end
        _G._PlayerESPConnection:Disconnect()
        _G._PlayerESPConnection = nil
    end
end)
Esp:AddToggle("Right", "ESP Brainrot", false, function(v)
    _G.ModelESP = v

    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")

    if v and not _G._ModelESPConnection then
        _G._ModelESPConnection = RunService.RenderStepped:Connect(function()
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") and not obj:FindFirstChildOfClass("Humanoid") and not obj:FindFirstChild("ESPTag") then
                    local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                    if primary then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Name = "ESPTag"
                        billboard.Adornee = primary
                        billboard.Size = UDim2.new(0, 200, 0, 50)
                        billboard.StudsOffset = Vector3.new(0, 3, 0)
                        billboard.AlwaysOnTop = true
                        billboard.LightInfluence = 0
                        billboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.TextColor3 = Color3.fromRGB(0, 255, 0)
                        label.TextStrokeTransparency = 0
                        label.Text = obj.Name
                        label.TextScaled = true
                        label.Font = Enum.Font.Gotham
                        label.Parent = billboard

                        billboard.Parent = obj
                    end
                elseif obj:IsA("Model") and obj:FindFirstChild("ESPTag") then
                    local tag = obj:FindFirstChild("ESPTag")
                    if tag and tag:FindFirstChildOfClass("TextLabel") then
                        tag.TextLabel.Text = obj.Name
                    end
                end
            end
        end)
    elseif not v and _G._ModelESPConnection then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("ESPTag") then
                obj.ESPTag:Destroy()
            end
        end
        _G._ModelESPConnection:Disconnect()
        _G._ModelESPConnection = nil
    end
end)
Esp:AddToggle("Right", "ESP NPC", false, function(v)
    _G.NPCEspEnabled = v

    local RunService = game:GetService("RunService")
    local NPCFolder = workspace:FindFirstChild("NPCs") or workspace -- sửa nếu NPC ở folder khác

    if v and not _G._NPCEspConnection then
        _G._NPCEspConnection = RunService.RenderStepped:Connect(function()
            for _, npc in ipairs(NPCFolder:GetChildren()) do
                if npc:IsA("Model") and not npc:FindFirstChild("ESPTag") and npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
                    local name = npc.Name
                    local hp = npc.Humanoid and math.floor(npc.Humanoid.Health) or "?"

                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "ESPTag"
                    billboard.Adornee = npc:FindFirstChild("Head") or npc:FindFirstChild("HumanoidRootPart")
                    billboard.Size = UDim2.new(0, 200, 0, 50)
                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                    billboard.AlwaysOnTop = true
                    billboard.LightInfluence = 0
                    billboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.TextColor3 = Color3.fromRGB(255, 255, 0)
                    label.TextStrokeTransparency = 0
                    label.Text = name .. " | HP: " .. tostring(hp)
                    label.TextScaled = true
                    label.Font = Enum.Font.Gotham
                    label.Parent = billboard

                    billboard.Parent = npc
                elseif npc:FindFirstChild("ESPTag") and npc:FindFirstChild("Humanoid") then
                    local label = npc.ESPTag:FindFirstChildOfClass("TextLabel")
                    if label then
                        label.Text = npc.Name .. " | HP: " .. math.floor(npc.Humanoid.Health)
                    end
                end
            end
        end)
    elseif not v and _G._NPCEspConnection then
        for _, npc in ipairs(NPCFolder:GetChildren()) do
            if npc:IsA("Model") and npc:FindFirstChild("ESPTag") then
                npc.ESPTag:Destroy()
            end
        end
        _G._NPCEspConnection:Disconnect()
        _G._NPCEspConnection = nil
    end
end)
Esp:RealLine("Right")
Misc:AddTextLabel("Left", "Shop")
Misc:AddDropdown("Left", "Brainrot", {"nill value"}, "nill value", function(choice)
end)
Misc:AddToggle("Left", "Auto Buy (All)", false, function(v)
end)
Misc:AddToggle("Left", "Auto Buy (Bug)", false, function(v)
end)
Misc:RealLine("Left")
Misc:AddTextLabel("Right", "Anti-Player")
Misc:AddToggle("Right", "Anti-Ban", false, function(v)
end)
Misc:AddToggle("Right", "Anti-Steal", false, function(v)
end)
Misc:AddToggle("Right", "Anti-Kick", false, function(v)
end)
Misc:RealLine("Right")
