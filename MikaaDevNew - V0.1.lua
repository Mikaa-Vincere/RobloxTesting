-- DUELING GROUNDS HACK - FIXED REAL SYSTEM
-- By DARK VERSE v1 | Owner: MikaaDev - V0.1
-- REAL DAMAGE HACK, NOT VISUAL

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Backpack = Player.Backpack
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- TUNGGU GAME LOAD
if not game:IsLoaded() then wait(5) end

print("[DARK VERSE] Loading REAL System Hack...")

-- UI YANG BISA DIGESER & RESPONSIVE
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RealDuelHack"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = game:GetService("CoreGui")

-- MAIN FRAME YANG POSISI AWAL TENGAH BAWAH
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.25, 0, 0.18, 0)
MainFrame.Position = UDim2.new(0.5, -100, 0.8, 0) -- TENGAH BAWAH
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 50, 50)
MainFrame.Parent = ScreenGui

-- DRAGGABLE SYSTEM
local UIS = game:GetService("UserInputService")
local dragging = false
local dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            update(input)
        end
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        update(input)
    end
end)

-- HEADER SIMPLE
local Header = Instance.new("TextLabel")
Header.Text = "⚔️ REAL HACK ⚔️"
Header.Size = UDim2.new(1, 0, 0.3, 0)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.Font = Enum.Font.GothamBold
Header.TextSize = 14
Header.Parent = MainFrame

local OwnerLabel = Instance.new("TextLabel")
OwnerLabel.Text = "@MikaaDev | Drag UI"
OwnerLabel.Size = UDim2.new(1, 0, 0.15, 0)
OwnerLabel.Position = UDim2.new(0, 0, 0.3, 0)
OwnerLabel.BackgroundTransparency = 1
OwnerLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
OwnerLabel.Font = Enum.Font.Gotham
OwnerLabel.TextSize = 10
OwnerLabel.Parent = MainFrame

-- REAL HACK SYSTEM (BUKAN VISUAL)
local DamageMultiplier = 2.0 -- 100% lebih (bisa diubah 1.2 untuk 20%)
local SpeedMultiplier = 1.5 -- 50% lebih cepat
local features = {
    RealDamage = false,
    RealSpeed = false,
    AntiStun = false,
    AutoBlock = false
}

