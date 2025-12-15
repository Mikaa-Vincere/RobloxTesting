--========================================
-- Combat Assist 1v1 (FULL FIX)
-- Owner : MikaaDev
--========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

--=====================
-- CONFIG
--=====================
local ENABLED = false

local AUTO_RADIUS = 14
local HIT_RANGE = 4.5

local MAX_LOCK = 0.15
local LOCK_STRENGTH = 0.10

local MIN_SPAM = 0.10
local MAX_SPAM = 0.15
local CLICK_DELAY = 0.15

local lockedTarget = nil
local isLocked = false
local lastClick = 0

--=====================
-- UI
--=====================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,230,0,210)
frame.Position = UDim2.new(0.5,-115,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Combat Assist"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.BackgroundColor3 = Color3.fromRGB(15,15,15)

-- Toggle
local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(1,-20,0,30)
toggle.Position = UDim2.new(0,10,0,40)
toggle.Text = "STATUS : OFF"
toggle.TextScaled = true
toggle.BackgroundColor3 = Color3.fromRGB(120,0,0)
toggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,8)

-- Camera slider
local camTxt = Instance.new("TextLabel", frame)
camTxt.Size = UDim2.new(1,-20,0,18)
camTxt.Position = UDim2.new(0,10,0,80)
camTxt.Text = "Camera Strength : 0.10"
camTxt.TextColor3 = Color3.new(1,1,1)
camTxt.BackgroundTransparency = 1
camTxt.TextScaled = true

local camBar = Instance.new("Frame", frame)
camBar.Size = UDim2.new(1,-20,0,6)
camBar.Position = UDim2.new(0,10,0,102)
camBar.BackgroundColor3 = Color3.fromRGB(60,60,60)

local camFill = Instance.new("Frame", camBar)
camFill.Size = UDim2.new(LOCK_STRENGTH/MAX_LOCK,0,1,0)
camFill.BackgroundColor3 = Color3.fromRGB(255,80,80)

-- Spam slider
local spamTxt = Instance.new("TextLabel", frame)
spamTxt.Size = UDim2.new(1,-20,0,18)
spamTxt.Position = UDim2.new(0,10,0,118)
spamTxt.Text = "Spam Speed : 0.15"
spamTxt.TextColor3 = Color3.new(1,1,1)
spamTxt.BackgroundTransparency = 1
spamTxt.TextScaled = true

local spamBar = Instance.new("Frame", frame)
spamBar.Size = UDim2.new(1,-20,0,6)
spamBar.Position = UDim2.new(0,10,0,140)
spamBar.BackgroundColor3 = Color3.fromRGB(60,60,60)

local spamFill = Instance.new("Frame", spamBar)
spamFill.Size = UDim2.new(1,0,1,0)
spamFill.BackgroundColor3 = Color3.fromRGB(255,120,0)

-- Owner
local owner = Instance.new("TextLabel", frame)
owner.Size = UDim2.new(1,0,0,18)
owner.Position = UDim2.new(0,0,1,-18)
owner.Text = "Owner : MikaaDev"
owner.TextColor3 = Color3.fromRGB(180,180,180)
owner.BackgroundTransparency = 1
owner.TextScaled = true

--=====================
-- UI LOGIC
--=====================
toggle.MouseButton1Click:Connect(function()
	ENABLED = not ENABLED
	toggle.Text = "STATUS : "..(ENABLED and "ON" or "OFF")
	toggle.BackgroundColor3 = ENABLED and Color3.fromRGB(0,140,0) or Color3.fromRGB(120,0,0)

	if not ENABLED then
		lockedTarget = nil
		isLocked = false
		lastClick = 0
		CLICK_DELAY = 0.15
		spamFill.Size = UDim2.new(1,0,1,0)
		spamTxt.Text = "Spam Speed : 0.15"
	end
end)

camBar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch then
		local p = math.clamp((i.Position.X-camBar.AbsolutePosition.X)/camBar.AbsoluteSize.X,0,1)
		LOCK_STRENGTH = math.clamp(p*MAX_LOCK,0,MAX_LOCK)
		camFill.Size = UDim2.new(p,0,1,0)
		camTxt.Text = string.format("Camera Strength : %.2f",LOCK_STRENGTH)
	end
end)

spamBar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch then
		local p = math.clamp((i.Position.X-spamBar.AbsolutePosition.X)/spamBar.AbsoluteSize.X,0,1)
		CLICK_DELAY = MAX_SPAM - (MAX_SPAM-MIN_SPAM)*p
		spamFill.Size = UDim2.new(p,0,1,0)
		spamTxt.Text = string.format("Spam Speed : %.2f",CLICK_DELAY)
	end
end)

--=====================
-- TARGET SEARCH (1v1)
--=====================
local function getEnemy()
	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return nil end
	local myPos = player.Character.HumanoidRootPart.Position
	local found = {}

	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local hum = plr.Character:FindFirstChildOfClass("Humanoid")
			if hum and hum.Health > 0 then
				local d = (plr.Character.HumanoidRootPart.Position-myPos).Magnitude
				if d <= AUTO_RADIUS then
					table.insert(found,plr.Character.HumanoidRootPart)
				end
			end
		end
	end
	if #found == 1 then
		return found[1]
	end
	return nil
end

--=====================
-- MAIN LOOP (FULL FIX)
--=====================
RunService.RenderStepped:Connect(function()
	if not ENABLED then return end

	lockedTarget = getEnemy()
	if not lockedTarget then
		isLocked = false
		return
	end

	-- CAMERA ASSIST (SAFE)
	local camCF = camera.CFrame
	local dir = (lockedTarget.Position-camCF.Position).Unit
	local targetCF = CFrame.new(camCF.Position, camCF.Position+dir)
	camera.CFrame = camCF:Lerp(targetCF, LOCK_STRENGTH)

	-- LOCK VALID CHECK
	local dot = camera.CFrame.LookVector:Dot(dir)
	isLocked = dot > 0.98

	-- SPAM ONLY IF LOCKED & VERY CLOSE
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		local dist = (lockedTarget.Position-char.HumanoidRootPart.Position).Magnitude
		if isLocked and dist <= HIT_RANGE then
			if tick()-lastClick > CLICK_DELAY then
				lastClick = tick()
				VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,0)
				VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,0)
			end
		end
	end
end)

print("Combat Assist FULL FIX Loaded | MikaaDev")
