local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local espEnabled = false
local aimbotEnabled = false
local mouseUnlocked = false
local FOV_RADIUS = 150
local whitelistedPlayers = {}

-- دالة لتوليد أسماء عشوائية تماماً لعناصر الواجهة لتخطي فلاتر فحص الأسماء
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

-- // 1. دمج وتعديل ستايل المربع الصغير (Executor Style Button ⚡) لإنشائه برمجياً
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = generateRandomName()
ToggleButton.Size = UDim2.new(0, 45, 0, 45) -- مربع صغير
ToggleButton.Position = UDim2.new(0, 20, 0, 20) -- محطوط الفوق على اليسار
ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- رمادي غامق بزاف (Dark Mode)
ToggleButton.Text = "⚡" -- رمز الطاقات أو الإكسيكيوتور
ToggleButton.TextColor3 = Color3.fromRGB(0, 255, 140) -- أخضر نيوني مضيء
ToggleButton.TextSize = 22
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Active = true
ToggleButton.Draggable = true -- إتاحة سحب الزر الصغير أيضاً لتسهيل اللعب
ToggleButton.Parent = ScreenGui

-- ترطيب الجناب ديال المربع باش يجي عصري
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = ToggleButton

-- خط محيط بالزر (Border) باش يعطيه شكل احترافي
local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(45, 45, 45)
btnStroke.Thickness = 1.5
btnStroke.Parent = ToggleButton

-- // 2. اللوحة الرئيسية الكبيرة (Main Panel)
local MainFrame = Instance.new("Frame")
MainFrame.Name = generateRandomName()
MainFrame.Size = UDim2.new(0, 380, 0, 210)
MainFrame.Position = UDim2.new(0, 30, 0, 100)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- إضافة ميزة سحب الواجهة لتسهيل التجربة
MainFrame.Visible = true -- تظهر افتراضياً
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- الخدمة (Logic): الكليكة على زر ⚡ كتقلب الحالة ديال الـ MainFrame الكبيرة
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

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
Hint.Text = "Press [A] for ESP | [E] for Aimbot"
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
    end
    
    if player.Character then setupBillboard(player.Character) end
    player.CharacterAdded:Connect(setupBillboard)
end

for _, player in ipairs(Players:GetPlayers()) do applyVisualTag(player) end
Players.PlayerAdded:Connect(applyVisualTag)

local function getClosestPlayerInZone()
    local closestPlayer = nil
local shortestDistance = FOV_RADIUSlocal mousePosition = UserInputService:GetMouseLocation()for _, player in ipairs(Players:GetPlayers()) doif player ~= LocalPlayer and not whitelistedPlayers[player.Name] and player.Character and player.Character:FindFirstChild("Head") thenlocal head = player.Character.Headlocal screenPosition, onScreen = Camera:WorldToViewportPoint(head.Position)if onScreen thenlocal distance = (Vector2.new(screenPosition.X, screenPosition.Y) - mousePosition).Magnitudeif distance < shortestDistance thenshortestDistance = distanceclosestPlayer = playerendendendendreturn closestPlayerendTagButton.MouseButton1Click:Connect(function()espEnabled = not espEnabledupdateESPStatus()end)LockButton.MouseButton1Click:Connect(function()aimbotEnabled = not aimbotEnabledupdateAimbotStatus()end)UserInputService.InputBegan:Connect(function(input, gameProcessed)if input.KeyCode == Enum.KeyCode.LeftControl thenmouseUnlocked = not mouseUnlockedif mouseUnlocked thenUserInputService.MouseBehavior = Enum.MouseBehavior.DefaultelseUserInputService.MouseBehavior = Enum.MouseBehavior.LockCenterendendif input.KeyCode == Enum.KeyCode.A and not gameProcessed thenespEnabled = not espEnabledupdateESPStatus()endif input.KeyCode == Enum.KeyCode.E and not gameProcessed thenaimbotEnabled = not aimbotEnabledupdateAimbotStatus()endend)RunService.RenderStepped:Connect(function()if mouseUnlocked thenUserInputService.MouseBehavior = Enum.MouseBehavior.Defaultendlocal mousePos = UserInputService:GetMouseLocation()AreaFrame.Position = UDim2.new(0, mousePos.X - FOV_RADIUS, 0, mousePos.Y - FOV_RADIUS)if espEnabled thenfor _, player in ipairs(Players:GetPlayers()) doif player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") thenlocal myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")local enemyRoot = player.Character:FindFirstChild("HumanoidRootPart")local humanoid = player.Character:FindFirstChildOfClass("Humanoid")local billboard = player.Character.Head:FindFirstChild("DiagnosticLabel")if billboard thenlocal textLabel = billboard:FindFirstChildOfClass("TextLabel")if textLabel thenlocal distanceStr = "--"if myRoot and enemyRoot thendistanceStr = tostring(math.floor((myRoot.Position - enemyRoot.Position).Magnitude)) .. "m"endlocal healthStr = "0/0"if humanoid thenhealthStr = tostring(math.floor(humanoid.Health)) .. "/" .. tostring(math.floor(humanoid.MaxHealth))endlocal heldItem = "None"local currentTool = player.Character:FindFirstChildOfClass("Tool")if currentTool thenheldItem = currentTool.NameendtextLabel.Text = player.Name .. "\n[HP: " .. healthStr .. "] [Dist: " .. distanceStr .. "]\n[Item: " .. heldItem .. "]"endendendendendif aimbotEnabled thenlocal targetPlayer = getClosestPlayerInZone()if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") thenlocal headPos = targetPlayer.Character.Head.Positionlocal cPos = Camera.CFrame.Positionlocal lookDir = (headPos - cPos).UnitCamera.CFrame = CFrame.new(cPos, cPos + lookDir)endendend)task.spawn(function()pcall(function()if hookmetamethod and typeof(hookmetamethod) == "function" thenlocal oldIndexoldIndex = hookmetamethod(game, "__index", function(self, key)local isServerCall = falsepcall(function()if checkcaller and typeof(checkcaller) == "function" thenisServerCall = not checkcaller()endend)if aimbotEnabled and self == Camera and key == "CFrame" and isServerCall thenreturn CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Vector3.new(0, 0, -1))endreturn oldIndex(self, key)end)endend)end)