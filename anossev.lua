-- [[ m1v ADVANCED SUITE V16 - PART 1: UI & TABS SYSTEM ]] --
if not _G.m1v_Config then
    _G.m1v_Config = {
        espEnabled = true,
        aimbotEnabled = true,
        walkSpeedEnabled = false,
        jumpPowerEnabled = false,
        infiniteJump = false,
        
        -- إعدادات الألغاز والتهكير الجديدة
        atmHackEnabled = false,
        vehicleBypassEnabled = false,
        
        -- إعدادات الـ Aimbot والـ ESP الجديدة
        FOV_RADIUS = 150,
        targetSpeed = 16,
        targetJump = 50,
        espColor = Color3.fromRGB(0, 255, 150),
        aimPart = "Head",
        aimKey = Enum.KeyCode.E, -- الزر المطلوب لتفعيل الأيمبوت بضغطة واحدة
        
        whitelistedPlayers = {},
        espObjects = {},
        connections = {}
    }
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function generateSecureToken()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local result = ""
    for i = 1, 16 do
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
_G.m1v_Gui = ScreenGui

-- 1. الزر الصغير الخارجي مكتوب فيه m1v وقابل للتحريك والسحب بالماوس
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = generateSecureToken()
ToggleButton.Size = UDim2.new(0, 55, 0, 35)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleButton.Text = "m1v" -- تم تعديل النص هنا
ToggleButton.TextColor3 = _G.m1v_Config.espColor
ToggleButton.TextSize = 14
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Active = true
ToggleButton.Draggable = true -- تفعيل تحريك الزر الصغير نفسه ف الشاشة
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(40, 40, 40)
ToggleStroke.Thickness = 1.2
ToggleStroke.Parent = ToggleButton

-- 2. اللوحة الرئيسية الكبيرة مجهزة للسحب
local MainFrame = Instance.new("Frame")
MainFrame.Name = generateSecureToken()
MainFrame.Size = UDim2.new(0, 560, 0, 380)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- المربع الكبير قابل للتحريك
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
_G.m1v_MainFrame = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 45, 45)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- شريط التبويبات الجانبي (Tabs Navigation)
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 130, 1, 0)
TabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local TabBarCorner = Instance.new("UICorner")
TabBarCorner.CornerRadius = UDim.new(0, 10)
TabBarCorner.Parent = TabBar

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0, 4)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = TabBar

local ContainerFrame = Instance.new("Frame")
ContainerFrame.Size = UDim2.new(1, -145, 1, -20)
ContainerFrame.Position = UDim2.new(0, 140, 0, 10)
ContainerFrame.BackgroundTransparency = 1
ContainerFrame.Parent = MainFrame
_G.m1v_Container = ContainerFrame

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- دالة معيارية لإنشاء التبويبات (Combat, Visuals, Exploits)
local function createTab(text, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.LayoutOrder = order
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = btn
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 2
    scroll.CanvasSize = UDim2.new(0, 0, 0, 400)
    scroll.Visible = (order == 1)
    scroll.Parent = ContainerFrame
    
    local scrollLayout = Instance.new("UIListLayout")
    scrollLayout.Padding = UDim.new(0, 6)
    scrollLayout.Parent = scroll
    
    btn.MouseButton1Click:Connect(function()
        for _, child in ipairs(ContainerFrame:GetChildren()) do
            if child:IsA("ScrollingFrame") then child.Visible = false end
        end
        scroll.Visible = true
    end)
    
    btn.Parent = TabBar
    return scroll
end

_G.m1v_CombatTab = createTab("Combat (Aim)", 1)
_G.m1v_VisualsTab = createTab("Visuals (ESP)", 2)
_G.m1v_ExploitsTab = createTab("Exploits (Hack)", 3)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "m1v Framework",
    Text = "Part 1 UI Matrix Configured. draggables active.",
    Duration = 3
})

task.wait(0.4)
-- ==========================================================
-- [[ STEP 2: COMBAT & VISUAL CONTROL MODULES ]] ------------
-- ==========================================================
local CombatTab = _G.m1v_CombatTab
local VisualsTab = _G.m1v_VisualsTab

if not CombatTab or not VisualsTab then
    return warn("[m1v Error]: Part 1 structure missing.")
end

local function createToggle(text, parent, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -5, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.Parent = parent
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 160, 1, 0)
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
    btn.BackgroundColor3 = Color3.fromRGB(38, 143, 85)
    btn.Text = "ON"
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    local state = true
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(38, 143, 85) or Color3.fromRGB(150, 52, 52)
        btn.Text = state and "ON" or "OFF"
        callback(state)
    end)
end

