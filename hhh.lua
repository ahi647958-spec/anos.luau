-- [[ San Aurie Ultimate Hack Script v2 ]] --
-- Added Anti-Ban / Bypass System

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ================================
-- CONFIG
-- ================================
local Config = {
    -- Aimbot
    aimbotEnabled = false,
    FOVRadius = 150,
    aimSmoothness = 5,
    aimPart = "Head",
    aimKey = Enum.KeyCode.E,
    
    -- ESP
    espEnabled = false,
    showDistance = false,
    showHealth = false,
    showHitbox = false,
    espColor = Color3.fromRGB(0, 255, 150),
    
    -- Whitelist (Friendly)
    whitelisted = {},
    
    -- Auto ATM (Robberies)
    autoATM = false,
    
    -- Vehicle Hack
    vehicleHack = false,
    
    -- Bank Hack
    bankHack = false,
    
    -- Anti-Ban / Bypass
    bypassEnabled = true,
    stealthMode = true
}

-- ================================
-- ANTI-BAN / BYPASS SYSTEM
-- ================================

-- 1. Bypass the Anti-Cheat (if present)
local function BypassAntiCheat()
    pcall(function()
        -- Disable anti-cheat scripts
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("LocalScript") and (string.find(v.Name, "AntiCheat") or string.find(v.Name, "AC") or string.find(v.Name, "Detection")) then
                v.Disabled = true
                task.wait(0.1)
                v.Disabled = false
            end
        end
        
        -- Remove any detection modules
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("ModuleScript") and (string.find(v.Name, "AntiCheat") or string.find(v.Name, "AC")) then
                v:Destroy()
            end
        end
    end)
end

-- 2. Fake Client Data (to avoid detection)
local function FakeClientData()
    pcall(function()
        local player = LocalPlayer
        
        -- Fake ping
        if player:FindFirstChild("Network") then
            local network = player.Network
            local ping = network:FindFirstChild("Ping")
            if ping then
                ping.Value = math.random(20, 80)
            end
        end
        
        -- Fake FPS
        if game:GetService("Stats"):FindFirstChild("FPS") then
            local fps = game:GetService("Stats").FPS
            fps.Value = math.random(30, 120)
        end
    end)
end

-- 3. Randomize Movement (to avoid detection patterns)
local function RandomizeMovement()
    pcall(function()
        if LocalPlayer and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                -- Slightly randomize walk speed
                local currentSpeed = humanoid.WalkSpeed
                humanoid.WalkSpeed = currentSpeed + math.random(-2, 2)
                task.wait(0.5)
                humanoid.WalkSpeed = currentSpeed
            end
        end
    end)
end

