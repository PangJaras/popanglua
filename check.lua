repeat
    task.wait(5)
until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Main = LocalPlayer.PlayerGui:FindFirstChild("Main")
local Gold = Main and Main.Screen.Hud.Gold

local oldMoney = Gold.Text

local CHECK_INTERVAL = 3
local COUNTDOWN_TIME = 1800

getgenv().LOADED = true
warn("[", os.date("%H:%M:%S"), "] LOADEDCHECK = true")

while task.wait(CHECK_INTERVAL) do
    print("[System] Working... Checking gold changes...")

    pcall(function()
        local newMoney = Gold.Text

        if newMoney == oldMoney then
            warn("No change in coins detected! Starting countdown to kick...")

            for i = COUNTDOWN_TIME, 1, -1 do
                warn("Kicking in " .. i .. " seconds... (System Running)")
                task.wait(1)
            end

            LocalPlayer:Kick("\nRejoining due to no coin change...")
        else
            print("[System] Gold changed! System running normally.")
            oldMoney = newMoney
        end
    end)
end
