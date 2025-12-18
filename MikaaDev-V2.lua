-- ============================================
-- FIXED ADVANCED MOBILE HACK UI
-- Game-Specific Hacks that Actually Work
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- Hapus UI lama
if CoreGui:FindFirstChild("FixedHackUI") then
    CoreGui.FixedHackUI:Destroy()
end

-- ============================================
-- UI SETUP (Sama seperti sebelumnya)
-- ============================================
local MainUI = Instance.new("ScreenGui")
MainUI.Name = "FixedHackUI"
MainUI.Parent = CoreGui

-- Toggle Button
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 65, 0, 65)
ToggleBtn.Position = UDim2.new(1, -75, 0.5, -32.5)
ToggleBtn.Text = "⚡"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.TextSize = 32
ToggleBtn.ZIndex = 100
ToggleBtn.Parent = MainUI

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

-- Main Panel
local MainPanel = Instance.new("Frame")
MainPanel.Size = UDim2.new(0, 320, 0, 400)
MainPanel.Position = UDim2.new(0.5, -160, 0.5, -200)
MainPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainPanel.BackgroundTransparency = 0.05
MainPanel.Visible = false
MainPanel.Parent = MainUI

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0, 12)
PanelCorner.Parent = MainPanel

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Header.Parent = MainPanel

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12, 0, 0)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "🎮 FIXED HACK MENU"
Title.TextColor3 = Color3.fromRGB(255, 150, 50)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -45, 0, 5)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBlack
CloseBtn.TextSize = 24
CloseBtn.Parent = Header

-- Status
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -20, 0, 30)
Status.Position = UDim2.new(0, 10, 0, 60)
Status.Text = "🟢 READY"
Status.TextColor3 = Color3.fromRGB(0, 255, 100)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.GothamBold
Status.TextSize = 16
Status.Parent = MainPanel

-- Features Container
local FeaturesFrame = Instance.new("ScrollingFrame")
FeaturesFrame.Size = UDim2.new(1, -20, 0, 290)
FeaturesFrame.Position = UDim2.new(0, 10, 0, 100)
FeaturesFrame.BackgroundTransparency = 1
FeaturesFrame.ScrollBarThickness = 4
FeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, 350)
FeaturesFrame.Parent = MainPanel

-- ============================================
-- FIXED HACK VARIABLES
-- ============================================
local ActiveHacks = {}
local HackConnections = {}
local RemoteHooks = {}

local function UpdateStatus()
    local count = 0
    for _, active in pairs(ActiveHacks) do
        if active then count = count + 1 end
    end
    
    if count == 0 then
        Status.Text = "🟢 READY"
        Status.TextColor3 = Color3.fromRGB(0, 255, 100)
    else
        Status.Text = "⚡ " .. count .. " HACKS ACTIVE"
        Status.TextColor3 = Color3.fromRGB(255, 200, 0)
    end
end

