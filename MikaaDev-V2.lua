--// Tinju Beta Combat Assist
--// Mobile Friendly | Analog SAFE
--// Owner : MikaaDev

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

--================ CONFIG =================
local ENABLED = false
local LOCK_STRENGTH = 0.14      -- camera assist (0.05 - 0.15)
local CLICK_DELAY = 0.1        -- spam speed (0.15 - 0.10)
local HIT_RANGE = 6             -- jarak spam (sangat dekat)
--========================================

local lockedTarget = nil
local isLocked = false
local lastClick = 0

--================ UI =====================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "CombatAssist"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.32,0.28)
frame.Position = UDim2.fromScale(0.62,0.32)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.18)
title.Text = "Combat Assist"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextScaled = true

local status = Instance.new("TextButton", frame)
status.Position = UDim2.fromScale(0.05,0.2)
status.Size = UDim2.fromScale(0.9,0.18)
status.Text = "STATUS : OFF"
status.BackgroundColor3 = Color3.fromRGB(120,40,40)
status.TextColor3 = Color3.new(1,1,1)
status.TextScaled = true

status.MouseButton1Click:Connect(function()
	ENABLED = not ENABLED
	if ENABLED then
		status.Text = "STATUS : ON"
		status.BackgroundColor3 = Color3.fromRGB(40,120,40)
	else
		status.Text = "STATUS : OFF"
		status.BackgroundColor3 = Color3.fromRGB(120,40,40)
		lockedTarget = nil
		isLocked = false
		lastClick = 0
	end
end)

-- Camera Strength
local camText = Instance.new("TextLabel", frame)
camText.Position = UDim2.fromScale(0.05,0.42)
camText.Size = UDim2.fromScale(0.9,0.12)
camText.Text = "Camera Strength : "..LOCK_STRENGTH
camText.TextColor3 = Color3.new(1,1,1)
camText.BackgroundTransparency = 1
camText.TextScaled = true

-- Spam Speed
local spamText = Instance.new("TextLabel", frame)
spamText.Position = UDim2.fromScale(0.05,0.58)
spamText.Size = UDim2.fromScale(0.9,0.12)
spamText.Text = "Spam Speed : "..CLICK_DELAY
spamText.TextColor3 = Color3.new(1,1,1)
spamText.BackgroundTransparency = 1
spamText.TextScaled = true

local owner = Instance.new("TextLabel", frame)
owner.Position = UDim2.fromScale(0,0.85)
owner.Size = UDim2.fromScale(1,0.12)
owner.Text = "Owner : MikaaDev"
owner.TextColor3 = Color3.fromRGB(180,180,180)
owner.BackgroundTransparency = 1
owner.TextScaled = true

--================ TARGET =================
local function getClosestEnemy()
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end

	local closest, dist = nil, math.huge
	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local d = (plr.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
			if d < dist then
				dist = d
				closest = plr.Character.HumanoidRootPart
			end
		end
	end
	return closest
end

--================ LOOP ===================
RunService.RenderStepped:Connect(function()
	if not ENABLED then return end

	lockedTarget = getClosestEnemy()
	if not lockedTarget then
		isLocked = false
		return
	end

	-- CAMERA ASSIST (SAFE, ANALOG TIDAK MATI)
	local camPos = camera.CFrame.Position
	local look = camera.CFrame.LookVector
	local targetLook = (lockedTarget.Position - camPos).Unit
	local newLook = look:Lerp(targetLook, LOCK_STRENGTH)
	camera.CFrame = CFrame.new(camPos, camPos + newLook)

	-- LOCK VALID CHECK
	local dot = newLook:Dot(targetLook)
	isLocked = dot > 0.98

	-- SPAM LOGIC
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		local dist = (lockedTarget.Position - char.HumanoidRootPart.Position).Magnitude
		if isLocked and dist <= HIT_RANGE then
			if tick() - lastClick >= CLICK_DELAY then
				lastClick = tick()
				VIM:SendMouseButtonEvent(0,0,0,true,game,0)
				VIM:SendMouseButtonEvent(0,0,0,false,game,0)
			end
		end
	end
end)

print("Combat Assist FULL FIX Loaded | MikaaDev")

