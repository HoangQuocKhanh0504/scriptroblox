-- ESP + SKELETON + AIMBOT + SET VALUE + KEY SYSTEM + DEVICE SPOOFER + CONFIG SYSTEM
-- ULTRA MODERN MENU WITH EFFECTS - FULL ROUNDED CORNERS
-- FIXED: Line luôn hiện, Auto shot bắn NGAY LẬP TỨC khi tâm chạm đầu

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInput = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- ============ CONFIG SYSTEM SETUP ==========
local ConfigFolder = "KhanhGD_Configs"

-- ============ DEVICE SPOOFER SETUP ==========
local SetControlsRemote = nil
pcall(function()
    SetControlsRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Replication"):WaitForChild("Fighter"):WaitForChild("SetControls")
end)

local function spoofDevice(wantedDevice)
    if not SetControlsRemote then
        warn("SetControls remote not found!")
        return
    end
    pcall(function()
        SetControlsRemote:FireServer("MouseKeyboard")
        task.wait(0.3)
        SetControlsRemote:FireServer(wantedDevice)
    end)
end

-- ============ ÂM THANH NHẸ ==========
local function playClickSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://9120386436"
    sound.Volume = 0.3
    sound.Parent = game:GetService("CoreGui")
    sound:Play()
    task.wait(0.2)
    sound:Destroy()
end

-- ============ KEY SYSTEM ==========
local playerName = LocalPlayer.Name
local isKeyValidated = false
local currentKey = ""

local validKeysList = {
    "ABCD1-EFGH2-IJKL3-MNOP4", "QRST5-UVWX6-YZAB7-CDEF8", "GHIJ9-KLMN0-OPQR1-STUV2",
    "WXYZ3-ABCD4-EFGH5-IJKL6", "MNOP7-QRST8-UVWX9-YZAB0", "KHANH-PC01-AAAAA-11111",
    "KHANH-PC02-BBBBB-22222", "KHANH-PC03-CCCCC-33333", "KHANH-PC04-DDDDD-44444",
    "KHANH-PC05-EEEEE-55555", "VIPPRO-9999-XXXXX-77777", "PREMIUM-8888-YYYYY-88888",
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
        return false, "Please enter a key!"
    end
    local normalizedKey = string.upper(string.gsub(inputKey, "%s+", ""))
    if validKeys[normalizedKey] then
        return true, "Key verified successfully!"
    end
    return false, "Invalid key! Please check and try again."
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
keyTitle.Text = "🔐 KEY VERIFICATION"
keyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
keyTitle.TextSize = 22
keyTitle.Font = Enum.Font.GothamBold
keyTitle.TextXAlignment = Enum.TextXAlignment.Center
keyTitle.Parent = keyFrame

local keySubtitle = Instance.new("TextLabel")
keySubtitle.Size = UDim2.new(1, -40, 0, 30)
keySubtitle.Position = UDim2.new(0, 20, 0, 85)
keySubtitle.BackgroundTransparency = 1
keySubtitle.Text = "Enter your license key to continue"
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
statusLabel.Text = "Waiting for key..."
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
submitBtn.Text = "VERIFY KEY"
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
getKeyBtn.Text = "🔑 GET KEY"
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
        notifText.Text = "✅ LINK COPIED!\n\n" .. keyLink
        statusLabel.Text = "✅ Link copied! Open browser and paste"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        notifText.Text = "❌ Cannot copy automatically!\n\nPlease copy manually:\n" .. keyLink
        statusLabel.Text = "❌ Please copy link manually: " .. keyLink
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    end
    
    task.wait(3)
    notifFrame:Destroy()
    task.wait(2)
    if statusLabel.Text ~= "Waiting for key..." then
        statusLabel.Text = "Waiting for key..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    end
end)

local savedKey = getSavedKey()
if savedKey then
    local isValid, msg = validateKey(savedKey)
    if isValid then
        statusLabel.Text = "Auto-verified! Loading menu..."
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        task.wait(1)
        onKeyValidated(savedKey)
        keyScreenGui:Destroy()
        loadMainMenu()
    else
        statusLabel.Text = "Saved key invalid! Please re-enter."
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end

submitBtn.MouseButton1Click:Connect(function()
    local key = keyInput.Text
    if key == "" then
        statusLabel.Text = "Please enter a key!"
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
    
    statusLabel.Text = "Verifying key..."
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

-- ============ MAIN MENU ==========
function loadMainMenu()
-- THÔNG SỐ
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
        smoothness = 2,
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
        lineColorB = 0
    },
    teleport = {
        enabled = true
    }
}

-- ============ CONFIG SYSTEM FUNCTIONS ==========
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
        settings = settings
    }
    
    local jsonData = HttpService:JSONEncode(configData)
    local success = pcall(function()
        if writefile then
            writefile(ConfigFolder .. "/" .. configName .. ".json", jsonData)
            return true
        end
        return false
    end)
    
    if success then
        return true, "✅ Saved: " .. configName
    end
    return false, "❌ Cannot save"
end

local function loadConfig(configName)
    if not configName or configName == "" then return false, "Invalid name" end
    
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
            return true, "✅ Loaded: " .. configName
        end
    end
    return false, "❌ Config not found"
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

local function clearAutoLoadConfig()
    pcall(function()
        if delfile then
            delfile(ConfigFolder .. "/auto_load_config.txt")
        end
    end)
end

local function autoLoadConfigOnStart()
    ensureConfigFolder()
    local autoLoadName = getAutoLoadConfig()
    if autoLoadName and autoLoadName ~= "" then
        local success, msg = loadConfig(autoLoadName)
        if success then
            return true, "🔧 Auto loaded: " .. autoLoadName
        end
    end
    return false, "No auto-load config set"
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

-- TELEPORT
local function teleportToPosition(position)
    local character = LocalPlayer.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
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
        if targetPos then teleportToPosition(targetPos) end
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

-- LINE TỪ TÂM ĐẾN ĐẦU ĐỊCH (LUÔN HIỆN)
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
    
    if settings.aimbot.aimMode == "Players" or settings.aimbot.aimMode == "Both" then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local char = player.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local targetPart = char:FindFirstChild(settings.aimbot.aimPart)
                    if hum and hum.Health > 0 and targetPart then
                        local distance = (myRoot.Position - targetPart.Position).Magnitude
                        if distance <= settings.aimbot.maxDistance then
                            table.insert(targets, {type = "Player", name = player.Name, part = targetPart, character = char, distance = distance})
                        end
                    end
                end
            end
        end
    end
    
    if settings.aimbot.aimMode == "NPCs" or settings.aimbot.aimMode == "Both" then
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
    end
    return targets
end

-- WALL CHECK
local function canSeeTarget(targetPart)
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

-- BẮN (NHANH, KHÔNG DELAY)
local lastShotTime = 0
local SHOT_DELAY = 0.03 -- Giảm còn 30ms để bắn nhanh hơn

local function shoot()
    local currentTime = tick()
    if currentTime - lastShotTime < SHOT_DELAY then return end
    lastShotTime = currentTime
    
    if mouse1click then
        mouse1click()
    else
        VirtualInput:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, Enum.UserInputState.Begin, nil, false)
        task.wait(0.005)
        VirtualInput:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, Enum.UserInputState.End, nil, false)
    end
end

-- TÌM TARGET TỐT NHẤT TRONG FOV
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

