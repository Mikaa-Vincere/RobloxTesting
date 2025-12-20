--==================================================
-- Mikaa Dev Testing (V1)
--==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char, hum, hrp

--================ CONFIG =================
local DEFAULT_SPEED = 16
local DEFAULT_JUMP = 50
local MAX_WALK_SPEED = 800
local MAX_JUMP_POWER = 250
local SPEED_SMOOTH = 0.15

--================ STATE =================
local targetSpeed, currentSpeed = DEFAULT_SPEED, DEFAULT_SPEED
local targetJump, currentJump = DEFAULT_JUMP, DEFAULT_JUMP
local speedEnabled = false
local jumpEnabled = false
local walkOnWater = false
local waterPart

local speedPercent = 0
local jumpPercent = 0
--================ CHARACTER =================
local function resetStats()
	targetSpeed, currentSpeed = DEFAULT_SPEED, DEFAULT_SPEED
	targetJump, currentJump = DEFAULT_JUMP, DEFAULT_JUMP
end

local function loadChar(c)
	char = c
	hum = c:WaitForChild("Humanoid")
	hrp = c:WaitForChild("HumanoidRootPart")
	resetStats()
	hum.WalkSpeed = DEFAULT_SPEED
	hum.JumpPower = DEFAULT_JUMP
end

player.CharacterAdded:Connect(loadChar)
if player.Character then loadChar(player.Character) end

--================ UI CORE =================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local logo = Instance.new("ImageButton", gui)
logo.Size = UDim2.new(0,40,0,40)
logo.Position = UDim2.new(0,10,0.5,-20)
logo.Image = "rbxassetid://100166477433523"
logo.BackgroundColor3 = Color3.fromRGB(20,20,20)
logo.BorderSizePixel = 0
logo.Active, logo.Draggable = true, true

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,220,0,420)
frame.Position = UDim2.new(0.6,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.Active, frame.Draggable = true, true

logo.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,26)
title.Text = "Mikaa Dev Testing"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(20,20,20)

--================ WATER =================
local waterBtn = Instance.new("TextButton", frame)
waterBtn.Size = UDim2.new(1,0,0,22)
waterBtn.Position = UDim2.new(0,0,0,28)
waterBtn.Text = "WATER : OFF"
waterBtn.TextScaled = true
waterBtn.BackgroundTransparency = 1
waterBtn.TextColor3 = Color3.new(1,1,1)

waterBtn.MouseButton1Click:Connect(function()
	walkOnWater = not walkOnWater
	waterBtn.Text = "WATER : "..(walkOnWater and "ON" or "OFF")
end)

--================ SPEED & JUMP =================
local function makeLabel(text,y)
	local l = Instance.new("TextLabel", frame)
	l.Size = UDim2.new(1,0,0,18)
	l.Position = UDim2.new(0,0,0,y)
	l.Text = text
	l.TextScaled = true
	l.TextColor3 = Color3.new(1,1,1)
	l.BackgroundTransparency = 1
	return l
end

makeLabel("SPEED",52)
makeLabel("JUMP",84)

local speedPercentLabel = Instance.new("TextLabel", frame)
speedPercentLabel.Size = UDim2.new(0.3,0,0,18)
speedPercentLabel.Position = UDim2.new(0.65,0,0,52)
speedPercentLabel.Text = "0%"
speedPercentLabel.TextScaled = true
speedPercentLabel.BackgroundTransparency = 1
speedPercentLabel.TextColor3 = Color3.fromRGB(0,170,255)

local jumpPercentLabel = Instance.new("TextLabel", frame)
jumpPercentLabel.Size = UDim2.new(0.3,0,0,18)
jumpPercentLabel.Position = UDim2.new(0.65,0,0,84)
jumpPercentLabel.Text = "0%"
jumpPercentLabel.TextScaled = true
jumpPercentLabel.BackgroundTransparency = 1
jumpPercentLabel.TextColor3 = Color3.fromRGB(255,140,0)

local speedBtn = Instance.new("TextButton", frame)
speedBtn.Size = UDim2.new(0.45,0,0,18)
speedBtn.Position = UDim2.new(0.05,0,0,120)
speedBtn.Text = "SPEED : OFF"
speedBtn.TextScaled = true
speedBtn.BackgroundColor3 = Color3.fromRGB(120,40,40)
speedBtn.TextColor3 = Color3.new(1,1,1)

local jumpBtn = Instance.new("TextButton", frame)
jumpBtn.Size = UDim2.new(0.45,0,0,18)
jumpBtn.Position = UDim2.new(0.5,0,0,120)
jumpBtn.Text = "JUMP : OFF"
jumpBtn.TextScaled = true
jumpBtn.BackgroundColor3 = Color3.fromRGB(120,40,40)
jumpBtn.TextColor3 = Color3.new(1,1,1)

speedBtn.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	speedBtn.Text = "SPEED : "..(speedEnabled and "ON" or "OFF")
	speedBtn.BackgroundColor3 = speedEnabled
		and Color3.fromRGB(40,120,40)
		or Color3.fromRGB(120,40,40)
end)

jumpBtn.MouseButton1Click:Connect(function()
	jumpEnabled = not jumpEnabled
	jumpBtn.Text = "JUMP : "..(jumpEnabled and "ON" or "OFF")
	jumpBtn.BackgroundColor3 = jumpEnabled
		and Color3.fromRGB(40,120,40)
		or Color3.fromRGB(120,40,40)
end)

local function makeBar(y,color)
	local bar = Instance.new("Frame", frame)
	bar.Size = UDim2.new(1,-20,0,6)
	bar.Position = UDim2.new(0,10,0,y)
	bar.BackgroundColor3 = Color3.fromRGB(60,60,60)

	local fill = Instance.new("Frame", bar)
	fill.Size = UDim2.new(0,0,1,0)
	fill.Backgro
