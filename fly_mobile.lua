--==================================================
-- Mikaa Fly V1 - ANDROID ONLY (FIX)
-- Analog SAFE | No Auto Move | Clean
--==================================================

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- ANDROID CHECK
if not UIS.TouchEnabled then
    warn("Mikaa Fly: Android only")
    return
end

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera

-- STATES
local fly = false
local noclip = false
local speed = 0
local up, down = false, false

local bg, bv

--==================================================
-- UI
--==================================================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,170)
frame.Position = UDim2.new(0.5,-130,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,-40,0,35)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "Mikaa Fly V1"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0,35,0,35)
close.Position = UDim2.new(1,-35,0,0)
close.Text = "X"
close.TextScaled = true
close.BackgroundColor3 = Color3.fromRGB(120,30,30)

local function btn(txt,y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-20,0,35)
    b.Position = UDim2.new(0,10,0,y)
    b.BackgroundColor3 = Color3.fromRGB(45,45,45)
    b.TextColor3 = Color3.new(1,1,1)
    b.TextScaled = true
    b.Text = txt
    return b
end

local flyBtn = btn("FLY : OFF",45)
local clipBtn = btn("NOCLIP : OFF",85)

local speedTxt = Instance.new("TextLabel", frame)
speedTxt.Size = UDim2.new(1,-20,0,25)
speedTxt.Position = UDim2.new(0,10,0,125)
speedTxt.BackgroundTransparency = 1
speedTxt.TextColor3 = Color3.new(1,1,1)
speedTxt.TextScaled = true
speedTxt.Text = "SPEED : 0%"

-- SLIDER
local bar = Instance.new("Frame", frame)
bar.Size = UDim2.new(1,-20,0,8)
bar.Position = UDim2.new(0,10,0,155)
bar.BackgroundColor3 = Color3.fromRGB(60,60,60)

local fill = Instance.new("Frame", bar)
fill.Size = UDim2.new(0,0,1,0)
fill.BackgroundColor3 = Color3.fromRGB(0,170,255)

-- UP / DOWN BUTTON
local function moveBtn(txt,pos)
    local b = Instance.new("TextButton", gui)
    b.Size = UDim2.new(0,60,0,60)
    b.Position = pos
    b.Text = txt
    b.TextScaled = true
    b.BackgroundColor3 = Color3.fromRGB(30,30,30)
    b.TextColor3 = Color3.new(1,1,1)
    return b
end

local upBtn = moveBtn("▲", UDim2.new(0.5,-80,0.75,0))
local dnBtn = moveBtn("▼", UDim2.new(0.5,20,0.75,0))

--==================================================
-- FLY CORE (ANALOG BASED)
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
-- INPUT
--==================================================
flyBtn.MouseButton1Click:Connect(function()
    if fly then stopFly() else startFly() end
end)

clipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    clipBtn.Text = "NOCLIP : "..(noclip and "ON" or "OFF")
end)

upBtn.MouseButton1Down:Connect(function() up = true end)
upBtn.MouseButton1Up:Connect(function() up = false end)
dnBtn.MouseButton1Down:Connect(function() down = true end)
dnBtn.MouseButton1Up:Connect(function() down = false end)

bar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch then
        local x = math.clamp((i.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
        fill.Size = UDim2.new(x,0,1,0)
        speed = x * 35 -- ONLY HORIZONTAL SPEED
        speedTxt.Text = "SPEED : "..math.floor(x*100).."%"
    end
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

--==================================================
-- LOOP
--==================================================
RunService.RenderStepped:Connect(function()
    if fly and bv then
        bg.CFrame = cam.CFrame

        -- ANALOG BASED MOVE (FIX)
        local moveDir = hum.MoveDirection
        local velocity = moveDir * speed

        if up then velocity += Vector3.new(0,35,0) end
        if down then velocity -= Vector3.new(0,35,0) end

        bv.Velocity = velocity
    end

    if noclip then
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

print("Mikaa Fly Android FIX Loaded")
