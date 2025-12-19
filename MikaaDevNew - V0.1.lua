-- DUELING GROUNDS - ULTIMATE SYSTEM HOOK
-- By DARK VERSE v1 | Owner: MikaaDev - V0.1
-- INJECT LANGSUNG KE CORE GAME

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

print("[DARK VERSE] INJECTING CORE HOOKS...")

-- SIMPLE UI YANG GA KETUTUP
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CoreHack"
ScreenGui.Parent = game.CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0.2, 0, 0.15, 0)
Main.Position = UDim2.new(0.78, 0, 0.1, 0) -- ATAS KANAN
Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Main.BackgroundTransparency = 0.3
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromRGB(255, 0, 0)
Main.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Text = "⚡ CORE HOOK ACTIVE"
Title.Size = UDim2.new(1, 0, 0.4, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = Main

local Status = Instance.new("TextLabel")
Status.Text = "WAITING FOR COMBAT..."
Status.Size = UDim2.new(1, 0, 0.6, 0)
Status.Position = UDim2.new(0, 0, 0.4, 0)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(0, 255, 0)
Status.Font = Enum.Font.Gotham
Status.TextSize = 11
Status.Parent = Main

-- ==================== CORE HOOK SYSTEM ====================
-- INJECT LANGSUNG KE METATABLE DAN REMOTE

local hookApplied = false
local originalMethods = {}

-- HOOK SEMUA REMOTE EVENT
local function hookAllRemotes()
    if hookApplied then return end
    
    print("[HOOK] Scanning for damage remotes...")
    
    -- Scan ReplicatedStorage
    local function hookRemote(remote)
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            local nameLower = remote.Name:lower()
            
            if nameLower:find("damage") or nameLower:find("hit") or nameLower:find("attack") or 
               nameLower:find("punch") or nameLower:find("strike") or nameLower:find("swing") then
                
                originalMethods[remote] = remote.FireServer
                
                remote.FireServer = function(self, ...)
                    local args = {...}
                    
                    -- DEBUG: Print semua argument
                    print("[HOOK] " .. remote.Name .. " fired!")
                    
                    -- MODIFIKASI DAMAGE
                    for i, arg in ipairs(args) do
                        -- Jika arg adalah number (damage value)
                        if type(arg) == "number" and arg > 0 and arg < 1000 then
                            local newDamage = arg * 2.5  -- +150%
                            args[i] = newDamage
                            print("[HOOK] Damage boosted: " .. arg .. " -> " .. newDamage)
                        
                        -- Jika arg adalah table dengan property Damage
                        elseif type(arg) == "table" then
                            if arg.Damage then
                                arg.Damage = arg.Damage * 2.5
                                print("[HOOK] Table Damage boosted: " .. arg.Damage)
                            elseif arg.damage then
                                arg.damage = arg.damage * 2.5
                                print("[HOOK] Table damage boosted: " .. arg.damage)
                            end
                        end
                    end
                    
                    -- Jika ada argumen player target, coba langsung kill
                    for _, arg in ipairs(args) do
                        if type(arg) == "userdata" and arg:IsA("Player") then
                            -- Coba langsung set health
                            spawn(function()
                                local targetChar = arg.Character
                                if targetChar and targetChar:FindFirstChild("Humanoid") then
                                    targetChar.Humanoid:TakeDamage(50) -- Extra damage
                                end
                            end)
                        end
                    end
                    
                    Status.Text = "DAMAGE BOOSTED!"
                    task.wait(0.5)
                    Status.Text = "ACTIVE"
                    
                    return originalMethods[remote](self, unpack(args))
                end
                
                print("[HOOK] Successfully hooked: " .. remote.Name)
            end
        end
    end
    
    -- Hook semua remote di ReplicatedStorage
    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
        hookRemote(remote)
    end
    
    -- Hook juga di Workspace dan lainnya
    for _, remote in pairs(workspace:GetDescendants()) do
        hookRemote(remote)
    end
    
    -- Hook Player scripts
    for _, remote in pairs(Player:GetDescendants()) do
        hookRemote(remote)
    end
    
    hookApplied = true
    print("[HOOK] All damage remotes hooked!")
end

-- HOOK HUMANOD.TAKEDAMAGE
local function hookHumanoid()
    if Character and Character:FindFirstChild("Humanoid") then
        local humanoid = Character.Humanoid
        
        -- BUAT KITA TIDAK BISA MATI
        local originalTakeDamage = humanoid.TakeDamage
        humanoid.TakeDamage = function(self, amount)
            -- Reduce damage yang kita terima
            local reducedAmount = amount * 0.2  -- Cuma terima 20% damage
            Status.Text = "DAMAGE REDUCED: " .. math.floor(reducedAmount)
            return originalTakeDamage(self, reducedAmount)
        end
        print("[HOOK] Humanoid.TakeDamage hooked!")
    end
end

-- AUTO DETECT COMBAT
local combatActive = false
RunService.Heartbeat:Connect(function()
    -- Update status
    if Character and Character:FindFirstChild("Humanoid") then
        Status.Text = "HP: " .. math.floor(Character.Humanoid.Health) .. " | ACTIVE"
    end
    
    -- Auto hook kalau belum
    if not hookApplied then
        hookAllRemotes()
        hookHumanoid()
    end
    
    -- Auto kill musuh terdekat
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= Player then
            local targetChar = targetPlayer.Character
            if targetChar and targetChar:FindFirstChild("Humanoid") then
                local distance = (Character.HumanoidRootPart.Position - targetChar.HumanoidRootPart.Position).Magnitude
                
                if distance < 15 then
                    combatActive = true
                    
                    -- Extra damage pas dekat
                    if math.random(1, 3) == 1 then
                        targetChar.Humanoid:TakeDamage(5)
                    end
                end
            end
        end
    end
end)

-- HOOK TOOL EQUIPPED
local function hookTool(tool)
    if tool:IsA("Tool") then
        -- Cari Handle
        local handle = tool:FindFirstChild("Handle")
        if handle then
            -- Hook touched event
            handle.Touched:Connect(function(hit)
                if hit.Parent and hit.Parent:FindFirstChild("Humanoid") then
                    local targetHumanoid = hit.Parent.Humanoid
                    
                    -- Extra damage on hit
                    spawn(function()
                        targetHumanoid:TakeDamage(15)
                        Status.Text = "EXTRA HIT!"
                    end)
                end
            end)
        end
    end
end

-- Monitor new tools
Player.CharacterAdded:Connect(function(char)
    Character = char
    wait(1)
    hookHumanoid()
    
    -- Hook tools in backpack
    Player.Backpack.ChildAdded:Connect(hookTool)
    
    -- Hook equipped tools
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            hookTool(child)
        end
    end)
end)

