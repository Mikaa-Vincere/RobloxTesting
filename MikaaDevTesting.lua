--// Mikaa Style UI Base
--// Owner / Creator: Mikaa Dev (UI only)

-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ScreenGui
-- Anti Double Execute
if player:WaitForChild("PlayerGui"):FindFirstChild("MikaaUI") then
    return
end

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

-- Logo Toggle Button (small)
local LogoBtn = Instance.new("TextButton")
LogoBtn.Size = UDim2.new(0, 36, 0, 36)
LogoBtn.Position = UDim2.new(0, 10, 0, 50)
LogoBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
LogoBtn.Text = ""
LogoBtn.Parent = ScreenGui

local lc = Instance.new("UICorner", LogoBtn)
lc.CornerRadius = UDim.new(0,6)

local smallLogo = Instance.new("ImageLabel", LogoBtn)
smallLogo.Size = UDim2.new(1, -4, 1, -4)
smallLogo.Position = UDim2.new(0, 2, 0, 2)
smallLogo.BackgroundTransparency = 1
smallLogo.Image = "rbxassetid://100166477433523"

-- Toggle Main visibility
LogoBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

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
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Owner (small)
local Owner = Instance.new("TextLabel", Main)
Owner.Text = "MikaaDevTesting"
Owner.Font = Enum.Font.Gotham
Owner.TextSize = 8
Owner.TextColor3 = Color3.fromRGB(130,130,130)
Owner.BackgroundTransparency = 1
Owner.Position = UDim2.new(0, 10, 1, -16)
Owner.Size = UDim2.new(1, -20, 0, 12)
Owner.TextXAlignment = Enum.TextXAlignment.Left

-- Content
local Content = Instance.new("Frame", Main)
Content.Position = UDim2.new(0, 0, 0, 50)
Content.Size = UDim2.new(1, 0, 1, -74)
Content.BackgroundTransparency = 1

-- Player refs
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Toggle builder with callback
    local function CreateToggle(text, yPos, callback)
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
        if callback then callback(state) end
    end)
end

-- Mobile Slider Builder (Android friendly)
local UIS = game:GetService("UserInputService")
local function CreateSlider(label, yPos, min, max, default, onChange)
    local Holder = Instance.new("Frame", Content)
    Holder.Size = UDim2.new(1, -20, 0, 44)
    Holder.Position = UDim2.new(0, 10, 0, yPos)
    Holder.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Holder.BorderSizePixel = 0
    local hc = Instance.new("UICorner", Holder)
    hc.CornerRadius = UDim.new(0,8)

    local Text = Instance.new("TextLabel", Holder)
    Text.BackgroundTransparency = 1
    Text.Size = UDim2.new(1, -12, 0, 16)
    Text.Position = UDim2.new(0, 6, 0, 4)
    Text.Font = Enum.Font.Gotham
    Text.TextSize = 12
    Text.TextColor3 = Color3.fromRGB(220,220,220)
    Text.TextXAlignment = Enum.TextXAlignment.Left

    local Bar = Instance.new("Frame", Holder)
    Bar.Size = UDim2.new(1, -12, 0, 8)
    Bar.Position = UDim2.new(0, 6, 0, 28)
    Bar.BackgroundColor3 = Color3.fromRGB(55,55,55)
    Bar.BorderSizePixel = 0
    local bc = Instance.new("UICorner", Bar)
    bc.CornerRadius = UDim.new(1,0)

    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(180,180,180)
    Fill.BorderSizePixel = 0
    local fc = Instance.new("UICorner", Fill)
    fc.CornerRadius = UDim.new(1,0)

    local value = default
    local function setByX(x)
        local pct = math.clamp((x - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * pct)
        Fill.Size = UDim2.new(pct, 0, 1, 0)
        Text.Text = label .. ": " .. tostring(value)
        if onChange then onChange(value) end
    end

    Text.Text = label .. ": " .. tostring(default)
    Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)

    local dragging = false
    Bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            setByX(i.Position.X)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
            setByX(i.Position.X)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- SPEED PLAYER
local defaultSpeed = humanoid.WalkSpeed
local speedValue = 32
CreateToggle("Speed Player", 0, function(on)
    humanoid.WalkSpeed = on and speedValue or defaultSpeed
end)
CreateSlider("Speed Player", 46, 16, 100, speedValue, function(v)
    speedValue = v
    if humanoid.WalkSpeed ~= defaultSpeed then humanoid.WalkSpeed = v end
end)

