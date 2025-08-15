local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Aura Hub | Premium | By Ziugpro",
    SubTitle = "NO FREE",
    TabWidth = 150,
    Size = UDim2.fromOffset(540, 375),
    Acrylic = true, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})
local Tabs = {
    Esp = Window:AddTab({ Title = "Tab Esp and Shop", Icon = "" }),
    Player = Window:AddTab({ Title = "Tab Player and Misc", Icon = "" }),
    Web = Window:AddTab({ Title = "Tab Webhook", Icon = "" }),
    Sv = Window:AddTab({ Title = "Tab Setting Ui", Icon = "" }),
}

--{ Phần Này Cũng Đéo Lỗi }--
local EspPlayer = Tabs.Esp:AddToggle("ESP_Player", {Title = "ESP Player", Default = false })
EspPlayer:OnChanged(function(Value)
    _G.ESP_Player = Value
end)

spawn(function()
    while wait() do
        if _G.ESP_Player then
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    if player.Character and player.Character:FindFirstChild("Head") and not player.Character.Head:FindFirstChild("NameESP") then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Name = "NameESP"
                        billboard.AlwaysOnTop = true
                        billboard.Size = UDim2.new(0, 200, 0, 50) -- Không auto zoom
                        billboard.StudsOffset = Vector3.new(0, 2, 0)
                        billboard.Parent = player.Character.Head

                        local nameLabel = Instance.new("TextLabel")
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.Size = UDim2.new(1, 0, 1, 0)
                        nameLabel.Text = player.Name
                        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        nameLabel.TextStrokeTransparency = 0
                        nameLabel.TextScaled = true
                        nameLabel.Parent = billboard
                    end
                end
            end
        else
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                    local esp = player.Character.Head:FindFirstChild("NameESP")
                    if esp then esp:Destroy() end
                end
            end
        end
    end
end)
local ESPNPC = Tabs.Esp:AddToggle("ESP_NPC", {Title = "ESP NPC", Default = false })
ESPNPC:OnChanged(function(Value)
    _G.ESP_NPC = Value
end)

spawn(function()
    while wait() do
        if _G.ESP_NPC then
            for _, npc in pairs(workspace.NPCs:GetChildren()) do
                if npc:FindFirstChild("Head") and not npc.Head:FindFirstChild("NameESP") then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "NameESP"
                    billboard.AlwaysOnTop = true
                    billboard.Size = UDim2.new(0, 200, 0, 50) -- Không auto zoom
                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                    billboard.Parent = npc.Head

                    local nameLabel = Instance.new("TextLabel")
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.Size = UDim2.new(1, 0, 1, 0)
                    nameLabel.Text = npc.Name
                    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    nameLabel.TextStrokeTransparency = 0
                    nameLabel.TextScaled = true
                    nameLabel.Parent = billboard
                end
            end
        else
            for _, npc in pairs(workspace.NPCs:GetChildren()) do
                if npc:FindFirstChild("Head") then
                    local esp = npc.Head:FindFirstChild("NameESP")
                    if esp then esp:Destroy() end
                end
            end
        end
    end
end)
local EspMob = Tabs.Esp:AddToggle("ESP_Mob", {Title = "ESP Brainrot", Default = false })
EspMob:OnChanged(function(Value)
    _G.ESP_Mob = Value
end)

spawn(function()
    while wait() do
        if _G.ESP_Mob then
            for _, mob in pairs(workspace.Mobs:GetChildren()) do
                if mob:FindFirstChild("Head") and not mob.Head:FindFirstChild("NameESP") then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "NameESP"
                    billboard.AlwaysOnTop = true
                    billboard.Size = UDim2.new(0, 200, 0, 50) -- Không auto zoom
                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                    billboard.Parent = mob.Head

                    local nameLabel = Instance.new("TextLabel")
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.Size = UDim2.new(1, 0, 1, 0)
                    nameLabel.Text = mob.Name
                    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    nameLabel.TextStrokeTransparency = 0
                    nameLabel.TextScaled = true
                    nameLabel.Parent = billboard
                end
            end
        else
            for _, mob in pairs(workspace.Mobs:GetChildren()) do
                if mob:FindFirstChild("Head") then
                    local esp = mob.Head:FindFirstChild("NameESP")
                    if esp then esp:Destroy() end
                end
            end
        end
    end
end)
local ESPHitboxTimer = Tabs.Esp:AddToggle("ESP_HitboxTimer", {Title = "ESP LockBase", Default = false })
ESPHitboxTimer:OnChanged(function(Value)
    _G.ESP_HitboxTimer = Value
end)

