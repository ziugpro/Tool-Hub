local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "Aura Hub",
    Icon = "palette",
    Author = "Thanawat_9999",
    Folder = "Premium",
    Size = UDim2.fromOffset(550, 320),
    Theme = "Dark",
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function()
        end
    },
    SideBarWidth = 200,
})

local Tabs = {
    Main = Window:Section({ Title = "Player", Opened = true }),
    Play = Window:Section({ Title = "Play Game", Opened = true }),
    Misc = Window:Section({ Title = "Misc", Opened = true }),

}
local TabHandles = {
    Player = Tabs.Main:Tab({ Title = "Speed & Jump", Icon = "layout-grid", Desc = "" }),
    Esp = Tabs.Main:Tab({ Title = "Esp & Item", Icon = "layout-grid", Desc = "" }),
    Chest = Tabs.Main:Tab({ Title = "Auto Chest", Icon = "layout-grid", Desc = "" }),
    Camp = Tabs.Play:Tab({ Title = "Camp Fire", Icon = "layout-grid", Desc = "" }),
    Create = Tabs.Play:Tab({ Title = "Create", Icon = "layout-grid", Desc = "" }),
    Tree = Tabs.Play:Tab({ Title = "Tree Farm", Icon = "layout-grid", Desc = "" }),
    Noclip = Tabs.Misc:Tab({ Title = "Noclip", Icon = "layout-grid", Desc = "" }),
    FlyUp = Tabs.Misc:Tab({ Title = "Fly Up", Icon = "layout-grid", Desc = "" }),

}
local SpeedBoost = TabHandles.Player:Toggle({
    Title = "Speed Boost",
    Locked = false,
    Value = false,
    Callback = function(state) 
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.WalkSpeed = state and 130 or 16
    end
})
local SpeedBoost50 = TabHandles.Player:Toggle({
    Title = "Speed Boost (Speed 60)",
    Locked = true,
    Value = false,
    Callback = function(state) 
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.WalkSpeed = state and 60 or 16
    end
})
local InfJumpToggle = TabHandles.Player:Toggle({
    Title = "Inf Jump",
    Locked = false,
    Value = false,
    Callback = function(state)
        local UserInputService = game:GetService("UserInputService")
        if state then
            _G.InfJumpConn = UserInputService.JumpRequest:Connect(function()
                local player = game.Players.LocalPlayer
                local character = player.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end)
        else
            if _G.InfJumpConn then
                _G.InfJumpConn:Disconnect()
                _G.InfJumpConn = nil
            end
        end
    end
})
local CustomSpeedSlider = TabHandles.Player:Slider({
    Title = "Custom Speed Value",
    Locked = false,
    Value = { Min = 1, Max = 300, Default = 16 },
    Callback = function(value)
        _G.CustomSpeedValue = value
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid and CustomSpeedToggle.Value then
                humanoid.WalkSpeed = value
            end
        end
    end
})

local CustomSpeedToggle = TabHandles.Player:Toggle({
    Title = "Custom Speed",
    Locked = false,
    Value = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")

        if state then
            humanoid.WalkSpeed = _G.CustomSpeedValue or 16
        else
            humanoid.WalkSpeed = 16
        end
    end
})
TabHandles.Esp:Paragraph({
    Title = "Esp Player",
})
local EspPlayerToggle = TabHandles.Esp:Toggle({
    Title = "Start Esp Player",
    Locked = false,
    Value = false,
    Callback = function(state)
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                local function applyEsp(char)
                    local head = char:FindFirstChild("Head")
                    if head then
                        local billboard = head:FindFirstChild("EspBillboard")
                        if state then
                            if not billboard then
                                billboard = Instance.new("BillboardGui")
                                billboard.Name = "EspBillboard"
                                billboard.AlwaysOnTop = true
                                billboard.Size = UDim2.new(0, 200, 0, 50)
                                billboard.StudsOffset = Vector3.new(0, 3, 0)
                                billboard.MaxDistance = 0
                                billboard.Parent = head

                                local label = Instance.new("TextLabel")
                                label.Name = "EspLabel"
                                label.BackgroundTransparency = 1
                                label.Size = UDim2.new(1, 0, 1, 0)
                                label.TextColor3 = Color3.fromRGB(0, 255, 0)
                                label.TextStrokeTransparency = 0
                                label.Font = Enum.Font.SourceSansBold
                                label.TextSize = 14
                                label.TextScaled = false
                                label.Text = ""
                                label.Parent = billboard
                            end
                        else
                            if billboard then
                                billboard:Destroy()
                            end
                        end
                    end
                end

                if player.Character then
                    applyEsp(player.Character)
                end
                player.CharacterAdded:Connect(applyEsp)
            end
        end
    end
})

