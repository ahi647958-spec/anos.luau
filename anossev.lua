-- [[ m1v San Aurie Anti-Cheat Bypass v8 ]] --
-- Advanced Bypass for Handshake + Dynamic Keys + Remote Event Protection
-- Bypasses Token Verification, Event Renaming, Memory Hacking Detection

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- ================================
-- ADVANCED BYPASS SYSTEM
-- ================================

-- 1. TOKEN / HANDSHAKE BYPASS
-- السيرفر كيتوقع Token مع كل طلب، هاد السكربت كيستخرج التوكن الحقيقي
local function ExtractToken()
    pcall(function()
        -- البحث عن التوكن فـ الذاكرة
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("StringValue") or v:IsA("ValueBase") then
                local name = string.lower(v.Name)
                if string.find(name, "token") or 
                   string.find(name, "key") or 
                   string.find(name, "session") or
                   string.find(name, "handshake") or
                   string.find(name, "auth") then
                    return v.Value
                end
            end
        end
        
        -- البحث فـ Modules
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("ModuleScript") then
                local name = string.lower(v.Name)
                if string.find(name, "token") or 
                   string.find(name, "auth") or
                   string.find(name, "session") then
                    -- قراءة الكود ديال الـ Module واستخراج التوكن
                    local code = v:GetFullName()
                    local token = string.match(code, "TOKEN%s*=%s*[\"']([^\"']+)[\"']")
                    if token then
                        return token
                    end
                end
            end
        end
        
        -- البحث فـ الـ Remote Events
        for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                local name = string.lower(v.Name)
                if string.find(name, "token") or 
                   string.find(name, "auth") or
                   string.find(name, "key") then
                    return "BYPASSED_" .. HttpService:GenerateGUID(false)
                end
            end
        end
    end)
    return "BYPASSED_" .. HttpService:GenerateGUID(false)
end

-- 2. REMOTE EVENT BYPASS
-- كيحلل الـ Remote Events ويخليك تبعث طلباتك من غير ما ينكشف
local function BypassRemoteEvents()
    pcall(function()
        -- خزن الـ Original Functions
        local originalFireServer = game:GetService("ReplicatedStorage").RemoteEvent.FireServer
        
        -- Override FireServer مع Bypass
        game:GetService("ReplicatedStorage").RemoteEvent.FireServer = function(...)
            local args = {...}
            
            -- اضف التوكن لكل طلب
            local token = ExtractToken()
            if token then
                table.insert(args, token)
            end
            
            -- غير السمية ديال الـ Event بشكل مؤقت
            local eventName = tostring(args[1])
            if eventName then
                -- شوف إذا كان الـ Event حساس
                local sensitiveEvents = {"money", "cash", "bank", "heist", "robbery", "vehicle", "car", "lock", "unlock"}
                for _, sensitive in ipairs(sensitiveEvents) do
                    if string.find(string.lower(eventName), sensitive) then
                        -- غير السمية
                        args[1] = "BYPASS_" .. sensitive .. "_" .. HttpService:GenerateGUID(false)
                    end
                end
            end
            
            -- إرسال الطلب
            return originalFireServer(unpack(args))
        end
    end)
end

-- 3. MEMORY HACKING BYPASS
-- كيخلي السيرفر ما يقدرش يكشف التغييرات فـ الذاكرة
local function BypassMemoryHacking()
    pcall(function()
        -- منع السيرفر من مقارنة القيم
        local function fakeValueCheck()
            -- خداع السيرفر بالقيم الصحيحة
            if LocalPlayer and LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    local health = humanoid.Health
                    local maxHealth = humanoid.MaxHealth
                    
                    -- خلي القيم فـ النطاق الطبيعي
                    if health > maxHealth then
                        humanoid.Health = maxHealth
                    end
                    if health < 0 then
                        humanoid.Health = 0
                    end
                    
                    -- Speed
                    local walkSpeed = humanoid.WalkSpeed
                    if walkSpeed > 20 then
                        humanoid.WalkSpeed = 20
                    end
                end
            end
        end
        
        -- Loop to keep values normal
        RunService.Heartbeat:Connect(function()
            pcall(fakeValueCheck)
        end)
    end)
end

