-- =================================
-- MIKAADEV DELTA EXECUTOR v5 - WORKING VERSION
-- =================================
-- Berdasarkan debug output game lu
-- TestingDevByMikaa

-- Clean up
for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
    if gui.Name:find("MikaaDev") then
        gui:Destroy()
    end
end

-- Variabel
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- ========== FIND GAME STRUCTURE ==========
local GameRemotes = {
    Damage = ReplicatedStorage:FindFirstChild("Remotes") and 
             ReplicatedStorage.Remotes:FindFirstChild("PlayerCharacter") and
             ReplicatedStorage.Remotes.PlayerCharacter.Request:FindFirstChild("QueueBasicAttack"),
    
    PlayerStats = ReplicatedStorage:FindFirstChild("Remotes") and 
                  ReplicatedStorage.Remotes:FindFirstChild("PlayerStats") or
                  ReplicatedStorage:FindFirstChild("UpdatePlayerStats")
}

-- ========== CUSTOM UI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MikaaDev_Delta"
ScreenGui.Parent = game.CoreGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 300, 0, 350)
Main.Position = UDim2.new(0, 20, 0, 100)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
Main.BorderColor3 = Color3.fromRGB(0, 120, 255)
Main.BorderSizePixel = 2
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(0, 90, 180)
Header.Parent = Main

local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 30, 0, 30)
Logo.Position = UDim2.new(0, 5, 0, 5)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://100166477433523"
Logo.Parent = Header

local Title = Instance.new("TextLabel")
Title.Text = "MikaaDev Delta"
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 40, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Text = "TestingDevByMikaa"
Subtitle.Size = UDim2.new(1, 0, 0, 20)
Subtitle.Position = UDim2.new(0, 0, 0, 40)
Subtitle.BackgroundTransparency = 1
Subtitle.TextColor3 = Color3.fromRGB(150, 200, 255)
Subtitle.Font = Enum.Font.Code
Subtitle.TextSize = 10
Subtitle.Parent = Main

-- Buttons
local MinBtn = Instance.new("TextButton")
MinBtn.Text = "_"
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -65, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
MinBtn.TextColor3 = Color3.white
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.TextColor3 = Color3.white
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header

-- Features Frame
local FeaturesFrame = Instance.new("ScrollingFrame")
FeaturesFrame.Size = UDim2.new(1, -10, 1, -70)
FeaturesFrame.Position = UDim2.new(0, 5, 0, 65)
FeaturesFrame.BackgroundTransparency = 1
FeaturesFrame.ScrollBarThickness = 4
FeaturesFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 100, 255)
FeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, 300)
FeaturesFrame.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.Parent = FeaturesFrame

-- ========== COIN HACK (WORKING VERSION) ==========
local CoinFrame = Instance.new("Frame")
CoinFrame.Size = UDim2.new(1, 0, 0, 60)
CoinFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
CoinFrame.Parent = FeaturesFrame

local CoinLabel = Instance.new("TextLabel")
CoinLabel.Text = "COIN"
CoinLabel.Size = UDim2.new(0.7, 0, 0, 25)
CoinLabel.Position = UDim2.new(0, 10, 0, 5)
CoinLabel.BackgroundTransparency = 1
CoinLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
CoinLabel.Font = Enum.Font.GothamBold
CoinLabel.TextSize = 14
CoinLabel.TextXAlignment = Enum.TextXAlignment.Left
CoinLabel.Parent = CoinFrame

local CoinDesc = Instance.new("TextLabel")
CoinDesc.Text = "Set coin to 9999 (REALTIME)"
CoinDesc.Size = UDim2.new(0.7, 0, 0, 20)
CoinDesc.Position = UDim2.new(0, 10, 0, 30)
CoinDesc.BackgroundTransparency = 1
CoinDesc.TextColor3 = Color3.fromRGB(150, 180, 220)
CoinDesc.Font = Enum.Font.Code
CoinDesc.TextSize = 10
CoinDesc.TextXAlignment = Enum.TextXAlignment.Left
CoinDesc.Parent = CoinFrame

