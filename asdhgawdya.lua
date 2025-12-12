repeat task.wait(1) until game:IsLoaded()
repeat task.wait() until _G.Horst_SetDescription and _G.DataConfigs

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")

local Equipments = require(ReplicatedStorage.Shared.Data.Equipments)
local Knit = require(Shared.Packages.Knit)
local PlayerController = Knit.GetController("PlayerController")
local Replica = PlayerController.Replica

repeat task.wait() until Replica and Replica.Data and Replica.Data.Inventory

getgenv().LOADED = true
warn("[", os.date("%H:%M:%S"), "] 5555555555555555555555555555555555555555")

local function GetPlayerLevel(Replica)
    if not Replica or not Replica.Data then
        return 0
    end

    return
        Replica.Data.Level or
        (Replica.Data.PlayerStats and Replica.Data.PlayerStats.Level) or
        (Replica.Data.Stats and Replica.Data.Stats.Level) or
        0
end

local suffixes = {"", "K", "M", "B", "T", "Q", "Qi", "Sx", "Sp", "O", "N", "D"}

local function FormatNumber(num)
    if type(num) ~= "number" then return tostring(num) end
    local i = 1
    while num >= 1000 and i < #suffixes do
        num = num / 1000
        i = i + 1
    end
    return string.format("%.2f", num) .. suffixes[i]
end

local TargetPickaxes = {}
for _, name in ipairs(_G.DataConfigs.Pickaxe or {}) do
    TargetPickaxes[name] = true
end

local triggered = false
local Pickaxes = {}

while true do
    local Gold = Replica.Data.Gold or 0
    local Level = GetPlayerLevel(Replica)
    local Race = Replica.Data.Race or "Unknown"

    local FoundPickaxes = {}

    for _, item in pairs(Replica.Data.Inventory.Equipments) do
        if typeof(item) == "table" and Equipments.Items.Pickaxe[item.Name] then
            table.insert(Pickaxes, item.Name)

            if TargetPickaxes[item.Name] then
                FoundPickaxes[item.Name] = true
            end
        end
    end

    if not triggered then
        local allFound = true
        for name, _ in pairs(TargetPickaxes) do
            if not FoundPickaxes[name] then
                allFound = false
                break
            end
        end

        if allFound then
            triggered = true
            if _G.Horst_AccountChangeDone then
                _G.Horst_AccountChangeDone()
            end
        end
    end

    _G.Horst_SetDescription(
        "⛏️ Pickaxes: " .. table.concat(Pickaxes, ", ") ..
        ", 💰 Gold: " .. FormatNumber(Gold) ..
        ", ⭐ Level: " .. tostring(Level) ..
        ", 👤 Race: " .. tostring(Race)
    )

    table.clear(Pickaxes)
    task.wait(10)
end
