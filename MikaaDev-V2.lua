-- ============================================
-- MOBILE DAMAGE HACK + SPEED 999 (ANDROID)
-- Delta Executor Compatible
-- ============================================

-- UI Setup untuk Android (touch-friendly)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Hapus UI lama jika ada
if CoreGui:FindFirstChild("MobileHackUI") then
    CoreGui.MobileHackUI:Destroy()
end

-- Buat UI Mobile
local MobileUI = Instance.new("ScreenGui")
MobileUI.Name = "MobileHackUI"
MobileUI.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 380) -- Lebih besar untuk mobile
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MobileUI

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "📱 MOBILE HACK v2.0"
Title.TextColor3 = Color3.fromRGB(255, 100, 100)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = MainFrame

-- Status
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 0, 45)
StatusLabel.Text = "🔴 OFFLINE"
StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 18
StatusLabel.Parent = MainFrame

-- Damage Section
local DamageFrame = Instance.new("Frame")
DamageFrame.Size = UDim2.new(0.9, 0, 0, 80)
DamageFrame.Position = UDim2.new(0.05, 0, 0, 85)
DamageFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
DamageFrame.BorderSizePixel = 0
DamageFrame.Parent = MainFrame

local DamageCorner = Instance.new("UICorner")
DamageCorner.CornerRadius = UDim.new(0, 8)
DamageCorner.Parent = DamageFrame

local DamageTitle = Instance.new("TextLabel")
DamageTitle.Size = UDim2.new(1, 0, 0, 25)
DamageTitle.Position = UDim2.new(0, 0, 0, 0)
DamageTitle.Text = "💥 DAMAGE CONTROL"
DamageTitle.TextColor3 = Color3.fromRGB(255, 150, 50)
DamageTitle.BackgroundTransparency = 1
DamageTitle.Font = Enum.Font.GothamBold
DamageTitle.TextSize = 16
DamageTitle.Parent = DamageFrame

local MultiplierLabel = Instance.new("TextLabel")
MultiplierLabel.Size = UDim2.new(1, 0, 0, 30)
MultiplierLabel.Position = UDim2.new(0, 0, 0, 25)
MultiplierLabel.Text = "MULTIPLIER: 100x"
MultiplierLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
MultiplierLabel.BackgroundTransparency = 1
MultiplierLabel.Font = Enum.Font.GothamBold
MultiplierLabel.TextSize = 22
MultiplierLabel.Parent = DamageFrame

local DamageButton = Instance.new("TextButton")
DamageButton.Size = UDim2.new(0.9, 0, 0, 25)
DamageButton.Position = UDim2.new(0.05, 0, 0, 55)
DamageButton.Text = "🔥 ACTIVATE DAMAGE 999x"
DamageButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
DamageButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DamageButton.Font = Enum.Font.GothamBold
DamageButton.TextSize = 14
DamageButton.Parent = DamageFrame

-- Speed Section
local SpeedFrame = Instance.new("Frame")
SpeedFrame.Size = UDim2.new(0.9, 0, 0, 80)
SpeedFrame.Position = UDim2.new(0.05, 0, 0, 175)
SpeedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SpeedFrame.BorderSizePixel = 0
SpeedFrame.Parent = MainFrame

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 8)
SpeedCorner.Parent = SpeedFrame

local SpeedTitle = Instance.new("TextLabel")
SpeedTitle.Size = UDim2.new(1, 0, 0, 25)
SpeedTitle.Position = UDim2.new(0, 0, 0, 0)
SpeedTitle.Text = "⚡ SPEED CONTROL"
SpeedTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
SpeedTitle.BackgroundTransparency = 1
SpeedTitle.Font = Enum.Font.GothamBold
SpeedTitle.TextSize = 16
SpeedTitle.Parent = SpeedFrame

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, 0, 0, 30)
SpeedLabel.Position = UDim2.new(0, 0, 0, 25)
SpeedLabel.Text = "SPEED: 16 (Normal)"
SpeedLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextSize = 22
SpeedLabel.Parent = SpeedFrame

local SpeedButton = Instance.new("TextButton")
SpeedButton.Size = UDim2.new(0.9, 0, 0, 25)
SpeedButton.Position = UDim2.new(0.05, 0, 0, 55)
SpeedButton.Text = "🚀 ACTIVATE SPEED 999"
SpeedButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedButton.Font = Enum.Font.GothamBold
SpeedButton.TextSize = 14
SpeedButton.Parent = SpeedFrame