spawn(function()
    local timers = {}

    while wait(1) do
        if _G.ESP_HitboxTimer then
            for _, hitbox in pairs(workspace:GetChildren()) do
                if hitbox.Name == "Hitbox" and hitbox:FindFirstChild("Head") then
                    if not timers[hitbox] then
                        timers[hitbox] = math.random(60, 200)
                    end
                    if not hitbox.Head:FindFirstChild("TimerESP") then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Name = "TimerESP"
                        billboard.AlwaysOnTop = true
                        billboard.Size = UDim2.new(0, 200, 0, 50)
                        billboard.StudsOffset = Vector3.new(0, 2, 0)
                        billboard.Parent = hitbox.Head

                        local label = Instance.new("TextLabel")
                        label.BackgroundTransparency = 1
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.TextColor3 = Color3.fromRGB(255, 255, 255)
                        label.TextStrokeTransparency = 0
                        label.TextScaled = true
                        label.Parent = billboard
                    end

                    local espLabel = hitbox.Head.TimerESP:FindFirstChildOfClass("TextLabel")
                    if espLabel then
                        espLabel.Text = tostring(timers[hitbox])
                    end

                    timers[hitbox] = timers[hitbox] - 1
                    if timers[hitbox] < 0 then
                        wait(3)
                        timers[hitbox] = math.random(60, 200)
                    end
                end
            end
        else
            for _, hitbox in pairs(workspace:GetChildren()) do
                if hitbox.Name == "Hitbox" and hitbox:FindFirstChild("Head") then
                    local esp = hitbox.Head:FindFirstChild("TimerESP")
                    if esp then esp:Destroy() end
                end
            end
            timers = {}
        end
    end
end)

local Main = Tabs.Esp:AddSection("Shop")
local Pet = {
  "All",
  "Noobini Pizzanini",
  "Tim Cheese",
  "Lirili Larila",
  "Tung Tung Tung Sahur",
  "Fluriflura",
  "Trippi Troppi",
  "Capachino Assassino",
  "Boneca Ambalabu",
  "Gangster Footera",
  "Svinina Bombardino",
  "Brr.Brr. Patapim", 
  "Bananita Dolphinita",  
  "Trulimero Trulicinea",  
  "Ta Ta Ta Ta Sahur",  
  "Frigo Camelo",
  "Chef Crabracadebra",
  "Burbaloni Loliloli",
  "Tralalero Tralala",
  "Frigo Camelo",
}
local MultiDropdown = Tabs.Esp:AddDropdown("MultiDropdown", {
        Title = "Select Pet",
        Description = "",
        Values = Pet,
        Multi = true,
        Default = {"one", "two"},
        Callback = function(Value)
        end
    })
local Type = {
  "Rare",
  "Common",
  "Epic",
  "Legendary",
  "Mythic",
  "Brainrot God", 
}
local MultiDropdown = Tabs.Esp:AddDropdown("MultiDropdown", {
        Title = "Select Type",
        Description = "",
        Values = Type,
        Multi = true,
        Default = {"one", "two"},
        Callback = function(Value)
        end
    })
local Toggle = Tabs.Esp:AddToggle("Toggle", {Title = "Auto Buy", Default = false })
local Toggle = Tabs.Esp:AddToggle("Toggle", {Title = "Auto Buy All [Good]", Default = false })
--{ Từ Đây Lên Trên Đéo Có Lỗi }--

--{ Phần Này Đéo Có Lỗi }--

local Input = Tabs.Web:AddInput("Input", {
        Title = "Webhook",
        Default = "",
        Placeholder = "Url",
        Numeric = false,
        Finished = false, 
        Callback = function(Value)
        end
    })

local Toggle = Tabs.Web:AddToggle("Toggle", {Title = "Tag Everyone", Default = false })
local Toggle = Tabs.Web:AddToggle("Toggle", {Title = "Start Webhook", Default = false })

local Main = Tabs.Web:AddSection("Setting")

local Toggle = Tabs.Web:AddToggle("Toggle", {Title = "When You Steal Brainrot", Default = false })
local Toggle = Tabs.Web:AddToggle("Toggle", {Title = "When Buy Brainrot", Default = false })
local Toggle = Tabs.Web:AddToggle("Toggle", {Title = "When You Is Attack", Default = false })

