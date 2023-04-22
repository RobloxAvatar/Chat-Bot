--[[
    Updated, Die!
]]

if disable then disable() end
local Players = game:GetService("Players")
local lp = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait() and Players.LocalPlayer
local connections = {}
local commands

local function getchar(plr)
    if not plr then plr = lp end
    return plr.Character or plr.CharacterAdded:Wait()
end

local function gethumanoid(plr)
    if not plr then plr = lp end
    return getchar(plr):WaitForChild("Humanoid")
end

local function getroot(plr)
    if not plr then plr = lp end
    local humanoid = gethumanoid(plr)
    repeat task.wait() until humanoid.RootPart
    return humanoid.RootPart
end

local function die()
    getchar():BreakJoints()
end

commands = {
    ["bring"] = function(speaker)
        getroot().CFrame = getroot(speaker).CFrame
    end,
    ["die"] = function()
        die()
    end
}

local function init(plr)
    connections[plr] = plr.Chatted:Connect(function(msg)
        local args = msg:split(" ")
        local cmd = args[1]:lower()
        local commandfunc = commands[cmd]

        if commandfunc then
            commandfunc(plr,args)
        end
    end)
end

connections["PlayerRemoving"] = Players.PlayerRemoving:Connect(function(plr)
    connections[plr]:Disconnect()
    connections[plr] = nil
end)

connections["PlayerAdded"] = Players.PlayerAdded:Connect(init)
for i,v in next, Players:GetPlayers() do
    init(v)
end

getgenv().disable = function()
    for i,v in next, connections do
        v:Disconnect()
    end
    getgenv().disable = nil
end
