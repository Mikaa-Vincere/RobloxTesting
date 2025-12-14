--==================================================
-- Mikaa Fly V1 (FIX)
--==================================================

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera

-- STATES
local fly = false
local noclip = false
local opened = false
local speedPercent = 0
local flySpeed = 0
local goingUp, goingDown = false, false

local bg, bv

--==================================================
-- UI
--==================================================
local gui = Instance.new("ScreenGui")
gui.Name = "MikaaFlyUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- HEADER
local header = Instance.new("Frame", gui)
header.Size = UDim2.new(0,260,0,35)
header.Position = UDim2.new(0.5,-130,0.25,0)
header.BackgroundColor3 = Color3.fromRGB(20,20,20)
header.Active = true

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,-40,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "Mikaa Fly V1"
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextScaled = true

local close = Instance.new("TextButton", header)
close.Size = UDim2.new(0,35,1,0)
close.Position = UDim2.new(1,-35,0,0)
close.Text = "X"
close.TextScaled = true
close.BackgroundColor3 = Color3.fromRGB(120,30,30)
close.TextColor3 = Color3.new(1,1,1)

-- PANEL
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0,260,0,0)
panel.Position = header.Position + UDim2.new(0,0,0,35)
panel.BackgroundColor3 = Color3.fromRGB(30,30,30)
panel.ClipsDescendants = true

--==================================================
-- TOGGLE BUTTON MAKER
--==================================================
local function makeToggle(text,y)
    local b = Instance.new("TextButton", panel)
    b.Size = UDim2.new(1,-20,0,35)
    b.Position = UDim2.new(0,10,0,y)
    b.BackgroundColor3 = Color3.fromRGB(45,45,45)
    b.TextColor3 = Color3.new(1,1,1)
    b.TextScaled = true
    b.Text = text.." : OFF"
    return b
end

local flyBtn = makeToggle("FLY",10)
local clipBtn = makeToggle("NOCLIP",55)

-- SPEED
local speedTxt = Instance.new("TextLabel", panel)
speedTxt.Size = UDim2.new(1,-20,0,30)
speedTxt.Position = UDim2.new(0,10,0,100)
speedTxt.BackgroundTransparency = 1
speedTxt.TextColor3 = Color3.new(1,1,1)
speedTxt.TextScaled = true
speedTxt.Text = "SPEED : 0%"

local sliderBg = Instance.new("Frame", panel)
sliderBg.Size = UDim2.new(1,-20,0,10)
sliderBg.Position = UDim2.new(0,10,0,135)
sliderBg.BackgroundColor3 = Color3.fromRGB(60,60,60)

local slider = Instance.new("Frame", sliderBg)
slider.Size = UDim2.new(0,0,1,0)
slider.BackgroundColor3 = Color3.fromRGB(0,170,255)

--==================================================
-- UP / DOWN BUTTONS (DRAGGABLE)
--==================================================
local function moveBtn(text,pos)
    local b = Instance.new("TextButton", gui)
    b.Size = UDim2.new(0,60,0,60)
    b.Position = pos
    b.BackgroundColor3 = Color3.fromRGB(30,30,30)
    b.TextColor3 = Color3.new(1,1,1)
    b.TextScaled = true
    b.Text = text
    b.Active = true
    return b
end

local upBtn = moveBtn("▲", UDim2.new(0.5,-90,0.75,0))
local dnBtn = moveBtn("▼", UDim2.new(0.5,30,0.75,0))

--==================================================
-- CUSTOM DRAG FUNCTION (REUSABLE)
--==================================================
local function enableDrag(frame, moveWith)
    local dragging, dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseMovement
        ) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            if moveWith then
                moveWith.Position = frame.Position + UDim2.new(0,0,0,35)
            end
        end
    end)
end

enableDrag(header, panel)
enableDrag(upBtn)
enableDrag(dnBtn)

--==================================================
-- FLY SYSTEM
--==================================================
local function startFly()
    fly = true
    bg = Instance.new("BodyGyro", hrp)
    bg.P = 9e4
    bg.MaxTorque = Vector3.new(9e9,9e9,9e9)

    bv = Instance.new("BodyVelocity", hrp)
    bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    bv.Velocity = Vector3.zero

    flyBtn.Text = "FLY : ON"
end

local function stopFly()
    fly = false
    if bg then bg:Destroy() end
    if bv then bv:Destroy() end
    flyBtn.Text = "FLY : OFF"
end

--==================================================
-- BUTTON LOGIC
--==================================================
flyBtn.MouseButton1Click:Connect(function()
    if fly then stopFly() else startFly() end
end)

clipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    clipBtn.Text = "NOCLIP : "..(noclip and "ON" or "OFF")
end)

upBtn.MouseButton1Down:Connect(function() goingUp = true end)
upBtn.MouseButton1Up:Connect(function() goingUp = false end)
dnBtn.MouseButton1Down:Connect(function() goingDown = true end)
dnBtn.MouseButton1Up:Connect(function() goingDown = false end)

sliderBg.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        local x = math.clamp((i.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X,0,1)
        slider.Size = UDim2.new(x,0,1,0)
        speedPercent = math.floor(x*100)
        speedTxt.Text = "SPEED : "..speedPercent.."%"
        flySpeed = speedPercent * 0.6
    end
end)

-- TAP HEADER TO OPEN MENU
local tapTime = 0
header.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch
    or i.UserInputType == Enum.UserInputType.MouseButton1 then
        tapTime = tick()
    end
end)

header.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch
    or i.UserInputType == Enum.UserInputType.MouseButton1 then
        if tick() - tapTime < 0.25 then
            opened = not opened
            TweenService:Create(panel, TweenInfo.new(0.25), {
                Size = opened and UDim2.new(0,260,0,170) or UDim2.new(0,260,0,0)
            }):Play()
        end
    end
end)

close.MouseButton1Click:Connect(function()
    opened = false
    panel.Size = UDim2.new(0,260,0,0)
end)

--==================================================
-- RUNTIME
--==================================================
RunService.RenderStepped:Connect(function()
    if fly and bv then
        bg.CFrame = cam.CFrame
        local vel = Vector3.zero
        if speedPercent > 0 then
            vel += cam.CFrame.LookVector * flySpeed
        end
        if goingUp then vel += Vector3.new(0,40,0) end
        if goingDown then vel -= Vector3.new(0,40,0) end
        bv.Velocity = vel
    end

    if noclip then
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

print("Mikaa Fly V1 FIX Loaded")