-- DI CHUYỂN CHUỘT ĐẾN TARGET
local function moveToTarget(targetData)
    if not targetData or not targetData.part then return false end
    local targetPos, onScreen = Camera:WorldToViewportPoint(targetData.part.Position)
    if not onScreen then return false end
    local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local delta = Vector2.new(targetPos.X, targetPos.Y) - centerScreen
    -- GIẢM NGƯỠNG TỪ 3 XUỐNG 2 PIXEL ĐỂ BẮN NHANH HƠN
    if delta.Magnitude < 2 then return true end
    local moveX = delta.X / settings.aimbot.smoothness
    local moveY = delta.Y / settings.aimbot.smoothness
    moveX = math.clamp(moveX, -20, 20)
    moveY = math.clamp(moveY, -20, 20)
    if mousemoverel then
        mousemoverel(moveX, moveY)
    elseif syn and syn.mouse_move then
        syn.mouse_move(moveX, moveY)
    else
        local mouse = LocalPlayer:GetMouse()
        VirtualInput:SendMouseMoveEvent(mouse.X + moveX, mouse.Y + moveY)
    end
    return delta.Magnitude < 2
end

local isAiming = false
local lockedTarget = nil
local isTargetLocked = false

local function isTargetAlive(targetData)
    if not targetData or not targetData.character then return false end
    local hum = targetData.character:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health and hum.Health > 0
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 and settings.aimbot.enabled then 
        isAiming = true 
        isTargetLocked = false
    end
end)

UserInputService.InputEnded:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then 
        isAiming = false
        lockedTarget = nil
        isTargetLocked = false
    end
end)

-- ============ RENDER STEP CHÍNH (LINE LUÔN HIỆN + AUTO SHOT NHANH) ==========
RunService.RenderStepped:Connect(function()
    local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local bestTarget = getBestTarget()
    
    -- LINE LUÔN HIỆN (KHI CÓ TARGET TRONG FOV)
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
    
    -- AIMBOT + AUTO SHOT (CHỈ KHI GIỮ CHUỘT PHẢI)
    if not (settings.aimbot.enabled and isAiming) then 
        lockedTarget = nil
        isTargetLocked = false
        return 
    end
    
    if lockedTarget and not isTargetAlive(lockedTarget) then
        lockedTarget = nil
        isTargetLocked = false
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
        -- Kiểm tra xem tâm đã chạm đầu chưa
        local targetPos, onScreen = Camera:WorldToViewportPoint(targetData.part.Position)
        local isOnTarget = false
        if onScreen then
            local delta = (Vector2.new(targetPos.X, targetPos.Y) - centerScreen).Magnitude
            isOnTarget = delta < 2 -- Tâm đã chạm đầu
        end
        
        -- Di chuyển chuột đến target
        moveToTarget(targetData)
        
        -- AUTO SHOT: BẮN NGAY LẬP TỨC KHI TÂM CHẠM ĐẦU VÀ THẤY NGƯỜI
        if settings.aimbot.autoShot and isOnTarget then
            if canSeeTarget(targetData.part) then
                shoot()
            end
        end
    end
end)

-- UPDATE FOV CIRCLE
RunService.RenderStepped:Connect(function()
    if settings.aimbot.enabled and isAiming then
        local pulseValue = (math.sin(tick() * 10) + 1) / 2
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

-- ESP + SKELETON (giữ nguyên từ code cũ)
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
        line.Color = isNPC and settings.esp.npcColor or settings.esp.boxColor
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
local RENDER_INTERVAL = 1/30

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
        if not data.isNPC then
            char = target.Character
            root = char and char:FindFirstChild("HumanoidRootPart")
            hum = char and char:FindFirstChildOfClass("Humanoid")
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
                    data.box[1].From = Vector2.new(minX, minY); data.box[1].To = Vector2.new(maxX, minY)
                    data.box[2].From = Vector2.new(maxX, minY); data.box[2].To = Vector2.new(maxX, maxY)
                    data.box[3].From = Vector2.new(maxX, maxY); data.box[3].To = Vector2.new(minX, maxY)
                    data.box[4].From = Vector2.new(minX, maxY); data.box[4].To = Vector2.new(minX, minY)
                    for _, l in pairs(data.box) do 
                        l.Color = data.isNPC and settings.esp.npcColor or settings.esp.boxColor
                        l.Visible = true 
                    end
                else for _, l in pairs(data.box) do l.Visible = false end end
                if settings.esp.skeleton and not data.isNPC and char then
                    local parts = getSkeletonParts(char)
                    drawSkeleton(espSkeletons[target], parts, settings.esp.skeletonColor)
                elseif espSkeletons[target] then 
                    for _, l in pairs(espSkeletons[target]) do l.Visible = false end 
                end
                local text = data.text
                if text then
                    local str = ""
                    if settings.esp.name then str = target.Name end
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

-- SET VALUE
local function setWinStreak(value)
    local customStats = LocalPlayer:FindFirstChild("CustomLeaderstats")
    if customStats then
        local winStreak = customStats:FindFirstChild("Win Streak")
        if winStreak then winStreak.Value = value; return true end
    end
    return false
end

local function getCurrentWinStreak()
    local customStats = LocalPlayer:FindFirstChild("CustomLeaderstats")
    if customStats then
        local winStreak = customStats:FindFirstChild("Win Streak")
        if winStreak then return winStreak.Value end
    end
    return 0
end

local function refreshLocalPlayerUI()
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        for _, stat in pairs(leaderstats:GetChildren()) do
            if stat:IsA("NumberValue") or stat:IsA("IntValue") then
                local oldValue = stat.Value
                stat.Value = oldValue + 1
                task.wait(0.05)
                stat.Value = oldValue
            end
        end
    end
    local customStats = LocalPlayer:FindFirstChild("CustomLeaderstats")
    if customStats then
        for _, stat in pairs(customStats:GetChildren()) do
            if stat:IsA("NumberValue") or stat:IsA("IntValue") then
                local oldValue = stat.Value
                stat.Value = oldValue + 1
                task.wait(0.05)
                stat.Value = oldValue
            end
        end
    end
end

-- ============ MENU CHÍNH (RÚT GỌN) ==========
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
menu.Size = UDim2.new(0, 580, 0, 800)
menu.Position = UDim2.new(0.5, -290, 0.5, -400)
menu.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
menu.BackgroundTransparency = 0.08
menu.BorderSizePixel = 0
menu.Visible = false
menu.ClipsDescendants = true
menu.Parent = screenGui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 20)
menuCorner.Parent = menu

local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 0, 1, 0)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.6
shadow.BorderSizePixel = 0
shadow.ZIndex = -1
shadow.Parent = menu

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 20)
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
glassCorner.CornerRadius = UDim.new(0, 20)
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
borderCorner.CornerRadius = UDim.new(0, 22)
borderCorner.Parent = borderGradient

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 80)
header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
header.BackgroundTransparency = 0.4
header.BorderSizePixel = 0
header.Parent = menu

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 20)
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
title.Size = UDim2.new(1, -100, 0, 40)
title.Position = UDim2.new(0, 20, 0, 15)
title.BackgroundTransparency = 1
title.Text = "✦ KHANHGD CHEAT ✦"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextYAlignment = Enum.TextYAlignment.Center
title.Parent = header

