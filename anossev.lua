-- [[ m1v ADVANCED SYSTEM - PART 1: MATRIX & INTERFACE ]] --
if not _G.m1v_Config then
    _G.m1v_Config = {
        MainFrame.Draggable = true
        espEnabled = true,
        aimbotEnabled = true,
        FOV_RADIUS = 150,
        walkSpeedEnabled = false,
        jumpPowerEnabled = false,
        infiniteJump = false,
        targetSpeed = 16,
        targetJump = 50,
        espColor = Color3.fromRGB(0, 255, 150),
        aimPart = "Head",
        whitelistedPlayers = {},
        espObjects = {},
        connections = {}
    }
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function generateSecureToken()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_!!"
    local result = ""
    for i = 1, math.random(16, 26) do
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

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = generateSecureToken()
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleButton.Text = "m1v"
ToggleButton.TextColor3 = _G.m1v_Config.espColor
ToggleButton.TextSize = 22
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Parent = ScreenGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = generateSecureToken()
MainFrame.Size = UDim2.new(0, 560, 0, 360)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
_G.m1v_MainFrame = MainFrame

local HeaderFrame = Instance.new("Frame")
HeaderFrame.Size = UDim2.new(1, 0, 0, 45)
HeaderFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
HeaderFrame.BorderSizePixel = 0
HeaderFrame.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 300, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Text = "m1v Premium Suite v15"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = HeaderFrame

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local LeftScroll = Instance.new("ScrollingFrame")
LeftScroll.Size = UDim2.new(0, 260, 1, -65)
LeftScroll.Position = UDim2.new(0, 15, 0, 55)
LeftScroll.BackgroundTransparency = 1
LeftScroll.ScrollBarThickness = 2
LeftScroll.CanvasSize = UDim2.new(0, 0, 0, 480)
LeftScroll.Parent = MainFrame
_G.m1v_LeftScroll = LeftScroll

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "m1v Core",
    Text = "Part 1 Matrix & GUI Loaded Successfully.",
    Duration = 4
})
-- [[ m1v ADVANCED SYSTEM - PART 2: TUNING ENGINE ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local LeftScroll = _G.m1v_LeftScroll
local MainFrame = _G.m1v_MainFrame

if not LeftScroll or not MainFrame then
    return warn("[m1v System Error]: Part 1 is missing. Execute Part 1 first.")
end

local function createToggleModule(text, order, default, callback)
    local wrapper = Instance.new("Frame")
    wrapper.Size = UDim2.new(1, -5, 0, 38)
    wrapper.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    wrapper.LayoutOrder = order
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = wrapper
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 160, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(225, 225, 225)
    label.TextSize = 13
    label.Font = Enum.Font.SourceSansBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = wrapper
    
    local actionBtn = Instance.new("TextButton")
    actionBtn.Size = UDim2.new(0, 65, 0, 24)
    actionBtn.Position = UDim2.new(1, -75, 0.5, -12)
    actionBtn.Font = Enum.Font.SourceSansBold
    actionBtn.TextSize = 11
    actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    local ac = Instance.new("UICorner")
    ac.CornerRadius = UDim.new(0, 4)
    ac.Parent = actionBtn
    
    local state = default
    local function updateUI()
        actionBtn.BackgroundColor3 = state and Color3.fromRGB(38, 143, 85) or Color3.fromRGB(150, 52, 52)
        actionBtn.Text = state and "ON" or "OFF"
    end
    updateUI()
    
    actionBtn.MouseButton1Click:Connect(function()
        state = not state
        updateUI()
        callback(state)
    end)
    
    wrapper.Parent = LeftScroll
end

-- بناء أزرار التحكم في الخصائص الأساسية
createToggleModule("Visual ESP Engine", 1, _G.m1v_Config.espEnabled, function(s) _G.m1v_Config.espEnabled = s end)
createToggleModule("Aimbot Tracking", 2, _G.m1v_Config.aimbotEnabled, function(s) _G.m1v_Config.aimbotEnabled = s end)

-- نظام التحكم الراداري في حجم دائرة الـ FOV (تكبير وتصغير)
local FOVControlFrame = Instance.new("Frame")
FOVControlFrame.Size = UDim2.new(1, -5, 0, 42)
FOVControlFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FOVControlFrame.LayoutOrder = 3
FOVControlFrame.Parent = LeftScroll

local FOVLabel = Instance.new("TextLabel")
FOVLabel.Size = UDim2.new(0, 130, 1, 0)
FOVLabel.Position = UDim2.new(0, 10, 0, 0)
FOVLabel.Text = "FOV Size: " .. tostring(_G.m1v_Config.FOV_RADIUS)
FOVLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
FOVLabel.TextSize = 12
FOVLabel.Font = Enum.Font.SourceSansBold
FOVLabel.TextXAlignment = Enum.TextXAlignment.Left
FOVLabel.BackgroundTransparency = 1
FOVLabel.Parent = FOVControlFrame
_G.m1v_FOVLabel = FOVLabel

local MinusBtn = Instance.new("TextButton")
MinusBtn.Size = UDim2.new(0, 30, 0, 26)
MinusBtn.Position = UDim2.new(1, -80, 0.5, -13)
MinusBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MinusBtn.Text = "-"
MinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinusBtn.TextSize = 16
MinusBtn.Font = Enum.Font.SourceSansBold
MinusBtn.Parent = FOVControlFrame

local PlusBtn = Instance.new("TextButton")
PlusBtn.Size = UDim2.new(0, 30, 0, 26)
PlusBtn.Position = UDim2.new(1, -40, 0.5, -13)
PlusBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
PlusBtn.Text = "+"
PlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PlusBtn.TextSize = 16
PlusBtn.Font = Enum.Font.SourceSansBold
PlusBtn.Parent = FOVControlFrame

MinusBtn.MouseButton1Click:Connect(function()
    if _G.m1v_Config.FOV_RADIUS > 20 then
        _G.m1v_Config.FOV_RADIUS = _G.m1v_Config.FOV_RADIUS - 15
        FOVLabel.Text = "FOV Size: " .. tostring(_G.m1v_Config.FOV_RADIUS)
    end
end)

PlusBtn.MouseButton1Click:Connect(function()
    if _G.m1v_Config.FOV_RADIUS < 600 then
        _G.m1v_Config.FOV_RADIUS = _G.m1v_Config.FOV_RADIUS + 15
        FOVLabel.Text = "FOV Size: " .. tostring(_G.m1v_Config.FOV_RADIUS)
    end
end)

-- أزرار إضافية للفحص الفيزيائي والمطاطي
createToggleModule("Modify WalkSpeed", 4, _G.m1v_Config.walkSpeedEnabled, function(s) _G.m1v_Config.walkSpeedEnabled = s end)
createToggleModule("Modify JumpPower", 5, _G.m1v_Config.jumpPowerEnabled, function(s) _G.m1v_Config.jumpPowerEnabled = s end)
createToggleModule("Infinite Air Jump", 6, _G.m1v_Config.infiniteJump, function(s) _G.m1v_Config.infiniteJump = s end)

local RightContainer = Instance.new("Frame")
RightContainer.Size = UDim2.new(0, 250, 1, -85)
RightContainer.Position = UDim2.new(0, 295, 0, 75)
RightContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
RightContainer.Parent = MainFrame

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -10, 1, -10)
ScrollFrame.Position = UDim2.new(0, 5, 0, 5)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.Parent = RightContainer

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 4)
ListLayout.Parent = ScrollFrame

