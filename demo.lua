-- ESP + SKELETON + AIMBOT + LOCK STATS + KEY SYSTEM + DEVICE SPOOFER + CONFIG SYSTEM + AFK + PLAYERS TAB + INFO TAB + ADMIN TAB + SKIN TAB (FULL) + SILENT AIM
-- UI NANG CAP: TAB DOC BEN TRAI, GIAO DIEN NHO GON, HIEN DAI
-- FIXED: Tat ca loi, Lock stats UI cap nhat dung khi load config, Tao config moi thanh cong
-- FIXED: Silent Aim (khong anh huong goc nhin, van co the nhin quanh)

-- ============ KIỂM TRA GAME ==========
local requiredGameName = "Rivals"

local successGetInfo, gameInfo = pcall(function()
    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
end)

local gameName = ""
if successGetInfo and gameInfo then
    gameName = gameInfo.Name or ""
end

if not string.find(string.lower(gameName), string.lower(requiredGameName)) then
    local notificationGui = Instance.new("ScreenGui")
    notificationGui.Name = "GameCheckNotification"
    notificationGui.Parent = game:GetService("CoreGui")
    notificationGui.ResetOnSpawn = false
    
    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 0.85
    background.Parent = notificationGui
    
    local notificationFrame = Instance.new("Frame")
    notificationFrame.Size = UDim2.new(0, 550, 0, 240)
    notificationFrame.Position = UDim2.new(0.5, -275, 0.5, -120)
    notificationFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    notificationFrame.BackgroundTransparency = 0.1
    notificationFrame.BorderSizePixel = 2
    notificationFrame.BorderColor3 = Color3.fromRGB(255, 50, 50)
    notificationFrame.Parent = background
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = notificationFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 50)
    titleLabel.Position = UDim2.new(0, 0, 0, 20)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "⚠️ CẢNH BÁO ⚠️"
    titleLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    titleLabel.TextSize = 24
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.Parent = notificationFrame
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -40, 0, 90)
    messageLabel.Position = UDim2.new(0, 20, 0, 80)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = "⚠️ Bạn đang không ở game " .. requiredGameName .. "!\n\nGame hiện tại: " .. (gameName ~= "" and gameName or "Không xác định") .. "\n\nMột số tính năng có thể không hoạt động đúng!"
    messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    messageLabel.TextSize = 13
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextXAlignment = Enum.TextXAlignment.Center
    messageLabel.TextWrapped = true
    messageLabel.Parent = notificationFrame
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 120, 0, 40)
    closeBtn.Position = UDim2.new(0.5, -60, 1, -50)
    closeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    closeBtn.Text = "BỎ QUA"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = notificationFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        notificationGui:Destroy()
    end)
    
    print("========================================")
    print("⚠️ KHANHGD CHEAT - CẢNH BÁO ⚠️")
    print("Game hiện tại: " .. (gameName ~= "" and gameName or "Không xác định"))
    print("Khuyến nghị chơi game: " .. requiredGameName)
    print("Vẫn chạy script nhưng có thể lỗi!")
    print("========================================")
end

print("✅ Đang tải KHANHGD CHEAT...")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInput = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")

-- ============ SKIN CHANGER SETUP ==========
local ViewModels = LocalPlayer.PlayerScripts.Assets.ViewModels
local WeaponsPath = ViewModels.Weapons

local SkinFolders = {
    ViewModels.Bundles,
    ViewModels["Festive Skin Case"],
    ViewModels.Glorious,
    ViewModels.Other,
    ViewModels.Seasons,
    ViewModels["Skin Case"],
    ViewModels["Skin Case 2"],
    ViewModels["Skin Case 3"],
    ViewModels["Spooky Skin Case"],
}

local IgnoreNames = {"Unobtainable", "unobtainable", "Test", "test", "Temp", "temp"}

local selectedSkin = nil
local selectedWeapon = nil
local allSkins = {}
local allWeapons = {}

-- ============ HỆ THỐNG LƯU NHIỀU SKIN ==========
local savedSkinList = {}

local function shouldIgnore(name)
    for _, ignore in ipairs(IgnoreNames) do
        if string.find(string.lower(name), string.lower(ignore)) then
            return true
        end
    end
    return false
end

local function ScanAllSkins()
    allSkins = {}
    for _, folder in ipairs(SkinFolders) do
        if folder and folder:IsA("Folder") then
            local folderName = folder.Name
            for _, child in ipairs(folder:GetChildren()) do
                if (child:IsA("Folder") or child:IsA("Model")) and not shouldIgnore(child.Name) then
                    table.insert(allSkins, {
                        name = child.Name,
                        path = child,
                        folderName = folderName
                    })
                end
            end
        end
    end
    return allSkins
end

local function ScanWeapons()
    allWeapons = {}
    if not WeaponsPath then return end
    for _, child in ipairs(WeaponsPath:GetChildren()) do
        if (child:IsA("Folder") or child:IsA("Model")) and not shouldIgnore(child.Name) then
            table.insert(allWeapons, {
                name = child.Name,
                path = child
            })
        end
    end
    return allWeapons
end

local function ApplySkinAndAutoSave(skin, weapon)
    if not skin or not weapon then return false, "Thiếu dữ liệu" end
    
    local success, err = pcall(function()
        weapon.path:ClearAllChildren()
        for _, v in ipairs(skin.path:GetChildren()) do
            v:Clone().Parent = weapon.path
        end
    end)
    
    if success then
        savedSkinList[weapon.name] = skin.name
    end
    
    return success, err
end

local function AutoApplySkin()
    if selectedSkin and selectedWeapon then
        return ApplySkinAndAutoSave(selectedSkin, selectedWeapon)
    end
    return false, "Chưa chọn đủ"
end

local function ApplyAllSavedSkins()
    local count = 0
    for weaponName, skinName in pairs(savedSkinList) do
        local weapon = nil
        local skin = nil
        for _, w in ipairs(allWeapons) do
            if w.name == weaponName then weapon = w; break end
        end
        for _, s in ipairs(allSkins) do
            if s.name == skinName then skin = s; break end
        end
        if weapon and skin then
            pcall(function()
                weapon.path:ClearAllChildren()
                for _, v in ipairs(skin.path:GetChildren()) do
                    v:Clone().Parent = weapon.path
                end
            end)
            count = count + 1
        end
    end
    return count
end

local function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

-- ============ ADMIN CONFIG ==========
local ADMIN_NAME = "hoangkhanh0504"
local ADMIN_ID = 11073255982
local ADMIN_DISPLAY_NAME = "Top1sniper"
local isAdminOnline = false
local adminPlayer = nil

local function checkAdminOnline()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower() == ADMIN_NAME:lower() then
            adminPlayer = player
            isAdminOnline = true
            return true
        end
    end
    adminPlayer = nil
    isAdminOnline = false
    return false
end

local function joinAdminServer()
    if not isAdminOnline or not adminPlayer then
        return false, "❌ Admin hiện không trực tuyến!"
    end
    
    -- Lấy JobId an toàn
    local jobId = nil
    if adminPlayer.Team then
        jobId = game.JobId
    else
        local attr = adminPlayer:GetAttribute("JobId")
        if attr and type(attr) == "string" and attr ~= "" then
            jobId = attr
        end
    end
    
    -- Nếu không có jobId, thử lấy từ leaderstats
    if not jobId or jobId == "" then
        local leaderstats = adminPlayer:FindFirstChild("leaderstats")
        if leaderstats then
            local jobIdStat = leaderstats:FindFirstChild("JobId")
            if jobIdStat then
                jobId = tostring(jobIdStat.Value)
            end
        end
    end
    
    -- Nếu vẫn không có, dùng game.JobId hiện tại
    if not jobId or jobId == "" then
        jobId = game.JobId
    end
    
    if jobId and jobId ~= game.JobId then
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, LocalPlayer)
        end)
        return true, "✅ Đang chuyển đến server của admin..."
    elseif jobId == game.JobId then
        return false, "ℹ️ Bạn đã ở cùng server với admin!"
    else
        return false, "❌ Không thể vào server của admin!"
    end
end

-- ============ TEAM SYSTEM ==========
local teamPlayers = {}

local function isTeammate(player)
    return teamPlayers[player.Name] == true
end

local function addTeammate(player)
    teamPlayers[player.Name] = true
end

local function removeTeammate(player)
    teamPlayers[player.Name] = nil
end

local function clearAllTeammates()
    teamPlayers = {}
end

-- ============ LẤY THÔNG TIN ==========
local function getPlayerHealth()
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            return math.floor(humanoid.Health), math.floor(humanoid.MaxHealth)
        end
    end
    return 0, 100
end

local function getPlayerKills()
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        local kills = leaderstats:FindFirstChild("Kills")
        if kills then return kills.Value end
    end
    local customStats = LocalPlayer:FindFirstChild("CustomLeaderstats")
    if customStats then
        local kills = customStats:FindFirstChild("Kills")
        if kills then return kills.Value end
    end
    return 0
end

local function getPlayerDeaths()
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        local deaths = leaderstats:FindFirstChild("Deaths")
        if deaths then return deaths.Value end
    end
    local customStats = LocalPlayer:FindFirstChild("CustomLeaderstats")
    if customStats then
        local deaths = customStats:FindFirstChild("Deaths")
        if deaths then return deaths.Value end
    end
    return 0
end

local function getPlayerELO()
    local customStats = LocalPlayer:FindFirstChild("CustomLeaderstats")
    if customStats then
        local elo = customStats:FindFirstChild("Current ELO")
        if elo then return elo.Value end
        local rank = customStats:FindFirstChild("Rank")
        if rank then return rank.Value end
    end
    return 0
end

local function getPlayerLevel()
    local customStats = LocalPlayer:FindFirstChild("CustomLeaderstats")
    if customStats then
        local level = customStats:FindFirstChild("Level")
        if level then return level.Value end
    end
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        local level = leaderstats:FindFirstChild("Level")
        if level then return level.Value end
    end
    return 0
end

local function getPlayerWinStreak()
    local customStats = LocalPlayer:FindFirstChild("CustomLeaderstats")
    if customStats then
        local winStreak = customStats:FindFirstChild("Win Streak")
        if winStreak then return winStreak.Value end
    end
    return 0
end

local function getPlayerPosition()
    local character = LocalPlayer.Character
    if character then
        local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
        if rootPart then
            local pos = rootPart.Position
            return string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
        end
    end
    return "0, 0, 0"
end

local function getPlayerRegion()
    return "BETA"
end

-- ============ ANTI AFK ==========
local AntiAFK = {}
AntiAFK.__index = AntiAFK

_G.__ANTI_AFK_INSTANCE__ = nil

local function killOldInstance()
    if _G.__ANTI_AFK_INSTANCE__ then
        pcall(function()
            if _G.__ANTI_AFK_INSTANCE__.connections then
                for _, conn in pairs(_G.__ANTI_AFK_INSTANCE__.connections) do
                    conn:Disconnect()
                end
            end
            if _G.__ANTI_AFK_INSTANCE__.thread then
                pcall(function() coroutine.close(_G.__ANTI_AFK_INSTANCE__.thread) end)
            end
            if _G.__ANTI_AFK_INSTANCE__.gui then
                _G.__ANTI_AFK_INSTANCE__.gui:Destroy()
            end
        end)
        _G.__ANTI_AFK_INSTANCE__ = nil
    end
end

local function createAntiAFKInstance()
    local self = setmetatable({}, AntiAFK)
    self.Services = {
        Players = game:GetService("Players"),
        UserInput = game:GetService("UserInputService"),
        RunService = game:GetService("RunService"),
        VirtualUser = game:GetService("VirtualUser"),
        CoreGui = game:GetService("CoreGui")
    }
    self.LocalPlayer = self.Services.Players.LocalPlayer
    self.connections = {}
    self.isRunning = true
    self.interval = 45
    self.lastRun = 0
    
    self.methods = {
        simulateInput = function()
            pcall(function()
                local VirtualInputGamepad = game:GetService("VirtualInputGamepad")
                if VirtualInputGamepad then
                    VirtualInputGamepad:SendMouseMove(Vector2.new(math.random(80, 120), math.random(80, 120)))
                    task.wait(0.05)
                    VirtualInputGamepad:SendMouseMove(Vector2.new(math.random(105, 115), math.random(105, 115)))
                end
            end)
        end,
        smallMove = function()
            local char = self.LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                local humanoid = char.Humanoid
                local rootPart = char:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local originalPos = rootPart.Position
                    humanoid:MoveTo(originalPos + Vector3.new(math.random(-2, 2), 0, math.random(-2, 2)))
                    task.wait(0.2)
                    humanoid:MoveTo(originalPos)
                end
            end
        end,
        cameraWiggle = function()
            pcall(function()
                local camera = workspace.CurrentCamera
                local originalCF = camera.CFrame
                camera.CFrame = CFrame.new(originalCF.Position, originalCF.Position + Vector3.new(math.random(-5, 5), math.random(-2, 2), math.random(-5, 5)))
                task.wait(0.1)
                camera.CFrame = originalCF
            end)
        end,
        virtualUser = function()
            pcall(function()
                local vu = self.Services.VirtualUser
                vu:CaptureController()
                vu:ClickButton1(Vector2.new())
                vu:ClickButton2(Vector2.new())
            end)
        end,
        contextAction = function()
            pcall(function()
                local ContextAction = game:GetService("ContextActionService")
                ContextAction:Fire("_click", Enum.UserInputType.MouseButton1, {X = 0, Y = 0})
            end)
        end,
        silentChat = function()
            pcall(function()
                local StarterGui = game:GetService("StarterGui")
                StarterGui:SetCore("ChatMakeSystemMessage", {Text = " ", Color = Color3.fromRGB(255, 255, 255)})
            end)
        end,
        smallJump = function()
            local char = self.LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                local humanoid = char.Humanoid
                if humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
                    humanoid.Jump = true
                    task.wait(0.05)
                    humanoid.Jump = false
                end
            end
        end,
        fakeRemote = function()
            pcall(function()
                local rs = game:GetService("ReplicatedStorage")
                for _, remote in ipairs(rs:GetDescendants()) do
                    if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                        pcall(function() remote:FireServer("ping") end)
                        break
                    end
                end
            end)
        end,
        rotateCamera = function()
            pcall(function()
                local camera = workspace.CurrentCamera
                local cf = camera.CFrame
                camera.CFrame = cf * CFrame.Angles(0, math.rad(1), 0)
                task.wait(0.05)
                camera.CFrame = cf
            end)
        end,
        pressW = function()
            pcall(function()
                VirtualInput:SendKeyEvent(true, "W", false, game)
                task.wait(0.1)
                VirtualInput:SendKeyEvent(false, "W", false, game)
            end)
        end,
        pressA = function()
            pcall(function()
                VirtualInput:SendKeyEvent(true, "A", false, game)
                task.wait(0.1)
                VirtualInput:SendKeyEvent(false, "A", false, game)
            end)
        end,
        pressD = function()
            pcall(function()
                VirtualInput:SendKeyEvent(true, "D", false, game)
                task.wait(0.1)
                VirtualInput:SendKeyEvent(false, "D", false, game)
            end)
        end
    }
    
    function self:runAntiAFK()
        if not self.isRunning then return end
        local now = tick()
        if now - self.lastRun < self.interval then return end
        self.lastRun = now
        local methodsList = {"virtualUser", "simulateInput", "smallMove", "cameraWiggle", "contextAction", "silentChat", "smallJump", "fakeRemote", "rotateCamera", "pressW", "pressA", "pressD"}
        local selected = methodsList[math.random(1, #methodsList)]
        pcall(function() self.methods[selected]() end)
    end
    
    function self:startLoop()
        self.thread = coroutine.create(function()
            while self.isRunning do
                self:runAntiAFK()
                task.wait(1)
            end
        end)
        coroutine.resume(self.thread)
    end
    
    function self:setupHeartbeat()
        local conn = self.Services.RunService.Heartbeat:Connect(function()
            if self.isRunning then self:runAntiAFK() end
        end)
        table.insert(self.connections, conn)
    end
    
    function self:setupRenderStepped()
        local conn = self.Services.RunService.RenderStepped:Connect(function()
            if self.isRunning and tick() % (self.interval * 2) < 1 then self:runAntiAFK() end
        end)
        table.insert(self.connections, conn)
    end
    
    function self:setupStepped()
        local conn = self.Services.RunService.Stepped:Connect(function()
            if self.isRunning and tick() % self.interval < 0.5 then self:runAntiAFK() end
        end)
        table.insert(self.connections, conn)
    end
    
    function self:setupCharacterHandler()
        local conn = self.LocalPlayer.CharacterAdded:Connect(function()
            task.wait(2)
            self.lastRun = tick() - self.interval + 5
        end)
        table.insert(self.connections, conn)
    end
    
    function self:setupPlayerHandler()
        local conn = self.Services.Players.PlayerAdded:Connect(function() task.wait(1) end)
        table.insert(self.connections, conn)
    end
    
    function self:createMiniGui()
        pcall(function()
            self.gui = Instance.new("ScreenGui")
            self.gui.Name = "__AntiAFK__"
            self.gui.ResetOnSpawn = false
            self.gui.IgnoreGuiInset = true
            self.gui.Parent = self.Services.CoreGui
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 0, 0, 0)
            frame.Visible = false
            frame.Parent = self.gui
        end)
    end
    
    function self:init()
        self:setupHeartbeat()
        self:setupRenderStepped()
        self:setupStepped()
        self:setupCharacterHandler()
        self:setupPlayerHandler()
        self:startLoop()
        self:createMiniGui()
        _G.__ANTI_AFK_INSTANCE__ = self
    end
    return self
end

local function bootstrapAntiAFK()
    killOldInstance()
    local instance = createAntiAFKInstance()
    instance:init()
    return instance
end

local antiAFKInstance = bootstrapAntiAFK()

_G.AntiAFKControl = {
    stop = function() if _G.__ANTI_AFK_INSTANCE__ then _G.__ANTI_AFK_INSTANCE__.isRunning = false end end,
    start = function() if _G.__ANTI_AFK_INSTANCE__ then _G.__ANTI_AFK_INSTANCE__.isRunning = true else bootstrapAntiAFK() end end,
    setInterval = function(sec) if _G.__ANTI_AFK_INSTANCE__ then _G.__ANTI_AFK_INSTANCE__.interval = sec end end,
    status = function() return _G.__ANTI_AFK_INSTANCE__ and _G.__ANTI_AFK_INSTANCE__.isRunning or false end,
    kill = function() killOldInstance() end,
    getInterval = function() return _G.__ANTI_AFK_INSTANCE__ and _G.__ANTI_AFK_INSTANCE__.interval or 45 end
}

-- ============ CONFIG SYSTEM ==========
local ConfigFolder = "KhanhGD_Configs"

local SetControlsRemote = nil
pcall(function()
    SetControlsRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Replication"):WaitForChild("Fighter"):WaitForChild("SetControls")
end)

local currentDevice = "MouseKeyboard"

local function spoofDevice(wantedDevice)
    if not SetControlsRemote then return end
    currentDevice = wantedDevice
    pcall(function()
        SetControlsRemote:FireServer("MouseKeyboard")
        task.wait(0.3)
        SetControlsRemote:FireServer(wantedDevice)
    end)
end

local function playClickSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://9120386436"
    sound.Volume = 0.3
    sound.Parent = CoreGui
    sound:Play()
    task.wait(0.2)
    sound:Destroy()
end

-- ============ KEY SYSTEM ==========
local playerName = LocalPlayer.Name
local isKeyValidated = false
local currentKey = ""

local validKeysList = {
    "ABCD1-EFGH2-IJKL3-MNOP4", "QRST5-UVWX6-YZAB7-CDEF8", "GHIJ9-KLMN0-OPQR1-STUV2"
}
local validKeys = {}
for _, key in ipairs(validKeysList) do
    validKeys[string.upper(key)] = true
end

local keyStorageFolder = "KeySystem_Storage"
local function saveUsedKey(key)
    local storage = LocalPlayer:FindFirstChild(keyStorageFolder)
    if not storage then
        storage = Instance.new("Folder")
        storage.Name = keyStorageFolder
        storage.Parent = LocalPlayer
    end
    local keyData = storage:FindFirstChild("UsedKey")
    if keyData then
        keyData.Value = key
    else
        local keyValue = Instance.new("StringValue")
        keyValue.Name = "UsedKey"
        keyValue.Value = key
        keyValue.Parent = storage
    end
end

local function getSavedKey()
    local storage = LocalPlayer:FindFirstChild(keyStorageFolder)
    if storage then
        local keyData = storage:FindFirstChild("UsedKey")
        if keyData then return keyData.Value end
    end
    return nil
end

local function validateKey(inputKey)
    if not inputKey or inputKey == "" then
        return false, "Vui lòng nhập key!"
    end
    local normalizedKey = string.upper(string.gsub(inputKey, "%s+", ""))
    if validKeys[normalizedKey] then
        return true, "Key hợp lệ!"
    end
    return false, "Key không hợp lệ!"
end

local function onKeyValidated(key)
    currentKey = key
    isKeyValidated = true
    saveUsedKey(key)
end

local function copyToClipboard(text)
    local success = false
    if setclipboard then
        pcall(function() setclipboard(text); success = true end)
    end
    if not success and toclipboard then
        pcall(function() toclipboard(text); success = true end)
    end
    if not success then
        pcall(function()
            local frame = Instance.new("Frame")
            frame.Parent = LocalPlayer.PlayerGui
            frame.Size = UDim2.new(0, 0, 0, 0)
            local textBox = Instance.new("TextBox")
            textBox.Parent = frame
            textBox.Size = UDim2.new(0, 0, 0, 0)
            textBox.Text = text
            textBox:CaptureFocus()
            textBox:ReleaseFocus()
            task.wait(0.1)
            frame:Destroy()
            success = true
        end)
    end
    return success
end

-- ============ UI NHẬP KEY ==========
local keyScreenGui = Instance.new("ScreenGui")
keyScreenGui.Name = "KeySystemGUI"
keyScreenGui.Parent = LocalPlayer.PlayerGui
keyScreenGui.ResetOnSpawn = false

local keyOverlay = Instance.new("Frame")
keyOverlay.Size = UDim2.new(1, 0, 1, 0)
keyOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
keyOverlay.BackgroundTransparency = 0.7
keyOverlay.Parent = keyScreenGui

local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0, 0, 0, 0)
keyFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
keyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
keyFrame.BackgroundTransparency = 0.1
keyFrame.BorderSizePixel = 0
keyFrame.Parent = keyOverlay

local keyFrameCorner = Instance.new("UICorner")
keyFrameCorner.CornerRadius = UDim.new(0, 20)
keyFrameCorner.Parent = keyFrame

local keyGlass = Instance.new("Frame")
keyGlass.Size = UDim2.new(1, 0, 1, 0)
keyGlass.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
keyGlass.BackgroundTransparency = 0.3
keyGlass.BorderSizePixel = 0
keyGlass.Parent = keyFrame

local keyGlassCorner = Instance.new("UICorner")
keyGlassCorner.CornerRadius = UDim.new(0, 20)
keyGlassCorner.Parent = keyGlass

local keyBorder = Instance.new("Frame")
keyBorder.Size = UDim2.new(1, 2, 1, 2)
keyBorder.Position = UDim2.new(0, -1, 0, -1)
keyBorder.BackgroundTransparency = 1
keyBorder.BorderSizePixel = 2
keyBorder.BorderColor3 = Color3.fromRGB(0, 200, 255)
keyBorder.BorderMode = Enum.BorderMode.Inset
keyBorder.Parent = keyFrame

local keyBorderCorner = Instance.new("UICorner")
keyBorderCorner.CornerRadius = UDim.new(0, 22)
keyBorderCorner.Parent = keyBorder

local keyTitle = Instance.new("TextLabel")
keyTitle.Size = UDim2.new(1, 0, 0, 60)
keyTitle.Position = UDim2.new(0, 0, 0, 20)
keyTitle.BackgroundTransparency = 1
keyTitle.Text = "🔐 XÁC THỰC KEY"
keyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
keyTitle.TextSize = 22
keyTitle.Font = Enum.Font.GothamBold
keyTitle.TextXAlignment = Enum.TextXAlignment.Center
keyTitle.Parent = keyFrame

local keySubtitle = Instance.new("TextLabel")
keySubtitle.Size = UDim2.new(1, -40, 0, 30)
keySubtitle.Position = UDim2.new(0, 20, 0, 85)
keySubtitle.BackgroundTransparency = 1
keySubtitle.Text = "Nhập key để tiếp tục"
keySubtitle.TextColor3 = Color3.fromRGB(160, 160, 200)
keySubtitle.TextSize = 12
keySubtitle.Font = Enum.Font.Gotham
keySubtitle.TextXAlignment = Enum.TextXAlignment.Center
keySubtitle.Parent = keyFrame

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(0, 320, 0, 50)
keyInput.Position = UDim2.new(0.5, -160, 0, 130)
keyInput.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
keyInput.BackgroundTransparency = 0.2
keyInput.PlaceholderText = "XXXXX-XXXXX-XXXXX-XXXXX"
keyInput.Text = ""
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInput.TextSize = 14
keyInput.Font = Enum.Font.Gotham
keyInput.TextXAlignment = Enum.TextXAlignment.Center
keyInput.ClearTextOnFocus = false
keyInput.Parent = keyFrame

local keyInputCorner = Instance.new("UICorner")
keyInputCorner.CornerRadius = UDim.new(0, 10)
keyInputCorner.Parent = keyInput

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -40, 0, 30)
statusLabel.Position = UDim2.new(0, 20, 0, 190)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Đang chờ key..."
statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.Parent = keyFrame

local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(0, 420, 0, 45)
buttonContainer.Position = UDim2.new(0.5, -210, 0, 235)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = keyFrame

local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(0, 200, 0, 45)
submitBtn.Position = UDim2.new(0, 0, 0, 0)
submitBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
submitBtn.Text = "XÁC THỰC"
submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
submitBtn.TextSize = 14
submitBtn.Font = Enum.Font.GothamBold
submitBtn.AutoButtonColor = false
submitBtn.Parent = buttonContainer

local submitCorner = Instance.new("UICorner")
submitCorner.CornerRadius = UDim.new(0, 10)
submitCorner.Parent = submitBtn

local getKeyBtn = Instance.new("TextButton")
getKeyBtn.Size = UDim2.new(0, 200, 0, 45)
getKeyBtn.Position = UDim2.new(0, 220, 0, 0)
getKeyBtn.BackgroundColor3 = Color3.fromRGB(45, 65, 45)
getKeyBtn.Text = "🔑 LẤY KEY"
getKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyBtn.TextSize = 14
getKeyBtn.Font = Enum.Font.GothamBold
getKeyBtn.AutoButtonColor = false
getKeyBtn.Parent = buttonContainer

local getKeyCorner = Instance.new("UICorner")
getKeyCorner.CornerRadius = UDim.new(0, 10)
getKeyCorner.Parent = getKeyBtn

local loadingDot = Instance.new("TextLabel")
loadingDot.Size = UDim2.new(0, 20, 0, 20)
loadingDot.Position = UDim2.new(0.5, -10, 0, 245)
loadingDot.BackgroundTransparency = 1
loadingDot.Text = ""
loadingDot.TextColor3 = Color3.fromRGB(0, 200, 255)
loadingDot.TextSize = 20
loadingDot.Font = Enum.Font.GothamBold
loadingDot.Visible = false
loadingDot.Parent = keyFrame

TweenService:Create(keyFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 480, 0, 330),
    Position = UDim2.new(0.5, -240, 0.5, -165)
}):Play()

submitBtn.MouseEnter:Connect(function()
    TweenService:Create(submitBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 170, 220)}):Play()
end)
submitBtn.MouseLeave:Connect(function()
    TweenService:Create(submitBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 150, 200)}):Play()
end)

getKeyBtn.MouseEnter:Connect(function()
    TweenService:Create(getKeyBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(65, 85, 65)}):Play()
end)
getKeyBtn.MouseLeave:Connect(function()
    TweenService:Create(getKeyBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 65, 45)}):Play()
end)

getKeyBtn.MouseButton1Click:Connect(function()
    playClickSound()
    getKeyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    task.wait(0.1)
    getKeyBtn.BackgroundColor3 = Color3.fromRGB(45, 65, 45)
    
    local keyLink = "https://hoangquockhanh0504.github.io/key-system/"
    local copied = copyToClipboard(keyLink)
    
    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 300, 0, 50)
    notifFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
    notifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    notifFrame.BackgroundTransparency = 0.1
    notifFrame.BorderSizePixel = 0
    notifFrame.Parent = keyFrame
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notifFrame
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, 0, 1, 0)
    notifText.BackgroundTransparency = 1
    notifText.TextColor3 = copied and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100)
    notifText.TextSize = 13
    notifText.Font = Enum.Font.GothamBold
    notifText.TextXAlignment = Enum.TextXAlignment.Center
    notifText.Parent = notifFrame
    
    if copied then
        notifText.Text = "✅ ĐÃ SAO CHÉP LINK!\n\n" .. keyLink
        statusLabel.Text = "✅ Đã sao chép link! Mở trình duyệt và dán"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        notifText.Text = "❌ Không thể sao chép tự động!\n\nVui lòng sao chép thủ công:\n" .. keyLink
        statusLabel.Text = "❌ Vui lòng sao chép thủ công: " .. keyLink
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    end
    
    task.wait(3)
    notifFrame:Destroy()
    task.wait(2)
    if statusLabel.Text ~= "Đang chờ key..." then
        statusLabel.Text = "Đang chờ key..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    end
end)

local savedKey = getSavedKey()
if savedKey then
    local isValid, msg = validateKey(savedKey)
    if isValid then
        statusLabel.Text = "Tự động xác thực! Đang tải menu..."
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        task.wait(1)
        onKeyValidated(savedKey)
        keyScreenGui:Destroy()
        loadMainMenu()
    else
        statusLabel.Text = "Key đã lưu không hợp lệ! Vui lòng nhập lại."
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end

submitBtn.MouseButton1Click:Connect(function()
    local key = keyInput.Text
    if key == "" then
        statusLabel.Text = "Vui lòng nhập key!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    submitBtn.Visible = false
    getKeyBtn.Visible = false
    loadingDot.Visible = true
    
    local dots = 0
    task.spawn(function()
        while loadingDot.Visible do
            dots = (dots % 3) + 1
            loadingDot.Text = string.rep(".", dots)
            task.wait(0.3)
        end
    end)
    
    statusLabel.Text = "Đang xác thực key..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    task.wait(0.5)
    
    local isValid, msg = validateKey(key)
    
    if isValid then
        statusLabel.Text = "✓ " .. msg
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        submitBtn.Visible = true
        getKeyBtn.Visible = true
        loadingDot.Visible = false
        task.wait(1)
        onKeyValidated(key)
        keyScreenGui:Destroy()
        loadMainMenu()
    else
        statusLabel.Text = "✗ " .. msg
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        submitBtn.Visible = true
        getKeyBtn.Visible = true
        loadingDot.Visible = false
    end
end)

keyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        submitBtn.MouseButton1Click:Fire()
    end
end)

-- ============================================================
-- ============ MAIN MENU ============
-- ============================================================
function loadMainMenu()

-- ============ THÔNG SỐ (MẶC ĐỊNH) ==========
local settings = {
    esp = {
        enabled = true,
        box = true,
        skeleton = true,
        name = true,
        distance = true,
        health = true,
        maxDistance = 200,
        boxColor = Color3.fromRGB(255, 70, 70),
        skeletonColor = Color3.fromRGB(0, 200, 255),
        npcColor = Color3.fromRGB(255, 200, 50),
        boxColorR = 255,
        boxColorG = 70,
        boxColorB = 70,
        skeletonColorR = 0,
        skeletonColorG = 200,
        skeletonColorB = 255,
        npcColorR = 255,
        npcColorG = 200,
        npcColorB = 50
    },
    aimbot = {
        enabled = true,
        fovRadius = 200,
        smoothness = 1,
        maxDistance = 150,
        lockTarget = true,
        showFOV = true,
        showLine = true,
        fovColor = Color3.fromRGB(0, 200, 255),
        lineColor = Color3.fromRGB(255, 0, 0),
        aimPart = "Head",
        aimMode = "Both",
        autoShot = true,
        fovColorR = 0,
        fovColorG = 200,
        fovColorB = 255,
        lineColorR = 255,
        lineColorG = 0,
        lineColorB = 0,
        ignoreTeam = true,
        aimPlayers = true,
        aimNPC = true,
        xuyenTuong = false
    },
    silentAim = {
        enabled = false,  -- MẶC ĐỊNH TẮT ĐỂ GIỮ AIM CHUỘT
        mode = "Both",    -- Players, NPCs, Both
        maxDistance = 200,
        aimPart = "Head"
    },
    teleport = {
        enabled = true
    },
    afk = {
        enabled = true,
        interval = 45
    },
    lockStats = {
        enabled = true,
        level = 0,
        streak = 0,
        elo = 0,
        customName = ""
    }
}

-- ============ SILENT AIM SYSTEM ==========
local silentAimTarget = nil
local silentAimRemoteHooked = false

-- Hàm lấy target cho Silent Aim
local function getSilentAimTarget()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    
    local bestTarget = nil
    local bestDistance = settings.silentAim.maxDistance
    local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    local mode = settings.silentAim.mode
    
    -- Lấy target Players
    if mode == "Players" or mode == "Both" then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if settings.aimbot.ignoreTeam and isTeammate(player) then
                    -- Skip teammate
                else
                    local char = player.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        local targetPart = char:FindFirstChild(settings.silentAim.aimPart) or char:FindFirstChild("Head")
                        if hum and hum.Health > 0 and targetPart then
                            local distance = (myRoot.Position - targetPart.Position).Magnitude
                            if distance <= settings.silentAim.maxDistance then
                                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                                if onScreen then
                                    local distToCenter = (Vector2.new(screenPos.X, screenPos.Y) - centerScreen).Magnitude
                                    if distToCenter < bestDistance then
                                        bestDistance = distToCenter
                                        bestTarget = targetPart
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- Lấy target NPC
    if mode == "NPCs" or mode == "Both" then
        local shootingRange = workspace:FindFirstChild("ShootingRangeEntities")
        if shootingRange then
            for _, npc in pairs(shootingRange:GetChildren()) do
                local hum = npc:FindFirstChildOfClass("Humanoid") or npc:FindFirstChild("Humanoid")
                local targetPart = npc:FindFirstChild(settings.silentAim.aimPart) or npc:FindFirstChild("Head") or npc:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health and hum.Health > 0 and targetPart then
                    local distance = (myRoot.Position - targetPart.Position).Magnitude
                    if distance <= settings.silentAim.maxDistance then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                        if onScreen then
                            local distToCenter = (Vector2.new(screenPos.X, screenPos.Y) - centerScreen).Magnitude
                            if distToCenter < bestDistance then
                                bestDistance = distToCenter
                                bestTarget = targetPart
                            end
                        end
                    end
                end
            end
        end
    end
    
    return bestTarget
end

-- Hook Remote để Silent Aim
local function setupSilentAimRemote()
    if silentAimRemoteHooked then return end
    
    -- Tìm Remote bắn
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then 
        -- Thử tìm trong các folder khác
        for _, child in pairs(ReplicatedStorage:GetChildren()) do
            if child:IsA("Folder") or child:IsA("Model") then
                for _, remote in pairs(child:GetDescendants()) do
                    if remote:IsA("RemoteEvent") then
                        local name = remote.Name:lower()
                        if name:find("shoot") or name:find("fire") or name:find("attack") or name:find("damage") or name:find("gun") or name:find("weapon") then
                            pcall(function()
                                local oldFire = remote.FireServer
                                remote.FireServer = function(self, ...)
                                    local args = {...}
                                    
                                    if settings.silentAim.enabled then
                                        local target = getSilentAimTarget()
                                        if target then
                                            local origin = Camera.CFrame.Position
                                            local targetPos = target.Position
                                            
                                            -- Kiểm tra xem args có Vector3 không (direction)
                                            for i, arg in ipairs(args) do
                                                if typeof(arg) == "Vector3" then
                                                    if i == 1 or i == 2 then
                                                        args[i] = (targetPos - origin).Unit * 1000
                                                    end
                                                elseif typeof(arg) == "CFrame" then
                                                    args[i] = CFrame.lookAt(origin, targetPos)
                                                end
                                            end
                                            
                                            -- Kiểm tra nếu args là bảng với các giá trị position/direction
                                            if args[1] and type(args[1]) == "table" then
                                                if args[1].Position or args[1].Direction then
                                                    if args[1].Position then
                                                        args[1].Position = targetPos
                                                    end
                                                    if args[1].Direction then
                                                        args[1].Direction = (targetPos - origin).Unit
                                                    end
                                                end
                                            end
                                        end
                                    end
                                    
                                    return oldFire(self, unpack(args))
                                end
                            end)
                        end
                    end
                end
            end
        end
    else
        -- Tìm remote bắn trong Remotes
        for _, remote in pairs(remotes:GetDescendants()) do
            if remote:IsA("RemoteEvent") then
                local name = remote.Name:lower()
                if name:find("shoot") or name:find("fire") or name:find("attack") or name:find("damage") or name:find("gun") or name:find("weapon") then
                    pcall(function()
                        local oldFire = remote.FireServer
                        remote.FireServer = function(self, ...)
                            local args = {...}
                            
                            if settings.silentAim.enabled then
                                local target = getSilentAimTarget()
                                if target then
                                    local origin = Camera.CFrame.Position
                                    local targetPos = target.Position
                                    
                                    for i, arg in ipairs(args) do
                                        if typeof(arg) == "Vector3" then
                                            if i == 1 or i == 2 then
                                                args[i] = (targetPos - origin).Unit * 1000
                                            end
                                        elseif typeof(arg) == "CFrame" then
                                            args[i] = CFrame.lookAt(origin, targetPos)
                                        end
                                    end
                                    
                                    if args[1] and type(args[1]) == "table" then
                                        if args[1].Position then
                                            args[1].Position = targetPos
                                        end
                                        if args[1].Direction then
                                            args[1].Direction = (targetPos - origin).Unit
                                        end
                                    end
                                end
                            end
                            
                            return oldFire(self, unpack(args))
                        end
                    end)
                end
            end
        end
    end
    
    -- Hook workspace.Raycast cho silent aim
    local oldRaycast = workspace.Raycast
    workspace.Raycast = function(self, origin, direction, params)
        if settings.silentAim.enabled then
            local target = getSilentAimTarget()
            if target then
                -- Kiểm tra xem có phải đang bắn không
                local callingScript = getcallingscript()
                if callingScript then
                    local scriptName = tostring(callingScript)
                    if scriptName:find("Weapon") or scriptName:find("Gun") or scriptName:find("Shoot") or scriptName:find("Projectile") then
                        local originPos = Camera.CFrame.Position
                        local targetPos = target.Position
                        return oldRaycast(self, originPos, (targetPos - originPos).Unit * 1000, params)
                    end
                end
            end
        end
        return oldRaycast(self, origin, direction, params)
    end
    
    -- Hook __namecall cho các method raycast
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if method == "Raycast" then
            if settings.silentAim.enabled then
                local target = getSilentAimTarget()
                if target then
                    local callingScript = getcallingscript()
                    if callingScript then
                        local scriptName = tostring(callingScript)
                        if scriptName:find("Weapon") or scriptName:find("Gun") or scriptName:find("Shoot") or scriptName:find("Projectile") then
                            local originPos = Camera.CFrame.Position
                            local targetPos = target.Position
                            args[1] = originPos
                            args[2] = (targetPos - originPos).Unit * 1000
                        end
                    end
                end
            end
        end
        
        return oldNamecall(self, unpack(args))
    end)
    
    silentAimRemoteHooked = true
    print("✅ Silent Aim Remote Hooked!")
end

-- Khởi tạo Silent Aim
task.spawn(function()
    task.wait(2)
    setupSilentAimRemote()
end)

-- ============ HÀM ĐỔI TÊN ==========
local oldName = LocalPlayer.Name
local oldDisplay = LocalPlayer.DisplayName
local isNameChanging = false

local function changePlayerName(newName)
    if not newName or newName == "" then return false end
    if isNameChanging then return false end
    isNameChanging = true
    
    pcall(function()
        LocalPlayer.DisplayName = newName
        
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.DisplayName = newName
            end
        end
        
        local function replaceText(inst)
            if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
                if inst.Text and inst.Text ~= "" then
                    local txt = inst.Text
                    local changed = false
                    if txt:find(oldName) then
                        txt = txt:gsub(oldName, newName)
                        changed = true
                    end
                    if oldDisplay ~= oldName and txt:find(oldDisplay) then
                        txt = txt:gsub(oldDisplay, newName)
                        changed = true
                    end
                    if changed then
                        inst.Text = txt
                    end
                end
            end
        end
        
        for _, v in pairs(game:GetDescendants()) do
            replaceText(v)
        end
        
        local conn
        conn = game.DescendantAdded:Connect(function(desc)
            replaceText(desc)
            for _, child in pairs(desc:GetDescendants()) do
                replaceText(child)
            end
        end)
        
        if not _G.nameChangeConnections then
            _G.nameChangeConnections = {}
        end
        table.insert(_G.nameChangeConnections, conn)
        
        local charConn
        charConn = LocalPlayer.CharacterAdded:Connect(function(newChar)
            task.wait()
            local hum = newChar:FindFirstChild("Humanoid")
            if hum then
                hum.DisplayName = newName
            end
        end)
        table.insert(_G.nameChangeConnections, charConn)
    end)
    
    isNameChanging = false
    return true
end

-- ============ HÀM KHÓA STATS ==========
local function lockStatsValue()
    if not settings.lockStats.enabled then return end
    
    if settings.lockStats.level > 0 then
        if LocalPlayer:GetAttribute("Level") ~= settings.lockStats.level then
            LocalPlayer:SetAttribute("Level", settings.lockStats.level)
        end
    end
    
    if settings.lockStats.streak > 0 then
        if LocalPlayer:GetAttribute("StatisticDuelsWinStreak") ~= settings.lockStats.streak then
            LocalPlayer:SetAttribute("StatisticDuelsWinStreak", settings.lockStats.streak)
        end
    end
    
    if settings.lockStats.elo > 0 then
        if LocalPlayer:GetAttribute("DisplayELO") ~= settings.lockStats.elo and settings.lockStats.elo > 0 then
            LocalPlayer:SetAttribute("DisplayELO", settings.lockStats.elo)
        end
    end
    
    local customStats = LocalPlayer:FindFirstChild("CustomLeaderstats")
    if customStats then
        if settings.lockStats.level > 0 then
            local levelStat = customStats:FindFirstChild("Level")
            if levelStat and levelStat.Value ~= settings.lockStats.level then
                levelStat.Value = settings.lockStats.level
            end
        end
        
        if settings.lockStats.streak > 0 then
            local streakStat = customStats:FindFirstChild("Win Streak")
            if streakStat and streakStat.Value ~= settings.lockStats.streak then
                streakStat.Value = settings.lockStats.streak
            end
        end
        
        if settings.lockStats.elo > 0 then
            local eloStat = customStats:FindFirstChild("Current ELO")
            if eloStat and eloStat.Value ~= settings.lockStats.elo then
                eloStat.Value = settings.lockStats.elo
            end
        end
    end
end

LocalPlayer.AttributeChanged:Connect(function(attr)
    if attr == "Level" or attr == "StatisticDuelsWinStreak" or attr == "DisplayELO" then
        lockStatsValue()
    end
end)

local function watchLeaderstats()
    local customStats = LocalPlayer:FindFirstChild("CustomLeaderstats")
    if customStats then
        if settings.lockStats.level > 0 then
            local levelStat = customStats:FindFirstChild("Level")
            if levelStat then
                levelStat:GetPropertyChangedSignal("Value"):Connect(function()
                    if levelStat.Value ~= settings.lockStats.level then
                        levelStat.Value = settings.lockStats.level
                    end
                end)
            end
        end
        
        if settings.lockStats.streak > 0 then
            local streakStat = customStats:FindFirstChild("Win Streak")
            if streakStat then
                streakStat:GetPropertyChangedSignal("Value"):Connect(function()
                    if streakStat.Value ~= settings.lockStats.streak then
                        streakStat.Value = settings.lockStats.streak
                    end
                end)
            end
        end
        
        if settings.lockStats.elo > 0 then
            local eloStat = customStats:FindFirstChild("Current ELO")
            if eloStat then
                eloStat:GetPropertyChangedSignal("Value"):Connect(function()
                    if eloStat.Value ~= settings.lockStats.elo then
                        eloStat.Value = settings.lockStats.elo
                    end
                end)
            end
        end
    end
end

watchLeaderstats()
LocalPlayer.ChildAdded:Connect(function(child)
    if child.Name == "CustomLeaderstats" then
        watchLeaderstats()
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        lockStatsValue()
    end
end)

-- ============ AFK CONTROL ==========
local function updateAFK()
    if _G.AntiAFKControl then
        if settings.afk.enabled then
            _G.AntiAFKControl.start()
        else
            _G.AntiAFKControl.stop()
        end
        _G.AntiAFKControl.setInterval(settings.afk.interval)
    end
end

local function updateAFKStatus()
    -- Sẽ được định nghĩa sau khi UI tạo
end

-- ============ LOAD CONFIG TỰ ĐỘNG TRƯỚC KHI TẠO UI ==========
local function ensureConfigFolder()
    local success = pcall(function()
        if not isfolder then return false end
        if not isfolder(ConfigFolder) then
            makefolder(ConfigFolder)
        end
        return true
    end)
    return success
end

local function getAutoLoadConfig()
    local autoLoadName = nil
    pcall(function()
        if readfile and isfile then
            local autoLoadPath = ConfigFolder .. "/auto_load_config.txt"
            if isfile(autoLoadPath) then
                autoLoadName = readfile(autoLoadPath)
            end
        end
    end)
    return autoLoadName
end

local function getConfigList()
    local configs = {}
    pcall(function()
        if listfiles then
            local files = listfiles(ConfigFolder)
            for _, file in pairs(files) do
                local name = string.match(file, "([^/\\]+)%.json$")
                if name then
                    table.insert(configs, name)
                end
            end
        end
    end)
    return configs
end

local function deleteConfig(configName)
    if not configName or configName == "" then return false end
    local success = pcall(function()
        if delfile then
            delfile(ConfigFolder .. "/" .. configName .. ".json")
            return true
        end
        return false
    end)
    return success
end

local function saveAutoLoadConfig(configName)
    if not configName or configName == "" then return false end
    local success = pcall(function()
        if writefile then
            writefile(ConfigFolder .. "/auto_load_config.txt", configName)
            return true
        end
        return false
    end)
    return success
end

local function clearAutoLoadConfig()
    pcall(function()
        if delfile then
            delfile(ConfigFolder .. "/auto_load_config.txt")
        end
    end)
end

-- LOAD CONFIG NGAY LẬP TỨC
local function loadConfigBeforeUI(configName)
    if not configName or configName == "" then return false end
    
    local success, data = pcall(function()
        if readfile and isfile then
            local filePath = ConfigFolder .. "/" .. configName .. ".json"
            if isfile(filePath) then
                return readfile(filePath)
            end
        end
        return nil
    end)
    
    if success and data then
        local loaded = HttpService:JSONDecode(data)
        if loaded and loaded.settings then
            for category, values in pairs(loaded.settings) do
                if settings[category] then
                    for k, v in pairs(values) do
                        if settings[category][k] ~= nil then
                            settings[category][k] = v
                        end
                    end
                end
            end
            
            settings.esp.boxColor = Color3.fromRGB(settings.esp.boxColorR or 255, settings.esp.boxColorG or 70, settings.esp.boxColorB or 70)
            settings.esp.skeletonColor = Color3.fromRGB(settings.esp.skeletonColorR or 0, settings.esp.skeletonColorG or 200, settings.esp.skeletonColorB or 255)
            settings.esp.npcColor = Color3.fromRGB(settings.esp.npcColorR or 255, settings.esp.npcColorG or 200, settings.esp.npcColorB or 50)
            settings.aimbot.fovColor = Color3.fromRGB(settings.aimbot.fovColorR or 0, settings.aimbot.fovColorG or 200, settings.aimbot.fovColorB or 255)
            settings.aimbot.lineColor = Color3.fromRGB(settings.aimbot.lineColorR or 255, settings.aimbot.lineColorG or 0, settings.aimbot.lineColorB or 0)
            
            if loaded.settings.afk then
                settings.afk.enabled = loaded.settings.afk.enabled or true
                settings.afk.interval = loaded.settings.afk.interval or 45
            end
            
            if loaded.settings.lockStats then
                settings.lockStats.enabled = loaded.settings.lockStats.enabled or true
                settings.lockStats.level = loaded.settings.lockStats.level or 0
                settings.lockStats.streak = loaded.settings.lockStats.streak or 0
                settings.lockStats.elo = loaded.settings.lockStats.elo or 0
                settings.lockStats.customName = loaded.settings.lockStats.customName or ""
            end
            
            if loaded.settings.aimbot then
                if loaded.settings.aimbot.aimPlayers ~= nil then
                    settings.aimbot.aimPlayers = loaded.settings.aimbot.aimPlayers
                end
                if loaded.settings.aimbot.aimNPC ~= nil then
                    settings.aimbot.aimNPC = loaded.settings.aimbot.aimNPC
                end
                if loaded.settings.aimbot.xuyenTuong ~= nil then
                    settings.aimbot.xuyenTuong = loaded.settings.aimbot.xuyenTuong
                end
            end
            
            if loaded.settings.silentAim then
                settings.silentAim.enabled = loaded.settings.silentAim.enabled or false
                settings.silentAim.mode = loaded.settings.silentAim.mode or "Both"
                settings.silentAim.maxDistance = loaded.settings.silentAim.maxDistance or 200
                settings.silentAim.aimPart = loaded.settings.silentAim.aimPart or "Head"
            end
            
            if loaded.teamPlayers then
                teamPlayers = loaded.teamPlayers
            end
            
            if loaded.device then
                currentDevice = loaded.device
                task.spawn(function()
                    spoofDevice(currentDevice)
                end)
            end
            
            if loaded.savedSkins and next(loaded.savedSkins) then
                savedSkinList = loaded.savedSkins
            else
                savedSkinList = {}
            end
            
            print("✅ Đã load config trước khi tạo UI: " .. configName)
            return true
        end
    end
    return false
end

-- Tự động load config
ensureConfigFolder()
local autoLoadName = getAutoLoadConfig()
if autoLoadName and autoLoadName ~= "" then
    loadConfigBeforeUI(autoLoadName)
end

-- Dọn dẹp drawing cũ
pcall(function()
    for _, data in pairs(espBoxes or {}) do
        if data.box then
            for _, line in pairs(data.box) do line:Remove() end
        end
        if data.text then data.text:Remove() end
    end
    for _, skel in pairs(espSkeletons or {}) do
        for _, line in pairs(skel) do line:Remove() end
    end
    if aimbotFOV then aimbotFOV:Remove() end
    if aimLine then aimLine:Remove() end
end)

pcall(function() 
    local old = LocalPlayer.PlayerGui:FindFirstChild("AuroraMenu")
    if old then old:Destroy() end 
end)

-- ============ TELEPORT ==========
local lastTeleportTime = 0
local teleportCount = 0
local TELEPORT_DELAY = 0.4
local MAX_TELEPORT_BEFORE_KICK = 10

local function teleportToPosition(position)
    local character = LocalPlayer.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local currentTime = tick()
    
    if currentTime - lastTeleportTime < TELEPORT_DELAY then
        teleportCount = teleportCount + 1
        print("⚠️ Cảnh báo: Tele quá nhanh! Lần vi phạm thứ: " .. teleportCount .. "/" .. MAX_TELEPORT_BEFORE_KICK)
        
        if teleportCount >= MAX_TELEPORT_BEFORE_KICK then
            print("🔴 ĐÃ KICK NGƯỜI DÙNG VÌ SPAM TELEPORT!")
            if LocalPlayer and not LocalPlayer:GetAttribute("Kicked") then
                LocalPlayer:SetAttribute("Kicked", true)
                LocalPlayer:Kick([[Banned by the Anticheat. NO APPEALS.]])
            end
            return
        end
    else
        teleportCount = 0
    end
    
    lastTeleportTime = currentTime
    humanoidRootPart.CFrame = CFrame.new(position)
    character:SetPrimaryPartCFrame(CFrame.new(position))
end

local function getMouseWorldPosition()
    local mouse = LocalPlayer:GetMouse()
    local unitRay = mouse.UnitRay
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, raycastParams)
    if result then return result.Position end
    return nil
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.X and settings.teleport.enabled then
        local targetPos = getMouseWorldPosition()
        if targetPos then 
            teleportToPosition(targetPos)
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if tick() - lastTeleportTime > 3 then
            if teleportCount > 0 then
                print("✅ Đã reset bộ đếm teleport (không tele trong 3 giây)")
            end
            teleportCount = 0
        end
    end
end)

-- FOV CIRCLE
local aimbotFOV = Drawing.new("Circle")
aimbotFOV.Thickness = 2
aimbotFOV.NumSides = 72
aimbotFOV.Radius = settings.aimbot.fovRadius
aimbotFOV.Color = settings.aimbot.fovColor
aimbotFOV.Filled = false
aimbotFOV.Visible = settings.aimbot.showFOV
aimbotFOV.Transparency = 0.4

local aimLine = Drawing.new("Line")
aimLine.Thickness = 2
aimLine.Color = settings.aimbot.lineColor
aimLine.Visible = false
aimLine.Transparency = 0.8

local function updateFOVPos()
    aimbotFOV.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end
updateFOVPos()
Camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateFOVPos)

-- LẤY DANH SÁCH MỤC TIÊU
local function getAllTargets()
    local targets = {}
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return targets end
    
    local aimPlayers = settings.aimbot.aimPlayers
    if aimPlayers == nil then aimPlayers = true end
    
    if (settings.aimbot.aimMode == "Players" or settings.aimbot.aimMode == "Both") and aimPlayers then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if settings.aimbot.ignoreTeam and isTeammate(player) then
                else
                    local char = player.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        local targetPart = char:FindFirstChild(settings.aimbot.aimPart)
                        if hum and hum.Health > 0 and targetPart then
                            local distance = (myRoot.Position - targetPart.Position).Magnitude
                            if distance <= settings.aimbot.maxDistance then
                                table.insert(targets, {type = "Player", name = player.Name, part = targetPart, character = char, distance = distance, player = player})
                            end
                        end
                    end
                end
            end
        end
    end
    
    local aimNPCs = settings.aimbot.aimNPC
    if aimNPCs == nil then aimNPCs = true end
    
    if (settings.aimbot.aimMode == "NPCs" or settings.aimbot.aimMode == "Both") and aimNPCs then
        local shootingRange = workspace:FindFirstChild("ShootingRangeEntities")
        if shootingRange then
            for _, npc in pairs(shootingRange:GetChildren()) do
                local hum = npc:FindFirstChildOfClass("Humanoid") or npc:FindFirstChild("Humanoid")
                local targetPart = npc:FindFirstChild(settings.aimbot.aimPart) or npc:FindFirstChild("Head") or npc:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health and hum.Health > 0 and targetPart then
                    local distance = (myRoot.Position - targetPart.Position).Magnitude
                    if distance <= settings.aimbot.maxDistance then
                        table.insert(targets, {type = "NPC", name = npc.Name, part = targetPart, character = npc, distance = distance})
                    end
                end
            end
        end
        
        local npcContainer = workspace:FindFirstChild("NPCs")
        if npcContainer then
            for _, npc in pairs(npcContainer:GetChildren()) do
                local hum = npc:FindFirstChildOfClass("Humanoid") or npc:FindFirstChild("Humanoid")
                local targetPart = npc:FindFirstChild(settings.aimbot.aimPart) or npc:FindFirstChild("Head") or npc:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health and hum.Health > 0 and targetPart then
                    local distance = (myRoot.Position - targetPart.Position).Magnitude
                    if distance <= settings.aimbot.maxDistance then
                        table.insert(targets, {type = "NPC", name = npc.Name, part = targetPart, character = npc, distance = distance})
                    end
                end
            end
        end
    end
    return targets
end

local function canSeeTarget(targetPart)
    if settings.aimbot.xuyenTuong then
        return true
    end
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit * (targetPart.Position - origin).Magnitude
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    local result = workspace:Raycast(origin, direction, raycastParams)
    if result and result.Instance then
        local hitPart = result.Instance
        local targetParent = targetPart.Parent
        if hitPart:IsDescendantOf(targetParent) then return true end
        return false
    end
    return true
end

-- SKELETON ESP
local function getSkeletonParts(character)
    local parts = {}
    local names = {"Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"}
    for _, name in ipairs(names) do
        local part = character:FindFirstChild(name)
        if part then parts[name] = part end
    end
    return parts
end

local function drawSkeleton(skelLines, parts, color)
    for _, line in pairs(skelLines) do line.Visible = false end
    if not parts.Head or not parts.UpperTorso then return end
    
    local connections = {
        {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
    }
    
    for _, conn in ipairs(connections) do
        local p1 = parts[conn[1]]
        local p2 = parts[conn[2]]
        if p1 and p2 then
            local pos1, on1 = Camera:WorldToViewportPoint(p1.Position)
            local pos2, on2 = Camera:WorldToViewportPoint(p2.Position)
            if on1 and on2 then
                local key = conn[1] .. "_" .. conn[2]
                local line = skelLines[key]
                if not line then
                    line = Drawing.new("Line")
                    line.Thickness = 2
                    skelLines[key] = line
                end
                line.From = Vector2.new(pos1.X, pos1.Y)
                line.To = Vector2.new(pos2.X, pos2.Y)
                line.Color = color
                line.Visible = true
            end
        end
    end
end

-- AIMBOT
local lastShotTime = 0
local SHOT_DELAY = 0.01

local function shoot()
    local currentTime = tick()
    if currentTime - lastShotTime < SHOT_DELAY then return end
    lastShotTime = currentTime
    
    if mouse1click then
        mouse1click()
    else
        VirtualInput:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, Enum.UserInputState.Begin, nil, false)
        task.wait(0.001)
        VirtualInput:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, Enum.UserInputState.End, nil, false)
    end
end

local function getBestTarget()
    local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local bestTarget = nil
    local bestScore = settings.aimbot.fovRadius
    local targets = getAllTargets()
    for _, target in ipairs(targets) do
        local screenPos, onScreen = Camera:WorldToViewportPoint(target.part.Position)
        if onScreen then
            local distToCenter = (Vector2.new(screenPos.X, screenPos.Y) - centerScreen).Magnitude
            if distToCenter < bestScore then
                bestScore = distToCenter
                bestTarget = target
            end
        end
    end
    return bestTarget
end

local function moveToTarget(targetData)
    if not targetData or not targetData.part then return false end
    local targetPos, onScreen = Camera:WorldToViewportPoint(targetData.part.Position)
    if not onScreen then return false end
    local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local delta = Vector2.new(targetPos.X, targetPos.Y) - centerScreen
    if delta.Magnitude < 1 then return true end
    local moveX = delta.X / math.max(settings.aimbot.smoothness, 0.5)
    local moveY = delta.Y / math.max(settings.aimbot.smoothness, 0.5)
    moveX = math.clamp(moveX, -30, 30)
    moveY = math.clamp(moveY, -30, 30)
    if mousemoverel then
        mousemoverel(moveX, moveY)
    elseif syn and syn.mouse_move then
        syn.mouse_move(moveX, moveY)
    else
        local mouse = LocalPlayer:GetMouse()
        VirtualInput:SendMouseMoveEvent(mouse.X + moveX, mouse.Y + moveY)
    end
    return delta.Magnitude < 1
end

local isAiming = false
local lockedTarget = nil

local function isTargetAlive(targetData)
    if not targetData or not targetData.character then return false end
    local hum = targetData.character:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health and hum.Health > 0
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 and settings.aimbot.enabled then 
        isAiming = true 
    end
end)

UserInputService.InputEnded:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then 
        isAiming = false
        lockedTarget = nil
    end
end)

