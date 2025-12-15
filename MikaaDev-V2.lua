--==================================================
-- Combat Assist Mobile | Owner : MikaaDev
--==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local cam = workspace.CurrentCamera

--========================
-- SETTINGS
--========================
local AUTO_RADIUS = 8
local LOCK_RADIUS = 10

local MIN_DELAY = 0.03
local MAX_DELAY = 0.25
local clickDelay = 0.1

local MOVE_RADIUS = 8
local STOP_RADIUS = 6
local MOVE_FORCE = 8
local PREDICT_TIME = 0.12

--========================
-- STATE
--========================
local autoClick = false
local spamClick = false
local camLock = true
local autoMove = true

--========================
-- UI MAIN
--========================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,240,0,300)
frame.Position = UDim2.new(0.05,0,0.35,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
frame.Visible = false

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,28)
title.BackgroundColor3 = Color3.fromRGB(15,15,15)
title.Text = "Combat Assist"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true

local function button(txt,y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(1,-12,0,28)
	b.Position = UDim2.new(0,6,0,y)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	b.TextScaled = true
	b.Text = txt
	return b
end

local autoBtn = button("AUTO CLICK : OFF",36)
local spamBtn = button("SPAM CLICK : OFF",68)
local camBtn  = button("CAM LOCK : ON",100)
local moveBtn = button("AUTO MOVE : ON",132)

--========================
-- SPEED UI
--========================
local speedTxt = Instance.new("TextLabel", frame)
speedTxt.Size = UDim2.new(1,0,0,18)
speedTxt.Position = UDim2.new(0,0,0,168)
speedTxt.BackgroundTransparency = 1
speedTxt.TextColor3 = Color3.new(1,1,1)
speedTxt.TextScaled = true
speedTxt.Text = "Click Speed"

local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(0,60,0,22)
speedBox.Position = UDim2.new(1,-66,0,190)
speedBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.TextScaled = true
speedBox.Text = tostring(clickDelay)

local sliderBg = Instance.new("Frame", frame)
sliderBg.Size = UDim2.new(1,-80,0,6)
sliderBg.Position = UDim2.new(0,10,0,200)
sliderBg.BackgroundColor3 = Color3.fromRGB(60,60,60)

local sliderFill = Instance.new("Frame", sliderBg)
sliderFill.BackgroundColor3 = Color3.fromRGB(0,170,255)

local function updateSlider()
	local a = 1 - ((clickDelay - MIN_DELAY)/(MAX_DELAY-MIN_DELAY))
	a = math.clamp(a,0,1)
	sliderFill.Size = UDim2.new(a,0,1,0)
	speedBox.Text = string.format("%.2f", clickDelay)
end

sliderBg.InputBegan:Connect(function(i)
	local x = math.clamp(
		(i.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X,
		0,1
	)
	clickDelay = MIN_DELAY + (MAX_DELAY-MIN_DELAY)*(1-x)
	updateSlider()
end)

speedBox.FocusLost:Connect(function()
	local v = tonumber(speedBox.Text)
	if v then
		clickDelay = math.clamp(v, MIN_DELAY, MAX_DELAY)
	end
	updateSlider()
end)

updateSlider()

--========================
-- BUTTON LOGIC
--========================
autoBtn.MouseButton1Click:Connect(function()
	autoClick = not autoClick
	if autoClick then
		spamClick = false
		spamBtn.Text = "SPAM CLICK : OFF"
	end
	autoBtn.Text = "AUTO CLICK : "..(autoClick and "ON" or "OFF")
end)

spamBtn.MouseButton1Click:Connect(function()
	spamClick = not spamClick
	if spamClick then
		autoClick = false
		autoBtn.Text = "AUTO CLICK : OFF"
	end
	spamBtn.Text = "SPAM CLICK : "..(spamClick and "ON" or "OFF")
end)

camBtn.MouseButton1Click:Connect(function()
	camLock = not camLock
	camBtn.Text = "CAM LOCK : "..(camLock and "ON" or "OFF")
end)

moveBtn.MouseButton1Click:Connect(function()
	autoMove = not autoMove
	moveBtn.Text = "AUTO MOVE : "..(autoMove and "ON" or "OFF")
end)

--========================
-- LOGO + OWNER
--========================
local logoBtn = Instance.new("ImageButton", gui)
logoBtn.Size = UDim2.new(0,45,0,45)
logoBtn.Position = UDim2.new(0,10,0.5,-22)
logoBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
logoBtn.BorderSizePixel = 0
logoBtn.Image = "rbxassetid://114257926084691"
logoBtn.Active = true
logoBtn.Draggable = true

local ownerFrame = Instance.new("Frame", gui)
ownerFrame.Size = UDim2.new(0,170,0,50)
ownerFrame.Position = UDim2.new(0,60,0.5,-25)
ownerFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
ownerFrame.Visible = false

local ownerTxt = Instance.new("TextLabel", ownerFrame)
ownerTxt.Size = UDim2.new(1,0,1,0)
ownerTxt.BackgroundTransparency = 1
ownerTxt.Text = "Owner : MikaaDev"
ownerTxt.TextColor3 = Color3.new(1,1,1)
ownerTxt.TextScaled = true
ownerTxt.Font = Enum.Font.GothamBold

logoBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
	ownerFrame.Visible = frame.Visible
end)

--========================
-- FIND ENEMY
--========================
local function getEnemy()
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
	local hrp = char.HumanoidRootPart

	local nearest, dist = nil, LOCK_RADIUS
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local d = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
			if d < dist then
				dist = d
				nearest = p.Character.HumanoidRootPart
			end
		end
	end
	return nearest
end

--========================
-- MAIN LOOP
--========================
RunService.RenderStepped:Connect(function()
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local hrp = char.HumanoidRootPart
	local hum = char:FindFirstChild("Humanoid")

	local enemy = getEnemy()
	if not enemy then return end

	local predicted = enemy.Position + enemy.Velocity * PREDICT_TIME

	if camLock then
		cam.CFrame = cam.CFrame:Lerp(
			CFrame.new(cam.CFrame.Position, predicted),
			0.15
		)
	end

	if autoMove and hum then
		local d = (predicted - hrp.Position).Magnitude
		if d <= MOVE_RADIUS and d > STOP_RADIUS then
			local dir = (predicted - hrp.Position).Unit
			hrp.Velocity = Vector3.new(dir.X*MOVE_FORCE, hrp.Velocity.Y, dir.Z*MOVE_FORCE)
		end
	end
end)

--========================
-- CLICK LOOP
--========================
task.spawn(function()
	while true do
		if getEnemy() then
			if autoClick then
				VIM:SendMouseButtonEvent(0,0,0,true,game,0)
				VIM:SendMouseButtonEvent(0,0,0,false,game,0)
			end
			if spamClick then
				for i=1,3 do
					VIM:SendMouseButtonEvent(0,0,0,true,game,0)
					VIM:SendMouseButtonEvent(0,0,0,false,game,0)
					task.wait(0.03)
				end
			end
		end
		task.wait(clickDelay)
	end
end)

print("Combat Assist Loaded | Owner : MikaaDev ✅")
