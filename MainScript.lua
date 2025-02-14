-- this script IS getting a new update, i will change the ui, fix some things and some features, most of the code will be rewritten. just watiing for swift to udptate (This script WILL remain open source)

--[[
	If you want to view the feedback for some reason: https://discord.gg/wAamT8wdQH
	Community Server: https://discord.gg/hFCsjYRVJ4
	TODO:
		Better Farming
		Auto Builder
		Mod Detection
		Infinite Money fr (need a vulnverability for this)
		Auto Quests
		Bug Fixes
]]

-- fuck da risky haul devs 🔥
--[[
	NOTES:
 	OWNER ALT ACC: Altered (user is "krampus.gg")
	MAIN ACCOUNT: apnff0x (cute cat)
]]

game.StarterGui:SetCore("SendNotification", {
 Title = "ps",Text="ps: Risky haul is updating alot and the script might become broken, if it does pls use the feedback section and attach a video",
 Duration = 13
});

local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local http = game:GetService("HttpService")
local ts = game:GetService("TweenService")
local starter = game:GetService("StarterGui")
local lp = game:GetService("Players").LocalPlayer

local studio = rs:IsStudio()

local function yznotify(text)
	if studio then return end
	starter:SetCore("SendNotification", {Text = text, Title = "YZenium", Duration = 5})
end
yznotify("Loading Library")
local gdata = loadstring(game:HttpGet('https://raw.githubusercontent.com/railme37509124/riskyhaulscript/refs/heads/main/somestuff/ui'))()

MainWindow = gdata:Window({
	GameName = "Risky Haul",
	Title = "Komaru Hub [UPDATED]"
})

Stuff = MainWindow:Tab({Title = "Stuff", Image = "rbxassetid://133515989982114"})
Crates = MainWindow:Tab({Title = "Chests", Image = "rbxassetid://118160654844398"})
World = MainWindow:Tab({Title = "World", Image = "rbxassetid://86004623527145"})
Settings = MainWindow:Tab({Title = "Library", Image = "rbxassetid://93373207940848"})

Stuff:Divider("General")

local FuelValueChanged = nil
local skibidi1 = false
local cargosellpoint = loadstring(game:HttpGet("https://raw.githubusercontent.com/railme37509124/riskyhaulscript/refs/heads/main/somestuff/cargosellpoint"))()

local function tweenroot(time,pos)
    game:GetService("TweenService"):Create(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = pos}):Play()
end

local function tweencar(time,pos)
    game:GetService("TweenService"):Create(game:GetService("Players").LocalPlayer.Character.Humanoid.SeatPart, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = pos}):Play()
end

local function ischar()
    if game:GetService("Players").LocalPlayer.Character then
        if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid") then
            return true
        end
    end
end
local function GetFuelUwU()
	game.Players.LocalPlayer.PlayerScripts["Launch/Drive"].FuelLevel.Value = 333333333
	--game:GetService("Players").LocalPlayer.PlayerGui.Fuel.CanvasGroup.FuelText.Text = "Fuel: infinite :3"
end
local function LoseFuelO_O()
	game.Players.LocalPlayer.PlayerScripts["Launch/Drive"].FuelLevel.Value = 25
	--game:GetService("Players").LocalPlayer.PlayerGui.Fuel.CanvasGroup.FuelText.Text = "Fuel: 25"