local subTitle = Instance.new("TextLabel")
subTitle.Size = UDim2.new(1, -100, 0, 20)
subTitle.Position = UDim2.new(0, 22, 0, 52)
subTitle.BackgroundTransparency = 1
subTitle.Text = "ESP • SKELETON • AIMBOT • LINE AIM (ALWAYS) • AUTO SHOT • VALUE • DEVICE • TP • CONFIG"
subTitle.TextColor3 = Color3.fromRGB(150, 200, 255)
subTitle.TextSize = 11
subTitle.Font = Enum.Font.Gotham
subTitle.TextXAlignment = Enum.TextXAlignment.Left
subTitle.TextYAlignment = Enum.TextYAlignment.Center
subTitle.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 42, 0, 42)
closeBtn.Position = UDim2.new(1, -56, 0, 19)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
closeBtn.BackgroundTransparency = 0.5
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextSize = 20
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

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 55)
tabBar.Position = UDim2.new(0, 0, 0, 80)
tabBar.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
tabBar.BackgroundTransparency = 0.3
tabBar.BorderSizePixel = 0
tabBar.Parent = menu

local tabs = {}
local tabNames = {"🎯 AIM", "🎨 ESP", "🦴 BONE", "⚡ VALUE", "🎮 DEVICE", "🌀 TP", "⚙️ CONFIG"}
local tabWidth = 580 / #tabNames

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, tabWidth, 1, 0)
    btn.Position = UDim2.new(0, (i-1) * tabWidth, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(160, 160, 200)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamSemibold
    btn.AutoButtonColor = false
    btn.Parent = tabBar
    tabs[i] = btn
    btn.MouseEnter:Connect(function()
        if btn.TextColor3 ~= Color3.fromRGB(255, 255, 255) then
            TweenService:Create(btn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(220, 220, 255)}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if btn.TextColor3 ~= Color3.fromRGB(255, 255, 255) then
            TweenService:Create(btn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(160, 160, 200)}):Play()
        end
    end)
end

local indicator = Instance.new("Frame")
indicator.Size = UDim2.new(0, tabWidth, 0, 3)
indicator.Position = UDim2.new(0, 0, 1, -3)
indicator.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
indicator.BorderSizePixel = 0
indicator.Parent = tabs[1]

local indicatorCorner = Instance.new("UICorner")
indicatorCorner.CornerRadius = UDim.new(0, 3)
indicatorCorner.Parent = indicator

local particle = Instance.new("Frame")
particle.Size = UDim2.new(0, 4, 0, 4)
particle.Position = UDim2.new(0, -2, 0.5, -2)
particle.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
particle.BackgroundTransparency = 0.5
particle.BorderSizePixel = 0
particle.Parent = indicator

local particleCorner = Instance.new("UICorner")
particleCorner.CornerRadius = UDim.new(1, 0)
particleCorner.Parent = particle

local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -40, 1, -165)
contentArea.Position = UDim2.new(0, 20, 0, 145)
contentArea.BackgroundTransparency = 1
contentArea.Parent = menu

-- Panels
local aimbotPanel = Instance.new("ScrollingFrame")
aimbotPanel.Size = UDim2.new(1, 0, 1, 0)
aimbotPanel.BackgroundTransparency = 1
aimbotPanel.BorderSizePixel = 0
aimbotPanel.CanvasSize = UDim2.new(0, 0, 0, 850)
aimbotPanel.ScrollBarThickness = 4
aimbotPanel.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 200)
aimbotPanel.Parent = contentArea

local espPanel = Instance.new("ScrollingFrame")
espPanel.Size = UDim2.new(1, 0, 1, 0)
espPanel.BackgroundTransparency = 1
espPanel.BorderSizePixel = 0
espPanel.CanvasSize = UDim2.new(0, 0, 0, 950)
espPanel.ScrollBarThickness = 4
espPanel.Parent = contentArea
espPanel.Visible = false

local skeletonPanel = Instance.new("ScrollingFrame")
skeletonPanel.Size = UDim2.new(1, 0, 1, 0)
skeletonPanel.BackgroundTransparency = 1
skeletonPanel.BorderSizePixel = 0
skeletonPanel.CanvasSize = UDim2.new(0, 0, 0, 220)
skeletonPanel.ScrollBarThickness = 4
skeletonPanel.Parent = contentArea
skeletonPanel.Visible = false

local setValuePanel = Instance.new("ScrollingFrame")
setValuePanel.Size = UDim2.new(1, 0, 1, 0)
setValuePanel.BackgroundTransparency = 1
setValuePanel.BorderSizePixel = 0
setValuePanel.CanvasSize = UDim2.new(0, 0, 0, 350)
setValuePanel.ScrollBarThickness = 4
setValuePanel.Parent = contentArea
setValuePanel.Visible = false

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
tpPanel.CanvasSize = UDim2.new(0, 0, 0, 200)
tpPanel.ScrollBarThickness = 4
tpPanel.Parent = contentArea
tpPanel.Visible = false

local configPanel = Instance.new("ScrollingFrame")
configPanel.Size = UDim2.new(1, 0, 1, 0)
configPanel.BackgroundTransparency = 1
configPanel.BorderSizePixel = 0
configPanel.CanvasSize = UDim2.new(0, 0, 0, 700)
configPanel.ScrollBarThickness = 4
configPanel.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 200)
configPanel.Parent = contentArea
configPanel.Visible = false

-- Helper Functions
local function createModernToggle(parent, y, name, getValue, setValue)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 52)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 0
    frame.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 0, 25)
    label.Position = UDim2.new(0, 15, 0, 14)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(230, 230, 255)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 80, 0, 32)
    toggleBtn.Position = UDim2.new(1, -95, 0, 10)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = getValue() and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 12
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = frame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
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
    frame.Size = UDim2.new(1, -10, 0, 72)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 0
    frame.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 180, 0, 25)
    label.Position = UDim2.new(0, 15, 0, 10)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(230, 230, 255)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 70, 0, 25)
    valueLabel.Position = UDim2.new(1, -85, 0, 10)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultValue) .. suffix
    valueLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    valueLabel.TextSize = 13
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Parent = frame
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -200, 0, 6)
    sliderBg.Position = UDim2.new(0, 190, 0, 48)
    sliderBg.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(0, 3)
    sliderBgCorner.Parent = sliderBg
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultValue - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = sliderFill
    local handle = Instance.new("TextButton")
    handle.Size = UDim2.new(0, 20, 0, 20)
    handle.Position = UDim2.new((defaultValue - minVal) / (maxVal - minVal), -10, 0.5, -10)
    handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    handle.BorderSizePixel = 0
    handle.Text = ""
    handle.Parent = sliderBg
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(0, 10)
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
            handle.Position = UDim2.new(percent, -10, 0.5, -10)
            callback(value)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    return frame
end