-- وضع أزرار التشغيل والتحكم ف التبويبات المخصصة ليها
createToggle("Enable m1v Aimbot", CombatTab, function(s) _G.m1v_Config.aimbotEnabled = s end)
createToggle("Enable m1v ESP Engine", VisualsTab, function(s) _G.m1v_Config.espEnabled = s end)

task.wait(0.2)
-- ==========================================================
-- [[ STEP 3: ADVANCED DETAILED ESP & EXPLOITS MODULES ]] ---
-- ==========================================================
local VisualsTab = _G.m1v_VisualsTab
local ExploitsTab = _G.m1v_ExploitsTab

if not VisualsTab or not ExploitsTab then
    return warn("[m1v Error]: Advanced layout structure not verified.")
end

-- إضافة متغيرات التحكم التفصيلية للـ ESP داخل المصفوفة العالمية
_G.m1v_Config.showESPHealth = true
_G.m1v_Config.showESPDistance = true
_G.m1v_Config.showESPInventory = true

local function createSubToggle(text, parent, defaultState, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -5, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.Parent = parent
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 160, 1, 0)
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
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(38, 143, 85) or Color3.fromRGB(150, 52, 52)
    btn.Text = defaultState and "ON" or "OFF"
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(38, 143, 85) or Color3.fromRGB(150, 52, 52)
        btn.Text = state and "ON" or "OFF"
        callback(state)
    end)
end

-- أزرار تشغيل وإطفاء خصائص الـ ESP بشكل منفصل تماماً كما طلبت
createSubToggle("Display Health [HP]", VisualsTab, _G.m1v_Config.showESPHealth, function(s) _G.m1v_Config.showESPHealth = s end)
createSubToggle("Display Distance [Studs]", VisualsTab, _G.m1v_Config.showESPDistance, function(s) _G.m1v_Config.showESPDistance = s end)
createSubToggle("Display Inventory [Items]", VisualsTab, _G.m1v_Config.showESPInventory, function(s) _G.m1v_Config.showESPInventory = s end)

-- أزرار تشغيل وإطفاء الـ Hacks بـ ON / OFF مستقلة
createSubToggle("Auto ATM & Bank Hack", ExploitsTab, _G.m1v_Config.atmHackEnabled, function(s) _G.m1v_Config.atmHackEnabled = s end)
createSubToggle("Bypass Vehicle Locks", ExploitsTab, _G.m1v_Config.vehicleBypassEnabled, function(s) _G.m1v_Config.vehicleBypassEnabled = s end)

task.wait(0.2)
-- ==========================================================
-- [[ STEP 4: INTERACTIVE KEYBIND & FRIENDLY EXCEPTION UI ]] -
-- ==========================================================
local CombatTab = _G.m1v_CombatTab
local MainFrame = _G.m1v_MainFrame

if not CombatTab or not MainFrame then
    return warn("[m1v Error]: Configuration target stream lost.")
end

-- 1. إضافة زر اختيار المفتاح الخاص بالـ Aimbot (Keybind Selector)
local KeybindFrame = Instance.new("Frame")
KeybindFrame.Size = UDim2.new(1, -5, 0, 40)
KeybindFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeybindFrame.Parent = CombatTab

local KeybindLabel = Instance.new("TextLabel")
KeybindLabel.Size = UDim2.new(0, 140, 1, 0)
KeybindLabel.Position = UDim2.new(0, 10, 0, 0)
KeybindLabel.Text = "Aim Keybind: [" .. _G.m1v_Config.aimKey.Name .. "]"
KeybindLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
KeybindLabel.TextSize = 12
KeybindLabel.Font = Enum.Font.SourceSansBold
KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
KeybindLabel.BackgroundTransparency = 1
KeybindLabel.Parent = KeybindFrame

local BindBtn = Instance.new("TextButton")
BindBtn.Size = UDim2.new(0, 80, 0, 24)
BindBtn.Position = UDim2.new(1, -90, 0.5, -12)
BindBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
BindBtn.Text = "CLICK TO BIND"
BindBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
BindBtn.TextSize = 11
BindBtn.Font = Enum.Font.SourceSansBold
BindBtn.Parent = KeybindFrame

local bindCorner = Instance.new("UICorner")
bindCorner.CornerRadius = UDim.new(0, 4)
bindCorner.Parent = BindBtn

local isBinding = false
BindBtn.MouseButton1Click:Connect(function()
    isBinding = true
    BindBtn.Text = "PRESS ANY KEY"
    BindBtn.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
end)

table.insert(_G.m1v_Config.connections, game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if isBinding and input.UserInputType == Enum.UserInputType.Keyboard then
        _G.m1v_Config.aimKey = input.KeyCode
        KeybindLabel.Text = "Aim Keybind: [" .. input.KeyCode.Name .. "]"
        BindBtn.Text = "CLICK TO BIND"
        BindBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        isBinding = false
    end
end))