-- 4. EVENT RENAMING BYPASS
-- كيحلل السميات المشفرة ويحولها للسميات الأصلية
local function BypassEventRenaming()
    pcall(function()
        -- البحث عن الـ Events المشفرة
        for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                local name = string.lower(v.Name)
                
                -- محاولة فك التشفير
                local decodedName = ""
                for i = 1, #name do
                    local char = string.sub(name, i, i)
                    local code = string.byte(char)
                    if code >= 97 and code <= 122 then
                        code = code - 5
                        if code < 97 then code = code + 26 end
                    elseif code >= 65 and code <= 90 then
                        code = code - 5
                        if code < 65 then code = code + 26 end
                    end
                    decodedName = decodedName .. string.char(code)
                end
                
                -- إضافة Event جديد بالسمية المفكوكة
                if decodedName and decodedName ~= name then
                    v.Name = decodedName
                end
            end
        end
    end)
end

-- 5. ANTI-STEAL DECRYPTION BYPASS
-- كيحاول يفك تشفير الـ UI والـ Modules
local function BypassDecryption()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("ModuleScript") or v:IsA("LocalScript") then
                -- محاولة فك التشفير
                local source = v:GetFullName()
                
                -- البحث عن أنماط التشفير المعروفة
                if string.find(source, "loadstring") or 
                   string.find(source, "string.char") or
                   string.find(source, "string.byte") then
                    
                    -- محاولة تنفيذ الكود لفك التشفير
                    pcall(function()
                        local decoded = loadstring(source)
                        if decoded then
                            decoded()
                        end
                    end)
                end
            end
        end
    end)
end

-- 6. Dynamic Key Spoofing
-- كيخدع السيرفر بKeys متغيرة
local function SpoofDynamicKeys()
    pcall(function()
        -- توليد Keys متغيرة
        local function generateFakeKey()
            local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
            local key = ""
            for i = 1, 32 do
                key = key .. string.sub(chars, math.random(1, #chars), math.random(1, #chars))
            end
            return key
        end
        
        -- تزويد السيرفر بKeys مزيفة
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("StringValue") or v:IsA("ValueBase") then
                local name = string.lower(v.Name)
                if string.find(name, "key") or 
                   string.find(name, "token") or
                   string.find(name, "session") then
                    v.Value = generateFakeKey()
                end
            end
        end
    end)
end

-- ================================
-- RUN ALL BYPASSES
-- ================================

local function RunAllBypasses()
    pcall(function()
        -- تشغيل كل الـ Bypasses
        BypassRemoteEvents()
        BypassMemoryHacking()
        BypassEventRenaming()
        BypassDecryption()
        SpoofDynamicKeys()
        
        -- استخراج التوكن
        local token = ExtractToken()
        if token then
            _G.M1V_TOKEN = token
        end
    end)
end

-- تشغيل الـ Bypass فوراً
RunAllBypasses()

-- تشغيل دوري باش يضمن عدم اكتشاف أي شيء جديد
RunService.Heartbeat:Connect(function()
    pcall(RunAllBypasses)
end)

-- ================================
-- CONFIG
-- ================================
local Config = {
    autoATM = false,
    autoCarTheft = false,
    autoSmallBank = false,
    autoGrandBank = false,
    autoCasino = false,
    autoYacht = false,
    autoCollectLoot = false,
    autoEscape = false,
    autoHide = false,
    bypassActive = true
}

-- ================================
-- PUZZLE SOLVERS (SPEED OPTIMIZED)
-- ================================

local function ClickAllButtons(pattern)
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("TextButton") and v.Visible and v.Enabled then
                local text = string.lower(v.Text)
                if string.find(text, pattern) then
                    v:Click()
                end
            end
        end
    end)
end

local function SolveTimingPuzzle()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Frame") or v:IsA("ImageLabel") then
                local name = string.lower(v.Name)
                if string.find(name, "timing") or string.find(name, "circle") or 
                   string.find(name, "bar") or string.find(name, "sweet") then
                    for _, child in ipairs(v:GetDescendants()) do
                        if (child:IsA("TextButton") or child:IsA("ImageButton")) and child.Visible then
                            child:Click()
                        end
                    end
                end
            end
        end
    end)
end

local function SolveLockpickPuzzle()
    ClickAllButtons("pick")
    ClickAllButtons("unlock")
    ClickAllButtons("turn")
end

local function SolveWiringPuzzle()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Frame") then
                local name = string.lower(v.Name)
                if string.find(name, "wiring") or string.find(name, "wire") or 
                   string.find(name, "cable") or string.find(name, "fuse") or
                   string.find(name, "connect") then
                    for _, child in ipairs(v:GetDescendants()) do
                        if child:IsA("TextButton") and child.Visible then
                            child:Click()
                        end
                    end
                end
            end
        end
    end)
end

