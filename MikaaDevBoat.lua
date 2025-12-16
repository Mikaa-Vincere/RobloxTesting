--==================================================
-- Mikaa Dev | Boat Boost (PERCENT MODE)
-- Owner Script : MikaaDevBoat
--==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

--================ CONFIG =================
local MAX_MULTIPLIER = 5 -- 100% = 5x speed

--================ STATE =================
local boostEnabled = false
local boostPercent = 0
local original = {}

--================ BOAT DETECT =================
local function getBoat()
	if hum.SeatPart then
		return hum.SeatPart:FindFirstAncestorWhichIsA("Model")
	end
end

local function percentToMultiplier(p)
	return 1 + (p / 100) * (MAX_MULTIPLIER - 1)
end

--================ UI =================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

-- LOGO
local logo = Instance.new("ImageButton", gui)
logo.Size = UDim2.new(0,45,0,45)
logo.Position = UDim2.new(0,10,0.5,-22)
logo.Image = "rbxassetid://100166477433523"
logo.BackgroundColor3 = Color3.fromRGB(20,20,20)
logo.BorderSizePixel = 0
logo.Active, logo.Draggable = true, true

-- FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,220,0,160)
frame.Position = UDim2.new(0.6,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.Active, frame.Draggable = true, true

logo.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,26)
title.Position = UDim2.new(0,0,0,0)
title.Text = "BOAT BOOST"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(25,25,25)
title.Font = Enum.Font.GothamBold

-- OWNER LABEL (✔ DIGABUNG)
local owner = Instance.new("TextLabel", frame)
owner.Size = UDim2.new(1,0,0,14)
owner.Position = UDim2.new(0,0,0,26)
owner.Text = "Owner Script : MikaaDevBoat"
owner.TextScaled = true
owner.TextColor3 = Color3.fromRGB(140,140,140)
owner.BackgroundTransparency = 1
owner.Font = Enum.Font.GothamMedium

-- LABEL
local lbl = Instance.new("TextLabel", frame)
lbl.Size = UDim2.new(1,0,0,18)
lbl.Position = UDim2.new(0,0,0,44)
lbl.Text = "BOOST PERCENT (0 - 100%)"
lbl.TextScaled = true
lbl.TextColor3 = Color3.fromRGB(200,200,200)
lbl.BackgroundTransparency = 1
lbl.Font = Enum.Font.Gotham

-- INPUT %
local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(1,-20,0,22)
box.Position = UDim2.new(0,10,0,68)
box.Text = "0%"
box.TextScaled = true
box.BackgroundColor3 = Color3.fromRGB(30,30,30)
box.TextColor3 = Color3.new(1,1,1)
box.Font = Enum.Font.Gotham

box.FocusLost:Connect(function()
	local v = tonumber(box.Text:gsub("%%",""))
	if v then
		boostPercent = math.clamp(v, 0, 100)
		box.Text = boostPercent .. "%"
	end
end)

-- TOGGLE
local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(1,-20,0,26)
btn.Position = UDim2.new(0,10,0,104)
btn.Text = "BOOST : OFF"
btn.TextScaled = true
btn.BackgroundColor3 = Color3.fromRGB(120,40,40)
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.GothamBold

btn.MouseButton1Click:Connect(function()
	boostEnabled = not boostEnabled
	btn.Text = "BOOST : "..(boostEnabled and "ON" or "OFF")
	btn.BackgroundColor3 = boostEnabled
		and Color3.fromRGB(40,120,40)
		or Color3.fromRGB(120,40,40)
end)

-- INFO
local info = Instance.new("TextLabel", frame)
info.Size = UDim2.new(1,0,0,18)
info.Position = UDim2.new(0,0,0,134)
info.Text = "Auto Detect All Boats"
info.TextScaled = true
info.TextColor3 = Color3.fromRGB(120,200,255)
info.BackgroundTransparency = 1
info.Font = Enum.Font.Gotham

--================ BOOST LOGIC =================
RunService.RenderStepped:Connect(function()
	local boat = getBoat()
	if not boat then return end

	local mul = percentToMultiplier(boostPercent)

	for _,v in ipairs(boat:GetDescendants()) do
		if v:IsA("LinearVelocity") then
			if not original[v] then
				original[v] = v.VectorVelocity
			end
			v.VectorVelocity = boostEnabled and (original[v] * mul) or original[v]
		end

		if v:IsA("BodyVelocity") then
			if not original[v] then
				original[v] = v.Velocity
			end
			v.Velocity = boostEnabled and (original[v] * mul) or original[v]
		end
	end
end)

print("Mikaa Dev Boat Boost Loaded 🚤")