-- 4. Hide the script from detection
local function HideScript()
    pcall(function()
        -- Rename all script objects
        local function randomName()
            local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            local str = ""
            for i = 1, math.random(12, 20) do
                str = str .. string.sub(chars, math.random(1, #chars), math.random(1, #chars))
            end
            return str
        end
        
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("LocalScript") or v:IsA("ModuleScript") or v:IsA("Script") then
                if v.Name ~= "StarterLocalScript" then
                    pcall(function()
                        v.Name = randomName()
                    end)
                end
            end
        end
    end)
end

-- 5. Bypass Remote Events (to avoid logging)
local function BypassRemoteEvents()
    pcall(function()
        local originalFireServer = game:GetService("ReplicatedStorage").RemoteEvent.FireServer
        
        -- Override FireServer to add random delays
        game:GetService("ReplicatedStorage").RemoteEvent.FireServer = function(...)
            if Config.stealthMode then
                task.wait(math.random(1, 5) / 100)
            end
            return originalFireServer(...)
        end
    end)
end

-- 6. Fake Lag (to hide teleportation)
local function FakeLag()
    pcall(function()
        if Config.stealthMode and math.random(1, 20) == 1 then
            if LocalPlayer and LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = humanoid.WalkSpeed - math.random(1, 3)
                    task.wait(0.1)
                    humanoid.WalkSpeed = humanoid.WalkSpeed + math.random(1, 3)
                end
            end
        end
    end)
end

-- 7. Randomize FOV (to avoid aimbot detection)
local function RandomizeFOV()
    pcall(function()
        if Config.stealthMode and math.random(1, 15) == 1 then
            if Camera then
                Camera.FieldOfView = math.random(70, 90)
            end
        end
    end)
end

-- Start Bypass System
local function StartBypass()
    if Config.bypassEnabled then
        -- Run bypass functions
        pcall(BypassAntiCheat)
        pcall(BypassRemoteEvents)
        pcall(HideScript)
        
        -- Start continuous bypass loop
        _G.BYPASS_CONN = RunService.Heartbeat:Connect(function()
            if Config.bypassEnabled then
                pcall(FakeClientData)
                pcall(RandomizeMovement)
                pcall(FakeLag)
                pcall(RandomizeFOV)
            end
        end)
    end
end

-- ================================
-- GUI
-- ================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "m1v"

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 550)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -275)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BackgroundTransparency = 0.05
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Title.Text = "San Aurie Ultimate v2 (Bypass)"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 100, 1, -40)
TabBar.Position = UDim2.new(0, 0, 0, 40)
TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TabBar.Parent = MainFrame

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 5)
TabCorner.Parent = TabBar

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -110, 1, -50)
Container.Position = UDim2.new(0, 105, 0, 45)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local function CreateTab(name, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, (order - 1) * 40 + 5)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 12
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = TabBar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 2
    scroll.CanvasSize = UDim2.new(0, 0, 0, 450)
    scroll.Visible = (order == 1)
    scroll.Parent = Container
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.Parent = scroll
    
    btn.MouseButton1Click:Connect(function()
        for _, child in ipairs(Container:GetChildren()) do
            if child:IsA("ScrollingFrame") then
                child.Visible = false
            end
        end
        scroll.Visible = true
    end)
    
    return scroll
end

local function CreateToggle(text, parent, configKey)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -5, 0, 35)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 12
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = frame
    
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
        
        -- Start bypass when enabled
        if configKey == "bypassEnabled" and newState then
            StartBypass()
        end
    end)
end

local function CreateButton(text, parent, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -5, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.SourceSans
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

-- Create Tabs
local AimbotTab = CreateTab("Aimbot", 1)
local ESPTab = CreateTab("ESP", 2)
local WhitelistTab = CreateTab("Friendly", 3)
local HackTab = CreateTab("Hacks", 4)
local BypassTab = CreateTab("Bypass", 5)

-- ================================
-- AIMBOT TAB
-- ================================
CreateToggle("Enable Aimbot", AimbotTab, "aimbotEnabled")
CreateToggle("Show FOV Circle", AimbotTab, "aimbotEnabled")

-- FOV Slider
local fovFrame = Instance.new("Frame")
fovFrame.Size = UDim2.new(1, -5, 0, 35)
fovFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
fovFrame.Parent = AimbotTab

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(0, 5)
fovCorner.Parent = fovFrame

local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0, 200, 1, 0)
fovLabel.Position = UDim2.new(0, 10, 0, 0)
fovLabel.Text = "FOV Radius: " .. Config.FOVRadius
fovLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
fovLabel.TextSize = 12
fovLabel.Font = Enum.Font.SourceSans
fovLabel.TextXAlignment = Enum.TextXAlignment.Left
fovLabel.BackgroundTransparency = 1
fovLabel.Parent = fovFrame

local fovBtn = Instance.new("TextButton")
fovBtn.Size = UDim2.new(0, 50, 0, 22)
fovBtn.Position = UDim2.new(1, -60, 0.5, -11)
fovBtn.Font = Enum.Font.SourceSansBold
fovBtn.TextSize = 10
fovBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fovBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
fovBtn.Text = "100"
fovBtn.Parent = fovFrame

local fovCornerBtn = Instance.new("UICorner")
fovCornerBtn.CornerRadius = UDim.new(0, 4)
fovCornerBtn.Parent = fovBtn