end
Stuff:Toggle({Name = "Infintite Fuel", Callback = function(state)
	if state then
		GetFuelUwU()
		FuelValueChanged = game.Players.LocalPlayer.PlayerScripts["Launch/Drive"].FuelLevel:GetPropertyChangedSignal("Value"):Connect(GetFuelUwU)
	elseif not state and FuelValueChanged then
		LoseFuelO_O()
		FuelValueChanged:Disconnect()
	end
end})
Stuff:Divider("Vehicle Modifiers")
Stuff:Button({Name = "Please relaunch the build to update the modifiers", Callback = function()
	yznotify("Press the return button")
end})
Stuff:Slider({Name = "Acceleration Boost", Callback = function (v)
	game:GetService("ReplicatedStorage").EngineConfig.Engine.AccelerationBoost.Value = v
	game:GetService("ReplicatedStorage").EngineConfig["Diesel Engine"].AccelerationBoost.Value = v
end, min = 1, max = 1000})
Stuff:Slider({Name = "Fuel Usage", Callback = function (v)
	game:GetService("ReplicatedStorage").EngineConfig.Engine.FuelUsage.Value = v
	game:GetService("ReplicatedStorage").EngineConfig["Diesel Engine"].AccelerationBoost.Value = v
end, min = 1, max = 1000})
Stuff:Slider({Name = "Max Speed", Callback = function (v)
	game:GetService("ReplicatedStorage").EngineConfig.Engine.MaxSpeedBoost.Value = v
	game:GetService("ReplicatedStorage").EngineConfig["Diesel Engine"].MaxSpeedBoost.Value = v
end, min = 1, max = 7500})
Stuff:Slider({Name = "Torque Boost", Callback = function (v)
	game:GetService("ReplicatedStorage").EngineConfig.Engine.TorqueBoost.Value = v
	game:GetService("ReplicatedStorage").EngineConfig["Diesel Engine"].TorqueBoost.Value = v
end, min = 10000, max = 250000})
Stuff:Button({Name = "Reset to defaults", Callback = function()
	game:GetService("ReplicatedStorage").EngineConfig.Engine.TorqueBoost.Value = 10000
	game:GetService("ReplicatedStorage").EngineConfig["Diesel Engine"].TorqueBoost.Value = 15000

	game:GetService("ReplicatedStorage").EngineConfig.Engine.MaxSpeedBoost.Value = 2
	game:GetService("ReplicatedStorage").EngineConfig["Diesel Engine"].MaxSpeedBoost.Value = 3

	game:GetService("ReplicatedStorage").EngineConfig.Engine.FuelUsage.Value = 1
	game:GetService("ReplicatedStorage").EngineConfig["Diesel Engine"].AccelerationBoost.Value = 1.25

	game:GetService("ReplicatedStorage").EngineConfig.Engine.AccelerationBoost.Value = 1
	game:GetService("ReplicatedStorage").EngineConfig["Diesel Engine"].AccelerationBoost.Value = 1.25
	yznotify("Reset to defaults")
end})

local winspeed = 100
Stuff:Divider("Farming")
Stuff:Slider({Name = "Win Speed", Callback = function(v)
	winspeed = v
end, min = 100, max = 800})
Stuff:Button({Name = "Goto best sell point", Callback = function()
	-- "its kinda bad, the auto farm doesnt work, and speed and things make me get flinged."
	if not game:GetService("Players").LocalPlayer.Character.Humanoid.SeatPart then
		return game.StarterGui:SetCore("SendNotification", {
			 Title = "get in car",Text="get in a car to use this",
			 Duration = 4
		});
	end
	game:GetService("Players").LocalPlayer.Character.Humanoid.SeatPart.CFrame = CFrame.new(57.267025, 44.5856285, -171.732178, -0.999935448, -1.00159582e-07, -0.0113605559, -1.01334564e-07, 1, 1.02850514e-07, 0.0113605559, 1.03995092e-07, -0.999935448)
	tweencar(100 / (winspeed / 100), cargosellpoint)
end}) -- go win
Stuff:Toggle({Name = "Fix \"goto sell point\" if it glitches out", Callback = function(state)
	skibidi1 = state
end})
Stuff:Toggle({Name = "autosell when reach a thing", Callback = function(state)
	skibidi2 = state
end})
Stuff:Button({Name = "Money hack", Callback = function()
	_G.moneycount = math.huge
	loadstring(game:HttpGet('https://raw.githubusercontent.com/railme37509124/blazecompetence-/refs/heads/main/exploit_V2.0.0'))()
end})
Stuff:Divider("Discord")
Stuff:Button({Name = "Copy developer UserID (discord)", Callback = function() setclipboard("1215375161121833063") end})
Stuff:Button({Name = "Copy Discord", Callback = function() setclipboard("https://discord.gg/hFCsjYRVJ4") end})
Stuff:Button({Name = "Copy official risky haul discord", Callback = function() setclipboard("https://discord.gg/risky-haul-1264916236236619857") end})

local iwannabuythis = nil
local iwannabuythis2 = nil
local count = 1
local pwices = {
	["Functional"] = {
		["Grass"] = 250,
		["Cave"] = 900,
		["Tundra"] = 2000
	},
	["Structural"] = {
		["Grass"] = 150,
		["Cave"] = 650,
		["Tundra"] = 1350
	}
}
local function buyCrate(crate, biome)
	game:GetService("ReplicatedStorage").RemoteEvents.ChestEvents.PurchaseChest:FireServer(crate .. " Chest", biome .. " Biome")
end

