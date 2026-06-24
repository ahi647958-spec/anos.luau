-- [[ m1v ULTIMATE TESTING FRAMEWORK v10 - STEP 1: INITIALIZATION & TABS ]] --
if not _G.m1v_Config then
    _G.m1v_Config = {
        espEnabled = false,
        aimbotEnabled = false,
        mouseUnlocked = false,
        FOV_RADIUS = 150,
        aimSmoothness = 5,
        aimPart = "Head",
        aimKey = Enum.KeyCode.E,
        playerEsp = false,
        distanceEsp = false,
        itemsEsp = false,
        espColor = Color3.fromRGB(0, 255, 150),
        exploitMasterEnabled = false,
        selectedExploit = "ATM Bank Hack",
        selectedWhitelistPlayer = "",
        whitelistedPlayers = {}
    }
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local mouseUnlocked = false

local function genName()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local str = ""
    for i = 1, math.random(12, 18) do
        local r = math.random(1, #chars)
        str = str .. string.sub(chars, r, r)
    end
    return str
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = genName()
ScreenGui.ResetOnSpawn = false

local secureParent = nil
pcall(function() 
    secureParent = game:GetService("CoreGui") 
end)
if not secureParent then 
    secureParent = LocalPlayer:WaitForChild("PlayerGui", 10) 
end
ScreenGui.Parent = secureParent

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = genName()
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ToggleButton.Text = "⚡"
ToggleButton.TextColor3 = _G.m1v_Config.espColor
ToggleButton.TextSize = 20
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.Parent = ScreenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = ToggleButton

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(45, 45, 45)
btnStroke.Thickness = 1.5
btnStroke.Parent = ToggleButton

local MainFrame = Instance.new("Frame")
MainFrame.Name = genName()
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
    
    local sl = Instance.new("UIListLayout")
    sl.Padding = UDim.new(0, 6)
    sl.Parent = scroll
    
    table.insert(allScrolls, scroll)
    btn.MouseButton1Click:Connect(function()
        for _, s in ipairs(allScrolls) do
            s.Visible = false
        end
        scroll.Visible = true
    end)
    return scroll
end

local CombatTab = createTab("Combat (Aim)", 1)
local VisualsTab = createTab("Visuals (ESP)", 2)
local ExploitsTab = createTab("Exploits (Hack)", 3)
local WhitelistTab = createTab("Whitelist (Friendly)", 4)
-- [[ m1v ULTIMATE TESTING FRAMEWORK v10 - STEP 2: TOGGLES & INTERACTION ]] --
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
        if callback then 
            callback(newState) 
        end
    end)
end

createToggle("Enable m1v Aimbot (FOV Target)", CombatTab, "aimbotEnabled")

createToggle("Set Bind Key to [E Key]", CombatTab, "mouseUnlocked", function(s)
    _G.m1v_Config.aimKey = s and Enum.KeyCode.E or Enum.KeyCode.Space
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Keybind Alert", Text = s and "Keybind shifted to E" or "Keybind shifted to Space", Duration = 2})
end)

createToggle("Increase FOV Size (+50)", CombatTab, "mouseUnlocked", function()
    _G.m1v_Config.FOV_RADIUS = _G.m1v_Config.FOV_RADIUS + 50
    if _G.m1v_Config.FOV_RADIUS > 400 then
        _G.m1v_Config.FOV_RADIUS = 100
    end
end)
createToggle("Toggle Smooth Movement", CombatTab, "mouseUnlocked", function(s)
    _G.m1v_Config.aimSmoothness = s and 12 or 4
end)

createToggle("Enable Player Location ESP", VisualsTab, "playerEsp")
createToggle("Enable Distance Counter ESP", VisualsTab, "distanceEsp")
createToggle("Enable Inventory Items ESP", VisualsTab, "itemsEsp")

createToggle("Activate Master Bypass Switch", ExploitsTab, "exploitMasterEnabled")
createToggle("Select: ATM Bank Hack", ExploitsTab, "mouseUnlocked", function()
    _G.m1v_Config.selectedExploit = "ATM Bank Hack"
end)
createToggle("Select: Vehicle Lock Bypass", ExploitsTab, "mouseUnlocked", function()
    _G.m1v_Config.selectedExploit = "Vehicle Lock Bypass"
end)

createToggle("Set Selected Player to SAFE", WhitelistTab, "mouseUnlocked", function()
    local target = _G.m1v_Config.selectedWhitelistPlayer
    if target and target ~= "" then
        _G.m1v_Config.whitelistedPlayers[target] = not _G.m1v_Config.whitelistedPlayers[target]
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Whitelist Update",
            Text = target .. " status updated.",
            Duration = 2
        })
    end
end)

local function updateWhitelistPlayersList()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and not WhitelistTab:FindFirstChild(p.Name) then
            local pBtn = Instance.new("TextButton")
            pBtn.Name = p.Name
            pBtn.Size = UDim2.new(1, -5, 0, 30)
            pBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            pBtn.Text = "Select: " .. p.Name
            pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            pBtn.Font = Enum.Font.SourceSansBold
            pBtn.TextSize = 12
            pBtn.Parent = WhitelistTab
            
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 4)
            c.Parent = pBtn
            
            pBtn.MouseButton1Click:Connect(function()
                _G.m1v_Config.selectedWhitelistPlayer = p.Name
                pBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
                for _, b in ipairs(WhitelistTab:GetChildren()) do
                    if b:IsA("TextButton") and b.Name ~= p.Name then
                        b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    end
                end
            end)
        end
    end