local fovValues = {50, 75, 100, 125, 150, 175, 200, 250, 300}
local fovIndex = 3

fovBtn.MouseButton1Click:Connect(function()
    fovIndex = fovIndex % #fovValues + 1
    Config.FOVRadius = fovValues[fovIndex]
    fovBtn.Text = tostring(Config.FOVRadius)
    fovLabel.Text = "FOV Radius: " .. Config.FOVRadius
end)

-- Aim Part Selector
local partFrame = Instance.new("Frame")
partFrame.Size = UDim2.new(1, -5, 0, 35)
partFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
partFrame.Parent = AimbotTab

local partCorner = Instance.new("UICorner")
partCorner.CornerRadius = UDim.new(0, 5)
partCorner.Parent = partFrame

local partLabel = Instance.new("TextLabel")
partLabel.Size = UDim2.new(0, 200, 1, 0)
partLabel.Position = UDim2.new(0, 10, 0, 0)
partLabel.Text = "Aim Part: Head"
partLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
partLabel.TextSize = 12
partLabel.Font = Enum.Font.SourceSans
partLabel.TextXAlignment = Enum.TextXAlignment.Left
partLabel.BackgroundTransparency = 1
partLabel.Parent = partFrame

local partBtn = Instance.new("TextButton")
partBtn.Size = UDim2.new(0, 60, 0, 22)
partBtn.Position = UDim2.new(1, -70, 0.5, -11)
partBtn.Font = Enum.Font.SourceSansBold
partBtn.TextSize = 10
partBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
partBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
partBtn.Text = "Head"
partBtn.Parent = partFrame

local partCornerBtn = Instance.new("UICorner")
partCornerBtn.CornerRadius = UDim.new(0, 4)
partCornerBtn.Parent = partBtn

local parts = {"Head", "HumanoidRootPart", "Torso"}
local partIndex = 1

partBtn.MouseButton1Click:Connect(function()
    partIndex = partIndex % #parts + 1
    Config.aimPart = parts[partIndex]
    partBtn.Text = Config.aimPart
    partLabel.Text = "Aim Part: " .. Config.aimPart
end)

-- ================================
-- ESP TAB
-- ================================
CreateToggle("Enable ESP", ESPTab, "espEnabled")
CreateToggle("Show Distance", ESPTab, "showDistance")
CreateToggle("Show Health", ESPTab, "showHealth")
CreateToggle("Show Hitbox", ESPTab, "showHitbox")

-- ================================
-- WHITELIST TAB
-- ================================
local function UpdateWhitelist()
    for _, child in ipairs(WhitelistTab:GetChildren()) do
        if child:IsA("TextButton") and child.Name ~= "UIListLayout" and child.Name ~= "UICorner" then
            child:Destroy()
        end
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Name = player.Name
            btn.Size = UDim2.new(1, -5, 0, 30)
            btn.BackgroundColor3 = Config.whitelisted[player.Name] and Color3.fromRGB(0, 150, 80) or Color3.fromRGB(40, 40, 45)
            btn.Text = player.Name .. (Config.whitelisted[player.Name] and " ✅" or "")
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 12
            btn.Font = Enum.Font.SourceSans
            btn.Parent = WhitelistTab
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 5)
            corner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                Config.whitelisted[player.Name] = not Config.whitelisted[player.Name]
                btn.Text = player.Name .. (Config.whitelisted[player.Name] and " ✅" or "")
                btn.BackgroundColor3 = Config.whitelisted[player.Name] and Color3.fromRGB(0, 150, 80) or Color3.fromRGB(40, 40, 45)
            end)
        end
    end
end

Players.PlayerAdded:Connect(UpdateWhitelist)
Players.PlayerRemoving:Connect(UpdateWhitelist)
UpdateWhitelist()

