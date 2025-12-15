--==================================================
-- Mikaa Dev Testing 
--==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local char, hum, hrp
local speed = 0
local targetSpeed = 16
local currentSpeed = 16

local targetJump = 50
local currentJump = 50

local walkOnWater = false

--=========================
-- CONFIG
--=========================
local MAX_WALK_SPEED = 800
local MAX_JUMP_POWER = 150
local SPEED_SMOOTH = 0.15

local waterPad

--=========================
-- CHARACTER LOAD
--=========================
local function loadChar(c)
    char = c
    hum = char:WaitForChild("Humanoid")
    hrp = char:WaitForChild("HumanoidRootPart")

    targetSpeed = 16
    currentSpeed = 16
    targetJump = 50
    currentJump = 50

    hum.WalkSpeed = 16
    hum.JumpPower = 50

    if waterPad then waterPad:Destroy() end
    waterPad = Instance.new("Part")
    waterPad.Size = Vector3.new(6,1,6)
    waterPad.Anchored = true
    waterPad.CanCollide = true
    waterPad.Transparency = 1
    waterPad.Parent = workspace

    if spTxt then spTxt.Text = "SPEED : 0%" end
    if spInput then spInput.Text = "0" end
    if fill then fill.Size = UDim2.new(0,0,1,0) end

    if jpTxt then jpTxt.Text = "JUMP : 0%" end
    if jpInput then jpInput.Text = "0" end
    if jpFill then jpFill.Size = UDim2.new(0,0,1,0) end

    if waterBtn then waterBtn.Text = "WATER : OFF" end
    walkOnWater = false
end

player.CharacterAdded:Connect(loadChar)
if player.Character then loadChar(player.Character) end

--=========================
-- UI
--=========================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local toggleBtn = Instance.new("ImageButton", gui)
toggleBtn.Size = UDim2.new(0,40,0,40)
toggleBtn.Position = UDim2.new(0,10,0.5,-20)
toggleBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
toggleBtn.BorderSizePixel = 0
toggleBtn.Active = true
toggleBtn.Draggable = true
toggleBtn.AutoButtonColor = true
toggleBtn.Image = "rbxassetid://100166477433523"
toggleBtn.ScaleType = Enum.ScaleType.Fit

local corner = Instance.new("UICorner", toggleBtn)
corner.CornerRadius = UDim.new(0,6)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,170)
frame.Position = UDim2.new(0.5,-100,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
frame.Active = true
frame.Draggable = true
frame.Visible = true

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,26)
title.Text = "Mikaa Dev Testing"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(15,15,15)

-- BUTTON
local function btn(txt,y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-16,0,30)
    b.Position = UDim2.new(0,8,0,y)
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.TextScaled = true
    b.Text = txt
    return b
end

waterBtn = btn("WATER : OFF",28)

--=========================
-- SPEED UI
--=========================
spTxt = Instance.new("TextLabel", frame)
spTxt.Size = UDim2.new(1,-16,0,18)
spTxt.Position = UDim2.new(0,8,0,64)
spTxt.BackgroundTransparency = 1
spTxt.TextColor3 = Color3.new(1,1,1)
spTxt.TextScaled = true
spTxt.Text = "SPEED : 0%"

spInput = Instance.new("TextBox", frame)
spInput.Size = UDim2.new(0,42,0,18)
spInput.Position = UDim2.new(1,-50,0,64)
spInput.BackgroundColor3 = Color3.fromRGB(35,35,35)
spInput.TextColor3 = Color3.new(1,1,1)
spInput.TextScaled = true
spInput.Text = "0"
spInput.ClearTextOnFocus = false

bar = Instance.new("Frame", frame)
bar.Size = UDim2.new(1,-16,0,6)
bar.Position = UDim2.new(0,8,0,84)
bar.BackgroundColor3 = Color3.fromRGB(60,60,60)

