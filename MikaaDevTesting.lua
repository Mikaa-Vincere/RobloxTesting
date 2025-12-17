
-- Mikaa Dev Testing Labubu
-- OWN : Mikaa

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- PLAYER
local player = Players.LocalPlayer
local char, hum, hrp
local cam = workspace.CurrentCamera

-- CONFIG
local DEFAULT_SPEED = 16
local DEFAULT_JUMP = 50
local MAX_WALK_SPEED = 800
local MAX_FLY_SPEED = 200
local MAX_JUMP_POWER = 250
local SMOOTH = 0.15

-- STATE
local speedEnabled = false
local jumpEnabled = false
local flyEnabled = false
local noclipEnabled = false
local walkOnWater = false

local speedPercent = 0
local jumpPercent = 0
local flyPercent = 0

local targetSpeed = DEFAULT_SPEED
local currentSpeed = DEFAULT_SPEED
local targetJump = DEFAULT_JUMP
local currentJump = DEFAULT_JUMP

local bg, bv, waterPart

local function enableFly()
	if not hrp or not hum then return end

	-- KUNCI KARAKTER (BUKAN PHYSICS)
	hum.PlatformStand = true

	bg = Instance.new("BodyGyro")
	bg.P = 100000
	bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	bg.CFrame = cam.CFrame
	bg.Parent = hrp

	bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	bv.Velocity = Vector3.zero
	bv.Parent = hrp
end

local function disableFly()
	if not hum then return end

	-- BALIKIN KONTROL
	hum.PlatformStand = false

	-- PAKSA STATE NORMAL
	local state = hum:GetState()
	if state == Enum.HumanoidStateType.Physics
	or state == Enum.HumanoidStateType.FallingDown
	or state == Enum.HumanoidStateType.Ragdoll then
		hum:ChangeState(Enum.HumanoidStateType.GettingUp)
	end

	if bg then bg:Destroy() bg = nil end
	if bv then bv:Destroy() bv = nil end
end

--==================================================
-- NOCLIP FUNCTION (HARUS DI ATAS)
--==================================================
local function setNoclip(state)
	if not char then return end
	for _,v in ipairs(char:GetDescendants()) do
		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
			v.CanCollide = not state
		end
	end
end

--==================================================
-- CHARACTER
--==================================================
local function loadChar(c)
	char = c
	hum = c:WaitForChild("Humanoid")
	hrp = c:WaitForChild("HumanoidRootPart")

	hum.WalkSpeed = DEFAULT_SPEED
	hum.JumpPower = DEFAULT_JUMP
	hum.PlatformStand = false

	-- RESET COLLISION (PENTING)
	task.wait()
	for _,v in ipairs(char:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = true
		end
	end

	-- AUTO RE-FLY SAAT RESPAWN
	if flyEnabled then
		task.wait(0.2)
		enableFly()
	end

-- RE-APPLY NOCLIP SAAT RESPAWN
if noclipEnabled then
	task.wait(0.1)
	setNoclip(true)
    end
end

player.CharacterAdded:Connect(loadChar)
if player.Character then
	loadChar(player.Character)
end

--==================================================
-- HELPERS
--==================================================
local function percentToValue(p,max)
	return math.clamp(p,0,100)/100*max
end

local function mousePercent(bar)
	return math.clamp(
		(UIS:GetMouseLocation().X - bar.AbsolutePosition.X)
		/ bar.AbsoluteSize.X,0,1)
end

--==================================================
-- UI SCREEN
--==================================================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

-- LOGO UI
local logo = Instance.new("ImageButton", gui)
logo.Size = UDim2.new(0,40,0,40)
logo.Position = UDim2.new(0,10,0.5,-20)
logo.Image = "rbxassetid://100166477433523"
logo.BackgroundColor3 = Color3.fromRGB(20,20,20)
logo.BorderSizePixel = 0
logo.Active, logo.Draggable = true, true

-- FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,240,0,380)
frame.Position = UDim2.new(0.6,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.Visible = true
frame.Active, frame.Draggable = true, true

logo.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,28)
title.Text = "Mikaa Dev Testing"
title.TextScaled = true
title.BackgroundColor3 = Color3.fromRGB(20,20,20)
title.TextColor3 = Color3.new(1,1,1)

--==================================================
-- UI FACTORY
--==================================================
local function makeRow(text,y,color,hasToggle)
	local label=Instance.new("TextLabel",frame)
	label.Text=text
	label.Size=UDim2.new(0.5,0,0,18)
	label.Position=UDim2.new(0,10,0,y)
	label.BackgroundTransparency=1
	label.TextScaled=true
	label.TextColor3=Color3.new(1,1,1)

	local toggle
	if hasToggle then
		toggle=Instance.new("TextButton",frame)
		toggle.Size=UDim2.new(0,42,0,18)
		toggle.Position=UDim2.new(1,-120,0,y)
		toggle.Text="OFF"
		toggle.TextScaled=true
		toggle.BackgroundColor3=Color3.fromRGB(120,40,40)
		toggle.TextColor3=Color3.new(1,1,1)
	end

	local box=Instance.new("TextBox",frame)
	box.Size=UDim2.new(0,50,0,18)
	box.Position=UDim2.new(1,-60,0,y)
	box.Text="0"
	box.TextScaled=true
	box.BackgroundColor3=Color3.fromRGB(30,30,30)
	box.TextColor3=Color3.new(1,1,1)

	local bar=Instance.new("Frame",frame)
	bar.Size=UDim2.new(1,-20,0,6)
	bar.Position=UDim2.new(0,10,0,y+22)
	bar.BackgroundColor3=Color3.fromRGB(60,60,60)

	local fill=Instance.new("Frame",bar)
	fill.Size=UDim2.new(0,0,1,0)
	fill.BackgroundColor3=color

	return toggle,box,bar,fill
