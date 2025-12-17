--// ===============================
--// Mikaa Dev Testing - FULL UI
--// Session 1 (UI Base + Player System)
--// ===============================

-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Anti Double UI
if PlayerGui:FindFirstChild("MikaaUI") then
    PlayerGui.MikaaUI:Destroy()
end

-- Character refs
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

-- CONFIG
local DEFAULT_SPEED = 16
local DEFAULT_JUMP = 50
local MAX_WALK_SPEED = 800
local MAX_JUMP_POWER = 250
local SPEED_SMOOTH = 0.15

-- COLORS TABLE (SESUI PERMINTAAN)
local colors = {
    Color3.new(1,1,1), -- putih
    Color3.fromRGB(255,0,0), -- merah
    Color3.fromRGB(255,165,0), -- oren
    Color3.fromRGB(128,0,128), -- ungu
    Color3.fromRGB(0,170,225) -- biru muda
}
local colorIndex = 1

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MikaaUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main Frame
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0,360,0,520)
Main.Position = UDim2.new(0.6,0,0.15,0)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.BorderSizePixel = 0

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

-- Small Logo Toggle
local LogoBtn = Instance.new("ImageButton", ScreenGui)
LogoBtn.Size = UDim2.new(0,36,0,36)
LogoBtn.Position = UDim2.new(0,20,0.4,0)
LogoBtn.Image = "rbxassetid://100166477433523"
LogoBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
LogoBtn.BorderSizePixel = 0
Instance.new("UICorner", LogoBtn).CornerRadius = UDim.new(0,8)

LogoBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Header
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1,0,0,45)
Header.BackgroundColor3 = Color3.fromRGB(30,30,30)
Header.BorderSizePixel = 0

Instance.new("UICorner", Header).CornerRadius = UDim.new(0,12)

do
    local dragging, dragStart, startPos

    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- Header Logo
local HeaderLogo = Instance.new("ImageLabel", Header)
HeaderLogo.Size = UDim2.new(0,26,0,26)
HeaderLogo.Position = UDim2.new(0,10,0.5,-13)
HeaderLogo.BackgroundTransparency = 1
HeaderLogo.Image = "rbxassetid://100166477433523"

-- Title
local Title = Instance.new("TextLabel", Header)
Title.Text = "Mikaa Dev Testing"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0,45,0,0)
Title.Size = UDim2.new(1,-50,1,0)
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Content
local Content = Instance.new("Frame", Main)
Content.Position = UDim2.new(0,0,0,55)
Content.Size = UDim2.new(1,0,1,-55)
Content.BackgroundTransparency = 1

-- ===============================
-- UI BUILDERS
-- ===============================

local function CreateToggle(text, yPos, callback)
    local Btn = Instance.new("TextButton", Content)
    Btn.Size = UDim2.new(1,-20,0,34)
    Btn.Position = UDim2.new(0,10,0,yPos)
    Btn.Text = text.." : OFF"
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 13
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Btn.BorderSizePixel = 0
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,8)

    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.Text = text .. (state and " : ON" or " : OFF")
        if callback then callback(state) end
    end)

    return Btn
end

local function CreateSliderWithInput(label, yPos, min, max, default, onChange)
    local Holder = Instance.new("Frame", Content)
    Holder.Size = UDim2.new(1,-20,0,50)
    Holder.Position = UDim2.new(0,10,0,yPos)
    Holder.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Holder.BorderSizePixel = 0
    Instance.new("UICorner", Holder).CornerRadius = UDim.new(0,8)

    local Text = Instance.new("TextLabel", Holder)
    Text.Size = UDim2.new(1,-70,0,18)
    Text.Position = UDim2.new(0,8,0,4)
    Text.BackgroundTransparency = 1
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.Font = Enum.Font.Gotham
    Text.TextSize = 12
    Text.TextColor3 = Color3.new(1,1,1)

    local Input = Instance.new("TextBox", Holder)
    Input.Size = UDim2.new(0,50,0,20)
    Input.Position = UDim2.new(1,-56,0,2)
    Input.Text = tostring(default)
    Input.Font = Enum.Font.Gotham
    Input.TextSize = 12
    Input.TextColor3 = Color3.new(1,1,1)
    Input.BackgroundColor3 = Color3.fromRGB(45,45,45)
    Input.BorderSizePixel = 0
    Instance.new("UICorner", Input).CornerRadius = UDim.new(0,6)

    local Bar = Instance.new("Frame", Holder)
    Bar.Size = UDim2.new(1,-16,0,8)
    Bar.Position = UDim2.new(0,8,0,32)
    Bar.BackgroundColor3 = Color3.fromRGB(55,55,55)
    Bar.BorderSizePixel = 0
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1,0)

    local Fill = Instance.new("Frame", Bar)
    Fill.BackgroundColor3 = Color3.fromRGB(0,170,225)
    Fill.BorderSizePixel = 0
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1,0)

    local value = default

    local function update(v)
        value = math.clamp(v,min,max)
        local pct = (value-min)/(max-min)
        Fill.Size = UDim2.new(pct,0,1,0)
        Text.Text = label..": "..value
        Input.Text = tostring(value)
        if onChange then onChange(value) end
    end

    update(default)

    Input.FocusLost:Connect(function()
        local v = tonumber(Input.Text)
        if v then update(v) end
    end)

    Bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            update(min + (max-min)*((i.Position.X-Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X))
        end
    end)

    return update
