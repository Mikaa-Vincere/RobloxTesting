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
local MAX_FLY_SPEED = 200
local MAX_JUMP_POWER = 250
local SPEED_SMOOTH = 0.15

--================ STATE =================
local targetSpeed, currentSpeed = DEFAULT_SPEED, DEFAULT_SPEED
local targetJump, currentJump = DEFAULT_JUMP, DEFAULT_JUMP
local speedEnabled = false
local jumpEnabled = false
local flyEnabled = false
local noclipEnabled = false
local bg, bv
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

local function percentToValue(percent, max)
	percent = math.clamp(percent,0,100)
	return (percent/100)*max
end

local function valueToPercent(value, max)
	return math.clamp((value/max)*100,0,100)
end

local function section(titleText,y)
	local t=Instance.new("TextLabel",frame)
	t.Size=UDim2.new(1,-20,0,20)
	t.Position=UDim2.new(0,10,0,y)
	t.Text=titleText
	t.TextScaled=true
	t.TextColor3=Color3.fromRGB(0,170,255)
	t.BackgroundTransparency=1
	return y+22
end

--================ FLY BUTTON =================
local flyBtn = Instance.new("TextButton", frame)
flyBtn.Size = UDim2.new(1,0,0,22)
flyBtn.Position = UDim2.new(0,0,0,52) -- tepat di bawah WATER
flyBtn.Text = "FLY : OFF"
flyBtn.TextScaled = true
flyBtn.BackgroundTransparency = 1
flyBtn.TextColor3 = Color3.new(1,1,1)

--================ NOCLIP BUTTON =================
local noclipBtn = Instance.new("TextButton", frame)
noclipBtn.Size = UDim2.new(1,0,0,22)
noclipBtn.Position = UDim2.new(0,0,0,76) -- tepat di bawah FLY
noclipBtn.Text = "NOCLIP : OFF"
noclipBtn.TextScaled = true
noclipBtn.BackgroundTransparency = 1
noclipBtn.TextColor3 = Color3.new(1,1,1)

--================ MOVEMENT UI =================
local y = 110
y = section("🧪 Movement",y)

makeLabel("Speed Player",y)
local spBar, spFill = makeBar(y+18,Color3.fromRGB(0,170,255))
local spBox = makeBox(y,0)
y += 40

makeLabel("Speed Fly",y)
local flyBar, flyFill = makeBar(y+18,Color3.fromRGB(0,255,127))
local flyBox = makeBox(y,0)
y += 40

makeLabel("Jump Power",y)
local jpBar, jpFill = makeBar(y+18,Color3.fromRGB(255,140,0))
local jpBox = makeBox(y,0)
y += 40

--================ FLY LOGIC =================
local cam = workspace.CurrentCamera

local function enableFly()
	if not hrp then return end

	bg = Instance.new("BodyGyro")
	bg.P = 9e4
	bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
	bg.CFrame = cam.CFrame
	bg.Parent = hrp

	bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(9e9,9e9,9e9)
	bv.Velocity = Vector3.zero
	bv.Parent = hrp
end

local function disableFly()
	if bg then bg:Destroy() bg = nil end
	if bv then bv:Destroy() bv = nil end
end

flyBtn.MouseButton1Click:Connect(function()
	flyEnabled = not flyEnabled
	flyBtn.Text = "FLY : "..(flyEnabled and "ON" or "OFF")
	if flyEnabled then
		enableFly()
	else
		disableFly()
	end
end)

noclipBtn.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	noclipBtn.Text = "NOCLIP : "..(noclipEnabled and "ON" or "OFF")
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

makeLabel("SPEED",110)
makeLabel("JUMP",142)

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
	fill.BackgroundColor3 = color
	return bar, fill
end

local spBar, spFill = makeBar(130, Color3.fromRGB(0,170,255))
local jpBar, jpFill = makeBar(162, Color3.fromRGB(255,140,0))

local function makeBox(y,default)
	local b = Instance.new("TextBox", frame)
	b.Size = UDim2.new(0,50,0,18)
	b.Position = UDim2.new(1,-60,0,y)
	b.Text = tostring(default)
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(30,30,30)
	b.TextColor3 = Color3.new(1,1,1)
	return b
end

local spBox = makeBox(110, DEFAULT_SPEED)
local jpBox = makeBox(142, DEFAULT_JUMP)

local dragS, dragJ = false,false

local function percent(bar)
	return math.clamp((UIS:GetMouseLocation().X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
end

spBar.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragS=true end
end)

jpBar.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragJ=true end
end)

UIS.InputEnded:Connect(function()
	dragS=false
	dragJ=false
end)

spBox.FocusLost:Connect(function()
	local v=tonumber(spBox.Text)
	if v then targetSpeed=math.clamp(v,0,MAX_WALK_SPEED) end
end)

jpBox.FocusLost:Connect(function()
	local v=tonumber(jpBox.Text)
	if v then targetJump=math.clamp(v,0,MAX_JUMP_POWER) end
end)

--================ NOTIFICATION =================
local notif = Instance.new("TextLabel", gui)
notif.Size = UDim2.new(0,320,0,40)
notif.Position = UDim2.new(1,0,0.15,0)
notif.BackgroundTransparency = 1
notif.TextScaled = true
notif.Visible = false

local colors = {
	Color3.new(1,1,1),
	Color3.fromRGB(0,170,255),
	Color3.fromRGB(255,140,0),
	Color3.fromRGB(0,255,127),
	Color3.fromRGB(255,80,80)
}
local colorIndex=1
notif.TextColor3=colors[colorIndex]


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