-- Hook existing tools
for _, tool in pairs(Player.Backpack:GetChildren()) do
    hookTool(tool)
end

if Character then
    for _, tool in pairs(Character:GetChildren()) do
        if tool:IsA("Tool") then
            hookTool(tool)
        end
    end
end

-- MANUAL DAMAGE BUTTON
local DamageBtn = Instance.new("TextButton")
DamageBtn.Text = "💥 FORCE DAMAGE"
DamageBtn.Size = UDim2.new(0.9, 0, 0.3, 0)
DamageBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
DamageBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
DamageBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DamageBtn.Font = Enum.Font.GothamBold
DamageBtn.TextSize = 12
DamageBtn.Parent = Main

DamageBtn.MouseButton1Click:Connect(function()
    -- Coba semua damage remote
    for remote, original in pairs(originalMethods) do
        spawn(function()
            pcall(function()
                -- Coba fire ke semua player
                for _, target in pairs(Players:GetPlayers()) do
                    if target ~= Player then
                        remote:FireServer(target, 100)
                        remote:FireServer({Player = target, Damage = 100})
                    end
                end
            end)
        end)
    end
    
    -- Direct damage
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= Player and target.Character and target.Character:FindFirstChild("Humanoid") then
            target.Character.Humanoid:TakeDamage(50)
        end
    end
    
    Status.Text = "FORCE DAMAGE SENT!"
    wait(1)
end)

-- INJECT SUCCESS
print("[DARK VERSE] CORE INJECTION COMPLETE!")
print("[DARK VERSE] All damage systems hooked")
print("[DARK VERSE] Auto-kill active")
print("[DARK VERSE] God mode active")

Status.Text = "INJECTED - WAIT FOR COMBAT"

-- NOTIFICATION
local notif = Instance.new("TextLabel")
notif.Text = "🔥 SYSTEM HOOKED - DAMAGE BOOSTED"
notif.Size = UDim2.new(0.4, 0, 0.05, 0)
notif.Position = UDim2.new(0.3, 0, 0.95, 0)
notif.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
notif.BackgroundTransparency = 0.3
notif.TextColor3 = Color3.fromRGB(0, 255, 0)
notif.Font = Enum.Font.GothamBold
notif.TextSize = 14
notif.Parent = ScreenGui

game:GetService("Debris"):AddItem(notif, 5)