end

-- ===============================
-- PLAYER FEATURES
-- ===============================

local walkValue = DEFAULT_SPEED
local jumpValue = DEFAULT_JUMP
local flySpeed = 60
local flying = false
local bv
local noclipConn

CreateToggle("Speed Player",0,function(on)
    humanoid.WalkSpeed = on and walkValue or DEFAULT_SPEED
end)

CreateSliderWithInput("Speed Player",40,16,MAX_WALK_SPEED,DEFAULT_SPEED,function(v)
    walkValue = v
    humanoid.WalkSpeed = v
end)

CreateToggle("Jump Player",100,function(on)
    humanoid.JumpPower = on and jumpValue or DEFAULT_JUMP
end)

CreateSliderWithInput("Jump Player",140,50,MAX_JUMP_POWER,DEFAULT_JUMP,function(v)
    jumpValue = v
    humanoid.JumpPower = v
end)

CreateToggle("Fly",200,function(on)
    flying = on
    if on then
        bv = Instance.new("BodyVelocity",root)
        bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        bv.Velocity = Vector3.new(0,flySpeed,0)
    else
        if bv then bv:Destroy() bv=nil end
    end
end)

CreateSliderWithInput("Speed Fly",240,20,200,60,function(v)
    flySpeed = v
    if bv then bv.Velocity = Vector3.new(0,flySpeed,0) end
end)

