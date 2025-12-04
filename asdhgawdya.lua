repeat
    task.wait(0.1)
until game:IsLoaded() and _G.Horst_SetDescription and _G.DataConfigs

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")

local Equipments = require(ReplicatedStorage.Shared.Data.Equipments)
local Knit = require(Shared.Packages.Knit)
local PlayerController = Knit.GetController("PlayerController")
local Replica = PlayerController.Replica

-- ฟังก์ชันดึง Level
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

local Pickaxes = {}
local Gold
local triggered = false

local TargetPickaxes = {}
for _, name in ipairs(_G.DataConfigs.Pickaxe or {}) do
    TargetPickaxes[name] = true
end

while true do
    Gold = Replica.Data.Gold or 0
    local Level = GetPlayerLevel(Replica)

    for _, item in pairs(Replica.Data.Inventory.Equipments) do
        if typeof(item) == "table" then
            if Equipments.Items.Pickaxe[item.Name] then
                table.insert(Pickaxes, item.Name)

                if TargetPickaxes[item.Name] and not triggered then
                    triggered = true
                    if _G.Horst_AccountChangeDone then
                        _G.Horst_AccountChangeDone()
                    end
                end
            end
        end
    end

    _G.Horst_SetDescription(
        "⛏️ Pickaxes: " .. table.concat(Pickaxes, ", ") ..
        ", 💰 Gold: " .. string.format("%d", Gold) ..
        ", ⭐ Level: " .. tostring(Level)
    )

    table.clear(Pickaxes)
    task.wait(10)
end