-- RENDER STEP CHÍNH
RunService.RenderStepped:Connect(function()
    local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local bestTarget = getBestTarget()
    
    if settings.aimbot.showLine and bestTarget and bestTarget.part then
        local targetPos, onScreen = Camera:WorldToViewportPoint(bestTarget.part.Position)
        if onScreen then
            aimLine.From = centerScreen
            aimLine.To = Vector2.new(targetPos.X, targetPos.Y)
            aimLine.Color = settings.aimbot.lineColor
            aimLine.Thickness = 2
            aimLine.Transparency = 0.8
            aimLine.Visible = true
        else
            aimLine.Visible = false
        end
    else
        aimLine.Visible = false
    end
    
    if not (settings.aimbot.enabled and isAiming) then 
        lockedTarget = nil
        return 
    end
    
    if lockedTarget and not isTargetAlive(lockedTarget) then
        lockedTarget = nil
    end
    
    local targetData = nil
    if settings.aimbot.lockTarget and lockedTarget then 
        targetData = lockedTarget 
    else 
        targetData = bestTarget
        if settings.aimbot.lockTarget and targetData then 
            lockedTarget = targetData
        end
    end
    
    if targetData and targetData.part then
        local targetPos, onScreen = Camera:WorldToViewportPoint(targetData.part.Position)
        local isOnTarget = false
        if onScreen then
            local delta = (Vector2.new(targetPos.X, targetPos.Y) - centerScreen).Magnitude
            isOnTarget = delta < 1
        end
        
        moveToTarget(targetData)
        
        if settings.aimbot.autoShot and isOnTarget then
            if canSeeTarget(targetData.part) then
                shoot()
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if settings.aimbot.enabled and isAiming then
        local pulseValue = (math.sin(tick() * 15) + 1) / 2
        aimbotFOV.Transparency = 0.2 + (pulseValue * 0.3)
        aimbotFOV.Thickness = 2 + (pulseValue * 2)
    else
        aimbotFOV.Transparency = 0.4
        aimbotFOV.Thickness = 2
    end
    
    aimbotFOV.Radius = settings.aimbot.fovRadius
    aimbotFOV.Color = settings.aimbot.fovColor
    aimbotFOV.Visible = settings.aimbot.showFOV
    aimbotFOV.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end)

-- ESP + SKELETON
local espBoxes = {}
local espSkeletons = {}

local function fullCleanupESP()
    for target, data in pairs(espBoxes) do
        if data and data.box then
            for _, line in pairs(data.box) do
                pcall(function() 
                    if line and line.Remove then line:Remove() 
                    elseif line then line.Visible = false end
                end)
            end
        end
        if data and data.text then
            pcall(function() data.text:Remove() end)
        end
    end
    
    for target, skel in pairs(espSkeletons) do
        if skel then
            for _, line in pairs(skel) do
                pcall(function() 
                    if line and line.Remove then line:Remove()
                    elseif line then line.Visible = false end
                end)
            end
        end
    end
    
    table.clear(espBoxes)
    table.clear(espSkeletons)
end

local function addESP(target, isNPC)
    if espBoxes[target] then return end
    local box = {}
    for i = 1, 4 do
        local line = Drawing.new("Line")
        line.Thickness = 2
        local isTeam = (not isNPC) and isTeammate(target)
        line.Color = isTeam and Color3.fromRGB(0, 255, 100) or (isNPC and settings.esp.npcColor or settings.esp.boxColor)
        line.Visible = true
        table.insert(box, line)
    end
    local text = Drawing.new("Text")
    text.Size = 14
    text.Center = true
    text.Outline = true
    text.Color = Color3.fromRGB(255, 255, 255)
    text.Visible = true
    espBoxes[target] = {box = box, text = text, isNPC = isNPC}
    espSkeletons[target] = {}
end

local function removeESP(target)
    if espBoxes[target] then
        for _, line in pairs(espBoxes[target].box) do 
            pcall(function() line.Visible = false line:Remove() end)
        end
        pcall(function() espBoxes[target].text:Remove() end)
        espBoxes[target] = nil
    end
    if espSkeletons[target] then
        for _, line in pairs(espSkeletons[target]) do 
            pcall(function() line:Remove() end)
        end
        espSkeletons[target] = nil
    end
end

local function cleanupAllESP()
    for target, data in pairs(espBoxes) do
        if data.box then
            for _, line in pairs(data.box) do
                pcall(function() line.Visible = false end)
            end
        end
        if data.text then
            pcall(function() data.text.Visible = false end)
        end
    end
    for _, skel in pairs(espSkeletons) do
        for _, line in pairs(skel) do
            pcall(function() line.Visible = false end)
        end
    end
end

for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        if p.Character then addESP(p, false) end
        p.CharacterAdded:Connect(function() addESP(p, false) end)
    end
end

Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then
        p.CharacterAdded:Connect(function() addESP(p, false) end)
        if p.Character then addESP(p, false) end
    end
end)
Players.PlayerRemoving:Connect(removeESP)

local function scanAndAddNPCs()
    local shootingRange = workspace:FindFirstChild("ShootingRangeEntities")
    if shootingRange then
        for _, npc in pairs(shootingRange:GetChildren()) do
            if npc:FindFirstChildOfClass("Humanoid") or npc:FindFirstChild("Humanoid") then addESP(npc, true) end
        end
    end
end
scanAndAddNPCs()

if workspace:FindFirstChild("ShootingRangeEntities") then
    workspace.ShootingRangeEntities.ChildAdded:Connect(function(npc)
        task.wait(0.1)
        if npc:FindFirstChildOfClass("Humanoid") or npc:FindFirstChild("Humanoid") then addESP(npc, true) end
    end)
    workspace.ShootingRangeEntities.ChildRemoved:Connect(function(npc) removeESP(npc) end)
end

local lastRenderTime = 0
local RENDER_INTERVAL = 1/60

RunService.RenderStepped:Connect(function()
    local currentTime = tick()
    if currentTime - lastRenderTime < RENDER_INTERVAL then
        return
    end
    lastRenderTime = currentTime
    
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local myPos = myRoot and myRoot.Position or nil
    
    if not settings.esp.enabled then
        cleanupAllESP()
        return
    end
    
    local activeTargets = {}
    for target, data in pairs(espBoxes) do
        local root = nil; local hum = nil; local char = nil
        local isTeam = false
        
        if not data.isNPC then
            char = target.Character
            root = char and char:FindFirstChild("HumanoidRootPart")
            hum = char and char:FindFirstChildOfClass("Humanoid")
            isTeam = isTeammate(target)
        else
            char = target
            root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head") or char:FindFirstChild("Torso")
            hum = char:FindFirstChildOfClass("Humanoid") or char:FindFirstChild("Humanoid")
        end
        local dist = myPos and root and (myPos - root.Position).Magnitude or 9999
        
        if not root or not hum or (hum.Health and hum.Health <= 0) or dist > settings.esp.maxDistance then
            for _, l in pairs(data.box) do l.Visible = false end
            data.text.Visible = false
            if espSkeletons[target] then for _, l in pairs(espSkeletons[target]) do l.Visible = false end end
        else
            activeTargets[target] = true
            local size = data.isNPC and Vector3.new(2, 4, 2) or (char and char:GetExtentsSize() or Vector3.new(3, 5, 3))
            local cf = root.CFrame
            local height = size.Y; local width = size.X; local depth = size.Z
            local corners = {
                cf:PointToWorldSpace(Vector3.new(-width/2, height/2, -depth/2)),
                cf:PointToWorldSpace(Vector3.new( width/2, height/2, -depth/2)),
                cf:PointToWorldSpace(Vector3.new( width/2, height/2,  depth/2)),
                cf:PointToWorldSpace(Vector3.new(-width/2, height/2,  depth/2)),
                cf:PointToWorldSpace(Vector3.new(-width/2, -height/2, -depth/2)),
                cf:PointToWorldSpace(Vector3.new( width/2, -height/2, -depth/2)),
                cf:PointToWorldSpace(Vector3.new( width/2, -height/2,  depth/2)),
                cf:PointToWorldSpace(Vector3.new(-width/2, -height/2,  depth/2))
            }
            local screenPoints = {}
            local allOnScreen = true
            for _, corner in ipairs(corners) do
                local pos, onScreen = Camera:WorldToViewportPoint(corner)
                if onScreen then table.insert(screenPoints, Vector2.new(pos.X, pos.Y))
                else allOnScreen = false end
            end
            if allOnScreen and #screenPoints > 0 then
                local minX, minY = math.huge, math.huge
                local maxX, maxY = -math.huge, -math.huge
                for _, point in ipairs(screenPoints) do
                    minX = math.min(minX, point.X); minY = math.min(minY, point.Y)
                    maxX = math.max(maxX, point.X); maxY = math.max(maxY, point.Y)
                end
                if settings.esp.box then
                    local boxColor = isTeam and Color3.fromRGB(0, 255, 100) or (data.isNPC and settings.esp.npcColor or settings.esp.boxColor)
                    for _, l in pairs(data.box) do 
                        l.Color = boxColor
                        l.Visible = true 
                    end
                    data.box[1].From = Vector2.new(minX, minY); data.box[1].To = Vector2.new(maxX, minY)
                    data.box[2].From = Vector2.new(maxX, minY); data.box[2].To = Vector2.new(maxX, maxY)
                    data.box[3].From = Vector2.new(maxX, maxY); data.box[3].To = Vector2.new(minX, maxY)
                    data.box[4].From = Vector2.new(minX, maxY); data.box[4].To = Vector2.new(minX, minY)
                else for _, l in pairs(data.box) do l.Visible = false end end
                
                if settings.esp.skeleton and not data.isNPC and char then
                    local parts = getSkeletonParts(char)
                    local skelColor = isTeam and Color3.fromRGB(0, 255, 100) or settings.esp.skeletonColor
                    drawSkeleton(espSkeletons[target], parts, skelColor)
                elseif espSkeletons[target] then 
                    for _, l in pairs(espSkeletons[target]) do l.Visible = false end 
                end
                local text = data.text
                if text then
                    local str = ""
                    if settings.esp.name then 
                        str = target.Name
                        if isTeam then str = str .. " 🤝" end
                    end
                    if settings.esp.distance then str = str .. (str ~= "" and " | " or "") .. math.floor(dist) .. "m" end
                    if settings.esp.health and hum then str = str .. (str ~= "" and " | " or "") .. math.floor(hum.Health) .. " HP" end
                    text.Text = str
                    text.Position = Vector2.new((minX + maxX) / 2, minY - 18)
                    text.Visible = str ~= ""
                end
                if settings.esp.health and hum then
                    local hpPct = hum.Health / hum.MaxHealth
                    local healthLine = espSkeletons[target]["healthBar"]
                    if not healthLine then
                        healthLine = Drawing.new("Line")
                        healthLine.Thickness = 4
                        espSkeletons[target]["healthBar"] = healthLine
                    end
                    healthLine.From = Vector2.new(minX, minY - 5)
                    healthLine.To = Vector2.new(minX + (maxX - minX) * hpPct, minY - 5)
                    healthLine.Color = Color3.fromRGB(255 - (255 * hpPct), 255 * hpPct, 0)
                    healthLine.Visible = true
                end
            else
                for _, l in pairs(data.box) do l.Visible = false end
                data.text.Visible = false
                if espSkeletons[target] then for _, l in pairs(espSkeletons[target]) do l.Visible = false end end
            end
        end
    end
    for target, skel in pairs(espSkeletons) do
        if not activeTargets[target] then for _, line in pairs(skel) do line.Visible = false end end
    end
end)

-- ============================================================
-- ============ TẠO UI SAU KHI ĐÃ LOAD CONFIG ============
-- ============================================================

-- UI NÂNG CẤP - TAB DỌC BÊN TRÁI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AuroraMenu"
screenGui.Parent = LocalPlayer.PlayerGui
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999999
screenGui.IgnoreGuiInset = true

local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 1
overlay.Visible = false
overlay.Parent = screenGui

local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 1100, 0, 720)
menu.Position = UDim2.new(0.5, -550, 0.5, -360)
menu.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
menu.BackgroundTransparency = 0.08
menu.BorderSizePixel = 0
menu.Visible = false
menu.ClipsDescendants = true
menu.Parent = screenGui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 16)
menuCorner.Parent = menu

local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 0, 1, 0)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.6
shadow.BorderSizePixel = 0
shadow.ZIndex = -1
shadow.Parent = menu

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 16)
shadowCorner.Parent = shadow

local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = menu

local glassBg = Instance.new("Frame")
glassBg.Size = UDim2.new(1, 0, 1, 0)
glassBg.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
glassBg.BackgroundTransparency = 0.15
glassBg.BorderSizePixel = 0
glassBg.Parent = menu

local glassCorner = Instance.new("UICorner")
glassCorner.CornerRadius = UDim.new(0, 16)
glassCorner.Parent = glassBg

local borderGradient = Instance.new("Frame")
borderGradient.Size = UDim2.new(1, 2, 1, 2)
borderGradient.Position = UDim2.new(0, -1, 0, -1)
borderGradient.BackgroundTransparency = 1
borderGradient.BorderSizePixel = 2
borderGradient.BorderColor3 = Color3.fromRGB(0, 200, 255)
borderGradient.BorderMode = Enum.BorderMode.Inset
borderGradient.Parent = menu

local borderCorner = Instance.new("UICorner")
borderCorner.CornerRadius = UDim.new(0, 18)
borderCorner.Parent = borderGradient

-- HEADER
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 70)
header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
header.BackgroundTransparency = 0.4
header.BorderSizePixel = 0
header.Parent = menu

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = header

local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 100, 150)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 80, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 60, 90))
})
headerGradient.Parent = header

local glowLine = Instance.new("Frame")
glowLine.Size = UDim2.new(1, 0, 0, 2)
glowLine.Position = UDim2.new(0, 0, 1, -2)
glowLine.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
glowLine.BackgroundTransparency = 0.3
glowLine.BorderSizePixel = 0
glowLine.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 0, 30)
title.Position = UDim2.new(0, 20, 0, 12)
title.BackgroundTransparency = 1
title.Text = "→KHANHGD CHEAT←"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextYAlignment = Enum.TextYAlignment.Center
title.Parent = header

local subTitle = Instance.new("TextLabel")
subTitle.Size = UDim2.new(1, -80, 0, 20)
subTitle.Position = UDim2.new(0, 22, 0, 42)
subTitle.BackgroundTransparency = 1
subTitle.Text = "ESP • Skeleton • Aimbot • Silent Aim • Auto Shot • Lock Stats • TP • AFK • Skin • Config • Device Spoofer"
subTitle.TextColor3 = Color3.fromRGB(150, 200, 255)
subTitle.TextSize = 10
subTitle.Font = Enum.Font.Gotham
subTitle.TextXAlignment = Enum.TextXAlignment.Left
subTitle.TextYAlignment = Enum.TextYAlignment.Center
subTitle.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 38, 0, 38)
closeBtn.Position = UDim2.new(1, -52, 0, 16)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
closeBtn.BackgroundTransparency = 0.5
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.Parent = header

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(1, 0)
closeBtnCorner.Parent = closeBtn

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(100, 30, 30)}):Play()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 200, 200)}):Play()
    playClickSound()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.5, BackgroundColor3 = Color3.fromRGB(40, 20, 20)}):Play()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 100, 100)}):Play()
end)

-- TAB DỌC BÊN TRÁI
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(0, 180, 1, -80)
tabBar.Position = UDim2.new(0, 0, 0, 80)
tabBar.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
tabBar.BackgroundTransparency = 0.3
tabBar.BorderSizePixel = 0
tabBar.Parent = menu

local tabList = Instance.new("ScrollingFrame")
tabList.Size = UDim2.new(1, 0, 1, 0)
tabList.BackgroundTransparency = 1
tabList.BorderSizePixel = 0
tabList.CanvasSize = UDim2.new(0, 0, 0, 500)
tabList.ScrollBarThickness = 2
tabList.Parent = tabBar

local tabLayout = Instance.new("UIListLayout")
tabLayout.Padding = UDim.new(0, 5)
tabLayout.Parent = tabList

local tabItems = {
    {name = "AIMBOT", icon = "🎯", color = Color3.fromRGB(0, 200, 255)},
    {name = "SILENT AIM", icon = "🤫", color = Color3.fromRGB(255, 200, 0)},
    {name = "ESP", icon = "👁️", color = Color3.fromRGB(0, 200, 255)},
    {name = "SKELETON", icon = "🦴", color = Color3.fromRGB(0, 200, 255)},
    {name = "SKIN", icon = "🎨", color = Color3.fromRGB(0, 200, 255)},
    {name = "LOCK STATS", icon = "🔒", color = Color3.fromRGB(255, 100, 100)},
    {name = "DEVICE", icon = "🎮", color = Color3.fromRGB(0, 200, 255)},
    {name = "TELEPORT", icon = "🌀", color = Color3.fromRGB(0, 200, 255)},
    {name = "AFK", icon = "💤", color = Color3.fromRGB(0, 200, 255)},
    {name = "PLAYERS", icon = "👥", color = Color3.fromRGB(0, 200, 255)},
    {name = "INFO", icon = "ℹ️", color = Color3.fromRGB(0, 200, 255)},
    {name = "ADMIN", icon = "👑", color = Color3.fromRGB(0, 200, 255)},
    {name = "CONFIG", icon = "⚙️", color = Color3.fromRGB(0, 200, 255)}
}

local tabButtons = {}
local activeTab = 1

local function createTabButton(item, index)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 48)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    btn.BackgroundTransparency = 0.5
    btn.BorderSizePixel = 0
    btn.Text = item.icon .. "  " .. item.name
    btn.TextColor3 = Color3.fromRGB(180, 180, 220)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamSemibold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.Parent = tabList
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    local btnGlow = Instance.new("Frame")
    btnGlow.Size = UDim2.new(0, 3, 1, -8)
    btnGlow.Position = UDim2.new(0, 0, 0, 4)
    btnGlow.BackgroundColor3 = item.color
    btnGlow.BackgroundTransparency = 1
    btnGlow.BorderSizePixel = 0
    btnGlow.Parent = btn
    
    btn.MouseEnter:Connect(function()
        if activeTab ~= index then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.2, TextColor3 = Color3.fromRGB(230, 230, 255)}):Play()
            TweenService:Create(btnGlow, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if activeTab ~= index then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.5, TextColor3 = Color3.fromRGB(180, 180, 220)}):Play()
            TweenService:Create(btnGlow, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
        end
    end)
    
    return btn
end

for i, item in ipairs(tabItems) do
    local btn = createTabButton(item, i)
    tabButtons[i] = btn
end

-- Content Area
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -200, 1, -90)
contentArea.Position = UDim2.new(0, 190, 0, 85)
contentArea.BackgroundTransparency = 1
contentArea.Parent = menu

-- Panels
local aimbotPanel = Instance.new("ScrollingFrame")
aimbotPanel.Size = UDim2.new(1, 0, 1, 0)
aimbotPanel.BackgroundTransparency = 1
aimbotPanel.BorderSizePixel = 0
aimbotPanel.CanvasSize = UDim2.new(0, 0, 0, 1400)
aimbotPanel.ScrollBarThickness = 4
aimbotPanel.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 200)
aimbotPanel.Parent = contentArea

local silentAimPanel = Instance.new("ScrollingFrame")
silentAimPanel.Size = UDim2.new(1, 0, 1, 0)
silentAimPanel.BackgroundTransparency = 1
silentAimPanel.BorderSizePixel = 0
silentAimPanel.CanvasSize = UDim2.new(0, 0, 0, 500)
silentAimPanel.ScrollBarThickness = 4
silentAimPanel.ScrollBarImageColor3 = Color3.fromRGB(255, 200, 0)
silentAimPanel.Parent = contentArea
silentAimPanel.Visible = false

local espPanel = Instance.new("ScrollingFrame")
espPanel.Size = UDim2.new(1, 0, 1, 0)
espPanel.BackgroundTransparency = 1
espPanel.BorderSizePixel = 0
espPanel.CanvasSize = UDim2.new(0, 0, 0, 850)
espPanel.ScrollBarThickness = 4
espPanel.Parent = contentArea
espPanel.Visible = false

local skeletonPanel = Instance.new("ScrollingFrame")
skeletonPanel.Size = UDim2.new(1, 0, 1, 0)
skeletonPanel.BackgroundTransparency = 1
skeletonPanel.BorderSizePixel = 0
skeletonPanel.CanvasSize = UDim2.new(0, 0, 0, 200)
skeletonPanel.ScrollBarThickness = 4
skeletonPanel.Parent = contentArea
skeletonPanel.Visible = false

local lockStatsPanel = Instance.new("ScrollingFrame")
lockStatsPanel.Size = UDim2.new(1, 0, 1, 0)
lockStatsPanel.BackgroundTransparency = 1
lockStatsPanel.BorderSizePixel = 0
lockStatsPanel.CanvasSize = UDim2.new(0, 0, 0, 1100)
lockStatsPanel.ScrollBarThickness = 4
lockStatsPanel.Parent = contentArea
lockStatsPanel.Visible = false

local devicePanel = Instance.new("ScrollingFrame")
devicePanel.Size = UDim2.new(1, 0, 1, 0)
devicePanel.BackgroundTransparency = 1
devicePanel.BorderSizePixel = 0
devicePanel.CanvasSize = UDim2.new(0, 0, 0, 400)
devicePanel.ScrollBarThickness = 4
devicePanel.Parent = contentArea
devicePanel.Visible = false

local tpPanel = Instance.new("ScrollingFrame")
tpPanel.Size = UDim2.new(1, 0, 1, 0)
tpPanel.BackgroundTransparency = 1
tpPanel.BorderSizePixel = 0
tpPanel.CanvasSize = UDim2.new(0, 0, 0, 350)
tpPanel.ScrollBarThickness = 4
tpPanel.Parent = contentArea
tpPanel.Visible = false

local afkPanel = Instance.new("ScrollingFrame")
afkPanel.Size = UDim2.new(1, 0, 1, 0)
afkPanel.BackgroundTransparency = 1
afkPanel.BorderSizePixel = 0
afkPanel.CanvasSize = UDim2.new(0, 0, 0, 550)
afkPanel.ScrollBarThickness = 4
afkPanel.Parent = contentArea
afkPanel.Visible = false

local playersPanel = Instance.new("ScrollingFrame")
playersPanel.Size = UDim2.new(1, 0, 1, 0)
playersPanel.BackgroundTransparency = 1
playersPanel.BorderSizePixel = 0
playersPanel.CanvasSize = UDim2.new(0, 0, 0, 800)
playersPanel.ScrollBarThickness = 4
playersPanel.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 200)
playersPanel.Parent = contentArea
playersPanel.Visible = false

local infoPanel = Instance.new("ScrollingFrame")
infoPanel.Size = UDim2.new(1, 0, 1, 0)
infoPanel.BackgroundTransparency = 1
infoPanel.BorderSizePixel = 0
infoPanel.CanvasSize = UDim2.new(0, 0, 0, 850)
infoPanel.ScrollBarThickness = 4
infoPanel.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 200)
infoPanel.Parent = contentArea
infoPanel.Visible = false

local adminPanel = Instance.new("ScrollingFrame")
adminPanel.Size = UDim2.new(1, 0, 1, 0)
adminPanel.BackgroundTransparency = 1
adminPanel.BorderSizePixel = 0
adminPanel.CanvasSize = UDim2.new(0, 0, 0, 650)
adminPanel.ScrollBarThickness = 4
adminPanel.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 200)
adminPanel.Parent = contentArea
adminPanel.Visible = false

local configPanel = Instance.new("ScrollingFrame")
configPanel.Size = UDim2.new(1, 0, 1, 0)
configPanel.BackgroundTransparency = 1
configPanel.BorderSizePixel = 0
configPanel.CanvasSize = UDim2.new(0, 0, 0, 850)
configPanel.ScrollBarThickness = 4
configPanel.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 200)
configPanel.Parent = contentArea
configPanel.Visible = false

-- SKIN PANEL
local skinPanel = Instance.new("ScrollingFrame")
skinPanel.Size = UDim2.new(1, 0, 1, 0)
skinPanel.BackgroundTransparency = 1
skinPanel.BorderSizePixel = 0
skinPanel.CanvasSize = UDim2.new(0, 0, 0, 950)
skinPanel.ScrollBarThickness = 4
skinPanel.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 200)
skinPanel.Parent = contentArea
skinPanel.Visible = false

