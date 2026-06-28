-- [[ San Aurie All-in-One Script Hub with Anti-Ban System ]] --
-- Combined features with anti-detection layers

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "San Aurie Hub v2",
   LoadingTitle = "Loading Hub",
   LoadingSubtitle = "Stealth Mode Enabled",
   ConfigurationSaving = {
      Enabled = true,
      FileName = "SanAurieStealth"
   },
   KeySystem = false
})

-- ================================
-- Anti-Ban / Stealth System
-- ================================

local AntiBan = {
    enabled = true,
    randomizers = {},
    connection = nil
}

-- Randomize movement patterns to avoid detection
local function randomizeMovement()
    local player = game:GetService("Players").LocalPlayer
    if player and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local walkSpeed = humanoid.WalkSpeed
            local jumpPower = humanoid.JumpPower
            
            -- Slightly randomize walk speed and jump power
            humanoid.WalkSpeed = walkSpeed + math.random(-2, 2)
            humanoid.JumpPower = jumpPower + math.random(-1, 1)
            
            -- Reset after short time to avoid suspicion
            task.wait(math.random(5, 15))
            humanoid.WalkSpeed = walkSpeed
            humanoid.JumpPower = jumpPower
        end
    end
end

-- Bypass the anti-cheat (if present)
local function bypassAntiCheat()
    -- Hide script from detection
    local function hideScript()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("LocalScript") and v.Name ~= "StarterLocalScript" then
                pcall(function()
                    v.Disabled = true
                    task.wait(math.random(1, 3))
                    v.Disabled = false
                end)
            end
        end
    end
    
    -- Randomize remote event firing
    local originalFireServer = game:GetService("ReplicatedStorage").RemoteEvent.FireServer
    game:GetService("ReplicatedStorage").RemoteEvent.FireServer = function(...)
        if _G.STEALTH_MODE then
            -- Add random delay to avoid detection
            task.wait(math.random(1, 5) / 10)
        end
        return originalFireServer(...)
    end
end

-- Randomize player data to avoid detection
local function randomizeData()
    local player = game:GetService("Players").LocalPlayer
    if player and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Randomize health display slightly (not actual health)
            local health = humanoid.Health
            humanoid.Health = health + math.random(-1, 1)
            task.wait(0.5)
            humanoid.Health = health
        end
    end
end

-- Start the anti-ban system
local function startAntiBan()
    if AntiBan.enabled then
        AntiBan.connection = game:GetService("RunService").Heartbeat:Connect(function()
            if _G.STEALTH_MODE then
                -- Randomize movement every few seconds
                if math.random(1, 20) == 5 then
                    pcall(randomizeMovement)
                end
                
                -- Randomize data occasionally
                if math.random(1, 30) == 7 then
                    pcall(randomizeData)
                end
            end
        end)
        
        -- Bypass anti-cheat
        pcall(bypassAntiCheat)
        
        -- Hide the script from detection
        pcall(hideScript)
    end
end

-- Anti-Ban Toggle
local AntiBanTab = Window:CreateTab("Anti-Ban", nil)

AntiBanTab:CreateToggle({
    Name = "Stealth Mode (Anti-Ban)",
    CurrentValue = true,
    Flag = "StealthMode",
    Callback = function(v)
        _G.STEALTH_MODE = v
        if v then
            startAntiBan()
            Rayfield:Notify({
                Title = "Stealth Mode",
                Content = "Anti-detection systems active",
                Duration = 3
            })
        else
            if AntiBan.connection then
                AntiBan.connection:Disconnect()
                AntiBan.connection = nil
            end
        end
    end
})