-- COLOR PICKER
local function createColorPicker(parent, y, name, getR, getG, getB, setR, setG, setB, updateColor)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 130)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, -10, 0, 25)
    label.Position = UDim2.new(0, 10, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(230, 230, 255)
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local preview = Instance.new("Frame")
    preview.Size = UDim2.new(0, 50, 0, 50)
    preview.Position = UDim2.new(1, -60, 0, 8)
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
        sliderLabel.Size = UDim2.new(0, 30, 0, 20)
        sliderLabel.Position = UDim2.new(0, 0, 0, 0)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = labelText
        sliderLabel.TextColor3 = color
        sliderLabel.TextSize = 12
        sliderLabel.Font = Enum.Font.GothamBold
        sliderLabel.Parent = sliderFrame
        
        local valueText = Instance.new("TextLabel")
        valueText.Size = UDim2.new(0, 40, 0, 20)
        valueText.Position = UDim2.new(1, -40, 0, 0)
        valueText.BackgroundTransparency = 1
        valueText.Text = tostring(getVal())
        valueText.TextColor3 = color
        valueText.TextSize = 11
        valueText.Font = Enum.Font.Gotham
        valueText.TextXAlignment = Enum.TextXAlignment.Right
        valueText.Parent = sliderFrame
        
        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(1, -80, 0, 6)
        sliderBg.Position = UDim2.new(0, 35, 0, 18)
        sliderBg.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        sliderBg.BorderSizePixel = 0
        sliderBg.Parent = sliderFrame
        local sliderBgCorner = Instance.new("UICorner")
        sliderBgCorner.CornerRadius = UDim.new(0, 3)
        sliderBgCorner.Parent = sliderBg
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new((getVal() - minVal) / (maxVal - minVal), 0, 1, 0)
        sliderFill.BackgroundColor3 = color
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBg
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 3)
        fillCorner.Parent = sliderFill
        
        local handle = Instance.new("TextButton")
        handle.Size = UDim2.new(0, 16, 0, 16)
        handle.Position = UDim2.new((getVal() - minVal) / (maxVal - minVal), -8, 0.5, -8)
        handle.BackgroundColor3 = color
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
                setVal(value)
                valueText.Text = tostring(value)
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                handle.Position = UDim2.new(percent, -8, 0.5, -8)
                preview.BackgroundColor3 = Color3.fromRGB(getR(), getG(), getB())
                updateColor()
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        
        return sliderFrame
    end
    
    createSlider(frame, 10, 45, 200, 40, "R", 0, 255, getR, setR, Color3.fromRGB(255, 80, 80))
    createSlider(frame, 10, 75, 200, 40, "G", 0, 255, getG, setG, Color3.fromRGB(80, 255, 80))
    createSlider(frame, 10, 105, 200, 40, "B", 0, 255, getB, setB, Color3.fromRGB(80, 80, 255))
    
    return frame
end

local function createDeviceButton(parent, y, name, deviceValue, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = color or Color3.fromRGB(45, 45, 65)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
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
        notif.Text = "✅ Switched to " .. name
        notif.Size = 14
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

-- ============ BUILD UI ==========

-- AIMBOT PANEL
local y = 10
createModernToggle(aimbotPanel, y, "⚡ ENABLE AIMBOT", function() return settings.aimbot.enabled end, function(v) settings.aimbot.enabled = v end)
y = y + 60

-- AIM MODE
local frame = Instance.new("Frame")
frame.Size = UDim2.new(1, -10, 0, 52)
frame.Position = UDim2.new(0, 5, 0, y)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
frame.BackgroundTransparency = 0.4
frame.BorderSizePixel = 0
frame.Parent = aimbotPanel
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame
local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 180, 0, 25)
label.Position = UDim2.new(0, 15, 0, 14)
label.BackgroundTransparency = 1
label.Text = "🎯 AIM MODE"
label.TextColor3 = Color3.fromRGB(230, 230, 255)
label.TextSize = 13
label.Font = Enum.Font.Gotham
label.Parent = frame
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 120, 0, 32)
btn.Position = UDim2.new(1, -135, 0, 10)
btn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
btn.Text = settings.aimbot.aimMode
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.TextSize = 12
btn.Font = Enum.Font.Gotham
btn.Parent = frame
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = btn
local options = {"Players", "NPCs", "Both"}
local isOpen = false
local dropdownFrame = nil
btn.MouseButton1Click:Connect(function()
    playClickSound()
    if isOpen then
        if dropdownFrame then dropdownFrame:Destroy() end
        isOpen = false
    else
        dropdownFrame = Instance.new("Frame")
        dropdownFrame.Size = UDim2.new(0, 120, 0, #options * 34)
        dropdownFrame.Position = UDim2.new(1, -135, 0, 42)
        dropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
        dropdownFrame.BorderSizePixel = 1
        dropdownFrame.BorderColor3 = Color3.fromRGB(80, 80, 120)
        dropdownFrame.Parent = frame
        local dropCorner = Instance.new("UICorner")
        dropCorner.CornerRadius = UDim.new(0, 8)
        dropCorner.Parent = dropdownFrame
        for i, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 34)
            optBtn.Position = UDim2.new(0, 0, 0, (i-1) * 34)
            optBtn.BackgroundTransparency = 1
            optBtn.Text = opt
            optBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
            optBtn.TextSize = 12
            optBtn.Parent = dropdownFrame
            optBtn.MouseButton1Click:Connect(function()
                playClickSound()
                settings.aimbot.aimMode = opt
                btn.Text = opt
                dropdownFrame:Destroy()
                isOpen = false
            end)
            optBtn.MouseEnter:Connect(function()
                TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.8, BackgroundColor3 = Color3.fromRGB(0, 150, 200)}):Play()
            end)
            optBtn.MouseLeave:Connect(function()
                TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundTransparency = 1, BackgroundColor3 = Color3.fromRGB(0, 0, 0)}):Play()
            end)
        end
        isOpen = true
    end
end)

y = y + 60
createModernSlider(aimbotPanel, y, "🎯 FOV RADIUS", 50, 400, settings.aimbot.fovRadius, "px", function(v) settings.aimbot.fovRadius = v end)
y = y + 80
createModernSlider(aimbotPanel, y, "⚡ SMOOTHNESS", 1, 15, settings.aimbot.smoothness, "", function(v) settings.aimbot.smoothness = v end)
y = y + 80
createModernSlider(aimbotPanel, y, "📏 MAX DISTANCE", 50, 400, settings.aimbot.maxDistance, "m", function(v) settings.aimbot.maxDistance = v end)
y = y + 80
createModernToggle(aimbotPanel, y, "🔫 AUTO SHOT", function() return settings.aimbot.autoShot end, function(v) settings.aimbot.autoShot = v end)
y = y + 60
createModernToggle(aimbotPanel, y, "👁️ SHOW FOV", function() return settings.aimbot.showFOV end, function(v) settings.aimbot.showFOV = v end)
y = y + 60
createModernToggle(aimbotPanel, y, "📏 SHOW AIM LINE (ALWAYS)", function() return settings.aimbot.showLine end, function(v) settings.aimbot.showLine = v end)
y = y + 60

-- FOV Color Picker
createColorPicker(aimbotPanel, y, "🎨 FOV COLOR", 
    function() return settings.aimbot.fovColorR or 0 end,
    function() return settings.aimbot.fovColorG or 200 end,
    function() return settings.aimbot.fovColorB or 255 end,
    function(v) settings.aimbot.fovColorR = v; settings.aimbot.fovColor = Color3.fromRGB(v, settings.aimbot.fovColorG or 200, settings.aimbot.fovColorB or 255) end,
    function(v) settings.aimbot.fovColorG = v; settings.aimbot.fovColor = Color3.fromRGB(settings.aimbot.fovColorR or 0, v, settings.aimbot.fovColorB or 255) end,
    function(v) settings.aimbot.fovColorB = v; settings.aimbot.fovColor = Color3.fromRGB(settings.aimbot.fovColorR or 0, settings.aimbot.fovColorG or 200, v) end,
    function() end
)