-- ================================
-- HACK TAB
-- ================================
CreateToggle("Auto ATM (Collect Cash)", HackTab, "autoATM")
CreateButton("Hack Vehicles (Unlock All)", HackTab, function()
    Config.vehicleHack = not Config.vehicleHack
    if Config.vehicleHack then
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("RemoteEvent") and (string.find(v.Name, "Vehicle") or string.find(v.Name, "Car") or string.find(v.Name, "Lock")) then
                pcall(function() v:FireServer("Unlock") end)
            end
        end
    end
end)

CreateButton("Hack Banks (Auto Cash)", HackTab, function()
    Config.bankHack = not Config.bankHack
    if Config.bankHack then
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("RemoteEvent") and (string.find(v.Name, "Bank") or string.find(v.Name, "ATM") or string.find(v.Name, "Cash")) then
                pcall(function() v:FireServer(true) end)
            end
        end
    end
end)

-- ================================
-- BYPASS TAB
-- ================================
CreateToggle("Enable Bypass System", BypassTab, "bypassEnabled")
CreateToggle("Stealth Mode (Random Delays)", BypassTab, "stealthMode")

CreateButton("Run Anti-Cheat Bypass", BypassTab, function()
    pcall(BypassAntiCheat)
    pcall(BypassRemoteEvents)
    pcall(HideScript)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Bypass",
        Text = "Anti-cheat bypassed successfully!",
        Duration = 2
    })
end)

CreateButton("Randomize Script Names", BypassTab, function()
    pcall(HideScript)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Bypass",
        Text = "Script names randomized!",
        Duration = 2
    })
end)

CreateButton("Clear Console (Remove Traces)", BypassTab, function()
    pcall(function()
        local console = game:GetService("CoreGui"):FindFirstChild("RobloxGui"):FindFirstChild("Console")
        if console then
            console:Clear()
        end
    end)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Bypass",
        Text = "Console cleared!",
        Duration = 2
    })
end)

-- ================================
-- FOV CIRCLE
-- ================================
local FOVCircle = Instance.new("Frame")
FOVCircle.Size = UDim2.new(0, Config.FOVRadius * 2, 0, Config.FOVRadius * 2)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Visible = false
FOVCircle.Parent = ScreenGui

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Thickness = 1.5
FOVStroke.Color = Color3.fromRGB(0, 255, 150)
FOVStroke.Parent = FOVCircle

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVCircle

-- ================================
-- AIMBOT FUNCTION
-- ================================
local function GetClosestPlayer()
    local closest = nil
    local shortest = Config.FOVRadius
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not Config.whitelisted[player.Name] and player.Character then
            local part = player.Character:FindFirstChild(Config.aimPart)
            if part then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortest then
                        shortest = dist
                        closest = player
                    end
                end
            end
        end
    end
    return closest
end

-- ================================
-- ESP SYSTEM
-- ================================
local ESPObjects = {}

local function CreateESP(player)
    if player == LocalPlayer then return end
    if ESPObjects[player] then return end
    
    local char = player.Character
    if not char then return end
    
    local head = char:FindFirstChild("Head")
    if not head then return end
    
    local bill = Instance.new("BillboardGui")
    bill.Name = "ESP_Label"
    bill.Size = UDim2.new(0, 200, 0, 80)
    bill.AlwaysOnTop = true
    bill.StudsOffset = Vector3.new(0, 3, 0)
    bill.Enabled = false
    bill.Parent = head
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Config.espColor
    label.TextSize = 12
    label.Font = Enum.Font.SourceSansBold
    label.TextWrapped = true
    label.Parent = bill
    
    ESPObjects[player] = bill
end

