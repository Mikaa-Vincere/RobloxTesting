-- Script Roblox By Mikaa

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera

local flying = false
local goingUp = false
local goingDown = false
local speed = 45
local vSpeed = 35

local bg, bv

-- AUTO NOCLIP
RunService.Stepped:Connect(function()
    if flying then
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- UI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "FlyUI"
gui.ResetOnSpawn = false

local function btn(text,pos)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0,110,0,40)
    b.Position = pos
    b.BackgroundColor3 = Color3.fromRGB(35,35,35)
    b.TextColor3 = Color3.new(1,1,1)
    b.TextScaled = true
    b.Text = text
    b.Parent = gui
    return b
end

local flyBtn  = btn("FLY : OFF", UDim2.new(0.05,0,0.65,0))
local upBtn   = btn("▲ UP",      UDim2.new(0.05,0,0.72,0))
local downBtn = btn("▼ DOWN",    UDim2.new(0.05,0,0.79,0))

-- Fly Functions
local function startFly()
    flying = true

    bg = Instance.new("BodyGyro", hrp)
    bg.P = 9e4
    bg.maxTorque = Vector3.new(9e9,9e9,9e9)

    bv = Instance.new("BodyVelocity", hrp)
    bv.maxForce = Vector3.new(9e9,9e9,9e9)

    flyBtn.Text = "FLY : ON"
end

local function stopFly()
    flying = false
    goingUp = false
    goingDown = false
    if bg then bg:Destroy() end
    if bv then bv:Destroy() end
    flyBtn.Text = "FLY : OFF"
end

flyBtn.MouseButton1Click:Connect(function()
    if flying then stopFly() else startFly() end
end)

upBtn.MouseButton1Down:Connect(function() goingUp = true end)
upBtn.MouseButton1Up:Connect(function() goingUp = false end)

downBtn.MouseButton1Down:Connect(function() goingDown = true end)
downBtn.MouseButton1Up:Connect(function() goingDown = false end)

RunService.RenderStepped:Connect(function()
    if flying then
        bg.CFrame = cam.CFrame

        local vel = cam.CFrame.LookVector * speed

        if goingUp then
            vel += Vector3.new(0, vSpeed, 0)
        elseif goingDown then
            vel -= Vector3.new(0, vSpeed, 0)
        end

        bv.Velocity = vel
    end
end)

print("Fly Mobile Full Loaded")