y = y + 140
-- LINE Color Picker
createColorPicker(aimbotPanel, y, "🎨 LINE COLOR",
    function() return settings.aimbot.lineColorR or 255 end,
    function() return settings.aimbot.lineColorG or 0 end,
    function() return settings.aimbot.lineColorB or 0 end,
    function(v) settings.aimbot.lineColorR = v; settings.aimbot.lineColor = Color3.fromRGB(v, settings.aimbot.lineColorG or 0, settings.aimbot.lineColorB or 0) end,
    function(v) settings.aimbot.lineColorG = v; settings.aimbot.lineColor = Color3.fromRGB(settings.aimbot.lineColorR or 255, v, settings.aimbot.lineColorB or 0) end,
    function(v) settings.aimbot.lineColorB = v; settings.aimbot.lineColor = Color3.fromRGB(settings.aimbot.lineColorR or 255, settings.aimbot.lineColorG or 0, v) end,
    function() end
)

-- ESP PANEL (rút gọn)
y = 10
createModernToggle(espPanel, y, "✨ ENABLE ESP", function() return settings.esp.enabled end, function(v) settings.esp.enabled = v end)
y = y + 60
createModernToggle(espPanel, y, "📦 SHOW BOX", function() return settings.esp.box end, function(v) settings.esp.box = v end)
y = y + 60
createModernSlider(espPanel, y, "📏 ESP DISTANCE", 50, 500, settings.esp.maxDistance, "m", function(v) settings.esp.maxDistance = v end)
y = y + 80
createModernToggle(espPanel, y, "🏷️ SHOW NAME", function() return settings.esp.name end, function(v) settings.esp.name = v end)
y = y + 60
createModernToggle(espPanel, y, "📐 SHOW DISTANCE", function() return settings.esp.distance end, function(v) settings.esp.distance = v end)
y = y + 60
createModernToggle(espPanel, y, "💚 SHOW HEALTH", function() return settings.esp.health end, function(v) settings.esp.health = v end)
y = y + 60

createColorPicker(espPanel, y, "🎨 BOX COLOR",
    function() return settings.esp.boxColorR or 255 end,
    function() return settings.esp.boxColorG or 70 end,
    function() return settings.esp.boxColorB or 70 end,
    function(v) settings.esp.boxColorR = v; settings.esp.boxColor = Color3.fromRGB(v, settings.esp.boxColorG or 70, settings.esp.boxColorB or 70) end,
    function(v) settings.esp.boxColorG = v; settings.esp.boxColor = Color3.fromRGB(settings.esp.boxColorR or 255, v, settings.esp.boxColorB or 70) end,
    function(v) settings.esp.boxColorB = v; settings.esp.boxColor = Color3.fromRGB(settings.esp.boxColorR or 255, settings.esp.boxColorG or 70, v) end,
    function() end
)

y = y + 140
createColorPicker(espPanel, y, "🎨 SKELETON COLOR",
    function() return settings.esp.skeletonColorR or 0 end,
    function() return settings.esp.skeletonColorG or 200 end,
    function() return settings.esp.skeletonColorB or 255 end,
    function(v) settings.esp.skeletonColorR = v; settings.esp.skeletonColor = Color3.fromRGB(v, settings.esp.skeletonColorG or 200, settings.esp.skeletonColorB or 255) end,
    function(v) settings.esp.skeletonColorG = v; settings.esp.skeletonColor = Color3.fromRGB(settings.esp.skeletonColorR or 0, v, settings.esp.skeletonColorB or 255) end,
    function(v) settings.esp.skeletonColorB = v; settings.esp.skeletonColor = Color3.fromRGB(settings.esp.skeletonColorR or 0, settings.esp.skeletonColorG or 200, v) end,
    function() end
)

y = y + 140
createColorPicker(espPanel, y, "🎨 NPC COLOR",
    function() return settings.esp.npcColorR or 255 end,
    function() return settings.esp.npcColorG or 200 end,
    function() return settings.esp.npcColorB or 50 end,
    function(v) settings.esp.npcColorR = v; settings.esp.npcColor = Color3.fromRGB(v, settings.esp.npcColorG or 200, settings.esp.npcColorB or 50) end,
    function(v) settings.esp.npcColorG = v; settings.esp.npcColor = Color3.fromRGB(settings.esp.npcColorR or 255, v, settings.esp.npcColorB or 50) end,
    function(v) settings.esp.npcColorB = v; settings.esp.npcColor = Color3.fromRGB(settings.esp.npcColorR or 255, settings.esp.npcColorG or 200, v) end,
    function() end
)

-- SKELETON PANEL
y = 10
createModernToggle(skeletonPanel, y, "🦴 ENABLE SKELETON", function() return settings.esp.skeleton end, function(v) settings.esp.skeleton = v end)

-- VALUE PANEL
y = 10
local currentFrame = Instance.new("Frame")
currentFrame.Size = UDim2.new(1, -10, 0, 60)
currentFrame.Position = UDim2.new(0, 5, 0, y)
currentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
currentFrame.BackgroundTransparency = 0.4
currentFrame.BorderSizePixel = 0
currentFrame.Parent = setValuePanel
local currentCorner = Instance.new("UICorner")
currentCorner.CornerRadius = UDim.new(0, 12)
currentCorner.Parent = currentFrame
local currentLabel = Instance.new("TextLabel")
currentLabel.Size = UDim2.new(1, -20, 0, 40)
currentLabel.Position = UDim2.new(0, 10, 0, 10)
currentLabel.BackgroundTransparency = 1
currentLabel.Text = "🏆 Current Win Streak: " .. getCurrentWinStreak()
currentLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
currentLabel.TextSize = 14
currentLabel.Font = Enum.Font.GothamBold
currentLabel.TextXAlignment = Enum.TextXAlignment.Center
currentLabel.Parent = currentFrame

y = y + 70
local inputFrame = Instance.new("Frame")
inputFrame.Size = UDim2.new(1, -10, 0, 55)
inputFrame.Position = UDim2.new(0, 5, 0, y)
inputFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
inputFrame.BackgroundTransparency = 0.4
inputFrame.BorderSizePixel = 0
inputFrame.Parent = setValuePanel
local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 12)
inputCorner.Parent = inputFrame
local valueInput = Instance.new("TextBox")
valueInput.Size = UDim2.new(1, -90, 0, 35)
valueInput.Position = UDim2.new(0, 10, 0, 10)
valueInput.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
valueInput.Text = tostring(getCurrentWinStreak())
valueInput.TextColor3 = Color3.fromRGB(255, 255, 255)
valueInput.TextSize = 14
valueInput.Font = Enum.Font.Gotham
valueInput.TextXAlignment = Enum.TextXAlignment.Center
valueInput.Parent = inputFrame
local inputBoxCorner = Instance.new("UICorner")
inputBoxCorner.CornerRadius = UDim.new(0, 8)
inputBoxCorner.Parent = valueInput
local applyBtn = Instance.new("TextButton")
applyBtn.Size = UDim2.new(0, 60, 0, 35)
applyBtn.Position = UDim2.new(1, -70, 0, 10)
applyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
applyBtn.Text = "SET"
applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applyBtn.TextSize = 13
applyBtn.Font = Enum.Font.GothamBold
applyBtn.Parent = inputFrame
local applyCorner = Instance.new("UICorner")
applyCorner.CornerRadius = UDim.new(0, 8)
applyCorner.Parent = applyBtn

applyBtn.MouseEnter:Connect(function()
    TweenService:Create(applyBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 210, 100)}):Play()
end)
applyBtn.MouseLeave:Connect(function()
    TweenService:Create(applyBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 180, 90)}):Play()
end)

local function refreshWinStreakDisplay()
    local newValue = getCurrentWinStreak()
    currentLabel.Text = "🏆 Current Win Streak: " .. tostring(newValue)
    valueInput.Text = tostring(newValue)