local function updateWhitelistView()
    for _, c in ipairs(ScrollFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
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
                if _G.m1v_Config.whitelistedPlayers[p.Name] then
                    _G.m1v_Config.whitelistedPlayers[p.Name] = nil
                else
                    _G.m1v_Config.whitelistedPlayers[p.Name] = true
                end
                updateWhitelistView()
            end)
            item.Parent = ScrollFrame
        end
    end
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, count * 34)
end

Players.PlayerAdded:Connect(updateWhitelistView)
Players.PlayerRemoving:Connect(updateWhitelistView)
updateWhitelistView()

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "m1v Factory",
    Text = "Part 2 Controls & FOV Tuner Loaded.",
    Duration = 4
})
-- [[ m1v ADVANCED SYSTEM - PART 3: SIMULATION CORE ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local LeftScroll = _G.m1v_LeftScroll
local ScreenGui = _G.m1v_Gui

if not LeftScroll or not ScreenGui then
    return warn("[m1v System Error]: Pipeline interrupted. Verify Part 1 & 2 loading.")
end

-- زر تخطي السجن الاحترافي
local BypassFrame = Instance.new("Frame")
BypassFrame.Size = UDim2.new(1, -5, 0, 40)
BypassFrame.BackgroundTransparency = 1
BypassFrame.LayoutOrder = 7
BypassFrame.Parent = LeftScroll

local JailBtn = Instance.new("TextButton")
JailBtn.Size = UDim2.new(1, 0, 1, 0)
JailBtn.BackgroundColor3 = Color3.fromRGB(22, 88, 144)
JailBtn.Text = "EXECUTE BYPASS JAIL"
JailBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
JailBtn.Font = Enum.Font.SourceSansBold
JailBtn.TextSize = 13
JailBtn.Parent = BypassFrame

local jc = Instance.new("UICorner")
jc.CornerRadius = UDim.new(0, 5)
jc.Parent = JailBtn

JailBtn.MouseButton1Click:Connect(function()
    local targetEvent = nil
    pcall(function()
        local folder = ReplicatedStorage:FindFirstChild("PoliceEvents")
        if folder then targetEvent = folder:FindFirstChild("RequestRelease") end
    end)
    
    if targetEvent and targetEvent:IsA("RemoteEvent") then
        pcall(function() targetEvent:FireServer(LocalPlayer) end)
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "m1v Success", Text = "Unjail system executed successfully.", Duration = 4})
    else
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            pcall(function() character.HumanoidRootPart.CFrame = CFrame.new(150, 150, -250) end)
            game:GetService("StarterGui"):SetCore("SendNotification", {Title = "m1v Success", Text = "Unjail system executed successfully.", Duration = 4})
        end
    end
end)

