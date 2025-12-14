--==================================================
-- Mikaa Boat Rusuh + Detector (Android Only)
--==================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")

-- ANDROID CHECK
if not UIS.TouchEnabled then
    warn("Android only")
    return
end

--==================================================
-- UI
--==================================================
local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,170)
frame.Position = UDim2.new(0.5,-130,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,35)
title.Text = "Boat Rusuh Detector"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(15,15,15)

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1,-20,0,40)
status.Position = UDim2.new(0,10,0,45)
status.Text = "STATUS : SCAN..."
status.TextScaled = true
status.TextColor3 = Color3.new(1,1,1)
status.BackgroundTransparency = 1

local rusuhBtn = Instance.new("TextButton", frame)
rusuhBtn.Size = UDim2.new(1,-20,0,45)
rusuhBtn.Position = UDim2.new(0,10,0,95)
rusuhBtn.Text = "RUSUH BOAT"
rusuhBtn.TextScaled = true
rusuhBtn.BackgroundColor3 = Color3.fromRGB(120,40,40)
rusuhBtn.TextColor3 = Color3.new(1,1,1)
rusuhBtn.AutoButtonColor = false

--==================================================
-- DETECTION
--==================================================
local targetSeat = nil
local targetBoat = nil

local function scanBoat()
    targetSeat = nil
    targetBoat = nil
    status.Text = "STATUS : SCANNING..."

    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Seat") or v:IsA("VehicleSeat") then
            if v.Occupant then
                local hum = v.Occupant.Parent
                if hum and hum:IsA("Model") and hum ~= Char then
                    if not v.Anchored then
                        targetSeat = v
                        targetBoat = v.Parent
                        status.Text = "STATUS : BISA DIRUSUH"
                        status.TextColor3 = Color3.fromRGB(0,255,0)
                        return
                    end
                end
            end
        end
    end

    status.Text = "STATUS : TIDAK BISA"
    status.TextColor3 = Color3.fromRGB(255,80,80)
end

scanBoat()

--==================================================
-- RUSUH LOGIC
--==================================================
rusuhBtn.MouseButton1Click:Connect(function()
    if not targetSeat or not targetBoat then
        scanBoat()
        return
    end

    -- cari part utama boat
    local root = targetBoat:FindFirstChild("HumanoidRootPart")
        or targetBoat:FindFirstChildWhichIsA("BasePart")

    if not root then
        status.Text = "STATUS : GAGAL (NO ROOT)"
        status.TextColor3 = Color3.fromRGB(255,80,80)
        return
    end

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e9,1e9,1e9)
    bv.Velocity = Vector3.new(0,300,0)
    bv.Parent = root

    task.delay(0.5, function()
        if bv then bv:Destroy() end
    end)
end)

-- auto rescan
Players.PlayerAdded:Connect(scanBoat)
Players.PlayerRemoving:Connect(scanBoat)

print("Mikaa Boat Rusuh + Detector Loaded")
