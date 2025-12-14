-- Fly Script MOBILE (Delta Executor)
-- Touch Button Version

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

local flying = false
local speed = 45

-- Body movers
local bg, bv

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FlyMobileGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0,120,0,45)
flyBtn.Position = UDim2.new(0.05,0,0.7,0)
flyBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
flyBtn.TextColor3 = Color3.new(1,1,1)
flyBtn.Text = "FLY : OFF"
flyBtn.TextScaled = true
flyBtn.Parent = gui

-- Functions
local function startFly()
    flying = true

    bg = Instance.new("BodyGyro")
    bg.P = 9e4
    bg.maxTorque = Vector3.new(9e9,9e9,9e9)
    bg.cframe = hrp.CFrame
    bg.Parent = hrp

    bv = Instance.new("BodyVelocity")
    bv.maxForce = Vector3.new(9e9,9e9,9e9)
    bv.velocity = Vector3.new(0,0,0)
    bv.Parent = hrp

    flyBtn.Text = "FLY : ON"
end

local function stopFly()
    flying = false
    if bg then bg:Destroy() end
    if bv then bv:Destroy() end
    flyBtn.Text = "FLY : OFF"
end

flyBtn.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
    else
        startFly()
    end
end)

RunService.RenderStepped:Connect(function()
    if flying then
        bg.cframe = camera.CFrame
        bv.velocity = camera.CFrame.LookVector * speed
    end
end)

print("Fly Mobile Loaded")