CreateToggle("Noclip",300,function(on)
    if on then
        noclipConn = RunService.Stepped:Connect(function()
            for _,v in pairs(character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() end
    end
end)

-- === END SESSION 1 ===

--// ===============================
--// SESSION 2 - NOTIFICATION PANEL
--// ===============================

local TweenService = game:GetService("TweenService")

-- NOTIF PANEL
local NotifPanel = Instance.new("Frame", Content)
NotifPanel.Size = UDim2.new(1,-20,0,240)
NotifPanel.Position = UDim2.new(0,10,0,350)
NotifPanel.BackgroundColor3 = Color3.fromRGB(25,25,25)
NotifPanel.BorderSizePixel = 0
Instance.new("UICorner", NotifPanel).CornerRadius = UDim.new(0,10)

-- TITLE
local NTitle = Instance.new("TextLabel", NotifPanel)
NTitle.Text = "NOTIF PESAN PANEL"
NTitle.Font = Enum.Font.GothamBold
NTitle.TextSize = 13
NTitle.TextColor3 = Color3.new(1,1,1)
NTitle.BackgroundTransparency = 1
NTitle.Size = UDim2.new(1,0,0,20)
NTitle.Position = UDim2.new(0,0,0,6)

-- INPUT PESAN
local MsgBox = Instance.new("TextBox", NotifPanel)
MsgBox.PlaceholderText = "Input Pesan..."
MsgBox.Text = ""
MsgBox.Font = Enum.Font.Gotham
MsgBox.TextSize = 13
MsgBox.TextColor3 = Color3.new(1,1,1)
MsgBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
MsgBox.BorderSizePixel = 0
MsgBox.Size = UDim2.new(1,-16,0,32)
MsgBox.Position = UDim2.new(0,8,0,30)
Instance.new("UICorner", MsgBox).CornerRadius = UDim.new(0,6)

-- INPUT SPEED
local SpeedBox = Instance.new("TextBox", NotifPanel)
SpeedBox.Text = "2"
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.TextSize = 12
SpeedBox.TextColor3 = Color3.new(1,1,1)
SpeedBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
SpeedBox.BorderSizePixel = 0
SpeedBox.Size = UDim2.new(0.45,-6,0,26)
SpeedBox.Position = UDim2.new(0,8,0,70)
SpeedBox.PlaceholderText = "Speed"
Instance.new("UICorner", SpeedBox).CornerRadius = UDim.new(0,6)

-- INPUT SIZE
local SizeBox = Instance.new("TextBox", NotifPanel)
SizeBox.Text = "16"
SizeBox.Font = Enum.Font.Gotham
SizeBox.TextSize = 12
SizeBox.TextColor3 = Color3.new(1,1,1)
SizeBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
SizeBox.BorderSizePixel = 0
SizeBox.Size = UDim2.new(0.45,-6,0,26)
SizeBox.Position = UDim2.new(0.5,2,0,70)
SizeBox.PlaceholderText = "Size"
Instance.new("UICorner", SizeBox).CornerRadius = UDim.new(0,6)

-- DEFAULT VALUES
local notifSpeed = 2
local notifSize = 16
local notifY = 0.2
local notifFontIndex = 1

-- FONT LIST (BISA DITAMBAH)
local fonts = {
    Enum.Font.GothamBold,
    Enum.Font.Arcade,
    Enum.Font.FredokaOne,
    Enum.Font.Cartoon,
    Enum.Font.Antique
}

-- FLOATING TEXT
local Float = Instance.new("TextLabel", ScreenGui)
Float.Visible = false
Float.BackgroundTransparency = 1
Float.TextColor3 = colors[colorIndex]
Float.TextSize = notifSize
Float.Font = fonts[notifFontIndex]
Float.TextXAlignment = Center
Float.TextYAlignment = Center
Float.Size = UDim2.new(0,500,0,60)

local activeTween

-- GANTI WARNA
local ColorBtn = Instance.new("TextButton", NotifPanel)
ColorBtn.Text = "GANTI WARNA"
ColorBtn.Font = Enum.Font.Gotham
ColorBtn.TextSize = 12
ColorBtn.TextColor3 = Color3.new(1,1,1)
ColorBtn.BackgroundColor3 = colors[colorIndex]
ColorBtn.BorderSizePixel = 0
ColorBtn.Size = UDim2.new(1,-16,0,28)
ColorBtn.Position = UDim2.new(0,8,0,104)
Instance.new("UICorner", ColorBtn).CornerRadius = UDim.new(0,6)

ColorBtn.MouseButton1Click:Connect(function()
    colorIndex = colorIndex % #colors + 1
    ColorBtn.BackgroundColor3 = colors[colorIndex]
    Float.TextColor3 = colors[colorIndex]
end)

-- POSISI BUTTON
local UpBtn = Instance.new("TextButton", NotifPanel)
UpBtn.Text = "▲ NAIK"
UpBtn.Font = Enum.Font.Gotham
UpBtn.TextSize = 11
UpBtn.TextColor3 = Color3.new(1,1,1)
UpBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
UpBtn.BorderSizePixel = 0
UpBtn.Size = UDim2.new(0.48,-4,0,26)
UpBtn.Position = UDim2.new(0,8,0,138)
Instance.new("UICorner", UpBtn).CornerRadius = UDim.new(0,6)

local DownBtn = UpBtn:Clone()
DownBtn.Text = "▼ TURUN"
DownBtn.Parent = NotifPanel
DownBtn.Position = UDim2.new(0.52,4,0,138)

UpBtn.MouseButton1Click:Connect(function()
    notifY = math.clamp(notifY - 0.05,0.05,0.9)
end)

DownBtn.MouseButton1Click:Connect(function()
    notifY = math.clamp(notifY + 0.05,0.05,0.9)
end)

-- FONT BUTTON
local FontBtn = Instance.new("TextButton", NotifPanel)
FontBtn.Text = "UBAH FONT"
FontBtn.Font = Enum.Font.GothamBold
FontBtn.TextSize = 12
FontBtn.TextColor3 = Color3.new(1,1,1)
FontBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
FontBtn.BorderSizePixel = 0
FontBtn.Size = UDim2.new(1,-16,0,28)
FontBtn.Position = UDim2.new(0,8,0,170)
Instance.new("UICorner", FontBtn).CornerRadius = UDim.new(0,6)

FontBtn.MouseButton1Click:Connect(function()
    notifFontIndex = notifFontIndex % #fonts + 1
    Float.Font = fonts[notifFontIndex]
end)

-- SEND BUTTON
local SendBtn = Instance.new("TextButton", NotifPanel)
SendBtn.Text = "KIRIM PESAN"
SendBtn.Font = Enum.Font.GothamBold
SendBtn.TextSize = 12
SendBtn.TextColor3 = Color3.new(1,1,1)
SendBtn.BackgroundColor3 = Color3.fromRGB(0,170,225)
SendBtn.BorderSizePixel = 0
SendBtn.Size = UDim2.new(0.48,-4,0,30)
SendBtn.Position = UDim2.new(0,8,0,204)
Instance.new("UICorner", SendBtn).CornerRadius = UDim.new(0,6)

-- CLEAR BUTTON
local ClearBtn = SendBtn:Clone()
ClearBtn.Text = "HAPUS PESAN"
ClearBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
ClearBtn.Parent = NotifPanel
ClearBtn.Position = UDim2.new(0.52,4,0,204)

-- SEND LOGIC
SendBtn.MouseButton1Click:Connect(function()
    if MsgBox.Text == "" then return end

    notifSpeed = tonumber(SpeedBox.Text) or 2
    notifSize = tonumber(SizeBox.Text) or 16

    Float.Text = MsgBox.Text
    Float.TextSize = notifSize
    Float.Visible = true

    if activeTween then activeTween:Cancel() end

    local function play()
        Float.Position = UDim2.new(1,10,notifY,0)
        activeTween = TweenService:Create(
            Float,
            TweenInfo.new(notifSpeed,Enum.EasingStyle.Linear),
            {Position = UDim2.new(-0.5,0,notifY,0)}
        )
        activeTween:Play()
        activeTween.Completed:Wait()
        play()
    end

    task.spawn(play)
end)

ClearBtn.MouseButton1Click:Connect(function()
    if activeTween then activeTween:Cancel() end
    Float.Visible = false
    Float.Text = ""
end)

--// ===============================
--// END SESSION 2 (FULL)
--// ===============================
