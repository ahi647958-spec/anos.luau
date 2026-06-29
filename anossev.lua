-- [[ m1v San Aurie Robbery System v2 ]] --
-- Added Square Menu Button (Mini Button) that opens full menu

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ================================
-- CONFIG
-- ================================
local Config = {
    -- Robbery Settings
    autoRobbery = false,
    autoLockpick = false,
    autoThermite = false,
    autoCables = false,
    autoMatrix = false,
    autoKeypad = false,
    autoCollectLoot = false,
    
    -- Safety
    autoEscape = false,
    autoHide = false,
    
    -- GUI
    showUI = true
}

-- ================================
-- ROBBERY SYSTEM
-- ================================

-- 1. Lockpick Puzzle
local function AutoLockpick()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Frame") and (string.find(string.lower(v.Name), "lock") or string.find(string.lower(v.Name), "pick")) then
                local buttons = v:GetDescendants()
                for _, btn in ipairs(buttons) do
                    if btn:IsA("TextButton") and (string.find(string.lower(btn.Text), "pick") or string.find(string.lower(btn.Text), "unlock")) then
                        btn:Click()
                        task.wait(0.1)
                        return
                    end
                end
            end
        end
    end)
end

-- 2. Thermite Puzzle
local function AutoThermite()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Frame") and (string.find(string.lower(v.Name), "thermite") or string.find(string.lower(v.Name), "grid")) then
                local tiles = {}
                for _, child in ipairs(v:GetDescendants()) do
                    if child:IsA("TextButton") and child.BackgroundColor3 ~= Color3.fromRGB(0, 0, 0) then
                        table.insert(tiles, child)
                    end
                end
                for _, tile in ipairs(tiles) do
                    if tile:IsA("TextButton") and tile.Visible then
                        tile:Click()
                        task.wait(0.05)
                    end
                end
            end
        end
    end)
end

-- 3. Cables Puzzle
local function AutoCables()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Frame") and (string.find(string.lower(v.Name), "cable") or string.find(string.lower(v.Name), "fuse") or string.find(string.lower(v.Name), "bypass")) then
                local cables = {}
                for _, child in ipairs(v:GetDescendants()) do
                    if child:IsA("TextButton") and (string.find(string.lower(child.Text), "connect") or string.find(string.lower(child.Text), "wire")) then
                        table.insert(cables, child)
                    end
                end
                for _, cable in ipairs(cables) do
                    if cable:IsA("TextButton") and cable.Visible then
                        cable:Click()
                        task.wait(0.08)
                    end
                end
            end
        end
    end)
end

-- 4. Matrix Puzzle
local function AutoMatrix()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Frame") and (string.find(string.lower(v.Name), "matrix") or string.find(string.lower(v.Name), "hack") or string.find(string.lower(v.Name), "laptop")) then
                local numbers = {}
                for _, child in ipairs(v:GetDescendants()) do
                    if child:IsA("TextButton") and child.Text and tonumber(child.Text) then
                        table.insert(numbers, child)
                    end
                end
                for _, num in ipairs(numbers) do
                    if num:IsA("TextButton") and num.Visible then
                        num:Click()
                        task.wait(0.06)
                    end
                end
            end
        end
    end)
end

-- 5. Keypad Puzzle
local function AutoKeypad()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Frame") and (string.find(string.lower(v.Name), "keypad") or string.find(string.lower(v.Name), "password") or string.find(string.lower(v.Name), "code")) then
                local keys = {}
                for _, child in ipairs(v:GetDescendants()) do
                    if child:IsA("TextButton") and child.Text and tonumber(child.Text) then
                        table.insert(keys, child)
                    end
                end
                for _, key in ipairs(keys) do
                    if key:IsA("TextButton") and key.Visible then
                        key:Click()
                        task.wait(0.02)
                    end
                end
            end
        end
    end)
end