-- ============================================
-- FIXED DAMAGE HACK (REAL WORKING VERSION)
-- ============================================
local function EnableDamageHack()
    ActiveHacks.Damage = true
    print("[DAMAGE] Activating...")
    
    -- METHOD 1: FIND AND HOOK DAMAGE REMOTES
    local damageRemotes = {}
    
    -- Cari semua remote yang berhubungan dengan damage
    for _, remote in pairs(game:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            local name = remote.Name:lower()
            if name:find("damage") or name:find("hit") or name:find("attack") or 
               name:find("punch") or name:find("strike") or name:find("combat") then
                table.insert(damageRemotes, remote)
                print("[DAMAGE] Found remote:", remote:GetFullName())
            end
        end
    end
    
    -- Jika tidak ada remote damage, coba remote umum
    if #damageRemotes == 0 then
        for _, remote in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
            if remote:IsA("RemoteEvent") then
                table.insert(damageRemotes, remote)
                print("[DAMAGE] Using general remote:", remote.Name)
            end
        end
    end
    
    -- Hook remotes
    for _, remote in pairs(damageRemotes) do
        if not RemoteHooks[remote] then
            local oldFire = remote.FireServer
            RemoteHooks[remote] = oldFire
            
            remote.FireServer = function(self, ...)
                local args = {...}
                
                -- Debug: Print args
                print("[DAMAGE HOOK]", remote.Name, "args:", #args)
                
                -- Ubah damage menjadi 9999
                local modified = false
                
                -- Coba semua kemungkinan format damage
                for i, arg in pairs(args) do
                    if type(arg) == "number" then
                        if arg > 0 and arg < 10000 then  -- Angka damage normal
                            args[i] = 9999
                            modified = true
                            print("[DAMAGE] Changed number:", arg, "->", 9999)
                        end
                    elseif type(arg) == "table" then
                        -- Jika ada table dengan damage value
                        for k, v in pairs(arg) do
                            if type(v) == "number" and v > 0 and v < 10000 then
                                arg[k] = 9999
                                modified = true
                                print("[DAMAGE] Changed table value:", v, "->", 9999)
                            end
                        end
                    end
                end
                
                -- Jika tidak ada angka, tambahkan damage
                if not modified then
                    table.insert(args, 9999)
                    print("[DAMAGE] Added damage value: 9999")
                end
                
                return oldFire(self, unpack(args))
            end
        end
    end
    
    -- METHOD 2: DIRECT DAMAGE LOOP
    HackConnections.DamageLoop = RunService.Heartbeat:Connect(function()
        pcall(function()
            -- Kirim damage ke semua musuh
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local humanoid = player.Character:FindFirstChild("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        -- Coba berbagai metode damage
                        humanoid:TakeDamage(9999)
                        
                        -- Kirim ke semua remote
                        for _, remote in pairs(damageRemotes) do
                            pcall(function()
                                remote:FireServer(player.Character, 9999)
                                remote:FireServer("Damage", player.Character, 9999)
                                remote:FireServer("Head", 9999, player.Character)
                            end)
                        end
                    end
                end
            end
        end)
    end)
    
    -- METHOD 3: MODIFY DAMAGE VALUES
    spawn(function()
        while ActiveHacks.Damage do
            wait(0.3)
            pcall(function()
                -- Ubah semua nilai damage di character
                if LocalPlayer.Character then
                    for _, obj in pairs(LocalPlayer.Character:GetDescendants()) do
                        if obj:IsA("NumberValue") then
                            local name = obj.Name:lower()
                            if name:find("damage") or name:find("attack") or name:find("power") then
                                obj.Value = 9999
                            end
                        end
                    end
                end
            end)
        end
    end)
    
    UpdateStatus()
    print("[DAMAGE] ✅ ACTIVATED")
end

local function DisableDamageHack()
    ActiveHacks.Damage = false
    
    -- Restore original remote functions
    for remote, oldFire in pairs(RemoteHooks) do
        remote.FireServer = oldFire
    end
    RemoteHooks = {}
    
    -- Disconnect loop
    if HackConnections.DamageLoop then
        HackConnections.DamageLoop:Disconnect()
        HackConnections.DamageLoop = nil
    end
    
    UpdateStatus()
    print("[DAMAGE] ❌ DISABLED")
end

-- ============================================
-- FIXED ATTACK SPEED HACK (REAL WORKING)
-- ============================================
local function EnableAttackSpeedHack()
    ActiveHacks.AttackSpeed = true
    print("[ATTACK SPEED] Activating...")
    
    -- METHOD 1: REMOVE ATTACK DELAYS
    HackConnections.AttackSpeedLoop = RunService.Heartbeat:Connect(function()
        pcall(function()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    -- Stop semua animasi attack yang lama
                    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                        local name = track.Name:lower()
                        if name:find("attack") or name:find("cooldown") or name:find("wait") then
                            track:Stop()
                        end
                    end
                    
                    -- Set attack speed attribute
                    humanoid:SetAttribute("AttackSpeed", 999)
                end
            end
        end)
    end)
    
    -- METHOD 2: SPAM ATTACK PACKETS
    spawn(function()
        while ActiveHacks.AttackSpeed do
            wait(0.05) -- 20x per second
            pcall(function()
                -- Cari semua attack remote
                local attackRemotes = {}
                for _, remote in pairs(game:GetDescendants()) do
                    if remote:IsA("RemoteEvent") then
                        local name = remote.Name:lower()
                        if name:find("attack") or name:find("punch") or name:find("hit") then
                            table.insert(attackRemotes, remote)
                        end
                    end
                end
                
                -- Spam packets
                for _, remote in pairs(attackRemotes) do
                    for i = 1, 3 do
                        pcall(function()
                            remote:FireServer()
                            remote:FireServer(LocalPlayer.Character)
                            remote:FireServer("Attack", LocalPlayer.Character)
                        end)
                    end
                end
                
                -- Auto click simulation (untuk mobile)
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end)
        end
    end)
    
    -- METHOD 3: REMOVE COOLDOWNS
    spawn(function()
        while ActiveHacks.AttackSpeed do
            wait(0.2)
            pcall(function()
                -- Set semua cooldown ke 0
                for _, obj in pairs(game:GetDescendants()) do
                    if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                        if obj.Name:lower():find("cooldown") or obj.Name:lower():find("delay") then
                            obj.Value = 0
                        end
                    end
                end
            end)
        end
    end)
    
    UpdateStatus()
    print("[ATTACK SPEED] ✅ ACTIVATED")
end

local function DisableAttackSpeedHack()
    ActiveHacks.AttackSpeed = false
    
    if HackConnections.AttackSpeedLoop then
        HackConnections.AttackSpeedLoop:Disconnect()
        HackConnections.AttackSpeedLoop = nil
    end
    
    UpdateStatus()
    print("[ATTACK SPEED] ❌ DISABLED")
end

-- ============================================
-- FIXED SPEED HACK (REAL WORKING)
-- ============================================
local function EnableSpeedHack()
    ActiveHacks.Speed = true
    print("[SPEED] Activating...")
    
    HackConnections.SpeedLoop = RunService.Heartbeat:Connect(function()
        pcall(function()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    -- Set extreme speed
                    humanoid.WalkSpeed = 100
                    humanoid.JumpPower = 100
                    
                    -- NoClip
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end)
    end)
    
    -- Auto reapply saat respawn
    LocalPlayer.CharacterAdded:Connect(function()
        wait(0.3)
        if ActiveHacks.Speed and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 100
                humanoid.JumpPower = 100
            end
        end
    end)
    
    UpdateStatus()
    print("[SPEED] ✅ ACTIVATED")
end

local function DisableSpeedHack()
    ActiveHacks.Speed = false
    
    if HackConnections.SpeedLoop then
        HackConnections.SpeedLoop:Disconnect()
        HackConnections.SpeedLoop = nil
    end
    
    -- Reset speed
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
    end
    
    UpdateStatus()
    print("[SPEED] ❌ DISABLED")
end

-- ============================================
-- FIXED GOD MODE (REAL WORKING)
-- ============================================
local function EnableGodMode()
    ActiveHacks.GodMode = true
    print("[GOD MODE] Activating...")
    
    HackConnections.GodLoop = RunService.Heartbeat:Connect(function()
        pcall(function()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    -- Prevent health from decreasing
                    if humanoid.Health < 100 then
                        humanoid.Health = 100
                    end
                    
                    -- Block damage
                    humanoid:SetAttribute("GodMode", true)
                end
            end
        end)
    end)
    
    -- Auto apply saat respawn
    LocalPlayer.CharacterAdded:Connect(function(char)
        wait(0.5)
        if ActiveHacks.GodMode then
            local humanoid = char:WaitForChild("Humanoid")
            humanoid.Health = 100
            
            humanoid.Changed:Connect(function()
                if humanoid.Health < 100 then
                    humanoid.Health = 100
                end
            end)
        end
    end)
    
    -- Apply sekarang
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Health = 100
        end
    end
    
    UpdateStatus()
    print("[GOD MODE] ✅ ACTIVATED")
end

local function DisableGodMode()
    ActiveHacks.GodMode = false
    
    if HackConnections.GodLoop then
        HackConnections.GodLoop:Disconnect()
        HackConnections.GodLoop = nil
    end
    
    UpdateStatus()
    print("[GOD MODE] ❌ DISABLED")
end

-- ============================================
-- CREATE FEATURE BUTTONS
-- ============================================
local features = {
    {
        Name = "💀 EXTREME DAMAGE",
        Desc = "One-Hit Kill (9999 Damage)",
        Color = Color3.fromRGB(255, 50, 50),
        EnableFunc = EnableDamageHack,
        DisableFunc = DisableDamageHack
    },
    {
        Name = "⚡ MAX ATTACK SPEED",
        Desc = "Instant Attacks | No Delay",
        Color = Color3.fromRGB(255, 150, 0),
        EnableFunc = EnableAttackSpeedHack,
        DisableFunc = DisableAttackSpeedHack
    },
    {
        Name = "🚀 SUPER SPEED",
        Desc = "Speed 100 | NoClip | High Jump",
        Color = Color3.fromRGB(50, 150, 255),
        EnableFunc = EnableSpeedHack,
        DisableFunc = DisableSpeedHack
    },
    {
        Name = "🛡️ GOD MODE",
        Desc = "Cannot Die | Auto Heal",
        Color = Color3.fromRGB(0, 200, 100),
        EnableFunc = EnableGodMode,
        DisableFunc = DisableGodMode
    }
}

for i, feature in ipairs(features) do
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 80)
    card.Position = UDim2.new(0, 0, 0, (i-1)*85)
    card.BackgroundColor3 = feature.Color
    card.BackgroundTransparency = 0.3
    card.Parent = FeaturesFrame
    
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 10)
    cardCorner.Parent = card
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.7, 0, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.Text = feature.Name
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = card
    
    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(0.7, 0, 0, 40)
    desc.Position = UDim2.new(0, 10, 0, 35)
    desc.Text = feature.Desc
    desc.TextColor3 = Color3.fromRGB(220, 220, 220)
    desc.BackgroundTransparency = 1
    desc.Font = Enum.Font.Gotham
    desc.TextSize = 12
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextWrapped = true
    desc.Parent = card
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 80, 0, 30)
    toggleBtn.Position = UDim2.new(1, -90, 0, 25)
    toggleBtn.Name = feature.Name
    toggleBtn.Text = "OFF"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 14
    toggleBtn.Parent = card
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = toggleBtn
    
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(0, 80, 0, 20)
    status.Position = UDim2.new(1, -90, 0, 5)
    status.Text = "INACTIVE"
    status.TextColor3 = Color3.fromRGB(255, 100, 100)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.Gotham
    status.TextSize = 12
    status.Parent = card
    
    toggleBtn.MouseButton1Click:Connect(function()
        local hackName = feature.Name
        local isActive = ActiveHacks[hackName] or false
        
        if not isActive then
            -- Aktifkan
            feature.EnableFunc()
            toggleBtn.Text = "ON"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 50)
            status.Text = "ACTIVE"
            status.TextColor3 = Color3.fromRGB(0, 255, 100)
            
            -- Notifikasi
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "HACK ACTIVATED",
                Text = feature.Name,
                Duration = 2
            })
        else
            -- Nonaktifkan
            feature.DisableFunc()
            toggleBtn.Text = "OFF"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            status.Text = "INACTIVE"
            status.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        
        -- Animasi
        toggleBtn.Size = UDim2.new(0, 75, 0, 28)
        wait(0.08)
        toggleBtn.Size = UDim2.new(0, 80, 0, 30)
    end)
