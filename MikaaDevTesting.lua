--==================================================
-- Mikaa Dev Testing (FINAL – NO MORE CHANGES)
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
local walkOnWater = false
local waterPart

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

local spBox = makeBox(52, DEFAULT_SPEED)
local jpBox = makeBox(84, DEFAULT_JUMP)

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

local presetColors = {
	Color3.fromRGB(255,255,255),
	Color3.fromRGB(0,170,255),
	Color3.fromRGB(255,140,0),
	Color3.fromRGB(0,255,127),
	Color3.fromRGB(255,80,80),
	Color3.fromRGB(180,80,255),
	Color3.fromRGB(255,220,0)
}
local colorIndex=1
notif.TextColor3 = presetColors[colorIndex]

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

--================ COLOR MODE MENU =================
local colorMenu = Instance.new("Frame", gui)
colorMenu.Size = UDim2.new(0,160,0,90)
colorMenu.Position = UDim2.new(0.5,-80,0.5,-45)
colorMenu.BackgroundColor3 = Color3.fromRGB(25,25,25)
colorMenu.Visible = false
colorMenu.Active = true
colorMenu.Draggable = true

local function menuBtn(txt,y)
	local b = Instance.new("TextButton", colorMenu)
	b.Size = UDim2.new(1,-10,0,30)
	b.Position = UDim2.new(0,5,0,y)
	b.Text = txt
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	return b
end

local pickerModeBtn = menuBtn("🎨 MINI PICKER",5)
local presetModeBtn = menuBtn("🌈 PRESET WARNA",45)

local sendBtn=btn("KIRIM TEKS",260)
local stopBtn=btn("HAPUS TEKS",286)

colorBtn.MouseButton1Click:Connect(function()
	colorMenu.Visible = not colorMenu.Visible
end)

stopBtn.MouseButton1Click:Connect(function()
	runNotif=false
	notif.Visible=false
end)

--================ MINI COLOR PICKER (HP) =================
local currentColor = notif.TextColor3
local savedColor = notif.TextColor3

pickerModeBtn.MouseButton1Click:Connect(function()
	colorMenu.Visible = false
	pickerFrame.Visible = true
	savedColor = notif.TextColor3
	currentColor = savedColor
end)

presetModeBtn.MouseButton1Click:Connect(function()
	colorMenu.Visible = false
	colorIndex = colorIndex % #presetColors + 1
	notif.TextColor3 = presetColors[colorIndex]
	currentColor = notif.TextColor3
end)

local pickerFrame = Instance.new("Frame", gui)
pickerFrame.Size = UDim2.new(0,160,0,180)
pickerFrame.Position = UDim2.new(0.5,-80,0.5,-90)
pickerFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
pickerFrame.Visible = false
pickerFrame.Active = true
pickerFrame.Draggable = true

local wheel = Instance.new("ImageLabel", pickerFrame)
wheel.Size = UDim2.new(1,-20,1,-60)
wheel.Position = UDim2.new(0,10,0,10)
wheel.Image = "rbxassetid://6020299385"
wheel.BackgroundTransparency = 1

local okBtn = Instance.new("TextButton", pickerFrame)
okBtn.Size = UDim2.new(0.45,0,0,28)
okBtn.Position = UDim2.new(0.05,0,1,-32)
okBtn.Text = "OK"
okBtn.BackgroundColor3 = Color3.fromRGB(50,150,50)
okBtn.TextColor3 = Color3.new(1,1,1)

local cancelBtn = Instance.new("TextButton", pickerFrame)
cancelBtn.Size = UDim2.new(0.45,0,0,28)
cancelBtn.Position = UDim2.new(0.5,0,1,-32)
cancelBtn.Text = "BATAL"
cancelBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
cancelBtn.TextColor3 = Color3.new(1,1,1)

local draggingColor = false

wheel.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingColor = true
	end
end)

UIS.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingColor = false
	end
end)

RunService.RenderStepped:Connect(function()
	if draggingColor then
		local pos = UIS:GetMouseLocation()
		local x = math.clamp((pos.X - wheel.AbsolutePosition.X) / wheel.AbsoluteSize.X, 0, 1)
		local y = math.clamp((pos.Y - wheel.AbsolutePosition.Y) / wheel.AbsoluteSize.Y, 0, 1)

		currentColor = Color3.fromHSV(x, 1, 1 - y)
		notif.TextColor3 = currentColor
	end
end)

okBtn.MouseButton1Click:Connect(function()
	notif.TextColor3 = currentColor
	pickerFrame.Visible = false
	
end)

cancelBtn.MouseButton1Click:Connect(function()
	notif.TextColor3 = savedColor
	pickerFrame.Visible = false
end)

sendBtn.MouseButton1Click:Connect(function()
	if textBox.Text=="" then return end
	notif.Text=textBox.Text
	notif.TextSize=tonumber(sizeBox.Text) or 20
	runNotif=true
	notif.Visible=true
	local spd=tonumber(speedBox.Text) or 3

	task.spawn(function()
		while runNotif do
			notif.Position=UDim2.new(1,0,notif.Position.Y.Scale,0)
			while notif.Position.X.Offset>-320 and runNotif do
				notif.Position-=UDim2.new(0,spd,0,0)
				RunService.RenderStepped:Wait()
			end
		end
	end)
end)

--================ LOOP =================
RunService.RenderStepped:Connect(function()
	if dragS then targetSpeed=DEFAULT_SPEED+(MAX_WALK_SPEED-DEFAULT_SPEED)*percent(spBar) end
	if dragJ then targetJump=DEFAULT_JUMP+(MAX_JUMP_POWER-DEFAULT_JUMP)*percent(jpBar) end

	spFill.Size=UDim2.new((targetSpeed-DEFAULT_SPEED)/(MAX_WALK_SPEED-DEFAULT_SPEED),0,1,0)
	jpFill.Size=UDim2.new((targetJump-DEFAULT_JUMP)/(MAX_JUMP_POWER-DEFAULT_JUMP),0,1,0)

	spBox.Text=math.floor(targetSpeed)
	jpBox.Text=math.floor(targetJump)

	if hum then
		currentSpeed+=(targetSpeed-currentSpeed)*SPEED_SMOOTH
		currentJump+=(targetJump-currentJump)*SPEED_SMOOTH
		hum.WalkSpeed=currentSpeed
		hum.JumpPower=currentJump
	end

	if walkOnWater and hrp then
		local ray=workspace:Raycast(hrp.Position,Vector3.new(0,-6,0))
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