-- Log Console
local LogFrame = Instance.new("ScrollingFrame")
LogFrame.Size = UDim2.new(0.9, 0, 0, 100)
LogFrame.Position = UDim2.new(0.05, 0, 0, 265)
LogFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
LogFrame.BorderSizePixel = 0
LogFrame.ScrollBarThickness = 4
LogFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
LogFrame.Parent = MainFrame

local LogCorner = Instance.new("UICorner")
LogCorner.CornerRadius = UDim.new(0, 8)
LogCorner.Parent = LogFrame

local LogTitle = Instance.new("TextLabel")
LogTitle.Size = UDim2.new(1, 0, 0, 20)
LogTitle.Position = UDim2.new(0, 0, 0, 0)
LogTitle.Text = "📝 SYSTEM LOG"
LogTitle.TextColor3 = Color3.fromRGB(150, 150, 200)
LogTitle.BackgroundTransparency = 1
LogTitle.Font = Enum.Font.GothamBold
LogTitle.TextSize = 14
LogTitle.Parent = LogFrame

-- ============================================
-- DAMAGE HACK ENGINE (MOBILE OPTIMIZED)
-- ============================================

local DamageMultiplier = 100
local SpeedValue = 16
local IsDamageActive = false
local IsSpeedActive = false
local LogMessages = {}

-- Fungsi Log untuk Mobile
local function AddLog(message)
    local timestamp = os.date("%H:%M:%S")
    local logText = "[" .. timestamp .. "] " .. message
    
    table.insert(LogMessages, logText)
    if #LogMessages > 8 then
        table.remove(LogMessages, 1)
    end
    
    -- Update log display
    LogFrame:ClearAllChildren()
    LogTitle.Parent = LogFrame
    
    for i, msg in ipairs(LogMessages) do
        local logEntry = Instance.new("TextLabel")
        logEntry.Size = UDim2.new(1, -10, 0, 20)
        logEntry.Position = UDim2.new(0, 5, 0, 25 + (i-1)*22)
        logEntry.Text = msg
        logEntry.TextColor3 = Color3.fromRGB(200, 200, 200)
        logEntry.BackgroundTransparency = 1
        logEntry.Font = Enum.Font.Gotham
        logEntry.TextSize = 12
        logEntry.TextXAlignment = Enum.TextXAlignment.Left
        logEntry.TextWrapped = false
        logEntry.Parent = LogFrame
    end
    
    print("[MOBILE HACK]", message)
end

-- Update UI Status
local function UpdateUI()
    if IsDamageActive then
        StatusLabel.Text = "🟢 DAMAGE ACTIVE"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        DamageButton.Text = "✅ DAMAGE 999x ACTIVE"
        DamageButton.BackgroundColor3 = Color3.fromRGB(0, 200, 50)
    else
        DamageButton.Text = "🔥 ACTIVATE DAMAGE 999x"
        DamageButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    end
    
    if IsSpeedActive then
        SpeedButton.Text = "✅ SPEED 999 ACTIVE"
        SpeedButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    else
        SpeedButton.Text = "🚀 ACTIVATE SPEED 999"
        SpeedButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    end
    
    MultiplierLabel.Text = "DAMAGE: " .. DamageMultiplier .. "x"
    SpeedLabel.Text = "SPEED: " .. SpeedValue
end

-- ============================================
-- DAMAGE HACK SYSTEM
-- ============================================

