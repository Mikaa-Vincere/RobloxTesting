-- MIKAA DEV TESTING EXPLOIT | Dueling Grounds | @Owner: Mikaa | No Bug 100%
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MikaaDev_DuelGrounds"
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

-- MAIN UI FRAME
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
Title.Text = "MIKAA DEV TESTING | Duel Grounds"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- CLOSE BTN
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

-- GODMODE TOGGLE
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

-- COINS TOGGLE
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

-- DAMAGE TOGGLE
local DmgBtn = Instance.new("TextButton")
DmgBtn.Size = UDim2.new(1, -20, 0, 45)
DmgBtn.Position = UDim2.new(0, 10, 0, 175)
DmgBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
DmgBtn.Text = "⚔️ Damage Realtime x10 : OFF"
DmgBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DmgBtn.TextScaled = true
DmgBtn.Font = Enum.Font.Gotham
DmgBtn.Parent = MainFrame
local DmgCorner = Instance.new("UICorner")
DmgCorner.CornerRadius = UDim.new(0, 8)
DmgCorner.Parent = DmgBtn

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

-- TOGGLES VARS
local GodEnabled = false
local CoinEnabled = false
local DmgEnabled = false
local DmgMulti = 10

-- UI FUNCTIONS
local function ToggleUI()
    MainFrame.Visible = not MainFrame.Visible
end
ToggleBtn.MouseButton1Click:Connect(ToggleUI)
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

-- GODMODE 500% LOOP
spawn(function()
    while task.wait(0.1) do
        if GodEnabled then
            local char = player.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char.Humanoid.MaxHealth = 500
                char.Humanoid.Health = 500
            end
        end
    end
end)

-- COINS 9999 LOOP
spawn(function()
    while task.wait(0.5) do
        if CoinEnabled then
            local stats = player:FindFirstChild("leaderstats")
            if stats then
                local coin = stats:FindFirstChild("Coins") or stats:FindFirstChild("Coin") or stats:FindFirstChild("Gems") or stats:FindFirstChild("Money")
                if coin then coin.Value = 9999 end
            end
        end
    end
end)

-- *** INI BAGIAN DAMAGE SENJATA REALTIME x10 - UBAH ANGKA 10 DI DmgMulti Kalo MAU LEBIH SADIS ***
local mt = getrawmetatable(game)
local oldnc = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if DmgEnabled and method == "FireServer" and (string.lower(self.Name):find("damage") or string.lower(self.Name):find("hit") or string.lower(self.Name):find("swing") or string.lower(self.Name):find("attack")) then
        *** INI BAGIAN MULTIPLY DAMAGE REALTIME - UBAH args[2]/args[3] KALO GA COCOK ***
        if typeof(args[2]) == "number" then args[2] = args[2] * DmgMulti end
        if typeof(args[3]) == "number" then args[3] = args[3] * DmgMulti end
        if typeof(args[4]) == "number" then args[4] = args[4] * DmgMulti end  -- Extra arg buat safety
    end
    return oldnc(self, unpack(args))
end)
setreadonly(mt, true)

-- BUTTON TOGGLES
GodBtn.MouseButton1Click:Connect(function()
    GodEnabled = not GodEnabled
    GodBtn.Text = "🛡️ Godmode 500% : " .. (GodEnabled and "ON" or "OFF")
    GodBtn.BackgroundColor3 = GodEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(40, 40, 45)
end)

CoinBtn.MouseButton1Click:Connect(function()
    CoinEnabled = not CoinEnabled
    CoinBtn.Text = "💰 Coins 9999 : " .. (CoinEnabled and "ON" or "OFF")
    CoinBtn.BackgroundColor3 = CoinEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(40, 40, 45)
end)

DmgBtn.MouseButton1Click:Connect(function()
    DmgEnabled = not DmgEnabled
    DmgBtn.Text = "⚔️ Damage Realtime x10 : " .. (DmgEnabled and "ON" or "OFF")
    DmgBtn.BackgroundColor3 = DmgEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(40, 40, 45)
end)

print("MIKAA DEV TESTING Loaded | Duel Grounds God | @Mikaa")
