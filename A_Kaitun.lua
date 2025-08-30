local PremiumKeys = {  
"AURA-BXID9-RGC9T-J9F-YA0MQ-11FEE",
"AURA-8SFMF-30ABW-Q8K-U3A0O-E98PA",
"AURA-OBTRB-8ZFNK-9ZX-EWL1R-FHZOL",
"AURA-H7VLB-CSCC5-8HL-TM36J-9OUAI",
"AURA-OPR6K-HMDCN-5TO-PM6K8-PKM97",
"AURA-ATHE0-DIYB8-6EV-MKHHU-E1YF7",
"AURA-RJ348-ZU95P-CIA-X99GI-682XG",
"AURA-V9DZK-MFID8-1EH-YKHLH-BSCIT",
"AURA-K6C3B-CU35K-3YW-43WEW-PY2FJ",
"AURA-VCX1W-2QCQ5-6DD-SX621-IUV0G",    
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
  
if not getgenv().Key or getBlacklistReason(getgenv().Key) then  
    local reason = getBlacklistReason(getgenv().Key) or "Key bị chặn"  
    game:GetService("Players").LocalPlayer:Kick(reason)  
    return  
end  
  
if isPremiumKey(getgenv().Key) then  
 local Scripts = {
   [1234567890] = "link",
}
local url = Scripts[game.PlaceId] or Scripts[game.GameId]
if url then
    loadstring(game:HttpGetAsync(url))()
  end   
else  
    game:GetService("Players").LocalPlayer:Kick("Invalid Key")  
end
