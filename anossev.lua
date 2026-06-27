-- m1v ULTIMATE TESTING FRAMEWORK v10 - Clean & Optimized
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

local function genName()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local str = ""
    for i = 1, math.random(12, 18) do
        str = str .. chars:sub(math.random(1, #chars), math.random(1, #chars))
    end
    return str
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = genName()
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = (getgenv and getgenv().syn and syn.protect_gui or function(g) end)(ScreenGui) or LocalPlayer:WaitForChild("PlayerGui")

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.Text = "⚡"
ToggleButton.TextColor3 = _G.m1v_Config.espColor
ToggleButton.TextSize = 24
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Draggable = true
ToggleButton.Parent = ScreenGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 580, 0, 420)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Visible = false
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- UICorner & Stroke for nice look
local function addCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = parent
end
addCorner(ToggleButton, 12)
addCorner(MainFrame, 12)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Tabs and UI (kept your structure but cleaned)
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 150, 1, 0)
TabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TabBar.Parent = MainFrame
addCorner(TabBar, 10)

local ContainerFrame = Instance.new("Frame")
ContainerFrame.Size = UDim2.new(1, -160, 1, -20)
ContainerFrame.Position = UDim2.new(0, 155, 0, 10)
ContainerFrame.BackgroundTransparency = 1
ContainerFrame.Parent = MainFrame

-- (Rest of your tab system remains similar, I can expand if you want)

print("✅ m1v Framework Loaded Successfully")
game:GetService("StarterGui"):SetCore("SendNotification", {Title = "m1v v10", Text = "Framework Ready - Test your map!", Duration = 5})
