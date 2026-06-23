-- [[ m1v Comprehensive Test Suite - Stealth Fallback ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- إعدادات التشغيل التلقائي
local espEnabled = true
local aimbotEnabled = true
local FOV_RADIUS = 150
local whitelistedPlayers = {}

-- دالة الإشعارات الجانبية باسم النظام الجديد
local function notify(title, text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = 4;
        })
    end)
end

-- توليد اسم عشوائي لتخطي فلاتر فحص الأسماء المحلية
local function generateRandomName()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local length = math.random(10, 20)
    local randomString = ""
    for i = 1, length do
        local rand = math.random(1, #chars)
        randomString = randomString .. string.sub(chars, rand, rand)
    end
    return randomString
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = generateRandomName()
ScreenGui.ResetOnSpawn = false

-- محاولة الحقن داخل CoreGui أو PlayerGui لتأمين الواجهة محلياً
local secureParent = nil
pcall(function() secureParent = game:GetService("CoreGui") end)
if not secureParent then secureParent = LocalPlayer:WaitForChild("PlayerGui") end
ScreenGui.Parent = secureParent

-- 1. بناء الواجهة الرئيسية
local MainFrame = Instance.new("Frame")
MainFrame.Name = generateRandomName()
MainFrame.Size = UDim2.new(0, 380, 0, 250)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false -- تبدأ مخفية
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- 2. زر التحكم الخارجي في الإخفاء والإظهار (⚡)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = generateRandomName()
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.Text = "m1v"
ToggleButton.TextColor3 = Color3.fromRGB(0, 255, 150)
ToggleButton.TextSize = 20
ToggleButton.Parent = ScreenGui

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- 3. محتويات الواجهة وعناصر التصميم الداخلي باسم m1v
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 190, 0, 30)
Title.Text = "m1v" -- تعديل الاسم هنا بالواجهة
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local Hint = Instance.new("TextLabel")
Hint.Size = UDim2.new(0, 190, 0, 20)
Hint.Position = UDim2.new(0, 0, 0, 25)
Hint.Text = "Hold [Right Click] to Lock Target"
Hint.TextColor3 = Color3.fromRGB(160, 160, 160)
Hint.TextSize = 11
Hint.Font = Enum.Font.SourceSansItalic
Hint.BackgroundTransparency = 1
Hint.Parent = MainFrame

-- زر الـ ESP
local TagButton = Instance.new("TextButton")
TagButton.Size = UDim2.new(0, 160, 0, 35)
TagButton.Position = UDim2.new(0, 15, 0, 60)
TagButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
TagButton.Text = "ESP: ON"
TagButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TagButton.TextSize = 14
TagButton.Font = Enum.Font.SourceSansBold
TagButton.Parent = MainFrame

local TagCorner = Instance.new("UICorner")
TagCorner.CornerRadius = UDim.new(0, 6)
TagCorner.Parent = TagButton

-- زر الـ Aimbot
local LockButton = Instance.new("TextButton")
LockButton.Size = UDim2.new(0, 160, 0, 35)
LockButton.Position = UDim2.new(0, 15, 0, 110)
LockButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
LockButton.Text = "Aimbot: ON"
LockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LockButton.TextSize = 14
LockButton.Font = Enum.Font.SourceSansBold
LockButton.Parent = MainFrame

local LockCorner = Instance.new("UICorner")
LockCorner.CornerRadius = UDim.new(0, 6)
LockCorner.Parent = LockButton

-- زر تخطي السجن (Bypass Jail)
local JailButton = Instance.new("TextButton")
JailButton.Size = UDim2.new(0, 160, 0, 35)
JailButton.Position = UDim2.new(0, 15, 0, 160)
JailButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
JailButton.Text = "Bypass Jail"
JailButton.TextColor3 = Color3.fromRGB(255, 255, 255)
JailButton.TextSize = 14
JailButton.Font = Enum.Font.SourceSansBold
JailButton.Parent = MainFrame

local JailCorner = Instance.new("UICorner")
JailCorner.CornerRadius = UDim.new(0, 6)
JailCorner.Parent = JailButton