-- Helper Functions
local function createModernToggle(parent, y, name, getValue, setValue)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 48)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 0, 25)
    label.Position = UDim2.new(0, 15, 0, 12)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(230, 230, 255)
    label.TextSize = 12
    label.Font = Enum.Font.GothamSemibold
    label.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 70, 0, 28)
    toggleBtn.Position = UDim2.new(1, -85, 0, 10)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = getValue() and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 10
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = toggleBtn
    
    local function update()
        local val = getValue()
        local targetColor = val and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(60, 60, 85)
        TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        toggleBtn.Text = val and "ON" or "OFF"
    end
    update()
    
    toggleBtn.MouseButton1Click:Connect(function()
        playClickSound()
        setValue(not getValue())
        update()
    end)
    toggleBtn.MouseEnter:Connect(function()
        TweenService:Create(toggleBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.1}):Play()
    end)
    toggleBtn.MouseLeave:Connect(function()
        TweenService:Create(toggleBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
    end)
    
    return frame
end

local function createModernSlider(parent, y, name, minVal, maxVal, defaultValue, suffix, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 70)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 160, 0, 20)
    label.Position = UDim2.new(0, 15, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(230, 230, 255)
    label.TextSize = 12
    label.Font = Enum.Font.GothamSemibold
    label.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 60, 0, 20)
    valueLabel.Position = UDim2.new(1, -75, 0, 8)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultValue) .. suffix
    valueLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    valueLabel.TextSize = 11
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -170, 0, 4)
    sliderBg.Position = UDim2.new(0, 160, 0, 40)
    sliderBg.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(0, 2)
    sliderBgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultValue - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 2)
    fillCorner.Parent = sliderFill
    
    local handle = Instance.new("TextButton")
    handle.Size = UDim2.new(0, 16, 0, 16)
    handle.Position = UDim2.new((defaultValue - minVal) / (maxVal - minVal), -8, 0.5, -8)
    handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    handle.BorderSizePixel = 0
    handle.Text = ""
    handle.Parent = sliderBg
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(0, 8)
    handleCorner.Parent = handle
    
    local dragging = false
    handle.MouseButton1Down:Connect(function() dragging = true end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = LocalPlayer:GetMouse()
            local sPos = sliderBg.AbsolutePosition.X
            local sWid = sliderBg.AbsoluteSize.X
            local percent = math.clamp((mousePos.X - sPos) / sWid, 0, 1)
            local value = math.floor(minVal + (maxVal - minVal) * percent)
            valueLabel.Text = tostring(value) .. suffix
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            handle.Position = UDim2.new(percent, -8, 0.5, -8)
            callback(value)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    
    return frame
end

local function createColorPicker(parent, y, name, getR, getG, getB, setR, setG, setB, updateColor)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 160)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, -10, 0, 25)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(230, 230, 255)
    label.TextSize = 11
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local preview = Instance.new("Frame")
    preview.Size = UDim2.new(0, 40, 0, 40)
    preview.Position = UDim2.new(1, -55, 0, 5)
    preview.BackgroundColor3 = Color3.fromRGB(getR(), getG(), getB())
    preview.BorderSizePixel = 0
    preview.Parent = frame
    local previewCorner = Instance.new("UICorner")
    previewCorner.CornerRadius = UDim.new(0, 8)
    previewCorner.Parent = preview
    
    local function createSlider(parent, x, y, w, h, labelText, minVal, maxVal, getVal, setVal, color)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(0, w, 0, h)
        sliderFrame.Position = UDim2.new(0, x, 0, y)
        sliderFrame.BackgroundTransparency = 1
        sliderFrame.Parent = parent
        
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Size = UDim2.new(0, 25, 0, 18)
        sliderLabel.Position = UDim2.new(0, 0, 0, 0)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = labelText
        sliderLabel.TextColor3 = color
        sliderLabel.TextSize = 10
        sliderLabel.Font = Enum.Font.GothamBold
        sliderLabel.Parent = sliderFrame
        
        local valueText = Instance.new("TextLabel")
        valueText.Size = UDim2.new(0, 35, 0, 18)
        valueText.Position = UDim2.new(1, -35, 0, 0)
        valueText.BackgroundTransparency = 1
        valueText.Text = tostring(getVal())
        valueText.TextColor3 = color
        valueText.TextSize = 9
        valueText.Font = Enum.Font.Gotham
        valueText.TextXAlignment = Enum.TextXAlignment.Right
        valueText.Parent = sliderFrame
        
        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(1, -70, 0, 4)
        sliderBg.Position = UDim2.new(0, 28, 0, 18)
        sliderBg.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        sliderBg.BorderSizePixel = 0
        sliderBg.Parent = sliderFrame
        local sliderBgCorner = Instance.new("UICorner")
        sliderBgCorner.CornerRadius = UDim.new(0, 2)
        sliderBgCorner.Parent = sliderBg
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new((getVal() - minVal) / (maxVal - minVal), 0, 1, 0)
        sliderFill.BackgroundColor3 = color
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBg
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 2)
        fillCorner.Parent = sliderFill
        
        local handle = Instance.new("TextButton")
        handle.Size = UDim2.new(0, 14, 0, 14)
        handle.Position = UDim2.new((getVal() - minVal) / (maxVal - minVal), -7, 0.5, -7)
        handle.BackgroundColor3 = color
        handle.BorderSizePixel = 0
        handle.Text = ""
        handle.Parent = sliderBg
        local handleCorner = Instance.new("UICorner")
        handleCorner.CornerRadius = UDim.new(0, 7)
        handleCorner.Parent = handle
        
        local dragging = false
        handle.MouseButton1Down:Connect(function() dragging = true end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mousePos = LocalPlayer:GetMouse()
                local sPos = sliderBg.AbsolutePosition.X
                local sWid = sliderBg.AbsoluteSize.X
                local percent = math.clamp((mousePos.X - sPos) / sWid, 0, 1)
                local value = math.floor(minVal + (maxVal - minVal) * percent)
                setVal(value)
                valueText.Text = tostring(value)
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                handle.Position = UDim2.new(percent, -7, 0.5, -7)
                preview.BackgroundColor3 = Color3.fromRGB(getR(), getG(), getB())
                updateColor()
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        
        return sliderFrame
    end
    
    createSlider(frame, 10, 45, 200, 35, "R", 0, 255, getR, setR, Color3.fromRGB(255, 80, 80))
    createSlider(frame, 10, 65, 200, 35, "G", 0, 255, getG, setG, Color3.fromRGB(80, 255, 80))
    createSlider(frame, 10, 85, 200, 35, "B", 0, 255, getB, setB, Color3.fromRGB(80, 80, 255))
    
    return frame
end

local function createDeviceButton(parent, y, name, deviceValue, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 42)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = color or Color3.fromRGB(45, 45, 65)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(1, 0, 0, 2)
    glow.Position = UDim2.new(0, 0, 1, -2)
    glow.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    glow.BackgroundTransparency = 1
    glow.BorderSizePixel = 0
    glow.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        playClickSound()
        spoofDevice(deviceValue)
        btn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
        TweenService:Create(glow, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
        task.wait(0.2)
        TweenService:Create(glow, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        btn.BackgroundColor3 = color or Color3.fromRGB(45, 45, 65)
        
        local notif = Drawing.new("Text")
        notif.Text = "✅ Đã chuyển sang " .. name
        notif.Size = 13
        notif.Color = Color3.fromRGB(0, 255, 0)
        notif.Center = true
        notif.Outline = true
        notif.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        notif.Visible = true
        task.wait(1)
        notif.Visible = false
        notif:Remove()
    end)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
    end)
    
    return btn
end

-- ============ SKIN PANEL UI ==========
local function refreshSkinPanel()
    for _, child in pairs(skinPanel:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local y = 5
    
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(1, -10, 0, 50)
    titleFrame.Position = UDim2.new(0, 5, 0, y)
    titleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    titleFrame.BackgroundTransparency = 0.4
    titleFrame.BorderSizePixel = 0
    titleFrame.Parent = skinPanel
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 35)
    titleLabel.Position = UDim2.new(0, 10, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🎨 SKIN CHANGER - SAU KHI SKIN ĐƯỢC APPLY VUI LÒNG BẤM NÚT BỎ CHỌN Ở DƯỚI ↓"
    titleLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.Parent = titleFrame
    
    y = y + 60
    
    local selectedFrame = Instance.new("Frame")
    selectedFrame.Size = UDim2.new(1, -10, 0, 60)
    selectedFrame.Position = UDim2.new(0, 5, 0, y)
    selectedFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    selectedFrame.BackgroundTransparency = 0.4
    selectedFrame.BorderSizePixel = 1
    selectedFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
    selectedFrame.Parent = skinPanel
    local selectedCorner = Instance.new("UICorner")
    selectedCorner.CornerRadius = UDim.new(0, 10)
    selectedCorner.Parent = selectedFrame
    
    local selectedSkinLabel = Instance.new("TextLabel")
    selectedSkinLabel.Size = UDim2.new(0.5, -10, 0, 22)
    selectedSkinLabel.Position = UDim2.new(0, 10, 0, 6)
    selectedSkinLabel.BackgroundTransparency = 1
    selectedSkinLabel.Text = "🎨 Skin: Chưa chọn"
    selectedSkinLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    selectedSkinLabel.TextSize = 10
    selectedSkinLabel.Font = Enum.Font.GothamBold
    selectedSkinLabel.TextXAlignment = Enum.TextXAlignment.Left
    selectedSkinLabel.Parent = selectedFrame
    
    local selectedWeaponLabel = Instance.new("TextLabel")
    selectedWeaponLabel.Size = UDim2.new(0.5, -10, 0, 22)
    selectedWeaponLabel.Position = UDim2.new(0.5, 5, 0, 6)
    selectedWeaponLabel.BackgroundTransparency = 1
    selectedWeaponLabel.Text = "🔫 Vũ khí: Chưa chọn"
    selectedWeaponLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    selectedWeaponLabel.TextSize = 10
    selectedWeaponLabel.Font = Enum.Font.GothamBold
    selectedWeaponLabel.TextXAlignment = Enum.TextXAlignment.Left
    selectedWeaponLabel.Parent = selectedFrame
    
    local clearAllBtn = Instance.new("TextButton")
    clearAllBtn.Size = UDim2.new(0, 80, 0, 28)
    clearAllBtn.Position = UDim2.new(1, -90, 0, 28)
    clearAllBtn.BackgroundColor3 = Color3.fromRGB(100, 60, 60)
    clearAllBtn.Text = "BỎ CHỌN"
    clearAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearAllBtn.TextSize = 10
    clearAllBtn.Font = Enum.Font.GothamBold
    clearAllBtn.Parent = selectedFrame
    local clearCorner = Instance.new("UICorner")
    clearCorner.CornerRadius = UDim.new(0, 5)
    clearCorner.Parent = clearAllBtn
    
    local function updateSelectedDisplay()
        if selectedSkin then
            selectedSkinLabel.Text = "🎨 Skin: " .. selectedSkin.name
            selectedSkinLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            selectedSkinLabel.Text = "🎨 Skin: Chưa chọn"
            selectedSkinLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
        end
        
        if selectedWeapon then
            selectedWeaponLabel.Text = "🔫 Vũ khí: " .. selectedWeapon.name
            selectedWeaponLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            selectedWeaponLabel.Text = "🔫 Vũ khí: Chưa chọn"
            selectedWeaponLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
        end
    end
    
    clearAllBtn.MouseButton1Click:Connect(function()
        playClickSound()
        selectedSkin = nil
        selectedWeapon = nil
        updateSelectedDisplay()
        
        for _, child in pairs(sourceScroll:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
            end
        end
        for _, child in pairs(weaponScroll:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
            end
        end
        
        skinStatus.Text = "✅ Đã bỏ chọn"
        skinStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
    end)
    
    y = y + 75
    
    local sourceFrame = Instance.new("Frame")
    sourceFrame.Size = UDim2.new(0.5, -10, 0, 220)
    sourceFrame.Position = UDim2.new(0, 5, 0, y)
    sourceFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    sourceFrame.BackgroundTransparency = 0.4
    sourceFrame.BorderSizePixel = 0
    sourceFrame.Parent = skinPanel
    local sourceCorner = Instance.new("UICorner")
    sourceCorner.CornerRadius = UDim.new(0, 10)
    sourceCorner.Parent = sourceFrame
    
    local sourceLabel = Instance.new("TextLabel")
    sourceLabel.Size = UDim2.new(1, -10, 0, 22)
    sourceLabel.Position = UDim2.new(0, 8, 0, 5)
    sourceLabel.BackgroundTransparency = 1
    sourceLabel.Text = "📦 SKIN"
    sourceLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    sourceLabel.TextSize = 11
    sourceLabel.Font = Enum.Font.GothamBold
    sourceLabel.TextXAlignment = Enum.TextXAlignment.Left
    sourceLabel.Parent = sourceFrame
    
    local sourceSearch = Instance.new("TextBox")
    sourceSearch.Size = UDim2.new(1, -16, 0, 28)
    sourceSearch.Position = UDim2.new(0, 8, 0, 30)
    sourceSearch.PlaceholderText = "🔍 Tìm skin..."
    sourceSearch.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    sourceSearch.Text = ""
    sourceSearch.TextColor3 = Color3.fromRGB(255, 255, 255)
    sourceSearch.TextSize = 11
    sourceSearch.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
    sourceSearch.BorderSizePixel = 0
    sourceSearch.Parent = sourceFrame
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 6)
    searchCorner.Parent = sourceSearch
    
    local sourceScroll = Instance.new("ScrollingFrame")
    sourceScroll.Size = UDim2.new(1, -16, 0, 155)
    sourceScroll.Position = UDim2.new(0, 8, 0, 62)
    sourceScroll.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    sourceScroll.BackgroundTransparency = 0.3
    sourceScroll.BorderSizePixel = 1
    sourceScroll.BorderColor3 = Color3.fromRGB(80, 80, 120)
    sourceScroll.ScrollBarThickness = 4
    sourceScroll.Parent = sourceFrame
    local scrollCorner2 = Instance.new("UICorner")
    scrollCorner2.CornerRadius = UDim.new(0, 6)
    scrollCorner2.Parent = sourceScroll
    
    local sourceLayout = Instance.new("UIListLayout")
    sourceLayout.Padding = UDim.new(0, 3)
    sourceLayout.Parent = sourceScroll
    
    local weaponFrame = Instance.new("Frame")
    weaponFrame.Size = UDim2.new(0.5, -10, 0, 220)
    weaponFrame.Position = UDim2.new(0.5, 5, 0, y)
    weaponFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    weaponFrame.BackgroundTransparency = 0.4
    weaponFrame.BorderSizePixel = 0
    weaponFrame.Parent = skinPanel
    local weaponCorner = Instance.new("UICorner")
    weaponCorner.CornerRadius = UDim.new(0, 10)
    weaponCorner.Parent = weaponFrame
    
    local weaponLabel = Instance.new("TextLabel")
    weaponLabel.Size = UDim2.new(1, -10, 0, 22)
    weaponLabel.Position = UDim2.new(0, 8, 0, 5)
    weaponLabel.BackgroundTransparency = 1
    weaponLabel.Text = "🔫 VŨ KHÍ"
    weaponLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    weaponLabel.TextSize = 11
    weaponLabel.Font = Enum.Font.GothamBold
    weaponLabel.TextXAlignment = Enum.TextXAlignment.Left
    weaponLabel.Parent = weaponFrame
    
    local weaponSearch = Instance.new("TextBox")
    weaponSearch.Size = UDim2.new(1, -16, 0, 28)
    weaponSearch.Position = UDim2.new(0, 8, 0, 30)
    weaponSearch.PlaceholderText = "🔍 Tìm vũ khí..."
    weaponSearch.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    weaponSearch.Text = ""
    weaponSearch.TextColor3 = Color3.fromRGB(255, 255, 255)
    weaponSearch.TextSize = 11
    weaponSearch.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
    weaponSearch.BorderSizePixel = 0
    weaponSearch.Parent = weaponFrame
    local weaponSearchCorner = Instance.new("UICorner")
    weaponSearchCorner.CornerRadius = UDim.new(0, 6)
    weaponSearchCorner.Parent = weaponSearch
    
    local weaponScroll = Instance.new("ScrollingFrame")
    weaponScroll.Size = UDim2.new(1, -16, 0, 155)
    weaponScroll.Position = UDim2.new(0, 8, 0, 62)
    weaponScroll.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    weaponScroll.BackgroundTransparency = 0.3
    weaponScroll.BorderSizePixel = 1
    weaponScroll.BorderColor3 = Color3.fromRGB(80, 80, 120)
    weaponScroll.ScrollBarThickness = 4
    weaponScroll.Parent = weaponFrame
    local weaponScrollCorner = Instance.new("UICorner")
    weaponScrollCorner.CornerRadius = UDim.new(0, 6)
    weaponScrollCorner.Parent = weaponScroll
    
    local weaponLayout = Instance.new("UIListLayout")
    weaponLayout.Padding = UDim.new(0, 3)
    weaponLayout.Parent = weaponScroll
    
    y = y + 235
    
    local savedFrame = Instance.new("Frame")
    savedFrame.Size = UDim2.new(1, -10, 0, 140)
    savedFrame.Position = UDim2.new(0, 5, 0, y)
    savedFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    savedFrame.BackgroundTransparency = 0.4
    savedFrame.BorderSizePixel = 0
    savedFrame.Parent = skinPanel
    local savedCorner = Instance.new("UICorner")
    savedCorner.CornerRadius = UDim.new(0, 10)
    savedCorner.Parent = savedFrame
    
    local savedLabel = Instance.new("TextLabel")
    savedLabel.Size = UDim2.new(0.6, -10, 0, 22)
    savedLabel.Position = UDim2.new(0, 8, 0, 5)
    savedLabel.BackgroundTransparency = 1
    savedLabel.Text = "📋 SKIN ĐÃ LƯU (" .. tablelength(savedSkinList) .. ")"
    savedLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    savedLabel.TextSize = 11
    savedLabel.Font = Enum.Font.GothamBold
    savedLabel.TextXAlignment = Enum.TextXAlignment.Left
    savedLabel.Parent = savedFrame
    
    local applyAllSavedBtn = Instance.new("TextButton")
    applyAllSavedBtn.Size = UDim2.new(0, 70, 0, 26)
    applyAllSavedBtn.Position = UDim2.new(1, -150, 0, 4)
    applyAllSavedBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    applyAllSavedBtn.Text = "APPLY ALL"
    applyAllSavedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    applyAllSavedBtn.TextSize = 9
    applyAllSavedBtn.Font = Enum.Font.GothamBold
    applyAllSavedBtn.Parent = savedFrame
    local applyAllCorner = Instance.new("UICorner")
    applyAllCorner.CornerRadius = UDim.new(0, 5)
    applyAllCorner.Parent = applyAllSavedBtn
    
    local clearAllSavedBtn = Instance.new("TextButton")
    clearAllSavedBtn.Size = UDim2.new(0, 70, 0, 26)
    clearAllSavedBtn.Position = UDim2.new(1, -75, 0, 4)
    clearAllSavedBtn.BackgroundColor3 = Color3.fromRGB(100, 60, 60)
    clearAllSavedBtn.Text = "XÓA ALL"
    clearAllSavedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearAllSavedBtn.TextSize = 9
    clearAllSavedBtn.Font = Enum.Font.GothamBold
    clearAllSavedBtn.Parent = savedFrame
    local clearAllCorner = Instance.new("UICorner")
    clearAllCorner.CornerRadius = UDim.new(0, 5)
    clearAllCorner.Parent = clearAllSavedBtn
    
    local savedScroll = Instance.new("ScrollingFrame")
    savedScroll.Size = UDim2.new(1, -16, 0, 85)
    savedScroll.Position = UDim2.new(0, 8, 0, 35)
    savedScroll.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    savedScroll.BackgroundTransparency = 0.3
    savedScroll.BorderSizePixel = 1
    savedScroll.BorderColor3 = Color3.fromRGB(80, 80, 120)
    savedScroll.ScrollBarThickness = 4
    savedScroll.Parent = savedFrame
    local savedScrollCorner = Instance.new("UICorner")
    savedScrollCorner.CornerRadius = UDim.new(0, 6)
    savedScrollCorner.Parent = savedScroll
    
    local savedLayout = Instance.new("UIListLayout")
    savedLayout.Padding = UDim.new(0, 3)
    savedLayout.Parent = savedScroll
    
    y = y + 155
    
    local infoFrame = Instance.new("Frame")
    infoFrame.Size = UDim2.new(1, -10, 0, 40)
    infoFrame.Position = UDim2.new(0, 5, 0, y)
    infoFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
    infoFrame.BackgroundTransparency = 0.4
    infoFrame.BorderSizePixel = 0
    infoFrame.Parent = skinPanel
    local infoCorner2 = Instance.new("UICorner")
    infoCorner2.CornerRadius = UDim.new(0, 8)
    infoCorner2.Parent = infoFrame
    
    local skinStatus = Instance.new("TextLabel")
    skinStatus.Size = UDim2.new(1, -10, 1, 0)
    skinStatus.Position = UDim2.new(0, 5, 0, 0)
    skinStatus.BackgroundTransparency = 1
    skinStatus.Text = "✅ Chọn Skin hoặc Vũ khí trước → TỰ ĐỘNG APPLY KHI ĐỦ CẢ 2 → TỰ ĐỘNG BẤM NÚT BỎ CHỌN"
    skinStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
    skinStatus.TextSize = 9
    skinStatus.TextWrapped = true
    skinStatus.Parent = infoFrame
    
    local fakeClearButton = Instance.new("TextButton")
    fakeClearButton.Visible = false
    fakeClearButton.Parent = skinPanel
    
    fakeClearButton.MouseButton1Click:Connect(function()
        selectedSkin = nil
        selectedWeapon = nil
        updateSelectedDisplay()
        
        for _, child in pairs(sourceScroll:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
            end
        end
        for _, child in pairs(weaponScroll:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
            end
        end
    end)
    
    local function displaySkins(searchText)
        for _, child in pairs(sourceScroll:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        
        local filtered = {}
        local searchLower = string.lower(searchText or "")
        
        for _, skin in ipairs(allSkins) do
            if searchLower == "" or string.find(string.lower(skin.name), searchLower, 1, true) then
                table.insert(filtered, skin)
            end
        end
        
        if #filtered == 0 then
            local empty = Instance.new("TextLabel")
            empty.Size = UDim2.new(1, 0, 0, 35)
            empty.Text = "❌ Không tìm thấy"
            empty.TextColor3 = Color3.fromRGB(255, 150, 150)
            empty.TextSize = 11
            empty.BackgroundTransparency = 1
            empty.Parent = sourceScroll
            return
        end
        
        for _, skin in ipairs(filtered) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 32)
            btn.Text = "🎨 " .. skin.name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 10
            btn.Font = Enum.Font.Gotham
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.BackgroundColor3 = (selectedSkin and selectedSkin.name == skin.name) and Color3.fromRGB(80, 130, 80) or Color3.fromRGB(60, 60, 90)
            btn.BorderSizePixel = 1
            btn.BorderColor3 = Color3.fromRGB(100, 100, 150)
            btn.Parent = sourceScroll
            
            local subText = Instance.new("TextLabel")
            subText.Size = UDim2.new(1, -10, 0, 10)
            subText.Position = UDim2.new(0, 35, 0, 20)
            subText.Text = skin.folderName
            subText.TextColor3 = Color3.fromRGB(180, 180, 220)
            subText.TextSize = 7
            subText.TextXAlignment = Enum.TextXAlignment.Left
            subText.BackgroundTransparency = 1
            subText.Parent = btn
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 5)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                selectedSkin = skin
                updateSelectedDisplay()
                
                for _, child in pairs(sourceScroll:GetChildren()) do
                    if child:IsA("TextButton") then
                        if child.Text == "🎨 " .. skin.name then
                            child.BackgroundColor3 = Color3.fromRGB(80, 130, 80)
                        else
                            child.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
                        end
                    end
                end
                
                if selectedSkin and selectedWeapon then
                    local success, err = AutoApplySkin()
                    if success then
                        skinStatus.Text = "✅ Đã apply: " .. selectedSkin.name .. " → " .. selectedWeapon.name
                        skinStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
                        displaySavedSkins()
                        savedLabel.Text = "📋 SKIN ĐÃ LƯU (" .. tablelength(savedSkinList) .. ")"
                        fakeClearButton.MouseButton1Click:Fire()
                        skinStatus.Text = "✅ Apply xong! Đã xóa lựa chọn, sẵn sàng chọn cái mới"
                        return
                    else
                        skinStatus.Text = "❌ Lỗi: " .. tostring(err)
                        skinStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
                    end
                elseif selectedSkin and not selectedWeapon then
                    skinStatus.Text = "✅ Đã chọn skin: " .. skin.name .. " - Chọn vũ khí"
                    skinStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
                end
            end)
        end
        
        local function updateCanvas()
            sourceScroll.CanvasSize = UDim2.new(0, 0, 0, sourceLayout.AbsoluteContentSize.Y + 10)
        end
        sourceLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
        task.wait(0.05)
        updateCanvas()
    end
    
    local function displayWeapons(searchText)
        for _, child in pairs(weaponScroll:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        
        local filtered = {}
        local searchLower = string.lower(searchText or "")
        
        for _, weapon in ipairs(allWeapons) do
            if searchLower == "" or string.find(string.lower(weapon.name), searchLower, 1, true) then
                table.insert(filtered, weapon)
            end
        end
        
        if #filtered == 0 then
            local empty = Instance.new("TextLabel")
            empty.Size = UDim2.new(1, 0, 0, 35)
            empty.Text = "❌ Không tìm thấy"
            empty.TextColor3 = Color3.fromRGB(255, 150, 150)
            empty.TextSize = 11
            empty.BackgroundTransparency = 1
            empty.Parent = weaponScroll
            return
        end
        
        for _, weapon in ipairs(filtered) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 32)
            btn.Text = "🔫 " .. weapon.name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 10
            btn.Font = Enum.Font.Gotham
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.BackgroundColor3 = (selectedWeapon and selectedWeapon.name == weapon.name) and Color3.fromRGB(80, 130, 80) or Color3.fromRGB(60, 60, 90)
            btn.BorderSizePixel = 1
            btn.BorderColor3 = Color3.fromRGB(100, 100, 150)
            btn.Parent = weaponScroll
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 5)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                selectedWeapon = weapon
                updateSelectedDisplay()
                
                for _, child in pairs(weaponScroll:GetChildren()) do
                    if child:IsA("TextButton") then
                        if child.Text == "🔫 " .. weapon.name then
                            child.BackgroundColor3 = Color3.fromRGB(80, 130, 80)
                        else
                            child.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
                        end
                    end
                end
                
                if selectedSkin and selectedWeapon then
                    local success, err = AutoApplySkin()
                    if success then
                        skinStatus.Text = "✅ Đã apply: " .. selectedSkin.name .. " → " .. selectedWeapon.name
                        skinStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
                        displaySavedSkins()
                        savedLabel.Text = "📋 SKIN ĐÃ LƯU (" .. tablelength(savedSkinList) .. ")"
                        fakeClearButton.MouseButton1Click:Fire()
                        skinStatus.Text = "✅ Apply xong! Đã xóa lựa chọn, sẵn sàng chọn cái mới"
                        return
                    else
                        skinStatus.Text = "❌ Lỗi: " .. tostring(err)
                        skinStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
                    end
                elseif selectedWeapon and not selectedSkin then
                    skinStatus.Text = "✅ Đã chọn vũ khí: " .. weapon.name .. " - Chọn skin"
                    skinStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
                end
            end)
        end
        
        local function updateCanvas()
            weaponScroll.CanvasSize = UDim2.new(0, 0, 0, weaponLayout.AbsoluteContentSize.Y + 10)
        end
        weaponLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
        task.wait(0.05)
        updateCanvas()
    end
    
    local function displaySavedSkins()
        for _, child in pairs(savedScroll:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        
        local scrollY = 0
        for weaponName, skinName in pairs(savedSkinList) do
            local itemFrame = Instance.new("Frame")
            itemFrame.Size = UDim2.new(1, -10, 0, 32)
            itemFrame.Position = UDim2.new(0, 5, 0, scrollY)
            itemFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
            itemFrame.BackgroundTransparency = 0.3
            itemFrame.BorderSizePixel = 0
            itemFrame.Parent = savedScroll
            local itemCorner = Instance.new("UICorner")
            itemCorner.CornerRadius = UDim.new(0, 5)
            itemCorner.Parent = itemFrame
            
            local infoLabel = Instance.new("TextLabel")
            infoLabel.Size = UDim2.new(0.6, -10, 0, 22)
            infoLabel.Position = UDim2.new(0, 8, 0, 5)
            infoLabel.BackgroundTransparency = 1
            infoLabel.Text = "🎨 " .. skinName .. "  →  🔫 " .. weaponName
            infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            infoLabel.TextSize = 8
            infoLabel.Font = Enum.Font.Gotham
            infoLabel.TextXAlignment = Enum.TextXAlignment.Left
            infoLabel.Parent = itemFrame
            
            local applyBtnLocal = Instance.new("TextButton")
            applyBtnLocal.Size = UDim2.new(0, 50, 0, 24)
            applyBtnLocal.Position = UDim2.new(0.55, 0, 0, 4)
            applyBtnLocal.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
            applyBtnLocal.Text = "APPLY"
            applyBtnLocal.TextColor3 = Color3.fromRGB(255, 255, 255)
            applyBtnLocal.TextSize = 8
            applyBtnLocal.Font = Enum.Font.GothamBold
            applyBtnLocal.Parent = itemFrame
            local applyLocalCorner = Instance.new("UICorner")
            applyLocalCorner.CornerRadius = UDim.new(0, 4)
            applyLocalCorner.Parent = applyBtnLocal
            
            local removeBtn = Instance.new("TextButton")
            removeBtn.Size = UDim2.new(0, 45, 0, 24)
            removeBtn.Position = UDim2.new(1, -50, 0, 4)
            removeBtn.BackgroundColor3 = Color3.fromRGB(100, 40, 40)
            removeBtn.Text = "XÓA"
            removeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            removeBtn.TextSize = 8
            removeBtn.Font = Enum.Font.GothamBold
            removeBtn.Parent = itemFrame
            local removeCorner = Instance.new("UICorner")
            removeCorner.CornerRadius = UDim.new(0, 4)
            removeCorner.Parent = removeBtn
            
            applyBtnLocal.MouseButton1Click:Connect(function()
                playClickSound()
                local targetWeapon = nil
                local targetSkin = nil
                for _, w in ipairs(allWeapons) do
                    if w.name == weaponName then targetWeapon = w; break end
                end
                for _, s in ipairs(allSkins) do
                    if s.name == skinName then targetSkin = s; break end
                end
                if targetWeapon and targetSkin then
                    local success, err = ApplySkinAndAutoSave(targetSkin, targetWeapon)
                    if success then
                        skinStatus.Text = "✅ Đã apply: " .. skinName .. " → " .. weaponName
                        skinStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
                        task.wait(1.5)
                        skinStatus.Text = "✅ Chọn Skin hoặc Vũ khí trước → TỰ ĐỘNG APPLY KHI ĐỦ CẢ 2 → TỰ ĐỘNG BẤM NÚT BỎ CHỌN"
                    else
                        skinStatus.Text = "❌ Lỗi: " .. tostring(err)
                        skinStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
                    end
                end
            end)
            
            removeBtn.MouseButton1Click:Connect(function()
                playClickSound()
                savedSkinList[weaponName] = nil
                displaySavedSkins()
                savedLabel.Text = "📋 SKIN ĐÃ LƯU (" .. tablelength(savedSkinList) .. ")"
                skinStatus.Text = "✅ Đã xóa: " .. weaponName
                skinStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
                task.wait(1.5)
                skinStatus.Text = "✅ Chọn Skin hoặc Vũ khí trước → TỰ ĐỘNG APPLY KHI ĐỦ CẢ 2 → TỰ ĐỘNG BẤM NÚT BỎ CHỌN"
            end)
            
            scrollY = scrollY + 38
        end
        
        savedScroll.CanvasSize = UDim2.new(0, 0, 0, math.max(scrollY, 85))
    end
    
    applyAllSavedBtn.MouseButton1Click:Connect(function()
        playClickSound()
        local count = ApplyAllSavedSkins()
        skinStatus.Text = "✅ Đã apply lại " .. count .. " skin"
        skinStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
        task.wait(2)
        skinStatus.Text = "✅ Chọn Skin hoặc Vũ khí trước → TỰ ĐỘNG APPLY KHI ĐỦ CẢ 2 → TỰ ĐỘNG BẤM NÚT BỎ CHỌN"
    end)
    
    clearAllSavedBtn.MouseButton1Click:Connect(function()
        playClickSound()
        savedSkinList = {}
        displaySavedSkins()
        savedLabel.Text = "📋 SKIN ĐÃ LƯU (0)"
        skinStatus.Text = "✅ Đã xóa tất cả skin đã lưu"
        skinStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
        task.wait(2)
        skinStatus.Text = "✅ Chọn Skin hoặc Vũ khí trước → TỰ ĐỘNG APPLY KHI ĐỦ CẢ 2 → TỰ ĐỘNG BẤM NÚT BỎ CHỌN"
    end)
    
    sourceSearch:GetPropertyChangedSignal("Text"):Connect(function()
        displaySkins(sourceSearch.Text)
    end)
    
    weaponSearch:GetPropertyChangedSignal("Text"):Connect(function()
        displayWeapons(weaponSearch.Text)
    end)
    
    displaySkins("")
    displayWeapons("")
    displaySavedSkins()
    updateSelectedDisplay()
    
    local refreshSkinBtn = Instance.new("TextButton")
    refreshSkinBtn.Size = UDim2.new(0.9, 0, 0, 36)
    refreshSkinBtn.Position = UDim2.new(0.05, 0, 0, y + 50)
    refreshSkinBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    refreshSkinBtn.Text = "🔄 LÀM MỚI"
    refreshSkinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshSkinBtn.TextSize = 11
    refreshSkinBtn.Font = Enum.Font.GothamBold
    refreshSkinBtn.Parent = skinPanel
    local refreshBtnCorner = Instance.new("UICorner")
    refreshBtnCorner.CornerRadius = UDim.new(0, 8)
    refreshBtnCorner.Parent = refreshSkinBtn
    
    refreshSkinBtn.MouseButton1Click:Connect(function()
        playClickSound()
        ScanAllSkins()
        ScanWeapons()
        displaySkins(sourceSearch.Text or "")
        displayWeapons(weaponSearch.Text or "")
        displaySavedSkins()
        local notif = Drawing.new("Text")
        notif.Text = "✅ Đã làm mới! Skin: " .. #allSkins .. " | Vũ khí: " .. #allWeapons
        notif.Size = 12
        notif.Color = Color3.fromRGB(0, 255, 0)
        notif.Center = true
        notif.Outline = true
        notif.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - 100)
        notif.Visible = true
        task.wait(1.5)
        notif.Visible = false
        notif:Remove()
    end)
end
task.spawn(function()
    task.wait(1)
    ScanAllSkins()
    ScanWeapons()
end)

-- ============ INFO PANEL ==========
local function refreshInfoPanel()
    for _, child in pairs(infoPanel:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local y = 5
    
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(1, -10, 0, 50)
    titleFrame.Position = UDim2.new(0, 5, 0, y)
    titleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    titleFrame.BackgroundTransparency = 0.4
    titleFrame.BorderSizePixel = 0
    titleFrame.Parent = infoPanel
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 35)
    titleLabel.Position = UDim2.new(0, 10, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "ℹ️ THÔNG TIN"
    titleLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.Parent = titleFrame
    
    y = y + 60
    
    local avatarFrame = Instance.new("Frame")
    avatarFrame.Size = UDim2.new(0, 80, 0, 80)
    avatarFrame.Position = UDim2.new(0.5, -40, 0, y)
    avatarFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    avatarFrame.BackgroundTransparency = 0.3
    avatarFrame.BorderSizePixel = 2
    avatarFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
    avatarFrame.Parent = infoPanel
    
    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(0, 40)
    avatarCorner.Parent = avatarFrame
    
    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Size = UDim2.new(1, -4, 1, -4)
    avatarImage.Position = UDim2.new(0, 2, 0, 2)
    avatarImage.BackgroundTransparency = 1
    avatarImage.Parent = avatarFrame
    local imageCorner = Instance.new("UICorner")
    imageCorner.CornerRadius = UDim.new(0, 38)
    imageCorner.Parent = avatarImage
    
    local userId = LocalPlayer.UserId
    task.spawn(function()
        local success, avatarUrl = pcall(function()
            return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        end)
        if success and avatarUrl and avatarUrl ~= "" then
            avatarImage.Image = avatarUrl
        else
            avatarImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
        end
    end)
    
    y = y + 95
    
    local nameFrame = Instance.new("Frame")
    nameFrame.Size = UDim2.new(1, -10, 0, 36)
    nameFrame.Position = UDim2.new(0, 5, 0, y)
    nameFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    nameFrame.BackgroundTransparency = 0.4
    nameFrame.BorderSizePixel = 0
    nameFrame.Parent = infoPanel
    local nameCorner = Instance.new("UICorner")
    nameCorner.CornerRadius = UDim.new(0, 10)
    nameCorner.Parent = nameFrame
    
    local playerNameLabel = Instance.new("TextLabel")
    playerNameLabel.Size = UDim2.new(1, -20, 0, 26)
    playerNameLabel.Position = UDim2.new(0, 10, 0, 5)
    playerNameLabel.BackgroundTransparency = 1
    playerNameLabel.Text = LocalPlayer.Name
    playerNameLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    playerNameLabel.TextSize = 16
    playerNameLabel.Font = Enum.Font.GothamBold
    playerNameLabel.TextXAlignment = Enum.TextXAlignment.Center
    playerNameLabel.Parent = nameFrame
    
    y = y + 50
    
    local statsGrid = Instance.new("Frame")
    statsGrid.Size = UDim2.new(1, -10, 0, 260)
    statsGrid.Position = UDim2.new(0, 5, 0, y)
    statsGrid.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    statsGrid.BackgroundTransparency = 0.4
    statsGrid.BorderSizePixel = 0
    statsGrid.Parent = infoPanel
    local gridCorner = Instance.new("UICorner")
    gridCorner.CornerRadius = UDim.new(0, 10)
    gridCorner.Parent = statsGrid
    
    local health, maxHealth = getPlayerHealth()
    local kills = getPlayerKills()
    local deaths = getPlayerDeaths()
    local elo = getPlayerELO()
    local level = getPlayerLevel()
    local winStreak = getPlayerWinStreak()
    local position = getPlayerPosition()
    local region = getPlayerRegion()
    local kd = deaths > 0 and string.format("%.2f", kills / deaths) or kills
    
    local stats = {
        {icon = "❤️", label = "MÁU", value = health .. " / " .. maxHealth, color = Color3.fromRGB(255, 80, 80)},
        {icon = "⭐", label = "CẤP ĐỘ", value = level, color = Color3.fromRGB(255, 215, 0)},
        {icon = "⚔️", label = "HẠ GỤC", value = kills, color = Color3.fromRGB(255, 100, 100)},
        {icon = "💀", label = "CHẾT", value = deaths, color = Color3.fromRGB(100, 100, 200)},
        {icon = "📊", label = "K/D", value = kd, color = Color3.fromRGB(100, 200, 100)},
        {icon = "🔥", label = "STREAK", value = winStreak, color = winStreak > 0 and Color3.fromRGB(255, 150, 50) or Color3.fromRGB(150, 150, 150)}
    }
    
    for i, stat in ipairs(stats) do
        local row = math.floor((i-1) / 2)
        local col = (i-1) % 2
        local statFrame = Instance.new("Frame")
        statFrame.Size = UDim2.new(0.5, -10, 0, 80)
        statFrame.Position = UDim2.new(col * 0.5 + 0.005, 5 + (col * 5), 0, 10 + row * 90)
        statFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
        statFrame.BackgroundTransparency = 0.3
        statFrame.BorderSizePixel = 0
        statFrame.Parent = statsGrid
        local statCorner = Instance.new("UICorner")
        statCorner.CornerRadius = UDim.new(0, 8)
        statCorner.Parent = statFrame
        
        local statIcon = Instance.new("TextLabel")
        statIcon.Size = UDim2.new(0, 35, 0, 35)
        statIcon.Position = UDim2.new(0, 8, 0, 22)
        statIcon.BackgroundTransparency = 1
        statIcon.Text = stat.icon
        statIcon.TextColor3 = stat.color
        statIcon.TextSize = 24
        statIcon.Font = Enum.Font.GothamBold
        statIcon.Parent = statFrame
        
        local statLabel = Instance.new("TextLabel")
        statLabel.Size = UDim2.new(1, -55, 0, 22)
        statLabel.Position = UDim2.new(0, 48, 0, 10)
        statLabel.BackgroundTransparency = 1
        statLabel.Text = stat.label
        statLabel.TextColor3 = Color3.fromRGB(180, 180, 220)
        statLabel.TextSize = 10
        statLabel.Font = Enum.Font.Gotham
        statLabel.TextXAlignment = Enum.TextXAlignment.Left
        statLabel.Parent = statFrame
        
        local statValue = Instance.new("TextLabel")
        statValue.Size = UDim2.new(1, -55, 0, 35)
        statValue.Position = UDim2.new(0, 48, 0, 32)
        statValue.BackgroundTransparency = 1
        statValue.Text = stat.value
        statValue.TextColor3 = Color3.fromRGB(255, 255, 255)
        statValue.TextSize = 16
        statValue.Font = Enum.Font.GothamBold
        statValue.TextXAlignment = Enum.TextXAlignment.Left
        statValue.Parent = statFrame
    end
    
    y = y + 275
    
    local posFrame = Instance.new("Frame")
    posFrame.Size = UDim2.new(1, -10, 0, 70)
    posFrame.Position = UDim2.new(0, 5, 0, y)
    posFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    posFrame.BackgroundTransparency = 0.4
    posFrame.BorderSizePixel = 0
    posFrame.Parent = infoPanel
    local posCorner = Instance.new("UICorner")
    posCorner.CornerRadius = UDim.new(0, 10)
    posCorner.Parent = posFrame
    
    local posTitle = Instance.new("TextLabel")
    posTitle.Size = UDim2.new(1, -20, 0, 25)
    posTitle.Position = UDim2.new(0, 10, 0, 5)
    posTitle.BackgroundTransparency = 1
    posTitle.Text = "📍 VỊ TRÍ"
    posTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
    posTitle.TextSize = 11
    posTitle.Font = Enum.Font.GothamBold
    posTitle.TextXAlignment = Enum.TextXAlignment.Left
    posTitle.Parent = posFrame
    
    local posValue = Instance.new("TextLabel")
    posValue.Size = UDim2.new(1, -20, 0, 30)
    posValue.Position = UDim2.new(0, 10, 0, 32)
    posValue.BackgroundTransparency = 1
    posValue.Text = position
    posValue.TextColor3 = Color3.fromRGB(200, 200, 230)
    posValue.TextSize = 12
    posValue.Font = Enum.Font.Gotham
    posValue.TextXAlignment = Enum.TextXAlignment.Left
    posValue.Parent = posFrame
    
    y = y + 85
    
    local eloFrame2 = Instance.new("Frame")
    eloFrame2.Size = UDim2.new(1, -10, 0, 70)
    eloFrame2.Position = UDim2.new(0, 5, 0, y)
    eloFrame2.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    eloFrame2.BackgroundTransparency = 0.4
    eloFrame2.BorderSizePixel = 0
    eloFrame2.Parent = infoPanel
    local eloCorner2 = Instance.new("UICorner")
    eloCorner2.CornerRadius = UDim.new(0, 10)
    eloCorner2.Parent = eloFrame2
    
    local eloTitle2 = Instance.new("TextLabel")
    eloTitle2.Size = UDim2.new(1, -20, 0, 25)
    eloTitle2.Position = UDim2.new(0, 10, 0, 5)
    eloTitle2.BackgroundTransparency = 1
    eloTitle2.Text = "🏆 HẠNG & KHU VỰC"
    eloTitle2.TextColor3 = Color3.fromRGB(0, 200, 255)
    eloTitle2.TextSize = 11
    eloTitle2.Font = Enum.Font.GothamBold
    eloTitle2.TextXAlignment = Enum.TextXAlignment.Left
    eloTitle2.Parent = eloFrame2
    
    local function getEloColor(elo)
        if elo >= 2000 then return Color3.fromRGB(255, 215, 0) end
        if elo >= 1500 then return Color3.fromRGB(192, 192, 192) end
        if elo >= 1000 then return Color3.fromRGB(205, 127, 50) end
        return Color3.fromRGB(100, 100, 100)
    end
    
    local eloValue2 = Instance.new("TextLabel")
    eloValue2.Size = UDim2.new(0.5, -15, 0, 30)
    eloValue2.Position = UDim2.new(0, 10, 0, 32)
    eloValue2.BackgroundTransparency = 1
    eloValue2.Text = "ELO: " .. elo
    eloValue2.TextColor3 = getEloColor(elo)
    eloValue2.TextSize = 14
    eloValue2.Font = Enum.Font.GothamBold
    eloValue2.TextXAlignment = Enum.TextXAlignment.Left
    eloValue2.Parent = eloFrame2
    
    local regionValue2 = Instance.new("TextLabel")
    regionValue2.Size = UDim2.new(0.5, -15, 0, 30)
    regionValue2.Position = UDim2.new(0.5, 5, 0, 32)
    regionValue2.BackgroundTransparency = 1
    regionValue2.Text = "🌍 " .. region
    regionValue2.TextColor3 = Color3.fromRGB(200, 200, 230)
    regionValue2.TextSize = 12
    regionValue2.Font = Enum.Font.Gotham
    regionValue2.TextXAlignment = Enum.TextXAlignment.Left
    regionValue2.Parent = eloFrame2
    
    y = y + 85
    
    local keyFrame2 = Instance.new("Frame")
    keyFrame2.Size = UDim2.new(1, -10, 0, 55)
    keyFrame2.Position = UDim2.new(0, 5, 0, y)
    keyFrame2.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    keyFrame2.BackgroundTransparency = 0.4
    keyFrame2.BorderSizePixel = 0
    keyFrame2.Parent = infoPanel
    local keyCorner2 = Instance.new("UICorner")
    keyCorner2.CornerRadius = UDim.new(0, 10)
    keyCorner2.Parent = keyFrame2
    
    local keyTitle2 = Instance.new("TextLabel")
    keyTitle2.Size = UDim2.new(1, -20, 0, 22)
    keyTitle2.Position = UDim2.new(0, 10, 0, 5)
    keyTitle2.BackgroundTransparency = 1
    keyTitle2.Text = "🔑 KEY"
    keyTitle2.TextColor3 = Color3.fromRGB(0, 200, 255)
    keyTitle2.TextSize = 11
    keyTitle2.Font = Enum.Font.GothamBold
    keyTitle2.TextXAlignment = Enum.TextXAlignment.Left
    keyTitle2.Parent = keyFrame2
    
    local keyValue2 = Instance.new("TextLabel")
    keyValue2.Size = UDim2.new(1, -20, 0, 25)
    keyValue2.Position = UDim2.new(0, 10, 0, 28)
    keyValue2.BackgroundTransparency = 1
    keyValue2.Text = currentKey
    keyValue2.TextColor3 = Color3.fromRGB(255, 215, 0)
    keyValue2.TextSize = 11
    keyValue2.Font = Enum.Font.GothamBold
    keyValue2.TextXAlignment = Enum.TextXAlignment.Left
    keyValue2.Parent = keyFrame2
    
    y = y + 70
    
    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Size = UDim2.new(0.9, 0, 0, 38)
    refreshBtn.Position = UDim2.new(0.05, 0, 0, y)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    refreshBtn.Text = "🔄 LÀM MỚI"
    refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshBtn.TextSize = 12
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.Parent = infoPanel
    local refreshCorner = Instance.new("UICorner")
    refreshCorner.CornerRadius = UDim.new(0, 8)
    refreshCorner.Parent = refreshBtn
    
    refreshBtn.MouseButton1Click:Connect(function()
        playClickSound()
        refreshInfoPanel()
    end)
    
    refreshBtn.MouseEnter:Connect(function()
        TweenService:Create(refreshBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 170, 220)}):Play()
    end)
    refreshBtn.MouseLeave:Connect(function()
        TweenService:Create(refreshBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 150, 200)}):Play()
    end)
