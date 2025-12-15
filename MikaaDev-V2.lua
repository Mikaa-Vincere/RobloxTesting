--// Tinju Beta Combat Assist (perbaikan + turbo spam)
--// Mobile Friendly | Analog SAFE
--// Owner : MikaaDev
--// Perubahan: turbo spam, min CLICK_DELAY lebih kecil, tombol UI turbo, aman terhadap VIM tidak tersedia

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = nil
pcall(function() VIM = game:GetService("VirtualInputManager") end)

local player = Players.LocalPlayer
if not player then
	warn("LocalPlayer tidak tersedia. Script harus dijalankan sebagai LocalScript di client.")
	return
end

local camera = workspace.CurrentCamera or workspace:WaitForChild("Camera")

--================ CONFIG =================
local ENABLED = false
local LOCK_STRENGTH = 0.14      -- camera assist (0.05 - 0.15)
local CLICK_DELAY = 0.01        -- spam speed default (bisa diset lebih kecil)
local HIT_RANGE = 6             -- jarak spam (sangat dekat)
local TURBO = false             -- turbo mode: spams as fast as possible
local TURBO_DELAY = 0.001       -- target delay in turbo loop (may be limited by engine)
--========================================

local lockedTarget = nil
local isLocked = false
local lastClick = 0

local isSpamming = false -- guard for turbo coroutine

-- Pastikan PlayerGui tersedia
local playerGui = player:WaitForChild("PlayerGui", 5)
if not playerGui then
	warn("PlayerGui tidak ditemukan. GUI tidak akan dibuat.")
	return
end

--================ UI =====================
local gui = Instance.new("ScreenGui")
gui.Name = "CombatAssist"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromScale(0.32,0.30)
frame.Position = UDim2.fromScale(0.62,0.30)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.fromScale(1,0.14)
title.Text = "Combat Assist"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextScaled = true
title.Parent = frame

local status = Instance.new("TextButton")
status.Position = UDim2.fromScale(0.05,0.16)
status.Size = UDim2.fromScale(0.9,0.13)
status.Text = "STATUS : OFF"
status.BackgroundColor3 = Color3.fromRGB(120,40,40)
status.TextColor3 = Color3.new(1,1,1)
status.TextScaled = true
status.Parent = frame

local function updateStatusUI()
	if ENABLED then
		status.Text = "STATUS : ON"
		status.BackgroundColor3 = Color3.fromRGB(40,120,40)
	else
		status.Text = "STATUS : OFF"
		status.BackgroundColor3 = Color3.fromRGB(120,40,40)
	end
end

status.MouseButton1Click:Connect(function()
	ENABLED = not ENABLED
	if not ENABLED then
		lockedTarget = nil
		isLocked = false
		lastClick = 0
	end
	updateStatusUI()
end)

-- Camera Strength
local camText = Instance.new("TextLabel")
camText.Position = UDim2.fromScale(0.05,0.32)
camText.Size = UDim2.fromScale(0.6,0.10)
camText.Text = "Camera Strength : "..string.format("%.2f", LOCK_STRENGTH)
camText.TextColor3 = Color3.new(1,1,1)
camText.BackgroundTransparency = 1
camText.TextScaled = true
camText.TextXAlignment = Enum.TextXAlignment.Left
camText.Parent = frame

local camInc = Instance.new("TextButton")
camInc.Position = UDim2.fromScale(0.67,0.32)
camInc.Size = UDim2.fromScale(0.12,0.10)
camInc.Text = "+"
camInc.Parent = frame
local camDec = camInc:Clone()
camDec.Position = UDim2.fromScale(0.79,0.32)
camDec.Text = "-"
camDec.Parent = frame

camInc.MouseButton1Click:Connect(function()
	LOCK_STRENGTH = math.clamp(LOCK_STRENGTH + 0.01, 0.01, 0.6)
	camText.Text = "Camera Strength : "..string.format("%.2f", LOCK_STRENGTH)
end)
camDec.MouseButton1Click:Connect(function()
	LOCK_STRENGTH = math.clamp(LOCK_STRENGTH - 0.01, 0.01, 0.6)
	camText.Text = "Camera Strength : "..string.format("%.2f", LOCK_STRENGTH)
end)

-- Spam Speed
local spamText = Instance.new("TextLabel")
spamText.Position = UDim2.fromScale(0.05,0.46)
spamText.Size = UDim2.fromScale(0.6,0.10)
spamText.Text = "Spam Delay : "..string.format("%.3f", CLICK_DELAY)
spamText.TextColor3 = Color3.new(1,1,1)
spamText.BackgroundTransparency = 1
spamText.TextScaled = true
spamText.TextXAlignment = Enum.TextXAlignment.Left
spamText.Parent = frame

local spamDec = Instance.new("TextButton")
spamDec.Position = UDim2.fromScale(0.67,0.46)
spamDec.Size = UDim2.fromScale(0.12,0.10)
spamDec.Text = "-"
spamDec.Parent = frame
local spamInc = spamDec:Clone()
spamInc.Position = UDim2.fromScale(0.79,0.46)
spamInc.Text = "+"
spamInc.Parent = frame