end

--==================================================
-- MOVEMENT UI
--==================================================
local y=40
local speedToggle,spBox,spBar,spFill=makeRow("Speed Player",y,Color3.fromRGB(0,170,255),true)
y+=44
local _,flyBox,flyBar,flyFill=makeRow("Speed Fly",y,Color3.fromRGB(0,255,127),false)
y+=44
local jumpToggle,jpBox,jpBar,jpFill=makeRow("Jump Power",y,Color3.fromRGB(255,140,0),true)

--==================================================
-- TOGGLES
--==================================================
speedToggle.MouseButton1Click:Connect(function()
	speedEnabled=not speedEnabled
	speedToggle.Text=speedEnabled and "ON" or "OFF"
	speedToggle.BackgroundColor3=speedEnabled and Color3.fromRGB(40,120,40) or Color3.fromRGB(120,40,40)
end)

jumpToggle.MouseButton1Click:Connect(function()
	jumpEnabled=not jumpEnabled
	jumpToggle.Text=jumpEnabled and "ON" or "OFF"
	jumpToggle.BackgroundColor3=jumpEnabled and Color3.fromRGB(40,120,40) or Color3.fromRGB(120,40,40)
end)

-- FLY TOGGLE
local flyBtn = Instance.new("TextButton", frame)
flyBtn.Size = UDim2.new(1,-20,0,22)
flyBtn.Position = UDim2.new(0,10,0,155)
flyBtn.Text = "FLY : OFF"
flyBtn.TextScaled = true
flyBtn.BackgroundColor3 = Color3.fromRGB(120,40,40)
flyBtn.TextColor3 = Color3.new(1,1,1)

flyBtn.MouseButton1Click:Connect(function()
	flyEnabled = not flyEnabled
	flyBtn.Text = flyEnabled and "FLY : ON" or "FLY : OFF"
	flyBtn.BackgroundColor3 = flyEnabled
		and Color3.fromRGB(40,120,40)
		or Color3.fromRGB(120,40,40)

	if flyEnabled then
		enableFly()
	else
		disableFly()
	end
end)

-- NOCLIP TOGGLE
local noclipBtn = Instance.new("TextButton", frame)
noclipBtn.Size = UDim2.new(1,-20,0,22)
noclipBtn.Position = UDim2.new(0,10,0,180)
noclipBtn.Text = "NOCLIP : OFF"
noclipBtn.TextScaled = true
noclipBtn.BackgroundColor3 = Color3.fromRGB(120,40,40)
noclipBtn.TextColor3 = Color3.new(1,1,1)

noclipBtn.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	noclipBtn.Text = noclipEnabled and "NOCLIP : ON" or "NOCLIP : OFF"
	noclipBtn.BackgroundColor3 = noclipEnabled
		and Color3.fromRGB(40,120,40)
		or Color3.fromRGB(120,40,40)

	setNoclip(noclipEnabled)
end)

----==================================================
-- NOTIFICATION UI
--==================================================
local notifY = 200

local notifLabel = Instance.new("TextLabel", frame)
notifLabel.Text = "NOTIFICATION"
notifLabel.Size = UDim2.new(1,-20,0,18)
notifLabel.Position = UDim2.new(0,10,0,notifY)
notifLabel.BackgroundTransparency = 1
notifLabel.TextScaled = true
notifLabel.TextColor3 = Color3.fromRGB(0,170,255)

notifY += 22

-- TEXT BOX
local textBox = Instance.new("TextBox", frame)
textBox.Size = UDim2.new(1,-20,0,22)
textBox.Position = UDim2.new(0,10,0,notifY)
textBox.PlaceholderText = "Isi pesan notif..."
textBox.TextScaled = true
textBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
textBox.TextColor3 = Color3.new(1,1,1)

notifY += 28

-- SPEED
local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(0.45,0,0,22)
speedBox.Position = UDim2.new(0,10,0,notifY)
speedBox.Text = "3"
speedBox.TextScaled = true
speedBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
speedBox.TextColor3 = Color3.new(1,1,1)

-- SIZE
local sizeBox = Instance.new("TextBox", frame)
sizeBox.Size = UDim2.new(0.45,0,0,22)
sizeBox.Position = UDim2.new(0.55,0,0,notifY)
sizeBox.Text = "22"
sizeBox.TextScaled = true
sizeBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
sizeBox.TextColor3 = Color3.new(1,1,1)