-- SPEED FLY (mobile)
local flySpeed = 60
CreateToggle("Speed Fly", 100, function(on)
    flySpeed = on and flySpeed or flySpeed
end)
CreateSlider("Speed Fly", 146, 40, 200, flySpeed, function(v)
    flySpeed = v
end)

-- JUMP PLAYER
local defaultJump = humanoid.JumpPower
local jumpValue = 80
CreateToggle("Jump Player", 200, function(on)
    humanoid.JumpPower = on and jumpValue or defaultJump
end)
CreateSlider("Jump Player", 246, 50, 150, jumpValue, function(v)
    jumpValue = v
    if humanoid.JumpPower ~= defaultJump then humanoid.JumpPower = v end
end)

-- FLY BUTTON (basic bodyvelocity)
local flying = false
local bv
CreateToggle("Fly", 138, function(on)
    flying = on
    if on then
        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        bv.Velocity = Vector3.new(0, flySpeed, 0)
        bv.Parent = character:WaitForChild("HumanoidRootPart")
    else
        if bv then bv:Destroy() bv = nil end
    end
end)

-- NOCLIP
local noclipConn
CreateToggle("Noclip", 184, function(on)
    if on then
        noclipConn = game:GetService("RunService").Stepped:Connect(function()
            for _,v in pairs(character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
        for _,v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    end
end)

-- NOTIFICATION PANEL (Mobile)
local NotifPanel = Instance.new("Frame", Content)
NotifPanel.Size = UDim2.new(1, -20, 0, 180)
NotifPanel.Position = UDim2.new(0, 10, 0, 300)
NotifPanel.BackgroundColor3 = Color3.fromRGB(25,25,25)
NotifPanel.BorderSizePixel = 0
local npc = Instance.new("UICorner", NotifPanel)
npc.CornerRadius = UDim.new(0,8)

-- Title
local NTitle = Instance.new("TextLabel", NotifPanel)
NTitle.Size = UDim2.new(1, -10, 0, 18)
NTitle.Position = UDim2.new(0, 5, 0, 4)
NTitle.BackgroundTransparency = 1
NTitle.Text = "NOTIF PESAN"
NTitle.Font = Enum.Font.GothamBold
NTitle.TextSize = 12
NTitle.TextColor3 = Color3.fromRGB(255,255,255)
NTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Input Pesan
local InputText = Instance.new("TextBox", NotifPanel)
InputText.Size = UDim2.new(1, -10, 0, 30)
InputText.Position = UDim2.new(0, 5, 0, 26)
InputText.PlaceholderText = "Input Pesan"
InputText.Text = ""
InputText.Font = Enum.Font.Gotham
InputText.TextSize = 12
InputText.TextColor3 = Color3.fromRGB(255,255,255)
InputText.BackgroundColor3 = Color3.fromRGB(35,35,35)
InputText.BorderSizePixel = 0
local itc = Instance.new("UICorner", InputText)
itc.CornerRadius = UDim.new(0,6)

-- Speed Label
local SpeedLabel = Instance.new("TextLabel", NotifPanel)
SpeedLabel.Size = UDim2.new(0.5, -8, 0, 18)
SpeedLabel.Position = UDim2.new(0, 5, 0, 64)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Speed Notif"
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 11
SpeedLabel.TextColor3 = Color3.fromRGB(200,200,200)
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Size Label
local SizeLabel = Instance.new("TextLabel", NotifPanel)
SizeLabel.Size = UDim2.new(0.5, -8, 0, 18)
SizeLabel.Position = UDim2.new(0.5, 3, 0, 64)
SizeLabel.BackgroundTransparency = 1
SizeLabel.Text = "Size Pesan"
SizeLabel.Font = Enum.Font.Gotham
SizeLabel.TextSize = 11
SizeLabel.TextColor3 = Color3.fromRGB(200,200,200)
SizeLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Default notif values
local notifSpeed = 2
local notifSize = 16
local notifColor = Color3.fromRGB(255,80,80)

-- Slider Speed Notif
CreateSlider("Speed Notif", 86, 1, 10, notifSpeed, function(v)
    notifSpeed = v
end)

-- Slider Size Pesan
CreateSlider("Size Pesan", 132, 10, 30, notifSize, function(v)
    notifSize = v
end)

-- Ganti Warna Button
local ColorBtn = Instance.new("TextButton", NotifPanel)
ColorBtn.Size = UDim2.new(0.48, -6, 0, 30)
ColorBtn.Position = UDim2.new(0, 5, 0, 170)
ColorBtn.Text = "GANTI WARNA"
ColorBtn.Font = Enum.Font.Gotham
ColorBtn.TextSize = 12
ColorBtn.TextColor3 = Color3.fromRGB(255,255,255)
ColorBtn.BackgroundColor3 = notifColor
ColorBtn.BorderSizePixel = 0
local cbc = Instance.new("UICorner", ColorBtn)
cbc.CornerRadius = UDim.new(0,6)

-- Kirim & Hapus
local SendBtn = Instance.new("TextButton", NotifPanel)
SendBtn.Size = UDim2.new(0.48, -6, 0, 30)
SendBtn.Position = UDim2.new(0.52, 0, 0, 170)
SendBtn.Text = "KIRIM PESAN"
SendBtn.Font = Enum.Font.GothamBold
SendBtn.TextSize = 12
SendBtn.TextColor3 = Color3.fromRGB(255,255,255)
SendBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
SendBtn.BorderSizePixel = 0
local sbc = Instance.new("UICorner", SendBtn)
sbc.CornerRadius = UDim.new(0,6)

local ClearBtn = Instance.new("TextButton", NotifPanel)
ClearBtn.Size = UDim2.new(1, -10, 0, 26)
ClearBtn.Position = UDim2.new(0, 5, 1, -30)
ClearBtn.Text = "HAPUS PESAN"
ClearBtn.Font = Enum.Font.Gotham
ClearBtn.TextSize = 11
ClearBtn.TextColor3 = Color3.fromRGB(255,255,255)
ClearBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
ClearBtn.BorderSizePixel = 0
local hbc = Instance.new("UICorner", ClearBtn)
hbc.CornerRadius = UDim.new(0,6)

-- Floating notif label
local Float = Instance.new("TextLabel", ScreenGui)
Float.Visible = false
Float.BackgroundTransparency = 1
Float.Font = Enum.Font.GothamBold
Float.TextColor3 = notifColor
Float.TextSize = notifSize
Float.TextXAlignment = Enum.TextXAlignment.Center
Float.TextYAlignment = Enum.TextYAlignment.Center

-- Posisi vertikal notif (0 = atas, 0.5 = tengah, 0.8 = bawah)
local notifY = 0.2

local TweenService = game:GetService("TweenService")
local tween

-- Tombol NAIK / TURUN posisi pesan
local UpBtn = Instance.new("TextButton", NotifPanel)
UpBtn.Size = UDim2.new(0.23, -4, 0, 26)
UpBtn.Position = UDim2.new(0, 5, 1, -62)
UpBtn.Text = "▲ NAIK"
UpBtn.Font = Enum.Font.Gotham
UpBtn.TextSize = 11
UpBtn.TextColor3 = Color3.fromRGB(255,255,255)
UpBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
UpBtn.BorderSizePixel = 0
Instance.new("UICorner", UpBtn).CornerRadius = UDim.new(0,6)

local DownBtn = Instance.new("TextButton", NotifPanel)
DownBtn.Size = UDim2.new(0.23, -4, 0, 26)
DownBtn.Position = UDim2.new(0.25, 1, 1, -62)
DownBtn.Text = "▼ TURUN"
DownBtn.Font = Enum.Font.Gotham
DownBtn.TextSize = 11
DownBtn.TextColor3 = Color3.fromRGB(255,255,255)
DownBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
DownBtn.BorderSizePixel = 0
Instance.new("UICorner", DownBtn).CornerRadius = UDim.new(0,6)

UpBtn.MouseButton1Click:Connect(function()
    notifY = math.clamp(notifY - 0.05, 0.05, 0.9)
end)

DownBtn.MouseButton1Click:Connect(function()
    notifY = math.clamp(notifY + 0.05, 0.05, 0.9)
end)

SendBtn.MouseButton1Click:Connect(function()
    if InputText.Text == "" then return end
    Float.Text = InputText.Text
    Float.TextSize = notifSize
    Float.TextColor3 = notifColor
    Float.Visible = true
    Float.Position = UDim2.new(1, 10, notifY, 0)
    Float.Size = UDim2.new(0, 400, 0, 50)

    if tween then tween:Cancel() end
    local function play()
        Float.Position = UDim2.new(1, 10, notifY, 0)
        tween = TweenService:Create(Float, TweenInfo.new(notifSpeed, Enum.EasingStyle.Linear), {
            Position = UDim2.new(-0.5, 0, notifY, 0)
        })
        tween:Play()
        tween.Completed:Wait()
        play()
    end
    task.spawn(play)
end)

ClearBtn.MouseButton1Click:Connect(function()
    if tween then tween:Cancel() tween = nil end
    Float.Visible = false
    Float.Text = ""
end)

--// End UI Base
--// Feature logic akan ditambahkan satu per satu sesuai permintaan

