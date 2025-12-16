--==================================================
-- Mikaa Dev Testing (V1) + Mikaa Fly (MERGED)
-- SPEED TERPISAH | NO LOGIC REMOVED
--==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local cam = workspace.CurrentCamera
local char, hum, hrp

--================ CONFIG =================
local DEFAULT_SPEED = 16
local DEFAULT_JUMP = 50
local MAX_WALK_SPEED = 800
local MAX_JUMP_POWER = 250
local SPEED_SMOOTH = 0.15
local FLY_MAX_SPEED = 300

--================ STATE =================
local targetSpeed, currentSpeed = DEFAULT_SPEED, DEFAULT_SPEED
local targetJump, currentJump = DEFAULT_JUMP, DEFAULT_JUMP
local speedEnabled, jumpEnabled = false, false
local walkOnWater = false
local waterPart

-- FLY STATE
local fly = false
local noclip = false
local flySpeed = 0
local bg, bv

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

	fly = false
	noclip = false
	flySpeed = 0
	if bg then bg:Destroy() bg=nil end
	if bv then bv:Destroy() bv=nil end
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
frame.Size = UDim2.new(0,220,0,520)
frame.Position = UDim2.new(0.6,0,0.15,0)
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

--================ SPEED & JUMP (ASLI) =================
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

local function makeBar(y,color)
	local bar = Instance.new("Frame", frame)
	bar.Size = UDim2.new(1,-20,0,6)
	bar.Position = UDim2.new(0,10,0,y)
	bar.BackgroundColor3 = Color3.fromRGB(60,60,60)

	local fill = Instance.new("Frame", bar)
	fill.Size = UDim2.new(0,0,1,0)
	fill.BackgroundColor3 = color
	return bar, fill
end

local spBar, spFill = makeBar(72, Color3.fromRGB(0,170,255))
local jpBar, jpFill = makeBar(104, Color3.fromRGB(255,140,0))

--================ FLY UI (TERPISAH) =================
makeLabel("FLY",320)

local flyBtn = Instance.new("TextButton", frame)
flyBtn.Size = UDim2.new(0.45,0,0,20)
flyBtn.Position = UDim2.new(0.05,0,0,340)
flyBtn.Text = "FLY : OFF"
flyBtn.TextScaled = true
flyBtn.BackgroundColor3 = Color3.fromRGB(120,40,40)
flyBtn.TextColor3 = Color3.new(1,1,1)

local clipBtn = Instance.new("TextButton", frame)
clipBtn.Size = UDim2.new(0.45,0,0,20)
clipBtn.Position = UDim2.new(0.5,0,0,340)
clipBtn.Text = "NOCLIP : OFF"
clipBtn.TextScaled = true
clipBtn.BackgroundColor3 = Color3.fromRGB(120,40,40)
clipBtn.TextColor3 = Color3.new(1,1,1)

local flyBar, flyFill = makeBar(370, Color3.fromRGB(0,255,150))

flyBtn.MouseButton1Click:Connect(function()
	fly = not fly
	flyBtn.Text = "FLY : "..(fly and "ON" or "OFF")
	flyBtn.BackgroundColor3 = fly and Color3.fromRGB(40,120,40) or Color3.fromRGB(120,40,40)

	if fly and hrp then
		bg = Instance.new("BodyGyro", hrp)
		bg.P = 9e4
		bg.MaxTorque = Vector3.new(9e9,9e9,9e9)

		bv = Instance.new("BodyVelocity", hrp)
		bv.MaxForce = Vector3.new(9e9,9e9,9e9)
	else
		if bg then bg:Destroy() bg=nil end
		if bv then bv:Destroy() bv=nil end
	end
end)

clipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	clipBtn.Text = "NOCLIP : "..(noclip and "ON" or "OFF")
end)

--================ WATER WALK PHYSICS =================
local function updateWaterWalk()
	if not walkOnWater or not hrp then
		if waterPart then
			waterPart:Destroy()
			waterPart = nil
		end
		return
	end

	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = {char}
	rayParams.FilterType = Enum.RaycastFilterType.Blacklist

	local ray = workspace:Raycast(
		hrp.Position,
		Vector3.new(0, -20, 0),
		rayParams
	)

	if ray and ray.Material == Enum.Material.Water then
		if not waterPart then
			waterPart = Instance.new("Part")
			waterPart.Anchored = true
			waterPart.CanCollide = true
			waterPart.Transparency = 1
			waterPart.Size = Vector3.new(20, 1, 20)
			waterPart.Name = "WaterWalkPart"
			waterPart.Parent = workspace
		end

		waterPart.Position = Vector3.new(
			hrp.Position.X,
			ray.Position.Y + 1,
			hrp.Position.Z
		)
	else
		if waterPart then
			waterPart:Destroy()
			waterPart = nil
		end
	end
end

