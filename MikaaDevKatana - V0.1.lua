-- MIKAA DEV TESTING EXPLOIT V3 | Dueling Grounds | @Owner: Mikaa | BALANCE DAMAGE KERASA DIKIT
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MikaaDev_DuelGroundsV3"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- LOGO MINI TOGGLE
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Name = "Toggle"
ToggleBtn.Size = UDim2.new(0, 60, 0, 60)
ToggleBtn.Position = UDim2.new(0, 20, 0, 20)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Image = "rbxassetid://100166477433523"
ToggleBtn.ImageTransparency = 0.1
ToggleBtn.Parent = ScreenGui

-- MAIN UI
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 320, 0, 280)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 50, 50)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- TITLE
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "MIKAA DEV TESTING V3 | Balance Damage"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- CLOSE
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -50, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- GODMODE
local GodBtn = Instance.new("TextButton")
GodBtn.Size = UDim2.new(1, -20, 0, 45)
GodBtn.Position = UDim2.new(0, 10, 0, 65)
GodBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
GodBtn.Text = "🛡️ Godmode 500% : OFF"
GodBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GodBtn.TextScaled = true
GodBtn.Font = Enum.Font.Gotham
GodBtn.Parent = MainFrame
local GodCorner = Instance.new("UICorner")
GodCorner.CornerRadius = UDim.new(0, 8)
GodCorner.Parent = GodBtn

-- COINS
local CoinBtn = Instance.new("TextButton")
CoinBtn.Size = UDim2.new(1, -20, 0, 45)
CoinBtn.Position = UDim2.new(0, 10, 0, 120)
CoinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
CoinBtn.Text = "💰 Coins 9999 : OFF"
CoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CoinBtn.TextScaled = true
CoinBtn.Font = Enum.Font.Gotham
CoinBtn.Parent = MainFrame
local CoinCorner = Instance.new("UICorner")
CoinCorner.CornerRadius = UDim.new(0, 8)
CoinCorner.Parent = CoinBtn

-- BALANCE AURA (KERASA DIKIT x3 DAMAGE)
local AuraBtn = Instance.new("TextButton")
AuraBtn.Size = UDim2.new(1, -20, 0, 45)
AuraBtn.Position = UDim2.new(0, 10, 0, 175)
AuraBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
AuraBtn.Text = "⚔️ Balance Aura (x3 Kerasa) : OFF"
AuraBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AuraBtn.TextScaled = true
AuraBtn.Font = Enum.Font.Gotham
AuraBtn.Parent = MainFrame
local AuraCorner = Instance.new("UICorner")
AuraCorner.CornerRadius = UDim.new(0, 8)
AuraCorner.Parent = AuraBtn

-- OWNER
local OwnerLbl = Instance.new("TextLabel")
OwnerLbl.Size = UDim2.new(1, 0, 0, 30)
OwnerLbl.Position = UDim2.new(0, 0, 1, -35)
OwnerLbl.BackgroundTransparency = 1
OwnerLbl.Text = "@Owner : Mikaa"
OwnerLbl.TextColor3 = Color3.fromRGB(255, 100, 100)
OwnerLbl.TextScaled = true
OwnerLbl.Font = Enum.Font.Gotham
OwnerLbl.Parent = MainFrame

-- TOGGLES
local GodEnabled = false
local CoinEnabled = false
local AuraEnabled = false

-- UI TOGGLE
local function ToggleUI() MainFrame.Visible = not MainFrame.Visible end
ToggleBtn.MouseButton1Click:Connect(ToggleUI)
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

-- GODMODE SAFE
local function setupGodmode(char)
    if char then
        pcall(function()
            local hum = char:WaitForChild("Humanoid", 5)
            if hum then
                hum.MaxHealth = 500
                hum.Health = 500
                hum.HealthChanged:Connect(function()
                    if hum.Health < 500 then hum.Health = 500 end
                end)
            end
        end)
    end
end
player.CharacterAdded:Connect(setupGodmode)
if player.Character then setupGodmode(player.Character) end

GodBtn.MouseButton1Click:Connect(function()
    GodEnabled = not GodEnabled
    GodBtn.Text = "🛡️ Godmode 500% : " .. (GodEnabled and "ON" or "OFF")
    GodBtn.BackgroundColor3 = GodEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(40, 40, 45)
end)

-- COINS SAFE
spawn(function()
    while task.wait(0.5) do
        if CoinEnabled then
            pcall(function()
                local stats = player:FindFirstChild("leaderstats")
                if stats then
                    for _, v in pairs(stats:GetChildren()) do
                        if v:IsA("IntValue") or v:IsA("NumberValue") then
                            v.Value = 9999
                        end
                    end
                end
            end)
        end
    end
end)

CoinBtn.MouseButton1Click:Connect(function()
    CoinEnabled = not CoinEnabled
    CoinBtn.Text = "💰 Coins 9999 : " .. (CoinEnabled and "ON" or "OFF")
    CoinBtn.BackgroundColor3 = CoinEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(40, 40, 45)
end)

-- BALANCE AURA REALTIME (KERASA DIKIT - DELAY + LIGHT HIT)
local lastHit = tick()
spawn(function()
    while task.wait(0.1) do
        if AuraEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local myPos = player.Character.HumanoidRootPart.Position
                local tool = player.Character:FindFirstChildOfClass("Tool")
                local remote = tool and (tool:FindFirstChild("Swing") or tool:FindFirstChild("Attack") or tool:FindFirstChildWhichIsA("RemoteEvent"))
                if remote and tick() - lastHit > 0.3 then  -- DELAY BIAR KERASA
                    for _, obj in pairs(Workspace:GetChildren()) do
                        if obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") and obj ~= player.Character and obj.Humanoid.Health > 0 then
                            local dist = (obj.HumanoidRootPart.Position - myPos).Magnitude
                            if dist < 20 then
                                remote:FireServer(obj.HumanoidRootPart.Position)  -- LIGHT HIT POS
                                lastHit = tick()
                                break  -- SATU HIT PER LOOP BIAR BALANCE
                            end
                        end
                    end
                end
            end)
        end
    end
end)

AuraBtn.MouseButton1Click:Connect(function()
    AuraEnabled = not AuraEnabled
    AuraBtn.Text = "⚔️ Balance Aura (x3 Kerasa) : " .. (AuraEnabled and "ON" or "OFF")
    AuraBtn.BackgroundColor3 = AuraEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(40, 40, 45)
end)

print("MIKAA DEV TESTING V3 Loaded | Balance Kerasa Dikit + God + Coins | @Mikaa")
