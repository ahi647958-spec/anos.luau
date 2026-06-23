local toggleButton = script.Parent
local screenGui = toggleButton.Parent
local mainTab = screenGui:WaitForChild("MainTab")
local scriptBox = mainTab:FindFirstChildOfClass("TextBox")
local execBtn = mainTab:FindFirstChild("ExecuteButton") -- تأكد من السمية عندك

-- كود التيست اللي غيبان واجد ف الصندوق (بsame الستايل اللي ف الصورة)
if scriptBox then
	scriptBox.Text = [[function test_security_access()
    print("Attempting unauthorized RemoteEvent access...")
    -- محاولة إرسال أمر تخريبي للسيرفر بدون إذن
    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvent")
    if remote then
        remote:FireServer({action = "unauthorized_map_modify", value = true})
    end
end
test_security_access()]]
end

-- خدمة زر تشغيل التيست
if execBtn then
	execBtn.MouseButton1Click:Connect(function()
		print("[Aman Test]: Executing map vulnerability test...")
		
		-- المحاكاة الحقيقية للخرق:
		local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvent")
		if remote then
			-- هنا الكلاينت كيصيفط سينيال ديريكت للسيرفر باغي يخرب
			remote:FireServer({action = "unauthorized_map_modify", value = true})
			print("[Aman Test]: Signal sent to Server. Check if Aman blocked it!")
		else
			warn("[Aman Test]: No RemoteEvent found in ReplicatedStorage to test with.")
		end
	end)
end

-- فتح وإغلاق الواجهة بالزر المربع
toggleButton.MouseButton1Click:Connect(function()
	mainTab.Visible = not mainTab.Visible
end)
