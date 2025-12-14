--==================================================
-- Mikaa Fly
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
local cam = workspace.CurrentCamera

local char, hum, hrp
local fly = false
local noclip = false
local speed = 0

local bg, bv
local MAX_SPEED = 300

--==================================================
-- CHARACTER LOAD / RESPAWN FIX
--==================================================
local function loadChar(c)
    char = c
    hum = char:WaitForChild("Humanoid")
    hrp = char:WaitForChild("HumanoidRootPart")

    fly = false
    noclip = false
    speed = 0

    if bg then bg:Destroy() bg = nil end
    if bv then bv:Destroy() bv = nil end

    task.wait()

    if flyBtn then flyBtn.Text = "FLY : OFF" end
    if clipBtn then clipBtn.Text = "NOCLIP : OFF" end
    if spTxt then spTxt.Text = "SPEED : 0%" end
    if spInput then spInput.Text = "0" end
    if fill then fill.Size = UDim2.new(0,0,1,0) end
end

player.CharacterAdded:Connect(loadChar)
if player.Character then loadChar(player.Character) end

--==================================================
-- UI (MINIMAL + TOGGLE)
--==================================================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0,36,0,36)
toggleBtn.Position = UDim2.new(0,10,0.5,-18)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
toggleBtn.Text = "☰"
toggleBtn.TextScaled = true
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Active = true
toggleBtn.Draggable = true

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,140)
frame.Position = UDim2.new(0.5,-100,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,26)
title.Text = "Mikaa Fly"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(15,15,15)

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

flyBtn = btn("FLY : OFF",28)
clipBtn = btn("NOCLIP : OFF",62)

spTxt = Instance.new("TextLabel", frame)
spTxt.Size = UDim2.new(1,-16,0,18)
spTxt.Position = UDim2.new(0,8,0,96)
spTxt.BackgroundTransparency = 1
spTxt.TextColor3 = Color3.new(1,1,1)
spTxt.TextScaled = true
spTxt.Text = "SPEED : 0%"

spInput = Instance.new("TextBox", frame)
spInput.Size = UDim2.new(0,42,0,18)
spInput.Position = UDim2.new(1,-50,0,96)
spInput.BackgroundColor3 = Color3.fromRGB(35,35,35)
spInput.TextColor3 = Color3.new(1,1,1)
spInput.TextScaled = true
spInput.Text = "0"
spInput.ClearTextOnFocus = false

bar = Instance.new("Frame", frame)
bar.Size = UDim2.new(1,-16,0,6)
bar.Position = UDim2.new(0,8,0,116)
bar.BackgroundColor3 = Color3.fromRGB(60,60,60)

fill = Instance.new("Frame", bar)
fill.Size = UDim2.new(0,0,1,0)
fill.BackgroundColor3 = Color3.fromRGB(0,170,255)

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

--==================================================
-- SPEED SYSTEM
--==================================================
local function setSpeed(percent)
    percent = math.clamp(percent,0,100)
    speed = (percent/100) * MAX_SPEED
    fill.Size = UDim2.new(percent/100,0,1,0)
    spTxt.Text = "SPEED : "..percent.."%"
    spInput.Text = tostring(percent)
end

bar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch then
        local x = math.clamp(
            (i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,0,1
        )
        setSpeed(math.floor(x*100))
    end
end)

spInput.FocusLost:Connect(function()
    setSpeed(tonumber(spInput.Text) or 0)
end)

--==================================================
-- FLY CORE (FIX)
--==================================================
local function startFly()
    if not hrp then return end
    fly = true

    if bg then bg:Destroy() end
    if bv then bv:Destroy() end

    bg = Instance.new("BodyGyro", hrp)
    bg.P = 9e4
    bg.MaxTorque = Vector3.new(9e9,9e9,9e9)

    bv = Instance.new("BodyVelocity", hrp)
    bv.MaxForce = Vector3.new(9e9,9e9,9e9)

    flyBtn.Text = "FLY : ON"
end

local function stopFly()
    fly = false
    if bg then bg:Destroy() bg=nil end
    if bv then bv:Destroy() bv=nil end
    flyBtn.Text = "FLY : OFF"
end

flyBtn.MouseButton1Click:Connect(function()
    if fly then stopFly() else startFly() end
end)

clipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    clipBtn.Text = "NOCLIP : "..(noclip and "ON" or "OFF")
end)

--==================================================
-- LOOP
--==================================================
RunService.RenderStepped:Connect(function()
    if fly and bg and bv and hum then
        bg.CFrame = cam.CFrame
        local dir = hum.MoveDirection
        if dir.Magnitude > 0 then
            bv.Velocity = (dir + Vector3.new(0,cam.CFrame.LookVector.Y,0)) * speed
        else
            bv.Velocity = Vector3.zero
        end
    end

    if noclip and char then
        for _,v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

print("Mikaa Fly FIXED + RESPAWN SAFE ✅")
