-- ================================
-- MIKAADEV DEBUGGER - FIND GAME STRUCTURE
-- ================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

print("=== MIKAADEV DEBUG MODE ===")

-- 1. CEK STRUKTUR PLAYER DATA
print("\n[1] PLAYER DATA STRUCTURE:")
wait(0.5)

for _, child in pairs(LocalPlayer:GetChildren()) do
    print("   - " .. child.Name .. " (" .. child.ClassName .. ")")
    
    if child:IsA("Folder") or child:IsA("Model") then
        for _, subchild in pairs(child:GetChildren()) do
            print("     * " .. subchild.Name .. " = " .. tostring(subchild.Value) .. " (" .. subchild.ClassName .. ")")
        end
    end
end

-- 2. CEK REMOTE EVENTS/FUNCTIONS
print("\n[2] REMOTE EVENTS/FUNCTIONS:")
wait(0.5)

local remotesFound = {}
for _, obj in pairs(game:GetDescendants()) do
    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
        if not table.find(remotesFound, obj.Name) then
            table.insert(remotesFound, obj.Name)
            print("   - " .. obj.Name .. " (" .. obj.ClassName .. ")")
        end
    end
end

-- 3. CEK COIN/MONEY VALUES
print("\n[3] SEARCHING FOR COIN/MONEY VALUES:")
wait(0.5)

local function SearchForValue(root, depth)
    if depth > 3 then return end
    
    for _, child in pairs(root:GetChildren()) do
        if child:IsA("IntValue") or child:IsA("NumberValue") or child:IsA("StringValue") then
            local nameLower = child.Name:lower()
            if nameLower:find("coin") or nameLower:find("money") or nameLower:find("uang") or nameLower:find("cash") then
                print("   FOUND: " .. child:GetFullName() .. " = " .. tostring(child.Value))
            end
        end
        SearchForValue(child, depth + 1)
    end
end

SearchForValue(LocalPlayer, 0)
SearchForValue(game:GetService("ReplicatedStorage"), 0)

-- 4. CEK DAMAGE SYSTEM
print("\n[4] DAMAGE SYSTEM INFO:")
wait(0.5)

-- Cari tool/weapon
if LocalPlayer.Character then
    for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
        if tool:IsA("Tool") then
            print("   Tool Found: " .. tool.Name)
            for _, script in pairs(tool:GetChildren()) do
                if script:IsA("Script") or script:IsA("LocalScript") then
                    print("     Script: " .. script.Name)
                    -- Cari kata "damage" di source
                    local source = script.Source
                    if source:lower():find("damage") then
                        print("     ! Contains 'damage' in script")
                    end
                end
            end
        end
    end
end

-- 5. TEST COIN HACK MANUAL
print("\n[5] TESTING COIN HACK MANUALLY:")
wait(0.5)

local function TestCoinHack()
    -- Coba semua kemungkinan
    local possiblePaths = {
        LocalPlayer:FindFirstChild("leaderstats"),
        LocalPlayer:FindFirstChild("Stats"),
        LocalPlayer:FindFirstChild("Data"),
        LocalPlayer:FindFirstChild("PlayerStats"),
        LocalPlayer:FindFirstChild("Currency")
    }
    
    for _, folder in pairs(possiblePaths) do
        if folder then
            print("   Checking folder: " .. folder.Name)
            for _, value in pairs(folder:GetChildren()) do
                if value:IsA("IntValue") or value:IsA("NumberValue") then
                    local oldValue = value.Value
                    value.Value = 9999
                    print("     - " .. value.Name .. ": " .. oldValue .. " -> " .. value.Value)
                    
                    -- Kembalikan nilai
                    value.Value = oldValue
                end
            end
        end
    end
end

TestCoinHack()

-- 6. TEST DAMAGE HOOK
print("\n[6] TESTING DAMAGE HOOK:")
wait(0.5)

-- Coba hook remote event damage
for _, remote in pairs(game:GetDescendants()) do
    if remote:IsA("RemoteEvent") then
        local nameLower = remote.Name:lower()
        if nameLower:find("damage") or nameLower:find("hit") or nameLower:find("attack") then
            print("   Found damage remote: " .. remote.Name)
            
            -- Backup fire function
            local oldFire = remote.FireServer
            remote.FireServer = function(self, ...)
                local args = {...}
                print("   Damage Event Fired! Args: " .. #args)
                for i, arg in ipairs(args) do
                    print("     Arg " .. i .. ": " .. tostring(arg) .. " (" .. typeof(arg) .. ")")
                end
                return oldFire(self, ...)
            end
        end
    end
end

print("\n=== DEBUG COMPLETE ===")
print("COPY OUTPUT INI DAN KASIH KE GUE!")
print("NANTI GUE BIKIN SCRIPT YANG SESUAI STRUKTUR GAME LU!")