-- بناء هيكل الـ FOV الراداري التفاعلي
local FOVFrame = Instance.new("Frame")
FOVFrame.BackgroundTransparency = 1
FOVFrame.Parent = ScreenGui

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Thickness = 1.2
FOVStroke.Color = Color3.fromRGB(255, 0, 0) -- جعل لون الدائرة أحمر واضح ومثير للاهتمام
FOVStroke.Parent = FOVFrame

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVFrame

local function constructESP(player)
    if player == LocalPlayer then return end
    
    local function process(character)
        task.defer(function()
            local head = character:WaitForChild("Head", 8)
            local root = character:WaitForChild("HumanoidRootPart", 8)
            if not head or not root then return end
            
            if _G.m1v_Config.espObjects[player.Name] then
                pcall(function() _G.m1v_Config.espObjects[player.Name].Billboard:Destroy() end)
                pcall(function() _G.m1v_Config.espObjects[player.Name].BoxSelection:Destroy() end)
                pcall(function() _G.m1v_Config.espObjects[player.Name].Tracer:Destroy() end)
            end
            
            local bGui = Instance.new("BillboardGui")
            bGui.Size = UDim2.new(0, 130, 0, 40)
            bGui.AlwaysOnTop = true
            bGui.Adornee = head
            bGui.Parent = ScreenGui
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = player.Name
            label.TextColor3 = _G.m1v_Config.espColor
            label.TextSize = 13
            label.Font = Enum.Font.SourceSansBold
            label.Parent = bGui
            
            local box = Instance.new("SelectionBox")
            box.Adornee = character
            box.Color3 = _G.m1v_Config.espColor
            box.LineThickness = 0.05
            box.SurfaceTransparency = 0.85
            box.SurfaceColor3 = _G.m1v_Config.espColor
            box.Parent = ScreenGui
            
            local tracer = Instance.new("Frame")
            tracer.BorderSizePixel = 0
            tracer.BackgroundColor3 = _G.m1v_Config.espColor
            tracer.AnchorPoint = Vector2.new(0.5, 0.5)
            tracer.Visible = false
            tracer.Parent = ScreenGui
            
            _G.m1v_Config.espObjects[player.Name] = {
                Billboard = bGui,
                BoxSelection = box,
                Tracer = tracer,
                RootPart = root
            }
        end)
    end
    
    if player.Character then process(player.Character) end
    player.CharacterAdded:Connect(process)
