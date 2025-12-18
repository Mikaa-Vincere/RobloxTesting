-- =================================
-- MIKAADEV DELTA - COMPLETE WITH LOGIC
-- =================================

-- HAPUS UI LAMA
for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
    if gui.Name:find("MikaaDev") then
        gui:Destroy()
    end
end

-- VARIABEL
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

-- STATUS
local Hacks = {
    Coin = {Active = false, Value = 9999},
    Damage = {Active = false, Multiplier = 10},
    Health = {Active = false, BonusHP = 500},
    Speed = {Active = false, WalkSpeed = 50}
}

-- ========== UI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MikaaDev_Final"
ScreenGui.Parent = game.CoreGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 260, 0, 320)
Main.Position = UDim2.new(0.05, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
Main.BorderColor3 = Color3.fromRGB(0, 120, 255)
Main.BorderSizePixel = 2
Main.Active = true
Main.Draggable = true
Main.ZIndex = 1000
Main.Parent = ScreenGui

-- HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(0, 90, 180)
Header.ZIndex = 1001
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Text = "MikaaDev Delta"
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 1002
Title.Parent = Header

-- MINIMIZE BUTTON
local MinBtn = Instance.new("TextButton")
MinBtn.Text = "_"
MinBtn.Size = UDim2.new(0, 30, 0, 25)
MinBtn.Position = UDim2.new(1, -65, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
MinBtn.TextColor3 = Color3.white
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.ZIndex = 1002
MinBtn.Parent = Header

-- CLOSE BUTTON
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 30, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.TextColor3 = Color3.white
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 1002
CloseBtn.Parent = Header

-- SUBTITLE
local Subtitle = Instance.new("TextLabel")
Subtitle.Text = "TestingDevByMikaa"
Subtitle.Size = UDim2.new(1, 0, 0, 20)
Subtitle.Position = UDim2.new(0, 0, 0, 35)
Subtitle.BackgroundTransparency = 1
Subtitle.TextColor3 = Color3.fromRGB(150, 200, 255)
Subtitle.Font = Enum.Font.Code
Subtitle.TextSize = 10
Subtitle.ZIndex = 1001
Subtitle.Parent = Main

-- FEATURES
local FeaturesFrame = Instance.new("Frame")
FeaturesFrame.Size = UDim2.new(1, -10, 1, -70)
FeaturesFrame.Position = UDim2.new(0, 5, 0, 60)
FeaturesFrame.BackgroundTransparency = 1
FeaturesFrame.ZIndex = 1001
FeaturesFrame.Parent = Main

-- ========== LOGIC FUNCTIONS ==========
local function FindCoinValue()
    -- Cari coin di berbagai lokasi
    local locations = {
        LocalPlayer:FindFirstChild("leaderstats"),
        LocalPlayer:FindFirstChild("Stats"),
        LocalPlayer:FindFirstChild("Data"),
        LocalPlayer:FindFirstChild("PlayerStats")
    }
    
    for _, loc in pairs(locations) do
        if loc then
            for _, child in pairs(loc:GetChildren()) do
                local name = child.Name:lower()
                if (name:find("coin") or name:find("money") or name:find("uang")) and 
                   (child:IsA("IntValue") or child:IsA("NumberValue")) then
                    return child
                end
            end
        end
    end
    return nil
end

local function CoinHackLogic(enable)
    Hacks.Coin.Active = enable
    
    if enable then
        spawn(function()
            while Hacks.Coin.Active do
                -- METHOD 1: Direct value
                local coinObj = FindCoinValue()
                if coinObj then
                    coinObj.Value = Hacks.Coin.Value
                end
                
                -- METHOD 2: Hook remotes
                local remotes = RS:FindFirstChild("Remotes")
                if remotes then
                    local updateRemote = remotes:FindFirstChild("UpdatePlayerStats") or
                                        remotes:FindFirstChild("GeneralStatsUpdated")
                    
                    if updateRemote and updateRemote:IsA("RemoteEvent") then
                        local oldFire = updateRemote.FireServer
                        updateRemote.FireServer = function(self, ...)
                            local args = {...}
                            if type(args[1]) == "table" then
                                for key, val in pairs(args[1]) do
                                    if tostring(key):lower():find("coin") then
                                        args[1][key] = Hacks.Coin.Value
                                    end
                                end
                            end
                            return oldFire(self, unpack(args))
                        end
                    end
                end
                
                wait(0.5)
            end
        end)
    end
end

local function DamageHackLogic(enable)
    Hacks.Damage.Active = enable
    
    if enable then
        -- Cari QueueBasicAttack remote (dari debug lu)
        local remotes = RS:FindFirstChild("Remotes")
        if remotes then
            local playerChar = remotes:FindFirstChild("PlayerCharacter")
            if playerChar then
                local request = playerChar:FindFirstChild("Request")
                if request then
                    local queueAttack = request:FindFirstChild("QueueBasicAttack")
                    
                    if queueAttack and queueAttack:IsA("RemoteEvent") then
                        local oldFire = queueAttack.FireServer
                        queueAttack.FireServer = function(self, ...)
                            local args = {...}
                            -- Multiply damage numbers
                            for i, v in ipairs(args) do
                                if type(v) == "number" and v > 0 and v < 1000 then
                                    args[i] = v * Hacks.Damage.Multiplier
                                end
                            end
                            return oldFire(self, unpack(args))
                        end
                    end
                end
            end
        end
    end
end

local function HealthHackLogic(enable)
    Hacks.Health.Active = enable
    
    local function ApplyHealth()
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                if enable then
                    humanoid.MaxHealth = 1000
                    humanoid.Health = 1000
                    
                    -- Auto regen
                    humanoid.HealthChanged:Connect(function()
                        if Hacks.Health.Active and humanoid.Health < 1000 then
                            humanoid.Health = 1000
                        end
                    end)
                else
                    humanoid.MaxHealth = 100
                    humanoid.Health = 100
                end
            end
        end
    end
    
    ApplyHealth()
    LocalPlayer.CharacterAdded:Connect(ApplyHealth)
end

local function SpeedHackLogic(enable)
    Hacks.Speed.Active = enable
    
    local function ApplySpeed()
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                if enable then
                    humanoid.WalkSpeed = Hacks.Speed.WalkSpeed
                    humanoid.JumpPower = 75
                else
                    humanoid.WalkSpeed = 16
                    humanoid.JumpPower = 50
                end
            end
        end
    end
    
    ApplySpeed()
    LocalPlayer.CharacterAdded:Connect(ApplySpeed)
end

-- ========== CREATE FEATURE BUTTONS ==========
local featureY = 0
local featureHeight = 55

local function CreateFeatureBtn(name, desc, logicFunc)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, featureHeight)
    Frame.Position = UDim2.new(0, 0, 0, featureY)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 1002
    Frame.Parent = FeaturesFrame
    
    local Label = Instance.new("TextLabel")
    Label.Text = name
    Label.Size = UDim2.new(0.65, 0, 0, 25)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(200, 220, 255)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 1003
    Label.Parent = Frame
    
    local Desc = Instance.new("TextLabel")
    Desc.Text = desc
    Desc.Size = UDim2.new(0.65, 0, 0, 20)
    Desc.Position = UDim2.new(0, 10, 0, 30)
    Desc.BackgroundTransparency = 1
    Desc.TextColor3 = Color3.fromRGB(150, 180, 220)
    Desc.Font = Enum.Font.Code
    Desc.TextSize = 10
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.ZIndex = 1003
    Desc.Parent = Frame
    
    local Btn = Instance.new("TextButton")
    Btn.Text = "OFF"
    Btn.Size = UDim2.new(0.3, 0, 0, 30)
    Btn.Position = UDim2.new(0.7, -5, 0.5, -15)
    Btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    Btn.TextColor3 = Color3.white
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Btn.ZIndex = 1003
    Btn.Parent = Frame
    
    Btn.MouseButton1Click:Connect(function()
        local enable = Btn.Text == "OFF"
        
        if enable then
            Btn.Text = "ON"
            Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        else
            Btn.Text = "OFF"
            Btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        end
        
        -- Execute logic
        if logicFunc then
            logicFunc(enable)
        end
    end)
    
    featureY = featureY + featureHeight + 5
    return Btn
end

-- BUAT 4 FITUR
CreateFeatureBtn("COIN", "Set to 9999 (Realtime)", CoinHackLogic)
CreateFeatureBtn("DAMAGE", "Katana x10 Damage", DamageHackLogic)
CreateFeatureBtn("HEALTH", "+500 HP Auto-Regen", HealthHackLogic)
CreateFeatureBtn("SPEED", "3x Movement Speed", SpeedHackLogic)

-- ========== UI CONTROLS ==========
local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        Main.Size = UDim2.new(0, 260, 0, 35)
        FeaturesFrame.Visible = false
        Subtitle.Visible = false
        MinBtn.Text = "□"
    else
        Main.Size = UDim2.new(0, 260, 0, 320)
        FeaturesFrame.Visible = true
        Subtitle.Visible = true
        MinBtn.Text = "_"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)

-- ========== STARTUP MESSAGE ==========
print("========================================")
print("MIKAADEV DELTA - COMPLETE VERSION")
print("UI + LOGIC LOADED!")
print("Minimize: _ | Close: X | Hide: RightShift")
print("TestingDevByMikaa")
print("========================================")

-- Force UI to front
Main.Parent = ScreenGui
