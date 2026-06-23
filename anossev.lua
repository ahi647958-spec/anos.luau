-- [[ m1v ENTERPRISE CORE - PART 1 ]] --
_G.m1v_Config = {
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
    espObjects = {}
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function generateSecureToken()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local result = ""
    for i = 1, math.random(12, 20) do
        local rand = math.random(1, #chars)
        result = result .. string.sub(chars, rand, rand)
    end
    return result
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = generateSecureToken()
ScreenGui.ResetOnSpawn = false

local targetParent = nil
pcall(function() targetParent = game:GetService("CoreGui") end)
if not targetParent then targetParent = LocalPlayer:WaitForChild("PlayerGui", 10) end
ScreenGui.Parent = targetParent
_G.m1v_Gui = ScreenGui

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleButton.Text = "⚡"
ToggleButton.TextColor3 = Color3.fromRGB(0, 255, 150)
ToggleButton.TextSize = 22
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 540, 0, 340)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -170)
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
TitleLabel.Text = "m1v Testing Suite v14"
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
LeftScroll.Size = UDim2.new(0, 250, 1, -65)
LeftScroll.Position = UDim2.new(0, 15, 0, 55)
LeftScroll.BackgroundTransparency = 1
LeftScroll.ScrollBarThickness = 2
LeftScroll.CanvasSize = UDim2.new(0, 0, 0, 350)
LeftScroll.Parent = MainFrame
_G.m1v_LeftScroll = LeftScroll

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "m1v System",
    Text = "Part 1 Loaded Successfully.",
    Duration = 3
})
-- [[ m1v MODULE ENGINE - PART 2 ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local LeftScroll = _G.m1v_LeftScroll
local MainFrame = _G.m1v_MainFrame

if not LeftScroll or not MainFrame then
    return warn("Please execute Part 1 first!")
end

local function createToggle(text, order, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -5, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.LayoutOrder = order
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = frame
    
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
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 60, 0, 24)
    button.Position = UDim2.new(1, -70, 0.5, -12)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 11
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = button
    
    local state = default
    local function render()
        button.BackgroundColor3 = state and Color3.fromRGB(38, 143, 85) or Color3.fromRGB(150, 52, 52)
        button.Text = state and "ENABLED" or "DISABLED"
    end
    render()
    
    button.MouseButton1Click:Connect(function()
        state = not state
        render()
        callback(state)
    end)
    
    frame.Parent = LeftScroll
end

createToggle("Visual ESP Engine", 1, _G.m1v_Config.espEnabled, function(s) _G.m1v_Config.espEnabled = s end)
createToggle("Aimbot Tracking", 2, _G.m1v_Config.aimbotEnabled, function(s) _G.m1v_Config.aimbotEnabled = s end)
createToggle("Modify WalkSpeed", 3, _G.m1v_Config.walkSpeedEnabled, function(s) _G.m1v_Config.walkSpeedEnabled = s end)
createToggle("Modify JumpPower", 4, _G.m1v_Config.jumpPowerEnabled, function(s) _G.m1v_Config.jumpPowerEnabled = s end)
createToggle("Infinite Air Jump", 5, _G.m1v_Config.infiniteJump, function(s) _G.m1v_Config.infiniteJump = s end)

local RightContainer = Instance.new("Frame")
RightContainer.Size = UDim2.new(0, 240, 1, -85)
RightContainer.Position = UDim2.new(0, 285, 0, 75)
RightContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
RightContainer.Parent = MainFrame

local RightCorner = Instance.new("UICorner")
RightCorner.CornerRadius = UDim.new(0, 6)
RightCorner.Parent = RightContainer

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -10, 1, -10)
ScrollFrame.Position = UDim2.new(0, 5, 0, 5)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.Parent = RightContainer

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 4)
ListLayout.Parent = ScrollFrame

local function updateList()
    for _, c in ipairs(ScrollFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    local count = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            count = count + 1
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -6, 0, 28)
            btn.Font = Enum.Font.SourceSansBold
            btn.TextSize = 12
            btn.BackgroundColor3 = _G.m1v_Config.whitelistedPlayers[p.Name] and Color3.fromRGB(35, 75, 125) or Color3.fromRGB(24, 24, 24)
            btn.Text = _G.m1v_Config.whitelistedPlayers[p.Name] and p.Name .. " [SAFE]" or p.Name
            btn.TextColor3 = Color3.fromRGB(240, 240, 240)
            
            local bc = Instance.new("UICorner")
            bc.CornerRadius = UDim.new(0, 4)
            bc.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                if _G.m1v_Config.whitelistedPlayers[p.Name] then
                    _G.m1v_Config.whitelistedPlayers[p.Name] = nil
                else
                    _G.m1v_Config.whitelistedPlayers[p.Name] = true
                end
                updateList()
            end)
            btn.Parent = ScrollFrame
        end
    end
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, count * 32)
end

Players.PlayerAdded:Connect(updateList)
Players.PlayerRemoving:Connect(updateList)
updateList()

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "m1v System",
    Text = "Part 2 Loaded Successfully.",
    Duration = 3
})
-- [[ m1v MECHANICS ENGINE - PART 3 ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local LeftScroll = _G.m1v_LeftScroll
local ScreenGui = _G.m1v_Gui

if not LeftScroll or not ScreenGui then
    return warn("Please execute Part 1 and Part 2 first!")
end

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
            pcall(function() character.HumanoidRootPart.CFrame = CFrame.new(150, 10, -250) end)
            game:GetService("StarterGui"):SetCore("SendNotification", {Title = "m1v Success", Text = "Unjail system executed successfully.", Duration = 4})
        end
    end
end)

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

local function constructESP(player)
    if player == LocalPlayer then return end
    local function process(character)
        task.defer(function()
            local head = character:WaitForChild("Head", 8)
            if not head then return end
            
            if _G.m1v_Config.espObjects[player.Name] then
                pcall(function() _G.m1v_Config.espObjects[player.Name].Billboard:Destroy() end)
                pcall(function() _G.m1v_Config.espObjects[player.Name].Highlight:Destroy() end)
            end
            
            local bGui = Instance.new("BillboardGui")
            bGui.Size = UDim2.new(0, 130, 0, 40)
            bGui.AlwaysOnTop = true
            bGui.Parent = head
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = player.Name
            label.TextColor3 = _G.m1v_Config.espColor
            label.TextSize = 12
            label.Font = Enum.Font.SourceSansBold
            label.Parent = bGui
            
            local highlight = Instance.new("Highlight")
            highlight.Adornee = character
            highlight.FillColor = _G.m1v_Config.espColor
            highlight.FillTransparency = 0.65
            highlight.Parent = character
            
            _G.m1v_Config.espObjects[player.Name] = {Billboard = bGui, Highlight = highlight}
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

RunService.RenderStepped:Connect(function()
    local mouse = UserInputService:GetMouseLocation()
    FOVFrame.Position = UDim2.new(0, mouse.X - _G.m1v_Config.FOV_RADIUS, 0, mouse.Y - _G.m1v_Config.FOV_RADIUS)
    FOVFrame.Visible = _G.m1v_Config.aimbotEnabled
    
    for _, obj in pairs(_G.m1v_Config.espObjects) do
        pcall(function()
            obj.Billboard.Enabled = _G.m1v_Config.espEnabled
            obj.Highlight.Enabled = _G.m1v_Config.espEnabled
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
    Title = "m1v System",
    Text = "m1v Testing Suite Loaded 100%.",
    Duration = 4
})