end

applyBtn.MouseButton1Click:Connect(function()
    playClickSound()
    local newValue = tonumber(valueInput.Text)
    if newValue then
        local success = setWinStreak(newValue)
        if success then
            refreshWinStreakDisplay()
            refreshLocalPlayerUI()
            local notif = Drawing.new("Text")
            notif.Text = "✅ Win Streak changed to " .. newValue
            notif.Size = 14
            notif.Color = Color3.fromRGB(0, 255, 0)
            notif.Center = true
            notif.Outline = true
            notif.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            notif.Visible = true
            task.wait(1)
            notif.Visible = false
            notif:Remove()
        else
            local notif = Drawing.new("Text")
            notif.Text = "❌ Win Streak not found!"
            notif.Size = 14
            notif.Color = Color3.fromRGB(255, 0, 0)
            notif.Center = true
            notif.Outline = true
            notif.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            notif.Visible = true
            task.wait(1)
            notif.Visible = false
            notif:Remove()
        end
    end
end)

-- DEVICE PANEL
y = 10
local deviceTitle = Instance.new("TextLabel")
deviceTitle.Size = UDim2.new(1, -20, 0, 40)
deviceTitle.Position = UDim2.new(0, 10, 0, y)
deviceTitle.BackgroundTransparency = 1
deviceTitle.Text = "🎮 SELECT YOUR DEVICE"
deviceTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
deviceTitle.TextSize = 14
deviceTitle.Font = Enum.Font.GothamBold
deviceTitle.TextXAlignment = Enum.TextXAlignment.Center
deviceTitle.Parent = devicePanel

y = y + 50
createDeviceButton(devicePanel, y, "🖱️ MOUSE & KEYBOARD", "MouseKeyboard", Color3.fromRGB(45, 45, 65))
y = y + 55
createDeviceButton(devicePanel, y, "🎮 GAMEPAD", "Gamepad", Color3.fromRGB(45, 65, 45))
y = y + 55
createDeviceButton(devicePanel, y, "📱 TOUCH (MOBILE)", "Touch", Color3.fromRGB(65, 45, 65))
y = y + 55
createDeviceButton(devicePanel, y, "🥽 VR", "VR", Color3.fromRGB(65, 65, 45))

y = y + 65
local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(1, -20, 0, 50)
infoText.Position = UDim2.new(0, 10, 0, y)
infoText.BackgroundTransparency = 1
infoText.Text = "⚠️ Note: Device spoofing changes how\nthe game detects your input method"
infoText.TextColor3 = Color3.fromRGB(150, 150, 200)
infoText.TextSize = 11
infoText.Font = Enum.Font.Gotham
infoText.TextXAlignment = Enum.TextXAlignment.Center
infoText.Parent = devicePanel

-- TP PANEL
y = 10
createModernToggle(tpPanel, y, "🌀 ENABLE TELEPORT", function() return settings.teleport.enabled end, function(v) settings.teleport.enabled = v end)
y = y + 70
local guideCard = Instance.new("Frame")
guideCard.Size = UDim2.new(1, -10, 0, 100)
guideCard.Position = UDim2.new(0, 5, 0, y)
guideCard.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
guideCard.BackgroundTransparency = 0.4
guideCard.BorderSizePixel = 0
guideCard.Parent = tpPanel
local guideCorner = Instance.new("UICorner")
guideCorner.CornerRadius = UDim.new(0, 12)
guideCorner.Parent = guideCard
local guideLabel = Instance.new("TextLabel")
guideLabel.Size = UDim2.new(1, -20, 0, 80)
guideLabel.Position = UDim2.new(0, 10, 0, 10)
guideLabel.BackgroundTransparency = 1
guideLabel.Text = "📌 HOW TO USE TELEPORT:\n\n   Press [X] to teleport to where you're looking\n   Make sure you have a clear view of the ground"
guideLabel.TextColor3 = Color3.fromRGB(200, 200, 230)
guideLabel.TextSize = 12
guideLabel.TextXAlignment = Enum.TextXAlignment.Center
guideLabel.Parent = guideCard

