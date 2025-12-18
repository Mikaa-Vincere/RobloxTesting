-- ============================================
-- ADVANCED MOBILE HACK UI WITH TOGGLE
-- Android Optimized + Toggle System
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- Hapus UI lama
if CoreGui:FindFirstChild("SmartHackUI") then
    CoreGui.SmartHackUI:Destroy()
end

-- ============================================
-- MINIMALIST TOGGLE BUTTON (UI Logo Kecil)
-- ============================================
local ToggleUI = Instance.new("ScreenGui")
ToggleUI.Name = "SmartHackUI"
ToggleUI.Parent = CoreGui

-- Logo UI Kecil (Toggle Button)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Position = UDim2.new(1, -70, 0.5, -30)
ToggleButton.Text = "⚡"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleButton.BorderSizePixel = 0
ToggleButton.Font = Enum.Font.GothamBlack
ToggleButton.TextSize = 30
ToggleButton.ZIndex = 100
ToggleButton.Parent = ToggleUI

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 30)
ToggleCorner.Parent = ToggleButton

local ToggleShadow = Instance.new("ImageLabel")
ToggleShadow.Size = UDim2.new(1, 10, 1, 10)
ToggleShadow.Position = UDim2.new(0, -5, 0, -5)
ToggleShadow.BackgroundTransparency = 1
ToggleShadow.Image = "rbxassetid://7333966035"
ToggleShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
ToggleShadow.ImageTransparency = 0.8
ToggleShadow.ScaleType = Enum.ScaleType.Slice
ToggleShadow.SliceCenter = Rect.new(10, 10, 118, 118)
ToggleShadow.Parent = ToggleButton

-- ============================================
-- MAIN UI PANEL (Tersembunyi Awalnya)
-- ============================================
local MainPanel = Instance.new("Frame")
MainPanel.Size = UDim2.new(0, 340, 0, 420)
MainPanel.Position = UDim2.new(0.5, -170, 0.5, -210)
MainPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainPanel.BackgroundTransparency = 0.05
MainPanel.BorderSizePixel = 0
MainPanel.Visible = false
MainPanel.Parent = ToggleUI

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0, 15)
PanelCorner.Parent = MainPanel

local PanelShadow = Instance.new("ImageLabel")
PanelShadow.Size = UDim2.new(1, 20, 1, 20)
PanelShadow.Position = UDim2.new(0, -10, 0, -10)
PanelShadow.BackgroundTransparency = 1
PanelShadow.Image = "rbxassetid://7333966035"
PanelShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
PanelShadow.ImageTransparency = 0.7
PanelShadow.ScaleType = Enum.ScaleType.Slice
PanelShadow.SliceCenter = Rect.new(10, 10, 118, 118)
PanelShadow.Parent = MainPanel

-- Header dengan tombol close
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Header.BorderSizePixel = 0
Header.Parent = MainPanel

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 15, 0, 0)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "🎮 ADVANCED HACK MENU"
Title.TextColor3 = Color3.fromRGB(255, 150, 50)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -45, 0, 5)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseButton.BackgroundTransparency = 1
CloseButton.Font = Enum.Font.GothamBlack
CloseButton.TextSize = 24
CloseButton.Parent = Header

-- Status Bar
local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, -20, 0, 40)
StatusBar.Position = UDim2.new(0, 10, 0, 60)
StatusBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
StatusBar.BorderSizePixel = 0
StatusBar.Parent = MainPanel

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusBar

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 1, 0)
StatusLabel.Position = UDim2.new(0, 0, 0, 0)
StatusLabel.Text = "🟢 SYSTEM READY"
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 16
StatusLabel.Parent = StatusBar

-- Container untuk fitur
local FeaturesContainer = Instance.new("ScrollingFrame")
FeaturesContainer.Size = UDim2.new(1, -20, 0, 280)
FeaturesContainer.Position = UDim2.new(0, 10, 0, 110)
FeaturesContainer.BackgroundTransparency = 1
FeaturesContainer.BorderSizePixel = 0
FeaturesContainer.ScrollBarThickness = 4
FeaturesContainer.CanvasSize = UDim2.new(0, 0, 0, 450)
FeaturesContainer.Parent = MainPanel

-- ============================================
-- SYSTEM VARIABLES
-- ============================================
local Hacks = {
    Damage = {
        Active = false,
        Multiplier = 100,
        Connection = nil
    },
    Speed = {
        Active = false,
        Value = 16,
        Connection = nil
    },
    AttackSpeed = {
        Active = false,
        Connection = nil
    },
    GodMode = {
        Active = false,
        Connection = nil
    }
}

local Logs = {}