fill = Instance.new("Frame", bar)
fill.Size = UDim2.new(0,0,1,0)
fill.BackgroundColor3 = Color3.fromRGB(0,170,255)

--=========================
-- JUMP UI
--=========================
jpTxt = Instance.new("TextLabel", frame)
jpTxt.Size = UDim2.new(1,-16,0,18)
jpTxt.Position = UDim2.new(0,8,0,100)
jpTxt.BackgroundTransparency = 1
jpTxt.TextColor3 = Color3.new(1,1,1)
jpTxt.TextScaled = true
jpTxt.Text = "JUMP : 0%"

jpInput = Instance.new("TextBox", frame)
jpInput.Size = UDim2.new(0,42,0,18)
jpInput.Position = UDim2.new(1,-50,0,100)
jpInput.BackgroundColor3 = Color3.fromRGB(35,35,35)
jpInput.TextColor3 = Color3.new(1,1,1)
jpInput.TextScaled = true
jpInput.Text = "0"
jpInput.ClearTextOnFocus = false

jpBar = Instance.new("Frame", frame)
jpBar.Size = UDim2.new(1,-16,0,6)
jpBar.Position = UDim2.new(0,8,0,120)
jpBar.BackgroundColor3 = Color3.fromRGB(60,60,60)

jpFill = Instance.new("Frame", jpBar)
jpFill.Size = UDim2.new(0,0,1,0)
jpFill.BackgroundColor3 = Color3.fromRGB(255,140,0)

--=========================
-- SPEED SYSTEM
--=========================
local function setSpeed(percent)
    percent = math.clamp(percent,0,100)
    targetSpeed = 16 + (MAX_WALK_SPEED - 16) * (percent / 100)
    fill.Size = UDim2.new(percent/100,0,1,0)
    spTxt.Text = "SPEED : "..percent.."%"
    spInput.Text = tostring(percent)
end

bar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch then
        local x = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,0,1)
        setSpeed(math.floor(x * 100))
    end
end)

spInput.FocusLost:Connect(function()
    setSpeed(tonumber(spInput.Text) or 0)
end)

--=========================
-- JUMP SYSTEM
--=========================
local function setJump(percent)
    percent = math.clamp(percent,0,100)
    targetJump = 50 + (MAX_JUMP_POWER - 50) * (percent / 100)
    jpFill.Size = UDim2.new(percent/100,0,1,0)
    jpTxt.Text = "JUMP : "..percent.."%"
    jpInput.Text = tostring(percent)
end

jpBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch then
        local x = math.clamp((i.Position.X - jpBar.AbsolutePosition.X) / jpBar.AbsoluteSize.X,0,1)
        setJump(math.floor(x * 100))
    end
end)

jpInput.FocusLost:Connect(function()
    setJump(tonumber(jpInput.Text) or 0)
end)

--=========================
-- WATER BUTTON
--=========================
waterBtn.MouseButton1Click:Connect(function()
    walkOnWater = not walkOnWater
    waterBtn.Text = "WATER : "..(walkOnWater and "ON" or "OFF")
end)

--=========================
-- LOOP
--=========================
RunService.RenderStepped:Connect(function()
    if hum then
        currentSpeed += (targetSpeed - currentSpeed) * SPEED_SMOOTH
        hum.WalkSpeed = currentSpeed

        currentJump += (targetJump - currentJump) * SPEED_SMOOTH
        hum.JumpPower = currentJump
    end

    if walkOnWater and hrp and waterPad then
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {char}
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist

        local result = workspace:Raycast(hrp.Position, Vector3.new(0,-20,0), rayParams)
        if result and result.Material == Enum.Material.Water then
            waterPad.Position = Vector3.new(hrp.Position.X, result.Position.Y + 0.3, hrp.Position.Z)
        else
            waterPad.Position = Vector3.new(0,-1000,0)
        end
    end
end)

print("Mikaa Dev Testing Loaded ✅")
