-- [[ m1v San Aurie Heist System v7 FINAL ]] --
-- Auto Bypass + No Delays + Anti-Cheat Removed

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ================================
-- AUTO BYPASS SYSTEM (Runs Automatically - NO DELAYS)
-- ================================

local function AutoBypass()
    pcall(function()
        -- Disable all anti-cheat scripts (NO DELAYS)
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("LocalScript") or v:IsA("ModuleScript") or v:IsA("Script") then
                local name = string.lower(v.Name)
                if string.find(name, "anticheat") or 
                   string.find(name, "anticheat") or
                   string.find(name, "ac_") or 
                   string.find(name, "detection") or
                   string.find(name, "cheat") or
                   string.find(name, "bypass") or
                   string.find(name, "guard") or
                   string.find(name, "security") or
                   string.find(name, "protect") then
                    v.Disabled = true
                    v:Destroy()
                end
            end
        end
        
        -- Remove detection modules
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("ModuleScript") then
                local name = string.lower(v.Name)
                if string.find(name, "anticheat") or 
                   string.find(name, "detect") or
                   string.find(name, "cheat") then
                    v:Destroy()
                end
            end
        end
        
        -- Disable remote event logging
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                local name = string.lower(v.Name)
                if string.find(name, "log") or 
                   string.find(name, "report") or
                   string.find(name, "detect") or
                   string.find(name, "admin") then
                    v:Destroy()
                end
            end
        end
        
        -- Override fire server (NO DELAYS)
        local replicatedStorage = game:GetService("ReplicatedStorage")
        if replicatedStorage then
            for _, v in ipairs(replicatedStorage:GetChildren()) do
                if v:IsA("RemoteEvent") then
                    local original = v.FireServer
                    v.FireServer = function(...)
                        return original(...)
                    end
                end
            end
        end
    end)
end

-- Run auto bypass immediately (NO DELAYS)
AutoBypass()

-- Keep bypass running (reapply if new anti-cheat appears)
local bypassConnection = RunService.Heartbeat:Connect(function()
    pcall(AutoBypass)
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
    autoHide = false
}

-- ================================
-- PUZZLE SOLVERS (NO DELAYS)
-- ================================

local function SolveTimingPuzzle()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Frame") or v:IsA("ImageLabel") then
                if string.find(string.lower(v.Name), "timing") or 
                   string.find(string.lower(v.Name), "circle") or
                   string.find(string.lower(v.Name), "bar") or
                   string.find(string.lower(v.Name), "sweet") then
                    
                    for _, child in ipairs(v:GetDescendants()) do
                        if child:IsA("TextButton") or child:IsA("ImageButton") then
                            if string.find(string.lower(child.Name), "green") or 
                               string.find(string.lower(child.Name), "hit") or
                               string.find(string.lower(child.Name), "click") then
                                child:Click()
                            end
                        end
                    end
                end
            end
        end
    end)
end

local function SolveLockpickPuzzle()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Frame") and (string.find(string.lower(v.Name), "lockpick") or 
               string.find(string.lower(v.Name), "lock") or
               string.find(string.lower(v.Name), "pick") or
               string.find(string.lower(v.Name), "unlock")) then
                
                for _, btn in ipairs(v:GetDescendants()) do
                    if btn:IsA("TextButton") then
                        if string.find(string.lower(btn.Text), "pick") or 
                           string.find(string.lower(btn.Text), "unlock") or
                           string.find(string.lower(btn.Text), "turn") or
                           string.find(string.lower(btn.Text), "click") then
                            btn:Click()
                        end
                    end
                end
            end
        end
    end)
end

local function SolveWiringPuzzle()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Frame") and (string.find(string.lower(v.Name), "wiring") or 
               string.find(string.lower(v.Name), "wire") or
               string.find(string.lower(v.Name), "cable") or
               string.find(string.lower(v.Name), "fuse") or
               string.find(string.lower(v.Name), "connect")) then
                
                local wires = {}
                for _, child in ipairs(v:GetDescendants()) do
                    if child:IsA("TextButton") and child.Visible then
                        table.insert(wires, child)
                    end
                end
                
                for _, wire in ipairs(wires) do
                    if wire:IsA("TextButton") and wire.Visible then
                        wire:Click()
                    end
                end
            end
        end
    end)
end

