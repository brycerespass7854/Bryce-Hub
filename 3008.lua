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
ESPSection:NewToggle("Employee ESP", "See Employees Through Walls", function(state)
    if state then
        employee = true
        for _, v in pairs(game.workspace.GameObjects.Physical.Employees:GetChildren()) do
            table.insert(employeetable, v)
        end
        employeeconnect = game.workspace.GameObjects.Physical.Employees.ChildAdded:Connect(function(v)
            table.insert(employeetable, v)
        end)
        while task.wait(0.1) do
            if employee then
                xpcall(function()
                    for i = #employeetable, 1, -1 do
                        local v = employeetable[i]
                        if not v or not v.Parent then
                            table.remove(employeetable, i)
                        else
                            if not v:FindFirstChild("ESPHighlight") then
                                if v:FindFirstChild("HumanoidRootPart") then
                                    local highlight = Instance.new("Highlight")
                                    highlight.Name = "ESPHighlight"
                                    highlight.FillColor = Color3.new(1, 0, 0)
                                    highlight.OutlineTransparency = 1
                                    highlight.Parent = v
                                end
                            end
                        end
                    end
                end, function(err)
                    warn("Employee ESP Error")
                    warn(debug.traceback(err))
                end)
            elseif employee == false then
                break
            end
        end
    else
        employee = false
        employeeconnect:Disconnect()
        employeetable = {}
        for _, v in pairs(game.workspace.GameObjects.Physical.Employees:GetChildren()) do
            if v:FindFirstChild("ESPHighlight") then
                v.ESPHighlight:Destroy()
            end
        end
    end
end)

ESPSection:NewToggle("Item ESP", "See Items Through Walls", function(state)
    if state then
        item = true
        for _, v in pairs(game.workspace.GameObjects.Physical:GetDescendants()) do
            for _, v2 in pairs(itemnames) do
                if v.Name == v2 then
                    table.insert(itemtable, v)
                end
            end
        end
        itemconnect = game.workspace.GameObjects.Physical.DescendantAdded:Connect(function(v)
            for _, v2 in pairs(itemnames) do
                if v.Name == v2 then
                    table.insert(itemtable, v)
                end
            end
        end)
        while task.wait(0.1) do
            if item then
                xpcall(function()
                    for i = #itemtable, 1, -1 do
                        local v = itemtable[i]
                        if not v or not v.Parent then
                            table.remove(itemtable, i)
                        else
                            if not v:FindFirstChild("ESPBillboard") then
                                local billboard = Instance.new("BillboardGui")
                                billboard.Name = "ESPBillboard"
                                billboard.Size = UDim2.new(0, 50, 0, 50)
                                billboard.StudsOffset = Vector3.new(0, 1, 0)
                                billboard.AlwaysOnTop = true
                                billboard.Parent = v

                                local textLabel = Instance.new("TextLabel")
                                textLabel.Size = UDim2.new(1, 0, 0.4, 0)
                                textLabel.Position = UDim2.new(0, 0, 0, 0)
                                textLabel.BackgroundTransparency = 0
                                textLabel.TextColor3 = Color3.new(0, 1, 0)
                                textLabel.BackgroundColor3 = Color3.new(0, 0, 0)
                                textLabel.AutomaticSize = "XY"
                                textLabel.BorderSizePixel = 0
                                textLabel.Text = v.Name
                                textLabel.Parent = billboard
                            end
                        end
                    end
                end, function(err)
                    warn("Item ESP Error")
                    warn(debug.traceback(err))
                end)
            elseif item == false then
                break
            end
        end
    else
        item = false
        itemconnect:Disconnect()
        itemtable = {}
        for _, v in pairs(game.workspace.GameObjects.Physical:GetDescendants()) do
            for _, v2 in pairs(itemnames) do
                if v.Name == v2 then
                    if v:FindFirstChild("ESPBillboard") then
                        v.ESPBillboard:Destroy()
                    end
                end
            end
        end
    end
end)

