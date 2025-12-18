-- ============================================
-- EXTREME SERVER BYPASS MOBILE HACK
-- Direct Game Manipulation - Android Optimized
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- Hapus UI lama
if CoreGui:FindFirstChild("ExtremeHack") then
    CoreGui.ExtremeHack:Destroy()
end

-- ============================================
-- MINIMALIST TOGGLE UI
-- ============================================
local MainUI = Instance.new("ScreenGui")
MainUI.Name = "ExtremeHack"
MainUI.Parent = CoreGui

-- Toggle Button (Logo Kecil)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 65, 0, 65)
ToggleBtn.Position = UDim2.new(1, -75, 0.5, -32.5)
ToggleBtn.Text = "⚔️"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ToggleBtn.BackgroundTransparency = 0.2
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.TextSize = 32
ToggleBtn.ZIndex = 100
ToggleBtn.Parent = MainUI

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

-- Main Panel (Hidden Initially)
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
Title.Text = "💀 EXTREME HACK"
Title.TextColor3 = Color3.fromRGB(255, 100, 100)
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
-- HACK VARIABLES
-- ============================================
local ActiveHacks = {}
local HackConnections = {}

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
-- EXTREME DAMAGE HACK (DIRECT SERVER ATTACK)
-- ============================================
local function EnableDamageHack()
    ActiveHacks.Damage = true
    
    -- METHOD 1: REMOTE EVENT HIJACKING
    for _, remote in pairs(game:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            local name = remote.Name:lower()
            if name:find("damage") or name:find("hit") or name:find("attack") or name:find("punch") then
                local old = remote.FireServer
                
                remote.FireServer = function(self, ...)
                    local args = {...}
                    
                    -- Ubah semua angka menjadi 999999
                    for i, arg in pairs(args) do
                        if type(arg) == "number" and arg > 0 then
                            args[i] = 999999
                        elseif type(arg) == "table" then
                            -- Jika ada table dengan damage value
                            for k, v in pairs(arg) do
                                if type(v) == "number" and v > 0 then
                                    arg[k] = 999999
                                end
                            end
                        end
                    end
                    
                    -- Tambahkan damage argument jika tidak ada
                    if #args == 0 then
                        table.insert(args, 999999)
                    end
                    
                    return old(self, unpack(args))
                end
            end
        end
    end
    
    -- METHOD 2: DIRECT PLAYER DAMAGE
    HackConnections.DamageLoop = RunService.Heartbeat:Connect(function()
        pcall(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local humanoid = player.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        -- Force damage langsung
                        humanoid:TakeDamage(999999)
                        
                        -- Kirim damage packet ke semua remote
                        for _, remote in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                            if remote:IsA("RemoteEvent") then
                                pcall(function()
                                    remote:FireServer(player.Character, 999999)
                                    remote:FireServer("Damage", player.Character, 999999)
                                    remote:FireServer("Head", 999999, player.Character)
                                end)
                            end
                        end
                    end
                end
            end
        end)
    end)
    
    -- METHOD 3: MEMORY OVERWRITE
    spawn(function()
        while ActiveHacks.Damage do
            wait(0.5)
            pcall(function()
                -- Overwrite semua nilai damage di game
                for _, obj in pairs(game:GetDescendants()) do
                    if obj:IsA("NumberValue") then
                        local name = obj.Name:lower()
                        if name:find("damage") or name:find("attack") or name:find("power") or name:find("strength") then
                            obj.Value = 999999
                        end
                    end
                end
                
                -- Ubah script damage
                for _, script in pairs(game:GetDescendants()) do
                    if script:IsA("Script") and script.Name:lower():find("damage") then
                        pcall(function()
                            script.Source = "return 999999"
                        end)
                    end
                end
            end)
        end
    end)
    
    UpdateStatus()
end

local function DisableDamageHack()
    ActiveHacks.Damage = false
    if HackConnections.DamageLoop then
        HackConnections.DamageLoop:Disconnect()
        HackConnections.DamageLoop = nil
    end
    UpdateStatus()
end

-- ============================================
-- EXTREME ATTACK SPEED HACK (INSTANT ATTACKS)
-- ============================================
local function EnableAttackSpeedHack()
    ActiveHacks.AttackSpeed = true
    
    -- METHOD 1: REMOVE ANIMATION DELAYS
    HackConnections.AttackSpeedLoop = RunService.Heartbeat:Connect(function()
        pcall(function()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    -- Hapus semua cooldown animation tracks
                    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                        if track.Name:lower():find("attack") or track.Name:lower():find("cooldown") then
                            track:Stop()
                        end
                    end
                    
                    -- Set animasi speed maksimal
                    humanoid:SetAttribute("AttackSpeed", 999)
                end
            end
        end)
    end)
    
    -- METHOD 2: SPAM ATTACK PACKETS
    spawn(function()
        while ActiveHacks.AttackSpeed do
            wait(0.01) -- 100x per second
            pcall(function()
                -- Temukan semua attack remote
                local attackRemotes = {}
                for _, remote in pairs(game:GetDescendants()) do
                    if remote:IsA("RemoteEvent") then
                        local name = remote.Name:lower()
                        if name:find("attack") or name:find("punch") or name:find("hit") or name:find("strike") then
                            table.insert(attackRemotes, remote)
                        end
                    end
                end
                
                -- Spam ke semua remote
                for _, remote in pairs(attackRemotes) do
                    for i = 1, 5 do
                        pcall(function()
                            remote:FireServer()
                            remote:FireServer(LocalPlayer.Character)
                            remote:FireServer("Attack")
                        end)
                    end
                end
                
                -- Force input attack
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end)
        end
    end)
    
    -- METHOD 3: MODIFY COOLDOWNS
    spawn(function()
        while ActiveHacks.AttackSpeed do
            wait(0.1)
            pcall(function()
                -- Set semua cooldown ke 0
                for _, obj in pairs(game:GetDescendants()) do
                    if obj:IsA("NumberValue") then
                        if obj.Name:lower():find("cooldown") or obj.Name:lower():find("delay") or obj.Name:lower():find("timer") then
                            obj.Value = 0
                        end
                    end
                end
            end)
        end
    end)
    
    UpdateStatus()
end

local function DisableAttackSpeedHack()
    ActiveHacks.AttackSpeed = false
    if HackConnections.AttackSpeedLoop then
        HackConnections.AttackSpeedLoop:Disconnect()
        HackConnections.AttackSpeedLoop = nil
    end
    UpdateStatus()
end

-- ============================================
-- SPEED HACK (INSTANT MOVEMENT)
-- ============================================
local function EnableSpeedHack()
    ActiveHacks.Speed = true
    
    HackConnections.SpeedLoop = RunService.Heartbeat:Connect(function()
        pcall(function()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    -- Set extreme speed
                    humanoid.WalkSpeed = 999
                    humanoid.JumpPower = 150
                    
                    -- NoClip
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                    
                    -- Anti-stun
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Stunned, false)
                end
            end
        end)
    end)
    
    UpdateStatus()
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
end