-- 6. Collect Loot
local function AutoCollectLoot()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Tool") or v:IsA("Part") then
                if string.find(string.lower(v.Name), "cash") or string.find(string.lower(v.Name), "money") or 
                   string.find(string.lower(v.Name), "gold") or string.find(string.lower(v.Name), "diamond") or
                   string.find(string.lower(v.Name), "loot") or string.find(string.lower(v.Name), "valuable") then
                    if v:IsA("Tool") then
                        task.wait(0.1)
                        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):EquipTool(v)
                    elseif v:IsA("Part") then
                        local click = v:FindFirstChildOfClass("ClickDetector")
                        if click then
                            click:Click()
                            task.wait(0.05)
                        end
                    end
                end
            end
        end
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("TextButton") and (string.find(string.lower(v.Text), "collect") or 
               string.find(string.lower(v.Text), "loot") or
               string.find(string.lower(v.Text), "take") or
               string.find(string.lower(v.Text), "grab") or
               string.find(string.lower(v.Text), "steal")) then
                v:Click()
                task.wait(0.05)
            end
        end
    end)
end

-- 7. Auto Escape
local function AutoEscape()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Part") and (string.find(string.lower(v.Name), "door") or 
               string.find(string.lower(v.Name), "exit") or
               string.find(string.lower(v.Name), "escape") or
               string.find(string.lower(v.Name), "vent")) then
                local click = v:FindFirstChildOfClass("ClickDetector")
                if click then
                    click:Click()
                    task.wait(0.05)
                end
            end
        end
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("TextButton") and (string.find(string.lower(v.Text), "escape") or 
               string.find(string.lower(v.Text), "exit") or
               string.find(string.lower(v.Text), "leave") or
               string.find(string.lower(v.Text), "flee")) then
                v:Click()
                task.wait(0.05)
            end
        end
    end)
end

-- 8. Auto Hide
local function AutoHide()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Part") and (string.find(string.lower(v.Name), "hiding") or 
               string.find(string.lower(v.Name), "hide") or
               string.find(string.lower(v.Name), "cover") or
               string.find(string.lower(v.Name), "closet")) then
                local click = v:FindFirstChildOfClass("ClickDetector")
                if click then
                    click:Click()
                    task.wait(0.05)
                end
            end
        end
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("TextButton") and (string.find(string.lower(v.Text), "hide") or 
               string.find(string.lower(v.Text), "cover") or
               string.find(string.lower(v.Text), "sneak")) then
                v:Click()
                task.wait(0.05)
            end
        end
    end)
end

-- ================================
-- GUI
-- ================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "m1vRobbery"

-- ================================
-- SQUARE MENU BUTTON (3lama mrb3a)
-- ================================
local MiniButton = Instance.new("TextButton")
MiniButton.Name = "MiniButton"
MiniButton.Size = UDim2.new(0, 55, 0, 55)
MiniButton.Position = UDim2.new(0, 15, 0, 15)
MiniButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MiniButton.Text = "💰"
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

-- Add shine effect to button
local Shine = Instance.new("Frame")
Shine.Size = UDim2.new(0.3, 0, 1, 0)
Shine.Position = UDim2.new(0, 0, 0, 0)
Shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Shine.BackgroundTransparency = 0.7
Shine.Parent = MiniButton

local ShineCorner = Instance.new("UICorner")
ShineCorner.CornerRadius = UDim.new(0, 8)
ShineCorner.Parent = Shine

-- Glow effect
local Glow = Instance.new("Frame")
Glow.Size = UDim2.new(1.2, 0, 1.2, 0)
Glow.Position = UDim2.new(-0.1, 0, -0.1, 0)
Glow.BackgroundTransparency = 1
Glow.Parent = MiniButton

local GlowStroke = Instance.new("UIStroke")
GlowStroke.Color = Color3.fromRGB(255, 200, 0)
GlowStroke.Thickness = 3
GlowStroke.Transparency = 0.7
GlowStroke.Parent = Glow

-- Pulse animation for glow
task.spawn(function()
    while true do
        for i = 1, 100 do
            GlowStroke.Transparency = 0.3 + (i / 100) * 0.5
            task.wait(0.02)
        end
        for i = 1, 100 do
            GlowStroke.Transparency = 0.8 - (i / 100) * 0.5
            task.wait(0.02)
        end
    end
end)

-- ================================
-- MAIN FRAME (9aima l-kbira)
-- ================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 520)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -260)
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
MainStroke.Transparency = 0.5
MainStroke.Parent = MainFrame

-- Title Bar
local Title = Instance.new("Frame")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "💰 m1v Robbery System"
TitleLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Title

