-- DUELING GROUNDS HACK SCRIPT - FIXED UI
-- By DARK VERSE v1 | Owner: MikaaDev - V0.1

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Backpack = Player.Backpack
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Tunggu game loaded
if not game:IsLoaded() then
    game.Loaded:Wait()
end
wait(2)

print("[DARK VERSE] Dueling Grounds Hack Loading...")

-- UI Setup PASTI MUNCUL
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DuelingHack_MikaaDev"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = game:GetService("CoreGui") -- PASTI MUNCUL DI COREGUI

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.2, 0, 0.35, 0)
MainFrame.Position = UDim2.new(0.78, 0, 0.35, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(255, 50, 50)
MainFrame.Parent = ScreenGui

-- LOGO MINI (KIRI ATAS)
local LogoMini = Instance.new("ImageLabel")
LogoMini.Name = "LogoMini"
LogoMini.Image = "rbxassetid://100166477433523"
LogoMini.Size = UDim2.new(0, 50, 0, 50)
LogoMini.Position = UDim2.new(0.02, 0, 0.02, 0)
LogoMini.BackgroundTransparency = 1
LogoMini.Parent = ScreenGui

-- DRAGGABLE UI
local UserInputService = game:GetService("UserInputService")
local dragging
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0.15, 0)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "⚔️ DUELING HACK ⚔️"
Title.Size = UDim2.new(1, 0, 0.7, 0)
Title.Position = UDim2.new(0, 0, 0.15, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = Header

local OwnerLabel = Instance.new("TextLabel")
OwnerLabel.Text = "@MikaaDev - V0.1 | DARK VERSE v1"
OwnerLabel.Size = UDim2.new(1, 0, 0.3, 0)
OwnerLabel.Position = UDim2.new(0, 0, 0.7, 0)
OwnerLabel.BackgroundTransparency = 1
OwnerLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
OwnerLabel.Font = Enum.Font.Gotham
OwnerLabel.TextSize = 10
OwnerLabel.Parent = Header

-- FITUR TOGGLE
local features = {
    OneHitKill = false,
    GodMode = false,
    Damage9999 = false,
    Speed50 = false,
    AntiStun = false,
    AutoBlock = false,
    Coin9999 = false,
    NoClip = false
}

local function setFeature(feature, state)
    features[feature] = state
end

-- TOGGLE BUTTON FUNCTION
local buttonY = 0.18
local buttonCount = 0

local function createFeatureButton(featureName, displayName, color)
    local button = Instance.new("TextButton")
    button.Name = featureName
    button.Size = UDim2.new(0.9, 0, 0.08, 0)
    button.Position = UDim2.new(0.05, 0, buttonY, 0)
    button.BackgroundColor3 = color
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = "⭕ " .. displayName
    button.Font = Enum.Font.GothamBold
    button.TextSize = 12
    button.Parent = MainFrame
    
    button.MouseButton1Click:Connect(function()
        features[featureName] = not features[featureName]
        
        if features[featureName] then
            button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            button.Text = "✅ " .. displayName .. " ON"
        else
            button.BackgroundColor3 = color
            button.Text = "⭕ " .. displayName
        end
    end)
    
    buttonY = buttonY + 0.09
    buttonCount = buttonCount + 1
    
    -- Adjust frame size based on buttons
    MainFrame.Size = UDim2.new(0.2, 0, 0.15 + (buttonCount * 0.09), 0)
    
    return button
end

-- CREATE BUTTONS
local buttons = {
    createFeatureButton("OneHitKill", "ONE HIT KILL", Color3.fromRGB(200, 50, 50)),
    createFeatureButton("GodMode", "GOD MODE", Color3.fromRGB(50, 150, 200)),
    createFeatureButton("Damage9999", "DAMAGE 9999", Color3.fromRGB(200, 100, 50)),
    createFeatureButton("Speed50", "SPEED 50", Color3.fromRGB(50, 200, 100)),
    createFeatureButton("AntiStun", "ANTI STUN", Color3.fromRGB(150, 50, 200)),
    createFeatureButton("AutoBlock", "AUTO BLOCK", Color3.fromRGB(200, 200, 50)),
    createFeatureButton("Coin9999", "COIN 9999", Color3.fromRGB(50, 200, 200)),
    createFeatureButton("NoClip", "NO CLIP", Color3.fromRGB(200, 150, 50))
}

-- SYSTEMS
local function oneHitSystem()
    while wait(0.5) do
        if not features.OneHitKill then break end
        pcall(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Player then
                    local char = player.Character
                    if char and char:FindFirstChild("Humanoid") then
                        char.Humanoid.Health = 0
                    end
                end
            end
        end)
    end
end

local function godModeSystem()
    while wait(0.3) do
        if not features.GodMode then break end
        pcall(function()
            if Character and Character:FindFirstChild("Humanoid") then
                Character.Humanoid.MaxHealth = 99999
                Character.Humanoid.Health = 99999
            end
        end)
    end
end

local function damageSystem()
    while wait(0.2) do
        if not features.Damage9999 then break end
        pcall(function()
            for _, tool in pairs(Backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    tool:SetAttribute("Damage", 9999)
                end
            end
            if Character then
                for _, tool in pairs(Character:GetChildren()) do
                    if tool:IsA("Tool") then
                        tool:SetAttribute("Damage", 9999)
                    end
                end
            end
        end)
    end
end

local function speedSystem()
    while wait(0.5) do
        if not features.Speed50 then break end
        pcall(function()
            if Character and Character:FindFirstChild("Humanoid") then
                Character.Humanoid.WalkSpeed = 50
                Character.Humanoid.JumpPower = 100
            end
        end)
    end
end

local function coinSystem()
    while wait(1) do
        if not features.Coin9999 then break end
        pcall(function()
            local stats = Player:FindFirstChild("leaderstats")
            if stats then
                for _, stat in pairs(stats:GetChildren()) do
                    if stat.Name:lower():find("coin") or stat.Name:lower():find("money") then
                        stat.Value = 9999
                    end
                end
            end
            Player:SetAttribute("Coins", 9999)
        end)
    end
end

local function noClipSystem()
    while wait(0.5) do
        if not features.NoClip then break end
        pcall(function()
            if Character then
                for _, part in pairs(Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end

-- START SYSTEMS WHEN TOGGLED
for feature, button in pairs(buttons) do
    button.MouseButton1Click:Connect(function()
        local featureName = button.Name
        if features[featureName] then
            if featureName == "OneHitKill" then spawn(oneHitSystem) end
            if featureName == "GodMode" then spawn(godModeSystem) end
            if featureName == "Damage9999" then spawn(damageSystem) end
            if featureName == "Speed50" then spawn(speedSystem) end
            if featureName == "Coin9999" then spawn(coinSystem) end
            if featureName == "NoClip" then spawn(noClipSystem) end
        end
    end)
end

-- MINIMIZE BUTTON
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Text = "─"
MinimizeBtn.Size = UDim2.new(0.05, 0, 0.05, 0)
MinimizeBtn.Position = UDim2.new(0.95, 0, 0, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = MainFrame

local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        for _, child in pairs(MainFrame:GetChildren()) do
            if child ~= Header and child ~= MinimizeBtn then
                child.Visible = false
            end
        end
        MainFrame.Size = UDim2.new(0.2, 0, 0.15, 0)
        MinimizeBtn.Text = "＋"
    else
        for _, child in pairs(MainFrame:GetChildren()) do
            child.Visible = true
        end
        MainFrame.Size = UDim2.new(0.2, 0, 0.15 + (buttonCount * 0.09), 0)
        MinimizeBtn.Text = "─"
    end
end)

-- NOTIFICATION
local function notify(msg)
    local notif = Instance.new("TextLabel")
    notif.Text = "⚡ " .. msg
    notif.Size = UDim2.new(0.3, 0, 0.05, 0)
    notif.Position = UDim2.new(0.35, 0, 0.9, 0)
    notif.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    notif.BackgroundTransparency = 0.3
    notif.TextColor3 = Color3.fromRGB(0, 255, 0)
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 14
    notif.Parent = ScreenGui
    
    wait(3)
    notif:Destroy()
end

-- AUTO RECONNECT
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    wait(1)
    notify("Character reconnected!")
end)

-- INIT
notify("Dueling Grounds Hack Loaded!")
print("[DARK VERSE] UI LOADED - Check top-right corner!")
print("[DARK VERSE] Logo mini at top-left corner!")

-- FORCE UI VISIBLE
ScreenGui.Enabled = true
MainFrame.Visible = true
LogoMini.Visible = true

-- LAST RESORT: Jika masih tidak muncul
wait(1)
if not ScreenGui.Parent then
    ScreenGui.Parent = game:GetService("CoreGui")
    warn("[DARK VERSE] UI Force-parented to CoreGui")
end