--{ Phần Player Này Đéo Có Lỗi }--
local SpeedValue = 16

local Speedslider = Tabs.Player:AddSlider("Speed_Slider", {
    Title = "Character Speed",
    Default = 16,
    Min = 16,
    Max = 100,
    Rounding = 1,
    Callback = function(Value)
        SpeedValue = Value
    end
})

local SpeedToggle = Tabs.Player:AddToggle("Speed_Toggle", {Title = "Enable Speed", Default = false })
SpeedToggle:OnChanged(function(Value)
    _G.Speed_Toggle = Value
end)

spawn(function()
    while wait() do
        if _G.Speed_Toggle then
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid").WalkSpeed = SpeedValue
            end
        else
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
            end
        end
    end
end)
local JumpValue = 50

local JumpSlider = Tabs.Player:AddSlider("Jump_Slider_ID", {
    Title = "Character Jump",
    Default = 50,
    Min = 50,
    Max = 200,
    Rounding = 1,
    Callback = function(Value)
        JumpValue = Value
    end
})

local JumpToggle = Tabs.Player:AddToggle("Jump_Toggle_ID", {Title = "Enable Jump", Default = false })
JumpToggle:OnChanged(function(Value)
    _G.Jump_Toggle = Value
end)

spawn(function()
    while wait() do
        if _G.Jump_Toggle then
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid").JumpPower = JumpValue
            end
        else
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid").JumpPower = 50
            end
        end
    end
end)
local AuraRange = 10

local AuraSlider = Tabs.Player:AddSlider("KillAura_Range_ID", {
    Title = "Kill Aura Range",
    Default = 10,
    Min = 5,
    Max = 50,
    Rounding = 1,
    Callback = function(Value)
        AuraRange = Value
    end
})

local AuraToggle = Tabs.Player:AddToggle("KillAura_Toggle_ID", {Title = "Enable Kill Aura", Default = false })
AuraToggle:OnChanged(function(Value)
    _G.KillAura_Enabled = Value
end)

spawn(function()
    while wait(0.1) do
        if _G.KillAura_Enabled then
            local player = game.Players.LocalPlayer
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                for _, v in pairs(game.Workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= char then
                        local hrp = v:FindFirstChild("HumanoidRootPart")
                        if hrp and (hrp.Position - char.HumanoidRootPart.Position).Magnitude <= AuraRange then
                            v.Humanoid.Health = 0
                        end
                    end
                end
            end
        end
    end
end)
local NoClipToggle = Tabs.Player:AddToggle("NoClip_Toggle_ID", {Title = "NoClip", Default = false })
NoClipToggle:OnChanged(function(Value)
    _G.NoClip_Enabled = Value
end)

spawn(function()
    while wait() do
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide ~= nil then
                    v.CanCollide = not _G.NoClip_Enabled
                end
            end
        end
    end
end)
local Main = Tabs.Player:AddSection("Misc")
local AntibanToggle = Tabs.Player:AddToggle("Antiban_Toggle_ID", {Title = "Antiban", Default = false })
AntibanToggle:OnChanged(function(Value)
    _G.Antiban_Enabled = Value
end)

spawn(function()
    while wait() do
        if _G.Antiban_Enabled then
            pcall(function()
                game:GetService("ReplicatedStorage").Events.AntiCheat:Destroy()
            end)
        end
    end
end)
local AntiKickToggle = Tabs.Player:AddToggle("AntiKick_Toggle_ID", {Title = "AntiKick", Default = false })
AntiKickToggle:OnChanged(function(Value)
    _G.AntiKick_Enabled = Value
    if Value then
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" or method == "kick" then
                return nil
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end
end)




--{ Cái Nút Bật Tắt Ui Xác Nhận Không Lỗi }--
game.StarterGui:SetCore("SendNotification", {
    Title = "Aura Hub",
    Text = "Success Loading",
    Icon = "rbxthumb://type=Asset&id=83230952715744&w=420&h=420",
    Duration = 5,
    Callback = function()
    end
})
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
getgenv().Image = "rbxthumb://type=Asset&id=83230952715744&w=420&h=420"
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


--{ Phần Lưu Setting Đéo Có Lỗi }--
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Sv)
SaveManager:BuildConfigSection(Tabs.Sv)
SaveManager:LoadAutoloadConfig()
