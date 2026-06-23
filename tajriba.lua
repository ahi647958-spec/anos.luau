local toggleButton = script.Parent
local screenGui = toggleButton.Parent

-- 1. صناعة الواجهة الكبيرة (Main Executor Frame)
local mainTab = Instance.new("Frame", screenGui)
mainTab.Name = "MainTab"
mainTab.Size = UDim2.new(0, 500, 0, 320)
mainTab.Position = UDim2.new(0.5, -250, 0.5, -160) -- فـ الوسط نيشان
mainTab.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Dark Background
mainTab.Visible = false -- مخفية ف الأول

local mainCorner = Instance.new("UICorner", mainTab)
mainCorner.CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke", mainTab)
mainStroke.Color = Color3.fromRGB(45, 45, 45)
mainStroke.Thickness = 1.5

-- 2. شريط العنوان (Top Title Bar)
local titleBar = Instance.new("Frame", mainTab)
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)

local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0, 12)

local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(1, -50, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Aman System - Map Destruction Tester v1.5"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.SourceSansBold
titleText.TextSize = 16
titleText.TextXAlignment = Enum.TextXAlignment.Left

-- 3. محرر النصوص (Luau Script Editor)
local scriptBox = Instance.new("TextBox", mainTab)
scriptBox.Size = UDim2.new(0, 340, 0, 240)
scriptBox.Position = UDim2.new(0, 15, 0, 55)
scriptBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
scriptBox.TextColor3 = Color3.fromRGB(230, 230, 230)
scriptBox.Font = Enum.Font.Code
scriptBox.TextSize = 13
scriptBox.TextXAlignment = Enum.TextXAlignment.Left
scriptBox.TextYAlignment = Enum.TextYAlignment.Top
scriptBox.ClearTextOnFocus = false
scriptBox.MultiLine = true

-- وضع كود الـ Unanchored واجد داخل المحرر
scriptBox.Text = [[for _, v in pairs(game.Workspace:GetDescendants()) do
    if v:IsA("BasePart") then
        v.Anchored = false
    end
end]]

local boxCorner = Instance.new("UICorner", scriptBox)
boxCorner.CornerRadius = UDim.new(0, 6)

local boxStroke = Instance.new("UIStroke", scriptBox)
boxStroke.Color = Color3.fromRGB(35, 80, 45) -- إطار خضر خفيف بحال الصورة
boxStroke.Thickness = 1

-- 4. زر التشغيل (Execute Unanchored)
local execBtn = Instance.new("TextButton", mainTab)
execBtn.Size = UDim2.new(0, 110, 0, 45)
execBtn.Position = UDim2.new(0, 370, 0, 95)
execBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 90) -- لون أخضر للـ Execution
execBtn.Text = "Execute\nUnanchored"
execBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
execBtn.Font = Enum.Font.SourceSansBold
execBtn.TextSize = 14

local execCorner = Instance.new("UICorner", execBtn)
execCorner.CornerRadius = UDim.new(0, 8)

-- 5. زر المسح (Clear)
local clearBtn = Instance.new("TextButton", mainTab)
clearBtn.Size = UDim2.new(0, 110, 0, 35)
clearBtn.Position = UDim2.new(0, 370, 0, 150)
clearBtn.BackgroundColor3 = Color3.fromRGB(160, 50, 50) -- لون أحمر
clearBtn.Text = "Clear"
clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearBtn.Font = Enum.Font.SourceSansBold
clearBtn.TextSize = 14

local clearCorner = Instance.new("UICorner", clearBtn)
clearCorner.CornerRadius = UDim.new(0, 8)

-- 6. ستايل زر المربع الصغير (Toggle Button ⚡)
toggleButton.Size = UDim2.new(0, 45, 0, 45)
toggleButton.Position = UDim2.new(0, 20, 0, 20)
toggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
toggleButton.Text = "⚡"
toggleButton.TextColor3 = Color3.fromRGB(0, 255, 140)
toggleButton.TextSize = 22

local btnCorner = Instance.new("UICorner", toggleButton)
btnCorner.CornerRadius = UDim.new(0, 8)

local btnStroke = Instance.new("UIStroke", toggleButton)
btnStroke.Color = Color3.fromRGB(45, 45, 45)
btnStroke.Thickness = 1.5


--- 🕹️ الخدمة والربط (Logic) ---

-- كليكة المربع الصغير تفتح وتخبي الـ Executor
toggleButton.MouseButton1Click:Connect(function()
	mainTab.Visible = not mainTab.Visible
end)

-- زر الـ Clear يمسح النص
clearBtn.MouseButton1Click:Connect(function()
	scriptBox.Text = ""
end)

-- زر الـ Execute ينفذ الكود اللي مكتوب وسط الـ TextBox ديريكت
execBtn.MouseButton1Click:Connect(function()
	print("[Aman Test]: Executing Code from Executor...")
	
	-- تنفيذ عملية الـ Unanchored على الماب كاملة
	for _, v in pairs(game.Workspace:GetDescendants()) do
		if v:IsA("BasePart") and v.Name ~= "Terrain" and not v:IsDescendantOf(game.Players.LocalPlayer.Character) then
			v.Anchored = false
		end
	end
	
	print("[Aman Test]: Map Unanchored successfully. Testing Aman Anti-Cheat response.")
end)
