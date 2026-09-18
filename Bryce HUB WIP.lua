local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Bryce Hub", "Midnight")
local speed = 16
local jump = 50
local speedtoggle = false
local jumptoggle = false
local once = false
local falldamagehook
local falldamage = false
local employeetable = {}
local employee = false
local employeeconnect
local itemtable = {}
local item = false
local itemconnect
local playerstable = {}
local players = false
local playersconnect
local selectedpoint = "Point1"
local pointcolor = Color3.new(1, 0, 0)
local itemnames = {}

for _, v in pairs(game.ReplicatedStorage.Modules.Item._EDIBLE:GetDescendants()) do
    if v:IsA("ModuleScript") then
        table.insert(itemnames, v.Name)
    end
end

game.StarterGui:SetCore("SendNotification", {Title = "Loaded", Text = "3008", Duration = 4,})

local Main = Window:NewTab("Main")
local MainSection = Main:NewSection("Common Things")
MainSection:NewSlider("WalkSpeed", "Move Faster", 200, 16, function(s) -- 200 (MaxValue) | 16 (MinValue)
    speed = s
end)

MainSection:NewSlider("JumpPower", "Jump Higher", 200, 50, function(s) -- 200 (MaxValue) | 50 (MinValue)
    jump = s
end)

MainSection:NewToggle("Loop Walkspeed", "Loop Speed", function(state)
    if state then
        speedtoggle = true
        while task.wait(0.1) do
            if speedtoggle then
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
            elseif speedtoggle == false then
                break
            end
        end
    else
        speedtoggle = false
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

MainSection:NewToggle("Loop JumpPower", "Loop Jump Height", function(state)
    if state then
        jumptoggle = true
        while task.wait(0.1) do
            if jumptoggle then
                game.Players.LocalPlayer.Character.Humanoid.JumpPower = jump
            elseif jumptoggle == false then
                break
            end
        end
    else
        jumptoggle = false
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
    end
end)
MainSection:NewButton("Disable Fall Damage Legacy", "No Fall Damage You Dumbfuck", function()
    game.Players.LocalPlayer.Character.FallDamage:Destroy()
end)
local ESP = Window:NewTab("ESP")
local ESPSection = ESP:NewSection("See Stuff Through Walls")
local Waypoint = Window:NewTab("Waypoint TP")
local WaypointSection = Waypoint:NewSection("Set A Game Waypoint Too For Better")
local Visual = Window:NewTab("Visual")
local VisualSection = Visual:NewSection("Clear Up Screen")
local UI = Window:NewTab("UI Toggle")
local UISection = UI:NewSection("Show/Hide")



UISection:NewKeybind("Show/Hide GUI", "Toggle UI", Enum.KeyCode.RightShift, function()
    Library:ToggleUI()
end)

local colors = {
    SchemeColor = Color3.fromRGB(0,100,0),
    Background = Color3.fromRGB(0, 0, 0),
    Header = Color3.fromRGB(0, 0, 0),
    TextColor = Color3.fromRGB(255,255,255),
    ElementColor = Color3.fromRGB(20, 20, 20)
}
for theme, color in pairs(colors) do
    UISection:NewColorPicker(theme, "Change your "..theme, color, function(color3)
        Library:ChangeColor(theme, color3)
    end)
end