-- Randomize Script Names (to avoid detection)
AntiBanTab:CreateButton({
    Name = "Randomize Script Names",
    Callback = function()
        local randomName = function()
            local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            local str = ""
            for i = 1, math.random(10, 20) do
                str = str .. string.sub(chars, math.random(1, #chars), math.random(1, #chars))
            end
            return str
        end
        
        -- Rename all script objects
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("LocalScript") or v:IsA("ModuleScript") or v:IsA("Script") then
                pcall(function()
                    v.Name = randomName()
                end)
            end
        end
        
        Rayfield:Notify({
            Title = "Scripts Renamed",
            Content = "All script names randomized",
            Duration = 2
        })
    end
})

-- Clear Console (to hide errors)
AntiBanTab:CreateButton({
    Name = "Clear Console",
    Callback = function()
        game:GetService("CoreGui"):FindFirstChild("RobloxGui"):FindFirstChild("Console"):Clear()
        Rayfield:Notify({
            Title = "Console Cleared",
            Content = "No trace left",
            Duration = 2
        })
    end
})

-- ================================
-- Combat Features
-- ================================

local MainTab = Window:CreateTab("Combat", nil)

-- Big Head Hitbox with random delay
MainTab:CreateButton({
    Name = "Toggle Big Head Hitbox (Stealth)",
    Callback = function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local LocalPlayer = Players.LocalPlayer

        _G.BIG_HEAD_STATE = _G.BIG_HEAD_STATE or {
            enabled = false,
            data = {},
            paused = {}
        }
        local state = _G.BIG_HEAD_STATE
        local HEAD_SCALE = Vector3.new(12, 12, 12)
        local HEAD_TRANSPARENCY = 0.9

        local function getHead(char) return char and char:FindFirstChild("Head") end
        local function getHumanoid(char) return char and char:FindFirstChildOfClass("Humanoid") end

        local function getAllDecals(head)
            local decals = {}
            for _, obj in ipairs(head:GetChildren()) do
                if obj:IsA("Decal") then table.insert(decals, obj) end
            end
            return decals
        end

        local function revertBigHead(player)
            local saved = state.data[player]
            if not saved then return end
            local head = getHead(player.Character)
            if head then
                head.Size = saved.size
                head.Transparency = saved.transparency
                head.CanCollide = true
                head.Massless = false
                for _, decal in ipairs(saved.decals) do
                    if decal then decal.Parent = head end
                end
            end
            state.data[player] = nil
        end

        local function applyBigHead(player)
            if player == LocalPlayer then return end
            if not player.Character then return end
            local humanoid = getHumanoid(player.Character)
            if not humanoid or humanoid.Health <= 0 then state.paused[player] = true; return end
            local head = getHead(player.Character)
            if not head then return end
            if not state.data[player] then
                state.data[player] = {
                    size = head.Size,
                    transparency = head.Transparency,
                    decals = getAllDecals(head)
                }
            end
            head.Size = HEAD_SCALE
            head.Transparency = HEAD_TRANSPARENCY
            head.CanCollide = false
            head.Massless = true
            for _, decal in ipairs(getAllDecals(head)) do decal.Parent = nil end
        end

        if state.enabled then
            for player in pairs(state.data) do revertBigHead(player) end
            if state.enforceConn then state.enforceConn:Disconnect(); state.enforceConn = nil end
            state.enabled = false
            return
        end

        state.enabled = true
        for _, player in ipairs(Players:GetPlayers()) do applyBigHead(player) end

        state.enforceConn = RunService.Heartbeat:Connect(function()
            if not state.enabled then return end
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local humanoid = getHumanoid(player.Character)
                    local head = getHead(player.Character)
                    if humanoid and humanoid.Health <= 0 then
                        if state.data[player] then revertBigHead(player) end
                        state.paused[player] = true
                    elseif humanoid and humanoid.Health > 0 then
                        if state.paused[player] then
                            state.paused[player] = nil
                            applyBigHead(player)
                        elseif state.data[player] and head then
                            if head.Size ~= HEAD_SCALE or head.Transparency ~= HEAD_TRANSPARENCY then
                                applyBigHead(player)
                            end
                        else
                            applyBigHead(player)
                        end
                    end
                end
            end
        end)
    end
})

-- Silent Aim with random delay
MainTab:CreateToggle({
    Name = "Silent Aim (Stealth)",
    CurrentValue = false,
    Flag = "SilentAim",
    Callback = function(v)
        if v then
            _G.SILENT_AIM_ENABLED = true
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local LocalPlayer = Players.LocalPlayer
            local Camera = workspace.CurrentCamera
            
            _G.SILENT_AIM_CONN = RunService.Heartbeat:Connect(function()
                if _G.SILENT_AIM_ENABLED and _G.STEALTH_MODE then
                    -- Add random delay to avoid detection
                    if math.random(1, 3) == 1 then
                        local closestPlayer = nil
                        local closestDistance = math.huge
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character then
                                local head = player.Character:FindFirstChild("Head")
                                if head then
                                    local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                                    if onScreen then
                                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
                                        if distance < closestDistance then
                                            closestDistance = distance
                                            closestPlayer = player
                                        end
                                    end
                                end
                            end
                        end
                        if closestPlayer and closestPlayer.Character then
                            local head = closestPlayer.Character:FindFirstChild("Head")
                            if head then
                                Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
                            end
                        end
                    end
                end
            end)
        else
            _G.SILENT_AIM_ENABLED = false
            if _G.SILENT_AIM_CONN then
                _G.SILENT_AIM_CONN:Disconnect()
                _G.SILENT_AIM_CONN = nil
            end
        end
    end
})

-- ================================
-- Visuals Features (Stealth)
-- ================================

local VisualsTab = Window:CreateTab("Visuals", nil)

-- ESP with random update delay
VisualsTab:CreateToggle({
    Name = "ESP (Stealth)",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(v)
        if v then
            _G.ESP_ENABLED = true
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            
            _G.ESP_CONN = game:GetService("RunService").Heartbeat:Connect(function()
                if _G.ESP_ENABLED and _G.STEALTH_MODE then
                    -- Update ESP randomly to avoid detection
                    if math.random(1, 5) == 1 then
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character then
                                local head = player.Character:FindFirstChild("Head")
                                if head and not head:FindFirstChild("ESPTag") then
                                    local bill = Instance.new("BillboardGui")
                                    bill.Name = "ESPTag"
                                    bill.Size = UDim2.new(0, 200, 0, 40)
                                    bill.AlwaysOnTop = true
                                    bill.StudsOffset = Vector3.new(0, 3, 0)
                                    bill.Parent = head
                                    
                                    local label = Instance.new("TextLabel")
                                    label.Size = UDim2.new(1, 0, 1, 0)
                                    label.BackgroundTransparency = 1
                                    label.TextColor3 = Color3.fromRGB(255, 255, 255)
                                    label.TextScaled = true
                                    label.Text = player.Name
                                    label.Parent = bill
                                end
                            end
                        end
                    end
                end
            end)
        else
            _G.ESP_ENABLED = false
            if _G.ESP_CONN then
                _G.ESP_CONN:Disconnect()
                _G.ESP_CONN = nil
            end
            for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                if player.Character then
                    local head = player.Character:FindFirstChild("Head")
                    if head then
                        local bill = head:FindFirstChild("ESPTag")
                        if bill then bill:Destroy() end
                    end
                end
            end
        end
    end
})

-- Chams with random timing
VisualsTab:CreateButton({
    Name = "Toggle Chams (Stealth)",
    Callback = function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        
        _G.CHAMS_ENABLED = not _G.CHAMS_ENABLED
        
        if _G.CHAMS_ENABLED and _G.STEALTH_MODE then
            task.wait(math.random(1, 3))
        end
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                for _, part in ipairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if _G.CHAMS_ENABLED then
                            local highlight = Instance.new("Highlight")
                            highlight.Adornee = part
                            highlight.Parent = part
                            highlight.FillColor = Color3.fromRGB(255, 0, 0)
                            highlight.FillTransparency = 0.5
                        else
                            local highlight = part:FindFirstChildOfClass("Highlight")
                            if highlight then highlight:Destroy() end
                        end
                    end
                end
            end
        end
    end
})

-- ================================
-- Utility Features (Stealth)
-- ================================

local UtilityTab = Window:CreateTab("Utility", nil)

-- Infinite Ammo with random values
UtilityTab:CreateButton({
    Name = "Enable Infinite Ammo (Stealth)",
    Callback = function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local player = Players.LocalPlayer
        local backpack = player:WaitForChild("Backpack")
        local TARGET_AMMO = 999
        local trackedAmmo = {}

        local function processTool(tool)
            if not tool:IsA("Tool") then return end
            local config = tool:FindFirstChild("Config")
            if not config then return end
            local ammo = config:FindFirstChild("Ammo")
            if not ammo or not ammo:IsA("ValueBase") then return end
            
            local whitelistFolder = tool:FindFirstChild("_TeamWhitelisted")
            if whitelistFolder then whitelistFolder:Destroy() end
            
            if trackedAmmo[ammo] then return end
            trackedAmmo[ammo] = true
            -- Set to random high value to avoid detection
            ammo.Value = math.random(900, 999)
            ammo.Changed:Connect(function()
                if ammo.Value < 900 then
                    ammo.Value = math.random(900, 999)
                end
            end)
        end

        for _, item in ipairs(backpack:GetChildren()) do processTool(item) end
        
        backpack.ChildAdded:Connect(function(child)
            task.wait(0.1)
            processTool(child)
        end)
        
        RunService.Heartbeat:Connect(function()
            for ammo in pairs(trackedAmmo) do
                if ammo.Parent and ammo.Value < 900 then
                    ammo.Value = math.random(900, 999)
                end
            end
        end)
    end
})

-- No Recoil with random delay
UtilityTab:CreateButton({
    Name = "No Recoil & No Spread (Stealth)",
    Callback = function()
        _G.NO_RECOIL = not _G.NO_RECOIL
        
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        
        local function modifyWeapon(weapon)
            if weapon:FindFirstChild("Config") then
                local config = weapon.Config
                local recoil = config:FindFirstChild("Recoil")
                local spread = config:FindFirstChild("Spread")
                if recoil and _G.NO_RECOIL then
                    recoil.Value = math.random(0, 1)
                end
                if spread and _G.NO_RECOIL then
                    spread.Value = math.random(0, 1)
                end
            end
        end
        
        if player.Character then
            for _, tool in ipairs(player.Character:GetChildren()) do
                if tool:IsA("Tool") then modifyWeapon(tool) end
            end
        end
        
        for _, tool in ipairs(player.Backpack:GetChildren()) do
            if tool:IsA("Tool") then modifyWeapon(tool) end
        end
        
        player.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            for _, tool in ipairs(char:GetChildren()) do
                if tool:IsA("Tool") then modifyWeapon(tool) end
            end
        end)
    end
})

-- Car Speed Boost (randomized)
UtilityTab:CreateButton({
    Name = "Boost Car Speed (Stealth)",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        if player.Character then
            local vehicle = player.Character:FindFirstChildOfClass("VehicleSeat")
            if vehicle then
                local parent = vehicle.Parent
                local engine = parent:FindFirstChild("Engine")
                if engine then
                    local speed = engine:FindFirstChild("Speed")
                    if speed then
                        _G.CAR_BOOST = not _G.CAR_BOOST
                        if _G.CAR_BOOST then
                            speed.Value = speed.Value * math.random(15, 25) / 10
                        else
                            speed.Value = speed.Value / math.random(15, 25) / 10
                        end
                    end
                end
            end
        end
    end
})

-- No Fall Damage (with random reapply)
UtilityTab:CreateButton({
    Name = "No Fall Damage (Stealth)",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        _G.NO_FALL_DAMAGE = not _G.NO_FALL_DAMAGE
        
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            end
        end
        
        -- Reapply randomly to avoid detection
        if _G.NO_FALL_DAMAGE then
            _G.NO_FALL_CONN = game:GetService("RunService").Heartbeat:Connect(function()
                if _G.NO_FALL_DAMAGE and _G.STEALTH_MODE and math.random(1, 10) == 1 then
                    if player.Character then
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                        end
                    end
                end
            end)
        else
            if _G.NO_FALL_CONN then
                _G.NO_FALL_CONN:Disconnect()
                _G.NO_FALL_CONN = nil
            end
        end
    end
})

-- No Ragdoll (stealth)
UtilityTab:CreateButton({
    Name = "No Ragdoll (Stealth)",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        _G.NO_RAGDOLL = not _G.NO_RAGDOLL
        
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            end
        end
    end
})

-- Infinite Stamina (with randomization)
UtilityTab:CreateButton({
    Name = "Infinite Stamina (Stealth)",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        _G.INF_STAMINA = not _G.INF_STAMINA
        
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local stamina = humanoid:FindFirstChild("Stamina")
                if stamina then
                    stamina.Value = math.random(95, 100)
                end
            end
        end
        
        if _G.INF_STAMINA then
            _G.STAMINA_CONN = game:GetService("RunService").Heartbeat:Connect(function()
                if _G.INF_STAMINA and _G.STEALTH_MODE and math.random(1, 5) == 1 then
                    if player.Character then
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            local stamina = humanoid:FindFirstChild("Stamina")
                            if stamina then
                                stamina.Value = math.random(95, 100)
                            end
                        end
                    end
                end
            end)
        else
            if _G.STAMINA_CONN then
                _G.STAMINA_CONN:Disconnect()
                _G.STAMINA_CONN = nil
            end
        end
    end
})

-- Noclip (stealth)
UtilityTab:CreateButton({
    Name = "Toggle Noclip (Stealth)",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        _G.NOCLIP = not _G.NOCLIP
        
        if player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not _G.NOCLIP
                end
            end
        end
    end
})

-- ================================
-- Auto Farm Features (Stealth)
-- ================================

local AutoTab = Window:CreateTab("Auto Farm", nil)

-- Auto Collect Cash (Stealth) - Mimics "Auto ATM" with random timing
AutoTab:CreateButton({
    Name = "Auto Collect Cash (Stealth)",
    Callback = function()
        _G.AUTO_COLLECT = not _G.AUTO_COLLECT
        
        if _G.AUTO_COLLECT then
            local Players = game:GetService("Players")
            local player = Players.LocalPlayer
            
            local function findCashRemotes()
                for _, v in ipairs(game:GetDescendants()) do
                    if v:IsA("RemoteEvent") and (string.find(v.Name, "Cash") or string.find(v.Name, "Collect") or string.find(v.Name, "Robbery")) then
                        -- Randomize fire timing to avoid detection
                        if math.random(1, 3) == 1 then
                            v:FireServer()
                        end
                    end
                end
            end
            
            _G.AUTO_COLLECT_CONN = game:GetService("RunService").Heartbeat:Connect(function()
                if _G.AUTO_COLLECT and _G.STEALTH_MODE then
                    -- Random interval between 2-5 seconds
                    if math.random(1, 30) == 1 then
                        pcall(findCashRemotes)
                    end
                end
            end)
        else
            if _G.AUTO_COLLECT_CONN then
                _G.AUTO_COLLECT_CONN:Disconnect()
                _G.AUTO_COLLECT_CONN = nil
            end
        end
    end
})

-- Auto Minigame (Stealth)
AutoTab:CreateButton({
    Name = "Auto Minigame (Stealth)",
    Callback = function()
        _G.AUTO_MINIGAME = not _G.AUTO_MINIGAME
        
        if _G.AUTO_MINIGAME then
            local function finishMinigames()
                for _, v in ipairs(game:GetDescendants()) do
                    if v:IsA("RemoteEvent") and (string.find(v.Name, "Minigame") or string.find(v.Name, "Game")) then
                        pcall(function()
                            -- Randomize finish timing
                            if math.random(1, 2) == 1 then
                                v:FireServer("Finish")
                            end
                        end)
                    end
                end
            end
            
            _G.MINIGAME_CONN = game:GetService("RunService").Heartbeat:Connect(function()
                if _G.AUTO_MINIGAME and _G.STEALTH_MODE then
                    if math.random(1, 20) == 1 then
                        pcall(finishMinigames)
                    end
                end
            end)
        else
            if _G.MINIGAME_CONN then
                _G.MINIGAME_CONN:Disconnect()
                _G.MINIGAME_CONN = nil
            end
        end
    end
})

-- Auto Fishing Farm (Stealth)
AutoTab:CreateButton({
    Name = "Auto Fishing Farm (Stealth)",
    Callback = function()
        _G.FISH_FARM = not _G.FISH_FARM
        
        if _G.FISH_FARM then
            local function fish()
                for _, v in ipairs(game:GetDescendants()) do
                    if v:IsA("RemoteEvent") and string.find(v.Name, "Fish") then
                        pcall(function()
                            if math.random(1, 3) == 1 then
                                v:FireServer("Cast")
                            end
                        end)
                        break
                    end
                end
            end
            
            local function sellFish()
                for _, v in ipairs(game:GetDescendants()) do
                    if v:IsA("RemoteEvent") and string.find(v.Name, "Sell") then
                        pcall(function()
                            if math.random(1, 3) == 1 then
                                v:FireServer()
                            end
                        end)
                        break
                    end
                end
            end
            
            _G.FISH_CONN = game:GetService("RunService").Heartbeat:Connect(function()
                if _G.FISH_FARM and _G.STEALTH_MODE then
                    if math.random(1, 25) == 1 then
                        pcall(fish)
                        pcall(sellFish)
                    end
                end
            end)
        else
            if _G.FISH_CONN then
                _G.FISH_CONN:Disconnect()
                _G.FISH_CONN = nil
            end
        end
    end
})

-- ================================
-- Additional Stealth Features
-- ================================

-- Randomize FOV (to avoid aimbot detection)
AntiBanTab:CreateButton({
    Name = "Randomize FOV (Anti-Detection)",
    Callback = function()
        _G.FOV_RANDOM = not _G.FOV_RANDOM
        
        if _G.FOV_RANDOM then
            _G.FOV_CONN = game:GetService("RunService").Heartbeat:Connect(function()
                if _G.FOV_RANDOM and _G.STEALTH_MODE then
                    if math.random(1, 10) == 1 then
                        local camera = workspace.CurrentCamera
                        if camera then
                            camera.FieldOfView = math.random(70, 90)
                        end
                    end
                end
            end)
        else
            if _G.FOV_CONN then
                _G.FOV_CONN:Disconnect()
                _G.FOV_CONN = nil
            end
        end
    end
})

-- Fake Lag (to hide teleportation)
AntiBanTab:CreateButton({
    Name = "Enable Fake Lag (Stealth)",
    Callback = function()
        _G.FAKE_LAG = not _G.FAKE_LAG
        
        if _G.FAKE_LAG then
            local player = game:GetService("Players").LocalPlayer
            _G.FAKE_LAG_CONN = game:GetService("RunService").Heartbeat:Connect(function()
                if _G.FAKE_LAG and _G.STEALTH_MODE then
                    if player and player.Character then
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid and math.random(1, 50) == 1 then
                            humanoid.WalkSpeed = humanoid.WalkSpeed - math.random(1, 5)
                            task.wait(0.1)
                            humanoid.WalkSpeed = humanoid.WalkSpeed + math.random(1, 5)
                        end
                    end
                end
            end)
        else
            if _G.FAKE_LAG_CONN then
                _G.FAKE_LAG_CONN:Disconnect()
                _G.FAKE_LAG_CONN = nil
            end
        end
    end
})

-- ================================
-- Notification
-- ================================
Rayfield:Notify({
    Title = "San Aurie Hub v2",
    Content = "Stealth mode active. Anti-ban systems running.",
    Duration = 5
})

-- Start Anti-Ban by default
_G.STEALTH_MODE = true
startAntiBan()
