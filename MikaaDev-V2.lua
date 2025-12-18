-- ============================================
-- SERVER CRASH/OVERRIDE HACK
-- Untuk game dengan proteksi ketat
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Hapus UI lama
if CoreGui:FindFirstChild("ExtremeHackUI") then
    CoreGui.ExtremeHackUI:Destroy()
end

-- UI Extreme
local ExtremeUI = Instance.new("ScreenGui")
ExtremeUI.Name = "ExtremeHackUI"
ExtremeUI.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.5, -175, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ExtremeUI

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "💀 EXTREME SERVER BYPASS"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 20
Title.Parent = MainFrame

-- Status
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 0, 45)
StatusLabel.Text = "⚡ METHOD 1: PACKET FLOOD"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 16
StatusLabel.Parent = MainFrame

-- Button Frame
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Size = UDim2.new(0.9, 0, 0, 280)
ButtonContainer.Position = UDim2.new(0.05, 0, 0, 80)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = MainFrame

-- Fungsi Log
local function AddLog(msg)
    print("[EXTREME]", msg)
    StatusLabel.Text = msg
end

-- ============================================
-- METHOD 1: PACKET FLOOD ATTACK
-- ============================================
local function PacketFlood()
    AddLog("FLOODING SERVER PACKETS...")
    
    spawn(function()
        while wait() do
            pcall(function()
                -- Flood semua RemoteEvent
                for _, remote in pairs(game:GetDescendants()) do
                    if remote:IsA("RemoteEvent") then
                        for i = 1, 50 do -- 50x spam per remote
                            -- Kirim damage tinggi
                            remote:FireServer("Head", 999999, LocalPlayer.Character)
                            remote:FireServer(999999)
                            remote:FireServer(LocalPlayer.Character, 999999)
                            remote:FireServer("Damage", 999999)
                        end
                    end
                end
                
                -- Flood RemoteFunction juga
                for _, remote in pairs(game:GetDescendants()) do
                    if remote:IsA("RemoteFunction") then
                        pcall(function() remote:InvokeServer(999999) end)
                    end
                end
            end)
        end
    end)
end

-- ============================================
-- METHOD 2: SERVER LAG SWITCH
-- ============================================
local function LagSwitch()
    AddLog("ACTIVATING LAG SWITCH...")
    
    spawn(function()
        local floodParts = {}
        
        while wait(0.01) do
            pcall(function()
                -- Buat ratusan part untuk lag server
                for i = 1, 20 do
                    local part = Instance.new("Part")
                    part.Size = Vector3.new(50, 50, 50)
                    part.Position = Vector3.new(math.random(-500, 500), math.random(10, 100), math.random(-500, 500))
                    part.Anchored = true
                    part.CanCollide = true
                    part.Parent = workspace
                    part.Name = "LagPart_" .. i
                    
                    table.insert(floodParts, part)
                    
                    -- Tambahkan script untuk terus berubah
                    local script = Instance.new("Script")
                    script.Source = [[
                        while wait(0.01) do
                            script.Parent.Position = Vector3.new(
                                math.random(-500, 500),
                                math.random(10, 100),
                                math.random(-500, 500)
                            )
                            script.Parent.CFrame = CFrame.Angles(
                                math.rad(math.random(0, 360)),
                                math.rad(math.random(0, 360)),
                                math.rad(math.random(0, 360))
                            )
                        end
                    ]]
                    script.Parent = part
                end
            end)
        end
    end)
end

-- ============================================
-- METHOD 3: MEMORY CORRUPTION
-- ============================================
local function MemoryCorruption()
    AddLog("CORRUPTING GAME MEMORY...")
    
    spawn(function()
        while wait(0.05) do
            pcall(function()
                -- Overwrite semua NumberValue
                for _, obj in pairs(game:GetDescendants()) do
                    if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                        obj.Value = 999999
                    end
                    
                    if obj:IsA("StringValue") then
                        obj.Value = "HACKED"
                    end
                    
                    if obj:IsA("BoolValue") then
                        obj.Value = true
                    end
                end
                
                -- Modifikasi semua script
                for _, script in pairs(game:GetDescendants()) do
                    if script:IsA("Script") or script:IsA("LocalScript") then
                        pcall(function()
                            local source = script.Source
                            if #source > 10 then
                                -- Ganti semua angka dengan 999999
                                source = string.gsub(source, "%d+", "999999")
                                script.Source = source
                            end
                        end)
                    end
                end
            end)
        end
    end)
end

