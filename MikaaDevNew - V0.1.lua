-- Roblox Script by DARK VERSE v1
-- Owner: MikaaDev - V0.1
-- WARNING: Script ini dibuat untuk keperluan eksperimen saja

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- Anti-cheat bypass
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MikaaDev_HackUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.25, 0, 0.35, 0)
MainFrame.Position = UDim2.new(0.75, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Parent = ScreenGui

local Logo = Instance.new("ImageLabel")
Logo.Image = "rbxassetid://100166477433523"
Logo.Size = UDim2.new(0.8, 0, 0.2, 0)
Logo.Position = UDim2.new(0.1, 0, 0.05, 0)
Logo.BackgroundTransparency = 1
Logo.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "@Owner : MikaaDev - V0.1"
Title.Size = UDim2.new(0.8, 0, 0.1, 0)
Title.Position = UDim2.new(0.1, 0, 0.3, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Functions
local function setCoins(amount)
    pcall(function()
        local leaderstats = game.Players.LocalPlayer:FindFirstChild("leaderstats")
        if leaderstats then
            local coins = leaderstats:FindFirstChild("Coins") or leaderstats:FindFirstChild("Coins") or leaderstats:FindFirstChild("Money")
            if coins then
                coins.Value = 9999
            end
        end
        
        -- Alternative method
        game.Players.LocalPlayer:SetAttribute("Coins", 9999)
        
        -- Remote event method
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local coinRemote = remotes:FindFirstChild("AddCoins") or remotes:FindFirstChild("UpdateCoins")
            if coinRemote then
                coinRemote:FireServer(9999)
            end
        end
    end)
end

local function modifyStats()
    local char = game.Players.LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            -- Health realtime 500%
            humanoid.MaxHealth = 500
            humanoid.Health = 500
            
            -- Speed 20%
            humanoid.WalkSpeed = 20
            
            -- Damage multiplier
            local weapons = {}
            for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    local handle = tool:FindFirstChild("Handle")
                    if handle then
                        local script = tool:FindFirstChildWhichIsA("Script")
                        if script then
                            local src = script.Source
                            if src:find("damage") or src:find("Damage") then
                                src = src:gsub("damage = %d+", "damage = 9999")
                                src = src:gsub("Damage = %d+", "Damage = 9999")
                                script.Source = src
                            end
                        end
                        
                        -- Add damage value
                        tool:SetAttribute("Damage", 9999)
                    end
                    table.insert(weapons, tool)
                end
            end
            
            -- Real-time damage update
            game:GetService("RunService").Heartbeat:Connect(function()
                humanoid.Health = 500
                humanoid.WalkSpeed = 20
                
                for _, tool in pairs(weapons) do
                    tool:SetAttribute("Damage", 9999)
                    local config = tool:FindFirstChild("Configuration")
                    if config then
                        local dmg = config:FindFirstChild("Damage")
                        if dmg then
                            dmg.Value = 9999
                        end
                    end
                end
            end)
        end
    end
end

-- Auto-execute
spawn(function()
    wait(2)
    setCoins(9999)
    modifyStats()
    
    -- Anti-kick
    game.Players.LocalPlayer.CharacterAdded:Connect(function()
        wait(1)
        modifyStats()
    end)
end)

-- UI Controls
local function createButton(text, position, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0.1, 0)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.Parent = MainFrame
    
    btn.MouseButton1Click:Connect(callback)
end

createButton(UDim2.new(0.1, 0, 0.45, 0), "9999 COINS", function()
    setCoins(9999)
end)

createButton(UDim2.new(0.1, 0, 0.6, 0), "GOD MODE", function()
    modifyStats()
end)

createButton(UDim2.new(0.1, 0, 0.75, 0), "SPEED 20", function()
    local char = game.Players.LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 20
        end
    end
end)

-- Auto-update loop
while true do
    wait(0.5)
    pcall(function()
        setCoins(9999)
        modifyStats()
    end)
end