local EspNameToggle = TabHandles.Esp:Toggle({
    Title = "ESP Name",
    Locked = false,
    Value = false,
    Callback = function(state)
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local billboard = head:FindFirstChild("EspBillboard")
                    if billboard and billboard:FindFirstChild("EspLabel") then
                        local label = billboard.EspLabel
                        if state then
                            if not string.find(label.Text, "Name:") then
                                label.Text = (label.Text ~= "" and label.Text .. " | " or "") .. "Name: " .. player.Name
                            end
                        else
                            label.Text = label.Text:gsub("Name: [^|]*|? ?", "")
                        end
                    end
                end
            end
        end
    end
})

local EspDistanceToggle = TabHandles.Esp:Toggle({
    Title = "ESP Distance",
    Locked = false,
    Value = false,
    Callback = function(state)
        local localPlayer = game.Players.LocalPlayer
        if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then return end

        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local billboard = head:FindFirstChild("EspBillboard")
                    if billboard and billboard:FindFirstChild("EspLabel") then
                        local label = billboard.EspLabel
                        if state then
                            local dist = math.floor((player.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude)
                            if not string.find(label.Text, "Location:") then
                                label.Text = (label.Text ~= "" and label.Text .. " | " or "") .. "Location: " .. dist
                            end
                        else
                            label.Text = label.Text:gsub("Location: [^|]*|? ?", "")
                        end
                    end
                end
            end
        end
    end
})

local EspHealthToggle = TabHandles.Esp:Toggle({
    Title = "ESP Health",
    Locked = false,
    Value = false,
    Callback = function(state)
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                local head = player.Character:FindFirstChild("Head")
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if head and humanoid then
                    local billboard = head:FindFirstChild("EspBillboard")
                    if billboard and billboard:FindFirstChild("EspLabel") then
                        local label = billboard.EspLabel
                        if state then
                            if not string.find(label.Text, "Health:") then
                                label.Text = (label.Text ~= "" and label.Text .. " | " or "") .. "Health: " .. math.floor(humanoid.Health)
                            end
                        else
                            label.Text = label.Text:gsub("Health: [^|]*|? ?", "")
                        end
                    end
                end
            end
        end
    end
})
TabHandles.Esp:Paragraph({
    Title = "Esp NPC",
})
local EspNpcToggle = TabHandles.Esp:Toggle({
    Title = "Start Esp NPC",
    Locked = false,
    Value = false,
    Callback = function(state)
        for _, npc in pairs(workspace:GetChildren()) do
            if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("Head") and not game.Players:GetPlayerFromCharacter(npc) then
                local head = npc:FindFirstChild("Head")
                local billboard = head:FindFirstChild("EspNpcBillboard")
                if state then
                    if not billboard then
                        billboard = Instance.new("BillboardGui")
                        billboard.Name = "EspNpcBillboard"
                        billboard.AlwaysOnTop = true
                        billboard.Size = UDim2.new(0, 200, 0, 50)
                        billboard.StudsOffset = Vector3.new(0, 3, 0)
                        billboard.MaxDistance = 0
                        billboard.Parent = head

                        local label = Instance.new("TextLabel")
                        label.Name = "EspNpcLabel"
                        label.BackgroundTransparency = 1
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.TextColor3 = Color3.fromRGB(255, 255, 0)
                        label.TextStrokeTransparency = 0
                        label.Font = Enum.Font.SourceSansBold
                        label.TextSize = 14
                        label.TextScaled = false
                        label.Text = ""
                        label.Parent = billboard
                    end
                else
                    if billboard then
                        billboard:Destroy()
                    end
                end
            end
        end
    end
})

local EspNpcNameToggle = TabHandles.Esp:Toggle({
    Title = "ESP NPC Name",
    Locked = false,
    Value = false,
    Callback = function(state)
        for _, npc in pairs(workspace:GetChildren()) do
            if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("Head") and not game.Players:GetPlayerFromCharacter(npc) then
                local head = npc.Head
                local billboard = head:FindFirstChild("EspNpcBillboard")
                if billboard and billboard:FindFirstChild("EspNpcLabel") then
                    local label = billboard.EspNpcLabel
                    if state then
                        if not string.find(label.Text, "Name:") then
                            label.Text = (label.Text ~= "" and label.Text .. " | " or "") .. "Name: " .. npc.Name
                        end
                    else
                        label.Text = label.Text:gsub("Name: [^|]*|? ?", "")
                    end
                end
            end
        end
    end
})

local EspNpcDistanceToggle = TabHandles.Esp:Toggle({
    Title = "ESP NPC Distance",
    Locked = false,
    Value = false,
    Callback = function(state)
        local localPlayer = game.Players.LocalPlayer
        if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then return end

        for _, npc in pairs(workspace:GetChildren()) do
            if npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("Head") and not game.Players:GetPlayerFromCharacter(npc) then
                local head = npc.Head
                local billboard = head:FindFirstChild("EspNpcBillboard")
                if billboard and billboard:FindFirstChild("EspNpcLabel") then
                    local label = billboard.EspNpcLabel
                    if state then
                        local dist = math.floor((npc.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude)
                        if not string.find(label.Text, "Location:") then
                            label.Text = (label.Text ~= "" and label.Text .. " | " or "") .. "Location: " .. dist
                        end
                    else
                        label.Text = label.Text:gsub("Location: [^|]*|? ?", "")
                    end
                end
            end
        end
    end
})

local EspNpcHealthToggle = TabHandles.Esp:Toggle({
    Title = "ESP NPC Health",
    Locked = false,
    Value = false,
    Callback = function(state)
        for _, npc in pairs(workspace:GetChildren()) do
            if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("Head") and not game.Players:GetPlayerFromCharacter(npc) then
                local head = npc.Head
                local humanoid = npc.Humanoid
                local billboard = head:FindFirstChild("EspNpcBillboard")
                if billboard and billboard:FindFirstChild("EspNpcLabel") then
                    local label = billboard.EspNpcLabel
                    if state then
                        if not string.find(label.Text, "Health:") then
                            label.Text = (label.Text ~= "" and label.Text .. " | " or "") .. "Health: " .. math.floor(humanoid.Health)
                        end
                    else
                        label.Text = label.Text:gsub("Health: [^|]*|? ?", "")
                    end
                end
            end
        end
    end
})
TabHandles.Esp:Paragraph({
    Title = "Item",
})
local Models = {}
for _, obj in pairs(workspace:GetChildren()) do
    if obj:IsA("Model") and obj:FindFirstChild("PrimaryPart") then
        table.insert(Models, obj.Name)
    end
end
local SelectedModel = nil
local BroughtModels = {}

local Dropdown = TabHandles.Esp:Dropdown({
    Title = "Select Item",
    Values = Models,
    Locked = false,
    Value = Models[1] or "",
    Callback = function(option)
        SelectedModel = option
    end
})

TabHandles.Esp:Button({
    Title = "Bring Model",
    Icon = "bell",
    Callback = function()
        if SelectedModel and not BroughtModels[SelectedModel] then
            local model = workspace:FindFirstChild(SelectedModel)
            local player = game.Players.LocalPlayer
            if model and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                model:SetPrimaryPartCFrame(hrp.CFrame * CFrame.new(0, 0, -5))
                BroughtModels[SelectedModel] = true
            end
        end
    end
})

local AutoChestToggle = TabHandles.Chest:Toggle({
    Title = "Auto Open Chest (Auto)",
    Locked = false,
    Value = false,
    Callback = function(v)
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        if not _G.AutoChestData then
            _G.AutoChestData = {running = false, originalCFrame = nil}
        end

        local function getChests()
            local chests = {}
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and string.find(obj.Name, "Item Chest") then
                    table.insert(chests, obj)
                end
            end
            return chests
        end

        local function getPrompt(model)
            local prompts = {}
            for _, obj in ipairs(model:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    table.insert(prompts, obj)
                end
            end
            return prompts
        end

        if v then
            if _G.AutoChestData.running then return end
            _G.AutoChestData.running = true
            _G.AutoChestData.originalCFrame = humanoidRootPart.CFrame
            task.spawn(function()
                while _G.AutoChestData.running do
                    local chests = getChests()
                    for _, chest in ipairs(chests) do
                        if not _G.AutoChestData.running then break end
                        local part = chest.PrimaryPart or chest:FindFirstChildWhichIsA("BasePart")
                        if part then
                            humanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 6, 0)
                            local prompts = getPrompt(chest)
                            for _, prompt in ipairs(prompts) do
                                fireproximityprompt(prompt, math.huge)
                            end
                            local t = tick()
                            while _G.AutoChestData.running and tick() - t < 4 do task.wait() end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            _G.AutoChestData.running = false
            if _G.AutoChestData.originalCFrame then
                humanoidRootPart.CFrame = _G.AutoChestData.originalCFrame
            end
        end
    end
})
local chestRange = 50

local ChestRangeSlider = TabHandles.Chest:Slider({
    Title = "Range Open Chest",
    Locked = false,
    Value = { Min = 1, Max = 100, Default = 50 },
    Callback = function(val)
        chestRange = val
    end
})

local AutoChestNearToggle = TabHandles.Chest:Toggle({
    Title = "Auto Open Chest (Near)",
    Locked = false,
    Value = false,
    Callback = function(v)
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

        if v then
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
    end
})

local TeleportChestButton = TabHandles.Chest:Button({
    Title = "Teleport To Chest",
    Icon = "box",
    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        local nearestChest, nearestDist, targetPart
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and string.find(obj.Name, "Item Chest") then
                local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    local dist = (humanoidRootPart.Position - part.Position).Magnitude
                    if not nearestDist or dist < nearestDist then
                        nearestDist = dist
                        nearestChest = obj
                        targetPart = part
                    end
                end
            end
        end

        if targetPart then
            humanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, targetPart.Size.Y/2 + 6, 0)
        end
    end
})




local AutoCampTeleportLog = TabHandles.Camp:Toggle({
    Title = "Auto Camp (Teleport - Log)",
    Locked = false,
    Value = false,
    Callback = function(v)
        if v then
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
    end
})

local AutoCampTeleportCoal = TabHandles.Camp:Toggle({
    Title = "Auto Camp (Teleport - Coal)",
    Locked = false,
    Value = false,
    Callback = function(v)
        if v then
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
    end
})

local AutoCampTeleportCooked = TabHandles.Camp:Toggle({
    Title = "Auto Cooked (Teleport)",
    Locked = false,
    Value = false,
    Callback = function(v)
        if v then
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
    end
})

local AutoCampBringLogs = TabHandles.Camp:Toggle({
    Title = "Auto Camp (Bring - Logs)",
    Locked = false,
    Value = false,
    Callback = function(v)
        if v then
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
    end
})

local AutoCampBringCooked = TabHandles.Camp:Toggle({
    Title = "Auto Cooked (Bring)",
    Locked = false,
    Value = false,
    Callback = function(v)
        if v then
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
    end
})

local TeleportToCamp = TabHandles.Camp:Button({
    Title = "Teleport To Camp",
    Callback = function()
        local player = game.Players.LocalPlayer
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(0.5406733155250549, 12.499372482299805, -0.718663215637207)
        end
    end
})
local Toggle_LogBring = TabHandles.Create:Toggle({
    Title = "Auto Log (Bring)",
    Locked = false,
    Value = false,
    Callback = function(state)
        if state then
            _G.CollectLogs = true  
            task.spawn(function()
                while _G.CollectLogs do  
                    task.wait()  
                    for _, m in pairs(workspace:GetDescendants()) do  
                        if not _G.CollectLogs then break end  
                        if m:IsA("Model") and m.Name == "Log" and m.PrimaryPart then  
                            m:SetPrimaryPartCFrame(CFrame.new(20.8234, 7.7533, -5.5350))  
                            task.wait(0.2)  
                        end  
                    end  
                end  
            end)
        else
            _G.CollectLogs = false  
        end
    end
})

local Toggle_BoltBring = TabHandles.Create:Toggle({
    Title = "Auto Bolt (Bring)",
    Locked = false,
    Value = false,
    Callback = function(state)
        if state then
            _G.CollectBolt = true  
            task.spawn(function()
                while _G.CollectBolt do  
                    task.wait()  
                    for _, m in pairs(workspace:GetDescendants()) do  
                        if not _G.CollectBolt then break end  
                        if m:IsA("Model") and m.Name == "Bolt" and m.PrimaryPart then  
                            m:SetPrimaryPartCFrame(CFrame.new(20.8234, 7.7533, -5.5350))  
                            task.wait(0.2)  
                        end  
                    end  
                end  
            end)
        else
            _G.CollectBolt = false  
        end
    end
})

local Toggle_LogTeleport = TabHandles.Create:Toggle({
    Title = "Auto Log (Teleport)",
    Locked = false,
    Value = false,
    Callback = function(state)
        if state then
            _G.AutoLogs = true  
            local player = game.Players.LocalPlayer  
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")  
            local originalPos = hrp and hrp.CFrame  
            task.spawn(function()
                while _G.AutoLogs do  
                    task.wait()  
                    for _, m in pairs(workspace:GetDescendants()) do  
                        if not _G.AutoLogs then break end  
                        if m:IsA("Model") and m.Name == "Log" and m.PrimaryPart then  
                            if hrp then  
                                hrp.CFrame = m.PrimaryPart.CFrame  
                                m:SetPrimaryPartCFrame(CFrame.new(20.8234, 7.7533, -5.5350))  
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
            _G.AutoLogs = false  
        end
    end
})

local Toggle_BoltTeleport = TabHandles.Create:Toggle({
    Title = "Auto Bolt (Teleport)",
    Locked = false,
    Value = false,
    Callback = function(state)
        if state then
            _G.AutoBolts = true  
            local player = game.Players.LocalPlayer  
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")  
            local originalPos = hrp and hrp.CFrame  
            task.spawn(function()
                while _G.AutoBolts do  
                    task.wait()  
                    for _, m in pairs(workspace:GetDescendants()) do  
                        if not _G.AutoBolts then break end  
                        if m:IsA("Model") and m.Name == "Bolt" and m.PrimaryPart then  
                            if hrp then  
                                hrp.CFrame = m.PrimaryPart.CFrame  
                                m:SetPrimaryPartCFrame(CFrame.new(20.8234, 7.7533, -5.5350))  
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
            _G.AutoBolts = false  
        end
    end
})
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

local ChopToggle = TabHandles.Tree:Toggle({
    Title = "Auto Chop Tree",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.AutoChop = v
        if v then
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            local originalPos = hrp and hrp.CFrame
            while _G.AutoChop do
                task.wait()
                local trees = {}
                for _, m in pairs(workspace:GetDescendants()) do
                    if m:IsA("Model") and m.Name == "Small Tree" and m.PrimaryPart then
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
    end
})

local ChopTPToggle = TabHandles.Tree:Toggle({
    Title = "Auto Chop Tree (Teleport + Click)",
    Locked = false,
    Value = false,
    Callback = function(v)
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
    end
})

local ChopFakeToggle = TabHandles.Tree:Toggle({
    Title = "Auto Chop Tree (Testing)",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.AutoChopFake = v
        if v then
            while _G.AutoChopFake do
                task.wait(0.3)
                for _, tree in pairs(workspace:GetDescendants()) do
                    if not _G.AutoChopFake then break end
                    if tree:IsA("Model") and tree.Name == "Small Tree" and tree.PrimaryPart then
                        local fakeCFrame = tree.PrimaryPart.CFrame * CFrame.new(0,0,-3)
                        UIS.InputBegan:Fire({UserInputType = Enum.UserInputType.MouseButton1, Position = fakeCFrame.Position}, false)
                        task.wait(0.1)
                        UIS.InputEnded:Fire({UserInputType = Enum.UserInputType.MouseButton1, Position = fakeCFrame.Position}, false)
                    end
                end
            end
        else
            _G.AutoChopFake = false
        end
    end
})

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local Noclip1 = TabHandles.Noclip:Toggle({
    Title = "Basic Noclip",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.Noclip1 = v
        while _G.Noclip1 do
            task.wait()
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
})

local Noclip2 = TabHandles.Noclip:Toggle({
    Title = "Smooth Noclip",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.Noclip2 = v
        while _G.Noclip2 do
            task.wait()
            hrp.Velocity = Vector3.new(0,0,0)
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
})

local Noclip3 = TabHandles.Noclip:Toggle({
    Title = "Noclip Jump",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.Noclip3 = v
        while _G.Noclip3 do
            task.wait()
            hrp.CFrame = hrp.CFrame + Vector3.new(0,0.2,0)
        end
    end
})

local Noclip4 = TabHandles.Noclip:Toggle({
    Title = "Noclip Slide",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.Noclip4 = v
        while _G.Noclip4 do
            task.wait()
            hrp.CFrame = hrp.CFrame + Vector3.new(0.5,0,0)
        end
    end
})

local Noclip5 = TabHandles.Noclip:Toggle({
    Title = "Noclip Fly",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.Noclip5 = v
        while _G.Noclip5 do
            task.wait()
            hrp.CFrame = hrp.CFrame + Vector3.new(0,1,0)
        end
    end
})

local Noclip6 = TabHandles.Noclip:Toggle({
    Title = "Noclip Down",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.Noclip6 = v
        while _G.Noclip6 do
            task.wait()
            hrp.CFrame = hrp.CFrame + Vector3.new(0,-1,0)
        end
    end
})

local Noclip7 = TabHandles.Noclip:Toggle({
    Title = "Wall Phase",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.Noclip7 = v
        while _G.Noclip7 do
            task.wait()
            hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 1
        end
    end
})

local Noclip8 = TabHandles.Noclip:Toggle({
    Title = "Noclip Dash",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.Noclip8 = v
        while _G.Noclip8 do
            task.wait()
            hrp.CFrame = hrp.CFrame + hrp.CFrame.RightVector * 1
        end
    end
})

local Noclip9 = TabHandles.Noclip:Toggle({
    Title = "Noclip Drift",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.Noclip9 = v
        while _G.Noclip9 do
            task.wait()
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0,math.rad(5),0)
        end
    end
})

local Noclip10 = TabHandles.Noclip:Toggle({
    Title = "Noclip Spin",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.Noclip10 = v
        while _G.Noclip10 do
            task.wait()
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0,math.rad(15),0)
        end
    end
})

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local player = game.Players.LocalPlayer

_G.FlyUpAllTime = false
_G.FlyUpNightOnly = false

local ToggleAllTime = TabHandles.FlyUp:Toggle({
    Title = "Fly Up (All Time)",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.FlyUpAllTime = v
        local character = player.Character
        if not character then return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not hrp or not humanoid then return end

        humanoid.PlatformStand = v

        if v then
            task.spawn(function()
                while _G.FlyUpAllTime do
                    local ray = Ray.new(hrp.Position, Vector3.new(0, -1000, 0))
                    local part, pos = workspace:FindPartOnRay(ray, hrp.Parent)
                    local targetY = (part and pos.Y or hrp.Position.Y) + 300
                    hrp.Velocity = Vector3.new(0, 0, 0)
                    hrp.CFrame = CFrame.new(hrp.Position.X, targetY, hrp.Position.Z)
                    task.wait()
                end
                humanoid.PlatformStand = false
            end)
        end
    end
})

local ToggleNightOnly = TabHandles.FlyUp:Toggle({
    Title = "Fly Up (Night Only)",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.FlyUpNightOnly = v
        local character = player.Character
        if not character then return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not hrp or not humanoid then return end

        humanoid.PlatformStand = v

        if v then
            task.spawn(function()
                while _G.FlyUpNightOnly do
                    local currentTime = Lighting.ClockTime
                    if currentTime >= 18 or currentTime < 6 then
                        local ray = Ray.new(hrp.Position, Vector3.new(0, -1000, 0))
                        local part, pos = workspace:FindPartOnRay(ray, hrp.Parent)
                        local targetY = (part and pos.Y or hrp.Position.Y) + 300
                        hrp.Velocity = Vector3.new(0, 0, 0)
                        hrp.CFrame = CFrame.new(hrp.Position.X, targetY, hrp.Position.Z)
                    end
                    task.wait()
                end
                humanoid.PlatformStand = false
            end)
        end
    end
})
