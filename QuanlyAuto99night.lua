local PremiumKeys = {  
    "JRTtibghwXeykmqzh4r3oCvzf35xtb",  
    "ERETOI3yH7FuimXMDxZyLkibiQB6d7zg",
    "xdR3YKgBZ8RqeYtKUS8tB8tBklggsfcC",
    "U02WZNd3rGQyRaj7tDwtICXGEgvtkfRT",
    "WGZTff6yt66ljbJucCbPfZZMyiHKjaDn",
    "2CgBaWfrkjGSBD1rWL6USVYwsznDGFQk",
    "j9rLTuR9nWxKUvfKSrSLTQT2pSttC89D",
    "GZD3BU59xagElF6ZmKBxcF8isTre3r05",
    "9trWCqgCa3GY5uUZCpWqTFIkZsmlbS7J",
    "OVnXGz3r50s9Sorjphv5bNu6aAkh9jNT",
    "gdG7BgzbuCAbBbFmAIKor2uLkDaJbhPx",
}  
  
local BlacklistKeys = {  
    ["abc123"] = "Hành vi gian lận bị phát hiện",  
    ["badkey456"] = "Vi phạm điều khoản sử dụng",  
    ["xyz789"] = "Key đã bị thu hồi do lạm dụng"  
}  
  
local function isPremiumKey(key)  
    for _, v in ipairs(PremiumKeys) do  
        if v == key then  
            return true  
        end  
    end  
    return false  
end  
  
local function getBlacklistReason(key)  
    return BlacklistKeys[key]  
end  
  
if not script_key or getBlacklistReason(script_key) then  
    local reason = getBlacklistReason(script_key) or "Key bị chặn"  
    game:GetService("Players").LocalPlayer:Kick(reason)  
    return  
end  
  
if isPremiumKey(script_key) then  
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KaitunUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 99
ScreenGui.Parent = PlayerGui

local FullBlack = Instance.new("Frame")
FullBlack.Size = UDim2.new(1, 0, 1, 36)
FullBlack.Position = UDim2.new(0, 0, -0.03, 0)
FullBlack.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
FullBlack.BorderSizePixel = 0
FullBlack.ZIndex = 19999999
FullBlack.BackgroundTransparency = 0.9
FullBlack.Parent = ScreenGui

local Image = Instance.new("ImageLabel")
Image.Size = UDim2.new(0, 100, 0, 100)
Image.Position = UDim2.new(0.5, -50, 0.5, -90)
Image.BackgroundTransparency = 1
Image.Image = "rbxthumb://type=Asset&id=131484641795167&w=420&h=420"
Image.ZIndex = 29999999
Image.Parent = ScreenGui

local Version = Instance.new("TextLabel")
Version.AnchorPoint = Vector2.new(0.5, 0.5)
Version.Position = UDim2.new(0.5, 0, 0.5, 40)
Version.Size = UDim2.new(0, 600, 0, 50)
Version.BackgroundTransparency = 1
Version.Text = "Aura Hub"
Version.Font = Enum.Font.PermanentMarker
Version.TextSize = 55
Version.TextColor3 = Color3.fromRGB(255, 255, 255)
Version.ZIndex = 39999999
Version.Parent = ScreenGui

task.spawn(function()
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

if not _G.AutoChestData then
    _G.AutoChestData = {running = false}
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

local function clickCenter()
    local viewport = camera.ViewportSize
    local x = viewport.X / 2
    local y = viewport.Y / 2
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

if not _G.AutoChestData.running then
    _G.AutoChestData.running = true
    task.spawn(function()
        while _G.AutoChestData.running do
            local chests = getChests()
            for _, chest in ipairs(chests) do
                if not _G.AutoChestData.running then break end
                local part = chest.PrimaryPart or chest:FindFirstChildWhichIsA("BasePart")
                if part then
                    player.CameraMode = Enum.CameraMode.LockFirstPerson
                    humanoidRootPart.CFrame = part.CFrame - Vector3.new(0, 3, 0)
                    humanoidRootPart.Velocity = Vector3.zero
                    humanoidRootPart.RotVelocity = Vector3.zero
                    clickCenter()
                    local t = tick()
                    while _G.AutoChestData.running and tick() - t < 5 do
                        humanoidRootPart.CFrame = part.CFrame - Vector3.new(0, 3, 0)
                        humanoidRootPart.Velocity = Vector3.zero
                        humanoidRootPart.RotVelocity = Vector3.zero
                        task.wait()
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end
end)

task.spawn(function()
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
local PLACE_ID = game.PlaceId

task.delay(20, function()
    TeleportService:Teleport(PLACE_ID, player)
end)
end)

task.spawn(function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local function getRemotes(parent)
    local remotes = {}
    for _, obj in ipairs(parent:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            table.insert(remotes, obj)
        end
    end
    return remotes
end

local allRemotes = {}
for _, parent in ipairs({ReplicatedStorage, Workspace}) do
    for _, r in ipairs(getRemotes(parent)) do
        table.insert(allRemotes, r)
    end
end

for _, remote in ipairs(allRemotes) do
    if remote:IsA("RemoteEvent") then
        remote:FireServer()
    elseif remote:IsA("RemoteFunction") then
        pcall(function()
            remote:InvokeServer()
        end)
    end
end
end)
  else  
    game:GetService("Players").LocalPlayer:Kick("Invalid Key")  
end