Crates:Divider("Chests")
Crates:Dropdown({Name = "Chest Type", List = {"Functional", "Structural"}, Callback = function(v)
	iwannabuythis = v
end})
Crates:Dropdown({Name = "Biome", List = {"Grass", "Cave", "Tundra"}, Callback = function(v)
	iwannabuythis2 = v
end})
Crates:Slider({Name = "Amount", Callback = function(v)
	count = v
end, min = 1, max = 1000})
Crates:Button({Name = "Buy Crates", Callback = function()
	if not iwannabuythis then yznotify("Please choose a chest type") return end
	if not iwannabuythis2 then yznotify("Please choose a biome") return end
	local pmath = (pwices[iwannabuythis][iwannabuythis2])*count
	if game:GetService("Players").LocalPlayer.leaderstats["Stud Bucks"].Value < pmath then
		yznotify("You do not have enough stud bucks for this! You need ~" .. tostring(math.round(pmath)) .. " more stud bucks")
		return
	end
	for i = 1, count do
		buyCrate(iwannabuythis, iwannabuythis2)
	end
	yznotify("Crates were bought")
end})
Crates:Divider("Help")
Crates:Button({Name = "Estimate Cost", Callback = function()
	if not iwannabuythis then yznotify("Please choose a chest type") return end
	if not iwannabuythis2 then yznotify("Please choose a biome") return end
	local pmath = (pwices[iwannabuythis][iwannabuythis2])*count
	yznotify("It costs ~" .. tostring(math.round(pmath)) .. " stud bucks to buy "..count.." chests")
end})

local thetheme = nil
Settings:Divider("Theme")
Settings:Dropdown({Name = "Theme", List = {"Blood", "Water", "Grape"}, Callback = function(v) thetheme = v end})
Settings:Button({Name = "Set Theme", Callback = function()
	if not thetheme then yznotify("Please select a theme") return end
	if writefile then
		writefile("komaruthemeuwu", thetheme)
	end
	gdata:LoadPresetTheme(thetheme)
end})
local CopyCharactersFolder = Instance.new("Folder", game.Lighting) -- bro is using the second arugment of instance.new 💀💀 what an npc
World:Divider("World")
World:Toggle({Name = "Hide Characters", Callback = function(state)
	if state then
		for i, v in game.Workspace.CharactersFolder:GetChildren() do
			if v ~= game.Players.LocalPlayer.Character then
				v.Parent = CopyCharactersFolder
			end
		end
	else
		for i, v in CopyCharactersFolder:GetChildren() do
			v.Parent = game.Workspace.CharactersFolder
		end
	end
end})
World:Button({Name = "Remove road obstacles (Half broke)", Callback = function()
	for i, v in workspace.Map.Road:GetChildren() do
		if v:IsA("Model") and v.Name:find("RoadLane") then
			for ii, vv in v:FindFirstChild("Obstacles"):GetChildren() do
				vv:Destroy()
			end
		end
	end
	for n, x in workspace.Map.Nature.Flowers:GetChildren() do
		for i, v in x:GetChildren() do
			if v:IsA("Part") then
				v:Destroy()
			end
		end
	end
end})
World:Divider("Extra")
World:Slider({Name = "Player Walkspeed", Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end, min = 16, max = 300})
World:Slider({Name = "Player Jumppower", Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.JumpPower = v end, min = 50, max = 300})
World:Keybind({Name = "Reset Character quick keybind", Callback = function() game.Players.LocalPlayer.Character:BreakJoints() end})

-- // loops here

task.spawn(function()
    repeat
        if skibidi1 then
            if ischar() then
                if game:GetService("Players").LocalPlayer.Character.Humanoid.SeatPart then
                    game:GetService("Players").LocalPlayer.Character.Humanoid.SeatPart.Velocity = Vector3.new(game:GetService("Players").LocalPlayer.Character.Humanoid.SeatPart.Velocity.X, 0, game:GetService("Players").LocalPlayer.Character.Humanoid.SeatPart.Velocity.Z)
                end
            end
        end
        if skibidi2 then
            game:GetService("ReplicatedStorage").RemoteEvents.SellCargo:FireServer()
        end
        task.wait()
    until nil
end)

-- // loops end

-- This part is specifically obfuscated because i dont want my webhook getting spammed, sorry! (its the feedback section)
_G.YZSETTINGS = Settings
_G.YZNOTIFY = yznotify
loadstring(game:HttpGet("https://raw.githubusercontent.com/railme37509124/riskyhaulscript/refs/heads/main/feedbackmenu", true))()