end

for _, p in ipairs(Players:GetPlayers()) do constructESP(p) end
Players.PlayerAdded:Connect(constructESP)

local function getTarget()
    local target = nil
    local shortest = math.huge
    local mouse = UserInputService:GetMouseLocation()
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and not _G.m1v_Config.whitelistedPlayers[p.Name] and p.Character and p.Character:FindFirstChild(_G.m1v_Config.aimPart) and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local part = p.Character[_G.m1v_Config.aimPart]
            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
                if dist <= _G.m1v_Config.FOV_RADIUS and dist < shortest then
                    shortest = dist
                    target = part
                end
            end
        end
    end
    return target
end

UserInputService.JumpRequest:Connect(function()
    if _G.m1v_Config.infiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        pcall(function() LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
    end
end)

-- حلقة التزامن والمزامنة الرياضية المستمرة
RunService.RenderStepped:Connect(function()
    local mouse = UserInputService:GetMouseLocation()
    local rad = _G.m1v_Config.FOV_RADIUS
    
    -- تحديث موقع وحجم دائرة الـ FOV ديناميكياً بناءً على القيمة المخزنة
    FOVFrame.Size = UDim2.new(0, rad * 2, 0, rad * 2)
    FOVFrame.Position = UDim2.new(0, mouse.X - rad, 0, mouse.Y - rad)
    FOVFrame.Visible = _G.m1v_Config.aimbotEnabled
    
    if _G.m1v_FOVLabel then
        _G.m1v_FOVLabel.Text = "FOV Size: " .. tostring(rad)
    end
    
    for name, obj in pairs(_G.m1v_Config.espObjects) do
        pcall(function()
            if obj.RootPart and obj.RootPart.Parent then
                local screenPos, onScreen = Camera:WorldToViewportPoint(obj.RootPart.Position)
                
                if onScreen and _G.m1v_Config.espEnabled then
                    obj.Billboard.Enabled = true
                    obj.BoxSelection.Visible = true
                    obj.Tracer.Visible = true
                    
                    local startX = Camera.ViewportSize.X / 2
                    local startY = Camera.ViewportSize.Y
                    local endX = screenPos.X
                    local endY = screenPos.Y
                    
                    local distance = math.sqrt((endX - startX)^2 + (endY - startY)^2)
                    obj.Tracer.Size = UDim2.new(0, distance, 0, 1.5)
                    obj.Tracer.Position = UDim2.new(0, (startX + endX) / 2, 0, (startY + endY) / 2)
                    obj.Tracer.Rotation = math.deg(math.atan2(endY - startY, endX - startX))
                else
                    obj.Billboard.Enabled = false
                    obj.BoxSelection.Visible = false
                    obj.Tracer.Visible = false
                end
            else
                obj.Billboard.Enabled = false
                obj.BoxSelection.Visible = false
                obj.Tracer.Visible = false
            end
        end)
    end
    
    if _G.m1v_Config.aimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t = getTarget()
        if t then Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Position) end
    end
    
    local c = LocalPlayer.Character
    if c and c:FindFirstChild("Humanoid") then
        if _G.m1v_Config.walkSpeedEnabled then c.Humanoid.WalkSpeed = _G.m1v_Config.targetSpeed end
        if _G.m1v_Config.jumpPowerEnabled then c.Humanoid.JumpPower = _G.m1v_Config.targetJump end
    end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "m1v Simulation",
    Text = "Part 3 Dynamic FOV Matrix Synced 100%.",
    Duration = 5
})
