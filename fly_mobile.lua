--==================================================
-- Mikaa Fly + Noclip (Android Only FIX)
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
-- UI
--==================================================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,190)
frame.Position = UDim2.new(0.5,-130,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,35)
title.Text = "Mikaa Fly"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(15,15,15)

local function btn(txt,y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-20,0,40)
    b.Position = UDim2.new(0,10,0,y)
    b.BackgroundColor3 = Color3.fromRGB(45,45,45)
    b.TextColor3 = Color3.new(1,1,1)
    b.TextScaled = true
    b.Text = txt
    return b
end

local flyBtn = btn("FLY : OFF",45)
local clipBtn = btn("NOCLIP : OFF",95)

-- SPEED TEXT
local spTxt = Instance.new("TextLabel", frame)
spTxt.Size = UDim2.new(1,-20,0,25)
spTxt.Position = UDim2.new(0,10,0,145)
spTxt.BackgroundTransparency = 1
spTxt.TextColor3 = Color3.new(1,1,1)
spTxt.TextScaled = true
spTxt.Text = "SPEED : 0%"

-- SLIDER
local bar = Instance.new("Frame", frame)
bar.Size = UDim2.new(1,-20,0,8)
bar.Position = UDim2.new(0,10,0,170)
bar.BackgroundColor3 = Color3.fromRGB(60,60,60)

local fill = Instance.new("Frame", bar)
fill.Size = UDim2.new(0,0,1,0)
fill.BackgroundColor3 = Color3.fromRGB(0,170,255)

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
        local x = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,0,1)
        fill.Size = UDim2.new(x,0,1,0)
        speed = x * 45 -- SPEED MAKS (CEPAT)
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
            -- horizontal move
            velocity = moveDir * speed

            -- vertical by camera (LOOK UP / DOWN)
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

print("Mikaa Fly Android FIX Loaded")
