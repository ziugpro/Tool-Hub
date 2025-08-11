game.StarterGui:SetCore("SendNotification", {
    Title = "Aura Hub",
    Text = "Success Loading",
    Icon = "rbxthumb://type=Asset&id=111167393120231&w=420&h=420",
    Duration = 5,
    Callback = function()
    end
})
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

for step = 1, 1 do
    task.spawn(function()
        heavyLoadStep()
    end)
    task.wait(1)
end

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua'))()
local Window = Rayfield:CreateWindow({
   Name = "Aura Hub",
   LoadingTitle = "Aura Hub | Loader",
   LoadingSubtitle = "by Ziugpro",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, 
      FileName = "Arrayfield"
   },
   Discord = {
      Enabled = false,
      Invite = "sirius",
      RememberJoins = false
   },
   KeySystem = true,
   KeySettings = {
      Title = "Aura Hub",
      Subtitle = "Key System",
      Note = "Aura Hub | Version 1.32",
      FileName = "SiriusKey",
      SaveKey = false,
      GrabKeyFromSite = false,
      Key = "AuraHub"
   }
})
local Tab = Window:CreateTab("General", 4483362458)
local Section = Tab:CreateSection("Player",false)
local Toggle = Tab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "ToggleNoclip",
    Callback = function(Value)
        _G.Noclip = Value
        if not _G.NoclipConnection then
            _G.NoclipConnection = game:GetService("RunService").Stepped:Connect(function()
                if _G.Noclip then
                    for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                end
            end)
        end
    end,
})
local Toggle = Tab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = false,
    Flag = "ToggleInfJump",
    Callback = function(Value)
        _G.InfJump = Value
        if not _G.InfJumpConnection then
            _G.InfJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                if _G.InfJump and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                end
            end)
        end
    end,
})
local Slider = Tab:CreateSlider({
    Name = "Speed Value",
    Range = {16, 200},
    Increment = 1,
    Suffix = " Speed",
    CurrentValue = 16,
    Flag = "SliderSpeed",
    Callback = function(Value)
        _G.SpeedValue = Value
    end,
})

local Toggle = Tab:CreateToggle({
    Name = "Player Speed",
    CurrentValue = false,
    Flag = "ToggleSpeed",
    Callback = function(Value)
        _G.SpeedEnabled = Value
        if not _G.SpeedConnection then
            _G.SpeedConnection = game:GetService("RunService").RenderStepped:Connect(function()
                if _G.SpeedEnabled and _G.SpeedValue then
                    local char = game.Players.LocalPlayer.Character
                    if char and char:FindFirstChildOfClass("Humanoid") then
                        char:FindFirstChildOfClass("Humanoid").WalkSpeed = _G.SpeedValue
                    end
                elseif not _G.SpeedEnabled and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
                end
            end)
        end
    end,
})
local Slider = Tab:CreateSlider({
    Name = "Jump Value",
    Range = {50, 300},
    Increment = 1,
    Suffix = " Jump",
    CurrentValue = 50,
    Flag = "SliderJump",
    Callback = function(Value)
        _G.JumpValue = Value
    end,
})

local Toggle = Tab:CreateToggle({
    Name = "Player Jump",
    CurrentValue = false,
    Flag = "ToggleJump",
    Callback = function(Value)
        _G.JumpEnabled = Value
        if not _G.JumpConnection then
            _G.JumpConnection = game:GetService("RunService").RenderStepped:Connect(function()
                local char = game.Players.LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then
                    if _G.JumpEnabled and _G.JumpValue then
                        hum.UseJumpPower = true
                        hum.JumpPower = _G.JumpValue
                    else
                        hum.UseJumpPower = true
                        hum.JumpPower = 50
                    end
                end
            end)
        end
    end,
})
local players = {}
for _, plr in pairs(game.Players:GetPlayers()) do
    if plr ~= game.Players.LocalPlayer then
        table.insert(players, plr.Name)
    end
end
local models = {}
for _, obj in pairs(workspace:GetChildren()) do
    if obj:IsA("Model") then
        table.insert(models, obj.Name)
    end
end

local selectedModels = {}

local MultiSelectionDropdown = Tab:CreateDropdown({
    Name = "Select Item",
    Options = {"Morsol", "Alpha Wolf", "Carrot", "Bunny"},
    CurrentOption = {},
    MultiSelection = true,
    Flag = "DropdownBringModels",
    Callback = function(Option)
        selectedModels = Option
    end,
})

local Button = Tab:CreateButton({
    Name = "Bring Item",
    Interact = 'Changable',
    Callback = function()
        local localChar = game.Players.LocalPlayer.Character
        if localChar and localChar:FindFirstChild("HumanoidRootPart") then
            for _, name in pairs(selectedModels) do
                for _, obj in pairs(workspace:GetChildren()) do
                    if obj:IsA("Model") and obj.Name == name and obj:FindFirstChild("HumanoidRootPart") then
                        obj.HumanoidRootPart.CFrame = localChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                    end
                end
            end
        end
    end,
})
local Section = Tab:CreateSection("Troll",false)
local selectedPlayers = {}

local MultiSelectionDropdown = Tab:CreateDropdown({
    Name = "Select Players",
    Options = players,
    CurrentOption = {},
    MultiSelection = true,
    Flag = "DropdownBring",
    Callback = function(Option)
        selectedPlayers = Option
    end,
})
local Button = Tab:CreateButton({
    Name = "Reset Player List",
    Interact = 'Changable',
    Callback = function()
        local players = {}
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer then
                table.insert(players, plr.Name)
            end
        end
        Tab:SetDropdownOptions("DropdownBring", players)
    end,
})

