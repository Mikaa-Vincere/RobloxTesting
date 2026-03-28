-- MIKAADEV LITE - INFINITE HEALTH

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
if not player then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    player = Players.LocalPlayer
end

-- Settings
local healthActive = true
local screenGui = nil
local mainFrame = nil

-- Wait for player character
local function waitForCharacter()
    if not player.Character then
        player.CharacterAdded:Wait()
    end
    return player.Character
end

waitForCharacter()

-- Create UI safely
local function createUI()
    -- Remove existing UI if any
    if screenGui then
        screenGui:Destroy()
    end
    
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "HealthUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- Main frame
    mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 200, 0, 80)
    mainFrame.Position = UDim2.new(0.5, -100, 0.7, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 28)
    header.BackgroundColor3 = Color3.fromRGB(35, 0, 0)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 8)
    headerCorner.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -35, 1, 0)
    title.Position = UDim2.new(0, 8, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "❤ INFINITE HEALTH"
    title.TextColor3 = Color3.fromRGB(255, 100, 100)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 22, 0, 22)
    closeBtn.Position = UDim2.new(1, -26, 0, 3)
    closeBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = header
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
    end)
    
    -- Content
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -10, 1, -38)
    content.Position = UDim2.new(0, 5, 0, 32)
    content.BackgroundTransparency = 1
    content.Parent = mainFrame
    
    -- Toggle row
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 38)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
    toggleFrame.BackgroundTransparency = 0.2
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = content
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleFrame
    
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(0.65, 0, 1, 0)
    healthLabel.Position = UDim2.new(0, 10, 0, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "❤ INFINITE HEALTH"
    healthLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    healthLabel.Font = Enum.Font.Gotham
    healthLabel.TextSize = 12
    healthLabel.TextXAlignment = Enum.TextXAlignment.Left
    healthLabel.Parent = toggleFrame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 55, 0, 28)
    toggleBtn.Position = UDim2.new(1, -62, 0, 5)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(140, 0, 0)
    toggleBtn.Text = "ON"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 11
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = toggleFrame
    
    local toggleCorner2 = Instance.new("UICorner")
    toggleCorner2.CornerRadius = UDim.new(0, 5)
    toggleCorner2.Parent = toggleBtn
    
    toggleBtn.MouseButton1Click:Connect(function()
        healthActive = not healthActive
        if healthActive then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(140, 0, 0)
            toggleBtn.Text = "ON"
            -- Apply health immediately when turned on
            local char = player.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    hum.MaxHealth = 1e9
                    hum.Health = 1e9
                    hum.BreakJointsOnDeath = false
                end
            end
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            toggleBtn.Text = "OFF"
        end
    end)
    
    -- Credit
    local credit = Instance.new("TextLabel")
    credit.Size = UDim2.new(1, 0, 0, 18)
    credit.Position = UDim2.new(0, 0, 1, -18)
    credit.BackgroundTransparency = 1
    credit.Text = "Credit : MikaaDev"
    credit.TextColor3 = Color3.fromRGB(120, 120, 130)
    credit.Font = Enum.Font.Gotham
    credit.TextSize = 9
    credit.TextXAlignment = Enum.TextXAlignment.Center
    credit.Parent = mainFrame
end

-- Create UI
pcall(createUI)

-- ===============================
-- DRAG FUNCTION
-- ===============================
local dragging = false
local dragStartPos = nil
local frameStartPos = nil

if mainFrame then
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStartPos = input.Position
            frameStartPos = mainFrame.Position
        end
    end)
end

UserInputService.InputChanged:Connect(function(input)
    if dragging and mainFrame and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStartPos
        mainFrame.Position = UDim2.new(
            frameStartPos.X.Scale, 
            frameStartPos.X.Offset + delta.X,
            frameStartPos.Y.Scale,
            frameStartPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ===============================
-- INFINITE HEALTH (FIXED)
-- ===============================
local currentHumanoid = nil

local function keepHealth()
    if not healthActive then return end
    
    local char = player.Character
    if not char then return end
    
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    
    currentHumanoid = hum
    
    -- Set max health
    if hum.MaxHealth ~= 1e9 then
        hum.MaxHealth = 1e9
    end
    
    -- Keep health full
    if hum.Health < hum.MaxHealth then
        hum.Health = hum.MaxHealth
    end
    
    -- Disable death
    hum.BreakJointsOnDeath = false
end

-- Run every frame (but not too heavy)
RunService.Heartbeat:Connect(function()
    pcall(keepHealth)
end)

-- When character respawns
player.CharacterAdded:Connect(function(character)
    wait(0.5)
    pcall(function()
        local hum = character:FindFirstChild("Humanoid")
        if hum and healthActive then
            hum.MaxHealth = 1e9
            hum.Health = 1e9
            hum.BreakJointsOnDeath = false
        end
    end)
end)

-- Initial apply
wait(1)
pcall(keepHealth)

print("Health mod loaded")
