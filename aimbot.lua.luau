-- // إعدادات الاختبار والاختصارات للمحاقن (نسخة تدعم الـ Friendly Whitelist)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- // الحالات الافتراضية
local espEnabled = false
local aimbotEnabled = false
local mouseUnlocked = false
local FOV_RADIUS = 150

-- // 1. إنشاء واجهة المستخدم (GUI) المستقرة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnticheatTestMenu_Friendly"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- اللوحة الرئيسية الصغيرة (Main Panel)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 190, 0, 160)
MainFrame.Position = UDim2.new(0, 30, 0, 100)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- عنوان اللوحة
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Anticheat Tester v5"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.SourceSansBold
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- نص إرشادي
local Hint = Instance.new("TextLabel")
Hint.Size = UDim2.new(1, 0, 0, 20)
Hint.Position = UDim2.new(0, 0, 0, 25)
Hint.Text = "Press [Left Ctrl] to use Mouse"
Hint.TextColor3 = Color3.fromRGB(160, 160, 160)
Hint.TextSize = 11
Hint.Font = Enum.Font.SourceSansItalic
Hint.BackgroundTransparency = 1
Hint.Parent = MainFrame

-- زر تفعيل وإطفاء الـ ESP
local ESPButton = Instance.new("TextButton")
ESPButton.Size = UDim2.new(0, 160, 0, 35)
ESPButton.Position = UDim2.new(0, 15, 0, 55)
ESPButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
ESPButton.Text = "ESP: OFF"
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.TextSize = 14
ESPButton.Font = Enum.Font.SourceSansBold
ESPButton.Parent = MainFrame

local ESPCorner = Instance.new("UICorner")
ESPCorner.CornerRadius = UDim.new(0, 6)
ESPCorner.Parent = ESPButton

-- زر تفعيل وإطفاء الـ Aimbot
local AimButton = Instance.new("TextButton")
AimButton.Size = UDim2.new(0, 160, 0, 35)
AimButton.Position = UDim2.new(0, 15, 0, 105)
AimButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
AimButton.Text = "Aimbot: OFF"
AimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimButton.TextSize = 14
AimButton.Font = Enum.Font.SourceSansBold
AimButton.Parent = MainFrame

local AimCorner = Instance.new("UICorner")
AimCorner.CornerRadius = UDim.new(0, 6)
AimCorner.Parent = AimButton

-- دائرة الـ FOV للحماية والتصويب
local CircleFrame = Instance.new("Frame")
CircleFrame.Size = UDim2.new(0, FOV_RADIUS * 2, 0, FOV_RADIUS * 2)
CircleFrame.BackgroundTransparency = 1
CircleFrame.Visible = false
CircleFrame.Parent = ScreenGui

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 1
UIStroke.Color = Color3.fromRGB(255, 0, 0)
UIStroke.Parent = CircleFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = CircleFrame

-- // 2. نظام الـ ESP المستقر
local function applyESP(player)
    if player == LocalPlayer then return end
    
    local function setupBillboard(character)
        local head = character:WaitForChild("Head", 10)
        if not head then return end
        
        local oldESP = head:FindFirstChild("TestESP")
        if oldESP then oldESP:Destroy() end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "TestESP"
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.Enabled = espEnabled
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = player.Name
        label.TextColor3 = Color3.fromRGB(0, 255, 0)
        label.TextSize = 13
        label.Font = Enum.Font.SourceSansBold
        label.Parent = billboard
        
        billboard.Parent = head
    end
    
    if player.Character then setupBillboard(player.Character) end
    player.CharacterAdded:Connect(setupBillboard)
end

for _, player in ipairs(Players:GetPlayers()) do applyESP(player) end
Players.PlayerAdded:Connect(applyESP)

-- // 3. دالة التحقق من الحلفاء والفرق (Friendly Whitelist Check)
local function isFriendly(player)
    -- التجاوز إذا كان اللاعب في نفس الفريق
    if player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
        return true
    end
    
    -- التجاوز إذا كان اللاعب صديقاً مسجلاً في حسابك على روبلوكس
    local isFriend = false
    pcall(function()
        isFriend = LocalPlayer:IsFriendsWith(player.UserId)
    end)
    if isFriend then
        return true
    end
    
    return false
end

-- // 4. نظام الـ Aimbot الدائري الذكي مع فحص الحلفاء
local function getClosestPlayerInFOV()
    local closestPlayer = nil
    local shortestDistance = FOV_RADIUS
    local mousePosition = UserInputService:GetMouseLocation()

    for _, player in ipairs(Players:GetPlayers()) do
        -- شرط إضافي: التأكد من أنه ليس حليفاً (not isFriendly) قبل استهدافه
        if player ~= LocalPlayer and not isFriendly(player) and player.Character and player.Character:FindFirstChild("Head") then
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
    return closestPlayer
end

-- // 5. برمجة أزرار الواجهة بالماوس (Tap Toggle)
ESPButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        ESPButton.Text = "ESP: ON"
        ESPButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
    else
        ESPButton.Text = "ESP: OFF"
        ESPButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("Head") then
            local billboard = player.Character.Head:FindFirstChild("TestESP")
            if billboard then billboard.Enabled = espEnabled end
        end
    end
end)

AimButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        AimButton.Text = "Aimbot: ON"
        AimButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        CircleFrame.Visible = true
    else
        AimButton.Text = "Aimbot: OFF"
        AimButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        CircleFrame.Visible = false
    end
end)

-- // 6. تحرير الفأرة وإظهار السهم
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.LeftControl then
        mouseUnlocked = not mouseUnlocked
        if mouseUnlocked then
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        else
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        end
    end
end)

-- // 7. حلقة التحديث المستمر
RunService.RenderStepped:Connect(function()
    if mouseUnlocked then
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end

    if CircleFrame.Visible then
        local mousePos = UserInputService:GetMouseLocation()
        CircleFrame.Position = UDim2.new(0, mousePos.X - FOV_RADIUS, 0, mousePos.Y - FOV_RADIUS)
    end
    
    if aimbotEnabled then
        local targetPlayer = getClosestPlayerInFOV()
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
            local headPos = targetPlayer.Character.Head.Position
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, headPos)
        end
    end
end)
