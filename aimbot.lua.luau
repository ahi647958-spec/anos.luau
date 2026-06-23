local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local espEnabled = false
local aimbotEnabled = false
local mouseUnlocked = false
local FOV_RADIUS = 150

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SecureDiagnosticPanel_v6"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

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

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Anticheat Tester v6"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.SourceSansBold
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local Hint = Instance.new("TextLabel")
Hint.Size = UDim2.new(1, 0, 0, 20)
Hint.Position = UDim2.new(0, 0, 0, 25)
Hint.Text = "Press [Left Ctrl] to use Mouse"
Hint.TextColor3 = Color3.fromRGB(160, 160, 160)
Hint.TextSize = 11
Hint.Font = Enum.Font.SourceSansItalic
Hint.BackgroundTransparency = 1
Hint.Parent = MainFrame

local TagButton = Instance.new("TextButton")
TagButton.Size = UDim2.new(0, 160, 0, 35)
TagButton.Position = UDim2.new(0, 15, 0, 55)
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
LockButton.Position = UDim2.new(0, 15, 0, 105)
LockButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
LockButton.Text = "Aimbot: OFF"
LockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LockButton.TextSize = 14
LockButton.Font = Enum.Font.SourceSansBold
LockButton.Parent = MainFrame

local LockCorner = Instance.new("UICorner")
LockCorner.CornerRadius = UDim.new(0, 6)
LockCorner.Parent = LockButton

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

local function applyVisualTag(player)
    if player == LocalPlayer then return end
    
    local function setupBillboard(character)
        local head = character:WaitForChild("Head", 10)
        if not head then return end
        
        local oldTag = head:FindFirstChild("DiagnosticLabel")
        if oldTag then oldTag:Destroy() end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "DiagnosticLabel"
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

for _, player in ipairs(Players:GetPlayers()) do applyVisualTag(player) end
Players.PlayerAdded:Connect(applyVisualTag)

local function isAlly(player)
    if player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
        return true
    end
    local isFriend = false
    pcall(function()
        isFriend = LocalPlayer:IsFriendsWith(player.UserId)
    end)
    return isFriend
end

local function getClosestPlayerInZone()
    local closestPlayer = nil
    local shortestDistance = FOV_RADIUS
    local mousePosition = UserInputService:GetMouseLocation()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not isAlly(player) and player.Character and player.Character:FindFirstChild("Head") then
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

TagButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        TagButton.Text = "ESP: ON"
        TagButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
    else
        TagButton.Text = "ESP: OFF"
        TagButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("Head") then
            local billboard = player.Character.Head:FindFirstChild("DiagnosticLabel")
            if billboard then billboard.Enabled = espEnabled end
        end
    end
end)

LockButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        LockButton.Text = "Aimbot: ON"
        LockButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        AreaFrame.Visible = true
    else
        LockButton.Text = "Aimbot: OFF"
        LockButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        AreaFrame.Visible = false
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.LeftControl then
        mouseUnlocked = not mouseUnlocked
        if mouseUnlocked then
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        else
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        end
    end
    
    if input.KeyCode == Enum.KeyCode.A then
        espEnabled = not espEnabled
        if espEnabled then
            TagButton.Text = "ESP: ON"
            TagButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        else
            TagButton.Text = "ESP: OFF"
            TagButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        end
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Head") then
                local billboard = player.Character.Head:FindFirstChild("DiagnosticLabel")
                if billboard then billboard.Enabled = espEnabled end
            end
        end
    end
    
    if input.KeyCode == Enum.KeyCode.E then
        aimbotEnabled = not aimbotEnabled
        if aimbotEnabled then
            LockButton.Text = "Aimbot: ON"
            LockButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
            AreaFrame.Visible = true
        else
            LockButton.Text = "Aimbot: OFF"
            LockButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
            AreaFrame.Visible = false
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if mouseUnlocked then
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end

    if AreaFrame.Visible then
        local mousePos = UserInputService:GetMouseLocation()
        AreaFrame.Position = UDim2.new(0, mousePos.X - FOV_RADIUS, 0, mousePos.Y - FOV_RADIUS)
    end
    
    if aimbotEnabled then
        local targetPlayer = getClosestPlayerInZone()
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
            local headPos = targetPlayer.Character.Head.Position
            local cPos = Camera.CFrame.Position
            local lookDir = (headPos - cPos).Unit
            Camera.CFrame = CFrame.new(cPos, cPos + lookDir)
        end
    end
end)
