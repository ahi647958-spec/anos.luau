--[[
  EDITED BY PEACE — ESP + Aimbot + Team Checker
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Teams = game:GetService("Teams")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local CFG = {
    ESP = { Box = true, Name = true, Health = true, Chams = true, Tracer = false },
    Aim = { Enabled = false, Key = Enum.KeyCode.Q, FOV = 120, Smooth = 0.6, Lock = false, Visible = true },
    Misc = { FriendlyTeams = {} },
}

-- Settings persistence
local fovC_Visible = false
local function loadSettings()
    local ok, d = pcall(function() return readfile("san_aurie_settings.json") end)
    if not ok or not d then return end
    local ok2, t = pcall(function() return HttpService:JSONDecode(d) end)
    if not ok2 or not t then return end
    if t.ESP then for k, v in pairs(t.ESP) do if CFG.ESP[k] ~= nil then CFG.ESP[k] = v end end end
    if t.Aim then
        for k, v in pairs(t.Aim) do
            if k == "Key" and type(v) == "string" then local ke = Enum.KeyCode[v]; if ke then CFG.Aim.Key = ke end
            elseif CFG.Aim[k] ~= nil then CFG.Aim[k] = v end
        end
    end
    if t.Misc and t.Misc.FriendlyTeams then CFG.Misc.FriendlyTeams = t.Misc.FriendlyTeams end
    if t.FOVCircle ~= nil then fovC_Visible = t.FOVCircle end
end
local lastSaveHash = nil
local function saveIfChanged()
    local s = HttpService:JSONEncode({
        ESP = CFG.ESP,
        Aim = { Enabled = CFG.Aim.Enabled, Key = CFG.Aim.Key.Name, FOV = CFG.Aim.FOV, Smooth = CFG.Aim.Smooth, Lock = CFG.Aim.Lock, Visible = CFG.Aim.Visible },
        Misc = { FriendlyTeams = CFG.Misc.FriendlyTeams },
        FOVCircle = fovC and fovC.Visible or false,
    })
    if s ~= lastSaveHash then lastSaveHash = s; pcall(function() writefile("san_aurie_settings.json", s) end) end
end
loadSettings()

-- Key state tracker (more reliable than IsKeyDown in some executors)
local KeysHeld = {}
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.UserInputType == Enum.UserInputType.Keyboard then KeysHeld[input.KeyCode] = true end
end)
UserInputService.InputEnded:Connect(function(input, gpe)
    if not gpe and input.UserInputType == Enum.UserInputType.Keyboard then KeysHeld[input.KeyCode] = false end
end)

-- G key toggles GUI visibility (using direct reference — defined later)
local sg = nil; local MainFrame = nil
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.G then
        if MainFrame then MainFrame.Visible = not MainFrame.Visible end
    end
end)

-- Team check: auto-friendly job roles + friendly teams (Police, Crew)
local autoFriendly = {"Fire", "Farmer", "Chef", "Civilian", "Delivery", "Medical", "Transit", "Prisoner"}
local function isT(p)
    if not p or not p.Team then return false end
    for _, af in ipairs(autoFriendly) do if p.Team.Name == af then return true end end
    for _, tn in ipairs(CFG.Misc.FriendlyTeams) do
        if tn == "Crew" then
            if LocalPlayer.Team and p.Team == LocalPlayer.Team then return true end
        elseif p.Team.Name == tn then return true end
    end; return false
end

-- ESP
local ESP = {}
local function mkESP(p)
    if ESP[p] then return end
    local e = {
        box = Drawing.new("Square"), name = Drawing.new("Text"),
        hbg = Drawing.new("Line"), hb = Drawing.new("Line"), tr = Drawing.new("Line"),
    }
    for _, d in pairs(e) do d.Visible = false; d.Color = Color3.new(1, 1, 1) end
    e.box.Thickness = 1.5; e.name.Size = 14; e.name.Center = true
    e.name.Outline = true; e.name.OutlineColor = Color3.new(0, 0, 0); e.tr.Thickness = 1
    ESP[p] = e
