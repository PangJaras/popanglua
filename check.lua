repeat
    task.wait(15)
until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Main = LocalPlayer.PlayerGui:FindFirstChild("Main")
local Gold = Main and Main.Screen.Hud.Gold

local oldMoney = Gold.Text

local CHECK_TIME = 60 * 5  -- 300 วินาที

print("[ระบบเช็คเงิน] เริ่มทำงานแล้ว")
print("[ระบบเช็คเงิน] ค่าเริ่มต้น:", oldMoney)

getgenv().LOADED = true
warn("[", os.date("%H:%M:%S"), "] LOADEDCHECKSUCCESSFULLY = true")

while true do
    -- นับถอยหลัง 300 วินาที
    for i = CHECK_TIME, 1, -1 do
        print("[ระบบเช็คเงิน] ตรวจอีก:", i, "วินาที")
        task.wait(1)
    end

    -- ตรวจเงิน
    pcall(function()
        local newMoney = Gold.Text

        print("[ระบบเช็คเงิน] ค่าเดิม:", oldMoney, " | ค่าใหม่:", newMoney)

        if newMoney == oldMoney then
            warn("[ระบบเช็คเงิน] ไม่พบการเปลี่ยนแปลงของเงิน → Rejoin…")
            LocalPlayer:Kick("\nRejoining due to no coin change...")
        else
            print("[ระบบเช็คเงิน] เงินเปลี่ยนแปลง → อัปเดตค่าใหม่")
            oldMoney = newMoney
        end
    end)
end
