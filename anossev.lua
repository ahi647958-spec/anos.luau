-- 1. بناء الواجهة الرئيسية (Main Frame)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 200)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Visible = false -- كتكون مخبية ف الأول
MainFrame.Parent = ScreenGui

-- 2. زيادة زر التحكم (Toggle Button) وسط نفس الكود
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.Text = "⚡"
ToggleButton.TextColor3 = Color3.fromRGB(0, 255, 150)
ToggleButton.TextSize = 20
ToggleButton.Parent = ScreenGui

-- إضافة حواف دائرية للزر
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleButton

-- 3. دمج الوظيفة (الربط ديريكت حيت الزر والواجهة ف نفس السكريبت)
ToggleButton.MouseButton1Click:Connect(function()
    -- الكود هنا كيقدر يشوف 'MainFrame' ديريكت حيت معرف الفوق
    MainFrame.Visible = not MainFrame.Visible
end)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local espEnabled = false
local aimbotEnabled = false
local FOV_RADIUS = 150
local whitelistedPlayers = {}

-- توليد اسم عشوائي تماماً للواجهة لتخطي فلاتر فحص الأسماء
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

-- محاولة الحقن داخل CoreGui أو PlayerGui
local secureParent = nil
pcall(function() secureParent = game:GetService("CoreGui") end)
if not secureParent then secureParent = LocalPlayer:WaitForChild("PlayerGui") end
ScreenGui.Parent = secureParent

local MainFrame = Instance.new("Frame")
MainFrame.Name = generateRandomName()
MainFrame.Size = UDim2.new(0, 380, 0, 210)
MainFrame.Position = UDim2.new(0, 30, 0, 100)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- إضافة ميزة سحب الواجهة لتسهيل التجربة
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 190, 0, 30)
Title.Text = "Diagnostic System v10 (Test)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
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

local TagButton = Instance.new("TextButton")
TagButton.Size = UDim2.new(0, 160, 0, 35)
TagButton.Position = UDim2.new(0, 15, 0, 60)
TagButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
TagButton.Text = "ESP: OFF"
TagButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TagButton.TextSize = 14
TagButton.Font = Enum.Font.SourceSansBold
TagButton.Parent = MainFrame

local TagCorner = Instance.new("UICorner")
TagCorner.CornerRadius = UDim.new(0, 6)
TagCorner.Parent = TagButton

local LockButton = Instance.new("TextButton")
LockButton.Size = UDim2.new(0, 160, 0, 35)
LockButton.Position = UDim2.new(0, 15, 0, 110)
LockButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
LockButton.Text = "Aimbot: OFF"
LockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LockButton.TextSize = 14
LockButton.Font = Enum.Font.SourceSansBold
LockButton.Parent = MainFrame

local LockCorner = Instance.new("UICorner")
LockCorner.CornerRadius = UDim.new(0, 6)
LockCorner.Parent = LockButton

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
PlayerListFrame.Size = UDim2.new(0, 170, 0, 155)
PlayerListFrame.Position = UDim2.new(0, 195, 0, 35)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerListFrame.ScrollBarThickness = 4
PlayerListFrame.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 4)
ListLayout.Parent = PlayerListFrame

local AreaFrame = Instance.new("Frame")
AreaFrame.Size = UDim2.new(0, FOV_RADIUS * 2, 0, FOV_RADIUS * 2)
AreaFrame.BackgroundTransparency = 1
AreaFrame.Visible = false
AreaFrame.Parent = ScreenGui

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 1
UIStroke.Color = Color3.fromRGB(255, 0, 0)
UIStroke.Parent = AreaFrame

local UICornerArea = Instance.new("UICorner")
UICornerArea.CornerRadius = UDim.new(1, 0)
UICornerArea.Parent = AreaFrame

-- تحديث موقع دائرة الـ FOV لتتبع الماوس بدقة
RunService.RenderStepped:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()
    AreaFrame.Position = UDim2.new(0, mousePos.X - FOV_RADIUS, 0, mousePos.Y - FOV_RADIUS)
end)

local function updateESPStatus()
    TagButton.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    TagButton.BackgroundColor3 = espEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("Head") then
            local billboard = player.Character.Head:FindFirstChild("DiagnosticLabel")
            if billboard then billboard.Enabled = espEnabled end
        end
    end
end

local function updateAimbotStatus()
    LockButton.Text = aimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
    LockButton.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50)
    AreaFrame.Visible = aimbotEnabled
end

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
            PButton.Parent = PlayerListFrame
        end
    end
    PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, count * 29)
end

Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)
refreshPlayerList()

-- وظيفة تحديث الـ ESP الحقيقي وجلب البيانات من السيرفر
local function applyVisualTag(player)
    if player == LocalPlayer then return end
    
    local function setupBillboard(character)
        local head = character:WaitForChild("Head", 10)
        if not head then return end
        
        local oldTag = head:FindFirstChild("DiagnosticLabel")
        if oldTag then oldTag:Destroy() end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "DiagnosticLabel"
        billboard.Size = UDim2.new(0, 250, 0, 70)
        billboard.AlwaysOnTop = true
        billboard.MaxDistance = math.huge
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.Enabled = espEnabled
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = player.Name .. "\n[HP: --] [Dist: --]\n[Item: None]"
        label.TextColor3 = Color3.fromRGB(0, 255, 0)
        label.TextSize = 12
        label.Font = Enum.Font.SourceSansBold
        label.TextWrapped = true
        label.Parent = billboard
        billboard.Parent = head

        -- حلقة تكرار لتحديث البيانات ديناميكياً
        task.spawn(function()
            while character.Parent and billboard.Parent do
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local hp = humanoid and math.floor(humanoid.Health) or 0
                local maxHp = humanoid and math.floor(humanoid.MaxHealth) or 100
                
                local localChar = LocalPlayer.Character
                local dist = "N/A"
                if localChar and localChar:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("HumanoidRootPart") then
                    dist = math.floor((localChar.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude) .. "m"
                end
                
                local currentItem = "None"
                local tool = character:FindFirstChildOfClass("Tool")
                if tool then currentItem = tool.Name end
                
                label.Text = string.format("%s\n[HP: %d/%d] [Dist: %s]\n[Item: %s]", player.Name, hp, maxHp, dist, currentItem)
                task.wait(0.2)
            end
        end)
    end
    
    if player.Character then setupBillboard(player.Character) end
    player.CharacterAdded:Connect(setupBillboard)
end

for _, player in ipairs(Players:GetPlayers()) do applyVisualTag(player) end
Players.PlayerAdded:Connect(applyVisualTag)

local function getClosestPlayerInZone()
    local closestPlayer = nil
    local shortestDistance = FOV_RADIUS
    local mousePosition = UserInputService:GetMouseLocation()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not whitelistedPlayers[player.Name] and player.Character and player.Character:FindFirstChild("Head") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then -- التأكد أن اللاعب ليس ميتاً
                local head = player.Character.Head
                local screenPosition, onScreen = Camera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - mousePosition).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- تشغيل الأيم بوت عند الضغط المطول على الزر الأيمن للماوس
RunService.RenderStepped:Connect(function()
    if aimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestPlayerInZone()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

TagButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    updateESPStatus()
end)

LockButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    updateAimbotStatus()
end)
