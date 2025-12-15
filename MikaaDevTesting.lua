--==================================================
-- Mikaa Dev Testing (FINAL ALL IN ONE)
--==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--==================================================
-- CORE VARIABLE (ASLI)
--==================================================
local char, hum, hrp
local targetSpeed, currentSpeed = 16,16
local targetJump, currentJump = 50,50
local walkOnWater = false
local noFallDamage = false

local MAX_WALK_SPEED = 800
local MAX_JUMP_POWER = 250
local SPEED_SMOOTH = 0.15
local waterPad

--==================================================
-- CHARACTER LOAD (ASLI)
--==================================================
local function loadChar(c)
	char = c
	hum = char:WaitForChild("Humanoid")
	hrp = char:WaitForChild("HumanoidRootPart")

	hum.WalkSpeed = 16
	hum.JumpPower = 50

	if waterPad then waterPad:Destroy() end
	waterPad = Instance.new("Part", workspace)
	waterPad.Size = Vector3.new(8,1,8)
	waterPad.Anchored = true
	waterPad.Transparency = 1
	waterPad.CanCollide = false
end

player.CharacterAdded:Connect(loadChar)
if player.Character then loadChar(player.Character) end

--==================================================
-- UI BASE (ASLI)
--==================================================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,460)
frame.Position = UDim2.new(0.5,-130,0.25,0)
frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
frame.Active = true
frame.Draggable = true

local function label(txt,y)
	local t = Instance.new("TextLabel", frame)
	t.Size = UDim2.new(1,-16,0,18)
	t.Position = UDim2.new(0,8,0,y)
	t.BackgroundTransparency = 1
	t.TextColor3 = Color3.new(1,1,1)
	t.TextScaled = true
	t.Text = txt
	return t
end

local function button(txt,y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(1,-16,0,28)
	b.Position = UDim2.new(0,8,0,y)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	b.TextScaled = true
	b.Text = txt
	return b
end

--==================================================
-- SLIDER + INPUT ANGKA (REUSABLE)
--==================================================
local function sliderWithInput(y,min,max,default,callback)
	local bar = Instance.new("Frame", frame)
	bar.Size = UDim2.new(0.65,-16,0,6)
	bar.Position = UDim2.new(0,8,0,y)
	bar.BackgroundColor3 = Color3.fromRGB(60,60,60)

	local fill = Instance.new("Frame", bar)
	fill.BackgroundColor3 = Color3.fromRGB(0,170,255)

	local knob = Instance.new("Frame", bar)
	knob.Size = UDim2.new(0,14,0,14)
	knob.BackgroundColor3 = Color3.fromRGB(220,220,220)
	knob.Active = true

	local box = Instance.new("TextBox", frame)
	box.Size = UDim2.new(0.25,0,0,22)
	box.Position = UDim2.new(0.7,0,0,y-8)
	box.BackgroundColor3 = Color3.fromRGB(35,35,35)
	box.TextColor3 = Color3.new(1,1,1)
	box.TextScaled = true

	local function setVal(v)
		v = math.clamp(v,min,max)
		local p = (v-min)/(max-min)
		fill.Size = UDim2.new(p,0,1,0)
		knob.Position = UDim2.new(p,-7,-0.8,0)
		box.Text = string.format("%.2f",v)
		callback(v)
	end

	setVal(default)

	local drag = false
	knob.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true end
	end)
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
	end)

	RunService.RenderStepped:Connect(function()
		if drag then
			local x = math.clamp((UIS:GetMouseLocation().X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
			setVal(min+(max-min)*x)
		end
	end)

	box.FocusLost:Connect(function()
		setVal(tonumber(box.Text) or default)
	end)
end

--==================================================
-- RUNNING NOTIF SYSTEM
--==================================================
local notifActive = false
local notifSpeed = 2
local notifDir = 1
local notifY = 0.1

local notifFrame = Instance.new("Frame", gui)
notifFrame.Size = UDim2.new(1,0,0,28)
notifFrame.Position = UDim2.new(0,0,notifY,0)
notifFrame.BackgroundTransparency = 1
notifFrame.Visible = false

local notifLabel = Instance.new("TextLabel", notifFrame)
notifLabel.Size = UDim2.new(0,900,1,0)
notifLabel.BackgroundTransparency = 1
notifLabel.TextColor3 = Color3.fromRGB(0,170,255)
notifLabel.TextScaled = true
notifLabel.TextXAlignment = Enum.TextXAlignment.Left

--==================================================
-- NOTIF UI
--==================================================
label("RUNNING NOTIF",6)

local input = Instance.new("TextBox", frame)
input.Size = UDim2.new(1,-16,0,24)
input.Position = UDim2.new(0,8,0,26)
input.BackgroundColor3 = Color3.fromRGB(35,35,35)
input.TextColor3 = Color3.new(1,1,1)
input.PlaceholderText = "Isi teks notif..."

local send = button("KIRIM NOTIF",56)
local del = button("HAPUS NOTIF",88)
local dirBtn = button("ARAH : KANAN",120)

label("KECEPATAN NOTIF",156)
sliderWithInput(176,0.5,10,2,function(v) notifSpeed = v end)

label("POSISI Y",214)
sliderWithInput(234,0,1,0.1,function(v)
	notifY = v
	notifFrame.Position = UDim2.new(0,0,notifY,0)
end)

--==================================================
-- BUTTON ACTION
--==================================================
send.MouseButton1Click:Connect(function()
	if input.Text ~= "" then
		notifLabel.Text = input.Text.."   "
		notifActive = true
		notifFrame.Visible = true
	end
end)

del.MouseButton1Click:Connect(function()
	notifActive = false
	notifFrame.Visible = false
end)

dirBtn.MouseButton1Click:Connect(function()
	notifDir *= -1
	dirBtn.Text = notifDir == 1 and "ARAH : KANAN" or "ARAH : KIRI"
end)

--==================================================
-- LOOP
--==================================================
RunService.RenderStepped:Connect(function()
	if hum then
		currentSpeed += (targetSpeed-currentSpeed)*SPEED_SMOOTH
		hum.WalkSpeed = currentSpeed
		currentJump += (targetJump-currentJump)*SPEED_SMOOTH
		hum.JumpPower = currentJump
	end

	if notifActive then
		notifLabel.Position += UDim2.new(0.002*notifSpeed*notifDir,0,0,0)
		if notifLabel.Position.X.Scale > 1 then
			notifLabel.Position = UDim2.new(-1,0,0,0)
		elseif notifLabel.Position.X.Scale < -1 then
			notifLabel.Position = UDim2.new(1,0,0,0)
		end
	end
end)

print("Mikaa Dev Testing FINAL ALL IN ONE Loaded ✅")