-- ============================================
-- GOD MODE (INVINCIBLE)
-- ============================================
local function EnableGodMode()
    ActiveHacks.GodMode = true
    
    HackConnections.GodLoop = RunService.Heartbeat:Connect(function()
        pcall(function()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    -- Infinite health
                    humanoid.MaxHealth = math.huge
                    humanoid.Health = math.huge
                    
                    -- Block damage events
                    humanoid:SetAttribute("GodMode", true)
                end
            end
        end)
    end)
    
    -- Hook damage taken
    LocalPlayer.CharacterAdded:Connect(function(char)
        wait(0.5)
        local humanoid = char:WaitForChild("Humanoid")
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    end)
    
    UpdateStatus()
end

local function DisableGodMode()
    ActiveHacks.GodMode = false
    if HackConnections.GodLoop then
        HackConnections.GodLoop:Disconnect()
        HackConnections.GodLoop = nil
    end
    
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
    end
    
    UpdateStatus()
end

-- ============================================
-- CREATE FEATURE BUTTONS
-- ============================================
local features = {
    {
        Name = "💀 EXTREME DAMAGE",
        Desc = "999999 Damage | One-Hit Kill",
        Color = Color3.fromRGB(255, 50, 50),
        EnableFunc = EnableDamageHack,
        DisableFunc = DisableDamageHack
    },
    {
        Name = "⚡ MAX ATTACK SPEED",
        Desc = "Instant Attacks | No Cooldowns",
        Color = Color3.fromRGB(255, 150, 0),
        EnableFunc = EnableAttackSpeedHack,
        DisableFunc = DisableAttackSpeedHack
    },
    {
        Name = "🚀 SPEED 999 + NOCLIP",
        Desc = "Super Speed | NoClip | Anti-Stun",
        Color = Color3.fromRGB(50, 150, 255),
        EnableFunc = EnableSpeedHack,
        DisableFunc = DisableSpeedHack
    },
    {
        Name = "🛡️ GOD MODE",
        Desc = "Invincible | Infinite Health",
        Color = Color3.fromRGB(0, 200, 100),
        EnableFunc = EnableGodMode,
        DisableFunc = DisableGodMode
    }
}

local buttonInstances = {}

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
            -- Aktifkan hack
            feature.EnableFunc()
            toggleBtn.Text = "ON"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 50)
            status.Text = "ACTIVE"
            status.TextColor3 = Color3.fromRGB(0, 255, 100)
            
            -- Feedback
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "HACK ACTIVATED",
                Text = hackName,
                Duration = 2
            })
        else
            -- Nonaktifkan hack
            feature.DisableFunc()
            toggleBtn.Text = "OFF"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            status.Text = "INACTIVE"
            status.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        
        -- Animasi tombol
        toggleBtn.Size = UDim2.new(0, 75, 0, 28)
        wait(0.08)
        toggleBtn.Size = UDim2.new(0, 80, 0, 30)
    end)
    
    buttonInstances[feature.Name] = {Button = toggleBtn, Status = status}
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
        ToggleBtn.Text = "⚔️"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    end
    
    -- Animasi tombol
    ToggleBtn.Size = UDim2.new(0, 60, 0, 60)
    wait(0.1)
    ToggleBtn.Size = UDim2.new(0, 65, 0, 65)
end)

CloseBtn.MouseButton1Click:Connect(function()
    UIOpen = false
    MainPanel.Visible = false
    ToggleBtn.Text = "⚔️"
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
print("EXTREME SERVER BYPASS HACK LOADED")
print("Game: " .. game.Name)
print("Place ID: " .. game.PlaceId)
print("Features: Extreme Damage, Max Attack Speed, Speed 999, God Mode")
print("Tap ⚔️ button to open menu")
print("========================================")
