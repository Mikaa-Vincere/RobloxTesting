-- =================================
-- MIKAADEV DELTA - GAME SPECIFIC FIX
-- =================================
-- Berdasarkan error log lu

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
local Controllers = RS:FindFirstChild("Controllers")

-- ========== SIMPLE UI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MikaaDev_Working"
ScreenGui.Parent = game.CoreGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 250, 0, 300)
Main.Position = UDim2.new(0, 20, 0, 100)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
Main.BorderColor3 = Color3.fromRGB(0, 120, 255)
Main.BorderSizePixel = 2
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

-- HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(0, 90, 180)
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Text = "MikaaDev Delta"
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.white
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- MINIMIZE BUTTON
local MinBtn = Instance.new("TextButton")
MinBtn.Text = "_"
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -55, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
MinBtn.TextColor3 = Color3.white
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 16
MinBtn.Parent = Header

-- CLOSE BUTTON
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -25, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.TextColor3 = Color3.white
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header

-- FEATURES
local Features = Instance.new("Frame")
Features.Size = UDim2.new(1, -10, 1, -60)
Features.Position = UDim2.new(0, 5, 0, 40)
Features.BackgroundTransparency = 1
Features.Parent = Main

-- ========== GAME SPECIFIC HACKS ==========

-- 1. COIN HACK (MENCARI DI STATS)
local function CoinHack()
    local btn = Instance.new("TextButton")
    btn.Text = "COIN: OFF"
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    btn.TextColor3 = Color3.white
    btn.Font = Enum.Font.GothamBold
    btn.Parent = Features
    
    local active = false
    
    btn.MouseButton1Click:Connect(function()
        active = not active
        
        if active then
            btn.Text = "COIN: ON"
            btn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
            
            spawn(function()
                while active do
                    -- Cari semua IntValue/NumberValue dengan nama coin
                    for _, obj in pairs(game:GetDescendants()) do
                        if (obj:IsA("IntValue") or obj:IsA("NumberValue")) then
                            local name = obj.Name:lower()
                            if name:find("coin") or name:find("money") or name:find("uang") then
                                obj.Value = 9999
                            end
                        end
                    end
                    
                    -- Coba cari di PlayerGui
                    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                    if playerGui then
                        for _, frame in pairs(playerGui:GetDescendants()) do
                            if frame:IsA("TextLabel") or frame:IsA("TextButton") then
                                local text = frame.Text
                                if text and (text:find("Coin") or text:find("coin")) then
                                    frame.Text = "9999"
                                end
                            end
                        end
                    end
                    
                    wait(0.5)
                end
            end)
        else
            btn.Text = "COIN: OFF"
            btn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
        end
    end)
end

-- 2. DAMAGE HACK (UNTUK KATANA - BERDASARKAN ERROR LOG)
local function DamageHack()
    local btn = Instance.new("TextButton")
    btn.Text = "DAMAGE: OFF"
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    btn.TextColor3 = Color3.white
    btn.Font = Enum.Font.GothamBold
    btn.Parent = Features
    
    local active = false
    
    btn.MouseButton1Click:Connect(function()
        active = not active
        
        if active then
            btn.Text = "DAMAGE: ON"
            btn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
            
            -- CARI CONTROLLER UNTUK DAMAGE (dari error log)
            if Controllers then
                local charController = Controllers:FindFirstChild("GkaracterController") or
                                      Controllers:FindFirstChild("CharacterController")
                
                if charController then
                    local baseClient = charController:FindFirstChild("BaseCharacterClient")
                    
                    if baseClient then
                        -- Backup original script
                        local original = baseClient:Clone()
                        original.Name = "OriginalScript"
                        original.Parent = baseClient.Parent
                        
                        -- Modify damage values
                        local source = baseClient.Source
                        
                        -- Ganti damage multiplier (dari error: "+30%")
                        source = source:gsub("%+%d+%%", "+300%")  -- 30% jadi 300%
                        source = source:gsub("damage%s*=%s*%d+", "damage = damage * 10")
                        source = source:gsub("Damage%s*=%s*%d+", "Damage = Damage * 10")
                        
                        baseClient.Source = source
                        print("[MIKAADEV] Damage script modified!")
                    end
                end
            end
            
            -- JUGA HOOK REMOTE EVENTS
            for _, remote in pairs(RS:GetDescendants()) do
                if remote:IsA("RemoteEvent") then
                    local name = remote.Name:lower()
                    if name:find("attack") or name:find("damage") or name:find("hit") then
                        local oldFire = remote.FireServer
                        remote.FireServer = function(self, ...)
                            local args = {...}
                            for i, v in ipairs(args) do
                                if type(v) == "number" and v > 0 then
                                    args[i] = v * 10
                                elseif type(v) == "table" then
                                    for k, val in pairs(v) do
                                        if type(val) == "number" and val > 0 then
                                            v[k] = val * 10
                                        end
                                    end
                                end
                            end
                            return oldFire(self, unpack(args))
                        end
                    end
                end
            end
        else
            btn.Text = "DAMAGE: OFF"
            btn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
            
            -- Restore original script
            if Controllers then
                local charController = Controllers:FindFirstChild("GkaracterController")
                if charController then
                    local original = charController:FindFirstChild("OriginalScript")
                    local baseClient = charController:FindFirstChild("BaseCharacterClient")
                    
                    if original and baseClient then
                        baseClient.Source = original.Source
                        original:Destroy()
                    end
                end
            end
        end
    end)
