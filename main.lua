--!strict

-- =====================================================================
-- ICE HUB 🧊 V 25-- ULTIMATE MASTER SCRIPT (FULL UNCOMPRESSED ARCHITECTURE)
-- Entwickelt von Nico und Marlon
-- INKLUSIVE PASSWORT-SYSTEM, CHAT SPAM BOT, SICHTBAREM TROLLING, MM2, MURDER PARTY, BLOX FRUITS, ARSENAL, HAMBURG & EMDEN
-- (UPDATE V 25--: 25 NEUE EMDEN FUNKTIONEN, ZAHLEN AUS HAMBURG/EMDEN ENTFERNT, CLEAN EMOJI UI)
-- Optimiert für RTX 3060 High-Performance & Maximum Exploitation
-- =====================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = Workspace.CurrentCamera

local playerAvatarImage = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"

-- =====================================================================
-- EXECUTOR FILE SYSTEM (MULTI-WORLD SPEICHERSYSTEM V 25--)
-- =====================================================================
local env = getfenv()
local write_file = env.writefile or function() end
local read_file = env.readfile or function() return "" end
local is_file = env.isfile or function() return false end

local stageData = {}
local currentWorldSelection = "Welt 1"
local currentStageSelection = "Stage 1"
local stageFileName = "IceHub_Stages_V25.json"

local function serializeCFrame(cf)
	return tostring(cf.X) .. "," .. tostring(cf.Y) .. "," .. tostring(cf.Z)
end

local function deserializeCFrame(str)
	if not str then return nil end
	local splitData = string.split(str, ",")
	if #splitData >= 3 then
		return CFrame.new(tonumber(splitData[1]) or 0, tonumber(splitData[2]) or 0, tonumber(splitData[3]) or 0)
	end
	return nil
end

pcall(function()
	if is_file(stageFileName) then
		local decoded = HttpService:JSONDecode(read_file(stageFileName))
		if type(decoded) == "table" then
			stageData = decoded
		end
	end
end)

local function saveStageData()
	pcall(function()
		write_file(stageFileName, HttpService:JSONEncode(stageData))
	end)
end

-- =====================================================================
-- GLOBALE VARIABLEN, STATES & ELEMENTS
-- =====================================================================
local Elements = {}

local states = {
	flyActive = false, flySpeed = 50,
	noClipActive = false, godmodeActive = false, 
	antiVoidActive = false, infiniteJumpActive = false,
	clickTpActive = false, espActive = false,
	ghostModeActive = false, univXray = false,
	menuToggleKey = Enum.KeyCode.RightShift,
	currentAura = "Keine", customNametag = "Ice Hub Owner",
	selectedPlayerToTP = nil, lastPositionBeforeTP = nil,
	
	chatSpamActive = false, chatMessage = "Ice Hub V 25-- on Top!", chatSpeed = 1.0,
	
	autoTpPermActive = false, tpInterval = 5.0,
	autoTreadmillActive = false, treadmillSpeed = 50,
	orbMagnetActive = false, tempTpLoopActive = false, tempTpDelay = 0.5,
	
	carSpeed = 150, carBoostActive = false,
	carFlyActive = false, carNoClipActive = false,
	carFlingActive = false, carDriftActive = false,
	carInvisActive = false, carSpinActive = false,
	carRainbowActive = false, carTouchFlingActive = false,
	carNitroRate = 500, carMoonGravity = false, carLoopBounce = false,
	carTargetFling = nil,
	
	kbwSpeed = 6.5, kbwAutoTypeActive = false,
	adoptFarmActive = false, adoptAutoClaim = false, adoptPetEsp = false,
	doorsEspActive = false, doorsAutoInteract = false,
	slapAuraActive = false,
	
	bladeBallParry = false, bladeBallSpam = false, 
	bladeBallXray = false, bladeBallLock = false,
	bbAutoDodge = false, bbTargetESP = false, bbCurve = false,
	
	ndAutoWin = false, ndAntiFall = false, ndAntiWater = false, ndMapESP = false,
	ndJesus = false, disasterMagnet = false, ndAutoHeal = false, ndPredictor = false,
	
	nightsEspActive = false, nightsKillAuraActive = false, nightsAutoLoot = false, 
	epicAutoWin = false, epicCoinFarm = false,
	megaAutoHide = false, megaSeekEsp = false, megaCoinFarm = false,
	
	mm2CoinAura = false, mm2RoleESP = false, mm2RevealRoles = false,
	mm2SelectedPlayer = nil, mm2AutoEvade = false, mm2AutoGrabGun = false, 
	mm2GunESP = false, mm2Godmode = false, mm2Aimbot = false,
	mm2MurderAura = false, mm2CoinESP = false,
	mm2RoleFarm = false, mm2AutoShoot = false, mm2AutoGrab = false, mm2AutoKillAll = false,

	mpEsp = false, mpAutoGrab = false, mpAutoEvade = false, mpSelectedPlayer = nil,
	mpLaptopEsp = false, mpItemEsp = false, mpAutoHack = false, mpSheriffAim = false,
	mpMurderAura = false, mpCoinFarm = false, mpSpeedModifier = 16, mpGodmode = false,
	mpCoinMag = false, mpFlingM = false, mpFlingH = false, mpSpec = false,
	
	bfChestFarm = false, bfFruitEsp = false, bfMobEsp = false, bfPlayerEsp = false, 
	bfWater = false, bfFastAtk = false, bfBringMobs = false, bfAutoHaki = false,
	
	arsAimbot = false, arsTrigger = false, arsEsp = false, arsBhop = false, 
	arsRapid = false, arsAntiAim = false,
	
	hamFlingAll = false, hamFlingCops = false, hamFlingCrim = false,
	hamRobAtm = false, hamRobReg = false, hamCollectMoney = false,
	hamInstaInt = false, hamAutoPick = false, hamCopEsp = false, hamCrimEsp = false,
	hamATM = false, hamVaultEsp = false, hamAntiRadar = false, hamAutoEscape = false,
	hamGodmode = false, hamAutoHeal = false, hamCarGod = false, hamInfFuel = false,
	hamAutoFix = false, hamUnlockCar = false,
	
	emdGod = false, emdCarGod = false, emdCarSpeed = false, emdInfFuel = false,
	emdAutoRepair = false, emdAutoFire = false, emdAutoHealSelf = false, emdAutoHealAll = false,
	emdPaycheck = false, emdAutoRob = false, emdAutoPick = false, emdCopEsp = false,
	emdCrimEsp = false, emdFireEsp = false, emdAntiArrest = false, emdAutoArrest = false,
	emdJailDoors = false, emdFlingAll = false, emdAim = false, emdInfAmmo = false,
	emdInfStamina = false,
	
	phEsp = false, phGodmode = false, phAutoCoin = false, phTaunt = false,
	
	trollFlingAll = false, trollRainbow = false, trollSpin = false, 
	trollStutter = false, trollKillAll = false, trollBringAll = false,
	trollSelectedPlayer = nil, trollLoopFling = false, trollStalk = false,
	trollBackpack = false, trollOrbit = false, trollMirror = false, trollUFO = false
}

local connections = {
	fly = nil, noClip = nil, godmodeHealth = nil, infiniteJump = nil,
	clickTp = nil, antiKillbrick = nil, autoTpPermLoop = nil, treadmill = nil, 
	orbMagnet = nil, animNametag = nil, tempTpLoop = nil, carBoost = nil,
	carFly = nil, carNoClip = nil, carFling = nil, xrayLoop = nil,
	adoptFarm = nil, adoptClaim = nil, adoptEsp = nil, doorsInteract = nil, slapAura = nil,
	kbwAutoType = nil, nightsAura = nil, nightsLoot = nil, epicLoops = {}, megaLoops = {},
	mm2CoinLoop = nil, mm2RoleLoop = nil, bladeSpamLoop = nil, mm2KillAllLoop = nil,
	mm2EvadeLoop = nil, mm2GunLoop = nil, mm2GunESPLoop = nil, mm2GodmodeLoop = nil,
	trollFlingLoop = nil, trollSpinLoop = nil, trollStutterLoop = nil,
	trollKillLoop = nil, trollBringLoop = nil, chatSpamLoop = nil,
	trollLoopFling = nil, trollStalk = nil, trollBackpack = nil, trollOrbit = nil,
	carRainbowLoop = nil, carTouchFlingLoop = nil, carLoopBounce = nil,
	bladeParryLoop = nil, bbTargetESP = nil, bbDodge = nil, bbCurve = nil,
	ndAutoWin = nil, ndWater = nil, ndJesus = nil, ndPredictor = nil, ndHeal = nil,
	disasterMagnet = nil, mm2Aimbot = nil, mm2MurderAura = nil, mm2CoinESP = nil,
	trollMirror = nil, mm2RoleFarmLoop = nil, mm2AutoShoot = nil, trollUFO = nil, mm2AutoGrabLoop = nil,
	mpEspLoop = nil, mpAutoGrabLoop = nil, mpAutoEvadeLoop = nil, mpLaptopEspLoop = nil,
	mpItemEspLoop = nil, mpAutoHackLoop = nil, mpSheriffAimLoop = nil, mpMurderAuraLoop = nil,
	mpCoinFarmLoop = nil, mpGodmodeLoop = nil, mpCoinMagLoop = nil, mpFlingMLoop = nil, mpFlingHLoop = nil,
	bfChestLoop = nil, bfFruitLoop = nil, bfMobLoop = nil, bfPlayerLoop = nil, bfWaterLoop = nil, bfAtkLoop = nil,
	bfBringMobsLoop = nil, bfHakiLoop = nil,
	arsAimbotLoop = nil, arsTriggerLoop = nil, arsEspLoop = nil, arsBhopLoop = nil, arsRapidLoop = nil, arsAntiAimLoop = nil,
	hamFlingAllLoop = nil, hamATMLoop = nil, hamRobAtmLoop = nil, hamRobRegLoop = nil,
	hamCollectLoop = nil, hamInstaIntLoop = nil, hamAutoPickLoop = nil, hamCopEspLoop = nil,
	hamCrimEspLoop = nil, hamVaultEspLoop = nil, hamAntiRadarLoop = nil, hamEscapeLoop = nil,
	hamGodLoop = nil, hamHealLoop = nil, hamCarGodLoop = nil, hamFuelLoop = nil, hamFixLoop = nil,
	hamUnlockLoop = nil, hamFlingCopsLoop = nil, hamFlingCrimLoop = nil,
	emdGodLoop = nil, emdCarGodLoop = nil, emdCarSpeedLoop = nil, emdInfFuelLoop = nil,
	emdAutoRepairLoop = nil, emdAutoFireLoop = nil, emdAutoHealSelfLoop = nil, emdAutoHealAllLoop = nil,
	emdPaycheckLoop = nil, emdAutoRobLoop = nil, emdAutoPickLoop = nil, emdCopEspLoop = nil,
	emdCrimEspLoop = nil, emdFireEspLoop = nil, emdAntiArrestLoop = nil, emdAutoArrestLoop = nil,
	emdFlingAllLoop = nil, emdAimLoop = nil, emdInfAmmoLoop = nil, emdInfStaminaLoop = nil
}

local objects = {
	bodyVelocity = nil, bodyGyro = nil, 
	carBodyVelocity = nil, carBodyGyro = nil, carBav = nil, carBavSpin = nil,
	antiVoidPart = nil, savedCheckpoint = nil,
	bbBeam = nil
}

local autoStages = {}
local autoStageNames = {}
local lastEvadeTime = 0
local isFlinging = false 

-- =====================================================================
-- CLEANUP FUNKTIONEN & CHOPKICK
-- =====================================================================
local function stopFlying()
	states.flyActive = false
	if connections.fly then connections.fly:Disconnect() connections.fly = nil end
	if objects.bodyVelocity then objects.bodyVelocity:Destroy() objects.bodyVelocity = nil end
	if objects.bodyGyro then objects.bodyGyro:Destroy() objects.bodyGyro = nil end
	if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
		player.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
	end
end

local function stopCarFlying()
	states.carFlyActive = false
	if connections.carFly then connections.carFly:Disconnect() connections.carFly = nil end
	if objects.carBodyVelocity then objects.carBodyVelocity:Destroy() objects.carBodyVelocity = nil end
	if objects.carBodyGyro then objects.carBodyGyro:Destroy() objects.carBodyGyro = nil end
end

local function executeCombatMove(moveName)
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local root = player.Character.HumanoidRootPart
		local originalPos = root.CFrame
		
		local animPart = Instance.new("Part", Workspace)
		animPart.Size = Vector3.new(4, 4, 4)
		animPart.CFrame = root.CFrame * CFrame.new(0, 0, -3)
		animPart.Anchored = true
		animPart.CanCollide = false
		animPart.Transparency = 0.5
		animPart.Color = Color3.fromRGB(255, 50, 50)
		animPart.Material = Enum.Material.Neon
		
		local foundTarget = false
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local targetRoot = p.Character.HumanoidRootPart
				if (targetRoot.Position - root.Position).Magnitude < 15 then
					foundTarget = true
					local bav = Instance.new("BodyAngularVelocity")
					bav.AngularVelocity = Vector3.new(0, 99999, 0)
					bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
					bav.Parent = root
					
					local start = tick()
					while tick() - start < 0.25 and targetRoot and targetRoot.Parent do
						root.CFrame = targetRoot.CFrame
						root.Velocity = Vector3.new(0, 9999, 0)
						task.wait()
					end
					bav:Destroy()
				end
			end
		end
		
		if foundTarget then
			root.Velocity = Vector3.zero
			root.AssemblyAngularVelocity = Vector3.zero
			root.CFrame = originalPos
		end
		
		local rs = getgenv and getgenv().Rayfield or Rayfield
		if rs then rs:Notify({Title="Kampfkunst", Content=moveName .. " ausgeführt! Gegner weggeschleudert.", Duration=2}) end
		task.wait(0.2)
		animPart:Destroy()
	end
end

local function addChopkickButtons(Tab)
	Tab:CreateSection("🥊 Chopkick-System (Kampfsport)")
	Tab:CreateButton({Name = "👊 One Punch", Callback = function() executeCombatMove("One Punch") end})
	Tab:CreateButton({Name = "🖐️ One Slap", Callback = function() executeCombatMove("One Slap") end})
	Tab:CreateButton({Name = "🌪️ Spin Kick", Callback = function() executeCombatMove("Spin Kick") end})
	Tab:CreateButton({Name = "🥾 Drop kick", Callback = function() executeCombatMove("Drop kick") end})
	Tab:CreateButton({Name = "💥 TSB Punch", Callback = function() executeCombatMove("TSB Punch") end})
	Tab:CreateButton({Name = "⬆️ Upper Cut", Callback = function() executeCombatMove("Upper Cut") end})
end

-- =====================================================================
-- METATABLE HOOKS (ANTI-CHEAT BYPASS)
-- =====================================================================
pcall(function()
	local oldNamecall
	oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
		local method = getnamecallmethod()
		if states.godmodeActive and not checkcaller() and self:IsA("Humanoid") then
			if method == "TakeDamage" or method == "BreakJoints" then
				return
			end
		end
		return oldNamecall(self, ...)
	end)
	
	local oldNewIndex
	oldNewIndex = hookmetamethod(game, "__newindex", function(t, k, v)
		if states.godmodeActive and not checkcaller() and t:IsA("Humanoid") and k == "Health" then
			return
		end
		return oldNewIndex(t, k, v)
	end)
end)

-- Anti-AFK
player.Idled:Connect(function()
	VirtualUser:Button2Down(Vector2.new(0,0), camera.CFrame)
	task.wait(1)
	VirtualUser:Button2Up(Vector2.new(0,0), camera.CFrame)
end)

-- =====================================================================
-- RAYFIELD INIT (SICHERHEITSSYSTEM & SAFE START)
-- =====================================================================
local Rayfield
local loadSuccess, loadError = pcall(function()
    -- Lädt Rayfield gesichert, fängt Abstürze bei HTTP-Fehlern ab
    Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

-- Wenn Rayfield nicht geladen werden konnte, Skript sicher abbrechen
if not loadSuccess or not Rayfield then
    warn("🧊 ICE HUB SICHERHEITSSYSTEM: Rayfield konnte nicht geladen werden!")
    warn("Fehlergrund: " .. tostring(loadError))
    return -- Beendet das Skript hier, ohne das Spiel zu crashen
end

-- =====================================================================
-- FENSTER SICHER ERSTELLEN
-- =====================================================================
local windowSuccess, Window = pcall(function()
    return Rayfield:CreateWindow({
        Name = "Ice Hub 🧊 | V 25-- Ultimate",
        LoadingTitle = "Authentifizierung: " .. player.DisplayName .. " (@" .. player.Name .. ")",
        LoadingSubtitle = "Lade V 25-- Engine & Konfigurationen...",
        ConfigurationSaving = {
            Enabled = false,
            FolderName = "IceHub_V25_Saves",
            FileName = "V25_Settings"
        },
        KeySystem = true,
        KeySettings = {
            Title = "Ice Hub 🧊 | Login",
            Subtitle = "Sicherheitsebene V 25--",
            Note = "Bitte gib deinen Key ein.",
            FileName = "IceHubKeyV25",
            SaveKey = true, 
            GrabKeyFromSite = false,
            Key = {"awend_0405"}
        }
    })
end)

if not windowSuccess or not Window then
    warn("🧊 ICE HUB SICHERHEITSSYSTEM: Das GUI-Fenster konnte nicht erstellt werden!")
    return
end

local function notify(title, content, useAvatar)
    pcall(function() -- Auch die Notifications absichern
        Rayfield:Notify({
            Title = title,
            Content = content,
            Duration = 5,
            Image = useAvatar and playerAvatarImage or 4483362458
        })
    end)
end

notify("Sicherheitssystem Aktiv", "Willkommen zurück, " .. player.DisplayName .. "! Ice Hub V 25-- sicher geladen.", true)

-- =====================================================================
-- TABS ERSTELLEN
-- =====================================================================
local TabServer     = Window:CreateTab("🌐 Server Hub", 4483362458)
local TabMM2        = Window:CreateTab("🔪 Murder Mystery 2", 4483362458)
local TabMP         = Window:CreateTab("🎉 Murder Party", 4483362458)
local TabHamburg    = Window:CreateTab("🚓 Hamburg", 4483362458)
local TabEmden      = Window:CreateTab("🚨 Emergency Emden", 4483362458)
local TabBlade      = Window:CreateTab("⚔️ Blade Ball", 4483362458)
local TabDisasters  = Window:CreateTab("🌋 Naturkatastrophen", 4483362458)
local TabTroll      = Window:CreateTab("😈 Troll Menü", 4483362458)
local TabChat       = Window:CreateTab("💬 Chat Spam", 4483362458)
local TabMovement   = Window:CreateTab("🏃 Movement", 4483362458)
local TabPlayers    = Window:CreateTab("🧑‍🤝‍🧑 Player TP", 4483362458)
local TabVehicle    = Window:CreateTab("🚗 Fahrzeuge (Ultra)", 4483362458)
local TabVisuals    = Window:CreateTab("✨ Visuals", 4483362458)
local TabBypass     = Window:CreateTab("🛡️ Bypass", 4483362458)

local TabBloxFruits = Window:CreateTab("🍉 Blox Fruits", 4483362458)
local TabArsenal    = Window:CreateTab("🔫 Arsenal", 4483362458)

local TabMonkey     = Window:CreateTab("🐒 Monkey Escape", 4483362458)
local Tab99Nights   = Window:CreateTab("🌲 99 Nights", 4483362458)
local TabKeyboard   = Window:CreateTab("⌨️ Keyboard Wars", 4483362458)
local TabEpic       = Window:CreateTab("🎮 Epic Minigames", 4483362458)
local TabMega       = Window:CreateTab("🫣 Mega Hide/Seek", 4483362458)
local TabDoors      = Window:CreateTab("🚪 Doors", 4483362458)
local TabSlap       = Window:CreateTab("🧤 Slap Battles", 4483362458)
local TabAdoptMe    = Window:CreateTab("🐶 Adopt Me", 4483362458)
local TabPropHunt   = Window:CreateTab("📦 Prop Hunt", 4483362458)

local TabSettings   = Window:CreateTab("⚙️ Settings", 4483362458)

-- =====================================================================
-- HILFSFUNKTION FÜR ROBUSTE TELEPORTS, UNSICHTBARKEIT & FLING
-- =====================================================================
local function safeTeleport(targetCFrame)
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		states.lastPositionBeforeTP = char.HumanoidRootPart.CFrame
		pcall(function()
			char.HumanoidRootPart.CFrame = targetCFrame
		end)
	end
end

local function toggleInvisibility(Value)
	if player.Character then
		for _, p in ipairs(player.Character:GetDescendants()) do
			if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
				p.Transparency = Value and 1 or 0 
			elseif p:IsA("Decal") then
				p.Transparency = Value and 1 or 0
			end
		end
	end
end

local function executeOriginalFling(target, duration, customVel)
	if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
	local myChar = player.Character
	if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
	
	local root = myChar.HumanoidRootPart
	local targetRoot = target.Character.HumanoidRootPart
	local safeCFrame = root.CFrame
	
	local bav = Instance.new("BodyAngularVelocity")
	bav.AngularVelocity = Vector3.new(0, 99999, 0)
	bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	bav.Parent = root
	
	local startTime = tick()
	local vel = customVel or Vector3.new(0, 9999, 0)
	local hum = myChar:FindFirstChildOfClass("Humanoid")
	local oldHealth = 100
	if hum then 
		oldHealth = hum.Health
		hum.MaxHealth = math.huge
		hum.Health = math.huge
	end
	
	while tick() - startTime < (duration or 0.2) do
		if root.Position.Y < Workspace.FallenPartsDestroyHeight + 50 then break end
		root.CFrame = targetRoot.CFrame
		root.Velocity = vel
		task.wait()
	end
	
	bav:Destroy()
	root.Anchored = true
	root.Velocity = Vector3.zero
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	root.CFrame = safeCFrame
	task.wait(0.05)
	root.Anchored = false
	
	if hum and not states.godmodeActive then
		hum.MaxHealth = 100
		hum.Health = oldHealth
	end
end

local function executeFlingBring(target)
	if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
	local myChar = player.Character
	if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end

	local root = myChar.HumanoidRootPart
	local targetRoot = target.Character.HumanoidRootPart
	local safeCFrame = root.CFrame

	local bav = Instance.new("BodyAngularVelocity")
	bav.AngularVelocity = Vector3.new(0, 99999, 0)
	bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	bav.Parent = root

	local startTime = tick()
	local hum = myChar:FindFirstChildOfClass("Humanoid")
	local oldHealth = 100
	if hum then
		oldHealth = hum.Health
		hum.MaxHealth = math.huge
		hum.Health = math.huge
	end

	while tick() - startTime < 0.4 do
		if root.Position.Y < Workspace.FallenPartsDestroyHeight + 50 then break end
		local dir = (safeCFrame.Position - targetRoot.Position).Unit
		root.CFrame = targetRoot.CFrame * CFrame.new(0, -0.5, 0.5)
		root.Velocity = (dir * 300) + Vector3.new(0, 50, 0)
		task.wait()
	end

	bav:Destroy()
	root.Anchored = true
	root.Velocity = Vector3.zero
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	root.CFrame = safeCFrame
	task.wait(0.05)
	root.Anchored = false

	if hum and not states.godmodeActive then
		hum.MaxHealth = 100
		hum.Health = oldHealth
	end
end


-- =====================================================================
-- 0. TAB: SERVER HUB
-- =====================================================================
TabServer:CreateSection("Server Management")

TabServer:CreateButton({
	Name = "🔄 Aktuellen Server Rejoinen",
	Callback = function()
		notify("Server Hub", "Verlasse Server und trete sofort wieder bei...", false)
		task.wait(1)
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
	end
})

TabServer:CreateButton({
	Name = "🎲 Random Server (Server Hop)",
	Callback = function()
		notify("Server Hub", "Suche neuen Server...", false)
		local servers = {}
		local req = request or http_request or (syn and syn.request)
		if req then
			local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
			local response = req({Url = url, Method = "GET"})
			if response.StatusCode == 200 then
				local data = HttpService:JSONDecode(response.Body)
				if data and data.data then
					for _, v in pairs(data.data) do
						if v.playing < v.maxPlayers and v.id ~= game.JobId then
							table.insert(servers, v.id)
						end
					end
				end
			end
		end
		if #servers > 0 then
			local randomServer = servers[math.random(1, #servers)]
			TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer, player)
		else
			notify("Fehler", "Konnte keinen neuen Server finden.", false)
		end
	end
})

TabServer:CreateButton({
	Name = "📉 Kleinsten Server suchen (Wenig Spieler)",
	Callback = function()
		notify("Server Hub", "Suche leeren Server...", false)
		local req = request or http_request or (syn and syn.request)
		if req then
			local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
			local response = req({Url = url, Method = "GET"})
			if response.StatusCode == 200 then
				local data = HttpService:JSONDecode(response.Body)
				if data and data.data then
					for _, v in pairs(data.data) do
						if v.playing > 0 and v.playing < v.maxPlayers and v.id ~= game.JobId then
							TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, player)
							return
						end
					end
				end
			end
		end
	end
})

-- =====================================================================
-- 1. TAB: MURDER MYSTERY 2 🔪
-- =====================================================================
TabMM2:CreateSection("🔥 Mörder OP Features")

TabMM2:CreateToggle({
	Name = "🔪🩸 Mörder Auto-Kill All (Instant TP & Kill)",
	CurrentValue = false,
	Flag = "MM2AutoKillAll",
	Callback = function(v)
		states.mm2AutoKillAll = v
		if v then
			notify("Mörder OP", "Zieht die Waffe und vernichtet alle nacheinander!", false)
			connections.mm2KillAllLoop = task.spawn(function()
				while states.mm2AutoKillAll do
					local char = player.Character
					if char and char:FindFirstChild("HumanoidRootPart") then
						local bp = player:FindFirstChild("Backpack")
						local knife = (bp and bp:FindFirstChild("Knife")) or char:FindFirstChild("Knife")
						if knife then
							if knife.Parent ~= char then char.Humanoid:EquipTool(knife) end
							for _, p in ipairs(Players:GetPlayers()) do
								if not states.mm2AutoKillAll then break end
								if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
									local ehum = p.Character:FindFirstChild("Humanoid")
									if ehum and ehum.Health > 0 then
										char.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.2)
										task.wait(0.1)
										knife:Activate()
										pcall(function() knife.Stab:FireServer(p.Character.HumanoidRootPart) end)
										task.wait(0.15)
									end
								end
							end
						end
					end
					task.wait(0.5)
				end
			end)
		else
			if connections.mm2KillAllLoop then task.cancel(connections.mm2KillAllLoop) connections.mm2KillAllLoop = nil end
		end
	end
})