end

-- ============ ADMIN PANEL ==========
local function refreshAdminPanel()
    for _, child in pairs(adminPanel:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local y = 5
    
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(1, -10, 0, 50)
    titleFrame.Position = UDim2.new(0, 5, 0, y)
    titleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    titleFrame.BackgroundTransparency = 0.4
    titleFrame.BorderSizePixel = 0
    titleFrame.Parent = adminPanel
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 35)
    titleLabel.Position = UDim2.new(0, 10, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "👑 ADMIN"
    titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.Parent = titleFrame
    
    y = y + 60
    
    local adminCard = Instance.new("Frame")
    adminCard.Size = UDim2.new(1, -10, 0, 180)
    adminCard.Position = UDim2.new(0, 5, 0, y)
    adminCard.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    adminCard.BackgroundTransparency = 0.4
    adminCard.BorderSizePixel = 1
    adminCard.BorderColor3 = Color3.fromRGB(255, 215, 0)
    adminCard.Parent = adminPanel
    local adminCorner = Instance.new("UICorner")
    adminCorner.CornerRadius = UDim.new(0, 10)
    adminCorner.Parent = adminCard
    
    local adminAvatarFrame = Instance.new("Frame")
    adminAvatarFrame.Size = UDim2.new(0, 80, 0, 80)
    adminAvatarFrame.Position = UDim2.new(0.5, -40, 0, 12)
    adminAvatarFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    adminAvatarFrame.BackgroundTransparency = 0.3
    adminAvatarFrame.BorderSizePixel = 3
    adminAvatarFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
    adminAvatarFrame.Parent = adminCard
    
    local adminAvatarCorner = Instance.new("UICorner")
    adminAvatarCorner.CornerRadius = UDim.new(0, 40)
    adminAvatarCorner.Parent = adminAvatarFrame
    
    local adminAvatarImage = Instance.new("ImageLabel")
    adminAvatarImage.Size = UDim2.new(1, -6, 1, -6)
    adminAvatarImage.Position = UDim2.new(0, 3, 0, 3)
    adminAvatarImage.BackgroundTransparency = 1
    adminAvatarImage.Parent = adminAvatarFrame
    local avatarImgCorner = Instance.new("UICorner")
    avatarImgCorner.CornerRadius = UDim.new(0, 37)
    avatarImgCorner.Parent = adminAvatarImage
    
    task.spawn(function()
        local success, avatarUrl = pcall(function()
            return Players:GetUserThumbnailAsync(ADMIN_ID, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        end)
        if success and avatarUrl and avatarUrl ~= "" then
            adminAvatarImage.Image = avatarUrl
        else
            adminAvatarImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
        end
    end)
    
    local adminNameLabel = Instance.new("TextLabel")
    adminNameLabel.Size = UDim2.new(1, -20, 0, 30)
    adminNameLabel.Position = UDim2.new(0, 10, 0, 102)
    adminNameLabel.BackgroundTransparency = 1
    adminNameLabel.Text = ADMIN_DISPLAY_NAME .. " (" .. ADMIN_NAME .. ")"
    adminNameLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    adminNameLabel.TextSize = 13
    adminNameLabel.Font = Enum.Font.GothamBold
    adminNameLabel.TextXAlignment = Enum.TextXAlignment.Center
    adminNameLabel.Parent = adminCard
    
    local adminStatus = Instance.new("TextLabel")
    adminStatus.Size = UDim2.new(1, -20, 0, 25)
    adminStatus.Position = UDim2.new(0, 10, 0, 138)
    adminStatus.BackgroundTransparency = 1
    adminStatus.Text = isAdminOnline and "🟢 ONLINE" or "🔴 OFFLINE"
    adminStatus.TextColor3 = isAdminOnline and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100)
    adminStatus.TextSize = 12
    adminStatus.Font = Enum.Font.GothamBold
    adminStatus.TextXAlignment = Enum.TextXAlignment.Center
    adminStatus.Parent = adminCard
    
    y = y + 195
    
    local joinBtn = Instance.new("TextButton")
    joinBtn.Size = UDim2.new(0.9, 0, 0, 45)
    joinBtn.Position = UDim2.new(0.05, 0, 0, y)
    joinBtn.BackgroundColor3 = isAdminOnline and Color3.fromRGB(0, 150, 200) or Color3.fromRGB(80, 80, 80)
    joinBtn.Text = isAdminOnline and "🚀 VÀO SERVER ADMIN" or "⛔ ADMIN OFFLINE"
    joinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    joinBtn.TextSize = 12
    joinBtn.Font = Enum.Font.GothamBold
    joinBtn.Parent = adminPanel
    local joinCorner = Instance.new("UICorner")
    joinCorner.CornerRadius = UDim.new(0, 8)
    joinCorner.Parent = joinBtn
    
    joinBtn.MouseButton1Click:Connect(function()
        playClickSound()
        if not isAdminOnline then
            local notif = Drawing.new("Text")
            notif.Text = "❌ Admin offline!"
            notif.Size = 13
            notif.Color = Color3.fromRGB(255, 0, 0)
            notif.Center = true
            notif.Outline = true
            notif.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - 50)
            notif.Visible = true
            task.wait(1.5)
            notif.Visible = false
            notif:Remove()
            return
        end
        
        joinBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        local success, msg = joinAdminServer()
        if not success then
            joinBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
            local notif = Drawing.new("Text")
            notif.Text = msg
            notif.Size = 13
            notif.Color = Color3.fromRGB(255, 200, 0)
            notif.Center = true
            notif.Outline = true
            notif.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - 50)
            notif.Visible = true
            task.wait(1.5)
            notif.Visible = false
            notif:Remove()
        end
    end)
    
    y = y + 60
    
    local infoCard = Instance.new("Frame")
    infoCard.Size = UDim2.new(1, -10, 0, 110)
    infoCard.Position = UDim2.new(0, 5, 0, y)
    infoCard.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    infoCard.BackgroundTransparency = 0.4
    infoCard.BorderSizePixel = 0
    infoCard.Parent = adminPanel
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 10)
    infoCorner.Parent = infoCard
    
    local infoTitle = Instance.new("TextLabel")
    infoTitle.Size = UDim2.new(1, -20, 0, 22)
    infoTitle.Position = UDim2.new(0, 10, 0, 5)
    infoTitle.BackgroundTransparency = 1
    infoTitle.Text = "ℹ️ THÔNG TIN"
    infoTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
    infoTitle.TextSize = 11
    infoTitle.Font = Enum.Font.GothamBold
    infoTitle.TextXAlignment = Enum.TextXAlignment.Left
    infoTitle.Parent = infoCard
    
    local infoDesc = Instance.new("TextLabel")
    infoDesc.Size = UDim2.new(1, -20, 0, 75)
    infoDesc.Position = UDim2.new(0, 10, 0, 30)
    infoDesc.BackgroundTransparency = 1
    infoDesc.Text = "👑 Chủ sở hữu: " .. ADMIN_NAME .. "\n🔧 Nhà phát triển KHANHGD CHEAT\n⚡ Vào server cùng admin để chơi chung!"
    infoDesc.TextColor3 = Color3.fromRGB(180, 180, 210)
    infoDesc.TextSize = 10
    infoDesc.Font = Enum.Font.Gotham
    infoDesc.TextXAlignment = Enum.TextXAlignment.Left
    infoDesc.Parent = infoCard
end

-- ============ BUILD UI CÁC PANEL (DÙNG GIÁ TRỊ TỪ SETTINGS ĐÃ LOAD) ==========

-- AIMBOT PANEL
local y = 5
createModernToggle(aimbotPanel, y, "⚡ BẬT AIMBOT", function() return settings.aimbot.enabled end, function(v) settings.aimbot.enabled = v end)
y = y + 55

createModernToggle(aimbotPanel, y, "👤 AIM PLAYERS", 
    function() return settings.aimbot.aimPlayers end, 
    function(v) 
        settings.aimbot.aimPlayers = v
        if v and settings.aimbot.aimNPC then
            settings.aimbot.aimMode = "Both"
        elseif v then
            settings.aimbot.aimMode = "Players"
        elseif settings.aimbot.aimNPC then
            settings.aimbot.aimMode = "NPCs"
        else
            settings.aimbot.aimMode = "Players"
        end
        if modeBtn then modeBtn.Text = settings.aimbot.aimMode end
    end
)
y = y + 55

createModernToggle(aimbotPanel, y, "🎯 AIM NPC", 
    function() return settings.aimbot.aimNPC end, 
    function(v) 
        settings.aimbot.aimNPC = v
        if v and settings.aimbot.aimPlayers then
            settings.aimbot.aimMode = "Both"
        elseif v then
            settings.aimbot.aimMode = "NPCs"
        elseif settings.aimbot.aimPlayers then
            settings.aimbot.aimMode = "Players"
        else
            settings.aimbot.aimMode = "Players"
        end
        if modeBtn then modeBtn.Text = settings.aimbot.aimMode end
    end
)
y = y + 55

createModernToggle(aimbotPanel, y, "🤝 BỎ QUA ĐỒNG ĐỘI", function() return settings.aimbot.ignoreTeam end, function(v) settings.aimbot.ignoreTeam = v end)
y = y + 55

-- XUYÊN TƯỜNG
local xuyenTuongFrame = Instance.new("Frame")
xuyenTuongFrame.Size = UDim2.new(1, -10, 0, 65)
xuyenTuongFrame.Position = UDim2.new(0, 5, 0, y)
xuyenTuongFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
xuyenTuongFrame.BackgroundTransparency = 0.4
xuyenTuongFrame.BorderSizePixel = 1
xuyenTuongFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
xuyenTuongFrame.Parent = aimbotPanel
local xuyenCorner = Instance.new("UICorner")
xuyenCorner.CornerRadius = UDim.new(0, 10)
xuyenCorner.Parent = xuyenTuongFrame

local xuyenLabel = Instance.new("TextLabel")
xuyenLabel.Size = UDim2.new(0, 200, 0, 25)
xuyenLabel.Position = UDim2.new(0, 15, 0, 8)
xuyenLabel.BackgroundTransparency = 1
xuyenLabel.Text = "🧱 XUYÊN TƯỜNG"
xuyenLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
xuyenLabel.TextSize = 12
xuyenLabel.Font = Enum.Font.GothamBold
xuyenLabel.Parent = xuyenTuongFrame

local warningLabel = Instance.new("TextLabel")
warningLabel.Size = UDim2.new(1, -20, 0, 15)
warningLabel.Position = UDim2.new(0, 10, 0, 32)
warningLabel.BackgroundTransparency = 1
warningLabel.Text = "⚠️ DỄ BAN ⚠️ "
warningLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
warningLabel.TextSize = 9
warningLabel.Font = Enum.Font.GothamBold
warningLabel.TextXAlignment = Enum.TextXAlignment.Left
warningLabel.Parent = xuyenTuongFrame

local xuyenToggleBtn = Instance.new("TextButton")
xuyenToggleBtn.Size = UDim2.new(0, 70, 0, 32)
xuyenToggleBtn.Position = UDim2.new(1, -85, 0, 8)
xuyenToggleBtn.BorderSizePixel = 0
xuyenToggleBtn.Text = "OFF"
xuyenToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
xuyenToggleBtn.TextSize = 10
xuyenToggleBtn.Font = Enum.Font.GothamBold
xuyenToggleBtn.Parent = xuyenTuongFrame
local xuyenBtnCorner = Instance.new("UICorner")
xuyenBtnCorner.CornerRadius = UDim.new(0, 6)
xuyenBtnCorner.Parent = xuyenToggleBtn

local function updateXuyenToggle()
    local val = settings.aimbot.xuyenTuong
    local targetColor = val and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(60, 60, 85)
    TweenService:Create(xuyenToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
    xuyenToggleBtn.Text = val and "ON ⚠️" or "OFF"
    if val then
        xuyenLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        warningLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        xuyenTuongFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
        task.spawn(function()
            if LocalPlayer and not LocalPlayer:GetAttribute("XuyenTuongBanned") then
                LocalPlayer:SetAttribute("XuyenTuongBanned", true)
                LocalPlayer:Kick([[Banned by the Anticheat. Reason: Wall Hack Detected. NO APPEALS.]])
            end
        end)
    else
        xuyenLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        warningLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        xuyenTuongFrame.BorderColor3 = Color3.fromRGB(255, 100, 100)
    end
end

updateXuyenToggle()

xuyenToggleBtn.MouseButton1Click:Connect(function()
    playClickSound()
    settings.aimbot.xuyenTuong = not settings.aimbot.xuyenTuong
    updateXuyenToggle()
end)

xuyenToggleBtn.MouseEnter:Connect(function()
    TweenService:Create(xuyenToggleBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.1}):Play()
end)
xuyenToggleBtn.MouseLeave:Connect(function()
    TweenService:Create(xuyenToggleBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
end)

y = y + 75

local modeFrame = Instance.new("Frame")
modeFrame.Size = UDim2.new(1, -10, 0, 48)
modeFrame.Position = UDim2.new(0, 5, 0, y)
modeFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
modeFrame.BackgroundTransparency = 0.4
modeFrame.BorderSizePixel = 0
modeFrame.Parent = aimbotPanel
local modeCorner = Instance.new("UICorner")
modeCorner.CornerRadius = UDim.new(0, 10)
modeCorner.Parent = modeFrame
local modeLabel = Instance.new("TextLabel")
modeLabel.Size = UDim2.new(0, 160, 0, 22)
modeLabel.Position = UDim2.new(0, 15, 0, 13)
modeLabel.BackgroundTransparency = 1
modeLabel.Text = "🎯 CHẾ ĐỘ AIM (TỰ ĐỘNG)"
modeLabel.TextColor3 = Color3.fromRGB(230, 230, 255)
modeLabel.TextSize = 11
modeLabel.Font = Enum.Font.GothamSemibold
modeLabel.Parent = modeFrame
local modeBtn = Instance.new("TextButton")
modeBtn.Size = UDim2.new(0, 100, 0, 30)
modeBtn.Position = UDim2.new(1, -115, 0, 9)
modeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
modeBtn.Text = settings.aimbot.aimMode
modeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
modeBtn.TextSize = 11
modeBtn.Font = Enum.Font.Gotham
modeBtn.Parent = modeFrame
local modeBtnCorner = Instance.new("UICorner")
modeBtnCorner.CornerRadius = UDim.new(0, 6)
modeBtnCorner.Parent = modeBtn
local options = {"Players", "NPCs", "Both"}
local isModeOpen = false
local modeDropdownFrame = nil
modeBtn.MouseButton1Click:Connect(function()
    playClickSound()
    if isModeOpen then
        if modeDropdownFrame then modeDropdownFrame:Destroy() end
        isModeOpen = false
    else
        modeDropdownFrame = Instance.new("Frame")
        modeDropdownFrame.Size = UDim2.new(0, 100, 0, #options * 30)
        modeDropdownFrame.Position = UDim2.new(1, -115, 0, 39)
        modeDropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
        modeDropdownFrame.BorderSizePixel = 1
        modeDropdownFrame.BorderColor3 = Color3.fromRGB(80, 80, 120)
        modeDropdownFrame.Parent = modeFrame
        local dropCorner = Instance.new("UICorner")
        dropCorner.CornerRadius = UDim.new(0, 6)
        dropCorner.Parent = modeDropdownFrame
        for i, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 30)
            optBtn.Position = UDim2.new(0, 0, 0, (i-1) * 30)
            optBtn.BackgroundTransparency = 1
            optBtn.Text = opt
            optBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
            optBtn.TextSize = 11
            optBtn.Parent = modeDropdownFrame
            optBtn.MouseButton1Click:Connect(function()
                playClickSound()
                settings.aimbot.aimMode = opt
                modeBtn.Text = opt
                if opt == "Players" then
                    settings.aimbot.aimPlayers = true
                    settings.aimbot.aimNPC = false
                elseif opt == "NPCs" then
                    settings.aimbot.aimPlayers = false
                    settings.aimbot.aimNPC = true
                else
                    settings.aimbot.aimPlayers = true
                    settings.aimbot.aimNPC = true
                end
                modeDropdownFrame:Destroy()
                isModeOpen = false
            end)
            optBtn.MouseEnter:Connect(function()
                TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.8, BackgroundColor3 = Color3.fromRGB(0, 150, 200)}):Play()
            end)
            optBtn.MouseLeave:Connect(function()
                TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundTransparency = 1, BackgroundColor3 = Color3.fromRGB(0, 0, 0)}):Play()
            end)
        end
        isModeOpen = true
    end
end)

y = y + 55
createModernSlider(aimbotPanel, y, "🎯 BÁN KÍNH FOV", 50, 400, settings.aimbot.fovRadius, "px", function(v) settings.aimbot.fovRadius = v end)
y = y + 75
createModernSlider(aimbotPanel, y, "⚡ ĐỘ MỊN", 1, 15, settings.aimbot.smoothness, "", function(v) settings.aimbot.smoothness = v end)
y = y + 75
createModernSlider(aimbotPanel, y, "📏 KHOẢNG CÁCH", 50, 400, settings.aimbot.maxDistance, "m", function(v) settings.aimbot.maxDistance = v end)
y = y + 75
createModernToggle(aimbotPanel, y, "🔫 BẮN TỰ ĐỘNG", function() return settings.aimbot.autoShot end, function(v) settings.aimbot.autoShot = v end)
y = y + 55
createModernToggle(aimbotPanel, y, "👁️ HIỂN THỊ FOV", function() return settings.aimbot.showFOV end, function(v) settings.aimbot.showFOV = v end)
y = y + 55
createModernToggle(aimbotPanel, y, "📏 HIỂN THỊ LINE", function() return settings.aimbot.showLine end, function(v) settings.aimbot.showLine = v end)
y = y + 55

createColorPicker(aimbotPanel, y, "🎨 MÀU FOV", 
    function() return settings.aimbot.fovColorR or 0 end,
    function() return settings.aimbot.fovColorG or 200 end,
    function() return settings.aimbot.fovColorB or 255 end,
    function(v) settings.aimbot.fovColorR = v; settings.aimbot.fovColor = Color3.fromRGB(v, settings.aimbot.fovColorG or 200, settings.aimbot.fovColorB or 255) end,
    function(v) settings.aimbot.fovColorG = v; settings.aimbot.fovColor = Color3.fromRGB(settings.aimbot.fovColorR or 0, v, settings.aimbot.fovColorB or 255) end,
    function(v) settings.aimbot.fovColorB = v; settings.aimbot.fovColor = Color3.fromRGB(settings.aimbot.fovColorR or 0, settings.aimbot.fovColorG or 200, v) end,
    function() end
)

y = y + 125
createColorPicker(aimbotPanel, y, "🎨 MÀU LINE",
    function() return settings.aimbot.lineColorR or 255 end,
    function() return settings.aimbot.lineColorG or 0 end,
    function() return settings.aimbot.lineColorB or 0 end,
    function(v) settings.aimbot.lineColorR = v; settings.aimbot.lineColor = Color3.fromRGB(v, settings.aimbot.lineColorG or 0, settings.aimbot.lineColorB or 0) end,
    function(v) settings.aimbot.lineColorG = v; settings.aimbot.lineColor = Color3.fromRGB(settings.aimbot.lineColorR or 255, v, settings.aimbot.lineColorB or 0) end,
    function(v) settings.aimbot.lineColorB = v; settings.aimbot.lineColor = Color3.fromRGB(settings.aimbot.lineColorR or 255, settings.aimbot.lineColorG or 0, v) end,
    function() end
)

local npcInfoFrame = Instance.new("Frame")
npcInfoFrame.Size = UDim2.new(1, -10, 0, 50)
npcInfoFrame.Position = UDim2.new(0, 5, 0, y + 130)
npcInfoFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
npcInfoFrame.BackgroundTransparency = 0.4
npcInfoFrame.BorderSizePixel = 0
npcInfoFrame.Parent = aimbotPanel
local npcInfoCorner = Instance.new("UICorner")
npcInfoCorner.CornerRadius = UDim.new(0, 10)
npcInfoCorner.Parent = npcInfoFrame

