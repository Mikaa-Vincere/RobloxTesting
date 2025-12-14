--========================================
-- Mikaa Rusuh Player - Android Only
--========================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ANDROID CHECK
if not UIS.TouchEnabled then
    warn("Android only")
    return
end

--========================================
-- UI
--========================================
local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
gui.ResetOnSpawn = false

-- TOGGLE BAR
local bar = Instance.new("Frame", gui)
bar.Size = UDim2.new(0,200,0,35)
bar.Position = UDim2.new(0.5,-100,0.25,0)
bar.BackgroundColor3 = Color3.fromRGB(20,20,20)
bar.Active = true
bar.Draggable = true

local title = Instance.new("TextButton", bar)
title.Size = UDim2.new(1,0,1,0)
title.Text = "Mikaa Menu"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.BackgroundTransparency = 1

-- PANEL
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0,260,0,200)
panel.Position = UDim2.new(0.5,-130,0.32,0)
panel.BackgroundColor3 = Color3.fromRGB(30,30,30)
panel.Visible = false
panel.Active = true
panel.Draggable = true

local pTitle = Instance.new("TextLabel", panel)
pTitle.Size = UDim2.new(1,0,0,35)
pTitle.Text = "Rusuh Player"
pTitle.TextColor3 = Color3.new(1,1,1)
pTitle.TextScaled = true
pTitle.BackgroundColor3 = Color3.fromRGB(15,15,15)

-- PLAYER LIST
local list = Instance.new("ScrollingFrame", panel)
list.Size = UDim2.new(1,-20,0,100)
list.Position = UDim2.new(0,10,0,45)
list.CanvasSize = UDim2.new(0,0,0,0)
list.ScrollBarThickness = 4
list.BackgroundColor3 = Color3.fromRGB(20,20,20)

local selectedPlayer = nil

local function refreshPlayers()
    list:ClearAllChildren()
    local y = 0

    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local btn = Instance.new("TextButton", list)
            btn.Size = UDim2.new(1,-5,0,30)
            btn.Position = UDim2.new(0,0,0,y)
            btn.Text = plr.Name
            btn.TextScaled = true
            btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
            btn.TextColor3 = Color3.new(1,1,1)

            btn.MouseButton1Click:Connect(function()
                selectedPlayer = plr
                for _,b in pairs(list:GetChildren()) do
                    if b:IsA("TextButton") then
                        b.BackgroundColor3 = Color3.fromRGB(45,45,45)
                    end
                end
                btn.BackgroundColor3 = Color3.fromRGB(0,120,255)
            end)

            y += 35
        end
    end

    list.CanvasSize = UDim2.new(0,0,0,y)
end

refreshPlayers()
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)

-- RUSUH BUTTON
local rusuhBtn = Instance.new("TextButton", panel)
rusuhBtn.Size = UDim2.new(1,-20,0,40)
rusuhBtn.Position = UDim2.new(0,10,1,-50)
rusuhBtn.Text = "RUSUH (LEMpar ke Langit)"
rusuhBtn.TextScaled = true
rusuhBtn.BackgroundColor3 = Color3.fromRGB(120,40,40)
rusuhBtn.TextColor3 = Color3.new(1,1,1)

--========================================
-- LOGIC RUSUH
--========================================
rusuhBtn.MouseButton1Click:Connect(function()
    if not selectedPlayer then return end
    if not selectedPlayer.Character then return end

    local hrp = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e9,1e9,1e9)
    bv.Velocity = Vector3.new(0,200,0) -- lempar ke atas
    bv.Parent = hrp

    task.delay(0.4, function()
        if bv then bv:Destroy() end
    end)
end)

--========================================
-- TOGGLE PANEL
--========================================
local open = false
title.MouseButton1Click:Connect(function()
    open = not open
    panel.Visible = open
end)

print("Mikaa Rusuh Player Loaded")