local Button = Tab:CreateButton({
    Name = "Bring Players",
    Interact = 'Changable',
    Callback = function()
        local localChar = game.Players.LocalPlayer.Character
        if localChar and localChar:FindFirstChild("HumanoidRootPart") then
            for _, name in pairs(selectedPlayers) do
                local target = game.Players:FindFirstChild(name)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    target.Character.HumanoidRootPart.CFrame = localChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                end
            end
        end
    end,
})
local Section = Tab:CreateSection("Esp",false)
local Toggle = Tab:CreateToggle({
    Name = "ESP Player",
    CurrentValue = false,
    Flag = "ToggleESP",
    Callback = function(Value)
        _G.ESP = Value

        local function createESP(player)
            if player.Character and not player.Character:FindFirstChild("ESPName") then
                local Billboard = Instance.new("BillboardGui")
                Billboard.Name = "ESPName"
                Billboard.Size = UDim2.new(0, 200, 0, 50)
                Billboard.Adornee = player.Character:FindFirstChild("Head")
                Billboard.AlwaysOnTop = true

                local NameLabel = Instance.new("TextLabel")
                NameLabel.Size = UDim2.new(1, 0, 1, 0)
                NameLabel.BackgroundTransparency = 1
                NameLabel.Text = player.Name
                NameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                NameLabel.TextStrokeTransparency = 0
                NameLabel.Font = Enum.Font.SourceSansBold
                NameLabel.TextScaled = true
                NameLabel.Parent = Billboard

                Billboard.Parent = player.Character
            end
        end

        if not _G.ESPConnection then
            _G.ESPConnection = game:GetService("RunService").RenderStepped:Connect(function()
                if _G.ESP then
                    for _, player in pairs(game.Players:GetPlayers()) do
                        if player ~= game.Players.LocalPlayer then
                            createESP(player)
                        end
                    end
                else
                    for _, player in pairs(game.Players:GetPlayers()) do
                        if player.Character and player.Character:FindFirstChild("ESPName") then
                            player.Character:FindFirstChild("ESPName"):Destroy()
                        end
                    end
                end
            end)
        end
    end,
})
local Toggle = Tab:CreateToggle({
    Name = "ESP Mob",
    CurrentValue = false,
    Flag = "ToggleESPMob",
    Callback = function(Value)
        _G.ESPMob = Value

        local function createESP(mob)
            if mob:FindFirstChild("Head") and not mob:FindFirstChild("ESPName") then
                local Billboard = Instance.new("BillboardGui")
                Billboard.Name = "ESPName"
                Billboard.Size = UDim2.new(0, 200, 0, 50)
                Billboard.Adornee = mob:FindFirstChild("Head")
                Billboard.AlwaysOnTop = true

                local NameLabel = Instance.new("TextLabel")
                NameLabel.Size = UDim2.new(1, 0, 1, 0)
                NameLabel.BackgroundTransparency = 1
                NameLabel.Text = mob.Name
                NameLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- xanh lá cho mob
                NameLabel.TextStrokeTransparency = 0
                NameLabel.Font = Enum.Font.SourceSansBold
                NameLabel.TextScaled = true
                NameLabel.Parent = Billboard

                Billboard.Parent = mob
            end
        end

        if not _G.ESPMobConnection then
            _G.ESPMobConnection = game:GetService("RunService").RenderStepped:Connect(function()
                if _G.ESPMob then
                    for _, mob in pairs(workspace.Mobs:GetChildren()) do
                        createESP(mob)
                    end
                else
                    for _, mob in pairs(workspace.Mobs:GetChildren()) do
                        if mob:FindFirstChild("ESPName") then
                            mob:FindFirstChild("ESPName"):Destroy()
                        end
                    end
                end
            end)
        end
    end,
})
local Toggle = Tab:CreateToggle({
    Name = "ESP NPC",
    CurrentValue = false,
    Flag = "ToggleESPNPC",
    Callback = function(Value)
        _G.ESPNPC = Value

        local function createESP(npc)
            if npc:FindFirstChild("Head") and not npc:FindFirstChild("ESPName") then
                local Billboard = Instance.new("BillboardGui")
                Billboard.Name = "ESPName"
                Billboard.Size = UDim2.new(0, 200, 0, 50)
                Billboard.Adornee = npc:FindFirstChild("Head")
                Billboard.AlwaysOnTop = true

                local NameLabel = Instance.new("TextLabel")
                NameLabel.Size = UDim2.new(1, 0, 1, 0)
                NameLabel.BackgroundTransparency = 1
                NameLabel.Text = npc.Name
                NameLabel.TextColor3 = Color3.fromRGB(255, 255, 0) -- vàng cho NPC
                NameLabel.TextStrokeTransparency = 0
                NameLabel.Font = Enum.Font.SourceSansBold
                NameLabel.TextScaled = true
                NameLabel.Parent = Billboard

                Billboard.Parent = npc
            end
        end

        if not _G.ESPNPCConnection then
            _G.ESPNPCConnection = game:GetService("RunService").RenderStepped:Connect(function()
                if _G.ESPNPC then
                    for _, npc in pairs(workspace.NPCs:GetChildren()) do
                        createESP(npc)
                    end
                else
                    for _, npc in pairs(workspace.NPCs:GetChildren()) do
                        if npc:FindFirstChild("ESPName") then
                            npc:FindFirstChild("ESPName"):Destroy()
                        end
                    end
                end
            end)
        end
    end,
})
local Section = Tab:CreateSection("Out of Function",false)
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
getgenv().Image = "rbxthumb://type=Asset&id=111167393120231&w=420&h=420"
getgenv().ToggleUI = "RightShift"

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
