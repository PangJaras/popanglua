_G.targetName = { "Archangel", "Demon", "Angel" } -- Developer, Orc, Demon, Vampire, Undead, Felynx, Zombie, Archangel, Fairy, Minotaur, Dragonborn, Dwarf, Shadow, Angel, Elf, Golem, Human, Orc Lord, Goblin
_G.codes = { "XMAS!", "SORRYFORDELAY" }

repeat task.wait(.1) until game:IsLoaded()
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Reroll = Shared.Packages.Knit.Services.RaceService.RF.Reroll
local RedeemCode = Shared.Packages.Knit.Services.CodeService.RF.RedeemCode

local Knit = require(Shared.Packages.Knit)
local PlayerController = Knit.GetController("PlayerController")
local Replica = PlayerController.Replica

for _, code in pairs(_G.codes) do
    RedeemCode:InvokeServer(code)
end

while Replica.Data.Spins > 0 and task.wait(.1) do
    if table.find(_G.targetName, Replica.Data.Race) then break end
    Reroll:InvokeServer()
end

local messages = "Auto Reroll Complete: ".. Replica.Data.Race .. " Reroll Left: ".. Replica.Data.Spins
_G.Horst_SetDescription(messages)
_G.Horst_AccountChangeDone()
