local PremiumKeys = {  
    "JRTtibghwXeykmqzh4r3oCvzf35xtb",  
}  
  
local BlacklistKeys = {  
    ["ERETOI3yH7FuimXMDxZyLkibiQB6d7zg"] = "KEY IS BLACKLIST - KEY ĐÃ BỊ THÊM VÀO DANH SÁCH ĐEN",
    ["xdR3YKgBZ8RqeYtKUS8tB8tBklggsfcC"] = "KEY IS BLACKLIST - KEY ĐÃ BỊ THÊM VÀO DANH SÁCH ĐEN", 
    ["U02WZNd3rGQyRaj7tDwtICXGEgvtkfRT"] = "KEY IS BLACKLIST - KEY ĐÃ BỊ THÊM VÀO DANH SÁCH ĐEN",
    ["WGZTff6yt66ljbJucCbPfZZMyiHKjaDn"] = "KEY IS BLACKLIST - KEY ĐÃ BỊ THÊM VÀO DANH SÁCH ĐEN",
    ["2CgBaWfrkjGSBD1rWL6USVYwsznDGFQk"] = "KEY IS BLACKLIST - KEY ĐÃ BỊ THÊM VÀO DANH SÁCH ĐEN",
    ["j9rLTuR9nWxKUvfKSrSLTQT2pSttC89D"] = "KEY IS BLACKLIST - KEY ĐÃ BỊ THÊM VÀO DANH SÁCH ĐEN",
    ["GZD3BU59xagElF6ZmKBxcF8isTre3r05"] = "KEY IS BLACKLIST - KEY ĐÃ BỊ THÊM VÀO DANH SÁCH ĐEN",
    ["9trWCqgCa3GY5uUZCpWqTFIkZsmlbS7J"] = "KEY IS BLACKLIST - KEY ĐÃ BỊ THÊM VÀO DANH SÁCH ĐEN",
    ["OVnXGz3r50s9Sorjphv5bNu6aAkh9jNT"] = "KEY IS BLACKLIST - KEY ĐÃ BỊ THÊM VÀO DANH SÁCH ĐEN",
    ["gdG7BgzbuCAbBbFmAIKor2uLkDaJbhPx"] = "KEY IS BLACKLIST - KEY ĐÃ BỊ THÊM VÀO DANH SÁCH ĐEN",
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
FullBlack.BackgroundTransparency = 0
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
    
local Note = Instance.new("TextLabel")
Note.AnchorPoint = Vector2.new(0.5, 0.5)
Note.Position = UDim2.new(0.5, 0, 0.5, 80)
Note.Size = UDim2.new(0, 600, 0, 50)
Note.BackgroundTransparency = 1
Note.Text = "Wait for the countdown to end to activate kaitun"
Note.Font = Enum.Font.PermanentMarker
Note.TextSize = 24
Note.TextColor3 = Color3.fromRGB(255, 255, 255)
Note.ZIndex = 39999999
Note.Parent = ScreenGui


local Timewait = Instance.new("TextLabel")
Timewait.AnchorPoint = Vector2.new(0.5, 0.5)
Timewait.Position = UDim2.new(0.5, 0, 0.5, 140)
Timewait.Size = UDim2.new(0, 600, 0, 50)
Timewait.BackgroundTransparency = 1
Timewait.Text = "1:00"
Timewait.Font = Enum.Font.GothamBold
Timewait.TextSize = 40
Timewait.TextColor3 = Color3.fromRGB(255, 255, 255)
Timewait.ZIndex = 39999999
Timewait.Parent = ScreenGui

task.spawn(function()
    local seconds = 27
    while seconds >= 0 do
        local minutes = math.floor(seconds / 60)
        local secs = seconds % 60
        Timewait.Text = string.format("%02d:%02d", minutes, secs)
        task.wait(1)
        seconds -= 1
    end
    Timewait.Text = "Start Kaitun......."
end)
    
task.spawn(function()
            task.wait(27)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

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

local function clickMiddleScreen()
    local VirtualUser = game:GetService("VirtualUser")
    VirtualUser:CaptureController()
    VirtualUser:ClickButton1(Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2))
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
                    local prompts = getPrompt(chest)
                    for _, prompt in ipairs(prompts) do
                        fireproximityprompt(prompt, math.huge)
                    end
                    local t = tick()
                    while _G.AutoChestData.running and tick() - t < 5 do
                        humanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 6, 0)
                        humanoidRootPart.Velocity = Vector3.zero
                        humanoidRootPart.RotVelocity = Vector3.zero
                        clickMiddleScreen()
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
            task.wait(27)
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
local PLACE_ID = game.PlaceId

task.delay(20, function()
    TeleportService:Teleport(PLACE_ID, player)
end)
end)
  else  
    game:GetService("Players").LocalPlayer:Kick("Invalid Key")  
end