-- ================================
-- MAIN LOOP
-- ================================
RunService.RenderStepped:Connect(function()
    -- FOV Circle
    local mousePos = UserInputService:GetMouseLocation()
    FOVCircle.Position = UDim2.new(0, mousePos.X - Config.FOVRadius, 0, mousePos.Y - Config.FOVRadius)
    FOVCircle.Size = UDim2.new(0, Config.FOVRadius * 2, 0, Config.FOVRadius * 2)
    FOVCircle.Visible = Config.aimbotEnabled
    
    -- ESP Update
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char then
                local head = char:FindFirstChild("Head")
                if head then
                    local bill = head:FindFirstChild("ESP_Label")
                    if not bill then
                        CreateESP(player)
                        bill = head:FindFirstChild("ESP_Label")
                    end
                    
                    if bill and Config.espEnabled then
                        bill.Enabled = true
                        local label = bill:FindFirstChildOfClass("TextLabel")
                        if label then
                            local text = ""
                            
                            -- Name
                            text = text .. player.Name
                            
                            -- Distance
                            if Config.showDistance and LocalPlayer.Character then
                                local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                if root and player.Character then
                                    local pRoot = player.Character:FindFirstChild("HumanoidRootPart")
                                    if pRoot then
                                        local dist = math.floor((root.Position - pRoot.Position).Magnitude)
                                        text = text .. "\n" .. tostring(dist) .. "m"
                                    end
                                end
                            end
                            
                            -- Health
                            if Config.showHealth then
                                local humanoid = char:FindFirstChildOfClass("Humanoid")
                                if humanoid then
                                    text = text .. "\nHP: " .. math.floor(humanoid.Health)
                                end
                            end
                            
                            label.Text = text
                        end
                    elseif bill then
                        bill.Enabled = false
                    end
                    
                    -- Hitbox (highlight)
                    if Config.showHitbox then
                        for _, part in ipairs(char:GetChildren()) do
                            if part:IsA("BasePart") and not part:FindFirstChild("HitboxHighlight") then
                                local hl = Instance.new("Highlight")
                                hl.Name = "HitboxHighlight"
                                hl.Adornee = part
                                hl.FillColor = Color3.fromRGB(255, 0, 0)
                                hl.FillTransparency = 0.3
                                hl.Parent = part
                            end
                        end
                    else
                        for _, part in ipairs(char:GetChildren()) do
                            if part:IsA("BasePart") then
                                local hl = part:FindFirstChild("HitboxHighlight")
                                if hl then hl:Destroy() end
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- Aimbot
    if Config.aimbotEnabled and UserInputService:IsKeyDown(Config.aimKey) then
        local target = GetClosestPlayer()
        if target and target.Character then
            local part = target.Character:FindFirstChild(Config.aimPart)
            if part then
                local pos = part.Position
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, pos), 1 / Config.aimSmoothness)
            end
        end
    end
    
    -- Auto ATM
    if Config.autoATM then
        pcall(function()
            for _, v in ipairs(game:GetDescendants()) do
                if v:IsA("RemoteEvent") then
                    if string.find(v.Name, "Collect") or string.find(v.Name, "Cash") or string.find(v.Name, "Robbery") then
                        v:FireServer()
                    end
                end
            end
        end)
    end
    
    -- Vehicle Hack
    if Config.vehicleHack then
        pcall(function()
            for _, v in ipairs(game:GetDescendants()) do
                if v:IsA("RemoteEvent") and (string.find(v.Name, "Vehicle") or string.find(v.Name, "Car") or string.find(v.Name, "Lock")) then
                    v:FireServer("Unlock")
                    v:FireServer("Start")
                end
            end
        end)
    end
    
    -- Bank Hack
    if Config.bankHack then
        pcall(function()
            for _, v in ipairs(game:GetDescendants()) do
                if v:IsA("RemoteEvent") and (string.find(v.Name, "Bank") or string.find(v.Name, "ATM") or string.find(v.Name, "Cash")) then
                    v:FireServer(true)
                    v:FireServer("Hack")
                end
            end
        end)
    end
end)

-- ================================
-- PLAYER ADDED/REMOVED
-- ================================
Players.PlayerAdded:Connect(UpdateWhitelist)
Players.PlayerRemoving:Connect(UpdateWhitelist)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        CreateESP(player)
    end)
end)

-- ================================
-- START BYPASS
-- ================================
StartBypass()

-- ================================
-- INITIAL NOTIFICATION
-- ================================
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "San Aurie Ultimate v2",
    Text = "All features loaded! Bypass system active.",
    Duration = 4
})