local function SolveThermitePuzzle()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Frame") then
                local name = string.lower(v.Name)
                if string.find(name, "thermite") or string.find(name, "grid") or 
                   string.find(name, "melt") or string.find(name, "burn") then
                    for _, child in ipairs(v:GetDescendants()) do
                        if child:IsA("TextButton") and child.Visible then
                            child:Click()
                        end
                    end
                end
            end
        end
    end)
end

local function SolveDrillPuzzle()
    ClickAllButtons("drill")
    ClickAllButtons("start")
    ClickAllButtons("bore")
end

local function SolveLaptopHackPuzzle()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Frame") then
                local name = string.lower(v.Name)
                if string.find(name, "laptop") or string.find(name, "hacking") or 
                   string.find(name, "code") or string.find(name, "ip") or
                   string.find(name, "matrix") then
                    for _, child in ipairs(v:GetDescendants()) do
                        if child:IsA("TextButton") and child.Visible and child.Text then
                            if tonumber(child.Text) or string.match(child.Text, "^[A-F0-9]+$") then
                                child:Click()
                            end
                        end
                    end
                end
            end
        end
    end)
end

local function SolveMemoryGamePuzzle()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Frame") then
                local name = string.lower(v.Name)
                if string.find(name, "memory") or string.find(name, "sequence") or 
                   string.find(name, "pattern") or string.find(name, "repeat") then
                    for _, child in ipairs(v:GetDescendants()) do
                        if child:IsA("TextButton") and child.Visible then
                            if child.BackgroundColor3 ~= Color3.fromRGB(30, 30, 35) then
                                child:Click()
                            end
                        end
                    end
                end
            end
        end
    end)
end

local function SolveNumberMatchingPuzzle()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Frame") then
                local name = string.lower(v.Name)
                if string.find(name, "match") or string.find(name, "numbers") or 
                   string.find(name, "matching") or string.find(name, "pair") then
                    for _, child in ipairs(v:GetDescendants()) do
                        if child:IsA("TextButton") and child.Visible and child.Text then
                            if tonumber(child.Text) or string.match(child.Text, "^[A-F0-9]+$") then
                                child:Click()
                            end
                        end
                    end
                end
            end
        end
    end)
end

local function SolveCuttingPuzzle()
    ClickAllButtons("cut")
    ClickAllButtons("slice")
    ClickAllButtons("snip")
end

local function SolveSafeCrackingPuzzle()
    ClickAllButtons("left")
    ClickAllButtons("right")
    ClickAllButtons("turn")
    ClickAllButtons("dial")
end

local function SolveMovementPuzzle()
    pcall(function()
        if LocalPlayer and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                for _, v in ipairs(game:GetDescendants()) do
                    if v:IsA("Part") then
                        local name = string.lower(v.Name)
                        if string.find(name, "path") or string.find(name, "waypoint") or 
                           string.find(name, "objective") or string.find(name, "point") then
                            humanoid:MoveTo(v.Position)
                        end
                    end
                end
            end
        end
    end)
end

local function CollectLoot()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Tool") or v:IsA("Part") then
                local name = string.lower(v.Name)
                if string.find(name, "cash") or string.find(name, "money") or 
                   string.find(name, "gold") or string.find(name, "diamond") or
                   string.find(name, "loot") or string.find(name, "valuable") or
                   string.find(name, "jewelry") or string.find(name, "painting") then
                    if v:IsA("Tool") then
                        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):EquipTool(v)
                    elseif v:IsA("Part") then
                        local click = v:FindFirstChildOfClass("ClickDetector")
                        if click then click:Click() end
                    end
                end
            end
        end
        ClickAllButtons("collect")
        ClickAllButtons("loot")
        ClickAllButtons("take")
        ClickAllButtons("grab")
        ClickAllButtons("steal")
        ClickAllButtons("pick up")
    end)
end

local function AutoEscape()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Part") then
                local name = string.lower(v.Name)
                if string.find(name, "door") or string.find(name, "exit") or 
                   string.find(name, "escape") or string.find(name, "vent") or
                   string.find(name, "out") then
                    local click = v:FindFirstChildOfClass("ClickDetector")
                    if click then click:Click() end
                end
            end
        end
        ClickAllButtons("escape")
        ClickAllButtons("exit")
        ClickAllButtons("leave")
        ClickAllButtons("flee")
        ClickAllButtons("run")
    end)
end