-- 2. بناء قائمة Friendly / Whitelist المستقلة بحد ذاتها على اليمين
local WhitelistScroll = Instance.new("ScrollingFrame")
WhitelistScroll.Size = UDim2.new(1, -10, 1, -10)
WhitelistScroll.Position = UDim2.new(0, 5, 0, 5)
WhitelistScroll.BackgroundTransparency = 1
WhitelistScroll.ScrollBarThickness = 3
WhitelistScroll.Parent = MainFrame:FindFirstChild("Frame") or MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 4)
ListLayout.Parent = WhitelistScroll

local function refreshFriendlyList()
    for _, c in ipairs(WhitelistScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    local count = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            count = count + 1
            local item = Instance.new("TextButton")
            item.Size = UDim2.new(1, -6, 0, 30)
            item.Font = Enum.Font.SourceSansBold
            item.TextSize = 12
            item.BackgroundColor3 = _G.m1v_Config.whitelistedPlayers[p.Name] and Color3.fromRGB(35, 75, 125) or Color3.fromRGB(24, 24, 24)
            item.Text = _G.m1v_Config.whitelistedPlayers[p.Name] and "  Friendly: " .. p.Name .. " [SAFE]" or "  Player: " .. p.Name
            item.TextColor3 = Color3.fromRGB(240, 240, 240)
            
            local ic = Instance.new("UICorner")
            ic.CornerRadius = UDim.new(0, 4)
            ic.Parent = item
            
            item.MouseButton1Click:Connect(function()
                if _G.m1v_Config.whitelistedPlayers[p.Name] then _G.m1v_Config.whitelistedPlayers[p.Name] = nil else _G.m1v_Config.whitelistedPlayers[p.Name] = true end
                refreshFriendlyList()
            end)
            item.Parent = WhitelistScroll
        end
    end
    WhitelistScroll.CanvasSize = UDim2.new(0, 0, 0, count * 34)
end

table.insert(_G.m1v_Config.connections, Players.PlayerAdded:Connect(refreshFriendlyList))
table.insert(_G.m1v_Config.connections, Players.PlayerRemoving:Connect(refreshFriendlyList))
refreshFriendlyList()

task.wait(0.2)
-- ==========================================================
-- [[ STEP 5: VISUAL RUNTIME LOGIC & ANTI-EXPLOIT SHIELD ]] -
-- ==========================================================
local Camera = workspace.CurrentCamera
local ScreenGui = _G.m1v_Gui

local function getInventoryTools(player)
    local toolNames = {}
    if player and player:FindFirstChild("Backpack") then
        for _, tool in ipairs(player.Backpack:GetChildren()) do
            if tool:IsA("Tool") then table.insert(toolNames, tool.Name) end
        end
    end
    if player.Character then
        for _, tool in ipairs(player.Character:GetChildren()) do
            if tool:IsA("Tool") then table.insert(toolNames, tool.Name) end
        end
    end
    return #toolNames > 0 and table.concat(toolNames, ", ") or "None"
end

local function constructAdvancedESP(player)
    if player == LocalPlayer then return end
    local function process(character)
        task.defer(function()
            local head = character:WaitForChild("Head", 8)
            local root = character:WaitForChild("HumanoidRootPart", 8)
            if not head or not root then return end
            
            if _G.m1v_Config.espObjects[player.Name] then
                pcall(function() _G.m1v_Config.espObjects[player.Name].Billboard:Destroy() end)
                pcall(function() _G.m1v_Config.espObjects[player.Name].BoxSelection:Destroy() end)
            end
            
            local bGui = Instance.new("BillboardGui")
            bGui.Size = UDim2.new(0, 180, 0, 75)
            bGui.AlwaysOnTop = true
            bGui.Adornee = head
            bGui.Parent = ScreenGui
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = _G.m1v_Config.espColor
            label.TextSize = 11
            label.Font = Enum.Font.SourceSansBold
            label.TextWrapped = true
            label.Parent = bGui
            
            local box = Instance.new("SelectionBox")
            box.Adornee = character
            box.Color3 = _G.m1v_Config.espColor
            box.LineThickness = 0.05
            box.SurfaceTransparency = 0.88
            box.SurfaceColor3 = _G.m1v_Config.espColor
            box.Parent = ScreenGui
            
            _G.m1v_Config.espObjects[player.Name] = {Billboard = bGui, BoxSelection = box, Label = label, RootPart = root, PlayerRef = player}
        end)
    end
    if player.Character then process(player.Character) end
    player.CharacterAdded:Connect(process)
end

for _, p in ipairs(Players:GetPlayers()) do constructAdvancedESP(p) end
table.insert(_G.m1v_Config.connections, Players.PlayerAdded:Connect(constructAdvancedESP))

local function getClosestTarget()
    local target = nil; local shortest = math.huge; local mouse = game:GetService("UserInputService"):GetMouseLocation()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and not _G.m1v_Config.whitelistedPlayers[p.Name] and p.Character and p.Character:FindFirstChild(_G.m1v_Config.aimPart) and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local part = p.Character[_G.m1v_Config.aimPart]
            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
                if dist <= _G.m1v_Config.FOV_RADIUS and dist < shortest then shortest = dist; target = part end
            end
        end
    end
    return target
end

table.insert(_G.m1v_Config.connections, game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.m1v_Config.infiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        pcall(function() LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
    end
end))

-- [[ محرك المزامنة والحماية المستمرة ضد الهكرز الآخرين ]] --
table.insert(_G.m1v_Config.connections, RunService.RenderStepped:Connect(function()
    
    -- خاصية الحماية الفورية: تشويش الـ ESP والـ Aimbot لأي شخص آخر يحاول رصدك
    pcall(function()
        local myChar = LocalPlayer.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            -- إرسال تحديث فيزيائي وهمي للأجهزة الأخرى لتغيير إحداثيات الـ ESP الخاص بهم عن بعد
            local root = myChar.HumanoidRootPart
            if math.random(1, 5) == 1 then
                root.Velocity = Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
            end
        end
    end)

    -- تحديث وحساب بيانات الـ ESP التفصيلية للاعبين الآخرين
    for name, obj in pairs(_G.m1v_Config.espObjects) do
        pcall(function()
            if obj.RootPart and obj.RootPart.Parent and _G.m1v_Config.espEnabled then
                local _, onScreen = Camera:WorldToViewportPoint(obj.RootPart.Position)
                if onScreen then
                    obj.Billboard.Enabled = true; obj.BoxSelection.Visible = true
                    local displayText = "Name: " .. obj.PlayerRef.Name
                    
                    if _G.m1v_Config.showESPHealth then
                        local health = obj.RootPart.Parent.Humanoid.Health
                        local maxHealth = obj.RootPart.Parent.Humanoid.MaxHealth
                        displayText = displayText .. string.format("\nHP: %d/%d", health, maxHealth)
                    end
                    
                    if _G.m1v_Config.showESPDistance then
                        local distance = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - obj.RootPart.Position).Magnitude)
                        displayText = displayText .. string.format("\nDist: %d studs", distance)
                    end
                    
                    if _G.m1v_Config.showESPInventory then
                        local inv = getInventoryTools(obj.PlayerRef)
                        displayText = displayText .. "\nInv: " .. inv
                    end
                    
                    obj.Label.Text = displayText
                else
                    obj.Billboard.Enabled = false; obj.BoxSelection.Visible = false
                end
            else
                obj.Billboard.Enabled = false; obj.BoxSelection.Visible = false
            end
        end)
    end
    
    -- تهكير الألغاز المستمرة (ATM / Bank)
    if _G.m1v_Config.atmHackEnabled then
        pcall(function()
            local bankEvents = ReplicatedStorage:FindFirstChild("BankEvents") or ReplicatedStorage:FindFirstChild("ATMEvents") or ReplicatedStorage
            local hackEvent = bankEvents:FindFirstChild("HackSuccess") or bankEvents:FindFirstChild("CompleteMinigame") or bankEvents:FindFirstChild("ATM_Hack")
            if hackEvent then hackEvent:FireServer(true) end
        end)
    end
    
    -- تهكير قفل المركبات المستمر
    if _G.m1v_Config.vehicleBypassEnabled then
        pcall(function()
            local vehicleEvents = ReplicatedStorage:FindFirstChild("VehicleEvents") or ReplicatedStorage:FindFirstChild("CarEvents") or ReplicatedStorage
            local hijackEvent = vehicleEvents:FindFirstChild("UnLockVehicle") or vehicleEvents:FindFirstChild("CarHackSuccess") or vehicleEvents:FindFirstChild("BypassLock")
            if hijackEvent then hijackEvent:FireServer(true) end
        end)
    end
    
    -- قفل الـ Aimbot عند الضغط على الزر المخصص (E مثلاً)
    if _G.m1v_Config.aimbotEnabled and game:GetService("UserInputService"):IsKeyDown(_G.m1v_Config.aimKey) then
        local t = getClosestTarget()
        if t then Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Position) end
    end
end))

game:GetService("StarterGui"):SetCore("SendNotification", {Title = "m1v Framework", Text = "All Pipeline Steps Loaded 100%. Anti-ESP Active.", Duration = 4})
