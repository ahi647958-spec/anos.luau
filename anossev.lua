-- [[ m1v San Aurie Heist System v8.1 ]] --
-- مدمج مع AutoATM Hack القديم + Bypass متقدم

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- ================================
-- GAME RULES (من السكربت القديم)
-- ================================
local GameRules
pcall(function()
    GameRules = require(game.ReplicatedStorage.Modules.GameRules)
end)

local autoHackOn = true
if GameRules then
    GameRules.disableHacking = autoHackOn
end

-- ================================
-- ADVANCED BYPASS SYSTEM
-- ================================

-- 1. TOKEN EXTRACTION
local function ExtractToken()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("StringValue") or v:IsA("ValueBase") then
                local name = string.lower(v.Name)
                if string.find(name, "token") or string.find(name, "key") or 
                   string.find(name, "session") or string.find(name, "handshake") then
                    return v.Value
                end
            end
        end
    end)
    return "BYPASSED_" .. HttpService:GenerateGUID(false)
end

-- 2. REMOTE EVENT BYPASS
local function BypassRemoteEvents()
    pcall(function()
        local originalFireServer = game:GetService("ReplicatedStorage").RemoteEvent.FireServer
        game:GetService("ReplicatedStorage").RemoteEvent.FireServer = function(...)
            local args = {...}
            local token = ExtractToken()
            if token then
                table.insert(args, token)
            end
            return originalFireServer(unpack(args))
        end
    end)
end

-- 3. FORCE GAME RULES (من السكربت القديم مطور)
local function ForceGameRules()
    if GameRules then
        pcall(function()
            GameRules.disableHacking = true
        end)
    end
end

-- 4. RUN ALL BYPASSES
local function RunAllBypasses()
    pcall(function()
        BypassRemoteEvents()
        ForceGameRules()
    end)
end

-- تشغيل الـ Bypass فوراً
RunAllBypasses()

-- تشغيل دوري
RunService.Heartbeat:Connect(function()
    pcall(RunAllBypasses)
end)

-- ================================
-- GUI (من السكربت القديم مطور)
-- ================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "m1vHeist"
local ok, _ = pcall(function() ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end)
if not ok then pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end) end

local theme = {
    bg = Color3.fromRGB(20, 8, 10),
    panel = Color3.fromRGB(40, 15, 18),
    accent = Color3.fromRGB(220, 50, 50),
    text = Color3.fromRGB(240, 210, 210),
    on = Color3.fromRGB(0, 200, 80),
    off = Color3.fromRGB(55, 55, 65),
}

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 220, 0, 100)
main.Position = UDim2.new(0.02, 0, 0.35, 0)
main.BackgroundColor3 = theme.bg
main.BorderSizePixel = 0
main.Parent = ScreenGui
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", main).Color = Color3.fromRGB(80, 30, 35)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 0, 28)
title.Position = UDim2.new(0, 10, 0, 4)
title.BackgroundTransparency = 1
title.Text = "m1v Auto Hack"
title.TextColor3 = theme.accent
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local toggleBg = Instance.new("Frame")
toggleBg.Size = UDim2.new(1, -12, 0, 32)
toggleBg.Position = UDim2.new(0, 6, 0, 34)
toggleBg.BackgroundColor3 = theme.panel
toggleBg.BorderSizePixel = 0
toggleBg.Parent = main
Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(0, 6)

local toggleLbl = Instance.new("TextLabel")
toggleLbl.Size = UDim2.new(1, -50, 1, 0)
toggleLbl.Position = UDim2.new(0, 10, 0, 0)
toggleLbl.BackgroundTransparency = 1
toggleLbl.Text = "Auto-Skip Hack"
toggleLbl.TextColor3 = theme.text
toggleLbl.TextSize = 13
toggleLbl.Font = Enum.Font.Gotham
toggleLbl.TextXAlignment = Enum.TextXAlignment.Left
toggleLbl.Parent = toggleBg

local sw = Instance.new("Frame")
sw.Size = UDim2.new(0, 36, 0, 18)
sw.Position = UDim2.new(1, -44, 0.5, -9)
sw.BackgroundColor3 = theme.on
sw.BorderSizePixel = 0
sw.Parent = toggleBg
Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)

local kb = Instance.new("Frame")
kb.Size = UDim2.new(0, 14, 0, 14)
kb.Position = UDim2.new(0, 20, 0, 2)
kb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
kb.BorderSizePixel = 0
kb.Parent = sw
Instance.new("UICorner", kb).CornerRadius = UDim.new(1, 0)

toggleBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        autoHackOn = not autoHackOn
        if GameRules then
            GameRules.disableHacking = autoHackOn
        end
        sw.BackgroundColor3 = autoHackOn and theme.on or theme.off
        kb.Position = autoHackOn and UDim2.new(0, 20, 0, 2) or UDim2.new(0, 2, 0, 2)
        task.wait()
        statusLbl.Text = autoHackOn and "Status: ON (hacks auto-complete)" or "Status: OFF"
        statusLbl.TextColor3 = autoHackOn and theme.on or theme.off
    end
end)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -24, 0, 6)
closeBtn.BackgroundColor3 = theme.off
closeBtn.Text = "X"
closeBtn.TextColor3 = theme.text
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = main
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)
closeBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, -12, 0, 20)
statusLbl.Position = UDim2.new(0, 6, 0, 70)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "Status: ON (hacks auto-complete)"
statusLbl.TextColor3 = theme.on
statusLbl.TextSize = 10
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextXAlignment = Enum.TextXAlignment.Center
statusLbl.Parent = main

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if GameRules then
        GameRules.disableHacking = autoHackOn
    end
end)

-- ================================
-- NOTIFICATION
-- ================================
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "m1v Auto Hack",
    Text = "Bypass + GameRules Force Active",
    Duration = 3
})

print("m1v Auto Hack Loaded | edited by pece")