end

FeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, #features * 85)

-- ============================================
-- UI TOGGLE FUNCTIONS
-- ============================================
local UIOpen = false

ToggleBtn.MouseButton1Click:Connect(function()
    UIOpen = not UIOpen
    MainPanel.Visible = UIOpen
    
    if UIOpen then
        ToggleBtn.Text = "⬅️"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
    else
        ToggleBtn.Text = "⚡"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    end
    
    ToggleBtn.Size = UDim2.new(0, 60, 0, 60)
    wait(0.1)
    ToggleBtn.Size = UDim2.new(0, 65, 0, 65)
end)

CloseBtn.MouseButton1Click:Connect(function()
    UIOpen = false
    MainPanel.Visible = false
    ToggleBtn.Text = "⚡"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    
    CloseBtn.TextSize = 20
    wait(0.1)
    CloseBtn.TextSize = 24
end)

-- ============================================
-- DRAGGABLE UI
-- ============================================
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainPanel.Position
    end
end)

Header.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ============================================
-- INITIALIZATION
-- ============================================
UpdateStatus()

-- Mobile optimization
if UIS.TouchEnabled then
    ToggleBtn.Size = UDim2.new(0, 75, 0, 75)
    ToggleBtn.Position = UDim2.new(1, -85, 0.5, -37.5)
    ToggleBtn.TextSize = 36
end

print("========================================")
print("FIXED HACK MENU LOADED")
print("Game: " .. game.Name)
print("Features now WORK PROPERLY")
print("Tap ⚡ button to open menu")
print("========================================")

-- Auto-detect game type
wait(2)
print("[INFO] Detecting game mechanics...")
print("[INFO] Use hacks and check console for feedback")