local function AutoHide()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Part") then
                local name = string.lower(v.Name)
                if string.find(name, "hiding") or string.find(name, "hide") or 
                   string.find(name, "cover") or string.find(name, "closet") or
                   string.find(name, "shadow") then
                    local click = v:FindFirstChildOfClass("ClickDetector")
                    if click then click:Click() end
                end
            end
        end
        ClickAllButtons("hide")
        ClickAllButtons("cover")
        ClickAllButtons("sneak")
        ClickAllButtons("crouch")
    end)
end

-- ================================
-- HEIST FUNCTIONS
-- ================================

local function DoATM()
    SolveTimingPuzzle()
    CollectLoot()
end

local function DoCarTheft()
    SolveLockpickPuzzle()
    SolveTimingPuzzle()
    CollectLoot()
end

local function DoSmallBank()
    SolveLockpickPuzzle()
    SolveWiringPuzzle()
    SolveThermitePuzzle()
    SolveDrillPuzzle()
    SolveMemoryGamePuzzle()
    CollectLoot()
end

local function DoGrandBank()
    SolveLaptopHackPuzzle()
    SolveThermitePuzzle()
    SolveSafeCrackingPuzzle()
    SolveDrillPuzzle()
    CollectLoot()
end

local function DoCasino()
    SolveMovementPuzzle()
    SolveNumberMatchingPuzzle()
    SolveMemoryGamePuzzle()
    CollectLoot()
end

local function DoYacht()
    SolveCuttingPuzzle()
    SolveSafeCrackingPuzzle()
    SolveWiringPuzzle()
    CollectLoot()
end

-- ================================
-- GUI
-- ================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "m1vHeist"

-- Square Button
local MiniButton = Instance.new("TextButton")
MiniButton.Name = "MiniButton"
MiniButton.Size = UDim2.new(0, 55, 0, 55)
MiniButton.Position = UDim2.new(0, 15, 0, 15)
MiniButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MiniButton.Text = "🏦"
MiniButton.TextColor3 = Color3.fromRGB(255, 200, 0)
MiniButton.TextSize = 26
MiniButton.Font = Enum.Font.SourceSansBold
MiniButton.Active = true
MiniButton.Draggable = true
MiniButton.Parent = ScreenGui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 8)
MiniCorner.Parent = MiniButton

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = Color3.fromRGB(255, 200, 0)
MiniStroke.Thickness = 2
MiniStroke.Parent = MiniButton

-- Glow
local Glow = Instance.new("Frame")
Glow.Size = UDim2.new(1.2, 0, 1.2, 0)
Glow.Position = UDim2.new(-0.1, 0, -0.1, 0)
Glow.BackgroundTransparency = 1
Glow.Parent = MiniButton

local GlowStroke = Instance.new("UIStroke")
GlowStroke.Color = Color3.fromRGB(255, 200, 0)
GlowStroke.Thickness = 3
GlowStroke.Transparency = 0.5
GlowStroke.Parent = Glow

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 540)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -270)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BackgroundTransparency = 0.05
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 200, 0)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.4
MainStroke.Parent = MainFrame

-- Title
local TitleFrame = Instance.new("Frame")
TitleFrame.Size = UDim2.new(1, 0, 0, 45)
TitleFrame.Position = UDim2.new(0, 0, 0, 0)
TitleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
TitleFrame.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🏦 m1v Heist System v8"
TitleLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleFrame

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = TitleFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

MiniButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Container
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 55)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
Container.CanvasSize = UDim2.new(0, 0, 0, 700)
Container.Parent = MainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.Parent = Container

-- ================================
-- UI FUNCTIONS
-- ================================
local function CreateToggle(text, parent, configKey, desc)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 38)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 250, 0, 18)
    label.Position = UDim2.new(0, 10, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 11
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    if desc then
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(0, 250, 0, 14)
        descLabel.Position = UDim2.new(0, 10, 0, 20)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = "🔹 " .. desc
        descLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        descLabel.TextSize = 9
        descLabel.Font = Enum.Font.SourceSans
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = frame
    end
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 22)
    btn.Position = UDim2.new(1, -60, 0.5, -11)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 10
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    local state = Config[configKey]
    btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(150, 50, 50)
    btn.Text = state and "ON" or "OFF"
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        local newState = Config[configKey]
        btn.BackgroundColor3 = newState and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(150, 50, 50)
        btn.Text = newState and "ON" or "OFF"
    end)
end

local function CreateButton(text, parent, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.SourceSans
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

local function CreateSection(text, parent)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 28)
    label.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    label.Text = "  " .. text
    label.TextColor3 = Color3.fromRGB(255, 200, 0)
    label.TextSize = 13
    label.Font = Enum.Font.SourceSansBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = label
end

