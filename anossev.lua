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
-- [[ STEP 3: EXPLOITS & PUZZLE AUTOMATION CONTROLS ]] ------
-- ==========================================================
local ExploitsTab = _G.m1v_ExploitsTab

if not ExploitsTab then
    return warn("[m1v Error]: Advanced navigation modules missing.")
end

local function createHackToggle(text, parent, callback)
    local wrapper = Instance.new("Frame")
    wrapper.Size = UDim2.new(1, -5, 0, 38)
    wrapper.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    wrapper.Parent = parent
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = wrapper
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 165, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 13
    label.Font = Enum.Font.SourceSansBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = wrapper
    
    local actionBtn = Instance.new("TextButton")
    actionBtn.Size = UDim2.new(0, 60, 0, 24)
    actionBtn.Position = UDim2.new(1, -70, 0.5, -12)
    actionBtn.Font = Enum.Font.SourceSansBold
    actionBtn.TextSize = 11
    actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    actionBtn.BackgroundColor3 = Color3.fromRGB(150, 52, 52)
    actionBtn.Text = "OFF"
    actionBtn.Parent = wrapper
    
    local ac = Instance.new("UICorner")
    ac.CornerRadius = UDim.new(0, 4)
    ac.Parent = actionBtn
    
    local state = false
    actionBtn.MouseButton1Click:Connect(function()
        state = not state
        actionBtn.BackgroundColor3 = state and Color3.fromRGB(38, 143, 85) or Color3.fromRGB(150, 52, 52)
        actionBtn.Text = state and "ON" or "OFF"
        callback(state)
    end)
end

-- تفعيل أزرار تشغيل وإطفاء الـ Hacks بـ ON / OFF مستقلة كما طلبت
createHackToggle("Auto ATM & Bank Hack", ExploitsTab, function(s) 
    _G.m1v_Config.atmHackEnabled = s 
end)

createHackToggle("Bypass Vehicle Locks", ExploitsTab, function(s) 
    _G.m1v_Config.vehicleBypassEnabled = s 
end)

task.wait(0.2)
-- ==========================================================
-- [[ STEP 4: RADAR FOV BOUNDS & WHITELIST REGISTRATION ]] --
-- ==========================================================
local ScreenGui = _G.m1v_Gui
local MainFrame = _G.m1v_MainFrame

if not ScreenGui or not MainFrame then
    return warn("[m1v Error]: Screen context verification failed.")
end

-- بناء رادار الـ FOV المرئي للـ Aimbot
local FOVFrame = Instance.new("Frame")
FOVFrame.BackgroundTransparency = 1
FOVFrame.Parent = ScreenGui
_G.m1v_FOVFrame = FOVFrame

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Thickness = 1.2
FOVStroke.Color = Color3.fromRGB(255, 0, 0)
FOVStroke.Parent = FOVFrame

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVFrame

-- إدراج لوحة الـ Whitelist الجانبية لإلغاء القفل عن الأصدقاء
local WhitelistScroll = Instance.new("ScrollingFrame")
WhitelistScroll.Size = UDim2.new(1, -10, 1, -10)
WhitelistScroll.Position = UDim2.new(0, 5, 0, 5)
WhitelistScroll.BackgroundTransparency = 1
WhitelistScroll.ScrollBarThickness = 3
WhitelistScroll.Parent = MainFrame:FindFirstChild("Frame") or MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 4)
ListLayout.Parent = WhitelistScroll

local function updateWhitelist()
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
            item.Text = _G.m1v_Config.whitelistedPlayers[p.Name] and "  " .. p.Name .. " [SAFE]" or "  " .. p.Name
            item.TextColor3 = Color3.fromRGB(240, 240, 240)
            
            item.MouseButton1Click:Connect(function()
                if _G.m1v_Config.whitelistedPlayers[p.Name] then _G.m1v_Config.whitelistedPlayers[p.Name] = nil else _G.m1v_Config.whitelistedPlayers[p.Name] = true end
                updateWhitelist()
            end)
            item.Parent = WhitelistScroll
        end
    end
    WhitelistScroll.CanvasSize = UDim2.new(0, 0, 0, count * 34)
end

Players.PlayerAdded:Connect(updateWhitelist)
Players.PlayerRemoving:Connect(updateWhitelist)
updateWhitelist()