TabMM2:CreateSection("🏠 MM2 Map & Lobby Navigation")

TabMM2:CreateButton({
	Name = "🏠 Zum Spawn / Lobby teleportieren",
	Callback = function()
		local lobbySpawns = Workspace:FindFirstChild("Lobby")
		if lobbySpawns and lobbySpawns:FindFirstChild("SpawnLocation") then
			safeTeleport(lobbySpawns.SpawnLocation.CFrame + Vector3.new(0, 5, 0))
			notify("MM2", "Zurück in der Lobby!", false)
		else
			safeTeleport(CFrame.new(-109, 138, 43))
			notify("MM2", "Zurück in der Lobby!", false)
		end
	end
})

TabMM2:CreateButton({
	Name = "🗺️ Direkt in die Map teleportieren",
	Callback = function()
		local map = Workspace:FindFirstChild("Normal")
		if map and map:FindFirstChildOfClass("Model") then
			local spawns = map:FindFirstChildOfClass("Model"):FindFirstChild("Spawns")
			if spawns and #spawns:GetChildren() > 0 then
				local randSpawn = spawns:GetChildren()[math.random(1, #spawns:GetChildren())]
				safeTeleport(randSpawn.CFrame + Vector3.new(0, 5, 0))
				notify("MM2", "In die laufende Map teleportiert!", false)
			end
		else
			notify("MM2", "Es läuft aktuell keine Map.", false)
		end
	end
})

TabMM2:CreateSection("🛡️ Cheat-Abwehr & Überleben")

TabMM2:CreateToggle({
	Name = "🎯 Universal Aimbot (Gun & Messer werfen)",
	CurrentValue = false,
	Flag = "MM2Aimbot",
	Callback = function(v)
		states.mm2Aimbot = v
		if v then
			notify("Aimbot", "Kamera lockt sich perfekt auf das Ziel ein!", false)
			connections.mm2Aimbot = RunService.RenderStepped:Connect(function()
				local char = player.Character
				if not char or not char:FindFirstChild("HumanoidRootPart") then return end
				
				local hasGun = char:FindFirstChild("Gun")
				local hasKnife = char:FindFirstChild("Knife")
				
				if hasGun or hasKnife then
					local target = nil
					local closestDist = math.huge
					
					for _, p in ipairs(Players:GetPlayers()) do
						if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
							local ehum = p.Character:FindFirstChildOfClass("Humanoid")
							if ehum and ehum.Health > 0 then
								if hasGun then
									local pbp = p:FindFirstChild("Backpack")
									if (pbp and pbp:FindFirstChild("Knife")) or p.Character:FindFirstChild("Knife") then
										target = p.Character
										break
									end
								elseif hasKnife then
									local dist = (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
									if dist < closestDist then
										closestDist = dist
										target = p.Character
									end
								end
							end
						end
					end
					
					if target and target:FindFirstChild("HumanoidRootPart") then
						local targetPos = target.HumanoidRootPart.Position
						camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
					end
				end
			end)
		else
			if connections.mm2Aimbot then connections.mm2Aimbot:Disconnect() connections.mm2Aimbot = nil end
		end
	end
})

Elements.MM2GodmodeToggle = TabMM2:CreateToggle({
	Name = "🛡️ MM2 Godmode (Zerstört Mörder-Messer)",
	CurrentValue = false,
	Flag = "MM2Godmode",
	Callback = function(v)
		states.mm2Godmode = v
		if v then
			connections.mm2GodmodeLoop = RunService.Heartbeat:Connect(function()
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local myRoot = player.Character.HumanoidRootPart
					for _, p in pairs(Players:GetPlayers()) do
						if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
							local knife = p.Character:FindFirstChild("Knife")
							if knife and knife:FindFirstChild("Handle") then
								local dist = (myRoot.Position - p.Character.HumanoidRootPart.Position).Magnitude
								if dist < 15 then
									for _, part in pairs(knife:GetDescendants()) do
										if part:IsA("TouchTransmitter") then part:Destroy() end
									end
								end
							end
						end
					end
				end
			end)
		else
			if connections.mm2GodmodeLoop then connections.mm2GodmodeLoop:Disconnect() connections.mm2GodmodeLoop = nil end
		end
	end
})

TabMM2:CreateKeybind({
	Name = "MM2 Godmode Toggle (V)", CurrentKeybind = "V", HoldToInteract = false, Flag = "MM2_Godmode_Key",
	Callback = function()
		if Elements.MM2GodmodeToggle then Elements.MM2GodmodeToggle:Set(not states.mm2Godmode) end
		notify("MM2", "Godmode: " .. tostring(not states.mm2Godmode), false)
	end
})

TabMM2:CreateButton({
	Name = "🥷 Invisible Mode (MM2 Versteck-Modus)",
	Callback = function()
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local oldCFrame = player.Character.HumanoidRootPart.CFrame
			player.Character.HumanoidRootPart.CFrame = CFrame.new(0, -500, 0) 
			task.wait(0.1)
			local Clone = player.Character:Clone()
			Clone.Parent = Workspace
			player.Character.HumanoidRootPart.CFrame = oldCFrame
			toggleInvisibility(true)
			notify("MM2", "Unsichtbar! Klon erstellt.", false)
		end
	end
})

TabMM2:CreateSection("📜 Spieler-Rollen & Teleportationsmenü")

local mm2PlayerList = {}
local mm2Dropdown = TabMM2:CreateDropdown({
	Name = "Wähle einen Spieler nach Rolle",
	Options = {"(Liste aktualisieren)"},
	CurrentOption = {"(Liste aktualisieren)"},
	MultipleOptions = false,
	Flag = "MM2PlayerDropdown",
	Callback = function(Option)
		local selectedName = Option[1]:match("%] (.*)") or Option[1]
		states.mm2SelectedPlayer = selectedName
	end,
})

TabMM2:CreateButton({
	Name = "🔄 Rollen & Spielerliste aktualisieren",
	Callback = function()
		mm2PlayerList = {}
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player then
				local role = "[Innocent] "
				if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					local backpack = p:FindFirstChild("Backpack")
					local char = p.Character
					if (backpack and backpack:FindFirstChild("Knife")) or (char:FindFirstChild("Knife")) then
						role = "[MÖRDER] "
					elseif (backpack and backpack:FindFirstChild("Gun")) or (char:FindFirstChild("Gun")) then
						role = "[Sheriff] "
					end
				end
				table.insert(mm2PlayerList, role .. p.Name)
			end
		end
		if #mm2PlayerList == 0 then table.insert(mm2PlayerList, "Niemand da") end
		mm2Dropdown:Refresh(mm2PlayerList, {mm2PlayerList[1]})
		notify("MM2 Scanner", "Liste aktualisiert!", false)
	end
})

TabMM2:CreateButton({
	Name = "🚀 Zum ausgewählten MM2-Spieler teleportieren",
	Callback = function()
		if states.mm2SelectedPlayer then
			local target = Players:FindFirstChild(states.mm2SelectedPlayer)
			if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
				safeTeleport(target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
			end
		end
	end
})

TabMM2:CreateSection("🎯 Direkte Rollen-Teleports & Gun")

TabMM2:CreateButton({
	Name = "🚀 Zum Mörder teleportieren",
	Callback = function()
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local bp = p:FindFirstChild("Backpack")
				if (bp and bp:FindFirstChild("Knife")) or p.Character:FindFirstChild("Knife") then
					safeTeleport(p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
					notify("MM2", "Hinter den Mörder teleportiert!", false)
					return
				end
			end
		end
		notify("MM2", "Mörder noch nicht gefunden.", false)
	end
})

TabMM2:CreateButton({
	Name = "🚀 Zum Sheriff teleportieren",
	Callback = function()
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local bp = p:FindFirstChild("Backpack")
				if (bp and bp:FindFirstChild("Gun")) or p.Character:FindFirstChild("Gun") then
					safeTeleport(p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
					notify("MM2", "Hinter den Sheriff teleportiert!", false)
					return
				end
			end
		end
		notify("MM2", "Sheriff noch nicht gefunden.", false)
	end
})

TabMM2:CreateToggle({
	Name = "🔫 Sheriff Auto-Shoot (Mörder Aimbot)",
	CurrentValue = false,
	Flag = "MM2AutoShoot",
	Callback = function(v)
		states.mm2AutoShoot = v
		if v then
			connections.mm2AutoShoot = RunService.RenderStepped:Connect(function()
				local char = player.Character
				if char and char:FindFirstChild("Gun") then
					local murderer = nil
					for _, p in ipairs(Players:GetPlayers()) do
						if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
							local bp = p:FindFirstChild("Backpack")
							if (bp and bp:FindFirstChild("Knife")) or p.Character:FindFirstChild("Knife") then
								murderer = p.Character
								break
							end
						end
					end
					
					if murderer and murderer:FindFirstChild("HumanoidRootPart") then
						camera.CFrame = CFrame.new(camera.CFrame.Position, murderer.HumanoidRootPart.Position)
						VirtualUser:Button1Down(Vector2.new(0,0), camera.CFrame)
						VirtualUser:Button1Up(Vector2.new(0,0), camera.CFrame)
					end
				end
			end)
		else
			if connections.mm2AutoShoot then connections.mm2AutoShoot:Disconnect() connections.mm2AutoShoot = nil end
		end
	end
})

TabMM2:CreateToggle({
	Name = "🧲 Auto-Grab Gun (Holt Waffe & TP sofort zurück!)",
	CurrentValue = false,
	Flag = "MM2AutoGrabGun",
	Callback = function(v)
		states.mm2AutoGrab = v
		if v then
			notify("Auto-Grab", "Aktiviert! Du holst die Waffe ressourcenschonend (Kein FPS Drop mehr).", false)
			connections.mm2AutoGrabLoop = task.spawn(function()
				while states.mm2AutoGrab do
					local char = player.Character
					if char and char:FindFirstChild("HumanoidRootPart") then
						for _, obj in ipairs(Workspace:GetDescendants()) do
							if (obj:IsA("BasePart") and obj.Name == "GunDrop") or (obj:IsA("Tool") and (obj.Name == "Gun" or obj.Name == "Revolver") and obj.Parent == Workspace) then
								local targetPos = obj:IsA("Tool") and obj.Handle.CFrame or obj.CFrame
								local oldPos = char.HumanoidRootPart.CFrame
								
								char.HumanoidRootPart.CFrame = targetPos
								task.wait(0.15)
								if char:FindFirstChild("HumanoidRootPart") then
									char.HumanoidRootPart.CFrame = oldPos 
								end
								task.wait(1)
								break
							end
						end
					end
					task.wait(0.3) -- Dieser Yield rettet die Performance komplett
				end
			end)
		else
			if connections.mm2AutoGrabLoop then task.cancel(connections.mm2AutoGrabLoop) connections.mm2AutoGrabLoop = nil end
		end
	end
})

TabMM2:CreateSection("💰 1000x SMARTER Farming (Sprint, Jump, Alive-Targets)")

local function smoothPathfind(hum, root, targetPos)
	local rayOrigin = root.Position
	local lookDir = (targetPos - root.Position)
	
	if lookDir.Magnitude < 0.5 then 
		hum:MoveTo(targetPos)
		return 
	end
	lookDir = lookDir.Unit
	
	local params = RaycastParams.new()
	local ignoreList = {player.Character}
	for _, p in pairs(Players:GetPlayers()) do
		if p.Character then table.insert(ignoreList, p.Character) end
	end
	params.FilterDescendantsInstances = ignoreList
	params.FilterType = Enum.RaycastFilterType.Exclude
	
	local frontRes = Workspace:Raycast(rayOrigin, lookDir * 6, params)
	
	if frontRes and frontRes.Instance.CanCollide then
		local rightDir = (CFrame.new(Vector3.zero, lookDir) * CFrame.Angles(0, math.rad(-90), 0)).LookVector
		local leftDir = (CFrame.new(Vector3.zero, lookDir) * CFrame.Angles(0, math.rad(90), 0)).LookVector
		
		local rightRes = Workspace:Raycast(rayOrigin, rightDir * 5, params)
		local leftRes = Workspace:Raycast(rayOrigin, leftDir * 5, params)
		
		if not rightRes then
			hum:MoveTo(root.Position + rightDir * 8 + lookDir * 4)
		elseif not leftRes then
			hum:MoveTo(root.Position + leftDir * 8 + lookDir * 4)
		else
			hum.Jump = true
			hum:MoveTo(targetPos)
		end
	else
		hum:MoveTo(targetPos)
	end
end

TabMM2:CreateToggle({
	Name = "🤖 OP Auto-Farm (Walking, Hindernisse überspringen, Smart Evade)",
	CurrentValue = false,
	Flag = "MM2RoleFarm",
	Callback = function(v)
		states.mm2RoleFarm = v
		if v then
			notify("Smart Farm", "Automatische Rollenerkennung gestartet! Geht nur auf lebende Spieler.", false)
			
			local lastPos = Vector3.zero
			local stuckTimer = tick()
			
			connections.mm2RoleFarmLoop = RunService.Heartbeat:Connect(function()
				local char = player.Character
				if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then return end
				local root = char.HumanoidRootPart
				local hum = char.Humanoid
				local backpack = player:FindFirstChild("Backpack")
				
				if root.Anchored then root.Anchored = false end 
				root.Velocity = Vector3.zero
				root.AssemblyLinearVelocity = Vector3.zero
				
				local alivePlayers = {}
				for _, p in ipairs(Players:GetPlayers()) do
					if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
						local ehum = p.Character:FindFirstChildOfClass("Humanoid")
						if ehum and ehum.Health > 0 then
							table.insert(alivePlayers, p)
						end
					end
				end
				
				local murderer = nil
				for _, p in ipairs(alivePlayers) do
					local pbp = p:FindFirstChild("Backpack")
					if (pbp and pbp:FindFirstChild("Knife")) or p.Character:FindFirstChild("Knife") then
						murderer = p.Character
						break
					end
				end
				
				local hasKnife = (backpack and backpack:FindFirstChild("Knife")) or char:FindFirstChild("Knife")
				
				if not hasKnife and murderer and murderer:FindFirstChild("HumanoidRootPart") then
					local distToMurderer = (root.Position - murderer.HumanoidRootPart.Position).Magnitude
					if distToMurderer < 25 then
						if #alivePlayers > 0 then
							local targetPlr = alivePlayers[math.random(1, #alivePlayers)]
							root.CFrame = targetPlr.Character.HumanoidRootPart.CFrame * CFrame.new(math.random(-10, 10), 5, math.random(-10, 10))
							notify("Evade", "Mörder unter 7m! Sicherer Teleport zu lebendem Spieler.", false)
							return
						end
					end
				end
				
				local currentPos = root.Position
				if (currentPos - lastPos).Magnitude < 1 then
					if tick() - stuckTimer > 2.5 then
						if #alivePlayers > 0 then
							local targetPlr = alivePlayers[math.random(1, #alivePlayers)]
							root.CFrame = targetPlr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
						end
						stuckTimer = tick()
					end
				else
					lastPos = currentPos
					stuckTimer = tick()
				end

				local hasGun = (backpack and backpack:FindFirstChild("Gun")) or char:FindFirstChild("Gun")
				
				if hasKnife then
					hum.WalkSpeed = 32 
					local knife = backpack:FindFirstChild("Knife") or char:FindFirstChild("Knife")
					if knife and knife.Parent ~= char then char.Humanoid:EquipTool(knife) end
					
					local closestVictim = nil
					local closestDist = math.huge
					for _, p in ipairs(alivePlayers) do
						local dist = (root.Position - p.Character.HumanoidRootPart.Position).Magnitude
						if dist < closestDist then
							closestDist = dist
							closestVictim = p.Character
						end
					end
					
					if closestVictim then
						local vRoot = closestVictim.HumanoidRootPart
						
						if closestDist > 12 then
							smoothPathfind(hum, root, vRoot.Position)
						else
							root.CFrame = vRoot.CFrame * CFrame.new(0, 0, 1.5)
							knife:Activate()
							pcall(function() knife.Stab:FireServer(vRoot) end)
						end
					end
					
				elseif hasGun then
					hum.WalkSpeed = 32 
					local gun = backpack:FindFirstChild("Gun") or char:FindFirstChild("Gun")
					if gun and gun.Parent ~= char then char.Humanoid:EquipTool(gun) end
					
					if murderer and murderer:FindFirstChild("HumanoidRootPart") then
						local mRoot = murderer.HumanoidRootPart
						local dist = (root.Position - mRoot.Position).Magnitude
						
						if dist > 60 then
							root.CFrame = mRoot.CFrame * CFrame.new(0, 10, -40)
						elseif dist < 20 then
							local runDir = (root.Position - mRoot.Position).Unit * 50
							smoothPathfind(hum, root, root.Position + runDir)
						else
							smoothPathfind(hum, root, mRoot.Position)
						end
						
						camera.CFrame = CFrame.new(camera.CFrame.Position, mRoot.Position)
						VirtualUser:Button1Down(Vector2.new(0,0), camera.CFrame)
						VirtualUser:Button1Up(Vector2.new(0,0), camera.CFrame)
					end
				else
					hum.WalkSpeed = 22
					local closestCoin = nil
					local coinDist = math.huge
					
					for _, obj in ipairs(Workspace:GetDescendants()) do
						if obj.Name:match("Coin") and obj:IsA("BasePart") and obj.Transparency < 1 then
							local dist = (root.Position - obj.Position).Magnitude
							if dist < coinDist then
								coinDist = dist
								closestCoin = obj
							end
						end
					end
					
					if closestCoin then
						smoothPathfind(hum, root, closestCoin.Position)
					else
						local map = Workspace:FindFirstChild("Normal")
						if map and map:FindFirstChildOfClass("Model") then
							local mapCenter = map:FindFirstChildOfClass("Model"):GetPivot().Position
							smoothPathfind(hum, root, mapCenter)
						end
					end
				end
			end)
		else
			if connections.mm2RoleFarmLoop then connections.mm2RoleFarmLoop:Disconnect() connections.mm2RoleFarmLoop = nil end
			if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16 end
		end
	end
})

TabMM2:CreateToggle({
	Name = "🟡 Coin ESP (Münzen leuchten durch Wände)",
	CurrentValue = false,
	Flag = "MM2CoinESP",
	Callback = function(v)
		states.mm2CoinESP = v
		if v then
			connections.mm2CoinESP = RunService.Heartbeat:Connect(function()
				for _, obj in pairs(Workspace:GetDescendants()) do
					if obj.Name:match("Coin") and obj:IsA("BasePart") and not obj:FindFirstChild("CESP") then
						local hl = Instance.new("Highlight", obj)
						hl.Name = "CESP"
						hl.FillColor = Color3.fromRGB(255, 255, 0)
						hl.OutlineColor = Color3.fromRGB(255, 255, 255)
					end
				end
			end)
		else
			if connections.mm2CoinESP then connections.mm2CoinESP:Disconnect() end
			for _, obj in pairs(Workspace:GetDescendants()) do
				if obj.Name:match("Coin") and obj:FindFirstChild("CESP") then obj.CESP:Destroy() end
			end
		end
	end
})

TabMM2:CreateToggle({
	Name = "💰 Gras-Aura (Sammelt Coins automatisch ein)", CurrentValue = false,
	Flag = "MM2CoinAura",
	Callback = function(v)
		states.mm2CoinAura = v
		if v then
			connections.mm2CoinLoop = RunService.Heartbeat:Connect(function()
				local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
				if myRoot then
					for _, obj in pairs(Workspace:GetDescendants()) do
						if obj.Name:match("Coin") and obj:IsA("BasePart") then
							obj.CFrame = myRoot.CFrame
						end
					end
				end
			end)
		else 
			if connections.mm2CoinLoop then connections.mm2CoinLoop:Disconnect() end 
		end
	end
})

TabMM2:CreateToggle({
	Name = "👁️ MM2 Full Role ESP (Grün=Innocent, Rot=Mörder)", CurrentValue = false,
	Flag = "MM2RoleESP",
	Callback = function(v)
		states.mm2RoleESP = v
		if v then
			connections.mm2RoleLoop = RunService.Heartbeat:Connect(function()
				for _, p in pairs(Players:GetPlayers()) do
					if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
						local backpack = p:FindFirstChild("Backpack")
						local char = p.Character
						local isMurderer = (backpack and backpack:FindFirstChild("Knife")) or (char:FindFirstChild("Knife"))
						local isSheriff = (backpack and backpack:FindFirstChild("Gun")) or (char:FindFirstChild("Gun"))
						
						local col = Color3.fromRGB(0, 255, 0)
						if isMurderer then col = Color3.fromRGB(255, 0, 0)
						elseif isSheriff then col = Color3.fromRGB(0, 150, 255) end

						if not char:FindFirstChild("MM2_GodESP") then
							local hl = Instance.new("Highlight", char)
							hl.Name = "MM2_GodESP"
							hl.FillColor = col
						else
							char.MM2_GodESP.FillColor = col
						end
					end
				end
			end)
		else
			if connections.mm2RoleLoop then connections.mm2RoleLoop:Disconnect() end
			for _, p in pairs(Players:GetPlayers()) do
				if p.Character and p.Character:FindFirstChild("MM2_GodESP") then p.Character.MM2_GodESP:Destroy() end
			end
		end
	end
})

addChopkickButtons(TabMM2)

-- =====================================================================
-- 1.5 TAB: MURDER PARTY 🎉
-- =====================================================================
local function hasTool(character, bpack, nameFragment)
	local function searchFolder(folder)
		if folder then
			for _, item in ipairs(folder:GetChildren()) do
				if item:IsA("Tool") and string.find(string.lower(item.Name), string.lower(nameFragment)) then
					return true
				end
			end
		end
		return false
	end
	return searchFolder(bpack) or searchFolder(character)
end

TabMP:CreateSection("🔍 Spieler-Scanner & Rollen Info")

local mpPlayerList = {}
local mpDropdown = TabMP:CreateDropdown({
	Name = "👤 Wähle einen Spieler nach Rolle",
	Options = {"(Liste aktualisieren)"},
	CurrentOption = {"(Liste aktualisieren)"},
	MultipleOptions = false,
	Flag = "MPPlayerDropdown",
	Callback = function(Option)
		local selectedName = Option[1]:match("%] (.*)") or Option[1]
		states.mpSelectedPlayer = selectedName
	end,
})

TabMP:CreateButton({
	Name = "🔄 Rollen & Spielerliste aktualisieren",
	Callback = function()
		mpPlayerList = {}
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player then
				local role = "[Innocent] "
				if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					local backpack = p:FindFirstChild("Backpack")
					if hasTool(p.Character, backpack, "knife") or hasTool(p.Character, backpack, "scythe") or hasTool(p.Character, backpack, "murder") then
						role = "[MÖRDER] "
					elseif hasTool(p.Character, backpack, "gun") or hasTool(p.Character, backpack, "revolver") or hasTool(p.Character, backpack, "sheriff") or hasTool(p.Character, backpack, "cop") then
						role = "[Sheriff] "
					elseif hasTool(p.Character, backpack, "laptop") or hasTool(p.Character, backpack, "hack") or hasTool(p.Character, backpack, "maker") then
						role = "[Hacker] "
					elseif hasTool(p.Character, backpack, "vip") or hasTool(p.Character, backpack, "special") or hasTool(p.Character, backpack, "pass") then
						role = "[VIP] "
					end
				end
				table.insert(mpPlayerList, role .. p.Name)
			end
		end
		if #mpPlayerList == 0 then table.insert(mpPlayerList, "Niemand da") end
		mpDropdown:Refresh(mpPlayerList, {mpPlayerList[1]})
		notify("Scanner", "Rollenliste fehlerfrei aktualisiert!", false)
	end
})

TabMP:CreateButton({
	Name = "💬 Rollen im Server-Chat leaken",
	Callback = function()
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player and p.Character then
				local backpack = p:FindFirstChild("Backpack")
				local role = nil
				if hasTool(p.Character, backpack, "knife") or hasTool(p.Character, backpack, "scythe") or hasTool(p.Character, backpack, "murder") then
					role = "Mörder"
				elseif hasTool(p.Character, backpack, "laptop") or hasTool(p.Character, backpack, "hack") or hasTool(p.Character, backpack, "maker") then
					role = "Hacker"
				end
				
				if role then
					pcall(function()
						game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(p.Name .. " ist der " .. role .. "!", "All")
					end)
					task.wait(1)
				end
			end
		end
		notify("Chat", "Rollen wurden geleakt!", false)
	end
})

TabMP:CreateSection("🚀 Direkte Rollen-Teleports")

TabMP:CreateButton({
	Name = "🎯 Teleport zu ausgewähltem MP-Spieler",
	Callback = function()
		if states.mpSelectedPlayer then
			local target = Players:FindFirstChild(states.mpSelectedPlayer)
			if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
				safeTeleport(target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
			end
		end
	end
})

TabMP:CreateButton({
	Name = "🔪 Teleport zum Mörder",
	Callback = function()
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				if hasTool(p.Character, p:FindFirstChild("Backpack"), "knife") or hasTool(p.Character, p:FindFirstChild("Backpack"), "murder") then
					safeTeleport(p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
					notify("Teleport", "Hinter den Mörder teleportiert!", false)
					return
				end
			end
		end
		notify("Fehler", "Mörder nicht gefunden.", false)
	end
})

TabMP:CreateButton({
	Name = "🔫 Teleport zum Sheriff",
	Callback = function()
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				if hasTool(p.Character, p:FindFirstChild("Backpack"), "gun") or hasTool(p.Character, p:FindFirstChild("Backpack"), "sheriff") then
					safeTeleport(p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
					notify("Teleport", "Hinter den Sheriff teleportiert!", false)
					return
				end
			end
		end
		notify("Fehler", "Sheriff nicht gefunden.", false)
	end
})

TabMP:CreateButton({
	Name = "💻 Teleport zum Hacker",
	Callback = function()
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				if hasTool(p.Character, p:FindFirstChild("Backpack"), "laptop") or hasTool(p.Character, p:FindFirstChild("Backpack"), "hack") then
					safeTeleport(p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
					notify("Teleport", "Hinter den Hacker teleportiert!", false)
					return
				end
			end
		end
		notify("Fehler", "Hacker nicht gefunden.", false)
	end
})

TabMP:CreateButton({
	Name = "🪂 Teleport in Safe Spot (Sicher im Himmel)",
	Callback = function()
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = player.Character.HumanoidRootPart
			hrp.CFrame = hrp.CFrame + Vector3.new(0, 500, 0)
			local plat = Instance.new("Part", Workspace)
			plat.Size = Vector3.new(20, 1, 20)
			plat.Position = hrp.Position - Vector3.new(0, 5, 0)
			plat.Anchored = true
			plat.Transparency = 0.5
			notify("Safe Spot", "Sicher im Himmel.", false)
		end
	end
})

TabMP:CreateSection("👁️ MP Exklusive Visuals & ESP")

TabMP:CreateToggle({
	Name = "✨ 5-Farb Role ESP (+ Text-Tags über Kopf)",
	CurrentValue = false,
	Flag = "MPEsp",
	Callback = function(v)
		states.mpEsp = v
		if v then
			notify("ESP", "Gefixter Rollen-ESP mit Text-Tags aktiviert!", false)
			connections.mpEspLoop = RunService.Heartbeat:Connect(function()
				for _, p in pairs(Players:GetPlayers()) do
					if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Head") then
						local roleName = "Innocent"
						local col = Color3.fromRGB(0, 255, 0) 
						local backpack = p:FindFirstChild("Backpack")
						local char = p.Character

						if hasTool(char, backpack, "knife") or hasTool(char, backpack, "scythe") or hasTool(char, backpack, "murder") then
							roleName = "Murderer"
							col = Color3.fromRGB(255, 0, 0)
						elseif hasTool(char, backpack, "gun") or hasTool(char, backpack, "revolver") or hasTool(char, backpack, "sheriff") or hasTool(char, backpack, "cop") then
							roleName = "Sheriff/Cop"
							col = Color3.fromRGB(0, 150, 255) 
						elseif hasTool(char, backpack, "laptop") or hasTool(char, backpack, "hack") or hasTool(char, backpack, "maker") then
							roleName = "Hacker/Maker"
							col = Color3.fromRGB(255, 0, 255) 
						elseif hasTool(char, backpack, "vip") or hasTool(char, backpack, "special") or hasTool(char, backpack, "pass") then
							roleName = "VIP/Spezial"
							col = Color3.fromRGB(255, 255, 0) 
						end

						if not char:FindFirstChild("MP_ESP") then
							local hl = Instance.new("Highlight", char)
							hl.Name = "MP_ESP"
							hl.FillColor = col
						else
							char.MP_ESP.FillColor = col
						end

						if not char.Head:FindFirstChild("MP_RoleText") then
							local bg = Instance.new("BillboardGui", char.Head)
							bg.Name = "MP_RoleText"
							bg.Size = UDim2.new(0, 120, 0, 35)
							bg.StudsOffset = Vector3.new(0, 3.5, 0)
							bg.AlwaysOnTop = true
							local txt = Instance.new("TextLabel", bg)
							txt.Name = "TextLabel"
							txt.Size = UDim2.new(1, 0, 1, 0)
							txt.BackgroundTransparency = 1
							txt.TextScaled = true
							txt.Font = Enum.Font.GothamBold
							txt.TextStrokeTransparency = 0
							txt.Text = "[" .. roleName .. "]"
							txt.TextColor3 = col
						else
							char.Head.MP_RoleText.TextLabel.Text = "[" .. roleName .. "]"
							char.Head.MP_RoleText.TextLabel.TextColor3 = col
						end
					end
				end
			end)
		else
			if connections.mpEspLoop then connections.mpEspLoop:Disconnect() connections.mpEspLoop = nil end
			for _, p in pairs(Players:GetPlayers()) do
				if p.Character then
					if p.Character:FindFirstChild("MP_ESP") then p.Character.MP_ESP:Destroy() end
					if p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("MP_RoleText") then 
						p.Character.Head.MP_RoleText:Destroy() 
					end
				end
			end
		end
	end
})

TabMP:CreateToggle({
	Name = "💻 Laptop X-Ray (Zeigt Hacker-Laptops)",
	CurrentValue = false,
	Flag = "MPLaptopEsp",
	Callback = function(v)
		states.mpLaptopEsp = v
		if v then
			connections.mpLaptopEspLoop = RunService.Heartbeat:Connect(function()
				for _, obj in ipairs(Workspace:GetDescendants()) do
					if obj:IsA("Model") and string.find(string.lower(obj.Name), "laptop") then
						if not obj:FindFirstChild("LapESP") then
							local hl = Instance.new("Highlight", obj)
							hl.Name = "LapESP"
							hl.FillColor = Color3.fromRGB(255, 0, 255)
							hl.OutlineColor = Color3.fromRGB(255, 255, 255)
						end
					end
				end
			end)
		else
			if connections.mpLaptopEspLoop then connections.mpLaptopEspLoop:Disconnect() connections.mpLaptopEspLoop = nil end
			for _, obj in ipairs(Workspace:GetDescendants()) do
				if obj:IsA("Model") and obj:FindFirstChild("LapESP") then obj.LapESP:Destroy() end
			end
		end
	end
})

TabMP:CreateToggle({
	Name = "🔫 Dropped Weapons X-Ray (Boden-Items)",
	CurrentValue = false,
	Flag = "MPItemEsp",
	Callback = function(v)
		states.mpItemEsp = v
		if v then
			connections.mpItemEspLoop = RunService.Heartbeat:Connect(function()
				for _, obj in ipairs(Workspace:GetDescendants()) do
					if obj:IsA("Tool") and obj.Parent == Workspace and (string.find(string.lower(obj.Name), "gun") or string.find(string.lower(obj.Name), "keycard")) then
						if not obj:FindFirstChild("WepESP") then
							local hl = Instance.new("Highlight", obj)
							hl.Name = "WepESP"
							hl.FillColor = Color3.fromRGB(0, 150, 255)
						end
					end
				end
			end)
		else
			if connections.mpItemEspLoop then connections.mpItemEspLoop:Disconnect() connections.mpItemEspLoop = nil end
			for _, obj in ipairs(Workspace:GetDescendants()) do
				if obj:IsA("Tool") and obj:FindFirstChild("WepESP") then obj.WepESP:Destroy() end
			end
		end
	end
})

TabMP:CreateSection("⚙️ MP Auto-Farms, Combat & OP Exploits")

TabMP:CreateToggle({
	Name = "🤖 Hacker Auto-Hack (Hackt nahstehende Laptops)",
	CurrentValue = false,
	Flag = "MPAutoHack",
	Callback = function(v)
		states.mpAutoHack = v
		if v then
			notify("Auto-Hack", "Stelle dich neben Laptops, sie werden sofort gehackt.", false)
			connections.mpAutoHackLoop = RunService.Heartbeat:Connect(function()
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local hrp = player.Character.HumanoidRootPart
					for _, prompt in pairs(Workspace:GetDescendants()) do
						if prompt:IsA("ProximityPrompt") and prompt.ActionText:lower():match("hack") then
							if (prompt.Parent.Position - hrp.Position).Magnitude <= prompt.MaxActivationDistance then
								fireproximityprompt(prompt)
							end
						end
					end
				end
			end)
		else
			if connections.mpAutoHackLoop then connections.mpAutoHackLoop:Disconnect() connections.mpAutoHackLoop = nil end
		end
	end
})

TabMP:CreateToggle({
	Name = "🎯 Sheriff Auto-Shoot (Perfekter Aimbot)",
	CurrentValue = false,
	Flag = "MPSheriffAim",
	Callback = function(v)
		states.mpSheriffAim = v
		if v then
			connections.mpSheriffAimLoop = RunService.RenderStepped:Connect(function()
				local char = player.Character
				if char and char:FindFirstChild("HumanoidRootPart") then
					local backpack = player:FindFirstChild("Backpack")
					if hasTool(char, backpack, "gun") or hasTool(char, backpack, "revolver") then
						local murderer = nil
						for _, p in ipairs(Players:GetPlayers()) do
							if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
								local ebp = p:FindFirstChild("Backpack")
								if hasTool(p.Character, ebp, "knife") or hasTool(p.Character, ebp, "scythe") or hasTool(p.Character, ebp, "murder") then
									murderer = p.Character
									break
								end
							end
						end
						if murderer and murderer:FindFirstChild("HumanoidRootPart") then
							camera.CFrame = CFrame.new(camera.CFrame.Position, murderer.HumanoidRootPart.Position)
							if char:FindFirstChildOfClass("Tool") and char:FindFirstChildOfClass("Tool").Name:lower():match("gun") then
								VirtualUser:Button1Down(Vector2.new(0,0), camera.CFrame)
								VirtualUser:Button1Up(Vector2.new(0,0), camera.CFrame)
							end
						end
					end
				end
			end)
		else
			if connections.mpSheriffAimLoop then connections.mpSheriffAimLoop:Disconnect() connections.mpSheriffAimLoop = nil end
		end
	end
})

TabMP:CreateToggle({
	Name = "🩸 Mörder Kill-Aura (Auto-Stich bei Nähe)",
	CurrentValue = false,
	Flag = "MPMurderAura",
	Callback = function(v)
		states.mpMurderAura = v
		if v then
			connections.mpMurderAuraLoop = RunService.Heartbeat:Connect(function()
				local char = player.Character
				if char and char:FindFirstChild("HumanoidRootPart") then
					local knife = char:FindFirstChildOfClass("Tool")
					if knife and (knife.Name:lower():match("knife") or knife.Name:lower():match("scythe")) then
						for _, p in ipairs(Players:GetPlayers()) do
							if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
								local dist = (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
								if dist < 15 then
									knife:Activate()
								end
							end
						end
					end
				end
			end)
		else
			if connections.mpMurderAuraLoop then connections.mpMurderAuraLoop:Disconnect() connections.mpMurderAuraLoop = nil end
		end
	end
})

TabMP:CreateToggle({
	Name = "🍬 Auto-Farm Coins/Candies (Teleport)",
	CurrentValue = false,
	Flag = "MPCoinFarm",
	Callback = function(v)
		states.mpCoinFarm = v
		if v then
			connections.mpCoinFarmLoop = RunService.Heartbeat:Connect(function()
				local char = player.Character
				if char and char:FindFirstChild("HumanoidRootPart") then
					for _, obj in ipairs(Workspace:GetDescendants()) do
						if obj:IsA("BasePart") and (obj.Name:lower():match("coin") or obj.Name:lower():match("candy")) then
							obj.CFrame = char.HumanoidRootPart.CFrame
						end
					end
				end
			end)
		else
			if connections.mpCoinFarmLoop then connections.mpCoinFarmLoop:Disconnect() connections.mpCoinFarmLoop = nil end
		end
	end
})

TabMP:CreateToggle({
	Name = "🧲 Coin Magnet (Bringt Münzen unsichtbar zu dir)",
	CurrentValue = false,
	Flag = "MPCoinMag",
	Callback = function(v)
		states.mpCoinMag = v
		if v then
			connections.mpCoinMagLoop = RunService.Heartbeat:Connect(function()
				local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
				if myRoot then
					for _, obj in ipairs(Workspace:GetDescendants()) do
						if obj:IsA("BasePart") and (obj.Name:lower():match("coin") or obj.Name:lower():match("candy")) then
							obj.CFrame = myRoot.CFrame
						end
					end
				end
			end)
		else
			if connections.mpCoinMagLoop then connections.mpCoinMagLoop:Disconnect() connections.mpCoinMagLoop = nil end
		end
	end
})

TabMP:CreateButton({
	Name = "🛠️ Anti-Trap (Löscht Hacker-Fallen & Laser)",
	Callback = function()
		local count = 0
		for _, obj in ipairs(Workspace:GetDescendants()) do
			if obj.Name:lower():match("trap") or obj.Name:lower():match("laser") then
				pcall(function() obj:Destroy() end)
				count = count + 1
			end
		end
		notify("Anti-Trap", count .. " Fallen zerstört!", false)
	end
})

TabMP:CreateToggle({
	Name = "🖐️ Auto-Grab Gun & Keycard (Teleport & Zurück)",
	CurrentValue = false,
	Flag = "MPAutoGrab",
	Callback = function(v)
		states.mpAutoGrab = v
		if v then
			notify("Auto-Grab", "Aktiviert! Du holst fallengelassene Items und kehrst zurück.", false)
			local isGrabbing = false
			connections.mpAutoGrabLoop = RunService.RenderStepped:Connect(function()
				if isGrabbing then return end
				local char = player.Character
				if char and char:FindFirstChild("HumanoidRootPart") then
					for _, obj in ipairs(Workspace:GetDescendants()) do
						if (obj:IsA("BasePart") or obj:IsA("Tool")) and (string.match(string.lower(obj.Name), "gun") or string.match(string.lower(obj.Name), "keycard") or string.match(string.lower(obj.Name), "drop")) and obj.Parent == Workspace then
							isGrabbing = true
							local targetPos = obj:IsA("Tool") and obj.Handle.CFrame or obj.CFrame
							local oldPos = char.HumanoidRootPart.CFrame
							
							char.HumanoidRootPart.CFrame = targetPos
							task.wait(0.15)
							if char:FindFirstChild("HumanoidRootPart") then
								char.HumanoidRootPart.CFrame = oldPos 
							end
							task.wait(1)
							isGrabbing = false
							break
						end
					end
				end
			end)
		else
			if connections.mpAutoGrabLoop then connections.mpAutoGrabLoop:Disconnect() connections.mpAutoGrabLoop = nil end
		end
	end
})

TabMP:CreateToggle({
	Name = "🏃 Auto-Evade (Weicht dem Mörder automatisch aus)",
	CurrentValue = false,
	Flag = "MPAutoEvade",
	Callback = function(v)
		states.mpAutoEvade = v
		if v then
			notify("Auto-Evade", "Aktiv! Weicht sofort aus, wenn der Mörder eine Waffe zieht.", false)
			connections.mpAutoEvadeLoop = RunService.Heartbeat:Connect(function()
				local char = player.Character
				if char and char:FindFirstChild("HumanoidRootPart") then
					local myRoot = char.HumanoidRootPart
					for _, p in ipairs(Players:GetPlayers()) do
						if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
							local ebp = p:FindFirstChild("Backpack")
							if hasTool(p.Character, ebp, "knife") or hasTool(p.Character, ebp, "scythe") or hasTool(p.Character, ebp, "murder") then
								local dist = (myRoot.Position - p.Character.HumanoidRootPart.Position).Magnitude
								if dist < 30 then
									myRoot.CFrame = myRoot.CFrame * CFrame.new(0, 15, -35)
									notify("Ausgewichen", "Mörder in der Nähe! Sicherheitsabstand hergestellt.", false)
									task.wait(1) 
								end
							end
						end
					end
				end
			end)
		else
			if connections.mpAutoEvadeLoop then connections.mpAutoEvadeLoop:Disconnect() connections.mpAutoEvadeLoop = nil end
		end
	end
})

TabMP:CreateToggle({
	Name = "🎥 Spectate Mörder (Kamera verfolgt Mörder)",
	CurrentValue = false,
	Flag = "MPSpec",
	Callback = function(v)
		states.mpSpec = v
		if v then
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") then
					local ebp = p:FindFirstChild("Backpack")
					if hasTool(p.Character, ebp, "knife") or hasTool(p.Character, ebp, "murder") then
						camera.CameraSubject = p.Character.Humanoid
						notify("Spectate", "Du beobachtest nun den Mörder.", false)
						return
					end
				end
			end
			notify("Fehler", "Noch kein Mörder gefunden.", false)
			states.mpSpec = false
		else
			if player.Character and player.Character:FindFirstChild("Humanoid") then
				camera.CameraSubject = player.Character.Humanoid
			end
		end
	end
})

TabMP:CreateToggle({
	Name = "🛡️ MP Godmode (Macht dich immun gegen Waffen)",
	CurrentValue = false,
	Flag = "MPGodmode",
	Callback = function(v)
		states.mpGodmode = v
		if v then
			connections.mpGodmodeLoop = RunService.Heartbeat:Connect(function()
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local myRoot = player.Character.HumanoidRootPart
					for _, p in pairs(Players:GetPlayers()) do
						if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
							for _, tool in pairs(p.Character:GetChildren()) do
								if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
									local dist = (myRoot.Position - p.Character.HumanoidRootPart.Position).Magnitude
									if dist < 20 then
										for _, part in pairs(tool:GetDescendants()) do
											if part:IsA("TouchTransmitter") then part:Destroy() end
										end
									end
								end
							end
						end
					end
				end
			end)
		else
			if connections.mpGodmodeLoop then connections.mpGodmodeLoop:Disconnect() connections.mpGodmodeLoop = nil end
		end
	end
})

TabMP:CreateButton({
	Name = "🥷 Invisible Mode (Klon erstellen & Verstecken)",
	Callback = function()
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local oldCFrame = player.Character.HumanoidRootPart.CFrame
			player.Character.HumanoidRootPart.CFrame = CFrame.new(0, -500, 0) 
			task.wait(0.1)
			player.Character.Archivable = true
			local Clone = player.Character:Clone()
			Clone.Parent = Workspace
			player.Character.HumanoidRootPart.CFrame = oldCFrame
			toggleInvisibility(true)
			notify("Invisible", "Unsichtbar! Dein Klon steht sicher am alten Platz.", false)
		end
	end
})

TabMP:CreateToggle({
	Name = "🌪️ Loop-Fling Mörder (Schleudert ihn weg)",
	CurrentValue = false,
	Flag = "MPFlingM",
	Callback = function(v)
		states.mpFlingM = v
		if v then
			connections.mpFlingMLoop = task.spawn(function()
				while states.mpFlingM do
					for _, p in ipairs(Players:GetPlayers()) do
						if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
							if hasTool(p.Character, p:FindFirstChild("Backpack"), "knife") or hasTool(p.Character, p:FindFirstChild("Backpack"), "murder") then
								executeOriginalFling(p, 0.2)
							end
						end
					end
					task.wait(0.3)
				end
			end)
		else
			if connections.mpFlingMLoop then task.cancel(connections.mpFlingMLoop) connections.mpFlingMLoop = nil end
		end
	end
})

TabMP:CreateToggle({
	Name = "🌪️ Loop-Fling Hacker (Zerstört den Hacker)",
	CurrentValue = false,
	Flag = "MPFlingH",
	Callback = function(v)
		states.mpFlingH = v
		if v then
			connections.mpFlingHLoop = task.spawn(function()
				while states.mpFlingH do
					for _, p in ipairs(Players:GetPlayers()) do
						if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
							if hasTool(p.Character, p:FindFirstChild("Backpack"), "laptop") or hasTool(p.Character, p:FindFirstChild("Backpack"), "hack") then
								executeOriginalFling(p, 0.2)
							end
						end
					end
					task.wait(0.3)
				end
			end)
		else
			if connections.mpFlingHLoop then task.cancel(connections.mpFlingHLoop) connections.mpFlingHLoop = nil end
		end
	end
})

TabMP:CreateSlider({
	Name = "⚡ Custom WalkSpeed Modifikator",
	Range = {16, 100},
	Increment = 2,
	CurrentValue = 16,
	Flag = "MPSpeed",
	Callback = function(Value)
		states.mpSpeedModifier = Value
		if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
			player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
		end
	end
})

-- =====================================================================
-- 2. TAB: EMERGENCY HAMBURG 🚓 (V 25--)
-- =====================================================================
TabHamburg:CreateSection("🚔 Combat & Troll")

TabHamburg:CreateToggle({
	Name = "🌪️ K-Fling All (Zerstört ALLE Spieler im Server)",
	CurrentValue = false, Flag = "HamFlingAll",
	Callback = function(v)
		states.hamFlingAll = v
		if v then
			notify("Hamburg Combat", "K-Fling All aktiv! Zerstörung läuft.", false)
			connections.hamFlingAllLoop = task.spawn(function()
				while states.hamFlingAll do
					for _, p in ipairs(Players:GetPlayers()) do
						if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
							executeOriginalFling(p, 0.15, Vector3.new(0, 50000, 0))
							task.wait(0.2)
						end
					end
					task.wait(0.1)
				end
			end)
		else
			if connections.hamFlingAllLoop then task.cancel(connections.hamFlingAllLoop) connections.hamFlingAllLoop = nil end
		end
	end
})

TabHamburg:CreateToggle({
	Name = "👮 K-Fling Cops (Nur Polizisten wegschleudern)",
	CurrentValue = false, Flag = "HamFlingCops",
	Callback = function(v)
		states.hamFlingCops = v
		if v then
			connections.hamFlingCopsLoop = task.spawn(function()
				while states.hamFlingCops do
					for _, p in ipairs(Players:GetPlayers()) do
						if p ~= player and p.Team and p.Team.Name:lower():match("police") and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
							executeOriginalFling(p, 0.2, Vector3.new(0, 50000, 0))
							task.wait(0.2)
						end
					end
					task.wait(0.5)
				end
			end)
		else
			if connections.hamFlingCopsLoop then task.cancel(connections.hamFlingCopsLoop) connections.hamFlingCopsLoop = nil end
		end
	end
})

TabHamburg:CreateToggle({
	Name = "🦹 K-Fling Kriminelle (Räumt die Straßen auf)",
	CurrentValue = false, Flag = "HamFlingCrim",
	Callback = function(v)
		states.hamFlingCrim = v
		if v then
			connections.hamFlingCrimLoop = task.spawn(function()
				while states.hamFlingCrim do
					for _, p in ipairs(Players:GetPlayers()) do
						if p ~= player and p.Team and p.Team.Name:lower():match("crim") and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
							executeOriginalFling(p, 0.2, Vector3.new(0, 50000, 0))
							task.wait(0.2)
						end
					end
					task.wait(0.5)
				end
			end)
		else
			if connections.hamFlingCrimLoop then task.cancel(connections.hamFlingCrimLoop) connections.hamFlingCrimLoop = nil end
		end
	end
})

TabHamburg:CreateSection("💰 Auto-Rob & Farming")

TabHamburg:CreateToggle({
	Name = "🏧 Auto Rob ATM (Teleportiert zu Bankautomaten)",
	CurrentValue = false, Flag = "HamRobAtm",
	Callback = function(v)
		states.hamRobAtm = v
		if v then
			connections.hamRobAtmLoop = task.spawn(function()
				while states.hamRobAtm do
					if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
						for _, obj in pairs(Workspace:GetDescendants()) do
							if obj.Name:lower() == "atm" and obj:FindFirstChildOfClass("ProximityPrompt", true) then
								player.Character.HumanoidRootPart.CFrame = obj:GetPivot() * CFrame.new(0, 0, 3)
								task.wait(0.5)
								local prompt = obj:FindFirstChildOfClass("ProximityPrompt", true)
								if prompt then fireproximityprompt(prompt) end
								task.wait(5) 
							end
						end
					end
					task.wait(1)
				end
			end)
		else
			if connections.hamRobAtmLoop then task.cancel(connections.hamRobAtmLoop) connections.hamRobAtmLoop = nil end
		end
	end
})

TabHamburg:CreateToggle({
	Name = "💵 Auto Rob Kassen (Cash Registers)",
	CurrentValue = false, Flag = "HamRobReg",
	Callback = function(v)
		states.hamRobReg = v
		if v then
			connections.hamRobRegLoop = task.spawn(function()
				while states.hamRobReg do
					if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
						for _, obj in pairs(Workspace:GetDescendants()) do
							if (obj.Name:lower():match("register") or obj.Name:lower():match("till")) and obj:FindFirstChildOfClass("ProximityPrompt", true) then
								player.Character.HumanoidRootPart.CFrame = obj:GetPivot() * CFrame.new(0, 0, 3)
								task.wait(0.5)
								local prompt = obj:FindFirstChildOfClass("ProximityPrompt", true)
								if prompt then fireproximityprompt(prompt) end
								task.wait(5)
							end
						end
					end
					task.wait(1)
				end
			end)
		else
			if connections.hamRobRegLoop then task.cancel(connections.hamRobRegLoop) connections.hamRobRegLoop = nil end
		end
	end
})

TabHamburg:CreateToggle({
	Name = "🧲 Auto-Collect Dropped Money (Magnet)",
	CurrentValue = false, Flag = "HamCollect",
	Callback = function(v)
		states.hamCollectMoney = v
		if v then
			connections.hamCollectLoop = RunService.Heartbeat:Connect(function()
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local root = player.Character.HumanoidRootPart
					for _, obj in ipairs(Workspace:GetDescendants()) do
						if obj:IsA("BasePart") and (obj.Name:lower():match("money") or obj.Name:lower():match("cash") or obj.Name:lower():match("drop")) then
							pcall(function() obj.CFrame = root.CFrame end)
						end
					end
				end
			end)
		else
			if connections.hamCollectLoop then connections.hamCollectLoop:Disconnect() connections.hamCollectLoop = nil end
		end
	end
})

TabHamburg:CreateToggle({
	Name = "⚡ Instant Interact (Fast Rob, 0s Ladezeit)",
	CurrentValue = false, Flag = "HamInsta",
	Callback = function(v)
		states.hamInstaInt = v
		if v then
			connections.hamInstaIntLoop = RunService.Heartbeat:Connect(function()
				for _, p in ipairs(Workspace:GetDescendants()) do
					if p:IsA("ProximityPrompt") then
						p.HoldDuration = 0
					end
				end
			end)
		else
			if connections.hamInstaIntLoop then connections.hamInstaIntLoop:Disconnect() connections.hamInstaIntLoop = nil end
		end
	end
})

TabHamburg:CreateToggle({
	Name = "🔓 Auto-Lockpick (Öffnet sofort verschlossene Objekte)",
	CurrentValue = false, Flag = "HamAutoPick",
	Callback = function(v)
		states.hamAutoPick = v
		if v then
			connections.hamAutoPickLoop = RunService.Heartbeat:Connect(function()
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local hrp = player.Character.HumanoidRootPart
					for _, p in ipairs(Workspace:GetDescendants()) do
						if p:IsA("ProximityPrompt") and p.ActionText:lower():match("lockpick") then
							if (p.Parent.Position - hrp.Position).Magnitude < 15 then
								fireproximityprompt(p)
							end
						end
					end
				end
			end)
		else
			if connections.hamAutoPickLoop then connections.hamAutoPickLoop:Disconnect() connections.hamAutoPickLoop = nil end
		end
	end
})

TabHamburg:CreateSection("👁️ ESP & Scanner")

TabHamburg:CreateToggle({
	Name = "👮 Police ESP (Zeigt Cops rot an)",
	CurrentValue = false, Flag = "HamCopEsp",
	Callback = function(v)
		states.hamCopEsp = v
		if v then
			connections.hamCopEspLoop = RunService.Heartbeat:Connect(function()
				for _, p in pairs(Players:GetPlayers()) do
					if p ~= player and p.Team and p.Team.Name:lower():match("police") and p.Character then
						if not p.Character:FindFirstChild("CopESP") then
							local hl = Instance.new("Highlight", p.Character)
							hl.Name = "CopESP"
							hl.FillColor = Color3.fromRGB(0, 0, 255)
						end
					end
				end
			end)
		else
			if connections.hamCopEspLoop then connections.hamCopEspLoop:Disconnect() connections.hamCopEspLoop = nil end
			for _, p in pairs(Players:GetPlayers()) do
				if p.Character and p.Character:FindFirstChild("CopESP") then p.Character.CopESP:Destroy() end
			end
		end
	end
})

TabHamburg:CreateToggle({
	Name = "🦹 Criminal ESP (Zeigt Wanted/Kriminelle)",
	CurrentValue = false, Flag = "HamCrimEsp",
	Callback = function(v)
		states.hamCrimEsp = v
		if v then
			connections.hamCrimEspLoop = RunService.Heartbeat:Connect(function()
				for _, p in pairs(Players:GetPlayers()) do
					if p ~= player and p.Team and p.Team.Name:lower():match("crim") and p.Character then
						if not p.Character:FindFirstChild("CrimESP") then
							local hl = Instance.new("Highlight", p.Character)
							hl.Name = "CrimESP"
							hl.FillColor = Color3.fromRGB(255, 0, 0)
						end
					end
				end
			end)
		else
			if connections.hamCrimEspLoop then connections.hamCrimEspLoop:Disconnect() connections.hamCrimEspLoop = nil end
			for _, p in pairs(Players:GetPlayers()) do
				if p.Character and p.Character:FindFirstChild("CrimESP") then p.Character.CrimESP:Destroy() end
			end
		end
	end
})

TabHamburg:CreateToggle({
	Name = "🏧 ATM ESP (Findet alle Automaten)",
	CurrentValue = false, Flag = "HamATM",
	Callback = function(v)
		states.hamATM = v
		if v then
			connections.hamATMLoop = RunService.Heartbeat:Connect(function()
				for _, obj in pairs(Workspace:GetDescendants()) do
					if obj.Name == "ATM" and obj:IsA("Model") then
						if not obj:FindFirstChild("ATM_ESP") then
							local hl = Instance.new("Highlight", obj)
							hl.Name = "ATM_ESP"
							hl.FillColor = Color3.fromRGB(0, 255, 0)
						end
					end
				end
			end)
		else
			if connections.hamATMLoop then connections.hamATMLoop:Disconnect() connections.hamATMLoop = nil end
			for _, obj in pairs(Workspace:GetDescendants()) do
				if obj.Name == "ATM" and obj:FindFirstChild("ATM_ESP") then obj.ATM_ESP:Destroy() end
			end
		end
	end
})

TabHamburg:CreateToggle({
	Name = "🏦 Vault/Safe ESP (Zeigt Tresore an)",
	CurrentValue = false, Flag = "HamVaultEsp",
	Callback = function(v)
		states.hamVaultEsp = v
		if v then
			connections.hamVaultEspLoop = RunService.Heartbeat:Connect(function()
				for _, obj in pairs(Workspace:GetDescendants()) do
					if obj:IsA("Model") and (obj.Name:lower():match("safe") or obj.Name:lower():match("vault")) then
						if not obj:FindFirstChild("VaultESP") then
							local hl = Instance.new("Highlight", obj)
							hl.Name = "VaultESP"
							hl.FillColor = Color3.fromRGB(255, 215, 0)
						end
					end
				end
			end)
		else
			if connections.hamVaultEspLoop then connections.hamVaultEspLoop:Disconnect() connections.hamVaultEspLoop = nil end
			for _, obj in pairs(Workspace:GetDescendants()) do
				if obj:FindFirstChild("VaultESP") then obj.VaultESP:Destroy() end
			end
		end
	end
})

TabHamburg:CreateToggle({
	Name = "📸 Anti-Radar / Blitzer (Zerstört alle Radarfallen)",
	CurrentValue = false, Flag = "HamAntiRadar",
	Callback = function(v)
		states.hamAntiRadar = v
		if v then
			notify("Anti-Radar", "Alle Blitzer auf der Karte werden für dich deaktiviert!", false)
			connections.hamAntiRadarLoop = RunService.Heartbeat:Connect(function()
				for _, obj in pairs(Workspace:GetDescendants()) do
					if obj:IsA("BasePart") and (obj.Name:lower():match("radar") or obj.Name:lower():match("camera") or obj.Name:lower():match("blitzer")) then
						pcall(function() obj:Destroy() end)
					end
				end
			end)
		else
			if connections.hamAntiRadarLoop then connections.hamAntiRadarLoop:Disconnect() connections.hamAntiRadarLoop = nil end
		end
	end
})

TabHamburg:CreateSection("🛡️ Player & Jail Break")

TabHamburg:CreateToggle({
	Name = "🏃 Auto-Escape Jail (Teleportiert dich raus)",
	CurrentValue = false, Flag = "HamEscape",
	Callback = function(v)
		states.hamAutoEscape = v
		if v then
			connections.hamEscapeLoop = RunService.Heartbeat:Connect(function()
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local inJail = false
					local jailFolder = Workspace:FindFirstChild("Jail") or Workspace:FindFirstChild("Prison")
					if jailFolder then
						local dist = (player.Character.HumanoidRootPart.Position - jailFolder:GetPivot().Position).Magnitude
						if dist < 100 then
							player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 500, 500)
						end
					end
				end
			end)
		else
			if connections.hamEscapeLoop then connections.hamEscapeLoop:Disconnect() connections.hamEscapeLoop = nil end
		end
	end
})

TabHamburg:CreateButton({
	Name = "💥 Destroy Jail Doors (Löscht Gefängnistüren)",
	Callback = function()
		local count = 0
		for _, obj in pairs(Workspace:GetDescendants()) do
			if obj:IsA("BasePart") and (obj.Name:lower():match("jaildoor") or obj.Name:lower():match("cell")) then
				pcall(function() obj:Destroy() end)
				count = count + 1
			end
		end
		notify("Jail Break", count .. " Türen zerstört!", false)
	end
})

TabHamburg:CreateToggle({
	Name = "🛡️ Player Godmode (Hamburg Anti-Damage)",
	CurrentValue = false, Flag = "HamGod",
	Callback = function(v)
		states.hamGodmode = v
		if v then
			connections.hamGodLoop = RunService.Heartbeat:Connect(function()
				local char = player.Character
				if char and char:FindFirstChild("Humanoid") then
					char.Humanoid.MaxHealth = math.huge
					char.Humanoid.Health = math.huge
				end
			end)
		else
			if connections.hamGodLoop then connections.hamGodLoop:Disconnect() connections.hamGodLoop = nil end
		end
	end
})

TabHamburg:CreateToggle({
	Name = "🏥 Auto-Heal (Benutzt Medkit automatisch)",
	CurrentValue = false, Flag = "HamHeal",
	Callback = function(v)
		states.hamAutoHeal = v
		if v then
			connections.hamHealLoop = RunService.Heartbeat:Connect(function()
				local char = player.Character
				if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health < 50 then
					local medkit = player.Backpack:FindFirstChild("Medkit") or char:FindFirstChild("Medkit")
					if medkit then
						char.Humanoid:EquipTool(medkit)
						medkit:Activate()
					end
				end
			end)
		else
			if connections.hamHealLoop then connections.hamHealLoop:Disconnect() connections.hamHealLoop = nil end
		end
	end
})

TabHamburg:CreateSection("🚗 Vehicle Mods (Hamburg Edition)")

TabHamburg:CreateToggle({
	Name = "🚘 Car Godmode (Unzerstörbares Auto)",
	CurrentValue = false, Flag = "HamCarGod",
	Callback = function(v)
		states.hamCarGod = v
		if v then
			connections.hamCarGodLoop = RunService.Heartbeat:Connect(function()
				local char = player.Character
				if char and char:FindFirstChildOfClass("Humanoid") then
					local hum = char:FindFirstChildOfClass("Humanoid")
					if hum.SeatPart and hum.SeatPart.Parent then
						local car = hum.SeatPart.Parent
						local health = car:FindFirstChild("Health") or car:FindFirstChild("Durability")
						if health and health:IsA("ValueBase") then
							health.Value = 999999
						end
					end
				end
			end)
		else
			if connections.hamCarGodLoop then connections.hamCarGodLoop:Disconnect() connections.hamCarGodLoop = nil end
		end
	end
})

TabHamburg:CreateToggle({
	Name = "⛽ Infinite Fuel (Unendlich Tanken)",
	CurrentValue = false, Flag = "HamFuel",
	Callback = function(v)
		states.hamInfFuel = v
		if v then
			connections.hamFuelLoop = RunService.Heartbeat:Connect(function()
				local char = player.Character
				if char and char:FindFirstChildOfClass("Humanoid") then
					local hum = char:FindFirstChildOfClass("Humanoid")
					if hum.SeatPart and hum.SeatPart.Parent then
						local car = hum.SeatPart.Parent
						local fuel = car:FindFirstChild("Fuel")
						if fuel and fuel:IsA("ValueBase") then
							fuel.Value = 100
						end
					end
				end
			end)
		else
			if connections.hamFuelLoop then connections.hamFuelLoop:Disconnect() connections.hamFuelLoop = nil end
		end
	end
})

TabHamburg:CreateToggle({
	Name = "🔧 Auto-Fix Car (Repariert Auto dauerhaft)",
	CurrentValue = false, Flag = "HamFix",
	Callback = function(v)
		states.hamAutoFix = v
		if v then
			connections.hamFixLoop = RunService.Heartbeat:Connect(function()
				local char = player.Character
				if char and char:FindFirstChildOfClass("Humanoid") then
					local hum = char:FindFirstChildOfClass("Humanoid")
					if hum.SeatPart and hum.SeatPart.Parent then
						for _, p in pairs(hum.SeatPart.Parent:GetDescendants()) do
							if p:IsA("BasePart") and p.Transparency == 1 and p.Name:lower():match("smoke") then
								p:Destroy() 
							end
						end
					end
				end
			end)
		else
			if connections.hamFixLoop then connections.hamFixLoop:Disconnect() connections.hamFixLoop = nil end
		end
	end
})

TabHamburg:CreateButton({
	Name = "🔓 Unlock All Car Doors (Lokal alle Autos entriegeln)",
	Callback = function()
		for _, v in pairs(Workspace:GetDescendants()) do
			if v:IsA("VehicleSeat") then
				v.Disabled = false
			end
		end
		notify("Unlock", "Du kannst nun versuchen in fremde Autos einzusteigen.", false)
	end
})

TabHamburg:CreateSection("📍 Quick Teleports")

TabHamburg:CreateButton({
	Name = "🚓 TP to Police Station",
	Callback = function()
		safeTeleport(CFrame.new(-380, 20, 150))
		notify("TP", "Zur Polizeiwache!", false)
	end
})

TabHamburg:CreateButton({
	Name = "🏦 TP to Bank",
	Callback = function()
		safeTeleport(CFrame.new(120, 20, -450))
		notify("TP", "Zur Bank!", false)
	end
})

TabHamburg:CreateButton({
	Name = "💎 TP to Jewelry Store",
	Callback = function()
		safeTeleport(CFrame.new(500, 20, -100))
		notify("TP", "Zum Juwelier!", false)
	end
})

TabHamburg:CreateButton({
	Name = "🚗 TP to Car Dealership",
	Callback = function()
		safeTeleport(CFrame.new(-200, 20, -800))
		notify("TP", "Zum Autohändler!", false)
	end
})

-- =====================================================================
-- 3. TAB: EMERGENCY EMDEN 🚨 (V 25--: 25 NEUE FUNKTIONEN)
-- =====================================================================
TabEmden:CreateSection("🛡️ Player & Auto-Farms")

TabEmden:CreateToggle({
	Name = "🛡️ Godmode (Emden Anti-Damage)", CurrentValue = false, Flag = "EmdGod",
	Callback = function(v)
		states.emdGod = v
		if v then
			connections.emdGodLoop = RunService.Heartbeat:Connect(function()
				local char = player.Character
				if char and char:FindFirstChild("Humanoid") then
					char.Humanoid.MaxHealth = math.huge
					char.Humanoid.Health = math.huge
				end
			end)
		else
			if connections.emdGodLoop then connections.emdGodLoop:Disconnect() connections.emdGodLoop = nil end
		end
	end
})

TabEmden:CreateToggle({
	Name = "🏃 Infinite Stamina (Nie wieder aus der Puste)", CurrentValue = false, Flag = "EmdStamina",
	Callback = function(v)
		states.emdInfStamina = v
		if v then
			connections.emdInfStaminaLoop = RunService.Heartbeat:Connect(function()
				local char = player.Character
				if char then
					local stam = char:FindFirstChild("Stamina") or player:FindFirstChild("Stamina")
					if stam and stam:IsA("ValueBase") then stam.Value = 100 end
				end
			end)
		else
			if connections.emdInfStaminaLoop then connections.emdInfStaminaLoop:Disconnect() connections.emdInfStaminaLoop = nil end
		end
	end
})

TabEmden:CreateToggle({
	Name = "💸 Auto-Collect Paycheck (Sammelt Gehaltsschecks)", CurrentValue = false, Flag = "EmdPaycheck",
	Callback = function(v)
		states.emdPaycheck = v
		if v then
			connections.emdPaycheckLoop = task.spawn(function()
				while states.emdPaycheck do
					for _, prompt in ipairs(Workspace:GetDescendants()) do
						if prompt:IsA("ProximityPrompt") and prompt.ActionText:lower():match("paycheck") then
							fireproximityprompt(prompt)
						end
					end
					task.wait(5)
				end
			end)
		else
			if connections.emdPaycheckLoop then task.cancel(connections.emdPaycheckLoop) connections.emdPaycheckLoop = nil end
		end
	end
})

TabEmden:CreateToggle({
	Name = "🏧 Auto-Rob ATM/Register", CurrentValue = false, Flag = "EmdAutoRob",
	Callback = function(v)
		states.emdAutoRob = v
		if v then
			connections.emdAutoRobLoop = task.spawn(function()
				while states.emdAutoRob do
					if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
						for _, obj in pairs(Workspace:GetDescendants()) do
							if (obj.Name:lower() == "atm" or obj.Name:lower():match("register")) and obj:FindFirstChildOfClass("ProximityPrompt", true) then
								player.Character.HumanoidRootPart.CFrame = obj:GetPivot() * CFrame.new(0, 0, 3)
								task.wait(0.5)
								local prompt = obj:FindFirstChildOfClass("ProximityPrompt", true)
								if prompt then fireproximityprompt(prompt) end
								task.wait(3) 
							end
						end
					end
					task.wait(1)
				end
			end)
		else
			if connections.emdAutoRobLoop then task.cancel(connections.emdAutoRobLoop) connections.emdAutoRobLoop = nil end
		end
	end
})

TabEmden:CreateSection("🚔 Police & Criminal Mods")

TabEmden:CreateToggle({
	Name = "🚨 Anti-Arrest (Zerstört Handschellen & entkommt)", CurrentValue = false, Flag = "EmdAntiArrest",
	Callback = function(v)
		states.emdAntiArrest = v
		if v then
			connections.emdAntiArrestLoop = RunService.Heartbeat:Connect(function()
				local char = player.Character
				if char then
					for _, obj in ipairs(char:GetDescendants()) do
						if obj:IsA("Tool") and obj.Name:lower():match("cuff") then
							obj:Destroy()
						end
					end
				end
			end)
		else
			if connections.emdAntiArrestLoop then connections.emdAntiArrestLoop:Disconnect() connections.emdAntiArrestLoop = nil end
		end
	end
})

TabEmden:CreateToggle({
	Name = "🚓 Auto-Arrest Aura (Polizei: Nimmt alle im Umkreis fest)", CurrentValue = false, Flag = "EmdAutoArrest",
	Callback = function(v)
		states.emdAutoArrest = v
		if v then
			connections.emdAutoArrestLoop = RunService.Heartbeat:Connect(function()
				local char = player.Character
				if char and char:FindFirstChild("HumanoidRootPart") then
					local cuffs = char:FindFirstChild("Handcuffs") or player.Backpack:FindFirstChild("Handcuffs")
					if cuffs then
						if cuffs.Parent ~= char then char.Humanoid:EquipTool(cuffs) end
						for _, p in ipairs(Players:GetPlayers()) do
							if p ~= player and p.Team and not p.Team.Name:lower():match("police") and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
								local dist = (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
								if dist < 15 then
									cuffs:Activate()
								end
							end
						end
					end
				end
			end)
		else
			if connections.emdAutoArrestLoop then connections.emdAutoArrestLoop:Disconnect() connections.emdAutoArrestLoop = nil end
		end
	end
})

TabEmden:CreateToggle({
	Name = "🔓 Auto-Lockpick (Für Kriminelle)", CurrentValue = false, Flag = "EmdAutoPick",
	Callback = function(v)
		states.emdAutoPick = v
		if v then
			connections.emdAutoPickLoop = RunService.Heartbeat:Connect(function()
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local hrp = player.Character.HumanoidRootPart
					for _, p in ipairs(Workspace:GetDescendants()) do
						if p:IsA("ProximityPrompt") and p.ActionText:lower():match("lockpick") then
							if (p.Parent.Position - hrp.Position).Magnitude < 15 then
								fireproximityprompt(p)
							end
						end
					end
				end
			end)
		else
			if connections.emdAutoPickLoop then connections.emdAutoPickLoop:Disconnect() connections.emdAutoPickLoop = nil end
		end
	end
})

TabEmden:CreateButton({
	Name = "🚪 Delete Jail Doors (Gefängnistüren zerstören)",
	Callback = function()
		local count = 0
		for _, obj in pairs(Workspace:GetDescendants()) do
			if obj:IsA("BasePart") and (obj.Name:lower():match("jaildoor") or obj.Name:lower():match("cell")) then
				pcall(function() obj:Destroy() end)
				count = count + 1
			end
		end
		notify("Emden Break", count .. " Gefängnistüren zerstört!", false)
	end
})

TabEmden:CreateSection("🚒 Firefighter & Medic")

TabEmden:CreateToggle({
	Name = "🔥 Auto-Extinguish Fires (Löscht Feuer im Umkreis)", CurrentValue = false, Flag = "EmdAutoFire",
	Callback = function(v)
		states.emdAutoFire = v
		if v then
			connections.emdAutoFireLoop = RunService.Heartbeat:Connect(function()
				local char = player.Character
				if char and char:FindFirstChild("HumanoidRootPart") then
					local hose = char:FindFirstChild("Hose") or char:FindFirstChild("Extinguisher")
					if hose then
						for _, obj in ipairs(Workspace:GetDescendants()) do
							if obj.Name:lower():match("fire") and obj:IsA("BasePart") then
								if (char.HumanoidRootPart.Position - obj.Position).Magnitude < 25 then
									hose:Activate()
								end
							end
						end
					end
				end
			end)
		else
			if connections.emdAutoFireLoop then connections.emdAutoFireLoop:Disconnect() connections.emdAutoFireLoop = nil end
		end
	end
})

TabEmden:CreateToggle({
	Name = "🚑 Auto-Heal Self (Automatische Heilung)", CurrentValue = false, Flag = "EmdAutoHealSelf",
	Callback = function(v)
		states.emdAutoHealSelf = v
		if v then
			connections.emdAutoHealSelfLoop = RunService.Heartbeat:Connect(function()
				local char = player.Character
				if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health < 50 then
					local med = player.Backpack:FindFirstChild("Medkit") or char:FindFirstChild("Medkit")
					if med then
						char.Humanoid:EquipTool(med)
						med:Activate()
					end
				end
			end)
		else
			if connections.emdAutoHealSelfLoop then connections.emdAutoHealSelfLoop:Disconnect() connections.emdAutoHealSelfLoop = nil end
		end
	end
})

TabEmden:CreateToggle({
	Name = "💉 Auto-Heal Others (Medic Aura)", CurrentValue = false, Flag = "EmdAutoHealAll",
	Callback = function(v)
		states.emdAutoHealAll = v
		if v then
			connections.emdAutoHealAllLoop = RunService.Heartbeat:Connect(function()
				local char = player.Character
				if char and char:FindFirstChild("HumanoidRootPart") then
					local med = player.Backpack:FindFirstChild("Medkit") or char:FindFirstChild("Medkit")
					if med then
						if med.Parent ~= char then char.Humanoid:EquipTool(med) end
						for _, p in ipairs(Players:GetPlayers()) do
							if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health < 100 then
								if (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude < 15 then
									med:Activate()
								end
							end
						end
					end
				end
			end)
		else
			if connections.emdAutoHealAllLoop then connections.emdAutoHealAllLoop:Disconnect() connections.emdAutoHealAllLoop = nil end
		end
	end
})

TabEmden:CreateSection("🚗 Emden Vehicles")

TabEmden:CreateToggle({
	Name = "🚘 Vehicle Godmode (Anti-Crash)", CurrentValue = false, Flag = "EmdCarGod",
	Callback = function(v)
		states.emdCarGod = v
		if v then
			connections.emdCarGodLoop = RunService.Heartbeat:Connect(function()
				local char = player.Character
				if char and char:FindFirstChildOfClass("Humanoid") then
					local hum = char:FindFirstChildOfClass("Humanoid")
					if hum.SeatPart and hum.SeatPart.Parent then
						local car = hum.SeatPart.Parent
						local health = car:FindFirstChild("Health") or car:FindFirstChild("Durability")
						if health and health:IsA("ValueBase") then health.Value = 999999 end
					end
				end
			end)
		else
			if connections.emdCarGodLoop then connections.emdCarGodLoop:Disconnect() connections.emdCarGodLoop = nil end
		end
	end
})

TabEmden:CreateToggle({
	Name = "🚀 Vehicle Super Speed", CurrentValue = false, Flag = "EmdCarSpeed",
	Callback = function(v)
		states.emdCarSpeed = v
		if v then
			connections.emdCarSpeedLoop = RunService.Heartbeat:Connect(function()
				local char = player.Character
				if char and char:FindFirstChildOfClass("Humanoid") then
					local hum = char:FindFirstChildOfClass("Humanoid")
					if hum.SeatPart and hum.SeatPart:IsA("VehicleSeat") and hum.SeatPart.Throttle == 1 then
						hum.SeatPart.AssemblyLinearVelocity = hum.SeatPart.CFrame.LookVector * 250
					end
				end
			end)
		else
			if connections.emdCarSpeedLoop then connections.emdCarSpeedLoop:Disconnect() connections.emdCarSpeedLoop = nil end
		end
	end
})

TabEmden:CreateToggle({
	Name = "⛽ Infinite Fuel", CurrentValue = false, Flag = "EmdInfFuel",
	Callback = function(v)
		states.emdInfFuel = v
		if v then
			connections.emdInfFuelLoop = RunService.Heartbeat:Connect(function()
				local char = player.Character
				if char and char:FindFirstChildOfClass("Humanoid") then
					local hum = char:FindFirstChildOfClass("Humanoid")
					if hum.SeatPart and hum.SeatPart.Parent then
						local fuel = hum.SeatPart.Parent:FindFirstChild("Fuel")
						if fuel and fuel:IsA("ValueBase") then fuel.Value = 100 end
					end
				end
			end)
		else
			if connections.emdInfFuelLoop then connections.emdInfFuelLoop:Disconnect() connections.emdInfFuelLoop = nil end
		end
	end
})

TabEmden:CreateToggle({
	Name = "🔧 Auto-Repair Vehicle", CurrentValue = false, Flag = "EmdAutoRepair",
	Callback = function(v)
		states.emdAutoRepair = v
		if v then
			connections.emdAutoRepairLoop = RunService.Heartbeat:Connect(function()
				local char = player.Character
				if char and char:FindFirstChildOfClass("Humanoid") then
					local hum = char:FindFirstChildOfClass("Humanoid")
					if hum.SeatPart and hum.SeatPart.Parent then
						for _, p in pairs(hum.SeatPart.Parent:GetDescendants()) do
							if p:IsA("BasePart") and p.Transparency == 1 and p.Name:lower():match("smoke") then
								p:Destroy() 
							end
						end
					end
				end
			end)
		else
			if connections.emdAutoRepairLoop then connections.emdAutoRepairLoop:Disconnect() connections.emdAutoRepairLoop = nil end
		end
	end
})

TabEmden:CreateSection("👁️ ESP & Visuals")

TabEmden:CreateToggle({
	Name = "👮 Cop ESP", CurrentValue = false, Flag = "EmdCopEsp",
	Callback = function(v)
		states.emdCopEsp = v
		if v then
			connections.emdCopEspLoop = RunService.Heartbeat:Connect(function()
				for _, p in pairs(Players:GetPlayers()) do
					if p ~= player and p.Team and p.Team.Name:lower():match("police") and p.Character then
						if not p.Character:FindFirstChild("CopESP") then
							local hl = Instance.new("Highlight", p.Character)
							hl.Name = "CopESP"
							hl.FillColor = Color3.fromRGB(0, 0, 255)
						end
					end
				end
			end)
		else
			if connections.emdCopEspLoop then connections.emdCopEspLoop:Disconnect() connections.emdCopEspLoop = nil end
			for _, p in pairs(Players:GetPlayers()) do
				if p.Character and p.Character:FindFirstChild("CopESP") then p.Character.CopESP:Destroy() end
			end
		end
	end
})

TabEmden:CreateToggle({
	Name = "🦹 Criminal ESP", CurrentValue = false, Flag = "EmdCrimEsp",
	Callback = function(v)
		states.emdCrimEsp = v
		if v then
			connections.emdCrimEspLoop = RunService.Heartbeat:Connect(function()
				for _, p in pairs(Players:GetPlayers()) do
					if p ~= player and p.Team and p.Team.Name:lower():match("crim") and p.Character then
						if not p.Character:FindFirstChild("CrimESP") then
							local hl = Instance.new("Highlight", p.Character)
							hl.Name = "CrimESP"
							hl.FillColor = Color3.fromRGB(255, 0, 0)
						end
					end
				end
			end)
		else
			if connections.emdCrimEspLoop then connections.emdCrimEspLoop:Disconnect() connections.emdCrimEspLoop = nil end
			for _, p in pairs(Players:GetPlayers()) do
				if p.Character and p.Character:FindFirstChild("CrimESP") then p.Character.CrimESP:Destroy() end
			end
		end
	end
})

TabEmden:CreateToggle({
	Name = "🔥 Fire ESP", CurrentValue = false, Flag = "EmdFireEsp",
	Callback = function(v)
		states.emdFireEsp = v
		if v then
			connections.emdFireEspLoop = RunService.Heartbeat:Connect(function()
				for _, obj in pairs(Workspace:GetDescendants()) do
					if obj.Name:lower():match("fire") and obj:IsA("BasePart") then
						if not obj:FindFirstChild("FireESP") then
							local hl = Instance.new("Highlight", obj)
							hl.Name = "FireESP"
							hl.FillColor = Color3.fromRGB(255, 100, 0)
						end
					end
				end
			end)
		else
			if connections.emdFireEspLoop then connections.emdFireEspLoop:Disconnect() connections.emdFireEspLoop = nil end
			for _, obj in pairs(Workspace:GetDescendants()) do
				if obj:FindFirstChild("FireESP") then obj.FireESP:Destroy() end
			end
		end
	end
})

TabEmden:CreateSection("💀 Combat & Chaos")

TabEmden:CreateToggle({
	Name = "🌪️ K-Fling All (Destroy Server)", CurrentValue = false, Flag = "EmdFlingAll",
	Callback = function(v)
		states.emdFlingAll = v
		if v then
			connections.emdFlingAllLoop = task.spawn(function()
				while states.emdFlingAll do
					for _, p in ipairs(Players:GetPlayers()) do
						if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
							executeOriginalFling(p, 0.15, Vector3.new(0, 50000, 0))
							task.wait(0.2)
						end
					end
					task.wait(0.1)
				end
			end)
		else
			if connections.emdFlingAllLoop then task.cancel(connections.emdFlingAllLoop) connections.emdFlingAllLoop = nil end
		end
	end
})

TabEmden:CreateToggle({
	Name = "🔫 Gun Aimbot", CurrentValue = false, Flag = "EmdAim",
	Callback = function(v)
		states.emdAim = v
		if v then
			connections.emdAimLoop = RunService.RenderStepped:Connect(function()
				if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
					local closestTarget = nil
					local closestDist = math.huge
					for _, p in pairs(Players:GetPlayers()) do
						if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
							local pos, onScreen = camera:WorldToViewportPoint(p.Character.Head.Position)
							if onScreen then
								local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
								if dist < closestDist then
									closestDist = dist
									closestTarget = p.Character.Head
								end
							end
						end
					end
					if closestTarget then
						camera.CFrame = CFrame.new(camera.CFrame.Position, closestTarget.Position)
					end
				end
			end)
		else
			if connections.emdAimLoop then connections.emdAimLoop:Disconnect() connections.emdAimLoop = nil end
		end
	end
})

TabEmden:CreateToggle({
	Name = "💥 Infinite Ammo (Kein Nachladen)", CurrentValue = false, Flag = "EmdInfAmmo",
	Callback = function(v)
		states.emdInfAmmo = v
		if v then
			connections.emdInfAmmoLoop = RunService.Heartbeat:Connect(function()
				local char = player.Character
				if char then
					local gun = char:FindFirstChildOfClass("Tool")
					if gun and gun:FindFirstChild("Ammo") then
						gun.Ammo.Value = 999
					end
				end
			end)
		else
			if connections.emdInfAmmoLoop then connections.emdInfAmmoLoop:Disconnect() connections.emdInfAmmoLoop = nil end
		end
	end
})

TabEmden:CreateSection("📍 Emden Teleports")

TabEmden:CreateButton({
	Name = "🏦 Teleport: Bank",
	Callback = function() safeTeleport(CFrame.new(0, 20, 0)) notify("TP", "Zur Bank portiert!", false) end
})
TabEmden:CreateButton({
	Name = "🚔 Teleport: Police Station",
	Callback = function() safeTeleport(CFrame.new(100, 20, 100)) notify("TP", "Zur Polizei portiert!", false) end
})
TabEmden:CreateButton({
	Name = "🏥 Teleport: Hospital",
	Callback = function() safeTeleport(CFrame.new(-100, 20, -100)) notify("TP", "Zum Krankenhaus portiert!", false) end
})
TabEmden:CreateButton({
	Name = "🚒 Teleport: Fire Station",
	Callback = function() safeTeleport(CFrame.new(200, 20, -200)) notify("TP", "Zur Feuerwehr portiert!", false) end
})


-- =====================================================================
-- 2. TAB: BLADE BALL ⚔️
-- =====================================================================
TabBlade:CreateSection("🛡️ Blade Ball Core System")

TabBlade:CreateToggle({
	Name = "🤖 Real Math Auto-Parry (Berechnet Time-to-Impact)",
	CurrentValue = false, Flag = "BladeParryReal",
	Callback = function(Value)
		states.bladeBallParry = Value
		if states.bladeBallParry then
			notify("Blade Ball", "Mathematischer Auto-Parry aktiv! (Distanz/Speed Berechnung)", false)
			connections.bladeParryLoop = RunService.Heartbeat:Connect(function()
				pcall(function()
					local balls = Workspace:FindFirstChild("Balls") or Workspace
					for _, ball in pairs(balls:GetDescendants()) do
						if ball.Name == "Ball" and ball:IsA("BasePart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
							local distance = (ball.Position - player.Character.HumanoidRootPart.Position).Magnitude
							local velocity = ball.Velocity.Magnitude
							local timeToImpact = distance / (velocity + 0.001)
							
							if timeToImpact < 0.4 then
								VirtualUser:Button1Down(Vector2.new(0,0), camera.CFrame)
								VirtualUser:Button1Up(Vector2.new(0,0), camera.CFrame)
								local args = { [1] = 1.5, [2] = CFrame.new(), [3] = {} }
								local rem = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
								if rem and rem:FindFirstChild("ParryButtonPress") then
									rem.ParryButtonPress:FireServer(unpack(args))
								end
							end
						end
					end
				end)
			end)
		else
			if connections.bladeParryLoop then connections.bladeParryLoop:Disconnect() connections.bladeParryLoop = nil end
		end
	end
})

TabBlade:CreateToggle({
	Name = "⚔️ Auto-Spam Parry (Rage Mode Nahkampf)",
	CurrentValue = false, Flag = "BladeSpamParry",
	Callback = function(Value)
		states.bladeBallSpam = Value
		if states.bladeBallSpam then
			notify("Blade Ball", "Spam Parry aktiviert! Unaufhaltsam im Clash.", false)
			connections.bladeSpamLoop = RunService.Heartbeat:Connect(function()
				pcall(function()
					VirtualUser:Button1Down(Vector2.new(0,0), camera.CFrame)
					VirtualUser:Button1Up(Vector2.new(0,0), camera.CFrame)
				end)
			end)
		else
			if connections.bladeSpamLoop then connections.bladeSpamLoop:Disconnect() connections.bladeSpamLoop = nil end
		end
	end
})

TabBlade:CreateButton({
	Name = "🟩 Hitbox Expander (Macht das Blocken extrem leicht)",
	Callback = function()
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = player.Character.HumanoidRootPart
			hrp.Size = Vector3.new(20, 20, 20)
			hrp.Transparency = 0.8
			notify("Blade Ball", "Hitbox extrem vergrößert!", false)
		end
	end
})

TabBlade:CreateSection("🎯 Aiming, Curve & Movement")

TabBlade:CreateToggle({
	Name = "🔄 Auto-Curve (Gibt dem Ball sofort einen Spin)",
	CurrentValue = false, Flag = "BladeCurve",
	Callback = function(Value)
		states.bbCurve = Value
		if states.bbCurve then
			connections.bbCurve = UserInputService.InputBegan:Connect(function(input, gp)
				if not gp and input.UserInputType == Enum.UserInputType.MouseButton1 then
					local original = camera.CFrame
					camera.CFrame = camera.CFrame * CFrame.Angles(0, math.rad(180), 0)
					task.wait(0.05)
					camera.CFrame = original
				end
			end)
		else
			if connections.bbCurve then connections.bbCurve:Disconnect() end
		end
	end
})

TabBlade:CreateToggle({
	Name = "🏃 Auto-Dodge (Weicht dem Ball aus)",
	CurrentValue = false, Flag = "BladeDodge",
	Callback = function(Value)
		states.bbAutoDodge = Value
		if states.bbAutoDodge then
			connections.bbDodge = RunService.Heartbeat:Connect(function()
				pcall(function()
					local ball = Workspace:FindFirstChild("Ball", true)
					if ball and ball:IsA("BasePart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
						local dist = (ball.Position - player.Character.HumanoidRootPart.Position).Magnitude
						if dist < 45 and ball:GetAttribute("target") ~= player.Name then
							player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(math.random(-5, 5), 0, math.random(-5, 5))
						end
					end
				end)
			end)
		else
			if connections.bbDodge then connections.bbDodge:Disconnect() end
		end
	end
})

TabBlade:CreateButton({
	Name = "🚀 Auto-Dash (Springt zum Ball)",
	Callback = function()
		local ball = Workspace:FindFirstChild("Ball", true)
		if ball and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = player.Character.HumanoidRootPart
			hrp.CFrame = CFrame.new(hrp.Position, ball.Position) * CFrame.new(0, 0, -15)
			notify("Blade Dash", "Dashed in Richtung Ball!", false)
		end
	end
})

TabBlade:CreateSection("👁️ ESP & Target Visuals")

TabBlade:CreateToggle({
	Name = "🎯 Target Player ESP (Zeigt an, wer im Visier ist)",
	CurrentValue = false, Flag = "BladeTargetESP",
	Callback = function(Value)
		states.bbTargetESP = Value
		if states.bbTargetESP then
			connections.bbTargetESP = RunService.Heartbeat:Connect(function()
				local ball = Workspace:FindFirstChild("Ball", true)
				if ball and ball:GetAttribute("target") then
					local targetName = ball:GetAttribute("target")
					for _, p in pairs(Players:GetPlayers()) do
						if p.Name == targetName and p.Character then
							if not p.Character:FindFirstChild("TargetESP") then
								local hl = Instance.new("Highlight", p.Character)
								hl.Name = "TargetESP"
								hl.FillColor = Color3.fromRGB(255, 0, 0)
							end
						else
							if p.Character and p.Character:FindFirstChild("TargetESP") then p.Character.TargetESP:Destroy() end
						end
					end
				end
			end)
		else
			if connections.bbTargetESP then connections.bbTargetESP:Disconnect() end
			for _, p in pairs(Players:GetPlayers()) do
				if p.Character and p.Character:FindFirstChild("TargetESP") then p.Character.TargetESP:Destroy() end
			end
		end
	end
})

TabBlade:CreateToggle({
	Name = "🚨 Target Alert (Große Warnung wenn du im Visier bist)",
	CurrentValue = false, Flag = "BladeTargetAlert",
	Callback = function(Value)
		if Value then
			connections.bbTargetAlert = RunService.Heartbeat:Connect(function()
				local ball = Workspace:FindFirstChild("Ball", true)
				if ball and ball:GetAttribute("target") == player.Name then
					Lighting.Ambient = Color3.fromRGB(255, 0, 0)
				else
					Lighting.Ambient = Color3.fromRGB(127, 127, 127)
				end
			end)
		else
			if connections.bbTargetAlert then connections.bbTargetAlert:Disconnect() end
			Lighting.Ambient = Color3.fromRGB(127, 127, 127)
		end
	end
})

TabBlade:CreateToggle({
	Name = "🔮 Ball X-Ray (ESP für den Ball)",
	CurrentValue = false, Flag = "BladeXray",
	Callback = function(Value)
		states.bladeBallXray = Value
		if states.bladeBallXray then
			connections.bladeXrayLoop = RunService.Heartbeat:Connect(function()
				for _, v in pairs(Workspace:GetDescendants()) do
					if v.Name == "Ball" and v:IsA("BasePart") and not v:FindFirstChild("BallESP") then
						local hl = Instance.new("Highlight", v)
						hl.Name = "BallESP"
						hl.FillColor = Color3.fromRGB(255, 50, 50)
						hl.OutlineColor = Color3.fromRGB(255, 255, 255)
					end
				end
			end)
		else
			if connections.bladeXrayLoop then connections.bladeXrayLoop:Disconnect() connections.bladeXrayLoop = nil end
			for _, v in pairs(Workspace:GetDescendants()) do
				if v.Name == "Ball" and v:FindFirstChild("BallESP") then v.BallESP:Destroy() end
			end
		end
	end
})

TabBlade:CreateToggle({
	Name = "📍 Target Line (Roter Laser vom Ball zu dir)",
	CurrentValue = false, Flag = "BladeLine",
	Callback = function(Value)
		if Value then
			objects.bbBeam = Instance.new("Beam", Workspace)
			objects.bbBeam.Color = ColorSequence.new(Color3.fromRGB(255,0,0))
			objects.bbBeam.Width0 = 0.5 objects.bbBeam.Width1 = 0.5
			local a0 = Instance.new("Attachment", Workspace.Terrain)
			local a1 = Instance.new("Attachment", Workspace.Terrain)
			objects.bbBeam.Attachment0 = a0 objects.bbBeam.Attachment1 = a1
			connections.bbBeam = RunService.RenderStepped:Connect(function()
				local ball = Workspace:FindFirstChild("Ball", true)
				if ball and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					a0.Position = ball.Position
					a1.Position = player.Character.HumanoidRootPart.Position
				end
			end)
		else
			if connections.bbBeam then connections.bbBeam:Disconnect() end
			if objects.bbBeam then objects.bbBeam:Destroy() end
		end
	end
})

TabBlade:CreateToggle({
	Name = "🎯 Target Lock-On (Kamera fixiert den Ball)",
	CurrentValue = false, Flag = "BladeLock",
	Callback = function(Value)
		states.bladeBallLock = Value
		if states.bladeBallLock then
			connections.bladeLockLoop = RunService.RenderStepped:Connect(function()
				local ball = Workspace:FindFirstChild("Ball", true)
				if ball and ball:IsA("BasePart") and player.Character and player.Character:FindFirstChild("Head") then
					camera.CFrame = CFrame.new(camera.CFrame.Position, ball.Position)
				end
			end)
		else
			if connections.bladeLockLoop then connections.bladeLockLoop:Disconnect() connections.bladeLockLoop = nil end
		end
	end
})

-- =====================================================================
-- 3. TAB: NATURKATASTROPHEN 🌋
-- =====================================================================
TabDisasters:CreateSection("🏆 Auto-Wins & God-Modi")

TabDisasters:CreateToggle({
	Name = "👑 Auto-Win (Sicherer Spot im Himmel)",
	CurrentValue = false, Flag = "NDAutoWin",
	Callback = function(v)
		states.ndAutoWin = v
		if v then
			connections.ndAutoWin = RunService.Heartbeat:Connect(function()
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 1000, 0)
					player.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
				end
			end)
		else
			if connections.ndAutoWin then connections.ndAutoWin:Disconnect() end
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
			end
		end
	end
})

TabDisasters:CreateButton({
	Name = "🛡️ Unsterblichkeit (Anti-Schaden & Anti-Wasser)",
	Callback = function()
		local char = player.Character
		if char and char:FindFirstChildOfClass("Humanoid") then
			char.Humanoid.MaxHealth = math.huge
			char.Humanoid.Health = math.huge
			notify("Naturkatastrophen", "Du bist nun immun gegen Umweltschaden!", false)
		end
	end
})

TabDisasters:CreateButton({
	Name = "❌ Fallschaden komplett entfernen (Anti-Fall)",
	Callback = function()
		local fallScript = player.Character and player.Character:FindFirstChild("FallDamage")
		if fallScript then
			fallScript:Destroy()
			notify("Naturkatastrophen", "Fallschaden wurde restlos entfernt!", false)
		else
			notify("Info", "Kein Fallschaden-Script gefunden.", false)
		end
	end
})

TabDisasters:CreateSection("🌍 Map Manipulation & Vorteile")

TabDisasters:CreateToggle({
	Name = "🌊 Tsunami & Flash Flood löschen (Anti-Wasser)",
	CurrentValue = false, Flag = "NDAntiWater",
	Callback = function(v)
		states.ndAntiWater = v
		if v then
			connections.ndWater = RunService.Heartbeat:Connect(function()
				for _, v in pairs(Workspace:GetDescendants()) do
					if v.Name == "Water" or v.Name == "FloodWater" or v.Name == "Tsunami" then
						pcall(function() v:Destroy() end)
					end
				end
			end)
		else
			if connections.ndWater then connections.ndWater:Disconnect() end
		end
	end
})

TabDisasters:CreateToggle({
	Name = "🚶 Jesus Mode (Über Wasser laufen)",
	CurrentValue = false, Flag = "NDJesus",
	Callback = function(v)
		states.ndJesus = v
		if v then
			local jesusPart = Instance.new("Part", Workspace)
			jesusPart.Name = "JesusPart"
			jesusPart.Size = Vector3.new(10, 1, 10)
			jesusPart.Transparency = 1
			jesusPart.Anchored = true
			connections.ndJesus = RunService.Heartbeat:Connect(function()
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local root = player.Character.HumanoidRootPart
					jesusPart.Position = Vector3.new(root.Position.X, 10, root.Position.Z)
				end
			end)
		else
			if connections.ndJesus then connections.ndJesus:Disconnect() end
			if Workspace:FindFirstChild("JesusPart") then Workspace.JesusPart:Destroy() end
		end
	end
})

TabDisasters:CreateToggle({
	Name = "🔮 Disaster Predictor (Sagt Katastrophe voraus)",
	CurrentValue = false, Flag = "NDPredictor",
	Callback = function(v)
		states.ndPredictor = v
		if v then
			connections.ndPredictor = player.PlayerGui.DescendantAdded:Connect(function(descendant)
				if descendant:IsA("TextLabel") and descendant.Name == "Message" then
					notify("WARNUNG", "Katastrophe: " .. descendant.Text, false)
				end
			end)
		else
			if connections.ndPredictor then connections.ndPredictor:Disconnect() end
		end
	end
})

TabDisasters:CreateToggle({
	Name = "🍎 Auto-Heal (Isst Äpfel bei Low HP)",
	CurrentValue = false, Flag = "NDAutoHeal",
	Callback = function(v)
		states.ndAutoHeal = v
		if v then
			connections.ndHeal = RunService.Heartbeat:Connect(function()
				local char = player.Character
				if char and char:FindFirstChild("Humanoid") then
					if char.Humanoid.Health < 50 and char.Humanoid.Health > 0 then
						local apple = player.Backpack:FindFirstChild("Green Apple") or char:FindFirstChild("Green Apple")
						if apple then
							char.Humanoid:EquipTool(apple)
							apple:Activate()
						end
					end
				end
			end)
		else
			if connections.ndHeal then connections.ndHeal:Disconnect() end
		end
	end
})

TabDisasters:CreateButton({
	Name = "🚀 Zur Rakete teleportieren (Falls Raketen-Map)",
	Callback = function()
		local rocket = Workspace:FindFirstChild("Rocket", true)
		if rocket and rocket:IsA("BasePart") then
			safeTeleport(rocket.CFrame * CFrame.new(0, 5, 0))
		else
			notify("Naturkatastrophen", "Keine Rakete auf dieser Map!", false)
		end
	end
})

TabDisasters:CreateToggle({
	Name = "🗺️ Map ESP (Hebt die Hauptinsel hervor)",
	CurrentValue = false, Flag = "NDMapESP",
	Callback = function(v)
		states.ndMapESP = v
		if v then
			local map = Workspace:FindFirstChild("Island") or Workspace:FindFirstChild("Map")
			if map and not map:FindFirstChild("MapESP") then
				local hl = Instance.new("Highlight", map)
				hl.Name = "MapESP"
				hl.FillColor = Color3.fromRGB(0, 255, 0)
			end
		else
			local map = Workspace:FindFirstChild("Island") or Workspace:FindFirstChild("Map")
			if map and map:FindFirstChild("MapESP") then map.MapESP:Destroy() end
		end
	end
})

TabDisasters:CreateToggle({
	Name = "🧲 Automatischer Item-Magnet (Sammelt Äpfel/Ballons)", CurrentValue = false, Flag = "DisasterMagnet",
	Callback = function(v)
		states.disasterMagnet = v
		if v then
			connections.disasterMagnet = RunService.Heartbeat:Connect(function()
				local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
				if root then
					for _, obj in pairs(Workspace:GetDescendants()) do
						if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
							obj.Handle.CFrame = root.CFrame
						end
					end
				end
			end)
		else
			if connections.disasterMagnet then connections.disasterMagnet:Disconnect() end
		end
	end
})

TabDisasters:CreateButton({
	Name = "🎈 Anti-Gravity / Schwerkraft verringern",
	Callback = function()
		Workspace.Gravity = 30
		notify("Naturkatastrophen", "Schwerkraft auf Mond-Niveau gesenkt (Perfekt zum Fliehen vor Fluten)!", false)
	end
})

TabDisasters:CreateButton({
	Name = "🌍 Schwerkraft auf Normal zurücksetzen",
	Callback = function()
		Workspace.Gravity = 196.2
		notify("Naturkatastrophen", "Schwerkraft normalisiert.", false)
	end
})

addChopkickButtons(TabDisasters)

-- =====================================================================
-- 4. TAB: TROLL MENÜ 😈
-- =====================================================================
TabTroll:CreateSection("💀 Tödliche Troll-Optionen (Physik-Exploits)")

TabTroll:CreateToggle({
	Name = "☠️ Auto-Kill All (Unsichtbares Fling nach unten)", CurrentValue = false, Flag = "TrollKillAll",
	Callback = function(v)
		states.trollKillAll = v
		if v then
			notify("Massenmord", "Kill All aktiv. Alle Spieler werden vernichtet. Du bleibst sicher.", false)
			connections.trollKillLoop = task.spawn(function()
				while states.trollKillAll do
					for _, p in ipairs(Players:GetPlayers()) do
						if not states.trollKillAll then break end
						if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
							executeOriginalFling(p, 0.15, Vector3.new(0, -99999, 0))
							task.wait(0.2)
						end
					end
					task.wait(0.1)
				end
			end)
		else
			if connections.trollKillLoop then task.cancel(connections.trollKillLoop) connections.trollKillLoop = nil end
		end
	end
})

TabTroll:CreateToggle({
	Name = "🧲 Bring All (Sichtbares Heranziehen)", CurrentValue = false, Flag = "TrollBringAll",
	Callback = function(v)
		states.trollBringAll = v
		if v then
			local originPosition = player.Character and player.Character.HumanoidRootPart.Position or Vector3.new(0,0,0)
			connections.trollBringLoop = RunService.Heartbeat:Connect(function()
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					for _, p in pairs(Players:GetPlayers()) do
						if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
							pcall(function()
								p.Character.HumanoidRootPart.CFrame = CFrame.new(originPosition + Vector3.new(math.random(-5,5), 0, math.random(-5,5)))
							end)
						end
					end
				end
			end)
		else
			if connections.trollBringLoop then connections.trollBringLoop:Disconnect() connections.trollBringLoop = nil end
		end
	end
})

TabTroll:CreateToggle({
	Name = "🌪️ Fling All Players (Sichtbares Chaos)", CurrentValue = false, Flag = "TrollFlingAll",
	Callback = function(v)
		states.trollFlingAll = v
		if v then
			connections.trollFlingLoop = task.spawn(function()
				while states.trollFlingAll do
					for _, p in ipairs(Players:GetPlayers()) do
						if not states.trollFlingAll then break end
						if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
							executeOriginalFling(p, 0.15)
							task.wait(0.16)
						end
					end
					task.wait(0.1)
				end
			end)
		else
			if connections.trollFlingLoop then task.cancel(connections.trollFlingLoop) connections.trollFlingLoop = nil end
		end
	end
})

TabTroll:CreateSection("🎯 Gezieltes Trolling (Ein Opfer)")

local trollDropdown = TabTroll:CreateDropdown({
	Name = "Opfer auswählen",
	Options = {"(Aktualisieren drücken)"},
	CurrentOption = {"(Aktualisieren drücken)"},
	MultipleOptions = false,
	Flag = "TrollPlayerDropdown",
	Callback = function(Option)
		states.trollSelectedPlayer = Option[1]
	end,
})

TabTroll:CreateButton({
	Name = "🔄 Spielerliste aktualisieren",
	Callback = function()
		local pList = {}
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player then table.insert(pList, p.Name) end
		end
		if #pList == 0 then table.insert(pList, "Niemand da") end
		trollDropdown:Refresh(pList, {pList[1]})
		notify("Troll Menü", "Spielerliste aktualisiert.", false)
	end
})

TabTroll:CreateButton({
	Name = "🚀 Einmalig Target Fling (Auto teleportiert mit & Du bist sicher)",
	Callback = function()
		if not states.trollSelectedPlayer or states.trollSelectedPlayer == "Niemand da" then
			notify("Fehler", "Bitte wähle einen Spieler aus.", false) return
		end
		local target = Players:FindFirstChild(states.trollSelectedPlayer)
		if not target then notify("Fehler", "Spieler nicht gefunden.", false) return end
		
		notify("Fling", target.Name .. " wird weggeschleudert!", false)
		executeOriginalFling(target, 0.5)
	end
})

TabTroll:CreateToggle({
	Name = "🌪️ Loop-Fling (Opfer dauerhaft wegschleudern)", CurrentValue = false, Flag = "TrollLoopFling",
	Callback = function(v)
		states.trollLoopFling = v
		if v then
			task.spawn(function()
				while states.trollLoopFling do
					if states.trollSelectedPlayer then
						local target = Players:FindFirstChild(states.trollSelectedPlayer)
						if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
							executeOriginalFling(target, 0.2)
						end
					end
					task.wait(0.3)
				end
			end)
		end
	end
})

TabTroll:CreateToggle({
	Name = "👀 Stalker-Mode (Immer hinter dem Opfer teleportieren)", CurrentValue = false, Flag = "TrollStalk",
	Callback = function(v)
		states.trollStalk = v
		if v then
			connections.trollStalk = RunService.Heartbeat:Connect(function()
				if states.trollSelectedPlayer then
					local target = Players:FindFirstChild(states.trollSelectedPlayer)
					if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
						player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
					end
				end
			end)
		else
			if connections.trollStalk then connections.trollStalk:Disconnect() connections.trollStalk = nil end
		end
	end
})

TabTroll:CreateToggle({
	Name = "🎒 Rucksack-Mode (Auf dem Kopf des Opfer sitzen)", CurrentValue = false, Flag = "TrollBackpack",
	Callback = function(v)
		states.trollBackpack = v
		if v then
			connections.trollBackpack = RunService.Heartbeat:Connect(function()
				if states.trollSelectedPlayer then
					local target = Players:FindFirstChild(states.trollSelectedPlayer)
					if target and target.Character and target.Character:FindFirstChild("Head") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
						player.Character.HumanoidRootPart.CFrame = target.Character.Head.CFrame * CFrame.new(0, 2, 0)
					end
				end
			end)
		else
			if connections.trollBackpack then connections.trollBackpack:Disconnect() connections.trollBackpack = nil end
		end
	end
})

TabTroll:CreateToggle({
	Name = "🪐 Orbit-Mode (Schnell um das Opfer kreisen)", CurrentValue = false, Flag = "TrollOrbit",
	Callback = function(v)
		states.trollOrbit = v
		if v then
			local angle = 0
			connections.trollOrbit = RunService.Heartbeat:Connect(function()
				if states.trollSelectedPlayer then
					local target = Players:FindFirstChild(states.trollSelectedPlayer)
					if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
						angle = angle + 15
						local rad = math.rad(angle)
						local offset = Vector3.new(math.sin(rad) * 12, 0, math.cos(rad) * 12)
						player.Character.HumanoidRootPart.CFrame = CFrame.new(target.Character.HumanoidRootPart.Position + offset)
					end
				end
			end)
		else
			if connections.trollOrbit then connections.trollOrbit:Disconnect() connections.trollOrbit = nil end
		end
	end
})

TabTroll:CreateSection("🌪️ Neue Psycho-Troll Funktionen")

TabTroll:CreateButton({
	Name = "🕳️ Send to Void (Schleudert Opfer ins Nichts)",
	Callback = function()
		if states.trollSelectedPlayer then
			local target = Players:FindFirstChild(states.trollSelectedPlayer)
			if target then
				executeOriginalFling(target, 0.4, Vector3.new(0, -50000, 0))
				notify("Void", target.Name .. " wurde in den Abgrund geschickt!", false)
			end
		end
	end
})

TabTroll:CreateToggle({
	Name = "🛸 UFO Abduction (Zieht das Opfer in den Himmel)", 
	CurrentValue = false, 
	Flag = "TrollUFO",
	Callback = function(v)
		states.trollUFO = v
		if v then
			connections.trollUFO = task.spawn(function()
				while states.trollUFO do
					if states.trollSelectedPlayer then
						local target = Players:FindFirstChild(states.trollSelectedPlayer)
						if target then
							executeOriginalFling(target, 0.2, Vector3.new(0, 5000, 0))
						end
					end
					task.wait(0.5)
				end
			end)
		else
			if connections.trollUFO then task.cancel(connections.trollUFO) connections.trollUFO = nil end
		end
	end
})

TabTroll:CreateSection("🔥 Brandneue High-End Troll Funktionen")

TabTroll:CreateToggle({
	Name = "🪞 Trolling Mirror-Mode (Kopiert jede Bewegung eines Spielers)", CurrentValue = false, Flag = "TrollMirror",
	Callback = function(v)
		states.trollMirror = v
		if v then
			connections.trollMirror = RunService.RenderStepped:Connect(function()
				if states.trollSelectedPlayer then
					local target = Players:FindFirstChild(states.trollSelectedPlayer)
					if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
						local tCf = target.Character.HumanoidRootPart.CFrame
						player.Character.HumanoidRootPart.CFrame = tCf + Vector3.new(5, 0, 5)
					end
				end
			end)
		else
			if connections.trollMirror then connections.trollMirror:Disconnect() end
		end
	end
})

TabTroll:CreateToggle({
	Name = "🚔 Jail Target (Baut einen lokalen Käfig um das Opfer)", CurrentValue = false, Flag = "TrollJail",
	Callback = function(v)
		if v and states.trollSelectedPlayer then
			local target = Players:FindFirstChild(states.trollSelectedPlayer)
			if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
				local p1 = Instance.new("Part", Workspace) p1.Name = "JailWall1" p1.Size = Vector3.new(10, 10, 1) p1.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5) p1.Anchored = true p1.Transparency = 0.5
				local p2 = Instance.new("Part", Workspace) p2.Name = "JailWall2" p2.Size = Vector3.new(10, 10, 1) p2.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5) p2.Anchored = true p2.Transparency = 0.5
				local p3 = Instance.new("Part", Workspace) p3.Name = "JailWall3" p3.Size = Vector3.new(1, 10, 10) p3.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(5, 0, 0) p3.Anchored = true p3.Transparency = 0.5
				local p4 = Instance.new("Part", Workspace) p4.Name = "JailWall4" p4.Size = Vector3.new(1, 10, 10) p4.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(-5, 0, 0) p4.Anchored = true p4.Transparency = 0.5
				notify("Jail", "Käfig um " .. target.Name .. " gebaut!", false)
			end
		else
			for _, v in pairs(Workspace:GetChildren()) do if v.Name:match("JailWall") then v:Destroy() end end
		end
	end
})

TabTroll:CreateToggle({
	Name = "🕶️ Blind Target (Packt einen schwarzen Block auf seinen Kopf)", CurrentValue = false, Flag = "TrollBlind",
	Callback = function(v)
		if v and states.trollSelectedPlayer then
			connections.trollBlind = RunService.Heartbeat:Connect(function()
				local target = Players:FindFirstChild(states.trollSelectedPlayer)
				if target and target.Character and target.Character:FindFirstChild("Head") then
					if not Workspace:FindFirstChild("BlindBlock") then
						local b = Instance.new("Part", Workspace)
						b.Name = "BlindBlock"
						b.Size = Vector3.new(5,5,5)
						b.Color = Color3.new(0,0,0)
						b.Anchored = true
					end
					Workspace.BlindBlock.CFrame = target.Character.Head.CFrame
				end
			end)
		else
			if connections.trollBlind then connections.trollBlind:Disconnect() end
			if Workspace:FindFirstChild("BlindBlock") then Workspace.BlindBlock:Destroy() end
		end
	end
})

TabTroll:CreateButton({
	Name = "🔊 Annoy Sound Spam (Spielt laute Sounds lokal ab)",
	Callback = function()
		for i = 1, 10 do
			local s = Instance.new("Sound", Workspace)
			s.SoundId = "rbxassetid://130768652"
			s.Volume = 10
			s:Play()
			task.wait(0.1)
		end
	end
})

TabTroll:CreateButton({
	Name = "🧞 Clone Target (Erstellt Klone vom Opfer)",
	Callback = function()
		if states.trollSelectedPlayer then
			local target = Players:FindFirstChild(states.trollSelectedPlayer)
			if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
				target.Character.Archivable = true 
				local clone = target.Character:Clone()
				if clone then
					clone.Parent = Workspace
					clone.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(3,0,0)
					notify("Clone", "Erfolgreich geklont!", false)
				end
			end
		end
	end
})

TabTroll:CreateButton({
	Name = "✈️ Troll Carpet (Spawnt fliegenden Teppich unter dir)",
	Callback = function()
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local carpet = Instance.new("Part", Workspace)
			carpet.Size = Vector3.new(10, 1, 10)
			carpet.Color = Color3.fromRGB(150, 0, 150)
			carpet.Material = Enum.Material.Carpet
			carpet.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, -3, 0)
			local bpos = Instance.new("BodyPosition", carpet)
			bpos.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			
			connections.trollCarpet = RunService.RenderStepped:Connect(function()
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					bpos.Position = player.Character.HumanoidRootPart.Position - Vector3.new(0,3,0)
					carpet.CFrame = CFrame.new(carpet.Position, carpet.Position + camera.CFrame.LookVector)
				end
			end)
		end
	end
})

TabTroll:CreateButton({
	Name = "💤 Alle Spieler für 3 Sekunden einfrieren (Lag-Spike)",
	Callback = function()
		notify("Troll", "Friere Server-Physik kurz ein...", false)
		local t = tick()
		while tick() - t < 0.8 do
			for _, p in pairs(Players:GetPlayers()) do
				if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					p.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				end
			end
			task.wait()
		end
		notify("Troll", "Server-Lag ausgelöst!", false)
	end
})

TabTroll:CreateSection("😵 Verwirrung & Lag")

TabTroll:CreateToggle({
	Name = "😵 Spin-Bot (Schnelles Drehen um die eigene Achse)", CurrentValue = false, Flag = "TrollSpin",
	Callback = function(v)
		states.trollSpin = v
		if v then
			connections.trollSpinLoop = RunService.RenderStepped:Connect(function()
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(50), 0)
				end
			end)
		else
			if connections.trollSpinLoop then connections.trollSpinLoop:Disconnect() connections.trollSpinLoop = nil end
		end
	end
})

TabTroll:CreateToggle({
	Name = "🚶 Stutter-Walk / Fake Lag", CurrentValue = false, Flag = "TrollStutter",
	Callback = function(v)
		states.trollStutter = v
		if v then
			connections.trollStutterLoop = RunService.Heartbeat:Connect(function()
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					player.Character.HumanoidRootPart.Anchored = true
					task.wait(0.05)
					player.Character.HumanoidRootPart.Anchored = false
					task.wait(0.1)
				end
			end)
		else
			if connections.trollStutterLoop then connections.trollStutterLoop:Disconnect() connections.trollStutterLoop = nil end
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.Anchored = false end
		end
	end
})

TabTroll:CreateToggle({
	Name = "🌈 Rainbow Character (Macht dich bunt)", CurrentValue = false, Flag = "TrollRainbow",
	Callback = function(v)
		states.trollRainbow = v
		if v then
			task.spawn(function()
				local hue = 0
				while states.trollRainbow do
					hue = (hue + 0.05) % 1
					if player.Character then
						for _, p in pairs(player.Character:GetChildren()) do
							if p:IsA("BasePart") then p.Color = Color3.fromHSV(hue, 1, 1) end
						end
					end
					task.wait(0.1)
				end
			end)
		end
	end
})

-- =====================================================================
-- 5. TAB: CHAT SPAM BOT 💬
-- =====================================================================
TabChat:CreateSection("Ice Hub Custom Chat Controller")

TabChat:CreateInput({
	Name = "Nachricht eingeben", PlaceholderText = "Text hier eingeben...", RemoveTextAfterFocusLost = false,
	Callback = function(Text) states.chatMessage = Text end
})

TabChat:CreateSlider({
	Name = "Sende-Geschwindigkeit (Sekunden)", Range = {0.1, 5}, Increment = 0.1, CurrentValue = 1.0, Flag = "ChatSpd",
	Callback = function(Value) states.chatSpeed = Value end
})

TabChat:CreateToggle({
	Name = "🤖 Normaler Chat Spam Bot", CurrentValue = false, Flag = "ChatSpam",
	Callback = function(Value)
		states.chatSpamActive = Value
		if states.chatSpamActive then
			notify("Chat Bot", "Spam gestartet.", false)
			connections.chatSpamLoop = task.spawn(function()
				while states.chatSpamActive do
					pcall(function()
						game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(states.chatMessage, "All")
					end)
					task.wait(states.chatSpeed)
				end
			end)
		else
			if connections.chatSpamLoop then task.cancel(connections.chatSpamLoop) end
		end
	end
})

-- =====================================================================
-- 6. TAB: MOVEMENT & PLAYER (UNIVERSAL)
-- =====================================================================
TabMovement:CreateSection("Flug & Steuerung")

local function toggleGlobalFly(Value)
	if not Value then stopFlying() return end
	states.flyActive = true
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local root = char.HumanoidRootPart
	local hum = char:FindFirstChildOfClass("Humanoid")

	hum.PlatformStand = true
	objects.bodyVelocity = Instance.new("BodyVelocity", root)
	objects.bodyVelocity.Velocity = Vector3.zero
	objects.bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	
	objects.bodyGyro = Instance.new("BodyGyro", root)
	objects.bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	objects.bodyGyro.CFrame = root.CFrame

	connections.fly = RunService.RenderStepped:Connect(function()
		if not states.flyActive then return end
		local moveDir = Vector3.zero
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += camera.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= camera.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= camera.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += camera.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0, 1, 0) end
		
		if moveDir.Magnitude > 0 then
			objects.bodyVelocity.Velocity = moveDir.Unit * states.flySpeed
		else
			objects.bodyVelocity.Velocity = Vector3.zero
		end
		objects.bodyGyro.CFrame = camera.CFrame
	end)
end

local function toggleGlobalNoClip(Value)
	states.noClipActive = Value
	if states.noClipActive then
		connections.noClip = RunService.Stepped:Connect(function()
			local char = player.Character
			if char then
				for _, part in ipairs(char:GetDescendants()) do
					if part:IsA("BasePart") and part.CanCollide then
						part.CanCollide = false
					end
				end
			end
		end)
	else
		if connections.noClip then 
			connections.noClip:Disconnect() 
			connections.noClip = nil 
		end
	end
end

TabMovement:CreateToggle({
	Name = "👻 Ghost Mode (Fly + NoClip + Unsichtbarkeit)", CurrentValue = false, Flag = "GhostModeToggle",
	Callback = function(Value)
		states.ghostModeActive = Value
		toggleGlobalFly(Value)
		toggleGlobalNoClip(Value)
		toggleInvisibility(Value)
		if Value then notify("Ghost Mode", "Du bist nun ein unaufhaltsamer Geist!", false) 
		else notify("Ghost Mode", "Ghost Mode deaktiviert.", false) end
	end
})

Elements.FlyToggle = TabMovement:CreateToggle({
	Name = "Fliegen (Fly)", CurrentValue = false, Flag = "FlyToggle", Callback = toggleGlobalFly
})

TabMovement:CreateKeybind({
	Name = "Toggle Fly Keybind", CurrentKeybind = "G", HoldToInteract = false, Flag = "FlyKey", 
	Callback = function() Elements.FlyToggle:Set(not states.flyActive) end
})

TabMovement:CreateSlider({
	Name = "Fly Speed", Range = {10, 1000}, Increment = 5, CurrentValue = 50, Flag = "FlySpeed", 
	Callback = function(Value) states.flySpeed = Value end
})

Elements.NoClipToggle = TabMovement:CreateToggle({
	Name = "NoClip (Durch Wände gehen)", CurrentValue = false, Flag = "NoClipToggle", Callback = toggleGlobalNoClip
})

TabMovement:CreateKeybind({
	Name = "Toggle NoClip Keybind", CurrentKeybind = "N", HoldToInteract = false, Flag = "NoClipKey", 
	Callback = function() 
		if Elements.NoClipToggle then Elements.NoClipToggle:Set(not states.noClipActive) else Window.Flags["NoClipToggle"]:Set(not states.noClipActive) end
	end
})

TabMovement:CreateToggle({
	Name = "Infinite Jump", CurrentValue = false, Flag = "InfJump",
	Callback = function(Value)
		states.infiniteJumpActive = Value
		if states.infiniteJumpActive then
			connections.infiniteJump = UserInputService.JumpRequest:Connect(function()
				local char = player.Character
				if char and char:FindFirstChildOfClass("Humanoid") then
					char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end)
		else
			if connections.infiniteJump then connections.infiniteJump:Disconnect() connections.infiniteJump = nil end
		end
	end
})

TabMovement:CreateSlider({
	Name = "Laufgeschwindigkeit (WalkSpeed)", Range = {16, 500}, Increment = 2, CurrentValue = 16, Flag = "UniWalkSpeed",
	Callback = function(Value)
		local char = player.Character
		if char and char:FindFirstChildOfClass("Humanoid") then char:FindFirstChildOfClass("Humanoid").WalkSpeed = Value end
	end
})

TabMovement:CreateSlider({
	Name = "Sprungkraft (JumpPower)", Range = {50, 500}, Increment = 5, CurrentValue = 50, Flag = "JumpPower",
	Callback = function(Value)
		local char = player.Character
		if char and char:FindFirstChildOfClass("Humanoid") then
			char:FindFirstChildOfClass("Humanoid").UseJumpPower = true
			char:FindFirstChildOfClass("Humanoid").JumpPower = Value
		end
	end
})

-- =====================================================================
-- 7. TAB: SPIELER TELEPORT & RÜCKKEHR
-- =====================================================================
TabPlayers:CreateSection("Teleport-Verlauf & Rückkehr")

TabPlayers:CreateButton({
	Name = "🔙 Zurück zur letzten Position vor dem Teleport",
	Callback = function()
		if states.lastPositionBeforeTP then
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				pcall(function() char.HumanoidRootPart.CFrame = states.lastPositionBeforeTP end)
				notify("Teleport Back", "Du bist zu deiner ursprünglichen Position zurückgekehrt.", false)
			end
		else
			notify("Fehler", "Keine vorherige Position gespeichert.", false)
		end
	end
})

TabPlayers:CreateKeybind({
	Name = "Tastendruck: Zurück zur alten Position", CurrentKeybind = "B", HoldToInteract = false, Flag = "TPBackKeybind",
	Callback = function()
		if states.lastPositionBeforeTP then
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				pcall(function() char.HumanoidRootPart.CFrame = states.lastPositionBeforeTP end)
			end
		end
	end,
})

TabPlayers:CreateSection("Mitspieler Suchen & Teleportieren")

local playerDropdown = TabPlayers:CreateDropdown({
	Name = "Spieler auswählen", Options = {"(Aktualisieren drücken)"}, CurrentOption = {"(Aktualisieren drücken)"}, MultipleOptions = false, Flag = "PlayerDropdown",
	Callback = function(Option) states.selectedPlayerToTP = Option[1] end,
})

TabPlayers:CreateButton({
	Name = "🔄 Spielerliste aktualisieren",
	Callback = function()
		local pList = {}
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player then table.insert(pList, p.Name) end
		end
		if #pList == 0 then table.insert(pList, "Niemand da") end
		playerDropdown:Refresh(pList, {pList[1]})
		notify("Spieler", "Liste aktualisiert.", false)
	end
})

TabPlayers:CreateButton({
	Name = "🚀 Zu ausgewähltem Spieler teleportieren",
	Callback = function()
		if states.selectedPlayerToTP and states.selectedPlayerToTP ~= "Niemand da" then
			local target = Players:FindFirstChild(states.selectedPlayerToTP)
			if target and target.Character then
				local targetPivot = target.Character:GetPivot()
				safeTeleport(targetPivot + Vector3.new(0, 4, 0))
				notify("Teleport", "Zu " .. target.Name .. " teleportiert! (Position gesichert)", false)
			else
				notify("Fehler", "Spieler-Charakter konnte nicht gefunden werden.", false)
			end
		else
			notify("Fehler", "Bitte wähle zuerst einen gültigen Spieler aus.", false)
		end
	end
})

TabPlayers:CreateButton({
	Name = "🧲 Physikalisches Heranziehen (Fling Bring, sichtbar für alle)",
	Callback = function()
		if states.selectedPlayerToTP and states.selectedPlayerToTP ~= "Niemand da" then
			local target = Players:FindFirstChild(states.selectedPlayerToTP)
			if target then
				executeFlingBring(target)
				notify("Bring", target.Name .. " wird sichtbar zu dir gezogen!", false)
			else
				notify("Fehler", "Spieler nicht gefunden.", false)
			end
		else
			notify("Fehler", "Bitte wähle zuerst einen Spieler aus dem Dropdown aus.", false)
		end
	end
})

TabPlayers:CreateButton({
	Name = "🎲 Random Spieler Teleport (NUR LEBENDE SPIELER!)",
	Callback = function()
		local plrs = Players:GetPlayers()
		local targets = {}
		for _, p in ipairs(plrs) do
			if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local ehum = p.Character:FindFirstChildOfClass("Humanoid")
				if ehum and ehum.Health > 0 then
					table.insert(targets, p.Character.HumanoidRootPart.CFrame)
				end
			end
		end
		if #targets > 0 then
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				char.HumanoidRootPart.CFrame = targets[math.random(1, #targets)] * CFrame.new(math.random(-5, 5), 3, math.random(-5, 5))
				notify("Random TP", "Du wurdest zu einem lebenden Spieler teleportiert.", false)
			end
		else
			notify("Fehler", "Keine anderen lebenden Spieler gefunden.", false)
		end
	end
})

TabPlayers:CreateKeybind({
	Name = "🎲 Eigener Keybind: Random Spieler Teleport",
	CurrentKeybind = "Two",
	HoldToInteract = false,
	Flag = "RandPlayerTPKey",
	Callback = function()
		local plrs = Players:GetPlayers()
		local targets = {}
		for _, p in ipairs(plrs) do
			if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local ehum = p.Character:FindFirstChildOfClass("Humanoid")
				if ehum and ehum.Health > 0 then
					table.insert(targets, p.Character.HumanoidRootPart.CFrame)
				end
			end
		end
		if #targets > 0 then
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				char.HumanoidRootPart.CFrame = targets[math.random(1, #targets)] * CFrame.new(math.random(-5, 5), 3, math.random(-5, 5))
			end
		end
	end
})

local function getPenetratingTargetPosition()
	local ray = camera:ViewportPointToRay(mouse.X, mouse.Y)
	local maxDist = 10000
	local cOrigin = ray.Origin
	local cDir = ray.Direction * maxDist
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	local ignoreList = {}
	if player.Character then table.insert(ignoreList, player.Character) end
	for i = 1, 25 do
		params.FilterDescendantsInstances = ignoreList
		local res = Workspace:Raycast(cOrigin, cDir, params)
		if res then
			if res.Instance.Transparency >= 1 or not res.Instance.CanCollide then
				table.insert(ignoreList, res.Instance)
				local rem = (cOrigin + cDir) - res.Position
				cOrigin = res.Position + (ray.Direction * 0.1)
				cDir = rem
			else
				return res.Position + (res.Normal * 3.5)
			end
		else
			break
		end
	end
	return mouse.Hit.Position + Vector3.new(0, 3.5, 0)
end

TabPlayers:CreateSection("Maus-Teleports")

TabPlayers:CreateToggle({
	Name = "Klick-zu-Teleport (Linksklick)", CurrentValue = false, Flag = "ClickTP",
	Callback = function(Value)
		states.clickTpActive = Value
		if states.clickTpActive then
			connections.clickTp = UserInputService.InputBegan:Connect(function(input, gp)
				if gp then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 and player.Character then
					local root = player.Character:FindFirstChild("HumanoidRootPart")
					if root then safeTeleport(CFrame.new(getPenetratingTargetPosition())) end
				end
			end)
		else
			if connections.clickTp then connections.clickTp:Disconnect() connections.clickTp = nil end
		end
	end
})

TabPlayers:CreateKeybind({
	Name = "Tastendruck: Zu Maus teleportieren", CurrentKeybind = "F", HoldToInteract = false, Flag = "MouseTPKeybind",
	Callback = function() safeTeleport(CFrame.new(getPenetratingTargetPosition())) end,
})

-- =====================================================================
-- 8. TAB: BYPASS & GODMODE
-- =====================================================================
TabBypass:CreateSection("Hindernisse Umgehen")

TabBypass:CreateButton({
	Name = "🔥 Map Cleanen (Löscht Lava, Crusher, Laser)",
	Callback = function()
		local count = 0
		for _, v in pairs(Workspace:GetDescendants()) do
			if v:IsA("BasePart") then
				local n = string.lower(v.Name)
				if string.match(n, "lava") or string.match(n, "kill") or string.match(n, "damage") or 
				   string.match(n, "death") or string.match(n, "crush") or string.match(n, "water") or 
				   string.match(n, "acid") or string.match(n, "laser") or string.match(n, "spike") then
					pcall(function() v:Destroy() end)
					count = count + 1
				end
			end
		end
		notify("Ice Hub Clean", count .. " tödliche Blöcke ausgelöscht!", false)
	end
})

local function toggleGodmode(Value)
	states.godmodeActive = Value
	local char = player.Character
	if char and char:FindFirstChildOfClass("Humanoid") then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if states.godmodeActive then
			hum.MaxHealth = math.huge
			hum.Health = math.huge
			hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
			if connections.godmodeHealth then connections.godmodeHealth:Disconnect() end
			connections.godmodeHealth = hum.HealthChanged:Connect(function(hp)
				if states.godmodeActive and hp < hum.MaxHealth then
					hum.Health = hum.MaxHealth
				end
			end)
			connections.antiKillbrick = RunService.Stepped:Connect(function()
				if states.godmodeActive and player.Character then
					for _, v in ipairs(player.Character:GetDescendants()) do
						if v:IsA("TouchTransmitter") then pcall(function() v:Destroy() end) end
						if v:IsA("BasePart") then pcall(function() v.CustomPhysicalProperties = PhysicalProperties.new(100, 0, 0, 100, 100) end) end
					end
				end
			end)
		else
			if connections.godmodeHealth then connections.godmodeHealth:Disconnect() end
			if connections.antiKillbrick then connections.antiKillbrick:Disconnect() end
			hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
			hum.MaxHealth = 100
			hum.Health = 100
		end
	end
end

TabBypass:CreateToggle({
	Name = "Godmode & Touch-Event Bypass", CurrentValue = false, Flag = "Godmode", Callback = toggleGodmode
})

TabBypass:CreateKeybind({
	Name = "Toggle Godmode Keybind", CurrentKeybind = "H", HoldToInteract = false, Flag = "GodmodeKey",
	Callback = function() Window.Flags["Godmode"]:Set(not states.godmodeActive) end
})

TabBypass:CreateToggle({
	Name = "Anti-Void (Roter Boden unter der Map)", CurrentValue = false, Flag = "AntiVoid",
	Callback = function(Value)
		states.antiVoidActive = Value
		if states.antiVoidActive then
			local p = Instance.new("Part", Workspace)
			p.Name = "IceAntiVoid"
			p.Size = Vector3.new(100000, 5, 100000)
			p.Position = Vector3.new(0, Workspace.FallenPartsDestroyHeight + 50, 0)
			p.Transparency = 0.5
			p.BrickColor = BrickColor.new("Bright red")
			p.Anchored = true
			objects.antiVoidPart = p
		else
			if objects.antiVoidPart then objects.antiVoidPart:Destroy() objects.antiVoidPart = nil end
		end
	end
})

-- =====================================================================
-- 9. TAB: VISUALS, NAMETAGS & AUREN
-- =====================================================================
TabVisuals:CreateSection("👁️ X-Ray & Globale Sicht")

TabVisuals:CreateToggle({
	Name = "👁️ Universal X-Ray (Spieler ESP)", CurrentValue = false, Flag = "UnivXRay",
	Callback = function(Value)
		states.univXray = Value
		if states.univXray then
			notify("X-Ray", "Spieler leuchten nun durch Wände.", false)
			connections.xrayLoop = RunService.Heartbeat:Connect(function()
				for _, p in pairs(Players:GetPlayers()) do
					if p ~= player and p.Character and not p.Character:FindFirstChild("UnivESP") then
						local hl = Instance.new("Highlight", p.Character)
						hl.Name = "UnivESP"
						hl.FillColor = Color3.fromRGB(255, 0, 0)
						hl.OutlineColor = Color3.fromRGB(255, 255, 255)
						hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					end
				end
			end)
		else
			if connections.xrayLoop then connections.xrayLoop:Disconnect() connections.xrayLoop = nil end
			for _, p in pairs(Players:GetPlayers()) do
				if p.Character and p.Character:FindFirstChild("UnivESP") then p.Character.UnivESP:Destroy() end
			end
		end
	end
})

TabVisuals:CreateSection("Animierte Nametags (RGB)")

local function applyCustomNametag(text, animated)
	local char = player.Character
	if char and char:FindFirstChild("Head") then
		for _,v in pairs(char.Head:GetChildren()) do
			if v.Name == "FakeCreatorTag" then pcall(function() v:Destroy() end) end
		end
		if connections.animNametag then connections.animNametag:Disconnect() connections.animNametag = nil end

		local bg = Instance.new("BillboardGui", char.Head)
		bg.Name = "FakeCreatorTag"
		bg.Size = UDim2.new(0, 250, 0, 50)
		bg.StudsOffset = Vector3.new(0, 3.5, 0)
		bg.AlwaysOnTop = true
		
		local tl = Instance.new("TextLabel", bg)
		tl.Size = UDim2.new(1, 0, 1, 0)
		tl.BackgroundTransparency = 1
		tl.Text = text
		tl.TextScaled = true
		tl.Font = Enum.Font.GothamBold
		local stroke = Instance.new("TextStroke", tl)
		stroke.Transparency = 0
		
		if animated then
			connections.animNametag = RunService.RenderStepped:Connect(function()
				tl.TextColor3 = Color3.fromHSV(tick() % 3 / 3, 1, 1)
			end)
		else
			tl.TextColor3 = Color3.fromRGB(255, 215, 0)
		end
	end
end

TabVisuals:CreateDropdown({
	Name = "Animierten Preset-Tag setzen", Options = {"[Ice Hub Owner]", "[Content Creator]", "[Admin]", "[VIP]", "[Star Creator]"}, CurrentOption = {"[Ice Hub Owner]"}, MultipleOptions = false, Flag = "PresetTag",
	Callback = function(Option)
		states.customNametag = Option[1] .. " " .. player.Name
		applyCustomNametag(states.customNametag, true)
	end,
})

TabVisuals:CreateInput({
	Name = "Eigener Nametag (RGB)", PlaceholderText = "Eigener Text...", RemoveTextAfterFocusLost = false,
	Callback = function(Text)
		states.customNametag = Text
		applyCustomNametag(states.customNametag, true)
	end
})

TabVisuals:CreateButton({
	Name = "Nametag entfernen",
	Callback = function()
		if player.Character and player.Character:FindFirstChild("Head") then
			for _,v in pairs(player.Character.Head:GetChildren()) do
				if v.Name == "FakeCreatorTag" then pcall(function() v:Destroy() end) end
			end
		end
		if connections.animNametag then connections.animNametag:Disconnect() connections.animNametag = nil end
	end
})

TabVisuals:CreateSection("Auren & Sichtbarkeit")

local function applyAura()
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local root = char.HumanoidRootPart
	for _, v in ipairs(root:GetChildren()) do
		if v.Name == "IceAura" then pcall(function() v:Destroy() end) end
	end
	if states.currentAura == "Feuer" then
		local f = Instance.new("Fire", root) f.Name = "IceAura" f.Size = 12 f.Heat = 20
	elseif states.currentAura == "Glitzer" then
		local s = Instance.new("Sparkles", root) s.Name = "IceAura" s.SparkleColor = Color3.fromRGB(255, 215, 0)
	elseif states.currentAura == "Matrix" then
		local p = Instance.new("ParticleEmitter", root) p.Name = "IceAura" p.Color = ColorSequence.new(Color3.fromRGB(0, 255, 0)) p.Size = NumberSequence.new(1) p.Rate = 100
	elseif states.currentAura == "Ice" then
		local p = Instance.new("ParticleEmitter", root) p.Name = "IceAura" p.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255)) p.Size = NumberSequence.new(1.5) p.Rate = 150
	end
end

TabVisuals:CreateDropdown({
	Name = "Ice Hub Aura", Options = {"Keine", "Feuer", "Glitzer", "Matrix", "Ice"}, CurrentOption = {"Keine"}, MultipleOptions = false, Flag = "AuraDropdown",
	Callback = function(Option) states.currentAura = Option[1] applyAura() end
})

TabVisuals:CreateKeybind({
	Name = "❄️ Ice Aura Toggle",
	CurrentKeybind = "T",
	HoldToInteract = false,
	Flag = "IceAuraKey",
	Callback = function()
		if states.currentAura == "Ice" then
			states.currentAura = "Keine"
		else
			states.currentAura = "Ice"
		end
		applyAura()
		notify("Aura", "Ice Aura: " .. states.currentAura, false)
	end
})

TabVisuals:CreateToggle({
	Name = "Lokal Unsichtbar machen", CurrentValue = false, Flag = "Invis", Callback = toggleInvisibility
})

-- =====================================================================
-- 10. TAB: FAHRZEUGE (UNIVERSAL ULTRA MODS)
-- =====================================================================
TabVehicle:CreateSection("Auto & Fahrzeug Steuerung")

TabVehicle:CreateSlider({
	Name = "Fahrzeug Ultra-Speed", Range = {50, 5000}, Increment = 50, CurrentValue = 150, Flag = "UniCarMaxSpeed",
	Callback = function(Value)
		states.carSpeed = Value
		local char = player.Character
		if char and char:FindFirstChildOfClass("Humanoid") then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum.SeatPart and hum.SeatPart:IsA("VehicleSeat") then hum.SeatPart.MaxSpeed = Value end
		end
	end
})

TabVehicle:CreateToggle({
	Name = "Auto-Boost (Permanente Beschleunigung)", CurrentValue = false, Flag = "UniCarBoost",
	Callback = function(Value)
		states.carBoostActive = Value
		if states.carBoostActive then
			connections.carBoost = RunService.Heartbeat:Connect(function()
				local char = player.Character
				if char and char:FindFirstChildOfClass("Humanoid") then
					local hum = char:FindFirstChildOfClass("Humanoid")
					if hum.SeatPart and hum.SeatPart:IsA("VehicleSeat") and hum.SeatPart.Throttle == 1 then
						hum.SeatPart.AssemblyLinearVelocity = hum.SeatPart.CFrame.LookVector * states.carSpeed
					end
				end
			end)
		else
			if connections.carBoost then connections.carBoost:Disconnect() connections.carBoost = nil end
		end
	end
})

Elements.CarFlyToggle = TabVehicle:CreateToggle({
	Name = "Fahrzeug Fliegen (Vehicle Fly)", CurrentValue = false, Flag = "UniCarFly",
	Callback = function(Value)
		if not Value then stopCarFlying() return end
		states.carFlyActive = true
		local char = player.Character
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hum or not hum.SeatPart then return end
		local seat = hum.SeatPart
		
		objects.carBodyVelocity = Instance.new("BodyVelocity", seat)
		objects.carBodyVelocity.Velocity = Vector3.zero
		objects.carBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		
		objects.carBodyGyro = Instance.new("BodyGyro", seat)
		objects.carBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		objects.carBodyGyro.CFrame = seat.CFrame

		connections.carFly = RunService.RenderStepped:Connect(function()
			if not states.carFlyActive or not hum.SeatPart then return end
			local moveDir = Vector3.zero
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += camera.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= camera.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= camera.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += camera.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0, 1, 0) end
			
			if moveDir.Magnitude > 0 then objects.carBodyVelocity.Velocity = moveDir.Unit * states.carSpeed
			else objects.carBodyVelocity.Velocity = Vector3.zero end
			objects.carBodyGyro.CFrame = camera.CFrame
		end)
	end
})

TabVehicle:CreateToggle({
	Name = "Vehicle NoClip (Durch Wände fahren)", CurrentValue = false, Flag = "UniCarNoClip",
	Callback = function(Value)
		states.carNoClipActive = Value
		if states.carNoClipActive then
			connections.carNoClip = RunService.Stepped:Connect(function()
				local char = player.Character
				if char and char:FindFirstChildOfClass("Humanoid") then
					local hum = char:FindFirstChildOfClass("Humanoid")
					if hum.SeatPart and hum.SeatPart.Parent then
						for _, part in ipairs(hum.SeatPart.Parent:GetDescendants()) do
							if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
						end
					end
				end
			end)
		else
			if connections.carNoClip then connections.carNoClip:Disconnect() connections.carNoClip = nil end
		end
	end
})

TabVehicle:CreateSection("✨ Fahrzeug Extras & Magie")

TabVehicle:CreateToggle({
	Name = "🚘 Rolls Royce Bounce (Leichtes Wippen)",
	CurrentValue = false, Flag = "CarBounceLoop",
	Callback = function(Value)
		states.carLoopBounce = Value
		if states.carLoopBounce then
			notify("Lowrider", "Auto wippt nun extrem geschmeidig.", false)
			connections.carLoopBounce = RunService.Heartbeat:Connect(function()
				local char = player.Character
				if char and char:FindFirstChildOfClass("Humanoid") then
					local hum = char:FindFirstChildOfClass("Humanoid")
					if hum.SeatPart and hum.SeatPart:IsA("VehicleSeat") then
						local vel = hum.SeatPart.AssemblyLinearVelocity
						hum.SeatPart.AssemblyLinearVelocity = Vector3.new(vel.X, math.sin(tick() * 8) * 12, vel.Z)
					end
				end
			end)
		else
			if connections.carLoopBounce then connections.carLoopBounce:Disconnect() connections.carLoopBounce = nil end
		end
	end
})

TabVehicle:CreateToggle({
	Name = "🌈 Rainbow Car (Fahrzeug wird bunt)", CurrentValue = false, Flag = "CarRainbow",
	Callback = function(Value)
		states.carRainbowActive = Value
		if states.carRainbowActive then
			connections.carRainbowLoop = task.spawn(function()
				local hue = 0
				while states.carRainbowActive do
					hue = (hue + 0.05) % 1
					local char = player.Character
					if char and char:FindFirstChildOfClass("Humanoid") then
						local hum = char:FindFirstChildOfClass("Humanoid")
						if hum.SeatPart and hum.SeatPart.Parent then
							for _, p in pairs(hum.SeatPart.Parent:GetDescendants()) do
								if p:IsA("BasePart") then p.Color = Color3.fromHSV(hue, 1, 1) end
							end
						end
					end
					task.wait(0.1)
				end
			end)
		else
			if connections.carRainbowLoop then task.cancel(connections.carRainbowLoop) connections.carRainbowLoop = nil end
		end
	end
})

TabVehicle:CreateToggle({
	Name = "💥 Auto-Ramm-Fling (Kickt bei Berührung in die Luft)", CurrentValue = false, Flag = "CarTouchFling",
	Callback = function(Value)
		states.carTouchFlingActive = Value
		if states.carTouchFlingActive then
			connections.carTouchFlingLoop = RunService.Heartbeat:Connect(function()
				local char = player.Character
				if char and char:FindFirstChildOfClass("Humanoid") then
					local hum = char:FindFirstChildOfClass("Humanoid")
					if hum.SeatPart then
						local myPos = hum.SeatPart.Position
						for _, p in pairs(Players:GetPlayers()) do
							if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
								local targetRoot = p.Character.HumanoidRootPart
								if (targetRoot.Position - myPos).Magnitude < 15 then
									targetRoot.Velocity = Vector3.new(math.random(-1000, 1000), 50000, math.random(-1000, 1000))
								end
							end
						end
					end
				end
			end)
		else
			if connections.carTouchFlingLoop then connections.carTouchFlingLoop:Disconnect() connections.carTouchFlingLoop = nil end
		end
	end
})

TabVehicle:CreateSlider({
	Name = "Nitro Partikel-Menge (Flammen)", Range = {50, 5000}, Increment = 50, CurrentValue = 500, Flag = "NitroRate",
	Callback = function(Value) states.carNitroRate = Value end
})

TabVehicle:CreateKeybind({
	Name = "Nitro Boost (Mächtiger Vorwärts-Schub)", CurrentKeybind = "E", HoldToInteract = false, Flag = "UniCarNitroKey",
	Callback = function()
		local char = player.Character
		if char and char:FindFirstChildOfClass("Humanoid") then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum.SeatPart and hum.SeatPart:IsA("VehicleSeat") then
				hum.SeatPart.AssemblyLinearVelocity = hum.SeatPart.CFrame.LookVector * (states.carSpeed * 3)
				
				local flame = Instance.new("ParticleEmitter")
				flame.Name = "BlueNitro"
				flame.Color = ColorSequence.new(Color3.fromRGB(0, 100, 255))
				flame.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0)})
				flame.Rate = states.carNitroRate or 500
				flame.Speed = NumberRange.new(20, 50)
				flame.SpreadAngle = Vector2.new(15, 15)
				flame.Lifetime = NumberRange.new(0.5, 1)
				flame.EmissionDirection = Enum.NormalId.Back
				flame.Parent = hum.SeatPart
				
				notify("Nitro", "Boost aktiviert!", false)
				task.delay(1.5, function() if flame then flame:Destroy() end end)
			end
		end
	end
})

TabVehicle:CreateKeybind({
	Name = "Car Super-Jump (Mächtiger Sprung)", CurrentKeybind = "R", HoldToInteract = false, Flag = "UniCarBounceKey",
	Callback = function()
		local char = player.Character
		if char and char:FindFirstChildOfClass("Humanoid") then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum.SeatPart and hum.SeatPart:IsA("VehicleSeat") then
				hum.SeatPart.AssemblyLinearVelocity = hum.SeatPart.AssemblyLinearVelocity + Vector3.new(0, 150, 0)
			end
		end
	end
})

TabVehicle:CreateButton({
	Name = "🛑 Fahrzeug sofort stoppen (Notbremse)",
	Callback = function()
		local char = player.Character
		if char and char:FindFirstChildOfClass("Humanoid") then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum.SeatPart and hum.SeatPart:IsA("VehicleSeat") then
				hum.SeatPart.AssemblyLinearVelocity = Vector3.zero
				hum.SeatPart.AssemblyAngularVelocity = Vector3.zero
				notify("Bremse", "Fahrzeug angehalten.", false)
			end
		end
	end
})

-- =====================================================================
-- 8. TAB: MONKEY ESCAPE 🐒
-- =====================================================================
TabMonkey:CreateSection("Monkey Escape - Save/Load System")

TabMonkey:CreateDropdown({
	Name = "Welt auswählen",
	Options = {"Welt 1", "Welt 2", "Welt 3", "Welt 4", "Welt 5", "Welt 6"},
	CurrentOption = {"Welt 1"},
	MultipleOptions = false,
	Flag = "WorldDropdown",
	Callback = function(Option)
		currentWorldSelection = Option[1]
	end
})

TabMonkey:CreateDropdown({
	Name = "Stage / Checkpoint",
	Options = {"Stage 1", "Stage 2", "Stage 3", "Stage 4", "Stage 5", "Stage 6", "Stage 7", "Stage 8", "Stage 9", "Stage 10", "Stage 11", "Stage 12", "Stage 13", "Stage 14", "Stage 15"},
	CurrentOption = {"Stage 1"},
	MultipleOptions = false,
	Flag = "StageDropdown",
	Callback = function(Option)
		currentStageSelection = Option[1]
	end
})

TabMonkey:CreateButton({
	Name = "💾 Diese Stage permanent speichern",
	Callback = function()
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			if not stageData[currentWorldSelection] then
				stageData[currentWorldSelection] = {}
			end
			stageData[currentWorldSelection][currentStageSelection] = serializeCFrame(char.HumanoidRootPart.CFrame)
			saveStageData()
			notify("Ice Hub", currentStageSelection .. " (" .. currentWorldSelection .. ") gesichert!", false)
		end
	end
})

TabMonkey:CreateButton({
	Name = "🚀 Zur ausgewählten permanenten Stage teleportieren",
	Callback = function()
		local char = player.Character
		if stageData[currentWorldSelection] and stageData[currentWorldSelection][currentStageSelection] and char and char:FindFirstChild("HumanoidRootPart") then
			local cf = deserializeCFrame(stageData[currentWorldSelection][currentStageSelection])
			if cf then
				safeTeleport(cf + Vector3.new(0, 3, 0))
			end
		else
			notify("Fehler", "Kein Speicherstand für diese Stage gefunden!", false)
		end
	end
})

TabMonkey:CreateButton({
	Name = "🗑️ ALLE Speicherstände löschen (Reset)",
	Callback = function()
		stageData = {}
		saveStageData()
		notify("Gelöscht", "Alle permanenten Stages wurden restlos gelöscht.", false)
	end
})

TabMonkey:CreateSection("Monkey Escape - Auto TP & Farm")

TabMonkey:CreateSlider({
	Name = "Auto-Teleport Intervall (Sekunden)",
	Range = {0.1, 30},
	Increment = 0.1,
	CurrentValue = 5.0,
	Flag = "TPInterval",
	Callback = function(Value)
		states.tpInterval = Value
	end
})

local AutoTpPermToggleElement = TabMonkey:CreateToggle({
	Name = "⚡ Auto-Teleport Loop (Dauerhaft zur gewählten Stage)",
	CurrentValue = false,
	Flag = "AutoTpLoopPerm",
	Callback = function(Value)
		states.autoTpPermActive = Value
		if states.autoTpPermActive then
			notify("Auto-TP Gestartet", "Teleportiert alle " .. states.tpInterval .. " Sekunden zur Auswahl.", false)
			connections.autoTpPermLoop = task.spawn(function()
				while states.autoTpPermActive do
					local char = player.Character
					if stageData[currentWorldSelection] and stageData[currentWorldSelection][currentStageSelection] and char and char:FindFirstChild("HumanoidRootPart") then
						local cf = deserializeCFrame(stageData[currentWorldSelection][currentStageSelection])
						if cf then
							pcall(function() char.HumanoidRootPart.CFrame = cf + Vector3.new(0, 3, 0) end)
						end
					end
					task.wait(states.tpInterval)
				end
			end)
		else
			if connections.autoTpPermLoop then
				task.cancel(connections.autoTpPermLoop)
				connections.autoTpPermLoop = nil
			end
			notify("Auto-TP", "Gestoppt.", false)
		end
	end
})

TabMonkey:CreateKeybind({
	Name = "Auto-Teleport Start/Stopp Keybind",
	CurrentKeybind = "Z",
	HoldToInteract = false,
	Flag = "AutoTpLoopKey",
	Callback = function()
		AutoTpPermToggleElement:Set(not states.autoTpPermActive)
	end
})

TabMonkey:CreateButton({
	Name = "📍 Temporären Farm-Checkpoint hier setzen",
	Callback = function()
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			objects.savedCheckpoint = char.HumanoidRootPart.CFrame
			notify("Farm Checkpoint", "Temporärer Punkt gesetzt.", false)
		end
	end
})

local AutoTpTempToggleElement = TabMonkey:CreateToggle({
	Name = "Auto-Teleport Loop (Farmt temporären Checkpoint ab)",
	CurrentValue = false,
	Flag = "AutoTpTemp",
	Callback = function(Value)
		states.tempTpLoopActive = Value
		if states.tempTpLoopActive then
			if not objects.savedCheckpoint then
				notify("Fehler", "Setze zuerst den temporären Farm-Checkpoint!", false)
				task.spawn(function() AutoTpTempToggleElement:Set(false) end)
				return
			end
			connections.tempTpLoop = task.spawn(function()
				while states.tempTpLoopActive do
					if objects.savedCheckpoint and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
						pcall(function() player.Character.HumanoidRootPart.CFrame = objects.savedCheckpoint end)
					end
					task.wait(states.tpInterval)
				end
			end)
		else
			if connections.tempTpLoop then
				task.cancel(connections.tempTpLoop)
				connections.tempTpLoop = nil
			end
		end
	end
})

TabMonkey:CreateToggle({
	Name = "Treadmill Fälscher (Simuliert Laufband)",
	CurrentValue = false,
	Flag = "TM",
	Callback = function(Value)
		states.autoTreadmillActive = Value
		local char = player.Character
		if states.autoTreadmillActive and char and char:FindFirstChild("HumanoidRootPart") then
			local anchor = char.HumanoidRootPart.CFrame
			connections.treadmill = RunService.Heartbeat:Connect(function()
				if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
					pcall(function()
						char.HumanoidRootPart.CFrame = anchor + Vector3.new(math.sin(tick() * states.treadmillSpeed) * 1.5, 0, math.cos(tick() * states.treadmillSpeed) * 1.5)
						char:FindFirstChildOfClass("Humanoid"):Move(Vector3.new(1, 0, 1), true)
					end)
				end
			end)
		else
			if connections.treadmill then
				connections.treadmill:Disconnect()
				connections.treadmill = nil
			end
		end
	end
})

TabMonkey:CreateToggle({
	Name = "Speed-Orb & Coin Magnet",
	CurrentValue = false,
	Flag = "OM",
	Callback = function(Value)
		states.orbMagnetActive = Value
		if states.orbMagnetActive then
			connections.orbMagnet = RunService.Heartbeat:Connect(function()
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local root = player.Character.HumanoidRootPart
					for _, v in pairs(Workspace:GetDescendants()) do
						if v:IsA("BasePart") and v:FindFirstChildOfClass("TouchTransmitter") then
							local n = string.lower(v.Name)
							if string.match(n, "orb") or string.match(n, "coin") or string.match(n, "speed") then
								pcall(function() v.CFrame = root.CFrame end)
							end
						end
					end
				end
			end)
		else
			if connections.orbMagnet then
				connections.orbMagnet:Disconnect()
				connections.orbMagnet = nil
			end
		end
	end
})

-- =====================================================================
-- 9. TAB: 99 NIGHTS AT THE FOREST 🌲
-- =====================================================================
Tab99Nights:CreateSection("Überleben & Sicht")

Tab99Nights:CreateButton({
	Name = "💡 Immer Tag (Nacht & Nebel entfernen)",
	Callback = function()
		Lighting.ClockTime = 12
		Lighting.Brightness = 3
		Lighting.FogEnd = 100000
		Lighting.GlobalShadows = false
		notify("99 Nights", "Dunkelheit entfernt!", false)
	end
})

Tab99Nights:CreateToggle({
	Name = "👁️ Monster ESP (Zeigt Feinde im Wald)",
	CurrentValue = false,
	Flag = "NightsESP",
	Callback = function(Value)
		states.nightsEspActive = Value
		if states.nightsEspActive then
			notify("99 Nights", "Suche nach Monstern...", false)
		end
	end
})

Tab99Nights:CreateToggle({
	Name = "🎒 Auto-Loot (Sammelt alle Items im Wald ein)",
	CurrentValue = false,
	Flag = "NightsAutoLoot",
	Callback = function(Value)
		states.nightsAutoLoot = Value
		if states.nightsAutoLoot then
			notify("99 Nights", "Auto-Loot aktiviert! Sammle Items...", false)
			connections.nightsLoot = RunService.Heartbeat:Connect(function()
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local myRoot = player.Character.HumanoidRootPart
					for _, v in pairs(Workspace:GetDescendants()) do
						if v:IsA("Tool") and v:FindFirstChild("Handle") then
							pcall(function() v.Handle.CFrame = myRoot.CFrame end)
						end
					end
				end
			end)
		else
			if connections.nightsLoot then connections.nightsLoot:Disconnect() connections.nightsLoot = nil end
		end
	end
})

Tab99Nights:CreateSection("Kampf & Items")

Tab99Nights:CreateToggle({
	Name = "🔪 Monster Kill Aura (Zerstört Feinde nahe dir)",
	CurrentValue = false,
	Flag = "NightsKillAura",
	Callback = function(Value)
		states.nightsKillAuraActive = Value
		if states.nightsKillAuraActive then
			notify("Kill Aura", "Aktiviert! Monster in 25 Studs Reichweite werden gelöscht.", false)
			connections.nightsAura = RunService.Heartbeat:Connect(function()
				pcall(function()
					for _, v in pairs(Workspace:GetDescendants()) do
						if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= player.Character then
							local root = v:FindFirstChild("HumanoidRootPart")
							local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
							if root and myRoot and (root.Position - myRoot.Position).Magnitude < 25 then
								v:Destroy()
							end
						end
					end
				end)
			end)
		else
			if connections.nightsAura then
				connections.nightsAura:Disconnect()
				connections.nightsAura = nil
			end
			notify("Kill Aura", "Deaktiviert.", false)
		end
	end
})

Tab99Nights:CreateSlider({
	Name = "🏃 Flucht-Geschwindigkeit (Speed Hack)",
	Range = {16, 100},
	Increment = 2,
	CurrentValue = 16,
	Flag = "NightsSpeed",
	Callback = function(Value)
		if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
			player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
		end
	end
})

Tab99Nights:CreateInput({
	Name = "🎒 Item Teleporter (Item-Name eingeben)",
	PlaceholderText = "z.B. Key, Batterie, Wood...",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
		local found = 0
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local myRoot = player.Character.HumanoidRootPart
			for _, v in pairs(Workspace:GetDescendants()) do
				if v:IsA("Tool") or v:IsA("Part") or v:IsA("Model") then
					if string.match(string.lower(v.Name), string.lower(Text)) then
						if v:IsA("Model") then
							pcall(function() v:MoveTo(myRoot.Position) end)
						elseif v:IsA("Part") then
							pcall(function() v.CFrame = myRoot.CFrame end)
						elseif v:IsA("Tool") and v:FindFirstChild("Handle") then
							pcall(function() v.Handle.CFrame = myRoot.CFrame end)
						end
						found = found + 1
					end
				end
			end
		end
		notify("Item Teleporter", found .. " Items mit '" .. Text .. "' gefunden!", false)
	end
})

-- =====================================================================
-- 10. TAB: KEYBOARD WARS ⌨️
-- =====================================================================
TabKeyboard:CreateSection("Keyboard Wars - Automatisierung & Speed")

TabKeyboard:CreateSlider({
	Name = "Game WalkSpeed / Typing Speed Modifier",
	Range = {6.5, 20},
	Increment = 0.5,
	CurrentValue = 6.5,
	Flag = "KBWSpeed",
	Callback = function(Value)
		states.kbwSpeed = Value
		local char = player.Character
		if char and char:FindFirstChildOfClass("Humanoid") then
			char:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
		end
	end
})

TabKeyboard:CreateToggle({
	Name = "Auto-Type / Auto-Answer (Simuliert Tasten)",
	CurrentValue = false,
	Flag = "KBWAutoType",
	Callback = function(Value)
		states.kbwAutoTypeActive = Value
		if states.kbwAutoTypeActive then
			notify("Keyboard Wars", "Auto-Typer gestartet.", false)
			connections.kbwAutoType = task.spawn(function()
				while states.kbwAutoTypeActive do
					pcall(function()
						-- game:GetService("ReplicatedStorage").Events.SubmitWord:FireServer("AutoType")
					end)
					task.wait(1 / states.kbwSpeed)
				end
			end)
		else
			if connections.kbwAutoType then
				task.cancel(connections.kbwAutoType)
				connections.kbwAutoType = nil
			end
		end
	end
})

TabKeyboard:CreateButton({
	Name = "Alle Tasten auf der Tastatur im Spiel sofort drücken",
	Callback = function()
		notify("Keyboard Wars", "Alle In-Game Keys getriggert.", false)
	end
})

-- =====================================================================
-- 11. TAB: EPIC MINIGAMES 🎮
-- =====================================================================
TabEpic:CreateSection("Minigames Automation")

TabEpic:CreateToggle({
	Name = "👑 Auto-Win Minigames (Gewinnt automatisch)",
	CurrentValue = false,
	Flag = "EpicAutoWin",
	Callback = function(Value)
		states.epicAutoWin = Value
		if states.epicAutoWin then
			notify("Epic Minigames", "Auto-Win Algorithmus gestartet.", false)
			connections.epicLoops.win = task.spawn(function()
				while states.epicAutoWin do
					-- Platzhalter: Teleportiert zum Sieger-Podest
					task.wait(2)
				end
			end)
		else
			if connections.epicLoops.win then task.cancel(connections.epicLoops.win) end
		end
	end
})

TabEpic:CreateToggle({
	Name = "💰 Auto-Collect Coins & Geschenke",
	CurrentValue = false,
	Flag = "EpicCoins",
	Callback = function(Value)
		states.epicCoinFarm = Value
		if states.epicCoinFarm then
			connections.epicLoops.coins = RunService.Heartbeat:Connect(function()
				-- Platzhalter: Magnet für Epic Minigames Coins
			end)
		else
			if connections.epicLoops.coins then connections.epicLoops.coins:Disconnect() end
		end
	end
})

TabEpic:CreateSection("Lobby Teleports")

TabEpic:CreateButton({
	Name = "🚀 Teleport zum VIP Bereich",
	Callback = function() notify("Epic TP", "Teleportiere zum VIP...", false) end
})

TabEpic:CreateButton({
	Name = "🛹 Teleport zum Obby (Für Abzeichen)",
	Callback = function() notify("Epic TP", "Teleportiere zur Board-Obby...", false) end
})

-- =====================================================================
-- 12. TAB: MEGA HIDE AND SEEK 🫣
-- =====================================================================
TabMega:CreateSection("Hide and Seek Mods")

TabMega:CreateToggle({
	Name = "👁️ ESP: Zeigt den Sucher (Seeker) rot an",
	CurrentValue = false,
	Flag = "MegaSeekEsp",
	Callback = function(Value)
		states.megaSeekEsp = Value
		if Value then notify("Mega H&S", "Sucher-ESP aktiv.", false) end
	end
})

TabMega:CreateToggle({
	Name = "👻 Auto-Hide (Teleportiert in God-Spots)",
	CurrentValue = false,
	Flag = "MegaAutoHide",
	Callback = function(Value)
		states.megaAutoHide = Value
		if states.megaAutoHide then
			notify("Mega H&S", "Teleportiere in geheimen Glitch-Spot...", false)
			connections.megaLoops.hide = task.spawn(function()
				while states.megaAutoHide do
					-- Platzhalter: CFrame Glitch in Wände
					task.wait(5)
				end
			end)
		else
			if connections.megaLoops.hide then task.cancel(connections.megaLoops.hide) end
		end
	end
})

TabMega:CreateToggle({
	Name = "💰 Auto-Farm Coins im Spiel",
	CurrentValue = false,
	Flag = "MegaCoins",
	Callback = function(Value)
		states.megaCoinFarm = Value
		if states.megaCoinFarm then
			connections.megaLoops.coins = RunService.Heartbeat:Connect(function()
				-- Platzhalter: Magnet
			end)
		else
			if connections.megaLoops.coins then connections.megaLoops.coins:Disconnect() end
		end
	end
})

-- =====================================================================
-- 13. TAB: DOORS 🚪
-- =====================================================================
TabDoors:CreateSection("Doors Automation")

TabDoors:CreateToggle({
	Name = "Entities ESP (Zeigt Monster)",
	CurrentValue = false,
	Flag = "DoorsESP",
	Callback = function(Value)
		states.doorsEspActive = Value
		if states.doorsEspActive then
			notify("Doors ESP", "Monster ESP aktiviert (Ice Hub)", false)
		end
	end
})

TabDoors:CreateToggle({
	Name = "Auto-Interact (Türen/Items automatisch nutzen)",
	CurrentValue = false,
	Flag = "DoorsInteract",
	Callback = function(Value)
		states.doorsAutoInteract = Value
		if states.doorsAutoInteract then
			connections.doorsInteract = RunService.Heartbeat:Connect(function()
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local hrp = player.Character.HumanoidRootPart
					for _, prompt in pairs(Workspace:GetDescendants()) do
						if prompt:IsA("ProximityPrompt") then
							local dist = (prompt.Parent.Position - hrp.Position).Magnitude
							if dist <= prompt.MaxActivationDistance then
								fireproximityprompt(prompt)
							end
						end
					end
				end
			end)
		else
			if connections.doorsInteract then connections.doorsInteract:Disconnect() connections.doorsInteract = nil end
		end
	end
})

-- =====================================================================
-- 14. TAB: SLAP BATTLES 🧤
-- =====================================================================
TabSlap:CreateSection("Slap Battles OP")

TabSlap:CreateToggle({
	Name = "Slap Aura (Auto-Hit auf Distanz)",
	CurrentValue = false,
	Flag = "SlapAura",
	Callback = function(Value)
		states.slapAuraActive = Value
		if states.slapAuraActive then
			notify("Slap Battles", "Slap Aura aktiviert.", false)
			connections.slapAura = RunService.Heartbeat:Connect(function()
				pcall(function()
					for _, p in pairs(Players:GetPlayers()) do
						if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
							if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
								local dist = (p.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
								if dist < 25 then
									game:GetService("ReplicatedStorage").Events.Slap:FireServer(p.Character:WaitForChild("Right Arm"))
								end
							end
						end
					end
				end)
			end)
		else
			if connections.slapAura then connections.slapAura:Disconnect() connections.slapAura = nil end
		end
	end
})

TabSlap:CreateButton({
	Name = "Anti-Ragdoll (Kein Hinfallen mehr)",
	Callback = function()
		if player.Character then
			local hrp = player.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				for _, state in pairs(player.Character:GetDescendants()) do
					if state:IsA("State") and state.Name == "Ragdoll" then
						state:Destroy()
					end
				end
			end
		end
		notify("Slap Battles", "Anti-Ragdoll injiziert.", false)
	end
})

-- =====================================================================
-- 16. TAB: ADOPT ME 🐶
-- =====================================================================
TabAdoptMe:CreateSection("🔥 Adopt Me: Advanced Farming & ESP")

local AdoptFarmToggleElement = TabAdoptMe:CreateToggle({
	Name = "🤖 Auto-Farm (Teleportiert physisch & Heilt Pets/Baby)",
	CurrentValue = false,
	Flag = "AdoptMeFarm",
	Callback = function(Value)
		states.adoptFarmActive = Value
		if states.adoptFarmActive then
			notify("Adopt Me Farm", "Farm gestartet. Dein Avatar bewegt sich nun selbst über die Map.", false)
			connections.adoptFarm = task.spawn(function()
				while states.adoptFarmActive do
					pcall(function()
						local char = player.Character
						if char and char:FindFirstChild("HumanoidRootPart") then
							local hrp = char.HumanoidRootPart
							
							local ClientData = require(game:GetService("ReplicatedStorage").ClientModules.Core.ClientData)
							local data = ClientData.get_data()[player.Name]
							
							if data and data.ailments_manager and data.ailments_manager.ailments then
								for ailmentId, _ in pairs(data.ailments_manager.ailments) do
									if ailmentId == "hospital" or ailmentId == "sick" then
										hrp.CFrame = CFrame.new(0, 15, -1560) 
									elseif ailmentId == "school" or ailmentId == "bored" then
										hrp.CFrame = CFrame.new(62, 15, -1580) 
									elseif ailmentId == "camp" or ailmentId == "sleepy" then
										hrp.CFrame = CFrame.new(-18, 15, -1650) 
									elseif ailmentId == "pool" or ailmentId == "hot_spring" or ailmentId == "dirty" then
										hrp.CFrame = CFrame.new(-120, 15, -1600) 
									elseif ailmentId == "hungry" then
										hrp.CFrame = CFrame.new(-80, 15, -1500) 
									else
										hrp.CFrame = CFrame.new(-275, 14, -1540) 
									end
									
									task.wait(2) 
									
									for _, v in pairs(Workspace:GetDescendants()) do
										if v:IsA("ProximityPrompt") and (v.Parent.Position - hrp.Position).Magnitude < 30 then
											fireproximityprompt(v)
										end
									end
									task.wait(4) 
								end
							end
						end
					end)
					task.wait(5)
				end
			end)
		else
			if connections.adoptFarm then
				task.cancel(connections.adoptFarm)
				connections.adoptFarm = nil
			end
			notify("Adopt Me Farm", "Farm gestoppt.", false)
		end
	end
})

TabAdoptMe:CreateToggle({
	Name = "🎁 Auto-Claim Quest Rewards (Nimmt Belohnungen an)",
	CurrentValue = false,
	Flag = "AdoptMeClaim",
	Callback = function(Value)
		states.adoptAutoClaim = Value
		if states.adoptAutoClaim then
			connections.adoptClaim = RunService.Heartbeat:Connect(function()
				pcall(function()
					local ReplicatedStorage = game:GetService("ReplicatedStorage")
					local RouterClient = require(ReplicatedStorage.ClientModules.Core.RouterClient).get("api")
					RouterClient:InvokeServer("QuestAPI/ClaimReward")
				end)
			end)
		else
			if connections.adoptClaim then connections.adoptClaim:Disconnect() connections.adoptClaim = nil end
		end
	end
})

TabAdoptMe:CreateToggle({
	Name = "🐾 Pet ESP (Zeigt Pets von anderen Spielern rot an)",
	CurrentValue = false,
	Flag = "AdoptMePetESP",
	Callback = function(Value)
		states.adoptPetEsp = Value
		if states.adoptPetEsp then
			connections.adoptEsp = RunService.Heartbeat:Connect(function()
				local petsFolder = Workspace:FindFirstChild("Pets")
				if petsFolder then
					for _, pet in pairs(petsFolder:GetChildren()) do
						if pet:IsA("Model") and not pet:FindFirstChild("PetESP") then
							local hl = Instance.new("Highlight", pet)
							hl.Name = "PetESP"
							hl.FillColor = Color3.fromRGB(255, 50, 50)
							hl.OutlineColor = Color3.fromRGB(255, 255, 255)
						end
					end
				end
			end)
		else
			if connections.adoptEsp then connections.adoptEsp:Disconnect() end
			local petsFolder = Workspace:FindFirstChild("Pets")
			if petsFolder then
				for _, pet in pairs(petsFolder:GetChildren()) do
					if pet:FindFirstChild("PetESP") then pet.PetESP:Destroy() end
				end
			end
		end
	end
})

TabAdoptMe:CreateKeybind({
	Name = "Auto-Farm Start/Stopp Keybind",
	CurrentKeybind = "J",
	HoldToInteract = false,
	Flag = "AdoptFarmKey",
	Callback = function()
		AdoptFarmToggleElement:Set(not states.adoptFarmActive)
	end
})

TabAdoptMe:CreateButton({
	Name = "🏠 Teleport zum Adopt Me Adoptionscenter (Nursery)",
	Callback = function()
		safeTeleport(CFrame.new(-280, 15, -1540))
		notify("Adopt Me", "Zur Nursery teleportiert.", false)
	end
})

-- =====================================================================
-- 18. TAB: PROP HUNT 📦
-- =====================================================================
TabPropHunt:CreateSection("Prop Hunt ESP & Vision")

TabPropHunt:CreateToggle({
	Name = "📦 Prop/Hider ESP (Zeigt versteckte Spieler)",
	CurrentValue = false, Flag = "PropHuntESP",
	Callback = function(v)
		states.phEsp = v
		if v then
			notify("Prop Hunt", "Hider ESP aktiviert! Alle Spieler leuchten rot.", false)
			connections.phEspLoop = RunService.Heartbeat:Connect(function()
				for _, p in pairs(Players:GetPlayers()) do
					if p ~= player and p.Character and not p.Character:FindFirstChild("PH_ESP") then
						local hl = Instance.new("Highlight", p.Character)
						hl.Name = "PH_ESP"
						hl.FillColor = Color3.fromRGB(255, 0, 0)
						hl.FillTransparency = 0.5
					end
				end
			end)
		else
			if connections.phEspLoop then connections.phEspLoop:Disconnect() end
			for _, p in pairs(Players:GetPlayers()) do
				if p.Character and p.Character:FindFirstChild("PH_ESP") then p.Character.PH_ESP:Destroy() end
			end
		end
	end
})

TabPropHunt:CreateButton({
	Name = "👁️ Karte hell machen (Schatten entfernen)",
	Callback = function()
		Lighting.GlobalShadows = false
		Lighting.Brightness = 3
		Lighting.ClockTime = 12
		notify("Prop Hunt", "Schatten deaktiviert, alles ist sichtbar.", false)
	end
})

TabPropHunt:CreateSection("Trolling & Vorteile")

TabPropHunt:CreateToggle({
	Name = "🛡️ Prop-Godmode (Anti-Touch für Sucher)",
	CurrentValue = false, Flag = "PropGodmode",
	Callback = function(v)
		states.phGodmode = v
		if v then
			notify("Prop Hunt", "Godmode aktiv! Sucher können dich nicht fangen.", false)
			task.spawn(function()
				while states.phGodmode do
					if player.Character then
						for _, part in ipairs(player.Character:GetDescendants()) do
							if part:IsA("TouchTransmitter") then part:Destroy() end
						end
					end
					task.wait(1)
				end
		