local npcInfoLabel = Instance.new("TextLabel")
npcInfoLabel.Size = UDim2.new(1, -20, 0, 40)
npcInfoLabel.Position = UDim2.new(0, 10, 0, 5)
npcInfoLabel.BackgroundTransparency = 1
npcInfoLabel.Text = "🎯 MẸO: Bật 'AIM NPC' để aim vào bia tập trong Shooting Range\n📌 NPC sẽ hiện khung màu vàng khi ESP bật"
npcInfoLabel.TextColor3 = Color3.fromRGB(200, 200, 150)
npcInfoLabel.TextSize = 9
npcInfoLabel.Font = Enum.Font.Gotham
npcInfoLabel.TextXAlignment = Enum.TextXAlignment.Center
npcInfoLabel.TextWrapped = true
npcInfoLabel.Parent = npcInfoFrame

-- ============ SILENT AIM PANEL ==========
local ySilent = 5

-- Tiêu đề
local silentTitleFrame = Instance.new("Frame")
silentTitleFrame.Size = UDim2.new(1, -10, 0, 50)
silentTitleFrame.Position = UDim2.new(0, 5, 0, ySilent)
silentTitleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
silentTitleFrame.BackgroundTransparency = 0.4
silentTitleFrame.BorderSizePixel = 0
silentTitleFrame.Parent = silentAimPanel
local silentTitleCorner = Instance.new("UICorner")
silentTitleCorner.CornerRadius = UDim.new(0, 10)
silentTitleCorner.Parent = silentTitleFrame

local silentTitleLabel = Instance.new("TextLabel")
silentTitleLabel.Size = UDim2.new(1, -20, 0, 35)
silentTitleLabel.Position = UDim2.new(0, 10, 0, 8)
silentTitleLabel.BackgroundTransparency = 1
silentTitleLabel.Text = "🤫 SILENT AIM - KHÔNG ẢNH HƯỞNG GÓC NHÌN"
silentTitleLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
silentTitleLabel.TextSize = 14
silentTitleLabel.Font = Enum.Font.GothamBold
silentTitleLabel.TextXAlignment = Enum.TextXAlignment.Center
silentTitleLabel.Parent = silentTitleFrame

ySilent = ySilent + 60

-- Toggle Silent Aim
createModernToggle(silentAimPanel, ySilent, "🤫 BẬT SILENT AIM", 
    function() return settings.silentAim.enabled end, 
    function(v) 
        settings.silentAim.enabled = v
        if v then
            setupSilentAimRemote()
        end
    end
)
ySilent = ySilent + 60

-- Mode Silent Aim
local silentModeFrame = Instance.new("Frame")
silentModeFrame.Size = UDim2.new(1, -10, 0, 48)
silentModeFrame.Position = UDim2.new(0, 5, 0, ySilent)
silentModeFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
silentModeFrame.BackgroundTransparency = 0.4
silentModeFrame.BorderSizePixel = 0
silentModeFrame.Parent = silentAimPanel
local silentModeCorner = Instance.new("UICorner")
silentModeCorner.CornerRadius = UDim.new(0, 10)
silentModeCorner.Parent = silentModeFrame

local silentModeLabel = Instance.new("TextLabel")
silentModeLabel.Size = UDim2.new(0, 160, 0, 22)
silentModeLabel.Position = UDim2.new(0, 15, 0, 13)
silentModeLabel.BackgroundTransparency = 1
silentModeLabel.Text = "🎯 AIM MODE"
silentModeLabel.TextColor3 = Color3.fromRGB(230, 230, 255)
silentModeLabel.TextSize = 11
silentModeLabel.Font = Enum.Font.GothamSemibold
silentModeLabel.Parent = silentModeFrame

local silentModeBtn = Instance.new("TextButton")
silentModeBtn.Size = UDim2.new(0, 100, 0, 30)
silentModeBtn.Position = UDim2.new(1, -115, 0, 9)
silentModeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
silentModeBtn.Text = settings.silentAim.mode or "Both"
silentModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
silentModeBtn.TextSize = 11
silentModeBtn.Font = Enum.Font.Gotham
silentModeBtn.Parent = silentModeFrame
local silentModeBtnCorner = Instance.new("UICorner")
silentModeBtnCorner.CornerRadius = UDim.new(0, 6)
silentModeBtnCorner.Parent = silentModeBtn

local silentOptions = {"Players", "NPCs", "Both"}
local isSilentModeOpen = false
local silentDropdownFrame = nil

silentModeBtn.MouseButton1Click:Connect(function()
    playClickSound()
    if isSilentModeOpen then
        if silentDropdownFrame then silentDropdownFrame:Destroy() end
        isSilentModeOpen = false
    else
        silentDropdownFrame = Instance.new("Frame")
        silentDropdownFrame.Size = UDim2.new(0, 100, 0, #silentOptions * 30)
        silentDropdownFrame.Position = UDim2.new(1, -115, 0, 39)
        silentDropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
        silentDropdownFrame.BorderSizePixel = 1
        silentDropdownFrame.BorderColor3 = Color3.fromRGB(80, 80, 120)
        silentDropdownFrame.Parent = silentModeFrame
        local dropCorner = Instance.new("UICorner")
        dropCorner.CornerRadius = UDim.new(0, 6)
        dropCorner.Parent = silentDropdownFrame
        
        for i, opt in ipairs(silentOptions) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 30)
            optBtn.Position = UDim2.new(0, 0, 0, (i-1) * 30)
            optBtn.BackgroundTransparency = 1
            optBtn.Text = opt
            optBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
            optBtn.TextSize = 11
            optBtn.Parent = silentDropdownFrame
            optBtn.MouseButton1Click:Connect(function()
                playClickSound()
                settings.silentAim.mode = opt
                silentModeBtn.Text = opt
                silentDropdownFrame:Destroy()
                isSilentModeOpen = false
            end)
            optBtn.MouseEnter:Connect(function()
                TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.8, BackgroundColor3 = Color3.fromRGB(255, 200, 0)}):Play()
            end)
            optBtn.MouseLeave:Connect(function()
                TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundTransparency = 1, BackgroundColor3 = Color3.fromRGB(0, 0, 0)}):Play()
            end)
        end
        isSilentModeOpen = true
    end
end)

ySilent = ySilent + 60

-- Khoảng cách Silent Aim
createModernSlider(silentAimPanel, ySilent, "📏 KHOẢNG CÁCH", 50, 400, settings.silentAim.maxDistance or 200, "m", 
    function(v) settings.silentAim.maxDistance = v end
)
ySilent = ySilent + 80

-- Aim Part
local partFrame = Instance.new("Frame")
partFrame.Size = UDim2.new(1, -10, 0, 48)
partFrame.Position = UDim2.new(0, 5, 0, ySilent)
partFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
partFrame.BackgroundTransparency = 0.4
partFrame.BorderSizePixel = 0
partFrame.Parent = silentAimPanel
local partCorner = Instance.new("UICorner")
partCorner.CornerRadius = UDim.new(0, 10)
partCorner.Parent = partFrame

local partLabel = Instance.new("TextLabel")
partLabel.Size = UDim2.new(0, 160, 0, 22)
partLabel.Position = UDim2.new(0, 15, 0, 13)
partLabel.BackgroundTransparency = 1
partLabel.Text = "🎯 AIM PART"
partLabel.TextColor3 = Color3.fromRGB(230, 230, 255)
partLabel.TextSize = 11
partLabel.Font = Enum.Font.GothamSemibold
partLabel.Parent = partFrame

local partBtn = Instance.new("TextButton")
partBtn.Size = UDim2.new(0, 100, 0, 30)
partBtn.Position = UDim2.new(1, -115, 0, 9)
partBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
partBtn.Text = settings.silentAim.aimPart or "Head"
partBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
partBtn.TextSize = 11
partBtn.Font = Enum.Font.Gotham
partBtn.Parent = partFrame
local partBtnCorner = Instance.new("UICorner")
partBtnCorner.CornerRadius = UDim.new(0, 6)
partBtnCorner.Parent = partBtn

local partOptions = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}
local isPartOpen = false
local partDropdownFrame = nil

partBtn.MouseButton1Click:Connect(function()
    playClickSound()
    if isPartOpen then
        if partDropdownFrame then partDropdownFrame:Destroy() end
        isPartOpen = false
    else
        partDropdownFrame = Instance.new("Frame")
        partDropdownFrame.Size = UDim2.new(0, 100, 0, #partOptions * 30)
        partDropdownFrame.Position = UDim2.new(1, -115, 0, 39)
        partDropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
        partDropdownFrame.BorderSizePixel = 1
        partDropdownFrame.BorderColor3 = Color3.fromRGB(80, 80, 120)
        partDropdownFrame.Parent = partFrame
        local dropCorner = Instance.new("UICorner")
        dropCorner.CornerRadius = UDim.new(0, 6)
        dropCorner.Parent = partDropdownFrame
        
        for i, opt in ipairs(partOptions) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 30)
            optBtn.Position = UDim2.new(0, 0, 0, (i-1) * 30)
            optBtn.BackgroundTransparency = 1
            optBtn.Text = opt
            optBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
            optBtn.TextSize = 11
            optBtn.Parent = partDropdownFrame
            optBtn.MouseButton1Click:Connect(function()
                playClickSound()
                settings.silentAim.aimPart = opt
                partBtn.Text = opt
                partDropdownFrame:Destroy()
                isPartOpen = false
            end)
            optBtn.MouseEnter:Connect(function()
                TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.8, BackgroundColor3 = Color3.fromRGB(255, 200, 0)}):Play()
            end)
            optBtn.MouseLeave:Connect(function()
                TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundTransparency = 1, BackgroundColor3 = Color3.fromRGB(0, 0, 0)}):Play()
            end)
        end
        isPartOpen = true
    end
end)

ySilent = ySilent + 60

-- Thông tin
local infoFrameSilent = Instance.new("Frame")
infoFrameSilent.Size = UDim2.new(1, -10, 0, 100)
infoFrameSilent.Position = UDim2.new(0, 5, 0, ySilent)
infoFrameSilent.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
infoFrameSilent.BackgroundTransparency = 0.4
infoFrameSilent.BorderSizePixel = 0
infoFrameSilent.Parent = silentAimPanel
local infoCornerSilent = Instance.new("UICorner")
infoCornerSilent.CornerRadius = UDim.new(0, 10)
infoCornerSilent.Parent = infoFrameSilent

local infoLabelSilent = Instance.new("TextLabel")
infoLabelSilent.Size = UDim2.new(1, -20, 0, 80)
infoLabelSilent.Position = UDim2.new(0, 10, 0, 10)
infoLabelSilent.BackgroundTransparency = 1
infoLabelSilent.Text = "📌 SILENT AIM HOẠT ĐỘNG:\n\n• Không ảnh hưởng đến góc nhìn\n• Vẫn có thể xoay camera thoải mái\n• Tự động điều chỉnh hướng bắn về mục tiêu\n• Khi bật Silent Aim, AIMBOT CHUỘT vẫn hoạt động riêng\n• Có thể dùng cả 2 chế độ cùng lúc!"
infoLabelSilent.TextColor3 = Color3.fromRGB(180, 180, 210)
infoLabelSilent.TextSize = 10
infoLabelSilent.Font = Enum.Font.Gotham
infoLabelSilent.TextXAlignment = Enum.TextXAlignment.Center
infoLabelSilent.TextWrapped = true
infoLabelSilent.Parent = infoFrameSilent

-- ============ ESP PANEL ==========
y = 5
createModernToggle(espPanel, y, "✨ BẬT ESP", function() return settings.esp.enabled end, function(v) settings.esp.enabled = v end)
y = y + 55
createModernToggle(espPanel, y, "📦 KHUNG", function() return settings.esp.box end, function(v) settings.esp.box = v end)
y = y + 55
createModernSlider(espPanel, y, "📏 KHOẢNG CÁCH", 50, 500, settings.esp.maxDistance, "m", function(v) settings.esp.maxDistance = v end)
y = y + 75
createModernToggle(espPanel, y, "🏷️ TÊN", function() return settings.esp.name end, function(v) settings.esp.name = v end)
y = y + 55
createModernToggle(espPanel, y, "📐 KHOẢNG CÁCH", function() return settings.esp.distance end, function(v) settings.esp.distance = v end)
y = y + 55
createModernToggle(espPanel, y, "💚 MÁU", function() return settings.esp.health end, function(v) settings.esp.health = v end)
y = y + 55

createColorPicker(espPanel, y, "🎨 MÀU KHUNG",
    function() return settings.esp.boxColorR or 255 end,
    function() return settings.esp.boxColorG or 70 end,
    function() return settings.esp.boxColorB or 70 end,
    function(v) settings.esp.boxColorR = v; settings.esp.boxColor = Color3.fromRGB(v, settings.esp.boxColorG or 70, settings.esp.boxColorB or 70) end,
    function(v) settings.esp.boxColorG = v; settings.esp.boxColor = Color3.fromRGB(settings.esp.boxColorR or 255, v, settings.esp.boxColorB or 70) end,
    function(v) settings.esp.boxColorB = v; settings.esp.boxColor = Color3.fromRGB(settings.esp.boxColorR or 255, settings.esp.boxColorG or 70, v) end,
    function() end
)

y = y + 125
createColorPicker(espPanel, y, "🎨 MÀU XƯƠNG",
    function() return settings.esp.skeletonColorR or 0 end,
    function() return settings.esp.skeletonColorG or 200 end,
    function() return settings.esp.skeletonColorB or 255 end,
    function(v) settings.esp.skeletonColorR = v; settings.esp.skeletonColor = Color3.fromRGB(v, settings.esp.skeletonColorG or 200, settings.esp.skeletonColorB or 255) end,
    function(v) settings.esp.skeletonColorG = v; settings.esp.skeletonColor = Color3.fromRGB(settings.esp.skeletonColorR or 0, v, settings.esp.skeletonColorB or 255) end,
    function(v) settings.esp.skeletonColorB = v; settings.esp.skeletonColor = Color3.fromRGB(settings.esp.skeletonColorR or 0, settings.esp.skeletonColorG or 200, v) end,
    function() end
)

y = y + 125
createColorPicker(espPanel, y, "🎨 MÀU NPC",
    function() return settings.esp.npcColorR or 255 end,
    function() return settings.esp.npcColorG or 200 end,
    function() return settings.esp.npcColorB or 50 end,
    function(v) settings.esp.npcColorR = v; settings.esp.npcColor = Color3.fromRGB(v, settings.esp.npcColorG or 200, settings.esp.npcColorB or 50) end,
    function(v) settings.esp.npcColorG = v; settings.esp.npcColor = Color3.fromRGB(settings.esp.npcColorR or 255, v, settings.esp.npcColorB or 50) end,
    function(v) settings.esp.npcColorB = v; settings.esp.npcColor = Color3.fromRGB(settings.esp.npcColorR or 255, settings.esp.npcColorG or 200, v) end,
    function() end
)

-- SKELETON PANEL
y = 5
createModernToggle(skeletonPanel, y, "🦴 BẬT XƯƠNG", function() return settings.esp.skeleton end, function(v) settings.esp.skeleton = v end)

-- ============ LOCK STATS PANEL ==========
local yLock = 5
createModernToggle(lockStatsPanel, yLock, "🔒 BẬT KHÓA STATS", 
    function() return settings.lockStats.enabled end, 
    function(v) 
        settings.lockStats.enabled = v 
        if v then lockStatsValue() end
        lockStatusLabel.Text = v and "✅ ĐANG KHÓA" or "❌ ĐÃ TẮT"
        lockStatusLabel.TextColor3 = v and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100)
    end
)
yLock = yLock + 60

local lockStatusFrame = Instance.new("Frame")
lockStatusFrame.Size = UDim2.new(1, -10, 0, 50)
lockStatusFrame.Position = UDim2.new(0, 5, 0, yLock)
lockStatusFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
lockStatusFrame.BackgroundTransparency = 0.4
lockStatusFrame.BorderSizePixel = 0
lockStatusFrame.Parent = lockStatsPanel
local lockStatusCorner = Instance.new("UICorner")
lockStatusCorner.CornerRadius = UDim.new(0, 10)
lockStatusCorner.Parent = lockStatusFrame

local lockStatusLabel = Instance.new("TextLabel")
lockStatusLabel.Size = UDim2.new(1, -20, 0, 35)
lockStatusLabel.Position = UDim2.new(0, 10, 0, 8)
lockStatusLabel.BackgroundTransparency = 1
lockStatusLabel.Text = settings.lockStats.enabled and "✅ ĐANG KHÓA" or "❌ ĐÃ TẮT"
lockStatusLabel.TextColor3 = settings.lockStats.enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100)
lockStatusLabel.TextSize = 14
lockStatusLabel.Font = Enum.Font.GothamBold
lockStatusLabel.TextXAlignment = Enum.TextXAlignment.Center
lockStatusLabel.Parent = lockStatusFrame

yLock = yLock + 65

-- Level Slider
local levelFrame = Instance.new("Frame")
levelFrame.Size = UDim2.new(1, -10, 0, 80)
levelFrame.Position = UDim2.new(0, 5, 0, yLock)
levelFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
levelFrame.BackgroundTransparency = 0.4
levelFrame.BorderSizePixel = 0
levelFrame.Parent = lockStatsPanel
local levelCorner = Instance.new("UICorner")
levelCorner.CornerRadius = UDim.new(0, 10)
levelCorner.Parent = levelFrame

local levelTitle = Instance.new("TextLabel")
levelTitle.Size = UDim2.new(0.4, -10, 0, 22)
levelTitle.Position = UDim2.new(0, 10, 0, 5)
levelTitle.BackgroundTransparency = 1
levelTitle.Text = "⭐ LEVEL CẦN KHÓA"
levelTitle.TextColor3 = Color3.fromRGB(230, 230, 255)
levelTitle.TextSize = 11
levelTitle.Font = Enum.Font.GothamBold
levelTitle.TextXAlignment = Enum.TextXAlignment.Left
levelTitle.Parent = levelFrame

local levelValue = Instance.new("TextLabel")
levelValue.Size = UDim2.new(0.3, -10, 0, 22)
levelValue.Position = UDim2.new(0.7, 0, 0, 5)
levelValue.BackgroundTransparency = 1
levelValue.Text = tostring(settings.lockStats.level)
levelValue.TextColor3 = Color3.fromRGB(255, 215, 0)
levelValue.TextSize = 12
levelValue.Font = Enum.Font.GothamBold
levelValue.TextXAlignment = Enum.TextXAlignment.Right
levelValue.Parent = levelFrame

local levelSliderBg = Instance.new("Frame")
levelSliderBg.Size = UDim2.new(1, -20, 0, 4)
levelSliderBg.Position = UDim2.new(0, 10, 0, 45)
levelSliderBg.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
levelSliderBg.BorderSizePixel = 0
levelSliderBg.Parent = levelFrame
local levelSliderBgCorner = Instance.new("UICorner")
levelSliderBgCorner.CornerRadius = UDim.new(0, 2)
levelSliderBgCorner.Parent = levelSliderBg

local levelSliderFill = Instance.new("Frame")
levelSliderFill.Size = UDim2.new(math.clamp(settings.lockStats.level / 10000000000, 0, 1), 0, 1, 0)
levelSliderFill.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
levelSliderFill.BorderSizePixel = 0
levelSliderFill.Parent = levelSliderBg
local levelFillCorner = Instance.new("UICorner")
levelFillCorner.CornerRadius = UDim.new(0, 2)
levelFillCorner.Parent = levelSliderFill

local levelHandle = Instance.new("TextButton")
levelHandle.Size = UDim2.new(0, 16, 0, 16)
levelHandle.Position = UDim2.new(math.clamp(settings.lockStats.level / 10000000000, 0, 1), -8, 0.5, -8)
levelHandle.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
levelHandle.BorderSizePixel = 0
levelHandle.Text = ""
levelHandle.Parent = levelSliderBg
local levelHandleCorner = Instance.new("UICorner")
levelHandleCorner.CornerRadius = UDim.new(0, 8)
levelHandleCorner.Parent = levelHandle

local levelMin = Instance.new("TextLabel")
levelMin.Size = UDim2.new(0, 30, 0, 18)
levelMin.Position = UDim2.new(0, 10, 0, 54)
levelMin.BackgroundTransparency = 1
levelMin.Text = "0"
levelMin.TextColor3 = Color3.fromRGB(150, 150, 200)
levelMin.TextSize = 9
levelMin.Font = Enum.Font.Gotham
levelMin.Parent = levelFrame

local levelMax = Instance.new("TextLabel")
levelMax.Size = UDim2.new(0, 60, 0, 18)
levelMax.Position = UDim2.new(1, -70, 0, 54)
levelMax.BackgroundTransparency = 1
levelMax.Text = "10 Tỷ"
levelMax.TextColor3 = Color3.fromRGB(150, 150, 200)
levelMax.TextSize = 9
levelMax.Font = Enum.Font.Gotham
levelMax.TextXAlignment = Enum.TextXAlignment.Right
levelMax.Parent = levelFrame

local levelDragging = false
levelHandle.MouseButton1Down:Connect(function() levelDragging = true end)

UserInputService.InputChanged:Connect(function(input)
    if levelDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = LocalPlayer:GetMouse()
        local sPos = levelSliderBg.AbsolutePosition.X
        local sWid = levelSliderBg.AbsoluteSize.X
        local percent = math.clamp((mousePos.X - sPos) / sWid, 0, 1)
        local value = math.floor(0 + (10000000000 - 0) * percent)
        settings.lockStats.level = value
        levelValue.Text = tostring(value)
        levelSliderFill.Size = UDim2.new(percent, 0, 1, 0)
        levelHandle.Position = UDim2.new(percent, -8, 0.5, -8)
        if settings.lockStats.enabled and value > 0 then lockStatsValue() end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then levelDragging = false end
end)

yLock = yLock + 95

-- Streak Slider
local streakFrame = Instance.new("Frame")
streakFrame.Size = UDim2.new(1, -10, 0, 80)
streakFrame.Position = UDim2.new(0, 5, 0, yLock)
streakFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
streakFrame.BackgroundTransparency = 0.4
streakFrame.BorderSizePixel = 0
streakFrame.Parent = lockStatsPanel
local streakCorner = Instance.new("UICorner")
streakCorner.CornerRadius = UDim.new(0, 10)
streakCorner.Parent = streakFrame

local streakTitle = Instance.new("TextLabel")
streakTitle.Size = UDim2.new(0.4, -10, 0, 22)
streakTitle.Position = UDim2.new(0, 10, 0, 5)
streakTitle.BackgroundTransparency = 1
streakTitle.Text = "🔥 STREAK CẦN KHÓA"
streakTitle.TextColor3 = Color3.fromRGB(230, 230, 255)
streakTitle.TextSize = 11
streakTitle.Font = Enum.Font.GothamBold
streakTitle.TextXAlignment = Enum.TextXAlignment.Left
streakTitle.Parent = streakFrame

local streakValue = Instance.new("TextLabel")
streakValue.Size = UDim2.new(0.3, -10, 0, 22)
streakValue.Position = UDim2.new(0.7, 0, 0, 5)
streakValue.BackgroundTransparency = 1
streakValue.Text = tostring(settings.lockStats.streak)
streakValue.TextColor3 = Color3.fromRGB(255, 150, 50)
streakValue.TextSize = 12
streakValue.Font = Enum.Font.GothamBold
streakValue.TextXAlignment = Enum.TextXAlignment.Right
streakValue.Parent = streakFrame

local streakSliderBg = Instance.new("Frame")
streakSliderBg.Size = UDim2.new(1, -20, 0, 4)
streakSliderBg.Position = UDim2.new(0, 10, 0, 45)
streakSliderBg.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
streakSliderBg.BorderSizePixel = 0
streakSliderBg.Parent = streakFrame
local streakSliderBgCorner = Instance.new("UICorner")
streakSliderBgCorner.CornerRadius = UDim.new(0, 2)
streakSliderBgCorner.Parent = streakSliderBg

local streakSliderFill = Instance.new("Frame")
streakSliderFill.Size = UDim2.new(math.clamp(settings.lockStats.streak / 10000000000, 0, 1), 0, 1, 0)
streakSliderFill.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
streakSliderFill.BorderSizePixel = 0
streakSliderFill.Parent = streakSliderBg
local streakFillCorner = Instance.new("UICorner")
streakFillCorner.CornerRadius = UDim.new(0, 2)
streakFillCorner.Parent = streakSliderFill

local streakHandle = Instance.new("TextButton")
streakHandle.Size = UDim2.new(0, 16, 0, 16)
streakHandle.Position = UDim2.new(math.clamp(settings.lockStats.streak / 10000000000, 0, 1), -8, 0.5, -8)
streakHandle.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
streakHandle.BorderSizePixel = 0
streakHandle.Text = ""
streakHandle.Parent = streakSliderBg
local streakHandleCorner = Instance.new("UICorner")
streakHandleCorner.CornerRadius = UDim.new(0, 8)
streakHandleCorner.Parent = streakHandle

local streakMin = Instance.new("TextLabel")
streakMin.Size = UDim2.new(0, 30, 0, 18)
streakMin.Position = UDim2.new(0, 10, 0, 54)
streakMin.BackgroundTransparency = 1
streakMin.Text = "0"
streakMin.TextColor3 = Color3.fromRGB(150, 150, 200)
streakMin.TextSize = 9
streakMin.Font = Enum.Font.Gotham
streakMin.Parent = streakFrame

local streakMax = Instance.new("TextLabel")
streakMax.Size = UDim2.new(0, 60, 0, 18)
streakMax.Position = UDim2.new(1, -70, 0, 54)
streakMax.BackgroundTransparency = 1
streakMax.Text = "10 Tỷ"
streakMax.TextColor3 = Color3.fromRGB(150, 150, 200)
streakMax.TextSize = 9
streakMax.Font = Enum.Font.Gotham
streakMax.TextXAlignment = Enum.TextXAlignment.Right
streakMax.Parent = streakFrame

local streakDragging = false
streakHandle.MouseButton1Down:Connect(function() streakDragging = true end)

UserInputService.InputChanged:Connect(function(input)
    if streakDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = LocalPlayer:GetMouse()
        local sPos = streakSliderBg.AbsolutePosition.X
        local sWid = streakSliderBg.AbsoluteSize.X
        local percent = math.clamp((mousePos.X - sPos) / sWid, 0, 1)
        local value = math.floor(0 + (10000000000 - 0) * percent)
        settings.lockStats.streak = value
        streakValue.Text = tostring(value)
        streakSliderFill.Size = UDim2.new(percent, 0, 1, 0)
        streakHandle.Position = UDim2.new(percent, -8, 0.5, -8)
        if settings.lockStats.enabled and value > 0 then lockStatsValue() end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then streakDragging = false end
end)

yLock = yLock + 95

-- ELO Slider
local eloFrame = Instance.new("Frame")
eloFrame.Size = UDim2.new(1, -10, 0, 80)
eloFrame.Position = UDim2.new(0, 5, 0, yLock)
eloFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
eloFrame.BackgroundTransparency = 0.4
eloFrame.BorderSizePixel = 0
eloFrame.Parent = lockStatsPanel
local eloCorner = Instance.new("UICorner")
eloCorner.CornerRadius = UDim.new(0, 10)
eloCorner.Parent = eloFrame

local eloTitle = Instance.new("TextLabel")
eloTitle.Size = UDim2.new(0.4, -10, 0, 22)
eloTitle.Position = UDim2.new(0, 10, 0, 5)
eloTitle.BackgroundTransparency = 1
eloTitle.Text = "🏆 ELO CẦN KHÓA"
eloTitle.TextColor3 = Color3.fromRGB(230, 230, 255)
eloTitle.TextSize = 11
eloTitle.Font = Enum.Font.GothamBold
eloTitle.TextXAlignment = Enum.TextXAlignment.Left
eloTitle.Parent = eloFrame

local eloValue = Instance.new("TextLabel")
eloValue.Size = UDim2.new(0.3, -10, 0, 22)
eloValue.Position = UDim2.new(0.7, 0, 0, 5)
eloValue.BackgroundTransparency = 1
eloValue.Text = tostring(settings.lockStats.elo)
eloValue.TextColor3 = Color3.fromRGB(100, 200, 255)
eloValue.TextSize = 12
eloValue.Font = Enum.Font.GothamBold
eloValue.TextXAlignment = Enum.TextXAlignment.Right
eloValue.Parent = eloFrame

local eloSliderBg = Instance.new("Frame")
eloSliderBg.Size = UDim2.new(1, -20, 0, 4)
eloSliderBg.Position = UDim2.new(0, 10, 0, 45)
eloSliderBg.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
eloSliderBg.BorderSizePixel = 0
eloSliderBg.Parent = eloFrame
local eloSliderBgCorner = Instance.new("UICorner")
eloSliderBgCorner.CornerRadius = UDim.new(0, 2)
eloSliderBgCorner.Parent = eloSliderBg

local eloSliderFill = Instance.new("Frame")
eloSliderFill.Size = UDim2.new(math.clamp(settings.lockStats.elo / 10000000000, 0, 1), 0, 1, 0)
eloSliderFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
eloSliderFill.BorderSizePixel = 0
eloSliderFill.Parent = eloSliderBg
local eloFillCorner = Instance.new("UICorner")
eloFillCorner.CornerRadius = UDim.new(0, 2)
eloFillCorner.Parent = eloSliderFill

local eloHandle = Instance.new("TextButton")
eloHandle.Size = UDim2.new(0, 16, 0, 16)
eloHandle.Position = UDim2.new(math.clamp(settings.lockStats.elo / 10000000000, 0, 1), -8, 0.5, -8)
eloHandle.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
eloHandle.BorderSizePixel = 0
eloHandle.Text = ""
eloHandle.Parent = eloSliderBg
local eloHandleCorner = Instance.new("UICorner")
eloHandleCorner.CornerRadius = UDim.new(0, 8)
eloHandleCorner.Parent = eloHandle

local eloMin = Instance.new("TextLabel")
eloMin.Size = UDim2.new(0, 30, 0, 18)
eloMin.Position = UDim2.new(0, 10, 0, 54)
eloMin.BackgroundTransparency = 1
eloMin.Text = "0"
eloMin.TextColor3 = Color3.fromRGB(150, 150, 200)
eloMin.TextSize = 9
eloMin.Font = Enum.Font.Gotham
eloMin.Parent = eloFrame

