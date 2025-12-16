--==================================================
-- Mikaa Dev Testing (FINAL FIX ALL FEATURE)
--==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char, hum, hrp

-- PLAYER STATS
local targetSpeed, currentSpeed = 16,16
local targetJump, currentJump = 50,50
local walkOnWater = false

-- CONFIG
local MAX_WALK_SPEED = 800
local MAX_JUMP_POWER = 250
local SPEED_SMOOTH = 0.15

--==================================================
-- CHARACTER LOAD
--==================================================
local function loadChar(c)
    char = c
    hum = c:WaitForChild("Humanoid")
    hrp = c:WaitForChild("HumanoidRootPart")
    hum.WalkSpeed = 16
    hum.JumpPower = 50
end
player.CharacterAdded:Connect(loadChar)
if player.Character then loadChar(player.Character) end

--==================================================
-- UI CORE
--==================================================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

-- LOGO BUTTON
local logo = Instance.new("ImageButton", gui)
logo.Size = UDim2.new(0,40,0,40)
logo.Position = UDim2.new(0,10,0.5,-20)
logo.Image = "rbxassetid://100166477433523"
logo.BackgroundColor3 = Color3.fromRGB(20,20,20)
logo.BorderSizePixel = 0
logo.Active = true
logo.Draggable = true

-- MAIN FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,220,0,420)
frame.Position = UDim2.new(0.6,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.Active = true
frame.Draggable = true

logo.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,26)
title.Text = "Mikaa Dev Testing"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(20,20,20)

--==================================================
-- WATER TOGGLE
--==================================================
local waterBtn = Instance.new("TextButton", frame)
waterBtn.Size = UDim2.new(1,0,0,22)
waterBtn.Position = UDim2.new(0,0,0,28)
waterBtn.Text = "WATER : OFF"
waterBtn.TextScaled = true
waterBtn.TextColor3 = Color3.new(1,1,1)
waterBtn.BackgroundTransparency = 1

waterBtn.MouseButton1Click:Connect(function()
    walkOnWater = not walkOnWater
    waterBtn.Text = "WATER : "..(walkOnWater and "ON" or "OFF")
end)

--==================================================
-- SPEED SLIDER
--==================================================
local spLabel = Instance.new("TextLabel", frame)
spLabel.Size = UDim2.new(1,0,0,18)
spLabel.Position = UDim2.new(0,0,0,52)
spLabel.Text = "SPEED : 0%"
spLabel.TextScaled = true
spLabel.TextColor3 = Color3.new(1,1,1)
spLabel.BackgroundTransparency = 1

local spBar = Instance.new("Frame", frame)
spBar.Size = UDim2.new(1,-20,0,6)
spBar.Position = UDim2.new(0,10,0,72)
spBar.BackgroundColor3 = Color3.fromRGB(60,60,60)

local spFill = Instance.new("Frame", spBar)
spFill.Size = UDim2.new(0,0,1,0)
spFill.BackgroundColor3 = Color3.fromRGB(0,170,255)

local dragSpeed = false
spBar.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then dragSpeed=true end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then dragSpeed=false end
end)

--==================================================
-- JUMP SLIDER
--==================================================
local jpLabel = Instance.new("TextLabel", frame)
jpLabel.Size = UDim2.new(1,0,0,18)
jpLabel.Position = UDim2.new(0,0,0,84)
jpLabel.Text = "JUMP : 0%"
jpLabel.TextScaled = true
jpLabel.TextColor3 = Color3.new(1,1,1)
jpLabel.BackgroundTransparency = 1

local jpBar = Instance.new("Frame", frame)
jpBar.Size = UDim2.new(1,-20,0,6)
jpBar.Position = UDim2.new(0,10,0,104)
jpBar.BackgroundColor3 = Color3.fromRGB(60,60,60)

local jpFill = Instance.new("Frame", jpBar)
jpFill.Size = UDim2.new(0,0,1,0)
jpFill.BackgroundColor3 = Color3.fromRGB(255,140,0)

local dragJump = false
jpBar.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then dragJump=true end
end)

--==================================================
-- NOTIFICATION UI
--==================================================
local yBase = 130

local function makeLabel(txt,y)
    local l = Instance.new("TextLabel", frame)
    l.Size = UDim2.new(1,0,0,18)
    l.Position = UDim2.new(0,0,0,y)
    l.Text = txt
    l.TextScaled = true
    l.TextColor3 = Color3.new(1,1,1)
    l.BackgroundTransparency = 1
    return l
end

makeLabel("NOTIF TEXT",yBase)

local notifBox = Instance.new("TextBox", frame)
notifBox.Size = UDim2.new(1,-20,0,22)
notifBox.Position = UDim2.new(0,10,0,yBase+20)
notifBox.PlaceholderText = "Isi teks notif"
notifBox.TextScaled = true
notifBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
notifBox.TextColor3 = Color3.new(1,1,1)

makeLabel("SPEED NOTIF",yBase+48)

