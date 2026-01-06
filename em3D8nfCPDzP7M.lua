repeat task.wait(10) until game:IsLoaded()
repeat task.wait() until _G.Horst_SetDescription

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local CommF = ReplicatedStorage.Remotes.CommF_

local CFG = getgenv().PoPangConfig

local lastDescTime = 0
local lastChangeTime = 0

local function GetSanguineArtMastery()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local character = LocalPlayer.Character

    local tool =
        (backpack and backpack:FindFirstChild("Sanguine Art"))
        or (character and character:FindFirstChild("Sanguine Art"))

    if not tool then
        return false, 0
    end

    local level = tool:FindFirstChild("Level")
    return true, (level and level.Value) or 0
end

local function GetLeviathanHeartCount()
    local count = 0
    for _, item in next, CommF:InvokeServer("getInventory") do
        if item.Type == "Material" and item.Name == "Leviathan Heart" then
            count += item.Count or 1
        end
    end
    return count
end

local function BuildDescription(hasMelee, mastery, heartCount, isBoat)
    if heartCount > 0 and isBoat then
        return string.format("🚢 Helper Boat , ❤️ Leviathan Heart x%d", heartCount)
    end

    local meleeText = hasMelee
        and string.format("🤛Melee: SanguineArt, Mastery: %d", mastery)
        or "🤛Melee: None"

    local heartText = heartCount > 0
        and "❤️ Leviathan Heart"
        or "❤️ None"

    return meleeText .. " , " .. heartText
end

-- ✅ ฟังก์ชัน Update Description กลาง
local function UpdateDescription(hasMelee, mastery, heartCount, isBoat)
    _G.Horst_SetDescription(
        BuildDescription(hasMelee, mastery, heartCount, isBoat)
    )
    lastDescTime = os.clock()
end

task.spawn(function()
    while true do
        task.wait(1)

        local now = os.clock()

        local hasMelee, mastery = GetSanguineArtMastery()
        local heartCount = GetLeviathanHeartCount()
        local isBoat = CFG.EXCLUDE_USERNAMES[LocalPlayer.Name] == true

        -- 🔁 Update Description ปกติทุก 5 วิ
        if now - lastDescTime >= 5 then
            UpdateDescription(hasMelee, mastery, heartCount, isBoat)
        end

        local meleeOK = true
        local heartOK = true

        if CFG.Sanguine_Art then
            meleeOK = hasMelee and mastery >= CFG.Mastery_SanguineArt
        end

        if CFG.Leviathan_Heart then
            heartOK = heartCount > 0
        end

        local allConditionsOK =
            (not CFG.Sanguine_Art or meleeOK)
            and (not CFG.Leviathan_Heart or heartOK)

        if
            allConditionsOK
            and _G.Horst_AccountChangeDone
            and now - lastChangeTime >= 15
        then
            warn("[POPANG] เงื่อนไขครบตาม Config → DONE")

            -- ✅ บังคับ UpdateDescription ก่อน DONE ทุกครั้ง
            UpdateDescription(hasMelee, mastery, heartCount, isBoat)

            _G.Horst_AccountChangeDone()
            lastChangeTime = now
        end
    end
end)
