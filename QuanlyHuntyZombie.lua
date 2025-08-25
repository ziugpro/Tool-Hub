local SkUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ziugpro/Tool-Hub/refs/heads/main/Tool-Hub-Ui"))()

local UI = SkUI:CreateWindow("SkUI V1.73 - By Ziugpro")

local Tab = UI:Create(105, "General")
local Visual = UI:Create(105, "Visuals")


Tab:AddTextLabel("Left", "Main")

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local tweenService = game:GetService("TweenService")
local repStorage = game:GetService("ReplicatedStorage")
local ws = workspace

Tab:AddToggle("Left", "Auto Clear Wave", false, function(state)
    getgenv().AutoClearWave = state
    if state then
        spawn(function()
            while getgenv().AutoClearWave do
                local questNPC = ws:FindFirstChild("QuestNPC")
                if questNPC and questNPC:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.CFrame = questNPC.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
                    repStorage.Remotes.Quest:FireServer("Accept")
                    wait(0.5)
                end
                local mobs = ws:FindFirstChild("Mobs")
                if mobs then
                    for i, mob in pairs(mobs:GetChildren()) do
                        if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
                            repeat
                                repStorage.Remotes.Combat:FireServer("Attack")
                                wait(0.1)
                            until mob.Humanoid.Health <= 0 or not getgenv().AutoClearWave
                        end
                    end
                end
                wait(0.2)
            end
        end)
    end
end)
Tab:AddToggle("Left", "Auto Clear Objectives", false, function(state)
    getgenv().AutoClearObjectives = state
    if state then
        spawn(function()
            while getgenv().AutoClearObjectives do
                local objectives = workspace:FindFirstChild("Objectives")
                if objectives then
                    for i, obj in pairs(objectives:GetChildren()) do
                        if obj:FindFirstChild("HumanoidRootPart") then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = obj.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
                            repeat
                                game:GetService("ReplicatedStorage").Remotes.Combat:FireServer("Attack")
                                wait(0.1)
                            until obj:FindFirstChild("Humanoid") == nil or obj.Humanoid.Health <= 0 or not getgenv().AutoClearObjectives
                        end
                    end
                end
                wait(0.3)
            end
        end)
    end
end)
Tab:AddToggle("Left", "Auto Collect Drops", false, function(state)
    getgenv().AutoCollectDrops = state
    if state then
        spawn(function()
            while getgenv().AutoCollectDrops do
                for i, drop in pairs(workspace.Drops:GetChildren()) do
                    if drop:IsA("Part") then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = drop.CFrame
                        wait(0.1)
                    end
                end
                wait(0.2)
            end
        end)
    end
end)
Tab:AddTextLabel("Left", "Modification")
getgenv().DashRange = 10

Tab:AddTextbox("Left", "Enter Dash Range", "10", function(text)
    local num = tonumber(text)
    if num then
        getgenv().DashRange = num
        for i, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                tool.DashDistance.Value = num
            end
        end
        local char = game.Players.LocalPlayer.Character
        if char then
            for i, tool in pairs(char:GetChildren()) do
                if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                    tool.DashDistance.Value = num
                end
            end
        end
    end
end)

Tab:RealLine("Left")
Tab:AddTextLabel("Right", "Code")
Tab:AddButton("Right", "Redeem All Codes", function()
    local repStorage = game:GetService("ReplicatedStorage")
    local codesFolder = repStorage:FindFirstChild("Codes")
    if codesFolder then
        for i, codeObj in pairs(codesFolder:GetChildren()) do
            if codeObj:IsA("StringValue") then
                pcall(function()
                    repStorage.Remotes.Redeem:FireServer(codeObj.Value)
                end)
                wait(0.1)
            end
        end
    end
end)
Tab:AddTextLabel("Right", "Shop")
getgenv().AutoRollWeapon = false
getgenv().AutoRollPerk = false
getgenv().RollDelay = 1

Tab:AddToggle("Right", "Auto Roll Weapon", false, function(state)
    getgenv().AutoRollWeapon = state
    if state then
        spawn(function()
            while getgenv().AutoRollWeapon do
                game:GetService("ReplicatedStorage").Remotes.RollWeapon:FireServer()
                wait(getgenv().RollDelay)
            end
        end)
    end
end)

Tab:AddToggle("Right", "Auto Roll Perk", false, function(state)
    getgenv().AutoRollPerk = state
    if state then
        spawn(function()
            while getgenv().AutoRollPerk do
                game:GetService("ReplicatedStorage").Remotes.RollPerk:FireServer()
                wait(getgenv().RollDelay)
            end
        end)
    end
end)

Tab:AddSlider("Right", "Delay", 1, 5, 1, function(val)
    getgenv().RollDelay = val
end)
Tab:RealLine("Right")

Visual:AddTextLabel("Left", "Esp")

getgenv().ESPEnabled = false

