if not _G.m1v_Config then
    _G.m1v_Config = {
        espEnabled = false, aimbotEnabled = false, walkSpeedEnabled = false,
        jumpPowerEnabled = false, infiniteJump = false, showESPHealth = false,
        showESPDistance = false, showESPInventory = false, atmHackEnabled = false,
        vehicleBypassEnabled = false, FOV_RADIUS = 150, targetSpeed = 16,
        targetJump = 50, espColor = Color3.fromRGB(0, 255, 150), aimPart = "Head",
        aimKey = Enum.KeyCode.Space, whitelistedPlayers = {}
    }
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local mouseUnlocked = false

local function generateSecureToken()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local result = ""
    for i = 1, math.random(16, 24) do
        local rand = math.random(1, #chars)
        result = result .. string.sub(chars, rand, rand)
    end
    return result
end

local function getSafeContext()
    local cParent = nil
    pcall(function() cParent = game:GetService("CoreGui") end)
    if not cParent then cParent = LocalPlayer:WaitForChild("PlayerGui", 10) end
    return cParent
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = generateSecureToken()
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = getSafeContext()
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 55, 0, 35)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleButton.Text = "m1v"
ToggleButton.TextColor3 = _G.m1v_Config.espColor
ToggleButton.TextSize = 13
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(45, 45, 45)
ToggleStroke.Thickness = 1.2
ToggleStroke.Parent = ToggleButton

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 560, 0, 380)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(40, 40, 40)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 140, 1, 0)
TabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TabBar.Parent = MainFrame

local TabBarCorner = Instance.new("UICorner")
TabBarCorner.CornerRadius = UDim.new(0, 10)
TabBarCorner.Parent = TabBar

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0, 4)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = TabBar

local ContainerFrame = Instance.new("Frame")
ContainerFrame.Size = UDim2.new(1, -155, 1, -20)
ContainerFrame.Position = UDim2.new(0, 145, 0, 10)
ContainerFrame.BackgroundTransparency = 1
ContainerFrame.Parent = MainFrame

local allScrolls = {}
local function createTab(text, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.LayoutOrder = order
    btn.Parent = TabBar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = btn
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 2
    scroll.CanvasSize = UDim2.new(0, 0, 0, 450)
    scroll.Visible = (order == 1)
    scroll.Parent = ContainerFrame
    
    table.insert(allScrolls, scroll)
    
    btn.MouseButton1Click:Connect(function()
        for _, s in ipairs(allScrolls) do s.Visible = false end
        scroll.Visible = true
    end)
    return scroll
end

local CombatTab = createTab("Combat (Aim)", 1)
local VisualsTab = createTab("Visuals (ESP)", 2)
local ExploitsTab = createTab("Exploits (Hack)", 3)
local WhitelistTab = createTab("Whitelist (Friendly)", 4)
local function createToggle(text, parent, configKey, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -5, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.Parent = parent
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 220, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 13
    label.Font = Enum.Font.SourceSansBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 0, 24)
    btn.Position = UDim2.new(1, -70, 0.5, -12)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 11
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    local state = _G.m1v_Config[configKey]
    btn.BackgroundColor3 = state and Color3.fromRGB(38, 143, 85) or Color3.fromRGB(150, 52, 52)
    btn.Text = state and "ON" or "OFF"
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        _G.m1v_Config[configKey] = not _G.m1v_Config[configKey]
        local newState = _G.m1v_Config[configKey]
        btn.BackgroundColor3 = newState and Color3.fromRGB(38, 143, 85) or Color3.fromRGB(150, 52, 52)
        btn.Text = newState and "ON" or "OFF"
        if callback then callback(newState) end
    end)
end

createToggle("Enable m1v Aimbot", CombatTab, "aimbotEnabled")
createToggle("Enable m1v ESP Engine", VisualsTab, "espEnabled")
createToggle("Display Health [HP]", VisualsTab, "showESPHealth")
createToggle("Display Distance [Studs]", VisualsTab, "showESPDistance")
createToggle("Display Inventory [Items]", VisualsTab, "showESPInventory")
createToggle("Auto ATM & Bank Hack", ExploitsTab, "atmHackEnabled")
createToggle("Bypass Vehicle Locks", ExploitsTab, "vehicleBypassEnabled")

createToggle("Modify WalkSpeed", ExploitsTab, "walkSpeedEnabled", function(s) 
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = s and _G.m1v_Config.targetSpeed or 16
    end
end)
createToggle("Modify JumpPower", ExploitsTab, "jumpPowerEnabled", function(s)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = s and _G.m1v_Config.targetJump or 50
    end
end)
createToggle("Infinite Air Jump", ExploitsTab, "infiniteJump")

local function refreshWhitelistUI()
    for _, child in ipairs(WhitelistTab:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -5, 0, 36)
            frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            frame.Parent = WhitelistTab
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0, 200, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.Text = "Player: " .. player.Name
            label.TextColor3 = Color3.fromRGB(220, 220, 220)
            label.TextSize = 13
            label.Font = Enum.Font.SourceSansBold
            label.BackgroundTransparency = 1
            label.Parent = frame
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 70, 0, 24)
            btn.Position = UDim2.new(1, -80, 0.5, -12)
            btn.Font = Enum.Font.SourceSansBold
            btn.Text = _G.m1v_Config.whitelistedPlayers[player.Name] and "SAFE" or "TARGET"
            btn.BackgroundColor3 = _G.m1v_Config.whitelistedPlayers[player.Name] and Color3.fromRGB(38, 143, 85) or Color3.fromRGB(150, 52, 52)
            btn.Parent = frame
            
            btn.MouseButton1Click:Connect(function()
                _G.m1v_Config.whitelistedPlayers[player.Name] = not _G.m1v_Config.whitelistedPlayers[player.Name]
                local nowSafe = _G.m1v_Config.whitelistedPlayers[player.Name]
                btn.Text = nowSafe and "SAFE" or "TARGET"
                btn.BackgroundColor3 = nowSafe and Color3.fromRGB(38, 143, 85) or Color3.fromRGB(150, 52, 52)
            end)
        end
    end