-- REAL DAMAGE HACK (MODIFIKASI SISTEM ASLI)
local function applyRealDamage()
    while wait(0.3) do
        if not features.RealDamage then break end
        
        pcall(function()
            -- CARI SEMUA PEDANG/TOOL
            local allTools = {}
            for _, tool in pairs(Backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    table.insert(allTools, tool)
                end
            end
            
            if Character then
                for _, tool in pairs(Character:GetChildren()) do
                    if tool:IsA("Tool") then
                        table.insert(allTools, tool)
                    end
                end
            end
            
            -- MODIFIKASI SETIAP TOOL
            for _, tool in pairs(allTools) do
                -- METHOD 1: ATTRIBUTES (Paling work)
                local currentDmg = tool:GetAttribute("Damage") or tool:GetAttribute("BaseDamage") or 10
                tool:SetAttribute("Damage", currentDmg * DamageMultiplier)
                tool:SetAttribute("BaseDamage", currentDmg * DamageMultiplier)
                
                -- METHOD 2: CONFIGURATION
                local config = tool:FindFirstChild("Configuration")
                if config then
                    local dmgValue = config:FindFirstChild("Damage") or config:FindFirstChild("damage")
                    if dmgValue and dmgValue:IsA("NumberValue") then
                        dmgValue.Value = dmgValue.Value * DamageMultiplier
                    end
                end
                
                -- METHOD 3: SCRIPTS (Hati-hati)
                local script = tool:FindFirstChildWhichIsA("Script")
                if script then
                    local src = script.Source
                    -- Cari angka damage di script
                    local patterns = {"damage = (%d+)", "Damage = (%d+)", "%.damage = (%d+)", "%.Damage = (%d+)"}
                    for _, pattern in ipairs(patterns) do
                        local current = src:match(pattern)
                        if current then
                            local newDmg = math.floor(tonumber(current) * DamageMultiplier)
                            src = src:gsub(pattern:gsub("%%d%+", current), pattern:gsub("%%d%+", tostring(newDmg)))
                        end
                    end
                    script.Source = src
                end
                
                -- METHOD 4: REMOTE HOOK (Paling Ampuh)
                for _, child in pairs(tool:GetDescendants()) do
                    if child:IsA("RemoteEvent") then
                        if child.Name:lower():find("damage") or child.Name:lower():find("hit") then
                            local oldFire = child.FireServer
                            child.FireServer = function(self, ...)
                                local args = {...}
                                -- Modify damage argument
                                for i, arg in ipairs(args) do
                                    if type(arg) == "number" and arg > 0 and arg < 1000 then
                                        args[i] = arg * DamageMultiplier
                                    end
                                end
                                return oldFire(self, unpack(args))
                            end
                        end
                    end
                end
            end
            
            -- HOOK GLOBAL DAMAGE REMOTE
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            if remotes then
                for _, remote in pairs(remotes:GetChildren()) do
                    if remote:IsA("RemoteEvent") and (remote.Name:lower():find("damage") or remote.Name:lower():find("hit")) then
                        local oldFire = remote.FireServer
                        remote.FireServer = function(self, ...)
                            local args = {...}
                            for i, arg in ipairs(args) do
                                if type(arg) == "number" then
                                    args[i] = arg * DamageMultiplier
                                elseif type(arg) == "table" and arg.Damage then
                                    arg.Damage = arg.Damage * DamageMultiplier
                                end
                            end
                            return oldFire(self, unpack(args))
                        end
                    end
                end
            end
        end)
    end
end

-- REAL SPEED HACK
local function applyRealSpeed()
    while wait(0.5) do
        if not features.RealSpeed then break end
        
        pcall(function()
            if Character and Character:FindFirstChild("Humanoid") then
                local defaultSpeed = 16
                Character.Humanoid.WalkSpeed = defaultSpeed * SpeedMultiplier
                Character.Humanoid.JumpPower = 50 * SpeedMultiplier
            end
        end)
    end
end

-- ANTI STUN SYSTEM
local function applyAntiStun()
    while wait(0.2) do
        if not features.AntiStun then break end
        
        pcall(function()
            if Character then
                local humanoid = Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid:SetAttribute("Stunned", false)
                    humanoid:SetAttribute("Frozen", false)
                    
                    -- Remove stun effects
                    for _, child in pairs(Character:GetChildren()) do
                        if child.Name:lower():find("stun") or child.Name:lower():find("freeze") then
                            child:Destroy()
                        end
                    end
                end
            end
        end)
    end
end

-- AUTO BLOCK SYSTEM
local function applyAutoBlock()
    while wait(0.1) do
        if not features.AutoBlock then break end
        
        pcall(function()
            -- Deteksi musuh dekat
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Player then
                    local enemy = player.Character
                    if enemy and enemy:FindFirstChild("HumanoidRootPart") then
                        local distance = (Character.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                        if distance < 10 then
                            -- Trigger block
                            local humanoid = Character:FindFirstChild("Humanoid")
                            if humanoid then
                                humanoid:SetAttribute("Blocking", true)
                            end
                        end
                    end
                end
            end
        end)
    end
end

-- CREATE TOGGLE BUTTONS
local buttonY = 0.48
local buttonHeight = 0.12

local function createRealToggle(text, featureName, func)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.45, 0, buttonHeight, 0)
    button.Position = UDim2.new(0.03, 0, buttonY, 0)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = text .. "\n[OFF]"
    button.Font = Enum.Font.Gotham
    button.TextSize = 11
    button.TextWrapped = true
    button.Parent = MainFrame
    
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(0.9, 0, 0.3, 0)
    status.Position = UDim2.new(0.05, 0, 0.7, 0)
    status.BackgroundTransparency = 1
    status.TextColor3 = Color3.fromRGB(255, 50, 50)
    status.Font = Enum.Font.GothamBold
    status.TextSize = 9
    status.Text = "OFF"
    status.Parent = button
    
    button.MouseButton1Click:Connect(function()
        features[featureName] = not features[featureName]
        
        if features[featureName] then
            button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            status.Text = "ON"
            status.TextColor3 = Color3.fromRGB(0, 255, 0)
            spawn(func)
        else
            button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            status.Text = "OFF"
            status.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end)
    
    return button
end

-- BUAT 4 FITUR UTAMA
local btnDamage = createRealToggle("DAMAGE\n+100%", "RealDamage", applyRealDamage)
btnDamage.Position = UDim2.new(0.03, 0, 0.48, 0)

local btnSpeed = createRealToggle("SPEED\n+50%", "RealSpeed", applyRealSpeed)
btnSpeed.Position = UDim2.new(0.53, 0, 0.48, 0)

local btnStun = createRealToggle("ANTI\nSTUN", "AntiStun", applyAntiStun)
btnStun.Position = UDim2.new(0.03, 0, 0.62, 0)

local btnBlock = createRealToggle("AUTO\nBLOCK", "AutoBlock", applyAutoBlock)
btnBlock.Position = UDim2.new(0.53, 0, 0.62, 0)

-- DAMAGE MULTIPLIER SLIDER
local MultiplierLabel = Instance.new("TextLabel")
MultiplierLabel.Text = "Damage Multiplier: 100%"
MultiplierLabel.Size = UDim2.new(0.94, 0, 0.1, 0)
MultiplierLabel.Position = UDim2.new(0.03, 0, 0.78, 0)
MultiplierLabel.BackgroundTransparency = 1
MultiplierLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
MultiplierLabel.Font = Enum.Font.Gotham
MultiplierLabel.TextSize = 11
MultiplierLabel.Parent = MainFrame

local MultiplierSlider = Instance.new("TextButton")
MultiplierSlider.Text = "▲ 100% ▼"
MultiplierSlider.Size = UDim2.new(0.94, 0, 0.08, 0)
MultiplierSlider.Position = UDim2.new(0.03, 0, 0.88, 0)
MultiplierSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
MultiplierSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
MultiplierSlider.Font = Enum.Font.GothamBold
MultiplierSlider.TextSize = 12
MultiplierSlider.Parent = MainFrame

MultiplierSlider.MouseButton1Click:Connect(function()
    DamageMultiplier = DamageMultiplier + 0.2
    if DamageMultiplier > 5 then DamageMultiplier = 1.2 end
    MultiplierLabel.Text = "Damage Multiplier: " .. math.floor((DamageMultiplier - 1) * 100) .. "%"
    MultiplierSlider.Text = "▲ " .. math.floor((DamageMultiplier - 1) * 100) .. "% ▼"
end)

-- NOTIFIKASI
local function showNotif(msg)
    local notif = Instance.new("TextLabel")
    notif.Text = "⚡ " .. msg
    notif.Size = UDim2.new(0.3, 0, 0.04, 0)
    notif.Position = UDim2.new(0.35, 0, 0.05, 0)
    notif.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    notif.BackgroundTransparency = 0.5
    notif.TextColor3 = Color3.fromRGB(0, 255, 0)
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 12
    notif.Parent = ScreenGui
    
    game:GetService("Debris"):AddItem(notif, 3)
end

-- AUTO REAPPLY SAAT GANTI CHARACTER
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    wait(1)
    showNotif("Character Ready!")
    
    if features.RealSpeed then
        pcall(function()
            if Character:FindFirstChild("Humanoid") then
                Character.Humanoid.WalkSpeed = 16 * SpeedMultiplier
            end
        end)
    end
end)

-- INIT
showNotif("Real Hack Loaded!")
print("[DARK VERSE] Real Damage System Active!")
print("[DARK VERSE] Multiplier: " .. DamageMultiplier)
print("[DARK VERSE] Drag UI to move!")

-- PASTIKAN UI MUNCUL
wait(0.5)
ScreenGui.Enabled = true