local eloMax = Instance.new("TextLabel")
eloMax.Size = UDim2.new(0, 60, 0, 18)
eloMax.Position = UDim2.new(1, -70, 0, 54)
eloMax.BackgroundTransparency = 1
eloMax.Text = "10 Tỷ"
eloMax.TextColor3 = Color3.fromRGB(150, 150, 200)
eloMax.TextSize = 9
eloMax.Font = Enum.Font.Gotham
eloMax.TextXAlignment = Enum.TextXAlignment.Right
eloMax.Parent = eloFrame

local eloDragging = false
eloHandle.MouseButton1Down:Connect(function() eloDragging = true end)

UserInputService.InputChanged:Connect(function(input)
    if eloDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = LocalPlayer:GetMouse()
        local sPos = eloSliderBg.AbsolutePosition.X
        local sWid = eloSliderBg.AbsoluteSize.X
        local percent = math.clamp((mousePos.X - sPos) / sWid, 0, 1)
        local value = math.floor(0 + (10000000000 - 0) * percent)
        settings.lockStats.elo = value
        eloValue.Text = tostring(value)
        eloSliderFill.Size = UDim2.new(percent, 0, 1, 0)
        eloHandle.Position = UDim2.new(percent, -8, 0.5, -8)
        if settings.lockStats.enabled and value > 0 then lockStatsValue() end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then eloDragging = false end
end)

yLock = yLock + 95

-- NAME CHANGER
local nameFrame = Instance.new("Frame")
nameFrame.Size = UDim2.new(1, -10, 0, 110)
nameFrame.Position = UDim2.new(0, 5, 0, yLock)
nameFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
nameFrame.BackgroundTransparency = 0.4
nameFrame.BorderSizePixel = 0
nameFrame.Parent = lockStatsPanel
local nameCorner = Instance.new("UICorner")
nameCorner.CornerRadius = UDim.new(0, 10)
nameCorner.Parent = nameFrame

local nameTitle = Instance.new("TextLabel")
nameTitle.Size = UDim2.new(1, -20, 0, 22)
nameTitle.Position = UDim2.new(0, 10, 0, 5)
nameTitle.BackgroundTransparency = 1
nameTitle.Text = "✏️ ĐỔI TÊN HIỂN THỊ"
nameTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
nameTitle.TextSize = 11
nameTitle.Font = Enum.Font.GothamBold
nameTitle.TextXAlignment = Enum.TextXAlignment.Left
nameTitle.Parent = nameFrame

local nameInput = Instance.new("TextBox")
nameInput.Size = UDim2.new(0.65, -10, 0, 34)
nameInput.Position = UDim2.new(0, 10, 0, 35)
nameInput.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
nameInput.PlaceholderText = "Nhập tên muốn đổi..."
nameInput.Text = settings.lockStats.customName or ""
nameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
nameInput.TextSize = 11
nameInput.Font = Enum.Font.Gotham
nameInput.Parent = nameFrame
local nameInputCorner = Instance.new("UICorner")
nameInputCorner.CornerRadius = UDim.new(0, 6)
nameInputCorner.Parent = nameInput

local changeNameBtn = Instance.new("TextButton")
changeNameBtn.Size = UDim2.new(0.3, -10, 0, 34)
changeNameBtn.Position = UDim2.new(0.68, 5, 0, 35)
changeNameBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
changeNameBtn.Text = "🔄 ĐỔI TÊN"
changeNameBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
changeNameBtn.TextSize = 11
changeNameBtn.Font = Enum.Font.GothamBold
changeNameBtn.Parent = nameFrame
local changeNameCorner = Instance.new("UICorner")
changeNameCorner.CornerRadius = UDim.new(0, 6)
changeNameCorner.Parent = changeNameBtn

local nameStatus = Instance.new("TextLabel")
nameStatus.Size = UDim2.new(1, -20, 0, 22)
nameStatus.Position = UDim2.new(0, 10, 0, 78)
nameStatus.BackgroundTransparency = 1
nameStatus.Text = "💡 Nhập tên rồi bấm ĐỔI TÊN"
nameStatus.TextColor3 = Color3.fromRGB(180, 180, 210)
nameStatus.TextSize = 9
nameStatus.Font = Enum.Font.Gotham
nameStatus.TextXAlignment = Enum.TextXAlignment.Left
nameStatus.Parent = nameFrame

changeNameBtn.MouseButton1Click:Connect(function()
    playClickSound()
    local newName = nameInput.Text
    if newName == "" then
        nameStatus.Text = "❌ Vui lòng nhập tên!"
        nameStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    local success = changePlayerName(newName)
    if success then
        settings.lockStats.customName = newName
        nameStatus.Text = "✅ Đã đổi tên thành: " .. newName
        nameStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
        nameInput.Text = newName
    else
        nameStatus.Text = "❌ Đổi tên thất bại!"
        nameStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
    
    task.delay(3, function()
        if nameStatus.Text ~= "💡 Nhập tên rồi bấm ĐỔI TÊN" then
            nameStatus.Text = "💡 Nhập tên rồi bấm ĐỔI TÊN"
            nameStatus.TextColor3 = Color3.fromRGB(180, 180, 210)
        end
    end)
end)

yLock = yLock + 125

-- Reset button
local resetFrame = Instance.new("Frame")
resetFrame.Size = UDim2.new(1, -10, 0, 55)
resetFrame.Position = UDim2.new(0, 5, 0, yLock)
resetFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
resetFrame.BackgroundTransparency = 0.4
resetFrame.BorderSizePixel = 0
resetFrame.Parent = lockStatsPanel
local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 10)
resetCorner.Parent = resetFrame

local resetDefaultBtn = Instance.new("TextButton")
resetDefaultBtn.Size = UDim2.new(0.9, 0, 0, 38)
resetDefaultBtn.Position = UDim2.new(0.05, 0, 0, 9)
resetDefaultBtn.BackgroundColor3 = Color3.fromRGB(100, 80, 40)
resetDefaultBtn.Text = "🔄 RESET VỀ MẶC ĐỊNH (0 | 0 | 0)"
resetDefaultBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetDefaultBtn.TextSize = 11
resetDefaultBtn.Font = Enum.Font.GothamBold
resetDefaultBtn.Parent = resetFrame
local resetDefaultCorner = Instance.new("UICorner")
resetDefaultCorner.CornerRadius = UDim.new(0, 8)
resetDefaultCorner.Parent = resetDefaultBtn

resetDefaultBtn.MouseButton1Click:Connect(function()
    playClickSound()
    settings.lockStats.level = 0
    settings.lockStats.streak = 0
    settings.lockStats.elo = 0
    levelValue.Text = "0"
    levelSliderFill.Size = UDim2.new(0, 0, 1, 0)
    levelHandle.Position = UDim2.new(0, -8, 0.5, -8)
    streakValue.Text = "0"
    streakSliderFill.Size = UDim2.new(0, 0, 1, 0)
    streakHandle.Position = UDim2.new(0, -8, 0.5, -8)
    eloValue.Text = "0"
    eloSliderFill.Size = UDim2.new(0, 0, 1, 0)
    eloHandle.Position = UDim2.new(0, -8, 0.5, -8)
    if settings.lockStats.enabled then lockStatsValue() end
    
    local notif = Drawing.new("Text")
    notif.Text = "✅ Đã reset về 0!"
    notif.Size = 13
    notif.Color = Color3.fromRGB(0, 255, 0)
    notif.Center = true
    notif.Outline = true
    notif.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - 100)
    notif.Visible = true
    task.wait(1.5)
    notif.Visible = false
    notif:Remove()
end)

-- DEVICE PANEL
y = 5
local deviceTitle = Instance.new("TextLabel")
deviceTitle.Size = UDim2.new(1, -20, 0, 35)
deviceTitle.Position = UDim2.new(0, 10, 0, y)
deviceTitle.BackgroundTransparency = 1
deviceTitle.Text = "🎮 THIẾT BỊ"
deviceTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
deviceTitle.TextSize = 12
deviceTitle.Font = Enum.Font.GothamBold
deviceTitle.TextXAlignment = Enum.TextXAlignment.Center
deviceTitle.Parent = devicePanel

y = y + 45
createDeviceButton(devicePanel, y, "🖱️ CHUỘT & BÀN PHÍM", "MouseKeyboard", Color3.fromRGB(45, 45, 65))
y = y + 52
createDeviceButton(devicePanel, y, "🎮 TAY CẦM", "Gamepad", Color3.fromRGB(45, 65, 45))
y = y + 52
createDeviceButton(devicePanel, y, "📱 CẢM ỨNG", "Touch", Color3.fromRGB(65, 45, 65))
y = y + 52
createDeviceButton(devicePanel, y, "🥽 VR", "VR", Color3.fromRGB(65, 65, 45))

y = y + 60
local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(1, -20, 0, 45)
infoText.Position = UDim2.new(0, 10, 0, y)
infoText.BackgroundTransparency = 1
infoText.Text = "⚠️ Spoof thiết bị thay đổi cách nhập"
infoText.TextColor3 = Color3.fromRGB(150, 150, 200)
infoText.TextSize = 10
infoText.Font = Enum.Font.Gotham
infoText.TextXAlignment = Enum.TextXAlignment.Center
infoText.Parent = devicePanel

-- TP PANEL
y = 5
createModernToggle(tpPanel, y, "🌀 DỊCH CHUYỂN", function() return settings.teleport.enabled end, function(v) settings.teleport.enabled = v end)
y = y + 60

local teleportWarning = Instance.new("Frame")
teleportWarning.Size = UDim2.new(1, -10, 0, 90)
teleportWarning.Position = UDim2.new(0, 5, 0, y)
teleportWarning.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
teleportWarning.BackgroundTransparency = 0.4
teleportWarning.BorderSizePixel = 1
teleportWarning.BorderColor3 = Color3.fromRGB(255, 100, 100)
teleportWarning.Parent = tpPanel
local warnCorner = Instance.new("UICorner")
warnCorner.CornerRadius = UDim.new(0, 10)
warnCorner.Parent = teleportWarning

local warnLabel = Instance.new("TextLabel")
warnLabel.Size = UDim2.new(1, -20, 1, 0)
warnLabel.Position = UDim2.new(0, 10, 0, 5)
warnLabel.BackgroundTransparency = 1
warnLabel.Text = "⚠️ CẢNH BÁO ⚠️\nTeleport quá nhanh (dưới 0.4 giây/lần) sẽ bị BAN sau 10 lần vi phạm!\nChỉ được tele cách nhau tối thiểu 0.4 giây."
warnLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
warnLabel.TextSize = 10
warnLabel.Font = Enum.Font.GothamBold
warnLabel.TextXAlignment = Enum.TextXAlignment.Center
warnLabel.TextWrapped = true
warnLabel.Parent = teleportWarning

y = y + 105
local guideCard = Instance.new("Frame")
guideCard.Size = UDim2.new(1, -10, 0, 90)
guideCard.Position = UDim2.new(0, 5, 0, y)
guideCard.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
guideCard.BackgroundTransparency = 0.4
guideCard.BorderSizePixel = 0
guideCard.Parent = tpPanel
local guideCorner = Instance.new("UICorner")
guideCorner.CornerRadius = UDim.new(0, 10)
guideCorner.Parent = guideCard
local guideLabel = Instance.new("TextLabel")
guideLabel.Size = UDim2.new(1, -20, 0, 70)
guideLabel.Position = UDim2.new(0, 10, 0, 10)
guideLabel.BackgroundTransparency = 1
guideLabel.Text = "📌 CÁCH DÙNG:\n\n   Nhấn [X] để dịch chuyển đến nơi bạn nhìn\n   Đảm bảo có tầm nhìn rõ xuống đất\n   KHÔNG spam tele để tránh bị kick!"
guideLabel.TextColor3 = Color3.fromRGB(200, 200, 230)
guideLabel.TextSize = 10
guideLabel.TextXAlignment = Enum.TextXAlignment.Center
guideLabel.Parent = guideCard

-- AFK PANEL
y = 5
createModernToggle(afkPanel, y, "💤 BẬT AFK", 
    function() return settings.afk.enabled end, 
    function(v) 
        settings.afk.enabled = v 
        updateAFK()
    end
)

y = y + 60
createModernSlider(afkPanel, y, "⏱️ KHOẢNG THỜI GIAN", 10, 300, settings.afk.interval, "s", 
    function(v) 
        settings.afk.interval = v 
        updateAFK()
    end
)

y = y + 80
local statusCard = Instance.new("Frame")
statusCard.Size = UDim2.new(1, -10, 0, 80)
statusCard.Position = UDim2.new(0, 5, 0, y)
statusCard.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
statusCard.BackgroundTransparency = 0.4
statusCard.BorderSizePixel = 0
statusCard.Parent = afkPanel
local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 10)
statusCorner.Parent = statusCard

local statusTitle = Instance.new("TextLabel")
statusTitle.Size = UDim2.new(1, -20, 0, 25)
statusTitle.Position = UDim2.new(0, 10, 0, 5)
statusTitle.BackgroundTransparency = 1
statusTitle.Text = "📊 TRẠNG THÁI"
statusTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
statusTitle.TextSize = 11
statusTitle.Font = Enum.Font.GothamBold
statusTitle.TextXAlignment = Enum.TextXAlignment.Left
statusTitle.Parent = statusCard

local statusValue = Instance.new("TextLabel")
statusValue.Size = UDim2.new(1, -20, 0, 25)
statusValue.Position = UDim2.new(0, 10, 0, 32)
statusValue.BackgroundTransparency = 1
statusValue.Text = settings.afk.enabled and "✅ BẬT" or "❌ TẮT"
statusValue.TextColor3 = settings.afk.enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100)
statusValue.TextSize = 12
statusValue.Font = Enum.Font.GothamBold
statusValue.TextXAlignment = Enum.TextXAlignment.Left
statusValue.Parent = statusCard

updateAFKStatus = function()
    statusValue.Text = settings.afk.enabled and "✅ BẬT" or "❌ TẮT"
    statusValue.TextColor3 = settings.afk.enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100)
end

local originalUpdateAFK = updateAFK
updateAFK = function()
    originalUpdateAFK()
    if updateAFKStatus then pcall(updateAFKStatus) end
end

y = y + 95
local infoCard2 = Instance.new("Frame")
infoCard2.Size = UDim2.new(1, -10, 0, 100)
infoCard2.Position = UDim2.new(0, 5, 0, y)
infoCard2.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
infoCard2.BackgroundTransparency = 0.4
infoCard2.BorderSizePixel = 0
infoCard2.Parent = afkPanel
local infoCorner2 = Instance.new("UICorner")
infoCorner2.CornerRadius = UDim.new(0, 10)
infoCorner2.Parent = infoCard2

local infoTitle2 = Instance.new("TextLabel")
infoTitle2.Size = UDim2.new(1, -20, 0, 25)
infoTitle2.Position = UDim2.new(0, 10, 0, 5)
infoTitle2.BackgroundTransparency = 1
infoTitle2.Text = "ℹ️ HƯỚNG DẪN"
infoTitle2.TextColor3 = Color3.fromRGB(0, 200, 255)
infoTitle2.TextSize = 11
infoTitle2.Font = Enum.Font.GothamBold
infoTitle2.TextXAlignment = Enum.TextXAlignment.Left
infoTitle2.Parent = infoCard2

local infoDesc2 = Instance.new("TextLabel")
infoDesc2.Size = UDim2.new(1, -20, 0, 65)
infoDesc2.Position = UDim2.new(0, 10, 0, 30)
infoDesc2.BackgroundTransparency = 1
infoDesc2.Text = "• Mô phỏng thao tác ngẫu nhiên\n• Ngăn game đá khi AFK\n• Hoạt động: Di chuột, nhảy nhẹ, lắc camera"
infoDesc2.TextColor3 = Color3.fromRGB(180, 180, 210)
infoDesc2.TextSize = 9
infoDesc2.Font = Enum.Font.Gotham
infoDesc2.TextXAlignment = Enum.TextXAlignment.Left
infoDesc2.Parent = infoCard2

pcall(updateAFKStatus)

-- ============ PLAYERS PANEL ==========
local function refreshPlayersList()
    for _, child in pairs(playersPanel:GetChildren()) do
        if child:IsA("Frame") or child:IsA("ScrollingFrame") or child:IsA("TextButton") or child:IsA("TextBox") then
            child:Destroy()
        end
    end
    
    local yPos = 5
    
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(1, -10, 0, 50)
    titleFrame.Position = UDim2.new(0, 5, 0, yPos)
    titleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    titleFrame.BackgroundTransparency = 0.4
    titleFrame.BorderSizePixel = 0
    titleFrame.Parent = playersPanel
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 35)
    titleLabel.Position = UDim2.new(0, 10, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "👥 PLAYERS"
    titleLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.Parent = titleFrame
    
    yPos = yPos + 60
    
    local statsFrame = Instance.new("Frame")
    statsFrame.Size = UDim2.new(1, -10, 0, 36)
    statsFrame.Position = UDim2.new(0, 5, 0, yPos)
    statsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    statsFrame.BackgroundTransparency = 0.4
    statsFrame.BorderSizePixel = 0
    statsFrame.Parent = playersPanel
    local statsCorner = Instance.new("UICorner")
    statsCorner.CornerRadius = UDim.new(0, 10)
    statsCorner.Parent = statsFrame
    
    local playerCount = #Players:GetPlayers()
    local teamCount = 0
    for name, _ in pairs(teamPlayers) do
        if Players:FindFirstChild(name) then
            teamCount = teamCount + 1
        end
    end
    
    local statsLabel = Instance.new("TextLabel")
    statsLabel.Size = UDim2.new(1, -20, 0, 26)
    statsLabel.Position = UDim2.new(0, 10, 0, 5)
    statsLabel.BackgroundTransparency = 1
    statsLabel.Text = "📊 Tổng: " .. playerCount .. "  |  🤝 Team: " .. teamCount
    statsLabel.TextColor3 = Color3.fromRGB(200, 200, 230)
    statsLabel.TextSize = 11
    statsLabel.Font = Enum.Font.Gotham
    statsLabel.TextXAlignment = Enum.TextXAlignment.Center
    statsLabel.Parent = statsFrame
    
    yPos = yPos + 50
    
    local searchFrame = Instance.new("Frame")
    searchFrame.Size = UDim2.new(1, -10, 0, 42)
    searchFrame.Position = UDim2.new(0, 5, 0, yPos)
    searchFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    searchFrame.BackgroundTransparency = 0.4
    searchFrame.BorderSizePixel = 0
    searchFrame.Parent = playersPanel
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 8)
    searchCorner.Parent = searchFrame
    
    local searchIcon = Instance.new("TextLabel")
    searchIcon.Size = UDim2.new(0, 30, 0, 30)
    searchIcon.Position = UDim2.new(0, 8, 0, 6)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Text = "🔍"
    searchIcon.TextColor3 = Color3.fromRGB(150, 150, 200)
    searchIcon.TextSize = 16
    searchIcon.Font = Enum.Font.Gotham
    searchIcon.TextXAlignment = Enum.TextXAlignment.Center
    searchIcon.Parent = searchFrame
    
    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -50, 0, 32)
    searchBox.Position = UDim2.new(0, 42, 0, 5)
    searchBox.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    searchBox.BackgroundTransparency = 0.2
    searchBox.PlaceholderText = "🔎 Tìm kiếm..."
    searchBox.Text = ""
    searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBox.TextSize = 11
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.ClearTextOnFocus = true
    searchBox.Parent = searchFrame
    local searchBoxCorner = Instance.new("UICorner")
    searchBoxCorner.CornerRadius = UDim.new(0, 6)
    searchBoxCorner.Parent = searchBox
    
    yPos = yPos + 55
    
    local clearTeamBtn = Instance.new("TextButton")
    clearTeamBtn.Size = UDim2.new(0.9, 0, 0, 36)
    clearTeamBtn.Position = UDim2.new(0.05, 0, 0, yPos)
    clearTeamBtn.BackgroundColor3 = Color3.fromRGB(100, 60, 60)
    clearTeamBtn.Text = "🗑️ XÓA TEAM"
    clearTeamBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearTeamBtn.TextSize = 11
    clearTeamBtn.Font = Enum.Font.GothamBold
    clearTeamBtn.Parent = playersPanel
    local clearCorner = Instance.new("UICorner")
    clearCorner.CornerRadius = UDim.new(0, 8)
    clearCorner.Parent = clearTeamBtn
    
    clearTeamBtn.MouseButton1Click:Connect(function()
        playClickSound()
        clearAllTeammates()
        refreshPlayersList()
        local notif = Drawing.new("Text")
        notif.Text = "✅ Đã xóa team!"
        notif.Size = 13
        notif.Color = Color3.fromRGB(0, 255, 0)
        notif.Center = true
        notif.Outline = true
        notif.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - 100)
        notif.Visible = true
        task.wait(1.5)
        notif.Visible = false
        notif:Remove()
    end)
    
    yPos = yPos + 50
    
    local listTitle = Instance.new("TextLabel")
    listTitle.Size = UDim2.new(1, -20, 0, 25)
    listTitle.Position = UDim2.new(0, 10, 0, yPos)
    listTitle.BackgroundTransparency = 1
    listTitle.Text = "👥 DANH SÁCH"
    listTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
    listTitle.TextSize = 12
    listTitle.Font = Enum.Font.GothamBold
    listTitle.TextXAlignment = Enum.TextXAlignment.Left
    listTitle.Parent = playersPanel
    
    yPos = yPos + 35
    
    local playerScrollFrame = Instance.new("ScrollingFrame")
    playerScrollFrame.Size = UDim2.new(1, -10, 0, 360)
    playerScrollFrame.Position = UDim2.new(0, 5, 0, yPos)
    playerScrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    playerScrollFrame.BackgroundTransparency = 0.3
    playerScrollFrame.BorderSizePixel = 0
    playerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 200)
    playerScrollFrame.ScrollBarThickness = 4
    playerScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 200)
    playerScrollFrame.ClipsDescendants = true
    playerScrollFrame.Parent = playersPanel
    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0, 10)
    scrollCorner.Parent = playerScrollFrame
    
    local scrollContainer = Instance.new("Frame")
    scrollContainer.Size = UDim2.new(1, 0, 0, 0)
    scrollContainer.BackgroundTransparency = 1
    scrollContainer.Parent = playerScrollFrame
    
    local function updatePlayerList(filterText)
        for _, child in pairs(scrollContainer:GetChildren()) do
            child:Destroy()
        end
        
        local scrollY = 0
        local playersList = {}
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(playersList, player)
            end
        end
        
        table.sort(playersList, function(a, b) return a.Name < b.Name end)
        
        local filteredPlayers = {}
        local searchLower = filterText and string.lower(filterText) or ""
        
        for _, player in pairs(playersList) do
            if searchLower == "" or string.find(string.lower(player.Name), searchLower, 1, true) then
                table.insert(filteredPlayers, player)
            end
        end
        
        for _, player in pairs(filteredPlayers) do
            local isTeam = isTeammate(player)
            
            local playerFrame = Instance.new("Frame")
            playerFrame.Size = UDim2.new(1, -10, 0, 50)
            playerFrame.Position = UDim2.new(0, 5, 0, scrollY)
            playerFrame.BackgroundColor3 = isTeam and Color3.fromRGB(0, 100, 50) or Color3.fromRGB(35, 35, 55)
            playerFrame.BackgroundTransparency = 0.3
            playerFrame.BorderSizePixel = 0
            playerFrame.Parent = scrollContainer
            local playerCorner = Instance.new("UICorner")
            playerCorner.CornerRadius = UDim.new(0, 8)
            playerCorner.Parent = playerFrame
            
            local iconLabel = Instance.new("TextLabel")
            iconLabel.Size = UDim2.new(0, 35, 0, 35)
            iconLabel.Position = UDim2.new(0, 8, 0, 8)
            iconLabel.BackgroundTransparency = 1
            iconLabel.Text = isTeam and "🤝" or "👤"
            iconLabel.TextColor3 = isTeam and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(200, 200, 200)
            iconLabel.TextSize = 22
            iconLabel.Font = Enum.Font.GothamBold
            iconLabel.TextXAlignment = Enum.TextXAlignment.Center
            iconLabel.Parent = playerFrame
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(0, 130, 0, 22)
            nameLabel.Position = UDim2.new(0, 52, 0, 6)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = isTeam and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            nameLabel.TextSize = 12
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.Parent = playerFrame
            
            local statusLabel = Instance.new("TextLabel")
            statusLabel.Size = UDim2.new(0, 70, 0, 18)
            statusLabel.Position = UDim2.new(0, 52, 0, 26)
            statusLabel.BackgroundTransparency = 1
            statusLabel.Text = isTeam and "TEAM" or "ENEMY"
            statusLabel.TextColor3 = isTeam and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 100, 100)
            statusLabel.TextSize = 9
            statusLabel.Font = Enum.Font.Gotham
            statusLabel.TextXAlignment = Enum.TextXAlignment.Left
            statusLabel.Parent = playerFrame
            
            local teamBtn = Instance.new("TextButton")
            teamBtn.Size = UDim2.new(0, 70, 0, 32)
            teamBtn.Position = UDim2.new(1, -150, 0, 9)
            teamBtn.BackgroundColor3 = isTeam and Color3.fromRGB(100, 60, 60) or Color3.fromRGB(0, 150, 200)
            teamBtn.Text = isTeam and "❌ XÓA" or "➕ TEAM"
            teamBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            teamBtn.TextSize = 10
            teamBtn.Font = Enum.Font.GothamBold
            teamBtn.Parent = playerFrame
            local teamCorner = Instance.new("UICorner")
            teamCorner.CornerRadius = UDim.new(0, 6)
            teamCorner.Parent = teamBtn
            
            teamBtn.MouseButton1Click:Connect(function()
                playClickSound()
                if isTeam then
                    removeTeammate(player)
                else
                    addTeammate(player)
                end
                refreshPlayersList()
            end)
            
            local tpBtn = Instance.new("TextButton")
            tpBtn.Size = UDim2.new(0, 65, 0, 32)
            tpBtn.Position = UDim2.new(1, -75, 0, 9)
            tpBtn.BackgroundColor3 = Color3.fromRGB(100, 80, 40)
            tpBtn.Text = "🌀 TP"
            tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            tpBtn.TextSize = 10
            tpBtn.Font = Enum.Font.GothamBold
            tpBtn.Parent = playerFrame
            local tpCorner = Instance.new("UICorner")
            tpCorner.CornerRadius = UDim.new(0, 6)
            tpCorner.Parent = tpBtn
            
            tpBtn.MouseButton1Click:Connect(function()
                playClickSound()
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local targetPos = player.Character.HumanoidRootPart.Position
                    local myChar = LocalPlayer.Character
                    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                        myChar.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
                        local notif = Drawing.new("Text")
                        notif.Text = "🌀 Teleport to: " .. player.Name
                        notif.Size = 12
                        notif.Color = Color3.fromRGB(0, 200, 255)
                        notif.Center = true
                        notif.Outline = true
                        notif.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - 100)
                        notif.Visible = true
                        task.wait(1.5)
                        notif.Visible = false
                        notif:Remove()
                    end
                else
                    local notif = Drawing.new("Text")
                    notif.Text = "❌ Không thể TP đến " .. player.Name
                    notif.Size = 12
                    notif.Color = Color3.fromRGB(255, 0, 0)
                    notif.Center = true
                    notif.Outline = true
                    notif.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - 100)
                    notif.Visible = true
                    task.wait(1.5)
                    notif.Visible = false
                    notif:Remove()
                end
            end)
            
            scrollY = scrollY + 58
        end
        
        local localFrame = Instance.new("Frame")
        localFrame.Size = UDim2.new(1, -10, 0, 50)
        localFrame.Position = UDim2.new(0, 5, 0, scrollY)
        localFrame.BackgroundColor3 = Color3.fromRGB(0, 80, 120)
        localFrame.BackgroundTransparency = 0.3
        localFrame.BorderSizePixel = 0
        localFrame.Parent = scrollContainer
        local localCorner = Instance.new("UICorner")
        localCorner.CornerRadius = UDim.new(0, 8)
        localCorner.Parent = localFrame
        
        local localIcon = Instance.new("TextLabel")
        localIcon.Size = UDim2.new(0, 35, 0, 35)
        localIcon.Position = UDim2.new(0, 8, 0, 8)
        localIcon.BackgroundTransparency = 1
        localIcon.Text = "👑"
        localIcon.TextColor3 = Color3.fromRGB(255, 215, 0)
        localIcon.TextSize = 22
        localIcon.Font = Enum.Font.GothamBold
        localIcon.TextXAlignment = Enum.TextXAlignment.Center
        localIcon.Parent = localFrame
        
        local localNameLabel = Instance.new("TextLabel")
        localNameLabel.Size = UDim2.new(0, 150, 0, 22)
        localNameLabel.Position = UDim2.new(0, 52, 0, 6)
        localNameLabel.BackgroundTransparency = 1
        localNameLabel.Text = LocalPlayer.Name .. " (YOU)"
        localNameLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
        localNameLabel.TextSize = 12
        localNameLabel.Font = Enum.Font.GothamBold
        localNameLabel.TextXAlignment = Enum.TextXAlignment.Left
        localNameLabel.Parent = localFrame
        
        local localStatus = Instance.new("TextLabel")
        localStatus.Size = UDim2.new(0, 70, 0, 18)
        localStatus.Position = UDim2.new(0, 52, 0, 26)
        localStatus.BackgroundTransparency = 1
        localStatus.Text = "YOU"
        localStatus.TextColor3 = Color3.fromRGB(255, 215, 0)
        localStatus.TextSize = 9
        localStatus.Font = Enum.Font.Gotham
        localStatus.TextXAlignment = Enum.TextXAlignment.Left
        localStatus.Parent = localFrame
        
        scrollY = scrollY + 58
        playerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(scrollY, 360))
        scrollContainer.Size = UDim2.new(1, 0, 0, scrollY)
    end
    
    updatePlayerList("")
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        updatePlayerList(searchBox.Text)
    end)
end

Players.PlayerAdded:Connect(refreshPlayersList)
Players.PlayerRemoving:Connect(refreshPlayersList)