end
local function getB(ch)
    local hrp, head = ch:FindFirstChild("HumanoidRootPart"), ch:FindFirstChild("Head")
    if not hrp or not head then return nil end
    local h = (head.Position.Y - hrp.Position.Y) * 2 + 0.5
    local t, tv = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, h / 2, 0))
    local b, bv = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, h / 2, 0))
    if not tv and not bv then return nil end
    local bh = math.max(math.abs(t.Y - b.Y), 15)
    return { x = (t.X + b.X) / 2 - bh * 0.3, y = (t.Y + b.Y) / 2 - bh / 2, w = bh * 0.6, h = bh }
end
local function upESP()
    for p, e in pairs(ESP) do
        local ch = p.Character; local hum = ch and ch:FindFirstChild("Humanoid")
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart"); local head = ch and ch:FindFirstChild("Head")
        if not ch or not hum or not hrp or not head or hum.Health <= 0 then
            for _, d in pairs(e) do d.Visible = false end
            local hl = ch and ch:FindFirstChildOfClass("Highlight")
            if hl and hl.Name == "_SA_ESP" then hl:Destroy() end; continue end
        local bx = getB(ch)
        if not bx then for _, d in pairs(e) do d.Visible = false end; continue end
        local en = not isT(p)
        local c = en and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(80, 255, 80)
        if CFG.ESP.Box then e.box.Visible = true; e.box.Color = c; e.box.Size = Vector2.new(bx.w, bx.h); e.box.Position = Vector2.new(bx.x, bx.y) else e.box.Visible = false end
        if CFG.ESP.Name then e.name.Visible = true; e.name.Color = c; e.name.Text = p.Name .. " [" .. math.floor(hum.Health) .. "]"; e.name.Position = Vector2.new(bx.x + bx.w / 2, bx.y - 16) else e.name.Visible = false end
        if CFG.ESP.Health then
            local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            e.hbg.Visible = true; e.hbg.From = Vector2.new(bx.x - 8, bx.y); e.hbg.To = Vector2.new(bx.x - 8, bx.y + bx.h); e.hbg.Color = Color3.new(0.2, 0.2, 0.2); e.hbg.Thickness = 4
            e.hb.Visible = true; e.hb.From = Vector2.new(bx.x - 8, bx.y + bx.h * (1 - hp)); e.hb.To = Vector2.new(bx.x - 8, bx.y + bx.h); e.hb.Color = Color3.fromRGB(math.floor(255 * (1 - hp)), math.floor(255 * hp), 0); e.hb.Thickness = 4
        else e.hb.Visible = false; e.hbg.Visible = false end
        if CFG.ESP.Tracer then e.tr.Visible = true; e.tr.Color = c; e.tr.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y); e.tr.To = Vector2.new(bx.x + bx.w / 2, bx.y) else e.tr.Visible = false end
        if CFG.ESP.Chams then
            local hl = ch:FindFirstChildOfClass("Highlight")
            if not hl then hl = Instance.new("Highlight"); hl.Name = "_SA_ESP"; hl.FillColor = en and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(50, 255, 50); hl.FillTransparency = 0.6; hl.OutlineColor = Color3.new(1, 1, 1); hl.OutlineTransparency = 0; hl.Parent = ch; hl.Adornee = ch; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop end
        else local hl = ch:FindFirstChildOfClass("Highlight"); if hl and hl.Name == "_SA_ESP" then hl:Destroy() end end
    end
end
for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then mkESP(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then mkESP(p) end end)
Players.PlayerRemoving:Connect(function(p) local e = ESP[p]; if e then for _, d in pairs(e) do if d.Remove then d:Remove() end end; ESP[p] = nil end end)

-- Aimbot
local LockedTarget = nil
local function isVisible(p)
    local ch = p.Character; if not ch then return false end
    local head = ch:FindFirstChild("Head"); if not head then return false end
    local lpChar = LocalPlayer.Character
    local origin = Camera.CFrame.Position
    local dir = (head.Position - origin).Unit * (head.Position - origin).Magnitude
    local filter = {Camera}
    if lpChar then filter[2] = lpChar end
    local params = RaycastParams.new(); params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = filter
    local result = workspace:Raycast(origin, dir, params)
    if not result then return true end
    local hit = result.Instance; return hit and hit:IsDescendantOf(ch)