local CoinBtn = Instance.new("TextButton")
CoinBtn.Text = "OFF"
CoinBtn.Size = UDim2.new(0.25, 0, 0, 30)
CoinBtn.Position = UDim2.new(0.75, -5, 0.5, -15)
CoinBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CoinBtn.TextColor3 = Color3.white
CoinBtn.Font = Enum.Font.GothamBold
CoinBtn.TextSize = 12
CoinBtn.Parent = CoinFrame

local CoinHackActive = false
CoinBtn.MouseButton1Click:Connect(function()
    CoinHackActive = not CoinHackActive
    
    if CoinHackActive then
        CoinBtn.Text = "ON"
        CoinBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        spawn(function()
            while CoinHackActive do
                -- METHOD 1: Hook UpdatePlayerStats RemoteEvent
                local updateStats = ReplicatedStorage:FindFirstChild("Remotes")
                if updateStats then
                    local statsRemote = updateStats:FindFirstChild("UpdatePlayerStats") or
                                       updateStats:FindFirstChild("GeneralStatsUpdated")
                    
                    if statsRemote then
                        -- Backup original
                        local oldFire = statsRemote.FireServer
                        statsRemote.FireServer = function(self, ...)
                            local args = {...}
                            -- Modify coin value in args
                            for i, v in ipairs(args) do
                                if type(v) == "table" then
                                    for key, value in pairs(v) do
                                        if string.lower(tostring(key)):find("coin") or
                                           string.lower(tostring(key)):find("money") then
                                            v[key] = 9999
                                        end
                                    end
                                end
                            end
                            return oldFire(self, unpack(args))
                        end
                    end
                end
                
                -- METHOD 2: Direct value modification
                for _, obj in pairs(LocalPlayer:GetDescendants()) do
                    if obj:IsA("IntValue") or obj:IsA("NumberValue") then
                        local name = string.lower(obj.Name)
                        if name:find("coin") or name:find("money") or name:find("uang") then
                            obj.Value = 9999
                        end
                    end
                end
                
                -- METHOD 3: Find in ReplicatedStorage
                for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
                    if obj:IsA("IntValue") and string.lower(obj.Name):find("coin") then
                        obj.Value = 9999
                    end
                end
                
                wait(0.3)
            end
        end)
    else
        CoinBtn.Text = "OFF"
        CoinBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)

-- ========== DAMAGE HACK (WORKING VERSION) ==========
local DamageFrame = Instance.new("Frame")
DamageFrame.Size = UDim2.new(1, 0, 0, 60)
DamageFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
DamageFrame.Parent = FeaturesFrame

local DamageLabel = Instance.new("TextLabel")
DamageLabel.Text = "DAMAGE"
DamageLabel.Size = UDim2.new(0.7, 0, 0, 25)
DamageLabel.Position = UDim2.new(0, 10, 0, 5)
DamageLabel.BackgroundTransparency = 1
DamageLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
DamageLabel.Font = Enum.Font.GothamBold
DamageLabel.TextSize = 14
DamageLabel.TextXAlignment = Enum.TextXAlignment.Left
DamageLabel.Parent = DamageFrame

local DamageDesc = Instance.new("TextLabel")
DamageDesc.Text = "Katana damage x10 (REALTIME)"
DamageDesc.Size = UDim2.new(0.7, 0, 0, 20)
DamageDesc.Position = UDim2.new(0, 10, 0, 30)
DamageDesc.BackgroundTransparency = 1
DamageDesc.TextColor3 = Color3.fromRGB(150, 180, 220)
DamageDesc.Font = Enum.Font.Code
DamageDesc.TextSize = 10
DamageDesc.TextXAlignment = Enum.TextXAlignment.Left
DamageDesc.Parent = DamageFrame

local DamageBtn = Instance.new("TextButton")
DamageBtn.Text = "OFF"
DamageBtn.Size = UDim2.new(0.25, 0, 0, 30)
DamageBtn.Position = UDim2.new(0.75, -5, 0.5, -15)
DamageBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
DamageBtn.TextColor3 = Color3.white
DamageBtn.Font = Enum.Font.GothamBold
DamageBtn.TextSize = 12
DamageBtn.Parent = DamageFrame

