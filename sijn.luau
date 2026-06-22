-- كود الـ Executor (يُشغل داخل اللعبة)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 1. إرسال إشارة للسيرفر لتفعيل التخطي ومنع السيرفر من طردك أو إعادتك للسجن
local bypassEvent = ReplicatedStorage:FindFirstChild("SanAurrisBypassEvent")
if bypassEvent then
    bypassEvent:FireServer()
else
    warn("لم يتم العثور على حدث التخطي في السيرفر!")
end

-- 2. ميزات التحكم والمراقبة (السرعة والقفز العالي)
local function upgradeCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = 120 -- سرعة خارقة للتنقل في خريطتك
    humanoid.JumpPower = 180 -- قفز عالي لتخطي الأسوار
end

if LocalPlayer.Character then
    upgradeCharacter(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(upgradeCharacter)
print("San Auris Owner Script Executed Successfully!")
