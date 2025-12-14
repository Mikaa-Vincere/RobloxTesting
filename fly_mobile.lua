--==================================================
-- Mikaa Fly + Noclip (Android Only FIX + Minimal UI)
--==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- ANDROID CHECK
if not UIS.TouchEnabled then
    warn("Android only")
    return
end

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera

-- STATE
local fly = false
local noclip = false
local speed = 0

local bg, bv

--==================================================
-- UI (MINIMAL + TOGGLE)
--==================================================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

-- TOGGLE BUTTON
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0,36,0,36)
toggleBtn.Position = UDim2.new(0,10,0.5,-18)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
toggleBtn.Text = "☰"
toggleBtn.TextScaled = true
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Active = true
toggleBtn.Draggable = true

-- MAIN FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,140)
frame.Position = UDim2.new(0.5,-100,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
frame.Active = true
frame.Draggable = true
frame.Visible = true

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,26)
title.Text = "Mikaa Fly"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(15,15,15)

-- BUTTON MAKER
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

local flyBtn = btn("FLY : OFF",28)
local clipBtn = btn("NOCLIP : OFF",62)

-- SPEED TEXT
local spTxt = Instance.new("TextLabel", frame)
spTxt.Size = UDim2.new(1,-16,0,18)
spTxt.Position = UDim2.new(0,8,0,96)
spTxt.BackgroundTransparency = 1
spTxt.TextColor3 = Color3.new(1,1,1)
spTxt.TextScaled = true
spTxt.Text = "SPEED : 0%"

-- SLIDER
local bar = Instance.new("Frame", frame)
bar.Size = UDim2.new(1,-16,0,6)
bar.Position = UDim2.new(0,8,0,116)
bar.BackgroundColor3 = Color3.fromRGB(60,60,60)

local fill = Instance.new("Frame", bar)
fill.Size = UDim2.new(0,0,1,0)
fill.BackgroundColor3 = Color3.fromRGB(0,170,255)

-- TOGGLE UI
toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

--==================================================
-- FLY CORE
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
-- BUTTONS
--==================================================
flyBtn.MouseButton1Click:Connect(function()
    if fly then stopFly() else startFly() end
end)

clipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    clipBtn.Text = "NOCLIP : "..(noclip and "ON" or "OFF")
end)

bar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch then
        local x = math.clamp(
            (i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
            0,1
        )
        fill.Size = UDim2.new(x,0,1,0)
        speed = x * 180
        spTxt.Text = "SPEED : "..math.floor(x*100).."%"
    end
end)

--==================================================
-- LOOP (FIX TOTAL)
--==================================================
RunService.RenderStepped:Connect(function()
    if fly and bv and bg then
        bg.CFrame = cam.CFrame

        local moveDir = hum.MoveDirection
        local velocity = Vector3.zero

        if moveDir.Magnitude > 0 then
            velocity = moveDir * speed
            local lookY = cam.CFrame.LookVector.Y
            velocity += Vector3.new(0, lookY * speed, 0)
        end

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

print("Mikaa Fly Android Minimal UI Loaded")
