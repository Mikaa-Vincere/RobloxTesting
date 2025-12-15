
-- Combat Assist Mobile

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local cam = workspace.CurrentCamera

-- CONFIG SESTING

local AUTO_RADIUS = 8
local LOCK_RADIUS = 10

local clickDelay = 0.06
local LOCK_STRENGTH = 0.15 -- DEFAULT
local PREDICT_TIME = 0.14

local camAssist = true

-- UI

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local logo = Instance.new("ImageButton", gui)
logo.Size = UDim2.new(0,44,0,44)
logo.Position = UDim2.new(0,10,0.5,-22)
logo.Image = "rbxassetid://114257926084691"
logo.BackgroundColor3 = Color3.fromRGB(20,20,20)
logo.BorderSizePixel = 0
logo.Active = true
logo.Draggable = true

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,240,0,270)
frame.Position = UDim2.new(0.05,0,0.32,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Visible = false
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,28)
title.BackgroundColor3 = Color3.fromRGB(15,15,15)
title.Text = "Combat Assist"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true

local owner = Instance.new("TextLabel", frame)
owner.Size = UDim2.new(1,0,0,18)
owner.Position = UDim2.new(0,0,1,-18)
owner.BackgroundTransparency = 1
owner.Text = "Owner : MikaaDev"
owner.TextColor3 = Color3.new(1,1,1)
owner.TextScaled = true

logo.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

--========================
-- CAMERA SLIDER
--========================
local txt = Instance.new("TextLabel", frame)
txt.Size = UDim2.new(1,-16,0,18)
txt.Position = UDim2.new(0,8,0,40)
txt.Text = "Camera Lock Strength"
txt.TextColor3 = Color3.new(1,1,1)
txt.TextScaled = true
txt.BackgroundTransparency = 1

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0,60,0,22)
box.Position = UDim2.new(1,-68,0,62)
box.BackgroundColor3 = Color3.fromRGB(35,35,35)
box.TextColor3 = Color3.new(1,1,1)
box.TextScaled = true
box.Text = tostring(LOCK_STRENGTH)

local bar = Instance.new("Frame", frame)
bar.Size = UDim2.new(1,-80,0,6)
bar.Position = UDim2.new(0,10,0,70)
bar.BackgroundColor3 = Color3.fromRGB(60,60,60)

local fill = Instance.new("Frame", bar)
fill.BackgroundColor3 = Color3.fromRGB(255,80,80)

local function updateUI()
	local p = (0.15 - LOCK_STRENGTH) / 0.15
	p = math.clamp(p,0,1)
	fill.Size = UDim2.new(p,0,1,0)
	box.Text = string.format("%.2f", LOCK_STRENGTH)
end

bar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch then
		local x = math.clamp((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
		LOCK_STRENGTH = 0.15 - (0.15*x)
		updateUI()
	end
end)

box.FocusLost:Connect(function()
	local v = tonumber(box.Text)
	if v then
		LOCK_STRENGTH = math.clamp(v,0,0.15)
	end
	updateUI()
end)

updateUI()

--========================
-- FIND ENEMY
--========================
local function getEnemy()
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
	local hrp = char.HumanoidRootPart

	local nearest, dist = nil, LOCK_RADIUS
	for _,p in pairs(Players:GetPlayers()) do
		if p~=player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local d = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
			if d < dist then
				dist = d
				nearest = p.Character.HumanoidRootPart
			end
		end
	end
	return nearest
end

local function countEnemies(radius)
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return 0 end
	local hrp = char.HumanoidRootPart

	local c = 0
	for _,p in pairs(Players:GetPlayers()) do
		if p~=player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			if (p.Character.HumanoidRootPart.Position-hrp.Position).Magnitude <= radius then
				c += 1
			end
		end
	end
	return c
end

--========================
-- INDICATOR
--========================
local indicator = Instance.new("BillboardGui", game.CoreGui)
indicator.Size = UDim2.new(0,70,0,24)
indicator.StudsOffset = Vector3.new(0,3,0)
indicator.AlwaysOnTop = true
indicator.Enabled = false

local indTxt = Instance.new("TextLabel", indicator)
indTxt.Size = UDim2.new(1,0,1,0)
indTxt.BackgroundTransparency = 0.2
indTxt.BackgroundColor3 = Color3.fromRGB(180,0,0)
indTxt.Text = "LOCKED"
indTxt.TextColor3 = Color3.new(1,1,1)
indTxt.TextScaled = true
Instance.new("UICorner", indTxt).CornerRadius = UDim.new(0,8)

--========================
-- SPAM (1v1)
--========================
RunService.RenderStepped:Connect(function()
	if not camAssist then return end

	local enemy = getEnemy()
	if not enemy then
		indicator.Enabled = false
		return
	end

	indicator.Adornee = enemy
	indicator.Enabled = true

	if countEnemies(LOCK_RADIUS) ~= 1 then return end
	if LOCK_STRENGTH >= 0.15 then return end

	local predicted = enemy.Position + enemy.Velocity * PREDICT_TIME
	cam.CFrame = cam.CFrame:Lerp(
		CFrame.new(cam.CFrame.Position, predicted),
		LOCK_STRENGTH
	)
end)

task.spawn(function()
	while true do
		local enemy = getEnemy()
		if enemy and countEnemies(AUTO_RADIUS)==1 then
			for i=1,3 do
				VIM:SendMouseButtonEvent(0,0,0,true,game,0)
				VIM:SendMouseButtonEvent(0,0,0,false,game,0)
				task.wait(0.03)
			end
		end
		task.wait(clickDelay)
	end
end)

print("Combat Assist Loaded | MikaaDev ✅")