-- قائمة اللاعبين والـ Whitelist الجانبية
local ListTitle = Instance.new("TextLabel")
ListTitle.Size = UDim2.new(0, 170, 0, 30)
ListTitle.Position = UDim2.new(0, 195, 0, 5)
ListTitle.Text = "Select Whitelist (No Aim):"
ListTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
ListTitle.TextSize = 12
ListTitle.Font = Enum.Font.SourceSansBold
ListTitle.BackgroundTransparency = 1
ListTitle.Parent = MainFrame

local PlayerListFrame = Instance.new("ScrollingFrame")
PlayerListFrame.Size = UDim2.new(0, 170, 0, 195)
PlayerListFrame.Position = UDim2.new(0, 195, 0, 35)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerListFrame.ScrollBarThickness = 4
PlayerListFrame.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 4)
ListLayout.Parent = PlayerListFrame

-- دائرة الـ FOV المرئية للـ Aimbot
local AreaFrame = Instance.new("Frame")
AreaFrame.Size = UDim2.new(0, FOV_RADIUS * 2, 0, FOV_RADIUS * 2)
AreaFrame.BackgroundTransparency = 1
AreaFrame.Visible = true
AreaFrame.Parent = ScreenGui

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 1
UIStroke.Color = Color3.fromRGB(255, 0, 0)
UIStroke.Parent = AreaFrame

local UICornerArea = Instance.new("UICorner")
UICornerArea.CornerRadius = UDim.new(1, 0)
UICornerArea.Parent = AreaFrame

-- تشغيل منطق الأزرار (ESP & Aimbot Toggle)
TagButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    TagButton.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    TagButton.BackgroundColor3 = espEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50)
end)

LockButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    LockButton.Text = aimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
    LockButton.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50)
    AreaFrame.Visible = aimbotEnabled
end)

-- ربط منطق تخطي السجن السري (Stealth Bypass)
JailButton.MouseButton1Click:Connect(function()
    notify("m1v System", "Analyzing Jail System...")
    task.wait(0.5)
    
    local policeEvents = ReplicatedStorage:FindFirstChild("PoliceEvents")
    if policeEvents then
        local releaseEvent = policeEvents:FindFirstChild("RequestRelease")
        if releaseEvent then
            releaseEvent:FireServer(LocalPlayer)
            notify("m1v Success", "Unjail request sent to Server!")
        else
            -- انتقال صامت بدون كشف الطريقة
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = CFrame.new(150, 10, -250) 
                notify("m1v Success", "Unjail system executed successfully.")
            else
                notify("m1v Error", "Execution failed. Character not ready.")
            end
        end
    else
        -- انتقال صامت في حالة عدم وجود المجلد
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(150, 10, -250) 
            notify("m1v Success", "Unjail system executed successfully.")
        else
            notify("m1v Error", "Execution failed. Character not ready.")
        end
    end
end)

-- تحديث وتعبئة قائمة اللاعبين
local function refreshPlayerList()
    for _, child in ipairs(PlayerListFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local count = 0
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            count = count + 1
            local PButton = Instance.new("TextButton")
            PButton.Size = UDim2.new(1, -6, 0, 25)
            PButton.Font = Enum.Font.SourceSansBold
            PButton.TextSize = 12
            PButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            
            if whitelistedPlayers[player.Name] then
                PButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
                PButton.Text = player.Name .. " [SAFE]"
            else
                PButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                PButton.Text = player.Name
            end
            
            local PCorner = Instance.new("UICorner")
            PCorner.CornerRadius = UDim.new(0, 4)
            PCorner.Parent = PButton
            
            PButton.MouseButton1Click:Connect(function()
                if whitelistedPlayers[player.Name] then
                    whitelistedPlayers[player.Name] = nil
                    PButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    PButton.Text = player.Name
                else
                    whitelistedPlayers[player.Name] = true
                    PButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
                    PButton.Text = player.Name .. " [SAFE]"
                end
            end)
