local Players = game:Service("Players")
local RunService = game:Service("RunService")
local UserInputService = game:Service("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local aimbotEnabled = false
local ToggleKey = Enum.KeyCode.T -- اضغط على زر T لتشغيل أو إطفاء الـ Aimbot
local FOV_RADIUS = 150 -- قطر الدائرة الافتراضية حول المؤشر

-- دالة للبحث عن أقرب رأس لاعب داخل نطاق الدائرة
local function getClosestPlayerInFOV()
    local closestPlayer = nil
    local shortestDistance = FOV_RADIUS
    local mousePosition = UserInputService:GetMouseLocation()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
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

-- تفعيل الإطفاء والتشغيل بنظام الكبس الزري
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == ToggleKey then
        aimbotEnabled = not aimbotEnabled
        print("Aimbot State: " .. tostring(aimbotEnabled))
    end
end)

-- تحديث الكاميرا في كل إطار (Frame) لتثبيتها على الرأس
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local targetPlayer = getClosestPlayerInFOV()
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
            local headPos = targetPlayer.Character.Head.Position
            -- توجيه الكاميرا مباشرة إلى الرأس
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, headPos)
        end
    end
end)
