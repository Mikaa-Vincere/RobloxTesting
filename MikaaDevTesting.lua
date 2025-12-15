--==================================================
-- Mikaa Dev Testing 
--==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local char, hum, hrp
local targetSpeed = 16
local currentSpeed = 16

local targetJump = 50
local currentJump = 50

local walkOnWater = false
local noFallDamage = false

--=========================
-- CONFIG
--=========================
local MAX_WALK_SPEED = 800
local MAX_JUMP_POWER = 250
local SPEED_SMOOTH = 0.15

local waterPad
local lastY = 0

--=========================
-- CHARACTER LOAD
--=========================
local function loadChar(c)
    char = c
    hum = char:WaitForChild("Humanoid")
    hrp = char:WaitForChild("HumanoidRootPart")

    targetSpeed = 16
    currentSpeed = 16
    targetJump = 50
    currentJump = 50

    hum.WalkSpeed = 16
    hum.JumpPower = 50
    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)

    if waterPad then waterPad:Destroy() end
    waterPad = Instance.new("Part")
    waterPad.Size = Vector3.new(8,1,8)
    waterPad.Anchored = true
    waterPad.CanCollide = false
    waterPad.Transparency = 1
    waterPad.Parent = workspace

    lastY = hrp.Position.Y

    if waterBtn then waterBtn.Text = "WATER : OFF" end
    if fallBtn then fallBtn.Text = "NO FALL : OFF" end

    walkOnWater = false
    noFallDamage = false
end

player.CharacterAdded:Connect(loadChar)
if player.Character then loadChar(player.Character) end

--=========================
-- UI
--=========================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local toggleBtn = Instance.new("ImageButton", gui)
toggleBtn.Size = UDim2.new(0,40,0,40)
toggleBtn.Position = UDim2.new(0,10,0.5,-20)
toggleBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
toggleBtn.BorderSizePixel = 0
toggleBtn.Active = true
toggleBtn.Draggable = true
toggleBtn.Image = "rbxassetid://100166477433523"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,200)
frame.Position = UDim2.new(0.5,-100,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
frame.Active = true
frame.Draggable = true

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,26)
title.Text = "Mikaa Dev Testing"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(15,15,15)

local function btn(txt,y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-16,0,30)
    b.Position = UDim2.new(0,8,0,y)
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.TextScaled = true
    b.Text = txt
    return b
end

waterBtn = btn("WATER : OFF",28)
fallBtn  = btn("NO FALL : OFF",62)

waterBtn.MouseButton1Click:Connect(function()
    walkOnWater = not walkOnWater
    waterBtn.Text = "WATER : "..(walkOnWater and "ON" or "OFF")
end)

fallBtn.MouseButton1Click:Connect(function()
    noFallDamage = not noFallDamage
    fallBtn.Text = "NO FALL : "..(noFallDamage and "ON" or "OFF")
end)

--=========================
-- LOOP SYSTEM
--=========================
RunService.RenderStepped:Connect(function()
    if hum and hrp then
        -- SPEED & JUMP
        currentSpeed += (targetSpeed - currentSpeed) * SPEED_SMOOTH
        hum.WalkSpeed = currentSpeed

        currentJump += (targetJump - currentJump) * SPEED_SMOOTH
        hum.JumpPower = currentJump

        --=========================
        -- NO FALL DAMAGE
        --=========================
        if noFallDamage then
            local falling = lastY - hrp.Position.Y

            if falling > 8 then
                hum:ChangeState(Enum.HumanoidStateType.Running)
                hrp.AssemblyLinearVelocity =
                    Vector3.new(
                        hrp.AssemblyLinearVelocity.X,
                        math.max(hrp.AssemblyLinearVelocity.Y, -35),
                        hrp.AssemblyLinearVelocity.Z
                    )
            end
        end

        lastY = hrp.Position.Y
    end

    --=========================
    -- WALK ON WATER
    --=========================
    if walkOnWater and hrp and hum and waterPad then
        local rp = RaycastParams.new()
        rp.FilterDescendantsInstances = {char}
        rp.FilterType = Enum.RaycastFilterType.Blacklist

        local ray = workspace:Raycast(hrp.Position, Vector3.new(0,-100,0), rp)

        if ray and ray.Material == Enum.Material.Water then
            waterPad.Position = Vector3.new(
                hrp.Position.X,
                ray.Position.Y - 0.5,
                hrp.Position.Z
            )
            waterPad.CanCollide = true

            if hum:GetState() == Enum.HumanoidStateType.Swimming then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        else
            waterPad.CanCollide = false
            waterPad.Position = Vector3.new(0,-1000,0)
        end
    else
        if waterPad then
            waterPad.CanCollide = false
            waterPad.Position = Vector3.new(0,-1000,0)
        end
    end
end)

print("Mikaa Dev Testing Loaded ✅")
