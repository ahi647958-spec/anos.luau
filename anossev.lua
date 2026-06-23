-- [[ m1v ENTERPRISE SECURITY FRAMEWORK - PART 1: CORE ENGINE ]] --
-- Initialize global matrix if not already registered
if not _G.m1v_Config then
    _G.m1v_Config = {
        espEnabled = true,
        aimbotEnabled = true,
        FOV_RADIUS = 150,
        walkSpeedEnabled = false,
        jumpPowerEnabled = false,
        infiniteJump = false,
        flightEnabled = false,
        targetSpeed = 16,
        targetJump = 50,
        flightSpeed = 50,
        espColor = Color3.fromRGB(0, 255, 150),
        aimPart = "Head",
        aimMethod = "Camera",
        whitelistedPlayers = {},
        espObjects = {},
        connections = {},
        logs = {}
    }
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Real-time cryptographic naming token generator
local function generateSecureToken()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_!@"
    local result = ""
    for i = 1, math.random(18, 32) do
        local rand = math.random(1, #chars)
        result = result .. string.sub(chars, rand, rand)
    end
    return result
end

-- Find context parent without triggers
local function findContext()
    local parent = nil
    pcall(function() parent = game:GetService("CoreGui") end)
    if not parent then parent = LocalPlayer:WaitForChild("PlayerGui", 12) end
    return parent
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = generateSecureToken()
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = findContext()
_G.m1v_Gui = ScreenGui

-- Visual Toggle Anchor
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = generateSecureToken()
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleButton.Text = "⚡"
ToggleButton.TextColor3 = _G.m1v_Config.espColor
ToggleButton.TextSize = 22
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

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

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local HeaderFrame = Instance.new("Frame")
HeaderFrame.Size = UDim2.new(1, 0, 0, 45)
HeaderFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
HeaderFrame.BorderSizePixel = 0
HeaderFrame.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 300, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Text = "m1v Advanced Framework"
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
LeftScroll.CanvasSize = UDim2.new(0, 0, 0, 450)
LeftScroll.Parent = MainFrame
_G.m1v_LeftScroll = LeftScroll

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "m1v Framework",
    Text = "Part 1 Kernel Loaded successfully.",
    Duration = 4
})
-- [[ m1v ENTERPRISE SECURITY FRAMEWORK - PART 2: CONTROL FACTORY ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local LeftScroll = _G.m1v_LeftScroll
local MainFrame = _G.m1v_MainFrame

if not LeftScroll or not MainFrame then
    return warn("[m1v Error]: Part 1 structure not detected. Execute Part 1 first.")
end

local function generateSecureToken()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local result = ""
    for i = 1, math.random(10, 20) do
        local rand = math.random(1, #chars)
        result = result .. string.sub(chars, rand, rand)
    end
    return result
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
    local function refreshView()
        actionBtn.BackgroundColor3 = state and Color3.fromRGB(38, 143, 85) or Color3.fromRGB(150, 52, 52)
        actionBtn.Text = state and "ENABLED" or "DISABLED"
    end
    refreshView()
    
    actionBtn.MouseButton1Click:Connect(function()
        state = not state
        refreshView()
        callback(state)
    end)
    
    wrapper.Parent = LeftScroll
end

createToggleModule("Visual ESP System", 1, _G.m1v_Config.espEnabled, function(s) _G.m1v_Config.espEnabled = s end)
createToggleModule("Aimbot Tracking", 2, _G.m1v_Config.aimbotEnabled, function(s) _G.m1v_Config.aimbotEnabled = s end)
createToggleModule("Modify WalkSpeed", 3, _G.m1v_Config.walkSpeedEnabled, function(s) _G.m1v_Config.walkSpeedEnabled = s end)
createToggleModule("Modify JumpPower", 4, _G.m1v_Config.jumpPowerEnabled, function(s) _G.m1v_Config.jumpPowerEnabled = s end)
createToggleModule("Infinite Air Jump", 5, _G.m1v_Config.infiniteJump, function(s) _G.m1v_Config.infiniteJump = s end)

local RightContainer = Instance.new("Frame")
RightContainer.Size = UDim2.new(0, 250, 1, -85)
RightContainer.Position = UDim2.new(0, 295, 0, 75)
RightContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
RightContainer.Parent = MainFrame

local ListTitle = Instance.new("TextLabel")
ListTitle.Size = UDim2.new(0, 250, 0, 20)
ListTitle.Position = UDim2.new(0, 295, 0, 52)
ListTitle.Text = "Bypass Exception Exceptions List:"
ListTitle.TextColor3 = Color3.fromRGB(160, 160, 160)
ListTitle.TextSize = 12
ListTitle.Font = Enum.Font.SourceSansBold
ListTitle.BackgroundTransparency = 1
ListTitle.Parent = MainFrame

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -10, 1, -10)
ScrollFrame.Position = UDim2.new(0, 5, 0, 5)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.Parent = RightContainer

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 4)
ListLayout.Parent = ScrollFrame

local function updateWhitelistInterface()
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
            item.Text = _G.m1v_Config.whitelistedPlayers[p.Name] and "  " .. p.Name .. " [SAFE_TARGET]" or "  " .. p.Name
            item.TextColor3 = Color3.fromRGB(240, 240, 240)
            
            local ic = Instance.new("UICorner")
            ic.CornerRadius = UDim.new(0, 4)
            ic.Parent = item
            
            item.MouseButton1Click:Connect(function()
                if _G.m1v_Config.whitelistedPlayers[p.Name] then
                    _G.m1v_Config.whitelistedPlayers[p.Name] = nil
                else
                    _G.m1v_Config.whitelistedPlayers[p.Name] = true
                end
                updateWhitelistInterface()
            end)
            item.Parent = ScrollFrame
        end
    end
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, count * 34)
end