local DamageHackActive = false
local DamageHook = nil

DamageBtn.MouseButton1Click:Connect(function()
    DamageHackActive = not DamageHackActive
    
    if DamageHackActive then
        DamageBtn.Text = "ON"
        DamageBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        -- FIND QUEUEBASICATTACK REMOTE (dari debug lu)
        local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
        if remotesFolder then
            local playerChar = remotesFolder:FindFirstChild("PlayerCharacter")
            if playerChar then
                local request = playerChar:FindFirstChild("Request")
                if request then
                    local queueAttack = request:FindFirstChild("QueueBasicAttack")
                    
                    if queueAttack and queueAttack:IsA("RemoteEvent") then
                        print("[MIKAADEV] Found QueueBasicAttack remote!")
                        
                        -- Hook the remote
                        local oldFire = queueAttack.FireServer
                        DamageHook = oldFire
                        
                        queueAttack.FireServer = function(self, ...)
                            local args = {...}
                            print("[MIKAADEV] Damage event intercepted!")
                            
                            -- Multiply damage
                            for i, v in ipairs(args) do
                                if type(v) == "number" and v > 0 and v < 1000 then
                                    args[i] = v * 10.0  -- 10x damage
                                    print("[MIKAADEV] Damage multiplied: " .. v .. " -> " .. args[i])
                                end
                            end
                            
                            return oldFire(self, unpack(args))
                        end
                    end
                end
            end
        end
        
        -- Also hook other possible damage remotes
        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") then
                local name = string.lower(remote.Name)
                if name:find("attack") or name:find("damage") or name:find("hit") then
                    local oldFire = remote.FireServer
                    remote.FireServer = function(self, ...)
                        local args = {...}
                        for i, v in ipairs(args) do
                            if type(v) == "number" then
                                args[i] = v * 10.0
                            end
                        end
                        return oldFire(self, unpack(args))
                    end
                end
            end
        end
    else
        DamageBtn.Text = "OFF"
        DamageBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        
        -- Restore original function if possible
        if DamageHook then
            local queueAttack = ReplicatedStorage:FindFirstChild("Remotes")
            if queueAttack then
                queueAttack = queueAttack:FindFirstChild("PlayerCharacter")
                if queueAttack then
                    queueAttack = queueAttack:FindFirstChild("Request")
                    if queueAttack then
                        queueAttack = queueAttack:FindFirstChild("QueueBasicAttack")
                        if queueAttack then
                            queueAttack.FireServer = DamageHook
                        end
                    end
                end
            end
        end
    end
end)

-- ========== SPEED HACK ==========
local SpeedFrame = Instance.new("Frame")
SpeedFrame.Size = UDim2.new(1, 0, 0, 60)
SpeedFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
SpeedFrame.Parent = FeaturesFrame

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Text = "SPEED"
SpeedLabel.Size = UDim2.new(0.7, 0, 0, 25)
SpeedLabel.Position = UDim2.new(0, 10, 0, 5)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextSize = 14
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = SpeedFrame

local SpeedDesc = Instance.new("TextLabel")
SpeedDesc.Text = "2x Movement Speed"
SpeedDesc.Size = UDim2.new(0.7, 0, 0, 20)
SpeedDesc.Position = UDim2.new(0, 10, 0, 30)
SpeedDesc.BackgroundTransparency = 1
SpeedDesc.TextColor3 = Color3.fromRGB(150, 180, 220)
SpeedDesc.Font = Enum.Font.Code
SpeedDesc.TextSize = 10
SpeedDesc.TextXAlignment = Enum.TextXAlignment.Left
SpeedDesc.Parent = SpeedFrame

local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Text = "OFF"
SpeedBtn.Size = UDim2.new(0.25, 0, 0, 30)
SpeedBtn.Position = UDim2.new(0.75, -5, 0.5, -15)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
SpeedBtn.TextColor3 = Color3.white
SpeedBtn.Font = Enum.Font.GothamBold
SpeedBtn.TextSize = 12
SpeedBtn.Parent = SpeedFrame

