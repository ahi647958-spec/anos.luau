local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- إنشاء الزر الرئيسي اللي كيكون فـ الجنب ديال الشاشة
local mainButton = Instance.new("TextButton")
mainButton.Size = UDim2.new(0, 120, 0, 40)
mainButton.Position = UDim2.new(1, -140, 0.5, -20) -- فاليمن ديال الشاشة
mainButton.Text = "Open Menu"
mainButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mainButton.Font = Enum.Font.SourceSansBold
mainButton.TextSize = 18
mainButton.Parent = script.Parent

-- إنشاء الإطار (Tab) اللي كيتفتح
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 200, 0, 150)
menuFrame.Position = UDim2.new(0.5, -100, 0.5, -75) -- وسط الشاشة
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.Visible = false -- كيكون مخفي فالبداية
menuFrame.Parent = script.Parent

-- إنشاء زر تفعيل ميزة معينة داخل الإطار
local actionButton = Instance.new("TextButton")
actionButton.Size = UDim2.new(0, 160, 0, 40)
actionButton.Position = UDim2.new(0.5, -80, 0.5, -20)
actionButton.Text = "Toggle Feature"
actionButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
actionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
actionButton.Parent = menuFrame

-- متغير لتتبع حالة الميزة (واش مشعولة ولا مطفية)
local featureEnabled = false

-- 1. برمجة زر فتح وإغلاق القائمة
mainButton.MouseButton1Click:Connect(function()
	menuFrame.Visible = not menuFrame.Visible -- كيعكس الحالة الحالية (يلا كان باين كيخفيه والعكس)
end)

-- 2. برمجة زر تفعيل الميزة العادية داخل القائمة
actionButton.MouseButton1Click:Connect(function()
	featureEnabled = not featureEnabled
	
	if featureEnabled then
		actionButton.Text = "Feature: ON"
		actionButton.BackgroundColor3 = Color3.fromRGB(85, 255, 127) -- اللون الأخضر
		print("الميزة تفتحت")
		-- هنا كيدير المطور الكود العادي ديال اللعبة (مثلاً زيادة السرعة)
	else
		actionButton.Text = "Feature: OFF"
		actionButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85) -- اللون الأحمر
		print("الميزة تطفات")
	end
end)