end
local function findTarget()
    local best, bd = nil, CFG.Aim.FOV; local sc = Camera.ViewportSize; local mp = Vector2.new(sc.X / 2, sc.Y / 2)
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer or isT(p) then continue end
        local ch = p.Character; if not ch then continue end; local head = ch:FindFirstChild("Head"); if not head then continue end
        if CFG.Aim.Visible and not isVisible(p) then continue end
        local pos, on = Camera:WorldToViewportPoint(head.Position); if not on then continue end
        local d = (Vector2.new(pos.X, pos.Y) - mp).Magnitude; if d < bd then bd = d; best = p end
    end
    return best
end
local function validateTarget(p)
    if not p then return false end
    local ch = p.Character; if not ch then return false end
    local head = ch:FindFirstChild("Head"); if not head then return false end
    local hum = ch:FindFirstChild("Humanoid"); if not hum or hum.Health <= 0 then return false end
    if CFG.Aim.Visible and not isVisible(p) then return false end
    local pos, on = Camera:WorldToViewportPoint(head.Position)
    return on
end
local function aimAt(p)
    if not p then return end
    local ch = p.Character; if not ch then return end; local head = ch:FindFirstChild("Head"); if not head then return end
    local ap = head.Position; local hrp = ch:FindFirstChild("HumanoidRootPart")
    if hrp then ap = ap + hrp.AssemblyLinearVelocity * ((head.Position - Camera.CFrame.Position).Magnitude / 2000) end
    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Camera.CFrame.Position + Camera.CFrame.LookVector:Lerp((ap - Camera.CFrame.Position).Unit, CFG.Aim.Smooth))
end
local function aim()
    if not CFG.Aim.Enabled then LockedTarget = nil; return end
    local holding = KeysHeld[CFG.Aim.Key]
    if not holding and not CFG.Aim.Lock then LockedTarget = nil; return end
    if LockedTarget and not validateTarget(LockedTarget) then LockedTarget = nil end
    if not LockedTarget then LockedTarget = findTarget() end
    if LockedTarget then aimAt(LockedTarget) end
end

-- Drawings
local fovC = Drawing.new("Circle")
fovC.Visible = fovC_Visible; fovC.Radius = CFG.Aim.FOV; fovC.Thickness = 1; fovC.Color = Color3.new(1, 1, 1); fovC.Filled = false; fovC.NumSides = 60

-- GUI
sg = Instance.new("ScreenGui")
sg.Name = "SAPVP"; sg.ResetOnSpawn = false; sg.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Colors
local C = {
    bg = Color3.fromRGB(18, 18, 22), title = Color3.fromRGB(18, 18, 22),
    tab = Color3.fromRGB(25, 25, 32), tabAct = Color3.fromRGB(45, 50, 70),
    btn = Color3.fromRGB(30, 30, 38), btnH = Color3.fromRGB(40, 42, 55),
    text = Color3.fromRGB(200, 200, 210), accent = Color3.fromRGB(60, 130, 255),
    green = Color3.fromRGB(70, 200, 100), red = Color3.fromRGB(240, 80, 80),
    yellow = Color3.fromRGB(240, 200, 60),
}

local function round(p, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 4); c.Parent = p
end

local function mkF(p, n, s, c)
    local f = Instance.new("Frame"); f.Name = n; f.Size = s; f.BackgroundColor3 = c or C.bg; f.BorderSizePixel = 0; f.Parent = p; return f
end