notifY += 30

-- BUTTON MAKER
local function makeBtn(text,y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(1,-20,0,22)
	b.Position = UDim2.new(0,10,0,y)
	b.Text = text
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	return b
end

local colorBtn = makeBtn("GANTI WARNA", notifY)
notifY += 26
local sendBtn = makeBtn("KIRIM TEKS", notifY)
notifY += 26
local stopBtn = makeBtn("HAPUS TEKS", notifY)

--==================================================
-- NOTIFICATION ENGINE
--==================================================
local notif = Instance.new("TextLabel", gui)
notif.Size = UDim2.new(0,400,0,40)
notif.Position = UDim2.new(0,0,0.15,0)
notif.BackgroundTransparency = 1
notif.TextWrapped = true
notif.TextScaled = false
notif.TextSize = 22
notif.Visible = false
notif.Font = Enum.Font.GothamBold
notif.TextColor3 = Color3.fromRGB(0,170,255)

local colors = {
	Color3.new(1,1,1),
	Color3.fromRGB(0,170,255),
	Color3.fromRGB(255,140,0),
	Color3.fromRGB(0,255,127),
	Color3.fromRGB(255,80,80)
}
local colorIndex = 1
local runNotif = false

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

	runNotif = false
	task.wait()

	notif.Text = textBox.Text
	notif.TextSize = tonumber(sizeBox.Text) or 22
	notif.Visible = true
	runNotif = true

	local speed = tonumber(speedBox.Text) or 3
	local screenWidth = cam.ViewportSize.X
	local notifWidth = notif.AbsoluteSize.X

	task.spawn(function()
		while runNotif do
			notif.Position = UDim2.new(0, screenWidth + notifWidth, 0.15, 0)

			while notif.Position.X.Offset > -notifWidth and runNotif do
				notif.Position -= UDim2.new(0, speed, 0, 0)
				RunService.RenderStepped:Wait()
			end

			RunService.RenderStepped:Wait()
		end
	end)
end)

--==================================================
-- DRAG
--==================================================
local drag=nil
local function bind(bar,name)
	bar.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 then
			drag=name
		end
	end)
end

bind(spBar,"speed")
bind(flyBar,"fly")
bind(jpBar,"jump")

UIS.InputEnded:Connect(function()
	drag=nil
end)

--==================================================
-- TEXTBOX INPUT FIX (WAJIB DI LUAR LOOP)
--==================================================

spBox.FocusLost:Connect(function()
	local n = tonumber(spBox.Text)
	if n then
		speedPercent = math.clamp(n, 0, 100)
	end
end)

flyBox.FocusLost:Connect(function()
	local n = tonumber(flyBox.Text)
	if n then
		flyPercent = math.clamp(n, 0, 100)
	end
end)

jpBox.FocusLost:Connect(function()
	local n = tonumber(jpBox.Text)
	if n then
		jumpPercent = math.clamp(n, 0, 100)
	end
end)

--==================================================
-- LOOP
--==================================================
RunService.RenderStepped:Connect(function()

	if drag=="speed" then speedPercent=mousePercent(spBar)*100 end
	if drag=="fly" then flyPercent=mousePercent(flyBar)*100 end
	if drag=="jump" then jumpPercent=mousePercent(jpBar)*100 end

	spFill.Size=UDim2.new(speedPercent/100,0,1,0)
	flyFill.Size=UDim2.new(flyPercent/100,0,1,0)
	jpFill.Size=UDim2.new(jumpPercent/100,0,1,0)

if not spBox:IsFocused() then
	spBox.Text = tostring(math.floor(speedPercent))
end

if not flyBox:IsFocused() then
	flyBox.Text = tostring(math.floor(flyPercent))
end

if not jpBox:IsFocused() then
	jpBox.Text = tostring(math.floor(jumpPercent))
		end
		
-- FLY LOGIC
if flyEnabled and bv and bg and hrp then
	local move = Vector3.zero

	if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.Space) then move += cam.CFrame.UpVector end
	if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= cam.CFrame.UpVector end

	if move.Magnitude > 0 then
		move = move.Unit
	end

	bv.Velocity = move * percentToValue(flyPercent, MAX_FLY_SPEED)
	bg.CFrame = cam.CFrame
		end

	if hum then
		if speedEnabled then
			targetSpeed=percentToValue(speedPercent,MAX_WALK_SPEED)
			currentSpeed+=(targetSpeed-currentSpeed)*SMOOTH
			hum.WalkSpeed=currentSpeed
		else
			hum.WalkSpeed=DEFAULT_SPEED
		end

		if jumpEnabled then
			targetJump=percentToValue(jumpPercent,MAX_JUMP_POWER)
			currentJump+=(targetJump-currentJump)*SMOOTH
			hum.JumpPower=currentJump
		else
			hum.JumpPower=DEFAULT_JUMP
		end
	end
end)

print("✅ Mikaa Dev Testing – FINAL BENAR")
