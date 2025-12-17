--// Mikaa Style UI Base
--// Owner / Creator: Mikaa Dev (UI only)
--// Logo: rbxassetid://100166477433523

-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MikaaUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.new(0, 360, 0, 420)
Main.Position = UDim2.new(0.65, 0, 0.18, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

-- Corner
local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 12)

-- Header
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 42)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Header.BorderSizePixel = 0

local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 12)

-- Logo
local Logo = Instance.new("ImageLabel", Header)
Logo.Size = UDim2.new(0, 28, 0, 28)
Logo.Position = UDim2.new(0, 8, 0.5, -14)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://100166477433523"

-- Title
local Title = Instance.new("TextLabel", Header)
Title.Text = "Mikaa Dev Testing"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 44, 0, 0)
Title.Size = UDim2.new(1, -44, 1, 0)
Title.TextXAlignment = Left

-- Owner (small)
local Owner = Instance.new("TextLabel", Main)
Owner.Text = "UI by Mikaa"
Owner.Font = Enum.Font.Gotham
Owner.TextSize = 10
Owner.TextColor3 = Color3.fromRGB(150,150,150)
Owner.BackgroundTransparency = 1
Owner.Position = UDim2.new(0, 10, 1, -18)
Owner.Size = UDim2.new(1, -20, 0, 14)
Owner.TextXAlignment = Left

-- Content
local Content = Instance.new("Frame", Main)
Content.Position = UDim2.new(0, 0, 0, 50)
Content.Size = UDim2.new(1, 0, 1, -74)
Content.BackgroundTransparency = 1

-- Example Toggle
local function CreateToggle(text, yPos)
    local Btn = Instance.new("TextButton", Content)
    Btn.Size = UDim2.new(1, -20, 0, 36)
    Btn.Position = UDim2.new(0, 10, 0, yPos)
    Btn.Text = text .. " : OFF"
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 13
    Btn.TextColor3 = Color3.fromRGB(255,255,255)
    Btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Btn.BorderSizePixel = 0

    local c = Instance.new("UICorner", Btn)
    c.CornerRadius = UDim.new(0,8)

    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.Text = text .. (state and " : ON" or " : OFF")
    end)
end

-- Dummy features (placeholder)
CreateToggle("Speed Player", 0)
CreateToggle("Speed Fly", 46)
CreateToggle("Fly", 92)
CreateToggle("Noclip", 138)

-- Notification Box
local Notify = Instance.new("TextLabel", Content)
Notify.Size = UDim2.new(1, -20, 0, 40)
Notify.Position = UDim2.new(0, 10, 0, 190)
Notify.BackgroundColor3 = Color3.fromRGB(25,25,25)
Notify.Text = "NOTIFICATION\nLagi belajar bang, jangan di bully"
Notify.TextSize = 12
Notify.Font = Enum.Font.Gotham
Notify.TextColor3 = Color3.fromRGB(200,200,200)
Notify.BorderSizePixel = 0
Notify.TextWrapped = true

local nc = Instance.new("UICorner", Notify)
nc.CornerRadius = UDim.new(0,8)

--// End UI Base
--// Feature logic akan ditambahkan satu per satu sesuai permintaan