Visual:AddToggle("Left", "Player ESP", false, function(state)
    getgenv().ESPEnabled = state
    for i, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            local esp = plr.Character:FindFirstChild("ESPName")
            if state then
                if not esp then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "ESPName"
                    billboard.Adornee = plr.Character.Head
                    billboard.Size = UDim2.new(0, 100, 0, 25)
                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                    billboard.AlwaysOnTop = true

                    local text = Instance.new("TextLabel")
                    text.Size = UDim2.new(1,0,1,0)
                    text.BackgroundTransparency = 1
                    text.TextColor3 = Color3.fromRGB(255,0,0)
                    text.TextStrokeTransparency = 0
                    text.TextScaled = true
                    text.Text = plr.Name
                    text.Parent = billboard

                    billboard.Parent = plr.Character
                end
            else
                if esp then
                    esp:Destroy()
                end
            end
        end
    end
end)
getgenv().MobESPEnabled = false

Visual:AddToggle("Left", "Mob ESP", false, function(state)
    getgenv().MobESPEnabled = state
    for i, mob in pairs(workspace.Mobs:GetChildren()) do
        if mob:FindFirstChild("HumanoidRootPart") then
            local esp = mob:FindFirstChild("ESPName")
            if state then
                if not esp then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "ESPName"
                    billboard.Adornee = mob.HumanoidRootPart
                    billboard.Size = UDim2.new(0, 100, 0, 25)
                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                    billboard.AlwaysOnTop = true

                    local text = Instance.new("TextLabel")
                    text.Size = UDim2.new(1,0,1,0)
                    text.BackgroundTransparency = 1
                    text.TextColor3 = Color3.fromRGB(0,255,0)
                    text.TextStrokeTransparency = 0
                    text.TextScaled = true
                    text.Text = mob.Name
                    text.Parent = billboard

                    billboard.Parent = mob
                end
            else
                if esp then
                    esp:Destroy()
                end
            end
        end
    end
end)
getgenv().NPCESPEnabled = false

Visual:AddToggle("Left", "NPC ESP", false, function(state)
    getgenv().NPCESPEnabled = state
    for i, npc in pairs(workspace.NPCs:GetChildren()) do
        if npc:FindFirstChild("HumanoidRootPart") then
            local esp = npc:FindFirstChild("ESPName")
            if state then
                if not esp then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "ESPName"
                    billboard.Adornee = npc.HumanoidRootPart
                    billboard.Size = UDim2.new(0, 100, 0, 25)
                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                    billboard.AlwaysOnTop = true

                    local text = Instance.new("TextLabel")
                    text.Size = UDim2.new(1,0,1,0)
                    text.BackgroundTransparency = 1
                    text.TextColor3 = Color3.fromRGB(0,0,255)
                    text.TextStrokeTransparency = 0
                    text.TextScaled = true
                    text.Text = npc.Name
                    text.Parent = billboard

                    billboard.Parent = npc
                end
            else
                if esp then
                    esp:Destroy()
                end
            end
        end
    end
end)
getgenv().ItemESPEnabled = false

Visual:AddToggle("Left", "Item ESP", false, function(state)
    getgenv().ItemESPEnabled = state
    for i, item in pairs(workspace.Items:GetChildren()) do
        if item:FindFirstChild("Handle") then
            local esp = item:FindFirstChild("ESPName")
            if state then
                if not esp then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "ESPName"
                    billboard.Adornee = item.Handle
                    billboard.Size = UDim2.new(0, 100, 0, 25)
                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                    billboard.AlwaysOnTop = true

                    local text = Instance.new("TextLabel")
                    text.Size = UDim2.new(1,0,1,0)
                    text.BackgroundTransparency = 1
                    text.TextColor3 = Color3.fromRGB(255,255,0)
                    text.TextStrokeTransparency = 0
                    text.TextScaled = true
                    text.Text = item.Name
                    text.Parent = billboard

                    billboard.Parent = item
                end
            else
                if esp then
                    esp:Destroy()
                end
            end
        end
    end
end)
Visual:RealLine("Left")
Visual:AddTextLabel("Right", "Server")

getgenv().JobID = ""
getgenv().SpamJoinJob = false

Visual:AddTextbox("Right", "Enter Job ID", "Job ID", function(text)
    getgenv().JobID = text
end)

Visual:AddButton("Right", "Join Server", function()
    if getgenv().JobID ~= "" then
        pcall(function()
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, getgenv().JobID, game.Players.LocalPlayer)
        end)
    end
end)

Visual:AddButton("Right", "Copy Current Job ID", function()
    local jobId = tostring(game.JobId)
    pcall(function()
        setclipboard(jobId)
    end)
end)

Visual:AddToggle("Right", "Spam Join Server", false, function(state)
    getgenv().SpamJoinJob = state
    if state then
        spawn(function()
            while getgenv().SpamJoinJob do
                if getgenv().JobID ~= "" then
                    pcall(function()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, getgenv().JobID, game.Players.LocalPlayer)
                    end)
                end
                wait(0.5)
            end
        end)
    end
end)

Visual:RealLine("Right")