local notifSpeedBox = Instance.new("TextBox", frame)
notifSpeedBox.Size = UDim2.new(0,50,0,22)
notifSpeedBox.Position = UDim2.new(1,-60,0,yBase+48)
notifSpeedBox.Text = "3"
notifSpeedBox.TextScaled = true
notifSpeedBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
notifSpeedBox.TextColor3 = Color3.new(1,1,1)

makeLabel("SIZE TEKS",yBase+76)

local notifSizeBox = Instance.new("TextBox", frame)
notifSizeBox.Size = UDim2.new(0,50,0,22)
notifSizeBox.Position = UDim2.new(1,-60,0,yBase+76)
notifSizeBox.Text = "20"
notifSizeBox.TextScaled = true
notifSizeBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
notifSizeBox.TextColor3 = Color3.new(1,1,1)

makeLabel("WARNA NOTIF",yBase+104)

local colorBtn = Instance.new("TextButton", frame)
colorBtn.Size = UDim2.new(1,-20,0,22)
colorBtn.Position = UDim2.new(0,10,0,yBase+124)
colorBtn.Text = "GANTI WARNA"
colorBtn.TextScaled = true
colorBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
colorBtn.TextColor3 = Color3.new(1,1,1)

local sendNotif = Instance.new("TextButton", frame)
sendNotif.Size = UDim2.new(1,-20,0,26)
sendNotif.Position = UDim2.new(0,10,0,yBase+154)
sendNotif.Text = "KIRIM NOTIF"
sendNotif.TextScaled = true
sendNotif.BackgroundColor3 = Color3.fromRGB(40,40,40)
sendNotif.TextColor3 = Color3.new(1,1,1)

local stopNotif = Instance.new("TextButton", frame)
stopNotif.Size = UDim2.new(1,-20,0,26)
stopNotif.Position = UDim2.new(0,10,0,yBase+184)
stopNotif.Text = "HAPUS NOTIF"
stopNotif.TextScaled = true
stopNotif.BackgroundColor3 = Color3.fromRGB(70,30,30)
stopNotif.TextColor3 = Color3.new(1,1,1)

--==================================================
-- NOTIF SYSTEM
--==================================================
local colors = {
    Color3.fromRGB(255,255,255),
    Color3.fromRGB(0,170,255),
    Color3.fromRGB(255,140,0),
    Color3.fromRGB(0,255,127),
    Color3.fromRGB(255,80,80)
}
local colorIndex = 1

local notif = Instance.new("TextLabel", gui)
notif.Size = UDim2.new(0,320,0,40)
notif.Position = UDim2.new(1,0,0.15,0)
notif.BackgroundColor3 = Color3.fromRGB(0,0,0)
notif.TextColor3 = colors[colorIndex]
notif.TextScaled = true
notif.Visible = false
notif.Active = true
notif.Draggable = true

local notifRun = false

colorBtn.MouseButton1Click:Connect(function()
    colorIndex = colorIndex % #colors + 1
    notif.TextColor3 = colors[colorIndex]
end)

stopNotif.MouseButton1Click:Connect(function()
    notifRun = false
    notif.Visible = false
end)

sendNotif.MouseButton1Click:Connect(function()
    if notifBox.Text=="" then return end
    notif.Text = notifBox.Text
    notif.TextSize = tonumber(notifSizeBox.Text) or 20
    notif.Visible = true
    notifRun = true
    local speed = tonumber(notifSpeedBox.Text) or 3

    task.spawn(function()
        while notifRun do
            notif.Position = UDim2.new(1,0,notif.Position.Y.Scale,0)
            for i=1,900,speed do
                if not notifRun then return end
                notif.Position -= UDim2.new(0,speed,0,0)
                RunService.RenderStepped:Wait()
            end
            notif.Position = UDim2.new(0,-320,notif.Position.Y.Scale,0)
            for i=1,900,speed do
                if not notifRun then return end
                notif.Position += UDim2.new(0,speed,0,0)
                RunService.RenderStepped:Wait()
            end
        end
    end)
end)

--==================================================
-- SYSTEM LOOP
--==================================================
RunService.RenderStepped:Connect(function()
    if dragSpeed then
        local p = math.clamp((UIS:GetMouseLocation().X-spBar.AbsolutePosition.X)/spBar.AbsoluteSize.X,0,1)
        spFill.Size = UDim2.new(p,0,1,0)
        spLabel.Text = "SPEED : "..math.floor(p*100).."%"
        targetSpeed = 16 + (MAX_WALK_SPEED-16)*p
    end

    if dragJump then
        local p = math.clamp((UIS:GetMouseLocation().X-jpBar.AbsolutePosition.X)/jpBar.AbsoluteSize.X,0,1)
        jpFill.Size = UDim2.new(p,0,1,0)
        jpLabel.Text = "JUMP : "..math.floor(p*100).."%"
        targetJump = 50 + (MAX_JUMP_POWER-50)*p
    end

    if hum then
        currentSpeed += (targetSpeed-currentSpeed)*SPEED_SMOOTH
        currentJump += (targetJump-currentJump)*SPEED_SMOOTH
        hum.WalkSpeed = currentSpeed
        hum.JumpPower = currentJump
    end
end)

print("Mikaa Dev Testing FINAL FIX Loaded ✅")