-- ============ SAVE CONFIG & LOAD CONFIG ==========
local function saveConfig(configName)
    if not configName or configName == "" then
        configName = "default"
    end
    configName = string.gsub(configName, "[^%w%_%-]", "_")
    
    settings.esp.boxColor = Color3.fromRGB(settings.esp.boxColorR, settings.esp.boxColorG, settings.esp.boxColorB)
    settings.esp.skeletonColor = Color3.fromRGB(settings.esp.skeletonColorR, settings.esp.skeletonColorG, settings.esp.skeletonColorB)
    settings.esp.npcColor = Color3.fromRGB(settings.esp.npcColorR, settings.esp.npcColorG, settings.esp.npcColorB)
    settings.aimbot.fovColor = Color3.fromRGB(settings.aimbot.fovColorR, settings.aimbot.fovColorG, settings.aimbot.fovColorB)
    settings.aimbot.lineColor = Color3.fromRGB(settings.aimbot.lineColorR, settings.aimbot.lineColorG, settings.aimbot.lineColorB)
    
    local configData = {
        name = configName,
        savedAt = os.date("%Y-%m-%d %H:%M:%S"),
        settings = settings,
        teamPlayers = teamPlayers,
        device = currentDevice or "MouseKeyboard",
    }
    
    if next(savedSkinList) then
        configData.savedSkins = savedSkinList
    else
        configData.savedSkins = {}
    end
    
    local jsonData = HttpService:JSONEncode(configData)
    local success = pcall(function()
        if writefile then
            writefile(ConfigFolder .. "/" .. configName .. ".json", jsonData)
            return true
        end
        return false
    end)
    
    if success then
        return true, "✅ Đã lưu: " .. configName .. " (" .. tablelength(savedSkinList) .. " skin, device: " .. currentDevice .. ")"
    end
    return false, "❌ Không thể lưu"
end

local function loadConfig(configName)
    if not configName or configName == "" then return false, "Tên không hợp lệ" end
    
    local success, data = pcall(function()
        if readfile and isfile then
            local filePath = ConfigFolder .. "/" .. configName .. ".json"
            if isfile(filePath) then
                return readfile(filePath)
            end
        end
        return nil
    end)
    
    if success and data then
        local loaded = HttpService:JSONDecode(data)
        if loaded and loaded.settings then
            for category, values in pairs(loaded.settings) do
                if settings[category] then
                    for k, v in pairs(values) do
                        if settings[category][k] ~= nil then
                            settings[category][k] = v
                        end
                    end
                end
            end
            
            settings.esp.boxColor = Color3.fromRGB(settings.esp.boxColorR or 255, settings.esp.boxColorG or 70, settings.esp.boxColorB or 70)
            settings.esp.skeletonColor = Color3.fromRGB(settings.esp.skeletonColorR or 0, settings.esp.skeletonColorG or 200, settings.esp.skeletonColorB or 255)
            settings.esp.npcColor = Color3.fromRGB(settings.esp.npcColorR or 255, settings.esp.npcColorG or 200, settings.esp.npcColorB or 50)
            settings.aimbot.fovColor = Color3.fromRGB(settings.aimbot.fovColorR or 0, settings.aimbot.fovColorG or 200, settings.aimbot.fovColorB or 255)
            settings.aimbot.lineColor = Color3.fromRGB(settings.aimbot.lineColorR or 255, settings.aimbot.lineColorG or 0, settings.aimbot.lineColorB or 0)
            
            if loaded.settings.afk then
                settings.afk.enabled = loaded.settings.afk.enabled or true
                settings.afk.interval = loaded.settings.afk.interval or 45
                if _G.AntiAFKControl then
                    if settings.afk.enabled then
                        _G.AntiAFKControl.start()
                    else
                        _G.AntiAFKControl.stop()
                    end
                    _G.AntiAFKControl.setInterval(settings.afk.interval)
                end
            end
            
            if loaded.settings.lockStats then
                settings.lockStats.enabled = loaded.settings.lockStats.enabled or true
                settings.lockStats.level = loaded.settings.lockStats.level or 0
                settings.lockStats.streak = loaded.settings.lockStats.streak or 0
                settings.lockStats.elo = loaded.settings.lockStats.elo or 0
                settings.lockStats.customName = loaded.settings.lockStats.customName or ""
                lockStatsValue()
                if settings.lockStats.customName and settings.lockStats.customName ~= "" then
                    changePlayerName(settings.lockStats.customName)
                end
            end
            
            if loaded.settings.aimbot then
                if loaded.settings.aimbot.aimPlayers ~= nil then
                    settings.aimbot.aimPlayers = loaded.settings.aimbot.aimPlayers
                end
                if loaded.settings.aimbot.aimNPC ~= nil then
                    settings.aimbot.aimNPC = loaded.settings.aimbot.aimNPC
                end
                if loaded.settings.aimbot.xuyenTuong ~= nil then
                    settings.aimbot.xuyenTuong = loaded.settings.aimbot.xuyenTuong
                end
            end
            
            if loaded.settings.silentAim then
                settings.silentAim.enabled = loaded.settings.silentAim.enabled or false
                settings.silentAim.mode = loaded.settings.silentAim.mode or "Both"
                settings.silentAim.maxDistance = loaded.settings.silentAim.maxDistance or 200
                settings.silentAim.aimPart = loaded.settings.silentAim.aimPart or "Head"
            end
            
            if loaded.teamPlayers then
                teamPlayers = loaded.teamPlayers
            end
            
            if loaded.device then
                currentDevice = loaded.device
                task.spawn(function()
                    spoofDevice(currentDevice)
                end)
            end
            
            if loaded.savedSkins and next(loaded.savedSkins) then
                savedSkinList = loaded.savedSkins
                task.spawn(function()
                    task.wait(1)
                    local count = ApplyAllSavedSkins()
                    print("✅ Đã tự động áp dụng " .. count .. " skin từ config")
                    if skinPanel and skinPanel.Visible then
                        pcall(refreshSkinPanel)
                    end
                end)
            else
                savedSkinList = {}
            end
            
            -- Cập nhật UI
            task.spawn(function()
                task.wait(0.1)
                if updateLockStatsUI then pcall(updateLockStatsUI) end
                task.wait(0.2)
                if updateLockStatsUI then pcall(updateLockStatsUI) end
                task.wait(0.3)
                if refreshAllSettingsUI then pcall(refreshAllSettingsUI) end
                task.wait(0.5)
                if updateLockStatsUI then pcall(updateLockStatsUI) end
            end)
            
            return true, "✅ Đã tải: " .. configName .. " (" .. tablelength(savedSkinList) .. " skin, device: " .. currentDevice .. ")"
        end
    end
    return false, "❌ Không tìm thấy config"
end

-- ============ CONFIG PANEL ==========
local function refreshConfigList()
    for _, child in pairs(configPanel:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local yPos = 5
    
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(1, -10, 0, 50)
    titleFrame.Position = UDim2.new(0, 5, 0, yPos)
    titleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    titleFrame.BackgroundTransparency = 0.4
    titleFrame.BorderSizePixel = 0
    titleFrame.Parent = configPanel
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleFrame
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 35)
    titleLabel.Position = UDim2.new(0, 10, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "⚙️ CONFIG"
    titleLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.Parent = titleFrame
    
    yPos = yPos + 60
    
    local autoLoadFrame = Instance.new("Frame")
    autoLoadFrame.Size = UDim2.new(1, -10, 0, 90)
    autoLoadFrame.Position = UDim2.new(0, 5, 0, yPos)
    autoLoadFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    autoLoadFrame.BackgroundTransparency = 0.4
    autoLoadFrame.BorderSizePixel = 0
    autoLoadFrame.Parent = configPanel
    local autoLoadCorner = Instance.new("UICorner")
    autoLoadCorner.CornerRadius = UDim.new(0, 10)
    autoLoadCorner.Parent = autoLoadFrame
    
    local autoLoadLabel = Instance.new("TextLabel")
    autoLoadLabel.Size = UDim2.new(1, -20, 0, 22)
    autoLoadLabel.Position = UDim2.new(0, 10, 0, 5)
    autoLoadLabel.BackgroundTransparency = 1
    autoLoadLabel.Text = "🔄 AUTO LOAD"
    autoLoadLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    autoLoadLabel.TextSize = 11
    autoLoadLabel.Font = Enum.Font.GothamBold
    autoLoadLabel.TextXAlignment = Enum.TextXAlignment.Left
    autoLoadLabel.Parent = autoLoadFrame
    
    local currentAutoLoad = getAutoLoadConfig()
    local autoLoadStatus = Instance.new("TextLabel")
    autoLoadStatus.Size = UDim2.new(1, -20, 0, 22)
    autoLoadStatus.Position = UDim2.new(0, 10, 0, 32)
    autoLoadStatus.BackgroundTransparency = 1
    autoLoadStatus.Text = currentAutoLoad and "📌 " .. currentAutoLoad or "📌 Chưa cài"
    autoLoadStatus.TextColor3 = currentAutoLoad and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 200, 100)
    autoLoadStatus.TextSize = 10
    autoLoadStatus.Font = Enum.Font.Gotham
    autoLoadStatus.TextXAlignment = Enum.TextXAlignment.Left
    autoLoadStatus.Parent = autoLoadFrame
    
    local clearAutoLoadBtn = Instance.new("TextButton")
    clearAutoLoadBtn.Size = UDim2.new(0, 80, 0, 28)
    clearAutoLoadBtn.Position = UDim2.new(1, -90, 0, 50)
    clearAutoLoadBtn.BackgroundColor3 = Color3.fromRGB(100, 60, 60)
    clearAutoLoadBtn.Text = "XÓA"
    clearAutoLoadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearAutoLoadBtn.TextSize = 10
    clearAutoLoadBtn.Font = Enum.Font.GothamBold
    clearAutoLoadBtn.Parent = autoLoadFrame
    local clearCorner = Instance.new("UICorner")
    clearCorner.CornerRadius = UDim.new(0, 6)
    clearCorner.Parent = clearAutoLoadBtn
    
    clearAutoLoadBtn.MouseButton1Click:Connect(function()
        playClickSound()
        clearAutoLoadConfig()
        autoLoadStatus.Text = "📌 Chưa cài"
        autoLoadStatus.TextColor3 = Color3.fromRGB(255, 200, 100)
        refreshConfigList()
        local notif = Drawing.new("Text")
        notif.Text = "✅ Đã xóa auto-load!"
        notif.Size = 13
        notif.Color = Color3.fromRGB(0, 255, 0)
        notif.Center = true
        notif.Outline = true
        notif.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - 100)
        notif.Visible = true
        task.wait(1.5)
        notif.Visible = false
        notif:Remove()
    end)
    
    yPos = yPos + 100
    
    local createFrame = Instance.new("Frame")
    createFrame.Size = UDim2.new(1, -10, 0, 90)
    createFrame.Position = UDim2.new(0, 5, 0, yPos)
    createFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    createFrame.BackgroundTransparency = 0.4
    createFrame.BorderSizePixel = 0
    createFrame.Parent = configPanel
    local createCorner = Instance.new("UICorner")
    createCorner.CornerRadius = UDim.new(0, 10)
    createCorner.Parent = createFrame
    local createLabel = Instance.new("TextLabel")
    createLabel.Size = UDim2.new(1, -20, 0, 22)
    createLabel.Position = UDim2.new(0, 10, 0, 5)
    createLabel.BackgroundTransparency = 1
    createLabel.Text = "📝 TẠO MỚI"
    createLabel.TextColor3 = Color3.fromRGB(230, 230, 255)
    createLabel.TextSize = 11
    createLabel.Font = Enum.Font.GothamBold
    createLabel.TextXAlignment = Enum.TextXAlignment.Left
    createLabel.Parent = createFrame
    local configNameInput = Instance.new("TextBox")
    configNameInput.Size = UDim2.new(0.6, -10, 0, 34)
    configNameInput.Position = UDim2.new(0, 10, 0, 35)
    configNameInput.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    configNameInput.PlaceholderText = "Nhập tên..."
    configNameInput.Text = ""
    configNameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    configNameInput.TextSize = 11
    configNameInput.Font = Enum.Font.Gotham
    configNameInput.Parent = createFrame
    local nameCorner = Instance.new("UICorner")
    nameCorner.CornerRadius = UDim.new(0, 6)
    nameCorner.Parent = configNameInput
    local createConfigBtn = Instance.new("TextButton")
    createConfigBtn.Size = UDim2.new(0.35, -10, 0, 34)
    createConfigBtn.Position = UDim2.new(0.65, 0, 0, 35)
    createConfigBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    createConfigBtn.Text = "💾 LƯU"
    createConfigBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    createConfigBtn.TextSize = 11
    createConfigBtn.Font = Enum.Font.GothamBold
    createConfigBtn.Parent = createFrame
    local createCorner2 = Instance.new("UICorner")
    createCorner2.CornerRadius = UDim.new(0, 6)
    createCorner2.Parent = createConfigBtn
    
    yPos = yPos + 100
    
    local listFrame = Instance.new("Frame")
    listFrame.Size = UDim2.new(1, -10, 0, 250)
    listFrame.Position = UDim2.new(0, 5, 0, yPos)
    listFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    listFrame.BackgroundTransparency = 0.4
    listFrame.BorderSizePixel = 0
    listFrame.Parent = configPanel
    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 10)
    listCorner.Parent = listFrame
    local listLabel = Instance.new("TextLabel")
    listLabel.Size = UDim2.new(0.6, -10, 0, 22)
    listLabel.Position = UDim2.new(0, 10, 0, 5)
    listLabel.BackgroundTransparency = 1
    listLabel.Text = "📋 DANH SÁCH"
    listLabel.TextColor3 = Color3.fromRGB(230, 230, 255)
    listLabel.TextSize = 11
    listLabel.Font = Enum.Font.GothamBold
    listLabel.TextXAlignment = Enum.TextXAlignment.Left
    listLabel.Parent = listFrame
    
    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Size = UDim2.new(0, 70, 0, 26)
    refreshBtn.Position = UDim2.new(1, -80, 0, 4)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 85)
    refreshBtn.Text = "🔄 REFRESH"
    refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshBtn.TextSize = 9
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.Parent = listFrame
    local refreshCorner = Instance.new("UICorner")
    refreshCorner.CornerRadius = UDim.new(0, 5)
    refreshCorner.Parent = refreshBtn
    
    local configListScrolling = Instance.new("ScrollingFrame")
    configListScrolling.Size = UDim2.new(1, -10, 1, -40)
    configListScrolling.Position = UDim2.new(0, 5, 0, 35)
    configListScrolling.BackgroundTransparency = 1
    configListScrolling.BorderSizePixel = 0
    configListScrolling.CanvasSize = UDim2.new(0, 0, 0, 200)
    configListScrolling.ScrollBarThickness = 4
    configListScrolling.Parent = listFrame
    
    local function updateConfigList()
        for _, child in pairs(configListScrolling:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        local configs = getConfigList()
        local scrollY = 0
        local autoLoadName = getAutoLoadConfig()
        
        for _, cfgName in pairs(configs) do
            local cfgFrame = Instance.new("Frame")
            cfgFrame.Size = UDim2.new(1, -10, 0, 50)
            cfgFrame.Position = UDim2.new(0, 5, 0, scrollY)
            cfgFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
            cfgFrame.BackgroundTransparency = 0.3
            cfgFrame.BorderSizePixel = 0
            cfgFrame.Parent = configListScrolling
            local cfgCorner = Instance.new("UICorner")
            cfgCorner.CornerRadius = UDim.new(0, 6)
            cfgCorner.Parent = cfgFrame
            
            local cfgNameLabel = Instance.new("TextLabel")
            cfgNameLabel.Size = UDim2.new(0.4, -10, 0, 22)
            cfgNameLabel.Position = UDim2.new(0, 10, 0, 6)
            cfgNameLabel.BackgroundTransparency = 1
            cfgNameLabel.Text = cfgName
            cfgNameLabel.TextColor3 = (autoLoadName == cfgName) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 200, 255)
            cfgNameLabel.TextSize = 11
            cfgNameLabel.Font = Enum.Font.GothamBold
            cfgNameLabel.TextXAlignment = Enum.TextXAlignment.Left
            cfgNameLabel.Parent = cfgFrame
            
            if autoLoadName == cfgName then
                local autoBadge = Instance.new("TextLabel")
                autoBadge.Size = UDim2.new(0, 50, 0, 16)
                autoBadge.Position = UDim2.new(0.4, 10, 0, 8)
                autoBadge.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
                autoBadge.Text = "AUTO"
                autoBadge.TextColor3 = Color3.fromRGB(255, 255, 255)
                autoBadge.TextSize = 9
                autoBadge.Font = Enum.Font.GothamBold
                autoBadge.Parent = cfgFrame
                local badgeCorner = Instance.new("UICorner")
                badgeCorner.CornerRadius = UDim.new(0, 4)
                badgeCorner.Parent = autoBadge
            end
            
            local loadCfgBtn = Instance.new("TextButton")
            loadCfgBtn.Size = UDim2.new(0, 60, 0, 30)
            loadCfgBtn.Position = UDim2.new(0.5, -95, 0, 10)
            loadCfgBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
            loadCfgBtn.Text = "📂 TẢI"
            loadCfgBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            loadCfgBtn.TextSize = 10
            loadCfgBtn.Font = Enum.Font.GothamBold
            loadCfgBtn.Parent = cfgFrame
            local loadCorner = Instance.new("UICorner")
            loadCorner.CornerRadius = UDim.new(0, 5)
            loadCorner.Parent = loadCfgBtn
            
            local autoLoadBtn = Instance.new("TextButton")
            autoLoadBtn.Size = UDim2.new(0, 75, 0, 30)
            autoLoadBtn.Position = UDim2.new(0.5, -25, 0, 10)
            autoLoadBtn.BackgroundColor3 = (autoLoadName == cfgName) and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(60, 60, 85)
            autoLoadBtn.Text = (autoLoadName == cfgName) and "✅ AUTO" or "⭐ AUTO"
            autoLoadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            autoLoadBtn.TextSize = 9
            autoLoadBtn.Font = Enum.Font.GothamBold
            autoLoadBtn.Parent = cfgFrame
            local autoCorner = Instance.new("UICorner")
            autoCorner.CornerRadius = UDim.new(0, 5)
            autoCorner.Parent = autoLoadBtn
            
            local delCfgBtn = Instance.new("TextButton")
            delCfgBtn.Size = UDim2.new(0, 50, 0, 30)
            delCfgBtn.Position = UDim2.new(1, -60, 0, 10)
            delCfgBtn.BackgroundColor3 = Color3.fromRGB(100, 40, 40)
            delCfgBtn.Text = "🗑️"
            delCfgBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            delCfgBtn.TextSize = 11
            delCfgBtn.Font = Enum.Font.GothamBold
            delCfgBtn.Parent = cfgFrame
            local delCorner = Instance.new("UICorner")
            delCorner.CornerRadius = UDim.new(0, 5)
            delCorner.Parent = delCfgBtn
            
            loadCfgBtn.MouseButton1Click:Connect(function()
                playClickSound()
                local success, msg = loadConfig(cfgName)
                if success then
                    pcall(updateAFKStatus)
                    refreshPlayersList()
                    refreshInfoPanel()
                    refreshSkinPanel()
                    if refreshAllSettingsUI then
                        pcall(refreshAllSettingsUI)
                    end
                end
                local notif = Drawing.new("Text")
                notif.Text = msg
                notif.Size = 12
                notif.Color = success and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                notif.Center = true
                notif.Outline = true
                notif.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - 100)
                notif.Visible = true
                task.wait(1.5)
                notif.Visible = false
                notif:Remove()
            end)
            
            autoLoadBtn.MouseButton1Click:Connect(function()
                playClickSound()
                local success = saveAutoLoadConfig(cfgName)
                if success then
                    autoLoadStatus.Text = "📌 " .. cfgName
                    autoLoadStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
                    updateConfigList()
                    local notif = Drawing.new("Text")
                    notif.Text = "✅ Auto-load: " .. cfgName
                    notif.Size = 12
                    notif.Color = Color3.fromRGB(0, 255, 0)
                    notif.Center = true
                    notif.Outline = true
                    notif.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - 100)
                    notif.Visible = true
                    task.wait(1.5)
                    notif.Visible = false
                    notif:Remove()
                end
            end)
            
            delCfgBtn.MouseButton1Click:Connect(function()
                playClickSound()
                local success = deleteConfig(cfgName)
                if success then
                    if autoLoadName == cfgName then
                        clearAutoLoadConfig()
                        autoLoadStatus.Text = "📌 Chưa cài"
                        autoLoadStatus.TextColor3 = Color3.fromRGB(255, 200, 100)
                    end
                    updateConfigList()
                end
            end)
            
            scrollY = scrollY + 58
        end
        
        configListScrolling.CanvasSize = UDim2.new(0, 0, 0, math.max(scrollY, 200))
    end
    
    refreshBtn.MouseButton1Click:Connect(function()
        playClickSound()
        updateConfigList()
    end)
    
    createConfigBtn.MouseButton1Click:Connect(function()
        playClickSound()
        local configName = configNameInput.Text
        if configName == "" then
            configName = "config_" .. os.time()
        end
        
        ensureConfigFolder()
        
        local success, msg = pcall(saveConfig, configName)
        if not success then
            msg = "❌ Lỗi: " .. tostring(msg)
        end
        
        local notif = Drawing.new("Text")
        notif.Text = msg
        notif.Size = 12
        notif.Color = success and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        notif.Center = true
        notif.Outline = true
        notif.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - 100)
        notif.Visible = true
        
        if success then
            configNameInput.Text = ""
            pcall(updateConfigList)
        end
        
        task.wait(1.5)
        notif.Visible = false
        notif:Remove()
    end)
    
    updateConfigList()
end

-- ============ UPDATE LOCK STATS UI ==========
local function updateLockStatsUI()
    -- Cập nhật Level
    if levelValue and levelValue.Parent then
        levelValue.Text = tostring(settings.lockStats.level)
        local percent = math.clamp(settings.lockStats.level / 10000000000, 0, 1)
        if levelSliderFill then
            levelSliderFill.Size = UDim2.new(percent, 0, 1, 0)
        end
        if levelHandle then
            levelHandle.Position = UDim2.new(percent, -8, 0.5, -8)
        end
    end
    
    -- Cập nhật Streak
    if streakValue and streakValue.Parent then
        streakValue.Text = tostring(settings.lockStats.streak)
        local percent = math.clamp(settings.lockStats.streak / 10000000000, 0, 1)
        if streakSliderFill then
            streakSliderFill.Size = UDim2.new(percent, 0, 1, 0)
        end
        if streakHandle then
            streakHandle.Position = UDim2.new(percent, -8, 0.5, -8)
        end
    end
    
    -- Cập nhật ELO
    if eloValue and eloValue.Parent then
        eloValue.Text = tostring(settings.lockStats.elo)
        local percent = math.clamp(settings.lockStats.elo / 10000000000, 0, 1)
        if eloSliderFill then
            eloSliderFill.Size = UDim2.new(percent, 0, 1, 0)
        end
        if eloHandle then
            eloHandle.Position = UDim2.new(percent, -8, 0.5, -8)
        end    end
    
    -- Cập nhật Lock Status
    if lockStatusLabel and lockStatusLabel.Parent then
        lockStatusLabel.Text = settings.lockStats.enabled and "✅ ĐANG KHÓA" or "❌ ĐÃ TẮT"
        lockStatusLabel.TextColor3 = settings.lockStats.enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100)
    end
    
    -- Cập nhật tên
    if nameInput and nameInput.Parent then
        nameInput.Text = settings.lockStats.customName or ""
    end
end

-- ============ REFRESH ALL SETTINGS UI ==========
local function refreshAllSettingsUI()
    -- Cập nhật Lock Stats
    if updateLockStatsUI then
        pcall(updateLockStatsUI)
    end
    
    -- Cập nhật AFK status
    if updateAFKStatus then
        pcall(updateAFKStatus)
    end
    
    -- Cập nhật AIMBOT mode
    if modeBtn and modeBtn.Parent then
        if settings.aimbot.aimPlayers and settings.aimbot.aimNPC then
            modeBtn.Text = "Both"
        elseif settings.aimbot.aimPlayers then
            modeBtn.Text = "Players"
        elseif settings.aimbot.aimNPC then
            modeBtn.Text = "NPCs"
        end
    end
    
    -- Cập nhật Silent Aim mode
    if silentModeBtn and silentModeBtn.Parent then
        silentModeBtn.Text = settings.silentAim.mode or "Both"
    end
    
    if partBtn and partBtn.Parent then
        partBtn.Text = settings.silentAim.aimPart or "Head"
    end
    
    -- Cập nhật Xuyên Tường
    if xuyenToggleBtn and xuyenToggleBtn.Parent then
        if updateXuyenToggle then
            pcall(updateXuyenToggle)
        end
    end
    
    -- Refresh panels
    if refreshPlayersList then pcall(refreshPlayersList) end
    if refreshInfoPanel then pcall(refreshInfoPanel) end
    if refreshSkinPanel then pcall(refreshSkinPanel) end
    if refreshAdminPanel then pcall(refreshAdminPanel) end
    if refreshConfigList then pcall(refreshConfigList) end
end

-- ============ KHỞI TẠO UI ==========
refreshConfigList()
refreshInfoPanel()
refreshAdminPanel()
refreshSkinPanel()
checkAdminOnline()

-- Tự động refresh UI sau khi load config
task.spawn(function()
    task.wait(0.1)
    if updateLockStatsUI then pcall(updateLockStatsUI) end
    task.wait(0.2)
    if updateLockStatsUI then pcall(updateLockStatsUI) end
    task.wait(0.3)
    if refreshAllSettingsUI then pcall(refreshAllSettingsUI) end
    task.wait(0.5)
    if updateLockStatsUI then pcall(updateLockStatsUI) end
end)

Players.PlayerAdded:Connect(function()
    checkAdminOnline()
    refreshAdminPanel()
end)
Players.PlayerRemoving:Connect(function()
    checkAdminOnline()
    refreshAdminPanel()
end)

local panels = {aimbotPanel, silentAimPanel, espPanel, skeletonPanel, skinPanel, lockStatsPanel, devicePanel, tpPanel, afkPanel, playersPanel, infoPanel, adminPanel, configPanel}
local function switchTab(tabIndex)
    for _, p in pairs(panels) do
        if p then p.Visible = false end
    end
    panels[tabIndex].Visible = true
    
    for i, btn in ipairs(tabButtons) do
        local isActive = (i == tabIndex)
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundTransparency = isActive and 0.1 or 0.5,
            TextColor3 = isActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 220)
        }):Play()
        
        local glow = btn:FindFirstChildOfClass("Frame")
        if glow then
            TweenService:Create(glow, TweenInfo.new(0.15), {BackgroundTransparency = isActive and 0.5 or 1}):Play()
        end
        
        activeTab = tabIndex
    end
    
    if tabIndex == 9 then pcall(updateAFKStatus) end
    if tabIndex == 10 then refreshPlayersList() end
    if tabIndex == 11 then refreshInfoPanel() end
    if tabIndex == 12 then 
        checkAdminOnline()
        refreshAdminPanel() 
    end
    if tabIndex == 13 then refreshConfigList() end
    if tabIndex == 5 then refreshSkinPanel() end
end

for i, btn in ipairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        playClickSound()
        switchTab(i)
    end)
end

switchTab(1)

local menuVisible = false
local function openMenu()
    menuVisible = true
    menu.Visible = true
    overlay.Visible = true
    TweenService:Create(overlay, TweenInfo.new(0.3), {BackgroundTransparency = 0.5}):Play()
    menu.Size = UDim2.new(0, 0, 0, 0)
    menu.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(menu, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0,1100, 0, 720),
        Position = UDim2.new(0.5, -550, 0.5, -360)
    }):Play()
    TweenService:Create(blur, TweenInfo.new(0.3), {Size = 12}):Play()
end

local function closeMenu()
    cleanupAllESP()
    aimLine.Visible = false
    TweenService:Create(menu, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    TweenService:Create(overlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    TweenService:Create(blur, TweenInfo.new(0.2), {Size = 0}):Play()
    task.wait(0.2)
    menu.Visible = false
    overlay.Visible = false
    menuVisible = false
end

closeBtn.MouseButton1Click:Connect(function()
    playClickSound()
    closeMenu()
end)

local dragStart, menuStart, isDragging = nil, nil, false
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStart = input.Position
        menuStart = menu.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        menu.Position = UDim2.new(menuStart.X.Scale, menuStart.X.Offset + delta.X, menuStart.Y.Scale, menuStart.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = false end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        playClickSound()
        if menuVisible then closeMenu() else openMenu() end
    end
end)

local successNotif = Drawing.new("Text")
successNotif.Text = "✅ Welcome " .. playerName .. "!"
successNotif.Size = 16
successNotif.Color = Color3.fromRGB(0, 255, 0)
successNotif.Center = true
successNotif.Outline = true
successNotif.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - 60)
successNotif.Visible = true

local subNotif = Drawing.new("Text")
subNotif.Text = "Key: " .. currentKey
subNotif.Size = 11
subNotif.Color = Color3.fromRGB(0, 200, 255)
subNotif.Center = true
subNotif.Outline = true
subNotif.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - 40)
subNotif.Visible = true

local deviceNotif = Drawing.new("Text")
deviceNotif.Text = "⚡ Aimbot | 🤫 Silent Aim | 🎮 Device Spoof | 💤 AFK | 👥 Team | 🎨 Skin | 🔒 Lock Stats | ✏️ Name Changer | ⚠️ Teleport Anti-Spam | 🧱 Xuyen Tuong (DE BAN)"
deviceNotif.Size = 10
deviceNotif.Color = Color3.fromRGB(200, 200, 100)
deviceNotif.Center = true
deviceNotif.Outline = true
deviceNotif.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - 20)
deviceNotif.Visible = true

task.wait(3)
successNotif.Visible = false
subNotif.Visible = false
deviceNotif.Visible = false
successNotif:Remove()
subNotif:Remove()
deviceNotif:Remove()

print("========================================")
print("     ✦ KHANHGD CHEAT v19.0 ✦")
print("========================================")
print("  KEY: " .. currentKey)
print("  Player: " .. playerName)
print("  Device: " .. currentDevice)
print("========================================")
print("  RIGHT SHIFT = MENU")
print("  RIGHT CLICK = AIMBOT (di chuyen chuot)")
print("  🤫 SILENT AIM = Khong anh huong goc nhin")
print("  X = TELEPORT (CO CHE CHONG SPAM)")
print("========================================")
print("  FIXED: Silent Aim (khong anh huong goc nhin)")
print("  FIXED: Van giu aim chuot khi Silent Aim OFF")
print("  FIXED: Co the bat/tat Silent Aim tuy y")
print("========================================")
local autoCfg = getAutoLoadConfig()
if autoCfg then
    print("  AUTO-LOAD: " .. autoCfg)
else
    print("  AUTO-LOAD: NONE")
end
print("========================================")
end

if isKeyValidated then
    loadMainMenu()
end

updateAFK()

print("✅ Silent Aim da duoc them! Khi bat len khong anh huong goc nhin, van nhin quanh duoc!")
print("✅ Khi tat di, aim chuot van hoat dong binh thuong!")
print("✅ Tab SILENT AIM trong menu de dieu khien")