-- allow smaller min value (0.001)
spamDec.MouseButton1Click:Connect(function()
	CLICK_DELAY = math.clamp(CLICK_DELAY - 0.001, 0.001, 1)
	spamText.Text = "Spam Delay : "..string.format("%.3f", CLICK_DELAY)
end)
spamInc.MouseButton1Click:Connect(function()
	CLICK_DELAY = math.clamp(CLICK_DELAY + 0.001, 0.001, 1)
	spamText.Text = "Spam Delay : "..string.format("%.3f", CLICK_DELAY)
end)

-- Turbo button
local turboBtn = Instance.new("TextButton")
turboBtn.Position = UDim2.fromScale(0.05,0.60)
turboBtn.Size = UDim2.fromScale(0.9,0.12)
turboBtn.Text = "TURBO : OFF"
turboBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
turboBtn.TextColor3 = Color3.new(1,1,1)
turboBtn.TextScaled = true
turboBtn.Parent = frame

local function updateTurboUI()
	if TURBO then
		turboBtn.Text = "TURBO : ON"
		turboBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
	else
		turboBtn.Text = "TURBO : OFF"
		turboBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
	end
end

turboBtn.MouseButton1Click:Connect(function()
	TURBO = not TURBO
	updateTurboUI()
end)

local owner = Instance.new("TextLabel")
owner.Position = UDim2.fromScale(0,0.82)
owner.Size = UDim2.fromScale(1,0.12)
owner.Text = "Owner : MikaaDev"
owner.TextColor3 = Color3.fromRGB(180,180,180)
owner.BackgroundTransparency = 1
owner.TextScaled = true
owner.Parent = frame

--================ TARGET =================
local function isAliveCharacter(char)
	if not char then return false end
	local humanoid = char:FindFirstChildWhichIsA("Humanoid")
	return humanoid and humanoid.Health > 0
end

local function getClosestEnemy()
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") or not isAliveCharacter(char) then return nil end

	local closest, dist = nil, math.huge
	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and isAliveCharacter(plr.Character) then
			local okToConsider = true
			if player.Team and plr.Team and (player.Team == plr.Team) then
				okToConsider = false
			end
			if okToConsider then
				local d = (plr.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
				if d < dist then
					dist = d
					closest = plr.Character.HumanoidRootPart
				end
			end
		end
	end
	return closest
end

-- Turbo spam coroutine starter
local function startTurboSpam()
	if isSpamming then return end
	isSpamming = true
	task.spawn(function()
		while isSpamming and ENABLED do
			-- ensure lockedTarget and player conditions
			local tgt = lockedTarget
			local char = player.Character
			if not tgt or not char or not char:FindFirstChild("HumanoidRootPart") then
				break
			end
			local dist = (tgt.Position - char.HumanoidRootPart.Position).Magnitude
			if not isLocked or dist > HIT_RANGE then
				break
			end
			-- perform click
			if VIM and type(VIM.SendMouseButtonEvent) == "function" then
				pcall(function()
					VIM:SendMouseButtonEvent(0,0,0,true,game,0)
					VIM:SendMouseButtonEvent(0,0,0,false,game,0)
				end)
			end
			-- very short wait; engine may clamp to frame rate
			task.wait(TURBO_DELAY)
		end
		isSpamming = false
	end)
end

--================ LOOP ===================
RunService.RenderStepped:Connect(function()
	if not ENABLED then return end

	-- update camera reference if changed
	camera = workspace.CurrentCamera or camera

	lockedTarget = getClosestEnemy()
	if not lockedTarget then
		isLocked = false
		return
	end

	-- safety checks
	if not camera or not camera.CFrame then return end

	-- CAMERA ASSIST
	local camPos = camera.CFrame.Position
	local look = camera.CFrame.LookVector
	local successTargetLook, targetLook = pcall(function()
		return (lockedTarget.Position - camPos).Unit
	end)
	if not successTargetLook or not targetLook then return end

	local newLook = look:Lerp(targetLook, LOCK_STRENGTH)
	if newLook.Magnitude > 0 then
		camera.CFrame = CFrame.new(camPos, camPos + newLook)
	end

	-- LOCK VALID CHECK
	local dot = newLook:Dot(targetLook)
	isLocked = dot > 0.98

	-- SPAM LOGIC
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		local dist = (lockedTarget.Position - char.HumanoidRootPart.Position).Magnitude
		if isLocked and dist <= HIT_RANGE then
			if TURBO then
				-- start turbo coroutine (it will stop itself when conditions break)
				startTurboSpam()
			else
				-- normal click with configured CLICK_DELAY (min 0.001)
				if tick() - lastClick >= math.max(0.001, CLICK_DELAY) then
					lastClick = tick()
					if VIM and type(VIM.SendMouseButtonEvent) == "function" then
						pcall(function()
							VIM:SendMouseButtonEvent(0,0,0,true,game,0)
							VIM:SendMouseButtonEvent(0,0,0,false,game,0)
						end)
					end
				end
			end
		else
			-- ensure turbo stops if out of range or unlocked
			isSpamming = false
		end
	end
end)

-- Reset lastClick / flags on character spawn
player.CharacterAdded:Connect(function()
	lastClick = 0
	lockedTarget = nil
	isLocked = false
	isSpamming = false
end)

updateStatusUI()
updateTurboUI()
spamText.Text = "Spam Delay : "..string.format("%.3f", CLICK_DELAY)

print("Combat Assist (Turbo) Loaded | MikaaDev")