end

-- 3. SPEED HACK
local function SpeedHack()
    local btn = Instance.new("TextButton")
    btn.Text = "SPEED: OFF"
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, 90)
    btn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    btn.TextColor3 = Color3.white
    btn.Font = Enum.Font.GothamBold
    btn.Parent = Features
    
    local active = false
    
    btn.MouseButton1Click:Connect(function()
        active = not active
        
        if active then
            btn.Text = "SPEED: ON"
            btn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
            
            local function SetSpeed()
                if LocalPlayer.Character then
                    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = 50
                        humanoid.JumpPower = 75
                    end
                end
            end
            
            SetSpeed()
            LocalPlayer.CharacterAdded:Connect(SetSpeed)
        else
            btn.Text = "SPEED: OFF"
            btn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
            
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 16
                    humanoid.JumpPower = 50
                end
            end
        end
    end)
end

-- 4. HEALTH HACK
local function HealthHack()
    local btn = Instance.new("TextButton")
    btn.Text = "HEALTH: OFF"
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, 135)
    btn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    btn.TextColor3 = Color3.white
    btn.Font = Enum.Font.GothamBold
    btn.Parent = Features
    
    local active = false
    
    btn.MouseButton1Click:Connect(function()
        active = not active
        
        if active then
            btn.Text = "HEALTH: ON"
            btn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
            
            local function SetHealth()
                if LocalPlayer.Character then
                    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.MaxHealth = 1000
                        humanoid.Health = 1000
                        
                        humanoid.HealthChanged:Connect(function()
                            if active and humanoid.Health < 1000 then
                                humanoid.Health = 1000
                            end
                        end)
                    end
                end
            end
            
            SetHealth()
            LocalPlayer.CharacterAdded:Connect(SetHealth)
        else
            btn.Text = "HEALTH: OFF"
            btn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
            
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.MaxHealth = 100
                    humanoid.Health = 100
                end
            end
        end
    end)
end

-- INITIALIZE HACKS
CoinHack()
DamageHack()
SpeedHack()
HealthHack()

-- ========== UI CONTROLS ==========
MinBtn.MouseButton1Click:Connect(function()
    if Main.Size.Y.Offset == 300 then
        Main.Size = UDim2.new(0, 250, 0, 35)
        Features.Visible = false
        MinBtn.Text = "□"
    else
        Main.Size = UDim2.new(0, 250, 0, 300)
        Features.Visible = true
        MinBtn.Text = "_"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- HOTKEY
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)

-- MESSAGE
print("========================================")
print("MIKAADEV DELTA - GAME SPECIFIC VERSION")
print("Based on your error log analysis")
print("TestingDevByMikaa")
print("========================================")
