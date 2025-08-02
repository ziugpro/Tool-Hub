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
local Setting = UI:Create("Setting Player")
local Teleport = UI:Create("Teleport")
local Steal = UI:Create("Steal Brainrot")
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
Tab:AddToggle("Right", "Super Speed", false, function(v)
    _G.SuperSpeed = v

    if _G.SuperSpeed and not _G._SuperSpeedConnection then
        _G._SuperSpeedConnection = game:GetService("RunService").RenderStepped:Connect(function()
            local human = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if human and _G.SuperSpeed then
                human.WalkSpeed = 55
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
Tab:AddTextLabel("Right", "Esp")
Tab:AddToggle("Right", "ESP Player", false, function(v)
    _G.PlayerESP = v

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")

    if v and not _G._PlayerESPConnection then
        _G._PlayerESPConnection = RunService.RenderStepped:Connect(function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    if not plr.Character:FindFirstChild("ESPTag") then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Name = "ESPTag"
                        billboard.Adornee = plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChild("HumanoidRootPart")
                        billboard.Size = UDim2.new(0, 200, 0, 50)
                        billboard.StudsOffset = Vector3.new(0, 2, 0)
                        billboard.AlwaysOnTop = true
                        billboard.LightInfluence = 0
                        billboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.TextColor3 = Color3.fromRGB(255, 0, 0)
                        label.TextStrokeTransparency = 0
                        label.Text = plr.Name .. " | HP: " .. math.floor((plr.Character:FindFirstChildOfClass("Humanoid") or {}).Health or 0)
                        label.TextScaled = true
                        label.Font = Enum.Font.Gotham

                        label.Parent = billboard
                        billboard.Parent = plr.Character
                    else
                        local tag = plr.Character:FindFirstChild("ESPTag")
                        if tag and tag:FindFirstChildOfClass("TextLabel") and plr.Character:FindFirstChildOfClass("Humanoid") then
                            tag.TextLabel.Text = plr.Name .. " | HP: " .. math.floor(plr.Character:FindFirstChildOfClass("Humanoid").Health)
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
Tab:AddToggle("Right", "ESP NPC", false, function(v)
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
Tab:AddTextLabel("Right", "_____")
Web:AddTextbox("Left", "Webhook Url", "", function(text)
end)
Web:AddToggle("Left", "Tag Everyone", false, function(v)
end)
Web:AddToggle("Left", "Start Webhook", false, function(v)
end)
Web:AddToggle("Right", "When Steal Brainrot", false, function(v)
end)
Web:AddToggle("Right", "When Brainrot Lost", false, function(v)
end)
Web:AddToggle("Right", "When Buy Brainrot", false, function(v)
end)

Setting:AddTextLabel("Left", "Color Skin")
Setting:AddButton("Left", "Skin: White", function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Color = Color3.fromRGB(255, 224, 189)
        end
    end
end)

Setting:AddButton("Left", "Skin: Light Tan", function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Color = Color3.fromRGB(255, 219, 172)
        end
    end
end)

Setting:AddButton("Left", "Skin: Medium Tan", function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Color = Color3.fromRGB(210, 180, 140)
        end
    end
end)

Setting:AddButton("Left", "Skin: Olive", function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Color = Color3.fromRGB(170, 135, 100)
        end
    end
end)

Setting:AddButton("Left", "Skin: Brown", function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Color = Color3.fromRGB(120, 85, 60)
        end
    end
end)

Setting:AddButton("Left", "Skin: Dark Brown", function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Color = Color3.fromRGB(80, 55, 39)
        end
    end
end)

Setting:AddButton("Left", "Skin: Black", function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Color = Color3.fromRGB(15, 15, 15)
        end
    end
end)

Setting:AddButton("Left", "Skin: Pale", function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Color = Color3.fromRGB(240, 220, 210)
        end
    end
end)

Setting:AddButton("Left", "Skin: Red Clay", function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Color = Color3.fromRGB(155, 80, 60)
        end
    end
end)

Setting:AddButton("Left", "Skin: Ash Gray", function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Color = Color3.fromRGB(100, 100, 100)
        end
    end
end)
Setting:AddTextLabel("Right", "Clothes")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local function applyOutfit(shirtId, pantsId)
    local character = localPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local desc = humanoid:GetAppliedDescription()
    desc.Shirt = "rbxassetid://" .. shirtId
    desc.Pants = "rbxassetid://" .. pantsId
    humanoid:ApplyDescription(desc)
end

Setting:AddButton("Right", "Outfit 1: Casual", function()
    applyOutfit(14407675970, 14407676151)
end)

Setting:AddButton("Right", "Outfit 2: Suit", function()
    applyOutfit(5707491070, 5707491607)
end)

Setting:AddButton("Right", "Outfit 3: Ninja", function()
    applyOutfit(5142045959, 5142046135)
end)

Setting:AddButton("Right", "Outfit 4: Cyberpunk", function()
    applyOutfit(10719624857, 10719625392)
end)

Setting:AddButton("Right", "Outfit 5: Military", function()
    applyOutfit(12347212376, 12347212592)
end)

Setting:AddButton("Right", "Outfit 6: Formal", function()
    applyOutfit(9441222463, 9441222801)
end)

Setting:AddButton("Right", "Outfit 7: Hoodie", function()
    applyOutfit(8611026896, 8611027132)
end)

Setting:AddButton("Right", "Outfit 8: Sporty", function()
    applyOutfit(7245682337, 7245682687)
end)

Setting:AddButton("Right", "Outfit 9: Police", function()
    applyOutfit(9912875938, 9912876182)
end)

Setting:AddButton("Right", "Outfit 10: Robber", function()
    applyOutfit(10212393784, 10212394020)
end)

Setting:AddTextLabel("Right", "Hair Style")
local Players = game:GetService("Players")
local InsertService = game:GetService("InsertService")
local localPlayer = Players.LocalPlayer
local Character = localPlayer.Character or localPlayer.CharacterAdded:Wait()

local function attachHair(assetId, tagName)
    if Character:FindFirstChild(tagName) then return end
    local hair = InsertService:LoadAsset(assetId):GetChildren()[1]
    hair.Name = tagName
    hair.Parent = Character
end

local function removeHair(tagName)
    local hair = Character:FindFirstChild(tagName)
    if hair then hair:Destroy() end
end

Setting:AddToggle("Right", "Hair 1: Spiky", false, function(v)
    if v then attachHair(48474294, "Hair1") else removeHair("Hair1") end
end)

Setting:AddToggle("Right", "Hair 2: Messy", false, function(v)
    if v then attachHair(12270248, "Hair2") else removeHair("Hair2") end
end)

Setting:AddToggle("Right", "Hair 3: Cool Boy", false, function(v)
    if v then attachHair(80922288, "Hair3") else removeHair("Hair3") end
end)

Setting:AddToggle("Right", "Hair 4: Dreadlocks", false, function(v)
    if v then attachHair(564488384, "Hair4") else removeHair("Hair4") end
end)

Setting:AddToggle("Right", "Hair 5: Anime Hair", false, function(v)
    if v then attachHair(161246558, "Hair5") else removeHair("Hair5") end
end)

Setting:AddToggle("Right", "Hair 6: Emo", false, function(v)
    if v then attachHair(14129164, "Hair6") else removeHair("Hair6") end
end)

Setting:AddToggle("Right", "Hair 7: Clean Cut", false, function(v)
    if v then attachHair(376548738, "Hair7") else removeHair("Hair7") end
end)

Setting:AddToggle("Right", "Hair 8: Afro", false, function(v)
    if v then attachHair(29467049, "Hair8") else removeHair("Hair8") end
end)

Setting:AddToggle("Right", "Hair 9: Ponytail", false, function(v)
    if v then attachHair(37820055, "Hair9") else removeHair("Hair9") end
end)

Setting:AddToggle("Right", "Hair 10: Bacon Classic", false, function(v)
    if v then attachHair(62399494, "Hair10") else removeHair("Hair10") end
end)
local InsertService = game:GetService("InsertService")
local Players = game:GetService("Players")
local Character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()

local function wearShoes(assetId, tagName)
    if Character:FindFirstChild(tagName) then return end
    local model = InsertService:LoadAsset(assetId)
    local shoe = model:FindFirstChildWhichIsA("Accessory")
    if shoe then
        shoe.Name = tagName
        shoe.Parent = Character
    end
end

local function removeShoes()
    for _, obj in ipairs(Character:GetChildren()) do
        if obj:IsA("Accessory") and (obj.Name == "Shoes1" or obj.Name == "Shoes2" or obj.Name == "Shoes3") then
            obj:Destroy()
        end
    end
end

Setting:AddButton("Right", "Wear Shoes 1 (Sneakers)", function()
    removeShoes()
    wearShoes(10813930350, "Shoes1") -- Example: Nike style sneakers
end)

Setting:AddButton("Right", "Wear Shoes 2 (Boots)", function()
    removeShoes()
    wearShoes(65136872, "Shoes2") -- Example: Black boots
end)

Setting:AddButton("Right", "Wear Shoes 3 (Slippers)", function()
    removeShoes()
    wearShoes(490467584, "Shoes3") -- Example: Roblox slippers
end)
Setting:AddTextLabel("Left", "_____")
Setting:AddTextLabel("Right", "_____")

Steal:AddTextLabel("Left", "Update Please Wait")
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