task.wait(0.2)
-- ==========================================================
-- [[ STEP 5: SIMULATION DESCENT & KEYBIND RUNTIME ENGINE ]]
-- ==========================================================
local Camera = workspace.CurrentCamera
local ScreenGui = _G.m1v_Gui
local FOVFrame = _G.m1v_FOVFrame

-- دالة جلب الأشياء اللي هاز اللاعب ف الـ Inventory
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

-- محرك الـ ESP الجديد: يعرض الاسم، الحياة، المسافة، والأدوات (بدون خط Tracer)
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
Players.PlayerAdded:Connect(constructAdvancedESP)

local function getClosestTarget()
    local target = nil; local shortest = math.huge; local mouse = UserInputService:GetMouseLocation()
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

-- حلقة الـ Loop الشاملة لتحديث الحالة والمزامنة المستمرة
RunService.RenderStepped:Connect(function()
    local mouse = UserInputService:GetMouseLocation(); local rad = _G.m1v_Config.FOV_RADIUS
    FOVFrame.Size = UDim2.new(0, rad * 2, 0, rad * 2)
    FOVFrame.Position = UDim2.new(0, mouse.X - rad, 0, mouse.Y - rad)
    FOVFrame.Visible = _G.m1v_Config.aimbotEnabled
    
    -- تحديث الـ ESP خطوة بخطوة بالبيانات المطلوبة
    for name, obj in pairs(_G.m1v_Config.espObjects) do
        pcall(function()
            if obj.RootPart and obj.RootPart.Parent and _G.m1v_Config.espEnabled then
                local _, onScreen = Camera:WorldToViewportPoint(obj.RootPart.Position)
                if onScreen then
                    obj.Billboard.Enabled = true; obj.BoxSelection.Visible = true
                    local health = obj.RootPart.Parent.Humanoid.Health
                    local maxHealth = obj.RootPart.Parent.Humanoid.MaxHealth
                    local distance = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - obj.RootPart.Position).Magnitude)
                    local inv = getInventoryTools(obj.PlayerRef)
                    
                    obj.Label.Text = string.format("Name: %s\nHP: %d/%d\nDist: %d studs\nInv: %s", obj.PlayerRef.Name, health, maxHealth, distance, inv)
                else
                    obj.Billboard.Enabled = false; obj.BoxSelection.Visible = false
                end
            else
                obj.Billboard.Enabled = false; obj.BoxSelection.Visible = false
            end
        end)
    end
    
    -- محاكاة التهكير المستمر للألغاز (ATM / Bank) عند تفعيل الزر الخاص بها
    if _G.m1v_Config.atmHackEnabled then
        pcall(function()
            local bankEvents = ReplicatedStorage:FindFirstChild("BankEvents") or ReplicatedStorage:FindFirstChild("ATMEvents") or ReplicatedStorage
            local hackEvent = bankEvents:FindFirstChild("HackSuccess") or bankEvents:FindFirstChild("CompleteMinigame") or bankEvents:FindFirstChild("ATM_Hack")
            if hackEvent then hackEvent:FireServer(true) end
        end)
    end
    
    -- محاكاة التهكير المستمر للسيارات والقوارب عند تفعيل الزر الخاص بها
    if _G.m1v_Config.vehicleBypassEnabled then
        pcall(function()
            local vehicleEvents = ReplicatedStorage:FindFirstChild("VehicleEvents") or ReplicatedStorage:FindFirstChild("CarEvents") or ReplicatedStorage
            local hijackEvent = vehicleEvents:FindFirstChild("UnLockVehicle") or vehicleEvents:FindFirstChild("CarHackSuccess") or vehicleEvents:FindFirstChild("BypassLock")
            if hijackEvent then hijackEvent:FireServer(true) end
        end)
    end
    
    -- لقط الأيمبوت بضغطة زر E واحدة وتثبيته فوق الهدف
    if _G.m1v_Config.aimbotEnabled and UserInputService:IsKeyDown(_G.m1v_Config.aimKey) then
        local t = getClosestTarget()
        if t then Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Position) end
    end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {Title = "m1v Framework", Text = "All Pipeline Steps Loaded 100%.", Duration = 4})