-- Toggle switch (modern style)
local function mkToggle(parent, name, label, default)
    local row = Instance.new("TextButton")
    row.Name = name; row.Size = UDim2.new(1, -10, 0, 32)
    row.BackgroundColor3 = C.btn; row.BorderSizePixel = 0; row.AutoButtonColor = false; row.Parent = parent
    round(row, 6)
    -- Label
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -56, 1, 0); lbl.Position = UDim2.fromOffset(10, 0)
    lbl.BackgroundTransparency = 1; lbl.Text = label; lbl.TextColor3 = C.text; lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamMedium; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = row
    -- Knob track
    local track = Instance.new("Frame")
    track.Name = "_tk"; track.Size = UDim2.fromOffset(36, 18); track.Position = UDim2.new(1, -46, 0.5, -9)
    track.BackgroundColor3 = default and C.green or Color3.fromRGB(60, 60, 70); track.BorderSizePixel = 0; track.Parent = row
    round(track, 9)
    -- Knob
    local knob = Instance.new("Frame")
    knob.Name = "_kn"; knob.Size = UDim2.fromOffset(14, 14); knob.Position = UDim2.fromOffset(default and 19 or 2, 2)
    knob.BackgroundColor3 = Color3.fromRGB(240, 240, 245); knob.BorderSizePixel = 0; knob.Parent = track
    round(knob, 7)

    local function setState(on)
        track.BackgroundColor3 = on and C.green or Color3.fromRGB(60, 60, 70)
        knob.Position = UDim2.fromOffset(on and 19 or 2, 2)
    end

    row.MouseButton1Click:Connect(function()
        local on = track.BackgroundColor3.g > 0.5
        setState(not on)
    end)
    return row
end

local function mkL(p, n, t, c)
    local l = Instance.new("TextLabel"); l.Name = n; l.Size = UDim2.new(1, -10, 0, 20)
    l.BackgroundTransparency = 1; l.Text = t; l.TextColor3 = c or C.text; l.TextSize = 12
    l.Font = Enum.Font.GothamBold; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = p; return l
end

-- Main window
local M = mkF(sg, "M", UDim2.fromOffset(320, 500), C.bg)
M.Position = UDim2.fromOffset(350, 15); M.Active = true; M.Draggable = true
round(M, 8); MainFrame = M

-- Title bar
local TB = mkF(M, "TB", UDim2.new(1, 0, 0, 36), C.title)
TB.BackgroundTransparency = 0; round(TB, 8)
local tc = Instance.new("Frame"); tc.Size = UDim2.new(1, 0, 0, 8); tc.Position = UDim2.new(0, 0, 1, -8); tc.BackgroundColor3 = C.title; tc.BorderSizePixel = 0; tc.Parent = TB
local tl = Instance.new("TextLabel")
tl.Size = UDim2.new(1, -36, 1, 0); tl.Position = UDim2.fromOffset(12, 0)
tl.BackgroundTransparency = 1; tl.Text = "EDITED BY PEACE"; tl.TextColor3 = C.accent
tl.TextSize = 16; tl.Font = Enum.Font.GothamBold; tl.TextXAlignment = Enum.TextXAlignment.Left; tl.Parent = TB
local cx = Instance.new("TextButton")
cx.Size = UDim2.fromOffset(28, 28); cx.Position = UDim2.new(1, -34, 0.5, -14)
cx.BackgroundColor3 = Color3.fromRGB(40, 35, 35); cx.BorderSizePixel = 0; cx.Text = "X"
cx.TextColor3 = C.red; cx.TextSize = 14; cx.Font = Enum.Font.GothamBold; cx.Parent = TB; round(cx, 6)
cx.MouseButton1Click:Connect(function() sg:Destroy() end)

-- Tab bar
local TBar = mkF(M, "TBar", UDim2.new(1, 0, 0, 34), Color3.fromRGB(22, 22, 28))
TBar.Position = UDim2.fromOffset(0, 36)

-- Tab frames
local CombatTab = mkF(M, "Combat", UDim2.new(1, 0, 1, -70), C.bg)
CombatTab.Position = UDim2.fromOffset(0, 70)
local VisualTab = mkF(M, "Visual", UDim2.new(1, 0, 1, -70), C.bg)
VisualTab.Position = UDim2.fromOffset(0, 70); VisualTab.Visible = false
local MiscTab = mkF(M, "Misc", UDim2.new(1, 0, 1, -70), C.bg)
MiscTab.Position = UDim2.fromOffset(0, 70); MiscTab.Visible = false