-- ============ CONFIG PANEL (RÚT GỌN) ==========
local function refreshConfigList()
    for _, child in pairs(configPanel:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local yPos = 10
    
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(1, -10, 0, 60)
    titleFrame.Position = UDim2.new(0, 5, 0, yPos)
    titleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    titleFrame.BackgroundTransparency = 0.4
    titleFrame.BorderSizePixel = 0
    titleFrame.Parent = configPanel
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleFrame
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 40)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "⚙️ CONFIG MANAGEMENT"
    titleLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.Parent = titleFrame
    
    yPos = yPos + 70
    
    local autoLoadFrame = Instance.new("Frame")
    autoLoadFrame.Size = UDim2.new(1, -10, 0, 100)
    autoLoadFrame.Position = UDim2.new(0, 5, 0, yPos)
    autoLoadFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    autoLoadFrame.BackgroundTransparency = 0.4
    autoLoadFrame.BorderSizePixel = 0
    autoLoadFrame.Parent = configPanel
    local autoLoadCorner = Instance.new("UICorner")
    autoLoadCorner.CornerRadius = UDim.new(0, 12)
    autoLoadCorner.Parent = autoLoadFrame
    
    local autoLoadLabel = Instance.new("TextLabel")
    autoLoadLabel.Size = UDim2.new(1, -20, 0, 25)
    autoLoadLabel.Position = UDim2.new(0, 10, 0, 8)
    autoLoadLabel.BackgroundTransparency = 1
    autoLoadLabel.Text = "🔄 AUTO LOAD CONFIG"
    autoLoadLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    autoLoadLabel.TextSize = 13
    autoLoadLabel.Font = Enum.Font.GothamBold
    autoLoadLabel.TextXAlignment = Enum.TextXAlignment.Left
    autoLoadLabel.Parent = autoLoadFrame
    
    local currentAutoLoad = getAutoLoadConfig()
    local autoLoadStatus = Instance.new("TextLabel")
    autoLoadStatus.Size = UDim2.new(1, -20, 0, 25)
    autoLoadStatus.Position = UDim2.new(0, 10, 0, 35)
    autoLoadStatus.BackgroundTransparency = 1
    autoLoadStatus.Text = currentAutoLoad and "📌 Current auto-load: " .. currentAutoLoad or "📌 No config set for auto-load"
    autoLoadStatus.TextColor3 = currentAutoLoad and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 200, 100)
    autoLoadStatus.TextSize = 12
    autoLoadStatus.Font = Enum.Font.Gotham
    autoLoadStatus.TextXAlignment = Enum.TextXAlignment.Left
    autoLoadStatus.Parent = autoLoadFrame
    
    local clearAutoLoadBtn = Instance.new("TextButton")
    clearAutoLoadBtn.Size = UDim2.new(0, 100, 0, 32)
    clearAutoLoadBtn.Position = UDim2.new(1, -110, 0, 55)
    clearAutoLoadBtn.BackgroundColor3 = Color3.fromRGB(100, 60, 60)
    clearAutoLoadBtn.Text = "🗑️ CLEAR"
    clearAutoLoadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearAutoLoadBtn.TextSize = 11
    clearAutoLoadBtn.Font = Enum.Font.GothamBold
    clearAutoLoadBtn.Parent = autoLoadFrame
    local clearCorner = Instance.new("UICorner")
    clearCorner.CornerRadius = UDim.new(0, 8)
    clearCorner.Parent = clearAutoLoadBtn
    
    clearAutoLoadBtn.MouseButton1Click:Connect(function()
        playClickSound()
        clearAutoLoadConfig()
        autoLoadStatus.Text = "📌 No config set for auto-load"
        autoLoadStatus.TextColor3 = Color3.fromRGB(255, 200, 100)
        refreshConfigList()
        local notif = Drawing.new("Text")
        notif.Text = "✅ Auto-load cleared!"
        notif.Size = 14
        notif.Color = Color3.fromRGB(0, 255, 0)
        notif.Center = true
        notif.Outline = true
        notif.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - 100)
        notif.Visible = true
        task.wait(1.5)
        notif.Visible = false
        notif:Remove()
    end)
    
    yPos = yPos + 110
    
    local createFrame = Instance.new("Frame")
    createFrame.Size = UDim2.new(1, -10, 0, 100)
    createFrame.Position = UDim2.new(0, 5, 0, yPos)
    createFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    createFrame.BackgroundTransparency = 0.4
    createFrame.BorderSizePixel = 0
    createFrame.Parent = configPanel
    local createCorner = Instance.new("UICorner")
    createCorner.CornerRadius = UDim.new(0, 12)
    createCorner.Parent = createFrame
    local createLabel = Instance.new("TextLabel")
    createLabel.Size = UDim2.new(1, -20, 0, 25)
    createLabel.Position = UDim2.new(0, 10, 0, 8)
    createLabel.BackgroundTransparency = 1
    createLabel.Text = "📝 CREATE NEW CONFIG"
    createLabel.TextColor3 = Color3.fromRGB(230, 230, 255)
    createLabel.TextSize = 13
    createLabel.Font = Enum.Font.GothamBold
    createLabel.TextXAlignment = Enum.TextXAlignment.Left
    createLabel.Parent = createFrame
    local configNameInput = Instance.new("TextBox")
    configNameInput.Size = UDim2.new(0.6, -10, 0, 38)
    configNameInput.Position = UDim2.new(0, 10, 0, 40)
    configNameInput.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    configNameInput.PlaceholderText = "Enter config name..."
    configNameInput.Text = ""
    configNameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    configNameInput.TextSize = 13
    configNameInput.Font = Enum.Font.Gotham
    configNameInput.Parent = createFrame
    local nameCorner = Instance.new("UICorner")
    nameCorner.CornerRadius = UDim.new(0, 8)
    nameCorner.Parent = configNameInput
    local createConfigBtn = Instance.new("TextButton")
    createConfigBtn.Size = UDim2.new(0.35, -10, 0, 38)
    createConfigBtn.Position = UDim2.new(0.65, 0, 0, 40)
    createConfigBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    createConfigBtn.Text = "💾 CREATE & SAVE"
    createConfigBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    createConfigBtn.TextSize = 11
    createConfigBtn.Font = Enum.Font.GothamBold
    createConfigBtn.Parent = createFrame
    local createCorner2 = Instance.new("UICorner")
    createCorner2.CornerRadius = UDim.new(0, 8)
    createCorner2.Parent = createConfigBtn
    
    yPos = yPos + 110
    
    local listFrame = Instance.new("Frame")
    listFrame.Size = UDim2.new(1, -10, 0, 250)
    listFrame.Position = UDim2.new(0, 5, 0, yPos)
    listFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    listFrame.BackgroundTransparency = 0.4
    listFrame.BorderSizePixel = 0
    listFrame.Parent = configPanel
    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 12)
    listCorner.Parent = listFrame
    local listLabel = Instance.new("TextLabel")
    listLabel.Size = UDim2.new(0.6, -10, 0, 25)
    listLabel.Position = UDim2.new(0, 10, 0, 8)
    listLabel.BackgroundTransparency = 1
    listLabel.Text = "📋 SAVED CONFIGS"
    listLabel.TextColor3 = Color3.fromRGB(230, 230, 255)
    listLabel.TextSize = 13
    listLabel.Font = Enum.Font.GothamBold
    listLabel.TextXAlignment = Enum.TextXAlignment.Left
    listLabel.Parent = listFrame
    
    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Size = UDim2.new(0, 80, 0, 28)
    refreshBtn.Position = UDim2.new(1, -90, 0, 6)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 85)
    refreshBtn.Text = "🔄 REFRESH"
    refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshBtn.TextSize = 11
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.Parent = listFrame
    local refreshCorner = Instance.new("UICorner")
    refreshCorner.CornerRadius = UDim.new(0, 6)
    refreshCorner.Parent = refreshBtn
    
    local configListScrolling = Instance.new("ScrollingFrame")
    configListScrolling.Size = UDim2.new(1, -10, 1, -45)
    configListScrolling.Position = UDim2.new(0, 5, 0, 40)
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
            cfgFrame.Size = UDim2.new(1, -10, 0, 55)
            cfgFrame.Position = UDim2.new(0, 5, 0, scrollY)
            cfgFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
            cfgFrame.BackgroundTransparency = 0.3
            cfgFrame.BorderSizePixel = 0
            cfgFrame.Parent = configListScrolling
            local cfgCorner = Instance.new("UICorner")
            cfgCorner.CornerRadius = UDim.new(0, 8)
            cfgCorner.Parent = cfgFrame
            
            local cfgNameLabel = Instance.new("TextLabel")
            cfgNameLabel.Size = UDim2.new(0.4, -10, 0, 25)
            cfgNameLabel.Position = UDim2.new(0, 10, 0, 8)
            cfgNameLabel.BackgroundTransparency = 1
            cfgNameLabel.Text = cfgName
            cfgNameLabel.TextColor3 = (autoLoadName == cfgName) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 200, 255)
            cfgNameLabel.TextSize = 12
            cfgNameLabel.Font = Enum.Font.GothamBold
            cfgNameLabel.TextXAlignment = Enum.TextXAlignment.Left
            cfgNameLabel.Parent = cfgFrame
            
            if autoLoadName == cfgName then
                local autoBadge = Instance.new("TextLabel")
                autoBadge.Size = UDim2.new(0, 60, 0, 18)
                autoBadge.Position = UDim2.new(0.4, 10, 0, 10)
                autoBadge.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
                autoBadge.Text = "AUTO"
                autoBadge.TextColor3 = Color3.fromRGB(255, 255, 255)
                autoBadge.TextSize = 10
                autoBadge.Font = Enum.Font.GothamBold
                autoBadge.Parent = cfgFrame
                local badgeCorner = Instance.new("UICorner")
                badgeCorner.CornerRadius = UDim.new(0, 4)
                badgeCorner.Parent = autoBadge
            end
            
            local loadCfgBtn = Instance.new("TextButton")
            loadCfgBtn.Size = UDim2.new(0, 70, 0, 32)
            loadCfgBtn.Position = UDim2.new(0.5, -95, 0, 12)
            loadCfgBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
            loadCfgBtn.Text = "📂 LOAD"
            loadCfgBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            loadCfgBtn.TextSize = 11
            loadCfgBtn.Font = Enum.Font.GothamBold
            loadCfgBtn.Parent = cfgFrame
            local loadCorner = Instance.new("UICorner")
            loadCorner.CornerRadius = UDim.new(0, 6)
            loadCorner.Parent = loadCfgBtn
            
            local autoLoadBtn = Instance.new("TextButton")
            autoLoadBtn.Size = UDim2.new(0, 85, 0, 32)
            autoLoadBtn.Position = UDim2.new(0.5, -15, 0, 12)
            autoLoadBtn.BackgroundColor3 = (autoLoadName == cfgName) and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(60, 60, 85)
            autoLoadBtn.Text = (autoLoadName == cfgName) and "✅ AUTO" or "⭐ SET AUTO"
            autoLoadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            autoLoadBtn.TextSize = 10
            autoLoadBtn.Font = Enum.Font.GothamBold
            autoLoadBtn.Parent = cfgFrame
            local autoCorner = Instance.new("UICorner")
            autoCorner.CornerRadius = UDim.new(0, 6)
            autoCorner.Parent = autoLoadBtn
            
            local delCfgBtn = Instance.new("TextButton")
            delCfgBtn.Size = UDim2.new(0, 55, 0, 32)
            delCfgBtn.Position = UDim2.new(1, -65, 0, 12)
            delCfgBtn.BackgroundColor3 = Color3.fromRGB(100, 40, 40)
            delCfgBtn.Text = "🗑️"
            delCfgBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            delCfgBtn.TextSize = 12
            delCfgBtn.Font = Enum.Font.GothamBold
            delCfgBtn.Parent = cfgFrame
            local delCorner = Instance.new("UICorner")
            delCorner.CornerRadius = UDim.new(0, 6)
            delCorner.Parent = delCfgBtn
            
            loadCfgBtn.MouseButton1Click:Connect(function()
                playClickSound()
                local success, msg = loadConfig(cfgName)
                if success then
                    refreshWinStreakDisplay()
                end
                local notif = Drawing.new("Text")
                notif.Text = msg
                notif.Size = 14
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
                    autoLoadStatus.Text = "📌 Current auto-load: " .. cfgName
                    autoLoadStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
                    updateConfigList()
                    local notif = Drawing.new("Text")
                    notif.Text = "✅ Auto-load set to: " .. cfgName
                    notif.Size = 14
                    notif.Color = Color3.fromRGB(0, 255, 0)
                    notif.Center = true
                    notif.Outline = true
                    notif.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - 100)
                    notif.Visible = true
                    task.wait(1.5)
                    notif.Visible = false
                    notif:Remove()
                else
                    local notif = Drawing.new("Text")
                    notif.Text = "❌ Cannot set auto-load"
                    notif.Size = 14
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
            
            delCfgBtn.MouseButton1Click:Connect(function()
                playClickSound()
                local success = deleteConfig(cfgName)
                if success then
                    if autoLoadName == cfgName then
                        clearAutoLoadConfig()
                        autoLoadStatus.Text = "📌 No config set for auto-load"
                        autoLoadStatus.TextColor3 = Color3.fromRGB(255, 200, 100)
                    end
                    updateConfigList()
                end
            end)
            
            scrollY = scrollY + 65
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
        local success, msg = saveConfig(configName)
        
        local notif = Drawing.new("Text")
        notif.Text = msg
        notif.Size = 14
        notif.Color = success and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        notif.Center = true
        notif.Outline = true
        notif.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - 100)
        notif.Visible = true
        
        if success then
            configNameInput.Text = ""
            updateConfigList()
        end
        
        task.wait(1.5)
        notif.Visible = false
        notif:Remove()
    end)
    
    updateConfigList()