end
Players.PlayerAdded:Connect(updateWhitelistPlayersList)
RunService.RenderStepped:Connect(updateWhitelistPlayersList)
-- [[ m1v ULTIMATE TESTING FRAMEWORK v10 - STEP 3: RENDER LOOP & STEALTH ]] --
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
        if head:FindFirstChild("DiagnosticLabel") then 
            head.DiagnosticLabel:Destroy() 
        end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "DiagnosticLabel"
        billboard.Size = UDim2.new(0, 250, 0, 70)
        billboard.AlwaysOnTop = true
        billboard.MaxDistance = math.huge
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.Enabled = false
        
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
    if player.Character then 
        setupBillboard(player.Character) 
    end
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
            local screenPosition, onScreen = Camera:WorldToViewportPoint(player.Character[_G.m1v_Config.aimPart].Position)
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

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftControl then
        mouseUnlocked = not mouseUnlocked
        UserInputService.MouseBehavior = mouseUnlocked and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter
    end
end)

RunService.RenderStepped:Connect(function()
    if mouseUnlocked then 
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default 
    end
    local mousePos = UserInputService:GetMouseLocation()
    AreaFrame.Position = UDim2.new(0, mousePos.X - _G.m1v_Config.FOV_RADIUS, 0, mousePos.Y - _G.m1v_Config.FOV_RADIUS)
    AreaFrame.Visible = _G.m1v_Config.aimbotEnabled
    AreaFrame.Size = UDim2.new(0, _G.m1v_Config.FOV_RADIUS * 2, 0, _G.m1v_Config.FOV_RADIUS * 2)
    
    local anyEsp = (_G.m1v_Config.playerEsp or _G.m1v_Config.distanceEsp or _G.m1v_Config.itemsEsp)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local billboard = player.Character.Head:FindFirstChild("DiagnosticLabel")
            if billboard then
                billboard.Enabled = anyEsp
                local textLabel = billboard:FindFirstChildOfClass("TextLabel")
                if textLabel then
                    local txt = _G.m1v_Config.playerEsp and player.Name or ""
                    if _G.m1v_Config.distanceEsp and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("HumanoidRootPart") then
                        txt = txt .. " [" .. tostring(math.floor((LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude)) .. "m]"
                    end
                    if _G.m1v_Config.itemsEsp then
                        local tool = player.Character:FindFirstChildOfClass("Tool")
                        txt = txt .. "\n[Item: " .. (tool and tool.Name or "None") .. "]"
                    end
                    if player.Character:FindFirstChildOfClass("Humanoid") then
                        txt = txt .. "\n[HP: " .. tostring(math.floor(player.Character:FindFirstChildOfClass("Humanoid").Health)) .. "]"
                    end
                    textLabel.Text = txt
                end
            end
        end
    end
    
    -- [[ تم حذف الـ Cooldown تماماً: السكربت يرسل الإشارات فورياً بأقصى سرعة ]]
    if _G.m1v_Config.exploitMasterEnabled then
        pcall(function()
            for _, v in ipairs(game:GetDescendants()) do
                if v:IsA("RemoteEvent") and (_G.m1v_Config.selectedExploit == "ATM Bank Hack" and (string.find(v.Name, "ATM") or string.find(v.Name, "Bank") or string.find(v.Name, "Cash"))) then
                    v:FireServer(true)
                elseif v:IsA("RemoteEvent") and (_G.m1v_Config.selectedExploit == "Vehicle Lock Bypass" and (string.find(v.Name, "Vehicle") or string.find(v.Name, "Car") or string.find(v.Name, "Lock"))) then
                    v:FireServer(false)
                end
            end
        end)
    end
    
    if _G.m1v_Config.aimbotEnabled and UserInputService:IsKeyDown(_G.m1v_Config.aimKey) then
        local targetPlayer = getClosestPlayerInZone()
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild(_G.m1v_Config.aimPart) then
            local headPos = targetPlayer.Character[_G.m1v_Config.aimPart].Position
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, headPos), 1 / _G.m1v_Config.aimSmoothness)
        end
    end
end)

task.spawn(function()
    pcall(function()
        if hookmetamethod and typeof(hookmetamethod) == "function" then
            local oldIndex
            oldIndex = hookmetamethod(game, "__index", function(self, key)
                local isServerCall = false
                pcall(function() 
                    if checkcaller then 
                        isServerCall = not checkcaller() 
                    end 
                end)
                if _G.m1v_Config.aimbotEnabled and self == Camera and key == "CFrame" and isServerCall then
                    return CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Vector3.new(0, 0, -1))
                end
                return oldIndex(self, key)
            end)
        end
    end)
end)
game:GetService("StarterGui"):SetCore("SendNotification", {Title = "m1v Premium v10", Text = "Framework compiled successfully.", Duration = 4})