local function fillTab(tab, name)
    local S = Instance.new("ScrollingFrame"); S.Name = "S"; S.Size = UDim2.new(1, 0, 1, 0)
    S.BackgroundTransparency = 1; S.BorderSizePixel = 0; S.ScrollBarThickness = 3; S.CanvasSize = UDim2.fromOffset(0, 0); S.Parent = tab
    local UL = Instance.new("UIListLayout"); UL.Parent = S; UL.Padding = UDim.new(0, 4)
    local PD = Instance.new("UIPadding"); PD.PaddingLeft = UDim.new(0, 5); PD.PaddingTop = UDim.new(0, 4); PD.Parent = S
    UL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() S.CanvasSize = UDim2.fromOffset(0, UL.AbsoluteContentSize.Y + 10) end)

    if name == "Combat" then
        mkL(S, "h", "COMBAT", C.red)
        mkToggle(S, "aim", "Aimbot", false)
        mkToggle(S, "lock", "Lock Target", false)
        mkToggle(S, "vis", "Visible Check", true)
        local fh = mkL(S, "fh", "FOV: " .. CFG.Aim.FOV, C.text)
        local fb = Instance.new("TextBox")
        fb.Size = UDim2.new(1, -10, 0, 28); fb.BackgroundColor3 = C.btn; fb.BorderSizePixel = 0; fb.Text = tostring(CFG.Aim.FOV); fb.TextColor3 = C.text; fb.TextSize = 14; fb.Font = Enum.Font.GothamMedium; fb.ClearTextOnFocus = true; fb.Parent = S; round(fb, 6)
        fb.FocusLost:Connect(function(e) if e then local n = tonumber(fb.Text); if n and n > 0 and n <= 360 then CFG.Aim.FOV = n; fovC.Radius = n; fh.Text = "FOV: " .. n; saveIfChanged() end; fb.PlaceholderText = tostring(CFG.Aim.FOV); fb.Text = "" end end)
        local sh = mkL(S, "sh", "Smooth: " .. CFG.Aim.Smooth, C.text)
        local sb = Instance.new("TextBox")
        sb.Size = UDim2.new(1, -10, 0, 28); sb.BackgroundColor3 = C.btn; sb.BorderSizePixel = 0; sb.Text = tostring(CFG.Aim.Smooth); sb.TextColor3 = C.text; sb.TextSize = 14; sb.Font = Enum.Font.GothamMedium; sb.ClearTextOnFocus = true; sb.Parent = S; round(sb, 6)
        sb.FocusLost:Connect(function(e) if e then local n = tonumber(sb.Text); if n and n > 0 and n <= 1 then CFG.Aim.Smooth = n; sh.Text = "Smooth: " .. n; saveIfChanged() end; sb.PlaceholderText = tostring(CFG.Aim.Smooth); sb.Text = "" end end)
        mkToggle(S, "fov", "Show FOV Circle", false)
        mkL(S, "kh", "AIM KEY", C.text)
        local kb = Instance.new("TextButton")
        kb.Name = "keybind"; kb.Size = UDim2.new(1, -10, 0, 28); kb.BackgroundColor3 = C.btn; kb.BorderSizePixel = 0
        kb.Text = "Key: " .. CFG.Aim.Key.Name; kb.TextColor3 = C.accent; kb.TextSize = 14; kb.Font = Enum.Font.GothamBold; kb.Parent = S; round(kb, 6)
        local listening = false; local conn = nil
        kb.MouseButton1Click:Connect(function()
            if listening then return end; listening = true; kb.Text = "Press any key..."
            if conn then conn:Disconnect() end
            local timeout = task.delay(5, function()
                if listening then listening = false; kb.Text = "Key: " .. CFG.Aim.Key.Name; if conn then conn:Disconnect(); conn = nil end end
            end)
            conn = UserInputService.InputBegan:Connect(function(input, gpe)
                if gpe or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
                CFG.Aim.Key = input.KeyCode; kb.Text = "Key: " .. input.KeyCode.Name
                listening = false; conn:Disconnect(); conn = nil; task.cancel(timeout); saveIfChanged()
            end)
        end)
    elseif name == "Visual" then
        mkL(S, "h", "VISUAL", C.green)
        mkToggle(S, "box", "Box ESP", true)
        mkToggle(S, "name", "Name ESP", true)
        mkToggle(S, "health", "Health Bar", true)
        mkToggle(S, "chams", "Chams", true)
        mkToggle(S, "tracer", "Tracer Lines", false)
    elseif name == "Misc" then
        mkL(S, "h", "MISC", C.yellow)
        mkL(S, "gk", "G = Toggle GUI", Color3.fromRGB(150, 150, 160))
        mkL(S, "dh", "DISCORD", C.accent)
        local dc = Instance.new("TextButton")
        dc.Size = UDim2.new(1, -10, 0, 36); dc.BackgroundColor3 = Color3.fromRGB(55, 75, 120); dc.BorderSizePixel = 0; dc.Text = "Join Discord"; dc.TextColor3 = Color3.new(1, 1, 1); dc.TextSize = 14; dc.Font = Enum.Font.GothamBold; dc.Parent = S; round(dc, 6)
        dc.MouseButton1Click:Connect(function()
            local s = Instance.new("StringValue"); s.Name = "DiscordLink"; s.Value = "https://discord.gg/wD4ycHr8P"; s.Parent = sg
            setclipboard("https://discord.gg/wD4ycHr8P")
            dc.Text = "Copied!"
            task.wait(1.5)
            dc.Text = "Join Discord"
        end)
        mkL(S, "fh", "TEAMS", C.accent)
        local showTeams = {"Police", "Crew"}
        local tl2 = mkL(S, "tl", "No teams found", C.text)
        local teamToggles = {}
        local function refreshTeams()
            for _, v in pairs(teamToggles) do if v and v.Parent then v:Destroy() end end; teamToggles = {}
            local all = Teams:GetTeams(); local found = 0
            for _, st in ipairs(showTeams) do
                if st == "Crew" then
                    local def = false; for _, ft in ipairs(CFG.Misc.FriendlyTeams) do if ft == "Crew" then def = true; break end end
                    local t = mkToggle(S, "t_Crew", "Team: Crew", def); teamToggles["Crew"] = t; found = found + 1
                else
                    for _, team in ipairs(all) do
                        if team.Name ~= st then continue end; found = found + 1
                        local def = false; for _, ft in ipairs(CFG.Misc.FriendlyTeams) do if ft == st then def = true; break end end
                        local t = mkToggle(S, "t_" .. st, "Team: " .. st, def); teamToggles[st] = t
                    end
                end
            end
            tl2.Visible = found == 0
        end
        refreshTeams()
        Teams.ChildAdded:Connect(function() task.wait(0.5); refreshTeams() end)
        Teams.ChildRemoved:Connect(function() task.wait(0.5); refreshTeams() end)
    end
    task.wait(); S.CanvasSize = UDim2.fromOffset(0, UL.AbsoluteContentSize.Y + 10)