SpeedBtn.MouseButton1Click:Connect(function()
    local enabled = SpeedBtn.Text == "OFF"
    
    if enabled then
        SpeedBtn.Text = "ON"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        -- Set speed
        local function SetSpeed()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 50  -- Very fast!
                    humanoid.JumpPower = 75
                end
            end
        end
        
        SetSpeed()
        LocalPlayer.CharacterAdded:Connect(SetSpeed)
    else
        SpeedBtn.Text = "OFF"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        
        -- Reset speed
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
            end
        end
    end
end)

-- ========== HEALTH HACK ==========
local HealthFrame = Instance.new("Frame")
HealthFrame.Size = UDim2.new(1, 0, 0, 60)
HealthFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
HealthFrame.Parent = FeaturesFrame

local HealthLabel = Instance.new("TextLabel")
HealthLabel.Text = "HEALTH"
HealthLabel.Size = UDim2.new(0.7, 0, 0, 25)
HealthLabel.Position = UDim2.new(0, 10, 0, 5)
HealthLabel.BackgroundTransparency = 1
HealthLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
HealthLabel.Font = Enum.Font.GothamBold
HealthLabel.TextSize = 14
HealthLabel.TextXAlignment = Enum.TextXAlignment.Left
HealthLabel.Parent = HealthFrame

local HealthDesc = Instance.new("TextLabel")
HealthDesc.Text = "+500 HP & Auto Regen"
HealthDesc.Size = UDim2.new(0.7, 0, 0, 20)
HealthDesc.Position = UDim2.new(0, 10, 0, 30)
HealthDesc.BackgroundTransparency = 1
HealthDesc.TextColor3 = Color3.fromRGB(150, 180, 220)
HealthDesc.Font = Enum.Font.Code
HealthDesc.TextSize = 10
HealthDesc.TextXAlignment = Enum.TextXAlignment.Left
HealthDesc.Parent = HealthFrame

local HealthBtn = Instance.new("TextButton")
HealthBtn.Text = "OFF"
HealthBtn.Size = UDim2.new(0.25, 0, 0, 30)
HealthBtn.Position = UDim2.new(0.75, -5, 0.5, -15)
HealthBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
HealthBtn.TextColor3 = Color3.white
HealthBtn.Font = Enum.Font.GothamBold
HealthBtn.TextSize = 12
HealthBtn.Parent = HealthFrame

HealthBtn.MouseButton1Click:Connect(function()
    local enabled = HealthBtn.Text == "OFF"
    
    if enabled then
        HealthBtn.Text = "ON"
        HealthBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        -- Set health
        local function SetHealth()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.MaxHealth = 1000
                    humanoid.Health = 1000
                    
                    -- Auto heal
                    humanoid.HealthChanged:Connect(function()
                        if HealthBtn.Text == "ON" and humanoid.Health < 1000 then
                            humanoid.Health = 1000
                        end
                    end)
                end
            end
        end
        
        SetHealth()
        LocalPlayer.CharacterAdded:Connect(SetHealth)
    else
        HealthBtn.Text = "OFF"
        HealthBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        
        -- Reset health
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.MaxHealth = 100
                humanoid.Health = 100
            end
        end
    end
end)

-- ========== BUTTON FUNCTIONS ==========
MinBtn.MouseButton1Click:Connect(function()
    if Main.Size == UDim2.new(0, 300, 0, 350) then
        Main.Size = UDim2.new(0, 300, 0, 40)
        FeaturesFrame.Visible = false
        Subtitle.Visible = false
        MinBtn.Text = "□"
    else
        Main.Size = UDim2.new(0, 300, 0, 350)
        FeaturesFrame.Visible = true
        Subtitle.Visible = true
        MinBtn.Text = "_"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ========== HOTKEY ==========
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)

-- ========== INIT MESSAGE ==========
print("========================================")
print("MIKAADEV DELTA EXECUTOR v5 LOADED")
print("SPECIFICALLY BUILT FOR YOUR GAME")
print("Based on debug output analysis")
print("TestingDevByMikaa")
print("========================================")