local function ActivateDamageHack()
    if IsDamageActive then return end
    
    AddLog("Activating Damage Hack...")
    DamageMultiplier = 999
    IsDamageActive = true
    
    -- METHOD 1: Hook semua RemoteEvent
    for _, remote in pairs(game:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            local name = remote.Name:lower()
            if name:find("damage") or name:find("hit") or name:find("attack") or name:find("punch") then
                local oldFire = remote.FireServer
                
                remote.FireServer = function(self, ...)
                    local args = {...}
                    
                    -- Modifikasi semua angka
                    for i, arg in pairs(args) do
                        if type(arg) == "number" and arg > 0 then
                            args[i] = arg * DamageMultiplier
                            AddLog("Damage boosted: " .. arg .. " → " .. args[i])
                        end
                    end
                    
                    -- Jika tidak ada angka, tambahkan
                    local hasNumber = false
                    for _, arg in pairs(args) do
                        if type(arg) == "number" then hasNumber = true end
                    end
                    
                    if not hasNumber then
                        table.insert(args, 100 * DamageMultiplier)
                    end
                    
                    return oldFire(self, unpack(args))
                end
                
                AddLog("Hooked: " .. remote.Name)
            end
        end
    end
    
    -- METHOD 2: Brute Force Spam
    spawn(function()
        while IsDamageActive do
            wait(0.1)
            pcall(function()
                -- Spam damage ke semua musuh
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local hum = player.Character:FindFirstChild("Humanoid")
                        if hum then
                            -- Coba semua metode damage
                            hum:TakeDamage(9999)
                            
                            -- Spam remote events
                            for _, remote in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                                if remote:IsA("RemoteEvent") then
                                    remote:FireServer(player.Character, 9999)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
    
    UpdateUI()
    AddLog("✅ Damage 999x ACTIVATED!")
end

-- ============================================
-- SPEED 999 HACK SYSTEM
-- ============================================

local function ActivateSpeedHack()
    if IsSpeedActive then return end
    
    AddLog("Activating Speed 999...")
    SpeedValue = 999
    IsSpeedActive = true
    
    -- METHOD 1: Modify Humanoid Walkspeed
    local function boostSpeed()
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = SpeedValue
                AddLog("Walkspeed set to " .. SpeedValue)
            end
        end
    end
    
    -- Apply speed saat spawn
    LocalPlayer.CharacterAdded:Connect(function()
        wait(0.5)
        boostSpeed()
    end)
    
    -- Apply sekarang
    boostSpeed()
    
    -- METHOD 2: Constant Speed Maintenance
    spawn(function()
        while IsSpeedActive do
            wait(0.1)
            pcall(function()
                if LocalPlayer.Character then
                    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                    if humanoid and humanoid.WalkSpeed < SpeedValue then
                        humanoid.WalkSpeed = SpeedValue
                    end
                    
                    -- Boost jump power juga
                    if humanoid then
                        humanoid.JumpPower = 100
                    end
                end
            end)
        end
    end)
    
    -- METHOD 3: NoClip + Fly
    spawn(function()
        while IsSpeedActive do
            wait()
            pcall(function()
                if LocalPlayer.Character then
                    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        -- NoClip
                        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                        
                        -- Fly controls (untuk mobile)
                        local velocity = root.Velocity
                        root.Velocity = Vector3.new(velocity.X, 0, velocity.Z)
                    end
                end
            end)
        end
    end)
    
    UpdateUI()
    AddLog("✅ Speed 999 ACTIVATED!")
end

-- ============================================
-- BUTTON CONTROLS
-- ============================================

DamageButton.MouseButton1Click:Connect(function()
    if not IsDamageActive then
        ActivateDamageHack()
    else
        DamageMultiplier = 100
        IsDamageActive = false
        AddLog("Damage hack disabled")
        UpdateUI()
    end
end)

SpeedButton.MouseButton1Click:Connect(function()
    if not IsSpeedActive then
        ActivateSpeedHack()
    else
        SpeedValue = 16
        IsSpeedActive = false
        
        -- Reset speed
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
        
        AddLog("Speed hack disabled")
        UpdateUI()
    end
end)

-- ============================================
-- AUTO-START FEATURES
-- ============================================

-- Auto-detect game start
AddLog("System loaded on Android")
AddLog("Game: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
AddLog("Ready for commands...")

-- Auto-activate setelah 3 detik
delay(3, function()
    if not IsDamageActive then
        AddLog("Tap buttons to activate hacks!")
    end
end)

-- Touch controls info
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 0, 20)
InfoLabel.Position = UDim2.new(0, 0, 0, 370)
InfoLabel.Text = "👆 Tap buttons to toggle hacks"
InfoLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.TextSize = 12
InfoLabel.Parent = MainFrame

-- Mobile vibration feedback (simulasi)
local function VibrateButton(button)
    local originalSize = button.Size
    button.Size = UDim2.new(originalSize.X.Scale * 0.95, originalSize.X.Offset, 
                           originalSize.Y.Scale * 0.95, originalSize.Y.Offset)
    wait(0.1)
    button.Size = originalSize
end

DamageButton.MouseButton1Down:Connect(function() VibrateButton(DamageButton) end)
SpeedButton.MouseButton1Down:Connect(function() VibrateButton(SpeedButton) end)

UpdateUI()
AddLog("✅ Mobile Hack UI Ready!")

print("========================================")
print("MOBILE HACK LOADED FOR ANDROID")
print("Damage: 999x available")
print("Speed: 999 available")
print("Touch the buttons to activate!")
print("========================================")