end

fillTab(CombatTab, "Combat"); fillTab(VisualTab, "Visual"); fillTab(MiscTab, "Misc")

-- Sync all toggle states to match loaded CFG settings
local function setToggleState(btn, on)
    local tk = btn:FindFirstChild("_tk"); if not tk then return end
    tk.BackgroundColor3 = on and C.green or Color3.fromRGB(60, 60, 70)
    local kn = tk:FindFirstChild("_kn"); if kn then kn.Position = UDim2.fromOffset(on and 19 or 2, 2) end
end
local function syncToggles()
    for _, tab in pairs({CombatTab, VisualTab, MiscTab}) do
        local sc = tab:FindFirstChild("S"); if not sc then continue end
        for _, v in ipairs(sc:GetChildren()) do
            if not v:IsA("TextButton") or not v:FindFirstChild("_tk") then continue end
            local val = (
                v.Name == "box" and CFG.ESP.Box or v.Name == "name" and CFG.ESP.Name or
                v.Name == "health" and CFG.ESP.Health or v.Name == "chams" and CFG.ESP.Chams or
                v.Name == "tracer" and CFG.ESP.Tracer or v.Name == "aim" and CFG.Aim.Enabled or
                v.Name == "lock" and CFG.Aim.Lock or v.Name == "vis" and CFG.Aim.Visible or
                v.Name == "fov" and fovC.Visible or nil
            )
            if val ~= nil then setToggleState(v, val) end
        end
    end