ESPSection:NewToggle("Player ESP", "ESP The Players", function(state)
    if state then
        for _, v in pairs(game.Players:GetPlayers()) do
            table.insert(playerstable, v)
        end
        playersconnect = game.Players.PlayerAdded:Connect(function(v)
            table.insert(playerstable, v)
        end)
        players = true
        while task.wait(0.1) do
            if players then
                xpcall(function()
                    for i = #playerstable, 1, -1 do
                        local v = playerstable[i]
                        if not v or not v.Parent then
                            table.remove(playerstable, i)
                        else
                            if v ~= game.Players.LocalPlayer then
                                local character = v.Character
                                if character then
                                    if not character:FindFirstChild("ESPHighlight") then
                                        if character:FindFirstChild("HumanoidRootPart") then
                                            local highlight = Instance.new("Highlight")
                                            highlight.Name = "ESPHighlight"
                                            highlight.FillColor = Color3.new(0, 1, 0)
                                            highlight.Parent = character
                                        end
                                    end
                                end
                            end
                        end
                    end
                end, function(err)
                    warn("Player ESP Error")
                    warn(debug.traceback(err))
                end)
            elseif players == false then
                break
            end
        end
    else
        players = false
        playersconnect:Disconnect()
        playerstable = {}
        for _, Players in pairs(game.Players:GetPlayers()) do
            if Players ~= game.Players.LocalPlayer then
                local character = Players.Character
                if character and character:FindFirstChild("ESPHighlight") then
                    character.ESPHighlight:Destroy()
                end
            end
        end
    end
end)

local TP = Window:NewTab("Waypoint TP")
local TPSection = TP:NewSection("Set A Game Waypoint Too For Better")

TPSection:NewDropdown("Choose A Point", "Select A Point To Set", {"Point1", "Point2", "Point3", "Point4"}, function(currentOption)
    selectedpoint = currentOption
end)

TPSection:NewButton("Set Waypoint", "Tp Test", function()
    local point = Instance.new("Part")
    point.Name = selectedpoint
    point.Size = Vector3.new(1, 1, 1)
    point.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    point.Anchored = true
    point.Color = Color3.new(1, 1, 1)
    point.CanCollide = false
    point.Parent = game.workspace

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPBillboard"
    billboard.Size = UDim2.new(0, 50, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 0, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = point

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0.25, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = pointcolor
    label.TextScaled = true
    label.Text = selectedpoint
    label.Parent = billboard
end)

TPSection:NewButton("TP To Waypoint", "Tp", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.workspace[selectedpoint].CFrame
end)

TPSection:NewButton("Delete Waypoint", "Remove", function()
    game.workspace[selectedpoint]:Destroy()
end)

TPSection:NewColorPicker("Waypoint Color", "Color For Point", Color3.fromRGB(1,0,0), function(color)
    pointcolor = color
end)
local Visual = Window:NewTab("Visual")
local VisualSection = Visual:NewSection("Clear Up Screen")

VisualSection:NewToggle("Disable Fog", "No Fog", function(state)
    if state then
        local lighting = game:GetService("Lighting")
        lighting.FogEnd = 100000
    else
        local lighting = game:GetService("Lighting")
        lighting.FogEnd = 1000
    end
end)

VisualSection:NewToggle("FullBright", "Brighten The Game", function(state)
    if state then
        local lighting = game:GetService("Lighting")
        local properties = {ClockTime = 14, GlobalShadows = false, Ambient = Color3.fromRGB(255, 255, 255), Brightness = 5, OutdoorAmbient = Color3.fromRGB(255, 255, 255)}
        for i, v in pairs(properties) do
            lighting[i] = v
            lightingconnects[i] = lighting:GetPropertyChangedSignal(i):Connect(function()
                if lighting[i] ~= v then
                    lighting[i] = v
                end
            end)
        end
    else
        for _, v in pairs(lightingconnects) do
            v:Disconnect()
        end
        lightingconnects = {}
    end
end)

VisualSection:NewToggle("Show Time Left", "A Free Clock", function(state)
    if state then
        local gui = Instance.new("ScreenGui")
        gui.Name = "ShowTime"
        gui.Parent = game.Players.LocalPlayer.PlayerGui
        local namelabel = Instance.new("TextLabel")
        namelabel.Name = "Time"
        namelabel.Text = "Time: "
        namelabel.TextScaled = true
        namelabel.Position = UDim2.new(0, 0, 0, 0)
        namelabel.Size = UDim2.new(0, 200, 0, 50)
        namelabel.Parent = gui
        showtime = true
        while task.wait(0.1) do
            if showtime then
                game.Players.LocalPlayer.PlayerGui.ShowTime.Time.Text = game.ReplicatedStorage.ServerSettings.TimeSettings:GetAttribute("TimeState") .. " Time: " .. tostring(game.ReplicatedStorage.ServerSettings.TimeSettings.TimeLeft.Value)
            elseif showtime == false then
                break
            end
        end
    else
        showtime = false
        game.Players.LocalPlayer.PlayerGui.ShowTime:Destroy()
    end
end)
local UI = Window:NewTab("UI Toggle")
local UISection = UI:NewSection("Show/Hide")



UISection:NewKeybind("Show/Hide GUI", "Toggle UI", Enum.KeyCode.RightShift, function()
    Library:ToggleUI()
end)

local colors = {
    SchemeColor = Color3.fromRGB(0,255,255),
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