local function SolveThermitePuzzle()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Frame") and (string.find(string.lower(v.Name), "thermite") or 
               string.find(string.lower(v.Name), "grid") or
               string.find(string.lower(v.Name), "melt") or
               string.find(string.lower(v.Name), "burn")) then
                
                local tiles = {}
                for _, child in ipairs(v:GetDescendants()) do
                    if child:IsA("TextButton") and child.Visible then
                        table.insert(tiles, child)
                    end
                end
                
                for _, tile in ipairs(tiles) do
                    if tile:IsA("TextButton") and tile.Visible then
                        tile:Click()
                    end
                end
            end
        end
    end)
end

local function SolveDrillPuzzle()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Frame") and (string.find(string.lower(v.Name), "drill") or 
               string.find(string.lower(v.Name), "overheat") or
               string.find(string.lower(v.Name), "temperature") or
               string.find(string.lower(v.Name), "bore")) then
                
                for _, child in ipairs(v:GetDescendants()) do
                    if child:IsA("TextButton") then
                        if string.find(string.lower(child.Text), "drill") or 
                           string.find(string.lower(child.Text), "start") or
                           string.find(string.lower(child.Text), "bore") then
                            child:Click()
                            child:Click()
                        end
                    end
                end
            end
        end
    end)
end

local function SolveLaptopHackPuzzle()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Frame") and (string.find(string.lower(v.Name), "laptop") or 
               string.find(string.lower(v.Name), "hacking") or
               string.find(string.lower(v.Name), "code") or
               string.find(string.lower(v.Name), "ip") or
               string.find(string.lower(v.Name), "matrix")) then
                
                local numbers = {}
                for _, child in ipairs(v:GetDescendants()) do
                    if child:IsA("TextButton") and child.Text then
                        if tonumber(child.Text) or string.match(child.Text, "^[A-F0-9]+$") then
                            table.insert(numbers, child)
                        end
                    end
                end
                
                for _, num in ipairs(numbers) do
                    if num:IsA("TextButton") and num.Visible then
                        num:Click()
                    end
                end
            end
        end
    end)
end

local function SolveMemoryGamePuzzle()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Frame") and (string.find(string.lower(v.Name), "memory") or 
               string.find(string.lower(v.Name), "sequence") or
               string.find(string.lower(v.Name), "pattern") or
               string.find(string.lower(v.Name), "repeat")) then
                
                local litButtons = {}
                for _, child in ipairs(v:GetDescendants()) do
                    if child:IsA("TextButton") and child.Visible then
                        if child.BackgroundColor3 ~= Color3.fromRGB(30, 30, 35) then
                            table.insert(litButtons, child)
                        end
                    end
                end
                
                for _, btn in ipairs(litButtons) do
                    if btn:IsA("TextButton") and btn.Visible then
                        btn:Click()
                    end
                end
            end
        end
    end)
end

local function SolveNumberMatchingPuzzle()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Frame") and (string.find(string.lower(v.Name), "match") or 
               string.find(string.lower(v.Name), "numbers") or
               string.find(string.lower(v.Name), "matching") or
               string.find(string.lower(v.Name), "pair")) then
                
                local numbers = {}
                for _, child in ipairs(v:GetDescendants()) do
                    if child:IsA("TextButton") and child.Text then
                        if tonumber(child.Text) or string.match(child.Text, "^[A-F0-9]+$") then
                            table.insert(numbers, child)
                        end
                    end
                end
                
                for _, num in ipairs(numbers) do
                    if num:IsA("TextButton") and num.Visible then
                        num:Click()
                    end
                end
            end
        end
    end)
end

local function SolveCuttingPuzzle()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Frame") and (string.find(string.lower(v.Name), "cut") or 
               string.find(string.lower(v.Name), "slice") or
               string.find(string.lower(v.Name), "snip") or
               string.find(string.lower(v.Name), "wire")) then
                
                for _, child in ipairs(v:GetDescendants()) do
                    if child:IsA("TextButton") then
                        if string.find(string.lower(child.Text), "cut") or 
                           string.find(string.lower(child.Text), "slice") or
                           string.find(string.lower(child.Text), "snip") then
                            child:Click()
                        end
                    end
                end
            end
        end
    end)
end

local function SolveSafeCrackingPuzzle()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Frame") and (string.find(string.lower(v.Name), "safe") or 
               string.find(string.lower(v.Name), "crack") or
               string.find(string.lower(v.Name), "vault") or
               string.find(string.lower(v.Name), "dial") or
               string.find(string.lower(v.Name), "combination")) then
                
                for _, child in ipairs(v:GetDescendants()) do
                    if child:IsA("TextButton") then
                        if string.find(string.lower(child.Text), "left") or 
                           string.find(string.lower(child.Text), "right") or
                           string.find(string.lower(child.Text), "turn") or
                           string.find(string.lower(child.Text), "dial") then
                            child:Click()
                        end
                    end
                end
            end
        end
    end)
