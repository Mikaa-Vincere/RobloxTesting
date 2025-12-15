--==================================================
-- Mikaa Dev Testing FINAL (ALL IN ONE)
--==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--==================================================
-- CHARACTER SYSTEM
--==================================================
local char, hum, hrp
local targetSpeed, currentSpeed = 16, 16
local targetJump, currentJump = 50, 50

local walkOnWater = false
local noFallDamage = false

local MAX_WALK_SPEED = 800
local MAX_JUMP_POWER = 250
local SPEED_SMOOTH = 0.15

local waterPad

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
	waterPad.CanCollide = false
	waterPad.Transparency = 1
end

player.CharacterAdded:Connect(loadChar)
if player.Character then loadChar(player.Character) end

--==================================================
-- UI BASE
--==================================================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,360)
frame.Position = UDim2.new(0.5,-130,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
frame.Active = true
frame.Draggable = true

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

--==================================================
-- BASIC BUTTONS
--==================================================
local waterBtn = button("WATER : OFF",10)
local fallBtn  = button("NO FALL : OFF",42)

waterBtn.MouseButton1Click:Connect(function()
	walkOnWater = not walkOnWater
	waterBtn.Text = "WATER : "..(walkOnWater and "ON" or "OFF")
end)

fallBtn.MouseButton1Click:Connect(function()
	noFallDamage = not noFallDamage
	fallBtn.Text = "NO FALL : "..(noFallDamage and "ON" or "OFF")
end)

--==================================================
-- RUNNING NOTIF SYSTEM
--==================================================
label("RUNNING NOTIF",78)

local notifInput = Instance.new("TextBox", frame)
notifInput.Size = UDim2.new(1,-16,0,26)
notifInput.Position = UDim2.new(0,8,0,98)
notifInput.BackgroundColor3 = Color3.fromRGB(35,35,35)
notifInput.TextColor3 = Color3.new(1,1,1)
notifInput.PlaceholderText = "Isi teks notif..."

local sendBtn = button("KIRIM NOTIF",132)
local dirBtn  = button("ARAH : KIRI",164)

local notifActive = false
local notifSpeed = 3
local notifDir = -1
local notifY = 0.1

local notifFrame = Instance.new("Frame", gui)
notifFrame.Size = UDim2.new(1,0,0,28)
notifFrame.Position = UDim2.new(0,0,notifY,0)
notifFrame.BackgroundTransparency = 1
notifFrame.Visible = false

local notifText = Instance.new("TextLabel", notifFrame)
notifText.Size = UDim2.new(0,1000,1,0)
notifText.BackgroundTransparency = 1
notifText.TextScaled = true
notifText.TextXAlignment = Enum.TextXAlignment.Left
notifText.TextColor3 = Color3.fromRGB(0,170,255)

sendBtn.MouseButton1Click:Connect(function()
	if notifInput.Text ~= "" then
		notifText.Text = notifInput.Text.."   "
		notifText.Position = notifDir == -1 and UDim2.new(1,0,0,0) or UDim2.new(-1,0,0,0)
		notifFrame.Visible = true
		notifActive = true
	end
end)

dirBtn.MouseButton1Click:Connect(function()
	notifDir *= -1
	dirBtn.Text = notifDir == -1 and "ARAH : KIRI" or "ARAH : KANAN"
end)

--==================================================
-- LOOP
--==================================================
RunService.RenderStepped:Connect(function()
	-- SPEED & JUMP
	if hum then
		currentSpeed += (targetSpeed - currentSpeed) * SPEED_SMOOTH
		hum.WalkSpeed = currentSpeed

		currentJump += (targetJump - currentJump) * SPEED_SMOOTH
		hum.JumpPower = currentJump
	end

	-- WALK ON WATER
	if walkOnWater and hrp then
		local ray = workspace:Raycast(hrp.Position, Vector3.new(0,-100,0))
		if ray and ray.Material == Enum.Material.Water then
			waterPad.Position = ray.Position - Vector3.new(0,0.5,0)
			waterPad.CanCollide = true
		else
			waterPad.CanCollide = false
		end
	end

	-- RUNNING NOTIF (STOP ONCE OUT)
	if notifActive then
		notifText.Position += UDim2.new(0.002 * notifSpeed * notifDir,0,0,0)
		if notifText.Position.X.Scale < -1.2 or notifText.Position.X.Scale > 1.2 then
			notifActive = false
			notifFrame.Visible = false
		end
	end
end)

print("Mikaa Dev FINAL ALL-IN-ONE Loaded ✅") 