local runNotif=false
local speedBox = makeBox(178,3)
local sizeBox = makeBox(206,20)
local textBox = Instance.new("TextBox",frame)
textBox.Size=UDim2.new(1,-20,0,22)
textBox.Position=UDim2.new(0,10,0,156)
textBox.TextScaled=true
textBox.BackgroundColor3=Color3.fromRGB(30,30,30)
textBox.TextColor3=Color3.new(1,1,1)

local btn=function(txt,y)
	local b=Instance.new("TextButton",frame)
	b.Size=UDim2.new(1,-20,0,22)
	b.Position=UDim2.new(0,10,0,y)
	b.Text=txt
	b.TextScaled=true
	b.BackgroundColor3=Color3.fromRGB(40,40,40)
	b.TextColor3=Color3.new(1,1,1)
	return b
end

local colorBtn=btn("GANTI WARNA",234)
local sendBtn=btn("KIRIM TEKS",260)
local stopBtn=btn("HAPUS TEKS",286)

colorBtn.MouseButton1Click:Connect(function()
	colorIndex=colorIndex%#colors+1
	notif.TextColor3=colors[colorIndex]
end)

stopBtn.MouseButton1Click:Connect(function()
	runNotif=false
	notif.Visible=false
end)

sendBtn.MouseButton1Click:Connect(function()
	if textBox.Text == "" then return end

	notif.Text = textBox.Text
	notif.TextSize = tonumber(sizeBox.Text) or 20
	notif.Visible = true
	runNotif = true

	local speed = tonumber(speedBox.Text) or 3
	local screenWidth = gui.AbsoluteSize.X
	local notifWidth = notif.AbsoluteSize.X

	task.spawn(function()
		while runNotif do
			-- mulai dari luar kanan layar
			notif.Position = UDim2.new(0, screenWidth + notifWidth, notif.Position.Y.Scale, 0)

			-- jalan ke kiri sampai benar-benar keluar
			while notif.Position.X.Offset > -notifWidth and runNotif do
				notif.Position -= UDim2.new(0, speed, 0, 0)
				RunService.RenderStepped:Wait()
			end

			RunService.RenderStepped:Wait()
		end
	end)
end)

--================ LOOP =================
local function isEditing(box)
	return box:IsFocused()
end

RunService.RenderStepped:Connect(function()
		
	--================ MOVEMENT LOGIC =================
local dragSP, dragFLY, dragJP = false, false, false
local flySpeedPercent = 0

spBar.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 then dragSP=true end
end)
flyBar.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 then dragFLY=true end
end)
jpBar.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 then dragJP=true end
end)

UIS.InputEnded:Connect(function()
	dragSP=false
	dragFLY=false
	dragJP=false
end)

spBox.FocusLost:Connect(function()
	local v=tonumber(spBox.Text)
	if v then
		speedPercent=math.clamp(v,0,100)
		targetSpeed=percentToValue(speedPercent,MAX_WALK_SPEED)
	end
end)

flyBox.FocusLost:Connect(function()
	local v=tonumber(flyBox.Text)
	if v then flySpeedPercent=math.clamp(v,0,100) end
end)

jpBox.FocusLost:Connect(function()
	local v=tonumber(jpBox.Text)
	if v then
		jumpPercent=math.clamp(v,0,100)
		targetJump=percentToValue(jumpPercent,MAX_JUMP_POWER)
	end
end)

RunService.RenderStepped:Connect(function()

	if dragSP then
		speedPercent=percent(spBar)*100
		targetSpeed=percentToValue(speedPercent,MAX_WALK_SPEED)
	end

	if dragFLY then
		flySpeedPercent=percent(flyBar)*100
	end

	if dragJP then
		jumpPercent=percent(jpBar)*100
		targetJump=percentToValue(jumpPercent,MAX_JUMP_POWER)
	end

	spFill.Size=UDim2.new(speedPercent/100,0,1,0)
	flyFill.Size=UDim2.new(flySpeedPercent/100,0,1,0)
	jpFill.Size=UDim2.new(jumpPercent/100,0,1,0)

	if not isEditing(spBox) then spBox.Text=math.floor(speedPercent).."%"
	end
	if not isEditing(flyBox) then flyBox.Text=math.floor(flySpeedPercent).."%"
	end
	if not isEditing(jpBox) then jpBox.Text=math.floor(jumpPercent).."%"
	end

	if hum then
		hum.WalkSpeed = speedEnabled and targetSpeed or DEFAULT_SPEED
		hum.JumpPower = jumpEnabled and targetJump or DEFAULT_JUMP
	end

	if flyEnabled and bv then
		bv.Velocity = cam.CFrame.LookVector *
			percentToValue(flySpeedPercent,MAX_FLY_SPEED)
	end
end)

	if walkOnWater and hrp then
		local ray=workspace:Raycast(hrp.Position,Vector3.new(0,-12,0))
		if ray and ray.Material==Enum.Material.Water then
			if not waterPart then
				waterPart=Instance.new("Part",workspace)
				waterPart.Anchored=true
				waterPart.Transparency=1
				waterPart.Size=Vector3.new(6,1,6)
			end
			waterPart.Position=ray.Position+Vector3.new(0,1,0)
		end
	elseif waterPart then
		waterPart:Destroy()
		waterPart=nil
	end
end)

print("Mikaa Dev Testing FINAL – LOCKED ✅")