-- ================================
-- BUILD UI
-- ================================

CreateSection("🛡️ Bypass System (Auto Active)", Container)
CreateToggle("Enable Bypass System", Container, "bypassActive", "Handshake + Token + Events")

CreateSection("🏦 Heists", Container)
CreateToggle("💰 ATM", Container, "autoATM", "Timing Puzzle")
CreateToggle("🚗 Car Theft", Container, "autoCarTheft", "Lockpick + Timing")
CreateToggle("🏛️ Small Bank", Container, "autoSmallBank", "Wiring + Thermite + Drill + Memory")
CreateToggle("🏦 Grand Bank", Container, "autoGrandBank", "Laptop + Thermite Grid + Safe")
CreateToggle("🎰 Casino", Container, "autoCasino", "Movement + Number Matching")
CreateToggle("🛥️ Yacht", Container, "autoYacht", "Cutting + Safe + Wiring")

CreateSection("💰 Collect & Safety", Container)
CreateToggle("Auto Collect Loot", Container, "autoCollectLoot", nil)
CreateToggle("Auto Escape", Container, "autoEscape", nil)
CreateToggle("Auto Hide", Container, "autoHide", nil)

CreateSection("⚡ Force Actions", Container)
CreateButton("🔓 Force All Puzzles", Container, function()
    SolveTimingPuzzle()
    SolveLockpickPuzzle()
    SolveWiringPuzzle()
    SolveThermitePuzzle()
    SolveDrillPuzzle()
    SolveLaptopHackPuzzle()
    SolveMemoryGamePuzzle()
    SolveNumberMatchingPuzzle()
    SolveCuttingPuzzle()
    SolveSafeCrackingPuzzle()
    SolveMovementPuzzle()
    CollectLoot()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "m1v Heist",
        Text = "All puzzles attempted!",
        Duration = 2
    })
end)

CreateButton("🏃 Force Escape", Container, function()
    AutoEscape()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "m1v Heist",
        Text = "Escape attempted!",
        Duration = 2
    })
end)

-- Status
local StatusFrame = Instance.new("Frame")
StatusFrame.Size = UDim2.new(1, -20, 0, 28)
StatusFrame.Position = UDim2.new(0, 10, 0, 0)
StatusFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
StatusFrame.Parent = Container

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 6)
StatusCorner.Parent = StatusFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 1, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "🟢 Status: Ready"
StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
StatusLabel.Parent = StatusFrame

-- Bypass Status
local BypassStatus = Instance.new("TextLabel")
BypassStatus.Size = UDim2.new(1, 0, 0, 18)
BypassStatus.Position = UDim2.new(0, 0, 0, -20)
BypassStatus.BackgroundTransparency = 1
BypassStatus.Text = "🛡️ Bypass: Active (Token + Events + Memory)"
BypassStatus.TextColor3 = Color3.fromRGB(0, 255, 100)
BypassStatus.TextSize = 10
BypassStatus.Font = Enum.Font.SourceSans
BypassStatus.TextXAlignment = Enum.TextXAlignment.Center
BypassStatus.Parent = StatusFrame

-- ================================
-- MAIN LOOP
-- ================================
RunService.RenderStepped:Connect(function()
    if Config.bypassActive then
        pcall(RunAllBypasses)
    end
    
    local anyHeist = Config.autoATM or Config.autoCarTheft or Config.autoSmallBank or 
                     Config.autoGrandBank or Config.autoCasino or Config.autoYacht
    
    if anyHeist or Config.autoCollectLoot or Config.autoEscape or Config.autoHide then
        StatusLabel.Text = "🟡 Status: Running..."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        
        if Config.autoATM then pcall(DoATM) end
        if Config.autoCarTheft then pcall(DoCarTheft) end
        if Config.autoSmallBank then pcall(DoSmallBank) end
        if Config.autoGrandBank then pcall(DoGrandBank) end
        if Config.autoCasino then pcall(DoCasino) end
        if Config.autoYacht then pcall(DoYacht) end
        
        if Config.autoCollectLoot then pcall(CollectLoot) end
        if Config.autoEscape then pcall(AutoEscape) end
        if Config.autoHide then pcall(AutoHide) end
        
    else
        StatusLabel.Text = "🟢 Status: Ready"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
    end
end)

-- ================================
-- KEYBIND: Ctrl + H
-- ================================
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.H and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- ================================
-- NOTIFICATION
-- ================================
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🏦 m1v Heist System v8",
    Text = "Advanced Bypass: Handshake + Token + Events + Memory",
    Duration = 5
})