table.insert(_G.m1v_Config.connections, Players.PlayerAdded:Connect(updateWhitelistInterface))
table.insert(_G.m1v_Config.connections, Players.PlayerRemoving:Connect(updateWhitelistInterface))
updateWhitelistInterface()

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "m1v Framework",
    Text = "Part 2 Factory loaded successfully.",
    Duration = 4
})
-- [[ m1v ENTERPRISE SECURITY FRAMEWORK - PART 3: SIMULATION ENGINE ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local LeftScroll = _G.m1v_LeftScroll
local ScreenGui = _G.m1v_Gui

if not LeftScroll or not ScreenGui then
    return warn("[m1v Error]: Architecture sequence interrupted. Verify Part 1 & 2 execution.")
end

-- زر تخطي السجن المتطور والمحاكي للثغرات
local BypassFrame = Instance.new("Frame")
BypassFrame.Size = UDim2.new(1, -5, 0, 40)
BypassFrame.BackgroundTransparency = 1
BypassFrame.LayoutOrder = 6
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
            pcall(function() 
                -- الارتفاع المطور لمنع الاختراق العشوائي والسقوط السليم فوق الخريطة
                character.HumanoidRootPart.CFrame = CFrame.new(150, 150, -250) 
            end)
            game:GetService("StarterGui"):SetCore("SendNotification", {Title = "m1v Success", Text = "Unjail system executed successfully.", Duration = 4})
        end
    end
end)

-- دائرة الـ FOV الرادارية
local FOVFrame = Instance.new("Frame")
FOVFrame.Size = UDim2.new(0, _G.m1v_Config.FOV_RADIUS * 2, 0, _G.m1v_Config.FOV_RADIUS * 2)
FOVFrame.BackgroundTransparency = 1
FOVFrame.Parent = ScreenGui

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Thickness = 1.2
FOVStroke.Color = Color3.fromRGB(0, 255, 150)
FOVStroke.Parent = FOVFrame

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVFrame

-- دالة معالجة الـ ESP المطور لجميع اللاعبين
local function processPlayerESP(player)
    if player == LocalPlayer then return end
    
    local function linkCharacter(character)
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
    
    if player.Character then linkCharacter(player.Character) end
    player.CharacterAdded:Connect(linkCharacter)
end

for _, p in ipairs(Players:GetPlayers()) do processPlayerESP(p) end
table.insert(_G.m1v_Config.connections, Players.PlayerAdded:Connect(processPlayerESP))

-- دالة حساب واختيار أقرب أهداف الـ Aimbot
local function findViewportTarget()
    local selectedTarget = nil
    local minimumDistance = math.huge
    local mouseLocation = UserInputService:GetMouseLocation()
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and not _G.m1v_Config.whitelistedPlayers[p.Name] then
            local char = p.Character
            if char and char:FindFirstChild(_G.m1v_Config.aimPart) and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local part = char[_G.m1v_Config.aimPart]
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - mouseLocation).Magnitude
                    if dist <= _G.m1v_Config.FOV_RADIUS and dist < minimumDistance then
                        minimumDistance = dist
                        selectedTarget = part
                    end
                end
            end
        end
    end
    return selectedTarget
end

-- معالجة نظام الـ Air Jumping المتتابع
table.insert(_G.m1v_Config.connections, UserInputService.JumpRequest:Connect(function()
    if _G.m1v_Config.infiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        pcall(function() LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
    end
end))

-- حلقة التزامن والمحاكاة المطلقة (Render Runtime)
table.insert(_G.m1v_Config.connections, RunService.RenderStepped:Connect(function()
    local mouse = UserInputService:GetMouseLocation()
    FOVFrame.Position = UDim2.new(0, mouse.X - _G.m1v_Config.FOV_RADIUS, 0, mouse.Y - _G.m1v_Config.FOV_RADIUS)
    FOVFrame.Visible = _G.m1v_Config.aimbotEnabled
    
    -- معالجة الهياكل والخطوط لكل عنصر في السيرفر بشكل آمن
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
    
    -- تنفيذ قفل الكاميرا
    if _G.m1v_Config.aimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local currentTarget = findViewportTarget()
        if currentTarget then 
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, currentTarget.Position) 
        end
    end
    
    -- محاكاة الخصائص الفيزيائية المحلية
    local localCharacter = LocalPlayer.Character
    if localCharacter and localCharacter:FindFirstChild("Humanoid") then
        if _G.m1v_Config.walkSpeedEnabled then localCharacter.Humanoid.WalkSpeed = _G.m1v_Config.targetSpeed end
        if _G.m1v_Config.jumpPowerEnabled then localCharacter.Humanoid.JumpPower = _G.m1v_Config.targetJump end
    end
end))

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "m1v Framework",
    Text = "Part 3 Simulation loaded 100%. All codes active.",
    Duration = 5
})
