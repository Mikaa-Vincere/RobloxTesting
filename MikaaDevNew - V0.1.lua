-- MIKAA DEV TESTING EXPLOIT V9 FINAL | Dueling Grounds | @Owner: Mikaa | SHOP BYPASS GRATIS + AURA GILA + AUTO EQUIP
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MikaaDev_DuelGroundsV9"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- LOGO TOGGLE
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Size = UDim2.new(0, 60, 0, 60)
ToggleBtn.Position = UDim2.new(0, 20, 0, 20)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Image = "rbxassetid://100166477433523"
ToggleBtn.ImageTransparency = 0.1
ToggleBtn.Parent = ScreenGui

-- MAIN UI
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 420)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(255, 50, 50)
UIStroke.Thickness = 2

-- TITLE
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "MIKAA DEV TESTING V9 | SHOP BYPASS GRATIS"
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
CloseBtn.Parent = MainFrame
local CloseCorner = Instance.new("UICorner", CloseBtn)
CloseCorner.CornerRadius = UDim.new(0, 8)

-- BTNS
local GodBtn = Instance.new("TextButton")
GodBtn.Size = UDim2.new(1, -20, 0, 40)
GodBtn.Position = UDim2.new(0, 10, 0, 65)
GodBtn.Text = "🛡️ Infinite Godmode : OFF"
GodBtn.Parent = MainFrame

local CoinBtn = Instance.new("TextButton")
CoinBtn.Size = UDim2.new(1, -20, 0, 40)
CoinBtn.Position = UDim2.new(0, 10, 0, 115)
CoinBtn.Text = "💰 Shop Bypass + Visual 999999 : OFF"
CoinBtn.Parent = MainFrame

local AuraBtn = Instance.new("TextButton")
AuraBtn.Size = UDim2.new(1, -20, 0, 40)
AuraBtn.Position = UDim2.new(0, 10, 0, 165)
AuraBtn.Text = "⚔️ Aura Gila x40 : OFF"
AuraBtn.Parent = MainFrame

local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Size = UDim2.new(1, -20, 0, 40)
SpeedBtn.Position = UDim2.new(0, 10, 0, 215)
SpeedBtn.Text = "🚀 Speed 70 : OFF"
SpeedBtn.Parent = MainFrame

local AutoEquipBtn = Instance.new("TextButton")
AutoEquipBtn.Size = UDim2.new(1, -20, 0, 40)
AutoEquipBtn.Position = UDim2.new(0, 10, 0, 265)
AutoEquipBtn.Text = "🗡️ Auto Equip OP Weapon : OFF"
AutoEquipBtn.Parent = MainFrame

local OwnerLbl = Instance.new("TextLabel")
OwnerLbl.Size = UDim2.new(1, 0, 0, 30)
OwnerLbl.Position = UDim2.new(0, 0, 1, -35)
OwnerLbl.BackgroundTransparency = 1
OwnerLbl.Text = "@Owner : Mikaa"
OwnerLbl.TextColor3 = Color3.fromRGB(255, 100, 100)
OwnerLbl.TextScaled = true
OwnerLbl.Parent = MainFrame

for _, btn in {GodBtn, CoinBtn, AuraBtn, SpeedBtn, AutoEquipBtn} do
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)
end

-- TOGGLES
local GodEnabled = false
local BypassEnabled = false
local AuraEnabled = false
local SpeedEnabled = false
local AutoEquipEnabled = false

local function ToggleUI()
    MainFrame.Visible = not MainFrame.Visible
end
ToggleBtn.MouseButton1Click:Connect(ToggleUI)
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

-- INFINITE GOD
local function setupGod(char)
    pcall(function()
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.MaxHealth = math.huge
            hum.Health = math.huge
            hum.HealthChanged:Connect(function() hum.Health = math.huge end)
        end
    end)
end
player.CharacterAdded:Connect(setupGod)
if player.Character then setupGod(player.Character) end

GodBtn.MouseButton1Click:Connect(function()
    GodEnabled = not GodEnabled
    GodBtn.Text = "🛡️ Infinite Godmode : " .. (GodEnabled and "ON" or "OFF")
    GodBtn.BackgroundColor3 = GodEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(40, 40, 45)
end)

-- SPEED
RunService.RenderStepped:Connect(function()
    if SpeedEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 70
    end
end)

SpeedBtn.MouseButton1Click:Connect(function()
    SpeedEnabled = not SpeedEnabled
    SpeedBtn.Text = "🚀 Speed 70 : " .. (SpeedEnabled and "ON" or "OFF")
    SpeedBtn.BackgroundColor3 = SpeedEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(40, 40, 45)
end)

-- SHOP BYPASS + VISUAL COIN
local oldnc
oldnc = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if BypassEnabled and method == "FireServer" and (self.Name:lower():find("buy") or self.Name:lower():find("purchase") or self.Name:lower():find("shop")) then
        if typeof(args[2]) == "number" then args[2] = 0 end  -- COST 0
        if typeof(args[3]) == "number" then args[3] = 0 end
    end
    return oldnc(self, unpack(args))
end)

RunService.Heartbeat:Connect(function()
    if BypassEnabled then
        pcall(function()
            local stats = player:FindFirstChild("leaderstats")
            if stats then
                for _, v in stats:GetChildren() do
                    if v:IsA("IntValue") or v:IsA("NumberValue") then
                        v.Value = 999999
                    end
                end
            end
        end)
    end
end)

CoinBtn.MouseButton1Click:Connect(function()
    BypassEnabled = not BypassEnabled
    CoinBtn.Text = "💰 Shop Bypass + Visual 999999 : " .. (BypassEnabled and "ON" or "OFF")
    CoinBtn.BackgroundColor3 = BypassEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(40, 40, 45)
end)

-- AUTO EQUIP OP WEAPON
spawn(function()
    while task.wait(1) do
        if AutoEquipEnabled and player.Backpack then
            pcall(function()
                local tool = player.Backpack:FindFirstChild("Naginata") or player.Backpack:FindFirstChild("Gauntlets") or player.Backpack:FindFirstChild("Pedang Ganda")
                if tool and player.Character then
                    player.Character.Humanoid:EquipTool(tool)
                end
            end)
        end
    end
end)

AutoEquipBtn.MouseButton1Click:Connect(function()
    AutoEquipEnabled = not AutoEquipEnabled
    AutoEquipBtn.Text = "🗡️ Auto Equip OP Weapon : " .. (AutoEquipEnabled and "ON" or "OFF")
    AutoEquipBtn.BackgroundColor3 = AutoEquipEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(40, 40, 45)
end)

-- AURA GILA x40
local function getRemote()
    if player.Character then
        local tool = player.Character:FindFirstChildOfClass("Tool")
        if tool then return tool:FindFirstChildWhichIsA("RemoteEvent") end
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
                        if dist < 40 then
                            remote:FireServer(obj.HumanoidRootPart.Position, "Light")
                            remote:FireServer(obj.HumanoidRootPart.Position, "Heavy")
                            remote:FireServer(obj.HumanoidRootPart.Position)
                        end
                    end
                end
            end
        end)
    end
end)

AuraBtn.MouseButton1Click:Connect(function()
    AuraEnabled = not AuraEnabled
    AuraBtn.Text = "⚔️ Aura Gila x40 : " .. (AuraEnabled and "ON" or "OFF")
    AuraBtn.BackgroundColor3 = AuraEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(40, 40, 45)
end)

print("MIKAA DEV TESTING V9 FINAL Loaded | SHOP BYPASS GRATIS + AURA GILA | @Mikaa")