-- ============================================
-- UI FUNCTIONS
-- ============================================
local function UpdateStatus()
    local activeCount = 0
    for hack, data in pairs(Hacks) do
        if data.Active then activeCount = activeCount + 1 end
    end
    
    if activeCount == 0 then
        StatusLabel.Text = "🟢 SYSTEM READY"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    else
        StatusLabel.Text = "⚡ " .. activeCount .. " HACK(S) ACTIVE"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    end
end

local function AddLog(message)
    table.insert(Logs, "[" .. os.date("%H:%M:%S") .. "] " .. message)
    if #Logs > 10 then table.remove(Logs, 1) end
    print("[HACK]", message)
end

local function CreateFeatureCard(name, description, color, toggleFunc, statusFunc)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 80)
    card.Position = UDim2.new(0, 0, 0, #FeaturesContainer:GetChildren() * 85)
    card.BackgroundColor3 = color
    card.BackgroundTransparency = 0.2
    card.BorderSizePixel = 0
    card.Parent = FeaturesContainer
    
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 10)
    cardCorner.Parent = card
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.7, 0, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.Text = name
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = card
    
    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(0.7, 0, 0, 40)
    desc.Position = UDim2.new(0, 10, 0, 35)
    desc.Text = description
    desc.TextColor3 = Color3.fromRGB(200, 200, 200)
    desc.BackgroundTransparency = 1
    desc.Font = Enum.Font.Gotham
    desc.TextSize = 12
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextWrapped = true
    desc.Parent = card
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 80, 0, 30)
    toggleBtn.Position = UDim2.new(1, -90, 0, 25)
    toggleBtn.Text = "OFF"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 14
    toggleBtn.Parent = card
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = toggleBtn
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0, 80, 0, 20)
    statusLabel.Position = UDim2.new(1, -90, 0, 5)
    statusLabel.Text = "INACTIVE"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 12
    statusLabel.Parent = card
    
    toggleBtn.MouseButton1Click:Connect(function()
        local newState = not Hacks[name].Active
        Hacks[name].Active = newState
        
        if newState then
            toggleBtn.Text = "ON"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 50)
            statusLabel.Text = "ACTIVE"
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
            AddLog(name .. " ACTIVATED")
        else
            toggleBtn.Text = "OFF"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            statusLabel.Text = "INACTIVE"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            AddLog(name .. " DEACTIVATED")
        end
        
        toggleFunc(newState)
        UpdateStatus()
        
        -- Animasi klik
        toggleBtn.Size = UDim2.new(0, 75, 0, 28)
        wait(0.1)
        toggleBtn.Size = UDim2.new(0, 80, 0, 30)
    end)
    
    FeaturesContainer.CanvasSize = UDim2.new(0, 0, 0, #FeaturesContainer:GetChildren() * 85)
end

-- ============================================
-- HACK FUNCTIONS
-- ============================================
local function ToggleDamage(enable)
    if enable then
        AddLog("Activating DAMAGE 999x...")
        
        Hacks.Damage.Connection = RunService.Heartbeat:Connect(function()
            pcall(function()
                -- Hook semua RemoteEvent damage
                for _, remote in pairs(game:GetDescendants()) do
                    if remote:IsA("RemoteEvent") then
                        local name = remote.Name:lower()
                        if name:find("damage") or name:find("hit") or name:find("attack") then
                            local old = remote.FireServer
                            if not getmetatable(remote).__hooked then
                                remote.FireServer = function(self, ...)
                                    local args = {...}
                                    for i, arg in pairs(args) do
                                        if type(arg) == "number" and arg > 0 then
                                            args[i] = arg * 999
                                        end
                                    end
                                    return old(self, unpack(args))
                                end
                                getmetatable(remote).__hooked = true
                            end
                        end
                    end
                end
                
                -- Force damage ke musuh
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local humanoid = player.Character:FindFirstChild("Humanoid")
                        if humanoid then
                            humanoid:TakeDamage(999)
                        end
                    end
                end
            end)
        end)
        
        AddLog("✅ DAMAGE 999x ACTIVATED")
    else
        if Hacks.Damage.Connection then
            Hacks.Damage.Connection:Disconnect()
            Hacks.Damage.Connection = nil
            AddLog("Damage hack disabled")
        end
    end
end

local function ToggleSpeed(enable)
    if enable then
        AddLog("Activating SPEED 999...")
        
        Hacks.Speed.Connection = RunService.Heartbeat:Connect(function()
            pcall(function()
                if LocalPlayer.Character then
                    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = 999
                        humanoid.JumpPower = 150
                        
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
        
        AddLog("✅ SPEED 999 ACTIVATED")
    else
        if Hacks.Speed.Connection then
            Hacks.Speed.Connection:Disconnect()
            Hacks.Speed.Connection = nil
            
            -- Reset speed
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 16
                    humanoid.JumpPower = 50
                end
            end
            
            AddLog("Speed hack disabled")
        end
    end
end

local function ToggleAttackSpeed(enable)
    if enable then
        AddLog("Activating MAX ATTACK SPEED...")
        
        Hacks.AttackSpeed.Connection = RunService.Heartbeat:Connect(function()
            pcall(function()
                -- Spam attack packets
                for _, remote in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                    if remote:IsA("RemoteEvent") and remote.Name:lower():find("attack") then
                        for i = 1, 10 do
                            remote:FireServer()
                        end
                    end
                end
                
                -- Remove attack cooldowns
                if LocalPlayer.Character then
                    for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                        if v:IsA("NumberValue") and v.Name:lower():find("cooldown") then
                            v.Value = 0
                        end
                    end
                end
            end)
        end)
        
        AddLog("✅ MAX ATTACK SPEED ACTIVATED")
    else
        if Hacks.AttackSpeed.Connection then
            Hacks.AttackSpeed.Connection:Disconnect()
            Hacks.AttackSpeed.Connection = nil
            AddLog("Attack speed hack disabled")
        end
    end
end

local function ToggleGodMode(enable)
    if enable then
        AddLog("Activating GOD MODE...")
        
        Hacks.GodMode.Connection = LocalPlayer.CharacterAdded:Connect(function(char)
            wait(0.5)
            local humanoid = char:WaitForChild("Humanoid")
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
            
            humanoid.Changed:Connect(function()
                if humanoid.Health < 1000 then
                    humanoid.Health = math.huge
                end
            end)
        end)
        
        -- Apply sekarang
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
            end
        end
        
        AddLog("✅ GOD MODE ACTIVATED")
    else
        if Hacks.GodMode.Connection then
            Hacks.GodMode.Connection:Disconnect()
            Hacks.GodMode.Connection = nil
            
            -- Reset health
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.MaxHealth = 100
                    humanoid.Health = 100
                end
            end
            
            AddLog("God mode disabled")
        end
    end
end

-- ============================================
-- CREATE FEATURE CARDS
-- ============================================
CreateFeatureCard(
    "DAMAGE",
    "999x Damage Multiplier\nOne-Hit Kill enemies",
    Color3.fromRGB(255, 50, 50),
    ToggleDamage,
    function() return Hacks.Damage.Active end
)

CreateFeatureCard(
    "SPEED",
    "WalkSpeed 999 + NoClip\nSuper fast movement",
    Color3.fromRGB(50, 150, 255),
    ToggleSpeed,
    function() return Hacks.Speed.Active end
)

CreateFeatureCard(
    "ATTACK SPEED",
    "Max attack speed\nNo cooldowns, rapid attacks",
    Color3.fromRGB(255, 150, 0),
    ToggleAttackSpeed,
    function() return Hacks.AttackSpeed.Active end
)

CreateFeatureCard(
    "GOD MODE",
    "Invincible, cannot die\nInfinite health",
    Color3.fromRGB(0, 200, 100),
    ToggleGodMode,
    function() return Hacks.GodMode.Active end
)

-- ============================================
-- UI TOGGLE LOGIC
-- ============================================
local UIVisible = false

ToggleButton.MouseButton1Click:Connect(function()
    UIVisible = not UIVisible
    MainPanel.Visible = UIVisible
    
    if UIVisible then
        ToggleButton.Text = "⬅️"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
        AddLog("UI Opened")
    else
        ToggleButton.Text = "⚡"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        AddLog("UI Closed")
    end
    
    -- Animasi tombol
    ToggleButton.Size = UDim2.new(0, 55, 0, 55)
    wait(0.1)
    ToggleButton.Size = UDim2.new(0, 60, 0, 60)
end)

CloseButton.MouseButton1Click:Connect(function()
    UIVisible = false
    MainPanel.Visible = false
    ToggleButton.Text = "⚡"
    ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    AddLog("UI Closed via X button")
    
    -- Animasi tombol close
    CloseButton.TextSize = 20
    wait(0.1)
    CloseButton.TextSize = 24
end)

-- ============================================
-- DRAGGABLE UI
-- ============================================
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainPanel.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- ============================================
-- INITIALIZATION
-- ============================================
AddLog("Advanced Hack UI Loaded")
AddLog("Tap ⚡ button to open menu")
AddLog("Toggle hacks ON/OFF as needed")

UpdateStatus()

print("========================================")
print("ADVANCED HACK UI LOADED")
print("Toggle button at right side")
print("Features: Damage, Speed, Attack Speed, God Mode")
print("All hacks are MANUAL toggle (no auto-run)")
print("========================================")

-- Mobile optimization
if UIS.TouchEnabled then
    AddLog("Mobile device detected")
    ToggleButton.Size = UDim2.new(0, 70, 0, 70)
    ToggleButton.Position = UDim2.new(1, -80, 0.5, -35)
    ToggleButton.TextSize = 35
end
