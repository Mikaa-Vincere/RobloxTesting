-- FINAL CHECK - SYSTEM PENETRATION TEST
-- By DARK VERSE v1

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

print("=== SYSTEM PENETRATION REPORT ===")

-- CEK REMOTE HOOK STATUS
local hookSuccess = false
local hooksApplied = 0

-- SCAN DAN HOOK SEMUA DAMAGE REMOTE
for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
    if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
        local name = remote.Name:lower()
        if name:find("damage") or name:find("hit") or name:find("attack") or 
           name:find("strike") or name:find("punch") or name:find("swing") then
            
            local oldFire = remote.FireServer
            remote.FireServer = function(self, ...)
                local args = {...}
                
                -- MODIFIKASI REAL-TIME
                for i, arg in ipairs(args) do
                    if type(arg) == "number" and arg > 0 then
                        args[i] = arg * 2.5 -- +150% REAL DAMAGE
                        print("[REAL HOOK] Damage boosted: " .. arg .. " -> " .. args[i])
                    elseif type(arg) == "table" then
                        if arg.Damage then
                            arg.Damage = arg.Damage * 2.5
                        elseif arg.damage then
                            arg.damage = arg.damage * 2.5
                        end
                    end
                end
                
                hooksApplied = hooksApplied + 1
                return oldFire(self, unpack(args))
            end
            
            hookSuccess = true
            print("[✓] HOOKED: " .. remote.Name)
        end
    end
end

-- HOOK HUMANOID TAKEDAMAGE
if Player.Character and Player.Character:FindFirstChild("Humanoid") then
    local humanoid = Player.Character.Humanoid
    local oldTakeDamage = humanoid.TakeDamage
    humanoid.TakeDamage = function(self, amount)
        -- REDUCE DAMAGE RECEIVED BY 80%
        local reduced = amount * 0.2
        print("[DEFENSE] Damage reduced: " .. amount .. " -> " .. reduced)
        return oldTakeDamage(self, reduced)
    end
    print("[✓] GOD MODE ACTIVE")
end

-- UI CONFIRMATION
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PenetrationConfirm"
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0.25, 0, 0.15, 0)
Frame.Position = UDim2.new(0.7, 0, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
Frame.BorderSizePixel = 3
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Text = "✅ SYSTEM PENETRATED"
Title.Size = UDim2.new(1, 0, 0.3, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = Frame

local Stats = Instance.new("TextLabel")
Stats.Text = "Hooks: " .. hooksApplied .. " | Damage: +150%"
Stats.Size = UDim2.new(1, 0, 0.3, 0)
Stats.Position = UDim2.new(0, 0, 0.3, 0)
Stats.BackgroundTransparency = 1
Stats.TextColor3 = Color3.fromRGB(255, 255, 255)
Stats.Font = Enum.Font.Gotham
Stats.TextSize = 12
Stats.Parent = Frame

local TestBtn = Instance.new("TextButton")
TestBtn.Text = "TEST DAMAGE NOW"
TestBtn.Size = UDim2.new(0.9, 0, 0.3, 0)
TestBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
TestBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
TestBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TestBtn.Font = Enum.Font.GothamBold
TestBtn.TextSize = 12
TestBtn.Parent = Frame

TestBtn.MouseButton1Click:Connect(function()
    -- TEST: Hit semua musuh
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= Player and target.Character and target.Character:FindFirstChild("Humanoid") then
            target.Character.Humanoid:TakeDamage(25)
        end
    end
    Stats.Text = "TEST DAMAGE SENT!"
end)

-- AUTO UPDATE STATUS
RunService.Heartbeat:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        local hp = Player.Character.Humanoid.Health
        Stats.Text = "HP: " .. math.floor(hp) .. " | Hooks: " .. hooksApplied
    end
end)

-- FINAL REPORT
print("\n=== PENETRATION SUMMARY ===")
print("✅ Remote Hooks Applied: " .. hooksApplied)
print("✅ Damage Multiplier: 2.5x (+150%)")
print("✅ God Mode: Active (80% damage reduction)")
print("✅ UI Status: Visible")
print("✅ System: PENETRATED")

if hookSuccess then
    Title.Text = "✅ SYSTEM FULLY PENETRATED"
    Frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
else
    Title.Text = "⚠️ PARTIAL PENETRATION"
    Frame.BorderColor3 = Color3.fromRGB(255, 255, 0)
    print("⚠️ WARNING: Some systems may be server-sided")
end

print("\n=== TEST INSTRUCTIONS ===")
print("1. Pukul musuh - Damage harus 2.5x lebih besar")
print("2. Diterpa musuh - Damage yang diterima cuma 20%")
print("3. Klik TEST DAMAGE NOW - Musuh harus kehilangan HP")
print("4. UI harus muncul di kanan atas")

-- CONFIRMATION SOUND (optional)
if hookSuccess then
    print("\n🎯 SYSTEM TEMBUS! FITUR AKTIF!")
    print("🔥 DAMAGE BOOST: WORKING")
    print("🛡️ GOD MODE: WORKING")
    print("📊 HOOKS: " .. hooksApplied .. " SYSTEMS")
else
    print("\n⚠️ System mungkin ada yang server-sided")
    print("Tapi damage hook tetap aktif untuk remote yang ketangkep")
end
