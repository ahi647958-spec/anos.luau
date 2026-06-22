-- // إعدادات الاختبار والاختصارات
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- // أزرار التحكم بالتشغيل والإطفاء (Toggle Keys)
local ESP_TOGGLE_KEY = Enum.KeyCode.E      -- اضغط E لتشغيل/إطفاء الرؤية
local AIM_TOGGLE_KEY = Enum.KeyCode.T      -- اضغط T لتشغيل/إطفاء التصويب

-- // حالات التشغيل الافتراضية
local espEnabled = false
local aimbotEnabled = false
local FOV_RADIUS = 150 -- قطر دائرة الـ Aimbot

-- // رسم دائرة الـ FOV على الشاشة باستخدام مكتبة المحاقن (Drawing Library)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Radius = FOV_RADIUS
FOVCircle.Filled = false
FOVCircle.Visible = false

-- // 1. نظام الـ ESP المدمج للمحاقن
local function applyESP(player)
    if player == LocalPlayer then return end
    
    local function setupBillboard(character)
        local head = character:WaitForChild("Head", 10)
        if not head then return end
        
        -- إزالة أي ESP قديم لتفادي التكرار عند إعادة الرسبون
        if head:FindFirstChild("TestESP") then
            head.TestESP:Destroy()
        end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "TestESP"
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.AlwaysOnTop = true -- اختراق الجدران لاختبار الحماية
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.Enabled = espEnabled
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = player.Name
        label.TextColor3 = Color3.fromRGB(0, 255, 0) -- لون أخضر للـ ESP
        label.TextSize = 14
        label.Font = Enum.Font.SourceSansBold
        label.Parent = billboard
        
        billboard.Parent = head
    end
    
    if player.Character then
        setupBillboard(player.Character)
    end
    player.CharacterAdded:Connect(setupBillboard)
end

-- تفعيل الـ ESP لجميع اللاعبين في السيرفر
for _, player in ipairs(Players:GetPlayers()) do
    applyESP(player)
end
Players.PlayerAdded:Connect(applyESP)

-- // 2. نظام الـ Aimbot الدائري (FOV Head Lock)
local function getClosestPlayerInFOV()
    local closestPlayer = nil
    local shortestDistance = FOV_RADIUS
    local mousePosition = UserInputService:GetMouseLocation()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local screenPosition, onScreen = Camera:WorldToViewportPoint(head.Position)
            
            if onScreen then
                -- حساب المسافة بين رأس اللاعب ومؤشر الماوس
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

-- // 3. نظام التبديل (Toggle) وإدارة الأزرار عبر الـ Executor
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- تشغيل/إطفاء الـ ESP
    if input.KeyCode == ESP_TOGGLE_KEY then
        espEnabled = not espEnabled
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Head") then
                local billboard = player.Character.Head:FindFirstChild("TestESP")
                if billboard then billboard.Enabled = espEnabled end
            end
        end
    end
    
    -- تشغيل/إطفاء الـ Aimbot ودائرته
    if input.KeyCode == AIM_TOGGLE_KEY then
        aimbotEnabled = not aimbotEnabled
        FOVCircle.Visible = aimbotEnabled
    end
end)

-- // 4. حلقة التحديث المستمر (Render Loop) لتثبيت التصويب وتحديث الدائرة
RunService.RenderStepped:Connect(function()
    -- تحديث موقع الدائرة الحية مع حركة الماوس
    if FOVCircle.Visible then
        FOVCircle.Position = UserInputService:GetMouseLocation()
    end
    
    -- تنفيذ قفل الكاميرا على الرأس (Head Lock)
    if aimbotEnabled then
        local targetPlayer = getClosestPlayerInFOV()
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
            local headPos = targetPlayer.Character.Head.Position
            -- تعديل مباشر للـ CFrame الخاص بكاميرا اللاعب
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, headPos)
        end
    end
end)