--================ UI HELPER (WAJIB ADA) =================
local function makeBox(y,default)
	local b = Instance.new("TextBox", frame)
	b.Size = UDim2.new(0,50,0,18)
	b.Position = UDim2.new(1,-60,0,y)
	b.Text = tostring(default)
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(30,30,30)
	b.TextColor3 = Color3.new(1,1,1)
	b.ClearTextOnFocus = false
	return b
end

local function btn(txt,y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(1,-20,0,22)
	b.Position = UDim2.new(0,10,0,y)
	b.Text = txt
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	return b
end

--================ NOTIFICATION (FINAL GABUNG) =================
local notif = Instance.new("TextLabel", gui)
notif.Size = UDim2.new(0,320,0,40)
notif.Position = UDim2.new(0.5,-160,0.05,0) -- TENGAH ATAS
notif.BackgroundTransparency = 1
notif.TextScaled = true
notif.Visible = false
notif.ZIndex = 50

local colors = {
	Color3.new(1,1,1),
	Color3.fromRGB(0,170,255),
	Color3.fromRGB(255,140,0),
	Color3.fromRGB(0,255,127),
	Color3.fromRGB(255,80,80)
}
local colorIndex = 1
notif.TextColor3 = colors[colorIndex]

local runNotif = false

-- UI CONTROL (ASLI, POSISI DIRAPIKAN)
local notifSpeedLabel = Instance.new("TextLabel", frame)
notifSpeedLabel.Size = UDim2.new(0.6,0,0,18)
notifSpeedLabel.Position = UDim2.new(0.05,0,0,178)
notifSpeedLabel.Text = "NOTIF SPEED"
notifSpeedLabel.TextScaled = true
notifSpeedLabel.BackgroundTransparency = 1
notifSpeedLabel.TextColor3 = Color3.fromRGB(200,200,200)

local notifSizeLabel = Instance.new("TextLabel", frame)
notifSizeLabel.Size = UDim2.new(0.6,0,0,18)
notifSizeLabel.Position = UDim2.new(0.05,0,0,206)
notifSizeLabel.Text = "TEXT SIZE"
notifSizeLabel.TextScaled = true
notifSizeLabel.BackgroundTransparency = 1
notifSizeLabel.TextColor3 = Color3.fromRGB(200,200,200)

local speedBox = makeBox(178,3)
local sizeBox  = makeBox(206,20)

local textBox = Instance.new("TextBox",frame)
textBox.Size = UDim2.new(1,-20,0,22)
textBox.Position = UDim2.new(0,10,0,156)
textBox.TextScaled = true
textBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
textBox.TextColor3 = Color3.new(1,1,1)

local colorBtn = btn("GANTI WARNA",234)
local sendBtn  = btn("KIRIM TEKS",260)
local stopBtn  = btn("HAPUS TEKS",286)

colorBtn.MouseButton1Click:Connect(function()
	colorIndex = colorIndex % #colors + 1
	notif.TextColor3 = colors[colorIndex]
end)

stopBtn.MouseButton1Click:Connect(function()
	runNotif = false
	notif.Visible = false
end)

sendBtn.MouseButton1Click:Connect(function()
	if textBox.Text == "" then return end

	notif.Text = textBox.Text
	notif.TextSize = tonumber(sizeBox.Text) or 20
	notif.Visible = true
	runNotif = true

	local speed = tonumber(speedBox.Text) or 3
	local guiWidth = gui.AbsoluteSize.X
	local notifWidth = notif.AbsoluteSize.X

	task.spawn(function()
		while runNotif do
			-- mulai dari kanan layar
			notif.Position = UDim2.new(0, guiWidth, notif.Position.Y.Scale, 0)

			while notif.Position.X.Offset > -notifWidth and runNotif do
				notif.Position -= UDim2.new(0, speed, 0, 0)
				RunService.RenderStepped:Wait()
			end

			RunService.RenderStepped:Wait()
		end
	end)
end)

--================ LOOP (SEMUA DIGABUNG) =================
RunService.RenderStepped:Connect(function()
	-- SPEED & JUMP ASLI
	if hum then
		if speedEnabled then
			currentSpeed += (targetSpeed-currentSpeed)*SPEED_SMOOTH
			hum.WalkSpeed = currentSpeed
		else
			hum.WalkSpeed = DEFAULT_SPEED
		end

		if jumpEnabled then
			currentJump += (targetJump-currentJump)*SPEED_SMOOTH
			hum.JumpPower = currentJump
		else
			hum.JumpPower = DEFAULT_JUMP
		end
	end

	-- FLY CORE
	if fly and bg and bv and hum then
		bg.CFrame = cam.CFrame
		local dir = hum.MoveDirection
		bv.Velocity = dir.Magnitude > 0 and (dir * flySpeed) or Vector3.zero
	end

	-- NOCLIP
	if noclip and char then
		for _,v in ipairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end

	-- WATER WALK
                updateWaterWalk()
end)

print("Mikaa Dev Testing + Fly MERGED FINAL ✅")