-- ============================================
-- METHOD 4: ONE-HIT KILL (FORCE)
-- ============================================
local function ForceOneHitKill()
    AddLog("FORCING ONE-HIT KILL...")
    
    spawn(function()
        while wait(0.1) do
            pcall(function()
                -- Kirim kill command ke semua player
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local humanoid = player.Character:FindFirstChild("Humanoid")
                        if humanoid then
                            -- Coba semua metode kill
                            humanoid.Health = 0
                            humanoid:TakeDamage(999999)
                            
                            -- Teleport ke void
                            local root = player.Character:FindFirstChild("HumanoidRootPart")
                            if root then
                                root.CFrame = CFrame.new(0, -10000, 0)
                            end
                        end
                    end
                end
            end)
        end
    end)
end

-- ============================================
-- METHOD 5: ATTACK SPEED EXPLOIT
-- ============================================
local function MaxAttackSpeed()
    AddLog("MAX ATTACK SPEED...")
    
    spawn(function()
        while wait() do
            pcall(function()
                -- Hook animasi attack
                if LocalPlayer.Character then
                    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        -- Remove semua animasi delay
                        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                            if track.Name:lower():find("attack") then
                                track:Stop()
                            end
                        end
                        
                        -- Spam attack input
                        local attackRemote = game:GetService("ReplicatedStorage"):FindFirstChild("AttackEvent")
                        if attackRemote then
                            for i = 1, 100 do
                                attackRemote:FireServer()
                            end
                        end
                    end
                end
                
                -- Auto-click simulation (untuk mobile)
                for i = 1, 50 do
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
                end
            end)
        end
    end)
end

-- ============================================
-- METHOD 6: ANTI-ANTICHEAT
-- ============================================
local function DisableAnticheat()
    AddLog("DISABLING ANTICHEAT...")
    
    spawn(function()
        while wait(0.5) do
            pcall(function()
                -- Cari dan disable anticheat scripts
                for _, script in pairs(game:GetDescendants()) do
                    if script:IsA("Script") then
                        local name = script.Name:lower()
                        if name:find("anti") or name:find("cheat") or name:find("security") or name:find("shield") then
                            script:Destroy()
                        end
                    end
                end
                
                -- Disable semua ModuleScript yang mencurigakan
                for _, module in pairs(game:GetDescendants()) do
                    if module:IsA("ModuleScript") then
                        local name = module.Name:lower()
                        if name:find("check") or name:find("validate") or name:find("verify") then
                            module:Destroy()
                        end
                    end
                end
            end)
        end
    end)
end

-- ============================================
-- UI BUTTONS
-- ============================================

local methods = {
    {"💣 PACKET FLOOD", Color3.fromRGB(255, 50, 50), PacketFlood},
    {"🌪️ LAG SWITCH", Color3.fromRGB(255, 150, 0), LagSwitch},
    {"💀 MEMORY CORRUPT", Color3.fromRGB(200, 0, 200), MemoryCorruption},
    {"⚡ ONE-HIT KILL", Color3.fromRGB(0, 255, 100), ForceOneHitKill},
    {"🎯 MAX ATTACK SPEED", Color3.fromRGB(100, 200, 255), MaxAttackSpeed},
    {"🛡️ DISABLE ANTICHEAT", Color3.fromRGB(255, 255, 0), DisableAnticheat},
}

for i, method in ipairs(methods) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 40)
    button.Position = UDim2.new(0, 0, 0, (i-1)*45)
    button.Text = method[1]
    button.BackgroundColor3 = method[2]
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.Parent = ButtonContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        method[3]()
    end)
end

-- ============================================
-- AUTO-START SEMUA METHOD
-- ============================================

AddLog("Starting all methods in 3 seconds...")

wait(3)

-- Jalankan semua method sekaligus
PacketFlood()
wait(0.5)
MemoryCorruption()
wait(0.5)
MaxAttackSpeed()
wait(0.5)
DisableAnticheat()

AddLog("ALL METHODS ACTIVE! KILL EVERYONE!")

-- Warning
local Warning = Instance.new("TextLabel")
Warning.Size = UDim2.new(1, 0, 0, 30)
Warning.Position = UDim2.new(0, 0, 0, 370)
Warning.Text = "⚠️ SERVER MAY CRASH/LAG ⚠️"
Warning.TextColor3 = Color3.fromRGB(255, 0, 0)
Warning.BackgroundTransparency = 1
Warning.Font = Enum.Font.GothamBlack
Warning.TextSize = 14
Warning.Parent = MainFrame

print("=========================================")
print("EXTREME SERVER BYPASS ACTIVATED")
print("Game: " .. game.Name)
print("Place ID: " .. game.PlaceId)
print("Methods: Packet Flood, Lag Switch, Memory Corruption")
print("Target: Server-side calculation bypass")
print("=========================================")
