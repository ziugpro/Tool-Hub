game:GetService("Players").LocalPlayer:Kick("⛔ Aura Hub ⛔                       Script Outdated")
local DarkraiX = loadstring(game:HttpGet("https://raw.githubusercontent.com/ziugpro/Ui/refs/heads/main/UiLib", true))()

local Library = DarkraiX:Window("Aura Hub","131484641795167","131484641795167",Enum.KeyCode.RightControl);

Tab1 = Library:Tab("Main")


Tab1:Seperator("Main")
getgenv().AutoClearWave = false

Tab1:Toggle("Auto Clear Wave", false, function(value)
    getgenv().AutoClearWave = value
    if value then
        spawn(function()
            while getgenv().AutoClearWave do
                local mobs = workspace:FindFirstChild("Mobs")
                if mobs then
                    for i, mob in pairs(mobs:GetChildren()) do
                        if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
                            repeat
                                game:GetService("ReplicatedStorage").Remotes.Combat:FireServer("Attack")
                                wait(0.1)
                            until mob.Humanoid.Health <= 0 or not getgenv().AutoClearWave
                        end
                    end
                end
                wait(0.5)
            end
        end)
    end
end)
getgenv().AutoClearObjectives = false

Tab1:Toggle("Auto Clear Objectives", false, function(value)
    getgenv().AutoClearObjectives = value
    if value then
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
getgenv().AutoCollectDrops = false

Tab1:Toggle("Auto Collect Drops", false, function(value)
    getgenv().AutoCollectDrops = value
    if value then
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
Tab1:Seperator("Code")
Tab1:Button("Redeem All Code", function()
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
Tab1:Seperator("Esp")
getgenv().ESPEnabled = false

Tab1:Toggle("Player ESP", false, function(state)
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

Tab1:Toggle("Mob ESP", false, function(state)
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
Tab1:Seperator("Server")
getgenv().JobID = ""
getgenv().SpamJoinJob = false

Tab1:Textbox("Job ID", "", true, function(value)
    getgenv().JobID = value
end)
Tab1:Button("Join Server", function()
    if getgenv().JobID ~= "" then
        pcall(function()
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, getgenv().JobID, game.Players.LocalPlayer)
        end)
    end
end)
Tab1:Toggle("Spam Join Server", false, function(state)
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

Tab1:Line()