end

local function SolveMovementPuzzle()
    pcall(function()
        if LocalPlayer and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                for _, v in ipairs(game:GetDescendants()) do
                    if v:IsA("Part") and (string.find(string.lower(v.Name), "path") or 
                       string.find(string.lower(v.Name), "waypoint") or
                       string.find(string.lower(v.Name), "objective") or
                       string.find(string.lower(v.Name), "point")) then
                        humanoid:MoveTo(v.Position)
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
                if string.find(string.lower(v.Name), "cash") or 
                   string.find(string.lower(v.Name), "money") or
                   string.find(string.lower(v.Name), "gold") or
                   string.find(string.lower(v.Name), "diamond") or
                   string.find(string.lower(v.Name), "loot") or
                   string.find(string.lower(v.Name), "valuable") or
                   string.find(string.lower(v.Name), "jewelry") or
                   string.find(string.lower(v.Name), "painting") then
                    
                    if v:IsA("Tool") then
                        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):EquipTool(v)
                    elseif v:IsA("Part") then
                        local click = v:FindFirstChildOfClass("ClickDetector")
                        if click then
                            click:Click()
                        end
                    end
                end
            end
        end
        
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("TextButton") then
                if string.find(string.lower(v.Text), "collect") or 
                   string.find(string.lower(v.Text), "loot") or
                   string.find(string.lower(v.Text), "take") or
                   string.find(string.lower(v.Text), "grab") or
                   string.find(string.lower(v.Text), "steal") or
                   string.find(string.lower(v.Text), "pick up") then
                    v:Click()
                end
            end
        end
    end)
end

local function AutoEscape()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Part") and (string.find(string.lower(v.Name), "door") or 
               string.find(string.lower(v.Name), "exit") or
               string.find(string.lower(v.Name), "escape") or
               string.find(string.lower(v.Name), "vent") or
               string.find(string.lower(v.Name), "out")) then
                local click = v:FindFirstChildOfClass("ClickDetector")
                if click then
                    click:Click()
                end
            end
        end
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("TextButton") and (string.find(string.lower(v.Text), "escape") or 
               string.find(string.lower(v.Text), "exit") or
               string.find(string.lower(v.Text), "leave") or
               string.find(string.lower(v.Text), "flee") or
               string.find(string.lower(v.Text), "run")) then
                v:Click()
            end
        end
    end)
end

local function AutoHide()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Part") and (string.find(string.lower(v.Name), "hiding") or 
               string.find(string.lower(v.Name), "hide") or
               string.find(string.lower(v.Name), "cover") or
               string.find(string.lower(v.Name), "closet") or
               string.find(string.lower(v.Name), "shadow")) then
                local click = v:FindFirstChildOfClass("ClickDetector")
                if click then
                    click:Click()
                end
            end
        end
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("TextButton") and (string.find(string.lower(v.Text), "hide") or 
               string.find(string.lower(v.Text), "cover") or
               string.find(string.lower(v.Text), "sneak") or
               string.find(string.lower(v.Text), "crouch")) then
                v:Click()
            end
        end
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
MainFrame.Size = UDim2.new(0, 420, 0, 520)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -260)
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
TitleLabel.Text = "🏦 m1v Heist System v7"
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
Container.CanvasSize = UDim2.new(0, 0, 0, 650)
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

CreateSection("🏦 Heists (Each with its own puzzles)", Container)

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
CreateButton("🔓 Force All Heist Puzzles", Container, function()
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
        Text = "All 11 puzzle types attempted!",
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
BypassStatus.Text = "🛡️ Bypass: Active (Auto)"
BypassStatus.TextColor3 = Color3.fromRGB(0, 255, 100)
BypassStatus.TextSize = 10
BypassStatus.Font = Enum.Font.SourceSans
BypassStatus.TextXAlignment = Enum.TextXAlignment.Center
BypassStatus.Parent = StatusFrame

-- ================================
-- MAIN LOOP (NO DELAYS)
-- ================================

RunService.RenderStepped:Connect(function()
    -- Bypass is already running automatically via Heartbeat
    
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
    Title = "🏦 m1v Heist System v7",
    Text = "Auto Bypass | No Delays | 6 Heists | 11 Puzzles",
    Duration = 5
})