end
syncToggles()

-- Tab buttons
local tabBtns = {}
for i, name in ipairs({"Combat", "Visual", "Misc"}) do
    local tb = Instance.new("TextButton")
    tb.Name = name; tb.Size = UDim2.new(1 / 3, -3, 1, -6); tb.Position = UDim2.new((i - 1) / 3, 2, 0, 3)
    tb.BackgroundColor3 = C.tab; tb.BorderSizePixel = 0; tb.Text = name; tb.TextColor3 = C.text; tb.TextSize = 13; tb.Font = Enum.Font.GothamBold; tb.Parent = TBar; round(tb, 6)
    tabBtns[name] = tb
    tb.MouseButton1Click:Connect(function()
        for _, btn in pairs(tabBtns) do btn.BackgroundColor3 = C.tab; btn.TextColor3 = C.text end
        tb.BackgroundColor3 = C.tabAct; tb.TextColor3 = Color3.new(1, 1, 1)
        CombatTab.Visible = name == "Combat"; VisualTab.Visible = name == "Visual"; MiscTab.Visible = name == "Misc"
    end)
end
tabBtns["Combat"].BackgroundColor3 = C.tabAct; tabBtns["Combat"].TextColor3 = Color3.new(1, 1, 1)

-- Read toggle state from the switch track color (green = ON, gray = OFF)
local function isToggleOn(btn)
    local tk = btn:FindFirstChild("_tk")
    return tk and tk.BackgroundColor3.r < 0.5 and tk.BackgroundColor3.g > 0.5
end

-- Main loop
RunService.RenderStepped:Connect(function()
    for _, tab in pairs({CombatTab, VisualTab, MiscTab}) do
        local sc = tab:FindFirstChild("S")
        if not sc then continue end
        for _, v in ipairs(sc:GetChildren()) do
            if not v:IsA("TextButton") then continue end
            if not v:FindFirstChild("_tk") then continue end
            local on = isToggleOn(v)
            if v.Name == "box" then CFG.ESP.Box = on
            elseif v.Name == "name" then CFG.ESP.Name = on
            elseif v.Name == "health" then CFG.ESP.Health = on
            elseif v.Name == "chams" then CFG.ESP.Chams = on
            elseif v.Name == "tracer" then CFG.ESP.Tracer = on
            elseif v.Name == "aim" then CFG.Aim.Enabled = on
            elseif v.Name == "lock" then CFG.Aim.Lock = on
            elseif v.Name == "vis" then CFG.Aim.Visible = on
            elseif v.Name == "fov" then fovC.Visible = on
            elseif string.sub(v.Name, 1, 2) == "t_" then
                local tn = string.sub(v.Name, 3)
                if on then
                    local found = false; for _, ft in ipairs(CFG.Misc.FriendlyTeams) do if ft == tn then found = true; break end end
                    if not found then table.insert(CFG.Misc.FriendlyTeams, tn) end
                else
                    for i = #CFG.Misc.FriendlyTeams, 1, -1 do if CFG.Misc.FriendlyTeams[i] == tn then table.remove(CFG.Misc.FriendlyTeams, i); break end end
                end
            end
        end
    end
    local sc = Camera.ViewportSize
    fovC.Position = Vector2.new(sc.X / 2, sc.Y / 2)
    upESP(); aim(); saveIfChanged()
end)

print("[EDITED BY PEACE] Loaded")
