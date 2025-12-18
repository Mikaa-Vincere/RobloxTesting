-- MIKAA DEV TESTING EXPLOIT V7 | Dueling Grounds | @Owner: Mikaa | REALTIME COIN VISUAL + REAL CODES + DAMAGE GILA KERASA
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MikaaDev_DuelGroundsV7"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- LOGO MINI TOGGLE
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Size = UDim2.new(0, 60, 0, 60)
ToggleBtn.Position = UDim2.new(0, 20, 0, 20)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Image = "rbxassetid://100166477433523"
ToggleBtn.ImageTransparency = 0.1
ToggleBtn.Parent = ScreenGui

-- MAIN UI BESAR
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 380)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -190)
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
Title.Text = "MIKAA DEV TESTING V7 | Realtime Coin + Gila Damage"
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

-- GOD INFINITE
local GodBtn = Instance.new("TextButton")
GodBtn.Size = UDim2.new(1, -20, 0, 40)
GodBtn.Position = UDim2.new(0, 10, 0, 65)
GodBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
GodBtn.Text = "🛡️ Infinite Godmode : OFF"
GodBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GodBtn.TextScaled = true
GodBtn.Font = Enum.Font.Gotham
GodBtn.Parent = MainFrame

-- COIN REALTIME + CODES
local CoinBtn = Instance.new("TextButton")
CoinBtn.Size = UDim2.new(1, -20, 0, 40)
CoinBtn.Position = UDim2.new(0, 10, 0, 115)
CoinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
CoinBtn.Text = "💰 Realtime 999999 + Real Codes : OFF"
CoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CoinBtn.TextScaled = true
CoinBtn.Font = Enum.Font.Gotham
CoinBtn.Parent = MainFrame

-- AURA GILA
local AuraBtn = Instance.new("TextButton")
AuraBtn.Size = UDim2.new(1, -20, 0, 40)
AuraBtn.Position = UDim2.new(0, 10, 0, 165)
AuraBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
AuraBtn.Text = "⚔️ Aura Gila x30 : OFF"
AuraBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AuraBtn.TextScaled = true
AuraBtn.Font = Enum.Font.Gotham
AuraBtn.Parent = MainFrame

-- SPEED
local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Size = UDim2.new(1, -20, 0, 40)
SpeedBtn.Position = UDim2.new(0, 10, 0, 215)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
SpeedBtn.Text = "🚀 Speed 60 : OFF"
SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBtn.TextScaled = true
SpeedBtn.Font = Enum.Font.Gotham
SpeedBtn.Parent = MainFrame

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
local SpeedEnabled = false

local function ToggleUI()
    MainFrame.Visible = not MainFrame.Visible
end
ToggleBtn.MouseButton1Click:Connect(ToggleUI)
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

-- INFINITE GOD
local function setupGod(char)
    pcall(function()
        local hum = char:WaitForChild("Humanoid")
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        RunService.Heartbeat:Connect(function()
            if GodEnabled then hum.Health = math.huge end
        end)
    end)
end
player.CharacterAdded:Connect(setupGod)
if player.Character then setupGod(player.Character) end

GodBtn.MouseButton1Click:Connect(function()
    GodEnabled = not GodEnabled
    GodBtn.Text = "🛡️ Infinite Godmode : " .. (GodEnabled and "ON" or "OFF")
    GodBtn.BackgroundColor3 = GodEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(40, 40, 45)
end)

-- SPEED 60
RunService.RenderStepped:Connect(function()
    if SpeedEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 60
    end
end)

SpeedBtn.MouseButton1Click:Connect(function()
    SpeedEnabled = not SpeedEnabled
    SpeedBtn.Text = "🚀 Speed 60 : " .. (SpeedEnabled and "ON" or "OFF")
    SpeedBtn.BackgroundColor3 = SpeedEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(40, 40, 45)
end)

-- REALTIME COIN 999999 + AUTO REDEEM REAL CODES
local realCodes = {"OneMillionFavorites", "GauntletsUpdate", "WingTheGoat", "FirstSpecialCode"}
local redeemed = {}

local function autoRedeem()
    pcall(function()
        local redeemRemote = ReplicatedStorage:FindFirstChildWhichIsA("RemoteEvent", true) -- cari generic
        if redeemRemote and redeemRemote.Name:lower():find("redeem") or redeemRemote.Name:lower():find("code") then
            for _, code in realCodes do
                if not redeemed[code] then
                    redeemRemote:FireServer(code)
                    redeemed[code] = true
                    task.wait(1)
                end
            end
        end
    end)
end

RunService.Heartbeat:Connect(function()
    if CoinEnabled then
        pcall(function()
            local stats = player:FindFirstChild("leaderstats")
            if stats then
                for _, v in stats:GetChildren() do
                    if v:IsA("IntValue") or v:IsA("NumberValue") then
                        v.Value = 999999 -- REALTIME VISUAL
                    end
                end
            end
        end)
    end
end)

CoinBtn.MouseButton1Click:Connect(function()
    CoinEnabled = not CoinEnabled
    CoinBtn.Text = "💰 Realtime 999999 + Real Codes : " .. (CoinEnabled and "ON" or "OFF")
    CoinBtn.BackgroundColor3 = CoinEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(40, 40, 45)
    if CoinEnabled then autoRedeem() end
end)

-- AURA GILA x30
local function getRemote()
    if player.Character then
        local tool = player.Character:FindFirstChildOfClass("Tool")
        if tool then
            return tool:FindFirstChildWhichIsA("RemoteEvent")
        end
    end
    return nil
end

RunService.Heartbeat:Connect(function()
    if AuraEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        pcall(function()
            local myPos = player.Character.HumanoidRootPart.Position
            local remote = getRemote()
            if remote then
                for _, obj in Workspace:GetChildren() do
                    if obj ~= player.Character and obj:FindFirstChild("HumanoidRootPart") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                        local dist = (obj.HumanoidRootPart.Position - myPos).Magnitude
                        if dist < 35 then
                            remote:FireServer(obj.HumanoidRootPart.Position, "Light")
                            remote:FireServer(obj.HumanoidRootPart.Position, "Heavy")
                            remote:FireServer(obj.HumanoidRootPart.Position) -- EXTRA SADIS
                        end
                    end
                end
            end
        end)
    end
end)

AuraBtn.MouseButton1Click:Connect(function()
    AuraEnabled = not AuraEnabled
    AuraBtn.Text = "⚔️ Aura Gila x30 : " .. (AuraEnabled and "ON" or "OFF")
    AuraBtn.BackgroundColor3 = AuraEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(40, 40, 45)
end)

print("MIKAA DEV TESTING V7 REALTIME Loaded | Coin Visual Instan + Real Codes + Damage Gila | @Mikaa")