end
Players.PlayerAdded:Connect(refreshWhitelistUI)
Players.PlayerRemoving:Connect(refreshWhitelistUI)
refreshWhitelistUI()
local AreaFrame = Instance.new("Frame")
AreaFrame.Size = UDim2.new(0, _G.m1v_Config.FOV_RADIUS * 2, 0, _G.m1v_Config.FOV_RADIUS * 2)
AreaFrame.BackgroundTransparency = 1
AreaFrame.Visible = false
AreaFrame.Parent = ScreenGui

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 1
UIStroke.Color = _G.m1v_Config.espColor
UIStroke.Parent = AreaFrame

local UICornerArea = Instance.new("UICorner")
UICornerArea.CornerRadius = UDim.new(1, 0)
UICornerArea.Parent = AreaFrame

local function applyVisualTag(player)
    if player == LocalPlayer then return end
    local function setupBillboard(character)
        local head = character:WaitForChild("Head", 10)
        if not head then return end
        if head:FindFirstChild("DiagnosticLabel") then head.DiagnosticLabel:Destroy() end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "DiagnosticLabel"
        billboard.Size = UDim2.new(0, 250, 0, 70)
        billboard.AlwaysOnTop = true
        billboard.MaxDistance = math.huge
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.Enabled = _G.m1v_Config.espEnabled
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = _G.m1v_Config.espColor
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
    local shortestDistance = _G.m1v_Config.FOV_RADIUS
    local mousePosition = UserInputService:GetMouseLocation()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not _G.m1v_Config.whitelistedPlayers[player.Name] and player.Character and player.Character:FindFirstChild(_G.m1v_Config.aimPart) then
            local targetPart = player.Character[_G.m1v_Config.aimPart]
            local screenPosition, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
            if onScreen then
                local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - mousePosition).Magnitude
                if distance < shortestDistance then shortestDistance = distance closestPlayer = player end
            end
        end
    end
    return closestPlayer
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.LeftControl then
        mouseUnlocked = not mouseUnlocked
        UserInputService.MouseBehavior = mouseUnlocked and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter
    end
end)

UserInputService.JumpRequest:Connect(function()
    if _G.m1v_Config.infiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

RunService.RenderStepped:Connect(function()
    if mouseUnlocked then UserInputService.MouseBehavior = Enum.MouseBehavior.Default end
    local mousePos = UserInputService:GetMouseLocation()
    AreaFrame.Position = UDim2.new(0, mousePos.X - _G.m1v_Config.FOV_RADIUS, 0, mousePos.Y - _G.m1v_Config.FOV_RADIUS)
    AreaFrame.Visible = _G.m1v_Config.aimbotEnabled
    
    if _G.m1v_Config.espEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local enemyRoot = player.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                local billboard = player.Character.Head:FindFirstChild("DiagnosticLabel")
                if billboard then
                    billboard.Enabled = true
                    local textLabel = billboard:FindFirstChildOfClass("TextLabel")
                    if textLabel then
                        local txt = player.Name
                        if _G.m1v_Config.showESPHealth and humanoid then txt = txt .. "\n[HP: " .. tostring(math.floor(humanoid.Health)) .. "/" .. tostring(math.floor(humanoid.MaxHealth)) .. "]" end
                        if _G.m1v_Config.showESPDistance and myRoot and enemyRoot then txt = txt .. " [Dist: " .. tostring(math.floor((myRoot.Position - enemyRoot.Position).Magnitude)) .. "m]" end
                        if _G.m1v_Config.showESPInventory then
                            local item = "None" local currentTool = player.Character:FindFirstChildOfClass("Tool")
                            if currentTool then item = currentTool.Name end txt = txt .. "\n[Item: " .. item .. "]"
                        end
                        textLabel.Text = txt
                    end
                end
            end
        end
    else
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Head") then
                local billboard = player.Character.Head:FindFirstChild("DiagnosticLabel")
                if billboard then billboard.Enabled = false end
            end
        end
    end
    
    if _G.m1v_Config.aimbotEnabled and UserInputService:IsKeyDown(_G.m1v_Config.aimKey) then
        local targetPlayer = getClosestPlayerInZone()
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild(_G.m1v_Config.aimPart) then
            local headPos = targetPlayer.Character[_G.m1v_Config.aimPart].Position
            local cPos = Camera.CFrame.Position
            Camera.CFrame = CFrame.new(cPos, cPos + (headPos - cPos).Unit)
        end
    end
end)

task.spawn(function()
    pcall(function()
        if hookmetamethod and typeof(hookmetamethod) == "function" then
            local oldIndex
            oldIndex = hookmetamethod(game, "__index", function(self, key)
                local isServerCall = false
                pcall(function() if checkcaller then isServerCall = not checkcaller() end end)
                if _G.m1v_Config.aimbotEnabled and self == Camera and key == "CFrame" and isServerCall then
                    return CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Vector3.new(0, 0, -1))
                end
                return oldIndex(self, key)
            end)
        end
    end)
end)