-- Close Button (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = Title

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- ================================
-- OPEN MENU WITH SQUARE BUTTON
-- ================================
MiniButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ================================
-- CONTAINER (Scrolling Frame)
-- ================================
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 55)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
Container.CanvasSize = UDim2.new(0, 0, 0, 550)
Container.Parent = MainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.Parent = Container

-- ================================
-- UI FUNCTIONS
-- ================================
local function CreateToggle(text, parent, configKey)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 250, 1, 0)
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

-- Robbery Section
CreateSection("🏪 Robbery Settings", Container)
CreateToggle("Auto Robbery (All Types)", Container, "autoRobbery")
CreateToggle("Auto Collect Loot", Container, "autoCollectLoot")

-- Puzzles Section
CreateSection("🔐 Puzzle Automation", Container)
CreateToggle("Auto Lockpick (Doors)", Container, "autoLockpick")
CreateToggle("Auto Thermite (Grid)", Container, "autoThermite")
CreateToggle("Auto Cables (Bypass)", Container, "autoCables")
CreateToggle("Auto Matrix (IP Hack)", Container, "autoMatrix")
CreateToggle("Auto Keypad (Bruteforce)", Container, "autoKeypad")

-- Safety Section
CreateSection("🛡️ Safety & Escape", Container)
CreateToggle("Auto Escape (Find Exit)", Container, "autoEscape")
CreateToggle("Auto Hide (Cover)", Container, "autoHide")

-- Manual Buttons
CreateSection("⚡ Manual Actions", Container)
CreateButton("🔓 Force Lockpick Now", Container, function()
    AutoLockpick()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "m1v Robbery",
        Text = "Lockpick attempted!",
        Duration = 2
    })
end)

CreateButton("🔥 Force Thermite Now", Container, function()
    AutoThermite()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "m1v Robbery",
        Text = "Thermite attempted!",
        Duration = 2
    })
end)

CreateButton("⚡ Force All Puzzles Now", Container, function()
    AutoLockpick()
    AutoThermite()
    AutoCables()
    AutoMatrix()
    AutoKeypad()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "m1v Robbery",
        Text = "All puzzles attempted!",
        Duration = 2
    })
end)

CreateButton("🏃 Force Escape Now", Container, function()
    AutoEscape()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "m1v Robbery",
        Text = "Escape attempted!",
        Duration = 2
    })
end)

-- ================================
-- STATUS INDICATOR
-- ================================
local StatusFrame = Instance.new("Frame")
StatusFrame.Size = UDim2.new(1, -20, 0, 28)
StatusFrame.Position = UDim2.new(0, 10, 0, 450)
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

-- ================================
-- MAIN LOOP
-- ================================
RunService.RenderStepped:Connect(function()
    if Config.autoRobbery or Config.autoLockpick or Config.autoThermite or 
       Config.autoCables or Config.autoMatrix or Config.autoKeypad or
       Config.autoCollectLoot or Config.autoEscape or Config.autoHide then
        
        StatusLabel.Text = "🟡 Status: Running..."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        
        if Config.autoRobbery then
            pcall(function()
                AutoLockpick()
                AutoThermite()
                AutoCables()
                AutoMatrix()
                AutoKeypad()
                AutoCollectLoot()
            end)
        end
        
        if Config.autoLockpick then pcall(AutoLockpick) end
        if Config.autoThermite then pcall(AutoThermite) end
        if Config.autoCables then pcall(AutoCables) end
        if Config.autoMatrix then pcall(AutoMatrix) end
        if Config.autoKeypad then pcall(AutoKeypad) end
        if Config.autoCollectLoot then pcall(AutoCollectLoot) end
        if Config.autoEscape then pcall(AutoEscape) end
        if Config.autoHide then pcall(AutoHide) end
        
        task.wait(0.5)
    else
        StatusLabel.Text = "🟢 Status: Ready"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
    end
end)

-- ================================
-- KEYBIND: Ctrl + R to toggle menu
-- ================================
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.R and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- ================================
-- INITIAL NOTIFICATION
-- ================================
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "💰 m1v Robbery System v2",
    Text = "Click 💰 square button to open menu | Ctrl+R to toggle",
    Duration = 4
})