end

refreshConfigList()

local function doAutoLoadOnStart()
    ensureConfigFolder()
    local success, msg = autoLoadConfigOnStart()
    if success then
        refreshWinStreakDisplay()
        local notif = Drawing.new("Text")
        notif.Text = "🔧 " .. msg
        notif.Size = 14
        notif.Color = Color3.fromRGB(0, 255, 0)
        notif.Center = true
        notif.Outline = true
        notif.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - 80)
        notif.Visible = true
        task.wait(2)
        notif.Visible = false
        notif:Remove()
    end
end

doAutoLoadOnStart()

-- Tab switching
local panels = {aimbotPanel, espPanel, skeletonPanel, setValuePanel, devicePanel, tpPanel, configPanel}
local function switchTab(tabIndex, panel, btn)
    TweenService:Create(contentArea, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    task.wait(0.1)
    for _, p in pairs(panels) do
        if p then p.Visible = false end
    end
    panel.Visible = true
    if tabIndex == 4 then refreshWinStreakDisplay() end
    if tabIndex == 7 then refreshConfigList() end
    for i, b in ipairs(tabs) do
        TweenService:Create(b, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(160, 160, 200), Font = Enum.Font.GothamSemibold}):Play()
    end
    TweenService:Create(btn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold}):Play()
    TweenService:Create(indicator, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, (tabIndex-1) * tabWidth, 1, -3)}):Play()
    TweenService:Create(contentArea, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
end

for i, btn in ipairs(tabs) do
    btn.MouseButton1Click:Connect(function()
        playClickSound()
        switchTab(i, panels[i], btn)
    end)
end

-- Menu animation
local menuVisible = false
local function openMenu()
    menuVisible = true
    menu.Visible = true
    overlay.Visible = true
    TweenService:Create(overlay, TweenInfo.new(0.3), {BackgroundTransparency = 0.5}):Play()
    menu.Size = UDim2.new(0, 0, 0, 0)
    menu.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(menu, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 580, 0, 800),
        Position = UDim2.new(0.5, -290, 0.5, -400)
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

-- Drag menu
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

-- Open menu with Right Shift
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        playClickSound()
        if menuVisible then closeMenu() else openMenu() end
    end
end)

-- Particle animation
task.spawn(function()
    while true do
        if menuVisible and particle then
            TweenService:Create(particle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true), {Position = UDim2.new(1, 2, 0.5, -2)}):Play()
        end
        task.wait(0.5)
    end
end)

-- Welcome notification
local successNotif = Drawing.new("Text")
successNotif.Text = "✅ Welcome " .. playerName .. "!"
successNotif.Size = 18
successNotif.Color = Color3.fromRGB(0, 255, 0)
successNotif.Center = true
successNotif.Outline = true
successNotif.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - 60)
successNotif.Visible = true

local subNotif = Drawing.new("Text")
subNotif.Text = "Key: " .. currentKey
subNotif.Size = 12
subNotif.Color = Color3.fromRGB(0, 200, 255)
subNotif.Center = true
subNotif.Outline = true
subNotif.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - 40)
subNotif.Visible = true

local deviceNotif = Drawing.new("Text")
deviceNotif.Text = "🎮 Device Spoofer | 🔫 Aimbot | 📏 LINE ALWAYS ON | ⚡ AUTO SHOT (NO DELAY)"
deviceNotif.Size = 12
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
print("     ✦ KHANHGD CHEAT v8.0 ✦")
print("========================================")
print("  VERIFIED KEY: " .. currentKey)
print("  PLAYER: " .. playerName)
print("========================================")
print("  RIGHT SHIFT = MENU")
print("  HOLD RIGHT CLICK = AIMBOT")
print("  X = TELEPORT")
print("========================================")
print("  📏 LINE LUÔN HIỆN (CÓ THỂ TẮT/BẬT)")
print("  ⚡ AUTO SHOT BẮN NGAY KHI TÂM CHẠM ĐẦU")
print("  🎨 ĐỔI MÀU LINE TRONG TAB AIM")
print("  🔫 KHÔNG BẮN XUYÊN TƯỜNG")
print("========================================")
local autoCfg = getAutoLoadConfig()
if autoCfg then
    print("  🔄 AUTO LOAD: " .. autoCfg)
else
    print("  🔄 AUTO LOAD: Not set")
end
print("========================================")
end

if isKeyValidated then
    loadMainMenu()
end
