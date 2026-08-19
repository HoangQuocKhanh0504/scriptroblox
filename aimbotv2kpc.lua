-- [[ Rscripts Risk Notice ]]
-- This script is not verified by rscripts.net. Deal with caution.
--
-- Stay safe:
--   • Never log in on unofficial Roblox sites or lookalike domains.
--   • Real Roblox links use roblox.com (check the .com ending).
--   • Treat fake Roblox login / "claim reward" pages as phishing.
-- [[ End Rscripts Risk Notice ]]

-- ===== ESP CONFIG =====
_G.FriendColor = Color3.fromRGB(0, 0, 255)
_G.EnemyColor = Color3.fromRGB(255, 0, 0)
_G.UseTeamColor = true
_G.ESPDistance = 300
_G.ShowHealth = true

--------------------------------------------------------------------
-- KHỞI TẠO ESP HOLDER TRƯỚC
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Holder = Instance.new("Folder", game.CoreGui)
Holder.Name = "ESP"

-- Biến trạng thái (mặc định TẮT)
local ESPEnabled = false
local AimbotEnabled = false
local MenuVisible = true

-- Vị trí cố định của menu (KHÔNG DI CHUYỂN ĐƯỢC)
local menuPosition = UDim2.new(0.500000, -958, 0.500000, 154)

-- ===== ĐỊNH NGHĨA IsInRange TRƯỚC KHI SỬ DỤNG =====
local function IsInRange(player)
    local localChar = LocalPlayer.Character
    local targetChar = player.Character
    if not localChar or not targetChar then return false end
    
    local localRoot = localChar:FindFirstChild("HumanoidRootPart")
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not localRoot or not targetRoot then return false end
    
    local dist = (localRoot.Position - targetRoot.Position).Magnitude
    return dist <= _G.ESPDistance
end

-- ===== TẠO KEYBINDS MENU =====
local function CreateKeybindsMenu()
    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KeybindsMenu"
    screenGui.Parent = game.CoreGui
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame (KHÔNG CHO KÉO THẢ)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 200, 0, 100)
    mainFrame.Position = menuPosition
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(80, 80, 130)
    mainFrame.ClipsDescendants = true
    mainFrame.Visible = true
    mainFrame.Parent = screenGui
    
    -- Glass effect
    local glass = Instance.new("Frame")
    glass.Name = "Glass"
    glass.Size = UDim2.new(1, 0, 1, 0)
    glass.Position = UDim2.new(0, 0, 0, 0)
    glass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    glass.BackgroundTransparency = 0.95
    glass.BorderSizePixel = 0
    glass.Parent = mainFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 28)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    titleBar.BackgroundTransparency = 0.3
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    -- Title Text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(1, 0, 1, 0)
    titleText.Position = UDim2.new(0, 0, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "⚡ KEYBINDS"
    titleText.TextColor3 = Color3.fromRGB(180, 180, 240)
    titleText.TextSize = 13
    titleText.Font = Enum.Font.SourceSansBold
    titleText.TextXAlignment = Enum.TextXAlignment.Center
    titleText.TextYAlignment = Enum.TextYAlignment.Center
    titleText.Parent = titleBar
    
    -- ===== CONTENT =====
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, -10, 1, -32)
    contentFrame.Position = UDim2.new(0, 5, 0, 31)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    -- UIListLayout
    local uiList = Instance.new("UIListLayout")
    uiList.Parent = contentFrame
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Padding = UDim.new(0, 4)
    uiList.VerticalAlignment = Enum.VerticalAlignment.Top
    
    -- Hàm tạo 1 keybind item
    local function CreateKeybindItem(key, name, getState, toggleFunc, order)
        local item = Instance.new("TextButton")
        item.Name = key .. "Item"
        item.Size = UDim2.new(1, 0, 0, 30)
        item.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
        item.BackgroundTransparency = 0.4
        item.BorderSizePixel = 1
        item.BorderColor3 = Color3.fromRGB(45, 45, 65)
        item.LayoutOrder = order or 1
        item.Parent = contentFrame
        item.Text = ""
        item.AutoButtonColor = false
        
        -- Hover effect
        item.MouseEnter:Connect(function()
            item.BackgroundTransparency = 0.2
        end)
        item.MouseLeave:Connect(function()
            item.BackgroundTransparency = 0.4
        end)
        
        -- Key label
        local keyLabel = Instance.new("TextLabel")
        keyLabel.Name = "KeyLabel"
        keyLabel.Size = UDim2.new(0, 30, 1, 0)
        keyLabel.Position = UDim2.new(0, 3, 0, 0)
        keyLabel.BackgroundColor3 = Color3.fromRGB(38, 38, 55)
        keyLabel.BackgroundTransparency = 0.3
        keyLabel.BorderSizePixel = 1
        keyLabel.BorderColor3 = Color3.fromRGB(70, 70, 110)
        keyLabel.Text = key
        keyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        keyLabel.TextSize = 13
        keyLabel.Font = Enum.Font.SourceSansBold
        keyLabel.TextXAlignment = Enum.TextXAlignment.Center
        keyLabel.TextYAlignment = Enum.TextYAlignment.Center
        keyLabel.Parent = item
        
        -- Name label
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "NameLabel"
        nameLabel.Size = UDim2.new(0.6, -5, 1, 0)
        nameLabel.Position = UDim2.new(0, 38, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = name
        nameLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
        nameLabel.TextSize = 13
        nameLabel.Font = Enum.Font.SourceSans
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.TextYAlignment = Enum.TextYAlignment.Center
        nameLabel.Parent = item
        
        -- Status Indicator
        local status = Instance.new("Frame")
        status.Name = "Status"
        status.Size = UDim2.new(0, 14, 0, 14)
        status.Position = UDim2.new(1, -20, 0.5, -7)
        status.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        status.BorderSizePixel = 0
        status.Parent = item
        
        -- Glow effect
        local glow = Instance.new("Frame")
        glow.Name = "Glow"
        glow.Size = UDim2.new(1.6, 0, 1.6, 0)
        glow.Position = UDim2.new(-0.3, 0, -0.3, 0)
        glow.BackgroundColor3 = status.BackgroundColor3
        glow.BackgroundTransparency = 0.7
        glow.BorderSizePixel = 0
        glow.Parent = status
        
        -- Update function
        local function UpdateStatus()
            local isOn = getState()
            local color = isOn and Color3.fromRGB(0, 255, 80) or Color3.fromRGB(255, 50, 50)
            
            local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween1 = TweenService:Create(status, tweenInfo, {BackgroundColor3 = color})
            local tween2 = TweenService:Create(glow, tweenInfo, {BackgroundColor3 = color})
            tween1:Play()
            tween2:Play()
        end
        
        -- Click to toggle
        item.MouseButton1Click:Connect(function()
            toggleFunc()
            UpdateStatus()
        end)
        
        UpdateStatus()
        
        return item, UpdateStatus
    end
    
    -- Tạo 2 keybind items
    local espItem, espUpdate = CreateKeybindItem(
        "P", 
        "Wall Hack", 
        function() return ESPEnabled end,
        function() 
            ESPEnabled = not ESPEnabled
            ToggleESP()
        end,
        1
    )
    
    local aimbotItem, aimbotUpdate = CreateKeybindItem(
        "0", 
        "Aim Bot", 
        function() return AimbotEnabled end,
        function() 
            AimbotEnabled = not AimbotEnabled
            if ToggleAimbotGlobal then
                ToggleAimbotGlobal()
            end
        end,
        2
    )
    
    return {
        UpdateESP = espUpdate,
        UpdateAimbot = aimbotUpdate,
        MainFrame = mainFrame
    }
end

-- ===== TẠO MENU VÀ LƯU THAM CHIẾU =====
local KeybindsMenu = CreateKeybindsMenu()

-- Hàm để toggle ESP từ bên ngoài
local function ToggleESP()
    ESPEnabled = not ESPEnabled
    
    -- Kiểm tra Holder tồn tại
    if not Holder then
        print("[ESP] Holder not found, skipping...")
        if KeybindsMenu and KeybindsMenu.UpdateESP then
            KeybindsMenu.UpdateESP()
        end
        return
    end
    
    -- Ẩn/hiện tất cả các ESP elements
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            -- Kiểm tra vHolder
            local vHolder = Holder:FindFirstChild(player.Name)
            if vHolder then
                local box = vHolder:FindFirstChild(player.Name .. "Box")
                if box then
                    box.Visible = ESPEnabled and IsInRange(player)
                end
                
                local nametag = vHolder:FindFirstChild(player.Name .. "NameTag")
                if nametag then
                    nametag.Enabled = ESPEnabled and IsInRange(player)
                end
                
                local healthGui = vHolder:FindFirstChild(player.Name .. "HealthBar")
                if healthGui then
                    healthGui.Enabled = ESPEnabled and _G.ShowHealth and IsInRange(player)
                end
            end
            
            -- Kiểm tra Highlight
            if player.Character then
                local highlight = player.Character:FindFirstChild("GetReal")
                if highlight then
                    highlight.Enabled = ESPEnabled
                end
            end
        end
    end
    
    -- Cập nhật menu
    if KeybindsMenu and KeybindsMenu.UpdateESP then
        KeybindsMenu.UpdateESP()
    end
    
    print("[ESP] Toggled: " .. (ESPEnabled and "ON" or "OFF"))
end

-- Hàm để toggle Aimbot từ bên ngoài
local function ToggleAimbotGlobal()
    AimbotEnabled = not AimbotEnabled
    
    if KeybindsMenu and KeybindsMenu.UpdateAimbot then
        KeybindsMenu.UpdateAimbot()
    end
    
    print("[AIMBOT] Toggled: " .. (AimbotEnabled and "ON" or "OFF"))
end

_G.ToggleAimbotGlobal = ToggleAimbotGlobal

--------------------------------------------------------------------
-- ESP System
local function IsInRange(player)
    local localChar = LocalPlayer.Character
    local targetChar = player.Character
    if not localChar or not targetChar then return false end
    
    local localRoot = localChar:FindFirstChild("HumanoidRootPart")
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not localRoot or not targetRoot then return false end
    
    local dist = (localRoot.Position - targetRoot.Position).Magnitude
    return dist <= _G.ESPDistance
end

-- Health Bar
local function CreateHealthBar(v)
    local healthGui = Instance.new("BillboardGui")
    healthGui.Name = v.Name .. "HealthBar"
    healthGui.Enabled = false
    healthGui.Size = UDim2.new(0, 120, 0, 16)
    healthGui.StudsOffset = Vector3.new(0, -2, 0)
    healthGui.AlwaysOnTop = true
    healthGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local bg = Instance.new("Frame", healthGui)
    bg.Name = "Background"
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.6
    bg.BorderSizePixel = 1
    bg.BorderColor3 = Color3.fromRGB(255, 255, 255)
    bg.BorderMode = Enum.BorderMode.Inset
    
    local healthFill = Instance.new("Frame", bg)
    healthFill.Name = "HealthFill"
    healthFill.Size = UDim2.new(1, -4, 1, -4)
    healthFill.Position = UDim2.new(0, 2, 0, 2)
    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthFill.BackgroundTransparency = 0
    healthFill.BorderSizePixel = 0
    
    local gradient = Instance.new("UIGradient", healthFill)
    gradient.Rotation = 0
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255, 0.3)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255, 0.1)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0, 0.2))
    })
    
    local shine = Instance.new("Frame", healthFill)
    shine.Name = "Shine"
    shine.Size = UDim2.new(1, 0, 0.4, 0)
    shine.Position = UDim2.new(0, 0, 0, 0)
    shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    shine.BackgroundTransparency = 0.7
    shine.BorderSizePixel = 0
    
    local healthText = Instance.new("TextLabel", healthGui)
    healthText.Name = "HealthText"
    healthText.Size = UDim2.new(1, 0, 1, 0)
    healthText.Position = UDim2.new(0, 0, 0, 0)
    healthText.BackgroundTransparency = 1
    healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
    healthText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    healthText.TextStrokeTransparency = 0.3
    healthText.TextSize = 10
    healthText.Font = Enum.Font.SourceSansBold
    healthText.Text = "100/100"
    healthText.TextXAlignment = Enum.TextXAlignment.Center
    healthText.TextYAlignment = Enum.TextYAlignment.Center
    
    return healthGui
end

local function UpdateHealthBar(v)
    local vHolder = Holder:FindFirstChild(v.Name)
    if not vHolder then return end
    
    local healthGui = vHolder:FindFirstChild(v.Name .. "HealthBar")
    if not healthGui then return end
    
    local char = v.Character
    if not char then
        healthGui.Enabled = false
        return
    end
    
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if not hum then
        healthGui.Enabled = false
        return
    end
    
    local health = hum.Health
    local maxHealth = hum.MaxHealth
    local healthPercent = math.clamp(health / maxHealth, 0, 1)
    
    local healthFill = healthGui.Background:FindFirstChild("HealthFill")
    local healthText = healthGui:FindFirstChild("HealthText")
    
    if healthFill then
        healthFill.Size = UDim2.new(healthPercent, -4, 1, -4)
        
        local r, g, b
        if healthPercent > 0.6 then
            r = math.floor(255 * (1 - (healthPercent - 0.6) / 0.4 * 0.5))
            g = 255
            b = math.floor(255 * ((healthPercent - 0.6) / 0.4 * 0.8))
        elseif healthPercent > 0.3 then
            local t = (healthPercent - 0.3) / 0.3
            r = math.floor(255 * t + 255 * (1 - t))
            g = 255
            b = math.floor(255 * (1 - t))
        else
            local t = healthPercent / 0.3
            r = 255
            g = math.floor(255 * t)
            b = 0
        end
        
        healthFill.BackgroundColor3 = Color3.fromRGB(r, g, b)
        
        local gradient = healthFill:FindFirstChildWhichIsA("UIGradient")
        if gradient then
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255, 0.2)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255, 0.05)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0, 0.1))
            })
        end
    end
    
    if healthText then
        healthText.Text = string.format("%.0f/%.0f", health, maxHealth)
    end
    
    if _G.ShowHealth and IsInRange(v) and hum.Health > 0 and ESPEnabled then
        healthGui.Enabled = true
        local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("Head")
        if root then
            healthGui.Adornee = root
        end
    else
        healthGui.Enabled = false
    end
end

-- Box Handle Adornment
local Box = Instance.new("BoxHandleAdornment")
Box.Name = "nilBox"
Box.Size = Vector3.new(1, 2, 1)
Box.Color3 = Color3.new(100 / 255, 100 / 255, 100 / 255)
Box.Transparency = 0.7
Box.ZIndex = 0
Box.AlwaysOnTop = false
Box.Visible = false

-- NameTag
local NameTag = Instance.new("BillboardGui")
NameTag.Name = "nilNameTag"
NameTag.Enabled = false
NameTag.Size = UDim2.new(0, 200, 0, 50)
NameTag.AlwaysOnTop = true
NameTag.StudsOffset = Vector3.new(0, 1.8, 0)
local Tag = Instance.new("TextLabel", NameTag)
Tag.Name = "Tag"
Tag.BackgroundTransparency = 1
Tag.Position = UDim2.new(0, -50, 0, 0)
Tag.Size = UDim2.new(0, 300, 0, 20)
Tag.TextSize = 15
Tag.TextColor3 = Color3.new(100 / 255, 100 / 255, 100 / 255)
Tag.TextStrokeColor3 = Color3.new(0 / 255, 0 / 255, 0 / 255)
Tag.TextStrokeTransparency = 0.4
Tag.Text = "nil"
Tag.Font = Enum.Font.SourceSansBold
Tag.TextScaled = false

local LoadCharacter = function(v)
    if v == LocalPlayer then return end
    
    repeat task.wait() until v.Character ~= nil
    v.Character:WaitForChild("Humanoid")
    local vHolder = Holder:FindFirstChild(v.Name)
    if not vHolder then return end
    vHolder:ClearAllChildren()
    
    local b = Box:Clone()
    b.Name = v.Name .. "Box"
    b.Adornee = v.Character
    b.Parent = vHolder
    
    local t = NameTag:Clone()
    t.Name = v.Name .. "NameTag"
    t.Enabled = true
    t.Parent = vHolder
    t.Adornee = v.Character:WaitForChild("Head", 5)
    if not t.Adornee then
        return UnloadCharacter(v)
    end
    
    local healthGui = CreateHealthBar(v)
    healthGui.Parent = vHolder
    local root = v.Character:FindFirstChild("HumanoidRootPart") or v.Character:FindFirstChild("Torso") or v.Character:FindFirstChild("Head")
    if root then
        healthGui.Adornee = root
    end
    
    if IsInRange(v) and ESPEnabled then
        b.Visible = true
        t.Enabled = true
        healthGui.Enabled = _G.ShowHealth
    else
        b.Visible = false
        t.Enabled = false
        healthGui.Enabled = false
    end
    
    t.Tag.Text = v.Name
    b.Color3 = Color3.new(v.TeamColor.r, v.TeamColor.g, v.TeamColor.b)
    t.Tag.TextColor3 = Color3.new(v.TeamColor.r, v.TeamColor.g, v.TeamColor.b)
    
    local Update
    local UpdateNameTag = function()
        if not pcall(function()
            v.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            UpdateHealthBar(v)
        end) then
            Update:Disconnect()
        end
    end
    UpdateNameTag()
    Update = v.Character.Humanoid.Changed:Connect(UpdateNameTag)
end

local UnloadCharacter = function(v)
    local vHolder = Holder:FindFirstChild(v.Name)
    if vHolder then
        vHolder:ClearAllChildren()
    end
end

local LoadPlayer = function(v)
    if v == LocalPlayer then return end
    
    local vHolder = Instance.new("Folder", Holder)
    vHolder.Name = v.Name
    v.CharacterAdded:Connect(function()
        pcall(LoadCharacter, v)
    end)
    v.CharacterRemoving:Connect(function()
        pcall(UnloadCharacter, v)
    end)
    v.Changed:Connect(function(prop)
        if prop == "TeamColor" then
            UnloadCharacter(v)
            task.wait()
            LoadCharacter(v)
        end
    end)
    LoadCharacter(v)
end

local UnloadPlayer = function(v)
    UnloadCharacter(v)
    local vHolder = Holder:FindFirstChild(v.Name)
    if vHolder then
        vHolder:Destroy()
    end
end

-- Load ESP
for i,v in pairs(Players:GetPlayers()) do
    task.spawn(function() pcall(LoadPlayer, v) end)
end

Players.PlayerAdded:Connect(function(v)
    pcall(LoadPlayer, v)
end)

Players.PlayerRemoving:Connect(function(v)
    pcall(UnloadPlayer, v)
end)

LocalPlayer.NameDisplayDistance = 0

-- Cập nhật ESP
task.spawn(function()
    while task.wait(0.2) do
        local localChar = LocalPlayer.Character
        if not localChar then continue end
        
        for _, v in pairs(Players:GetPlayers()) do
            if v == LocalPlayer then continue end
            
            local vHolder = Holder:FindFirstChild(v.Name)
            if not vHolder then continue end
            
            local box = vHolder:FindFirstChild(v.Name .. "Box")
            local nametag = vHolder:FindFirstChild(v.Name .. "NameTag")
            local healthGui = vHolder:FindFirstChild(v.Name .. "HealthBar")
            
            if ESPEnabled and IsInRange(v) then
                if box then box.Visible = true end
                if nametag then nametag.Enabled = true end
                if healthGui then 
                    healthGui.Enabled = _G.ShowHealth
                    UpdateHealthBar(v)
                end
            else
                if box then box.Visible = false end
                if nametag then nametag.Enabled = false end
                if healthGui then healthGui.Enabled = false end
            end
        end
    end
end)

-- Highlight ESP
if _G.Reantheajfdfjdgs then
else
    _G.Reantheajfdfjdgs = ":suifayhgvsdghfsfkajewfrhk321rk213kjrgkhj432rj34f67df"
    
    function esp(target, color)
        if target == LocalPlayer then return end
        
        if target.Character then
            if not IsInRange(target) or not ESPEnabled then
                local highlight = target.Character:FindFirstChild("GetReal")
                if highlight then 
                    highlight.Enabled = false
                end
                return
            end
            
            if not target.Character:FindFirstChild("GetReal") then
                local highlight = Instance.new("Highlight")
                highlight.RobloxLocked = true
                highlight.Name = "GetReal"
                highlight.Adornee = target.Character
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.FillColor = color
                highlight.FillTransparency = 0.5
                highlight.OutlineColor = color
                highlight.OutlineTransparency = 0.3
                highlight.Parent = target.Character
            else
                target.Character.GetReal.FillColor = color
                target.Character.GetReal.OutlineColor = color
                target.Character.GetReal.Enabled = true
            end
        end
    end
    
    task.spawn(function()
        local updateCount = 0
        while task.wait() do
            updateCount = updateCount + 1
            if updateCount % 2 == 0 then
                for i, v in pairs(Players:GetPlayers()) do
                    if v ~= LocalPlayer then
                        esp(v, _G.UseTeamColor and v.TeamColor.Color or ((LocalPlayer.TeamColor == v.TeamColor) and _G.FriendColor or _G.EnemyColor))
                    end
                end
            end
        end
    end)
end

-- Bắt phím P để toggle ESP
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.P then
        ToggleESP()
    end
end)

print("[ESP] ESP System Loaded with 300m limit and Health Bar!")
print("[ESP] Press P to toggle ESP ON/OFF")

-- ===== AIMBOT SYSTEM =====
local __a1b2c3 = setmetatable({}, {
    __index = function(__d4e5f6, __g7h8i9)
        local __j0k1l2, __m3n4o5 = pcall(function()
            return game:GetService(__g7h8i9)
        end)
        if __m3n4o5 then
            return cloneref(__m3n4o5)
        end
        return nil
    end
})

local __p6q7r8 = getgenv()
if __p6q7r8.__s9t0u1 then
    print("[LOG] Shutting down previous instance...")
    __p6q7r8.__s9t0u1:Shutdown()
end

local __v2w3x4 = __a1b2c3.Players
local __y5z6a7 = __a1b2c3.RunService
local __b8c9d0 = __a1b2c3.ReplicatedStorage
local __e1f2g3 = __a1b2c3.Workspace
local __h4i5j6 = __a1b2c3.UserInputService
local __k7l8m9 = __v2w3x4.LocalPlayer
local __n0o1p2 = __e1f2g3.CurrentCamera
local __q3r4s5 = __k7l8m9.PlayerScripts
local __t6u7v8 = require(__q3r4s5.Modules.ItemTypes.Gun)
local __w9x0y1 = require(__b8c9d0.Modules.Utility)

local __z2a3b4 = setmetatable({}, {
    __index = function(_, __c5d6e7)
        local __f8g9h0 = __k7l8m9.Character
        if not __f8g9h0 then return nil end
        if __c5d6e7 == "__root" then
            return __f8g9h0:FindFirstChild("HumanoidRootPart")
        elseif __c5d6e7 == "__head" then
            return __f8g9h0:FindFirstChild("Head")
        end
        return nil
    end
})

__p6q7r8.__s9t0u1 = {}

do
    local __i1j2k3 = __p6q7r8.__s9t0u1
    
    print("[LOG] Aimbot initialized. Waiting for setup...")

    function __i1j2k3:__init()
        print("[LOG] Initializing aimbot...")
        self.__active = true
        self.__target = nil
        self.__desync = false
        self.__conn1 = nil
        self.__conn2 = nil
        self.__task1 = nil
        self.__oldfunc = nil
        self.__maxDistance = 300
        
        self:__setup()
        print("[LOG] Aimbot setup complete!")
    end

    function __i1j2k3:__setup()
        print("[LOG] Setting up aimbot connections...")
        
        self.__conn1 = __y5z6a7.Heartbeat:Connect(function()
            if not self.__active or not AimbotEnabled then 
                self.__target = nil
                return 
            end
            self.__target = self:__find()
        end)

        local __l4m5n6 = __t6u7v8.StartShooting
        self.__oldfunc = __l4m5n6
        __t6u7v8.StartShooting = function(__o7p8q9, ...)
            local __r0s1t2 = {__l4m5n6(__o7p8q9, ...)}
            if not __o7p8q9.ClientFighter or not __o7p8q9.ClientFighter.IsLocalPlayer then
                return unpack(__r0s1t2)
            end

            local __u3v4w5 = __r0s1t2[3]
            if not __u3v4w5 or typeof(__u3v4w5) ~= "table" then
                return unpack(__r0s1t2)
            end

            __r0s1t2[4] = true
            local __x6y7z8 = self.__target

            if not self.__active or not AimbotEnabled or not __x6y7z8 or not __x6y7z8.Character then
                return unpack(__r0s1t2)
            end

            if not self.__desync or self.__curr ~= __x6y7z8 then
                self:__desync_start(__x6y7z8)
                task.wait(0.1)
            end

            if self.__task1 then
                task.cancel(self.__task1)
                self.__task1 = nil
            end

            local __a9b0c1 = __x6y7z8.Character:FindFirstChild("Head")
            if not __a9b0c1 then 
                return unpack(__r0s1t2) 
            end

            local __d2e3f4 = __a9b0c1.Position
            local __g5h6i7 = __a9b0c1.CFrame
            
            local randomOffset = Vector3.new(
                (math.random() - 0.5) * 1.2,
                (math.random() - 0.5) * 1.2,
                (math.random() - 0.5) * 1.2
            )
            local __j8k9l0 = __d2e3f4 + randomOffset
            local __m1n2o3 = CFrame.lookAt(__j8k9l0, __d2e3f4)
            local __p4q5r6 = __g5h6i7:ToObjectSpace(CFrame.new(__d2e3f4 + randomOffset))

            __u3v4w5[utf8.char(0)] = __w9x0y1:EncodeCFrame(CFrame.new(__j8k9l0, __d2e3f4) * CFrame.Angles(__m1n2o3:ToOrientation()))
            __u3v4w5[utf8.char(1)] = __w9x0y1:EncodeCFrame(CFrame.new(__d2e3f4) * CFrame.Angles(__m1n2o3:ToOrientation()))
            __u3v4w5[utf8.char(2)] = __a9b0c1
            __u3v4w5[utf8.char(3)] = __w9x0y1:EncodeCFrame(__p4q5r6)

            self.__task1 = task.delay(0.15, function()
                self:__desync_stop()
            end)

            return unpack(__r0s1t2)
        end
        
        -- Bắt phím 0 để toggle aimbot
        __h4i5j6.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            if input.KeyCode == Enum.KeyCode.Zero then
                ToggleAimbotGlobal()
            end
        end)
        
        print("[LOG] Aimbot hooked! Press 0 to toggle ON/OFF")
    end

    function __i1j2k3:__find()
        local myChar = __k7l8m9.Character
        if not myChar then return nil end
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return nil end
       
        local closest = nil
        local closestDist = math.huge

        for _, player in next, __v2w3x4:GetPlayers() do
            if player == __k7l8m9 then continue end
            if player:GetAttribute("TeamID") == __k7l8m9:GetAttribute("TeamID") then continue end
           
            local char = player.Character
            if not char then continue end

            local root = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            
            if not (root and head and hum and hum.Health > 0) then continue end
           
            local dist = (myRoot.Position - root.Position).Magnitude
            
            if dist > self.__maxDistance then continue end
            
            if dist < closestDist then
                closestDist = dist
                closest = player
            end
        end
        
        return closest
    end

    function __i1j2k3:__desync_start(__c3d4e5)
        if self.__conn2 then self.__conn2:Disconnect() end
        self.__desync = true
        self.__curr = __c3d4e5

        self.__conn2 = __y5z6a7.Heartbeat:Connect(function()
            if not self.__desync or not AimbotEnabled then 
                self:__desync_stop()
                return 
            end
            local __f6g7h8 = __z2a3b4.__root
            if not __f6g7h8 then return end

            local __i9j0k1 = __c3d4e5.Character and __c3d4e5.Character:FindFirstChild("HumanoidRootPart")
            if not __i9j0k1 then
                self:__desync_stop()
                return
            end

            local __l2m3n4 = __f6g7h8.CFrame
            local __o5p6q7 = __f6g7h8.Velocity
            local __r8s9t0 = __f6g7h8.RotVelocity

            __f6g7h8.CFrame = __i9j0k1.CFrame * CFrame.new(0, -5, 0)

            __y5z6a7:BindToRenderStep("__restore", 101, function()
                __f6g7h8.CFrame = __l2m3n4
                __f6g7h8.Velocity = __o5p6q7
                __f6g7h8.RotVelocity = __r8s9t0
                __y5z6a7:UnbindFromRenderStep("__restore")
            end)
        end)
    end

    function __i1j2k3:__desync_stop()
        self.__desync = false
        self.__curr = nil
        if self.__conn2 then
            self.__conn2:Disconnect()
            self.__conn2 = nil
        end
    end

    function __i1j2k3:Shutdown()
        print("[LOG] Shutting down aimbot...")
        self.__active = false
        if self.__conn1 then self.__conn1:Disconnect() end
        if self.__conn2 then self.__conn2:Disconnect() end
        if self.__task1 then task.cancel(self.__task1) end
        if self.__oldfunc then
            __t6u7v8.StartShooting = self.__oldfunc
        end
        print("[LOG] Aimbot shutdown complete")
    end

    __i1j2k3:__init()
end

-- ===== KILL LOG SYSTEM =====
local KillListFrame = nil
local KillListContainer = nil
local KillListVisible = false
local KillListData = {}
local KillListCount = 0
local KilledPlayers = {}

local function CreateKillListUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KillLogsGUI"
    screenGui.Parent = game.CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "KillListMain"
    mainFrame.Size = UDim2.new(0, 400, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(255, 50, 50)
    mainFrame.ClipsDescendants = true
    mainFrame.Visible = false
    mainFrame.Parent = screenGui
    
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    titleBar.BackgroundTransparency = 0
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 1, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "☠ KILL LIST ☠"
    title.TextColor3 = Color3.fromRGB(255, 50, 50)
    title.TextSize = 20
    title.Font = Enum.Font.SourceSansBold
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.TextYAlignment = Enum.TextYAlignment.Center
    title.Parent = titleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 1, 0)
    closeBtn.Position = UDim2.new(1, -35, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 20
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.Parent = titleBar
    closeBtn.MouseButton1Click:Connect(function()
        KillListVisible = false
        mainFrame.Visible = false
    end)
    
    local countLabel = Instance.new("TextLabel")
    countLabel.Name = "CountLabel"
    countLabel.Size = UDim2.new(1, 0, 0, 30)
    countLabel.Position = UDim2.new(0, 0, 0, 40)
    countLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    countLabel.BackgroundTransparency = 0.3
    countLabel.Text = "Total Kills: 0"
    countLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    countLabel.TextSize = 15
    countLabel.Font = Enum.Font.SourceSansBold
    countLabel.TextXAlignment = Enum.TextXAlignment.Center
    countLabel.TextYAlignment = Enum.TextYAlignment.Center
    countLabel.Parent = mainFrame
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScrollFrame"
    scrollFrame.Size = UDim2.new(1, 0, 1, -70)
    scrollFrame.Position = UDim2.new(0, 0, 0, 70)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 5
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.Parent = mainFrame
    
    local uiList = Instance.new("UIListLayout")
    uiList.Parent = scrollFrame
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Padding = UDim.new(0, 3)
    
    return screenGui, mainFrame, scrollFrame
end

local function CreateKillEntry(playerName, damage, time)
    local entry = Instance.new("Frame")
    entry.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    entry.BackgroundTransparency = 0.2
    entry.BorderSizePixel = 1
    entry.BorderColor3 = Color3.fromRGB(60, 60, 80)
    entry.Size = UDim2.new(1, -10, 0, 38)
    entry.Parent = nil
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255, 0.05)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255, 0.05))
    })
    gradient.Parent = entry
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 35, 1, 0)
    icon.Position = UDim2.new(0, 5, 0, 0)
    icon.BackgroundTransparency = 1
    icon.Text = "☠"
    icon.TextSize = 18
    icon.TextColor3 = Color3.fromRGB(255, 50, 50)
    icon.Font = Enum.Font.SourceSansBold
    icon.TextXAlignment = Enum.TextXAlignment.Center
    icon.TextYAlignment = Enum.TextYAlignment.Center
    icon.Parent = entry
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0.4, -10, 1, 0)
    nameLabel.Position = UDim2.new(0, 45, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = playerName
    nameLabel.TextSize = 14
    nameLabel.TextColor3 = Color3.fromRGB(255, 120, 120)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextYAlignment = Enum.TextYAlignment.Center
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.Parent = entry
    
    local damageLabel = Instance.new("TextLabel")
    damageLabel.Size = UDim2.new(0.25, 0, 1, 0)
    damageLabel.Position = UDim2.new(0.45, 0, 0, 0)
    damageLabel.BackgroundTransparency = 1
    damageLabel.Text = "-" .. damage .. " HP"
    damageLabel.TextSize = 13
    damageLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
    damageLabel.TextXAlignment = Enum.TextXAlignment.Center
    damageLabel.TextYAlignment = Enum.TextYAlignment.Center
    damageLabel.Font = Enum.Font.SourceSansBold
    damageLabel.Parent = entry
    
    local timeLabel = Instance.new("TextLabel")
    timeLabel.Size = UDim2.new(0.25, 0, 1, 0)
    timeLabel.Position = UDim2.new(0.7, 0, 0, 0)
    timeLabel.BackgroundTransparency = 1
    timeLabel.Text = time
    timeLabel.TextSize = 12
    timeLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
    timeLabel.TextXAlignment = Enum.TextXAlignment.Center
    timeLabel.TextYAlignment = Enum.TextYAlignment.Center
    timeLabel.Font = Enum.Font.SourceSans
    timeLabel.Parent = entry
    
    return entry
end

local function AddKillToList(playerName, damage)
    if not KillListFrame then
        local screenGui, mainFrame, scrollFrame = CreateKillListUI()
        KillListFrame = mainFrame
        KillListContainer = screenGui
    end
    
    if not KillListFrame then return end
    
    KillListCount = KillListCount + 1
    local timeStr = string.format("%02d:%02d:%02d", math.floor(os.time() / 3600) % 24, math.floor(os.time() / 60) % 60, os.time() % 60)
    table.insert(KillListData, 1, {name = playerName, damage = damage, time = timeStr})
    
    if #KillListData > 50 then
        table.remove(KillListData)
    end
    
    if KillListVisible then
        UpdateKillListUI()
    end
    
    print(string.format("kill %s %d", playerName, damage))
end

local function UpdateKillListUI()
    if not KillListFrame then return end
    
    local scrollFrame = KillListFrame:FindFirstChild("ScrollFrame")
    if not scrollFrame then return end
    
    local countLabel = KillListFrame:FindFirstChild("CountLabel")
    if countLabel then
        countLabel.Text = "Total Kills: " .. KillListCount
    end
    
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") and child ~= scrollFrame:FindFirstChild("UIListLayout") then
            child:Destroy()
        end
    end
    
    for _, data in ipairs(KillListData) do
        local entry = CreateKillEntry(data.name, data.damage, data.time)
        entry.Parent = scrollFrame
    end
end

function ToggleKillList()
    if not KillListFrame then
        local screenGui, mainFrame, scrollFrame = CreateKillListUI()
        KillListFrame = mainFrame
        KillListContainer = screenGui
    end
    
    KillListVisible = not KillListVisible
    KillListFrame.Visible = KillListVisible
    
    if KillListVisible then
        UpdateKillListUI()
    end
end

-- Bắt phím Right Shift để mở Kill List
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        ToggleKillList()
    end
end)

-- ===== KILL DETECTION =====
local function SetupKillDetection()
    local function CheckAllPlayers()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not KilledPlayers[player.Name] then
                local char = player.Character
                if char then
                    local hum = char:FindFirstChildWhichIsA("Humanoid")
                    if hum then
                        hum.Died:Connect(function()
                            if not KilledPlayers[player.Name] then
                                KilledPlayers[player.Name] = true
                                AddKillToList(player.Name, 100)
                                print("[KILL] You killed:", player.Name)
                            end
                        end)
                        
                        if hum.Health <= 0 and not KilledPlayers[player.Name] then
                            KilledPlayers[player.Name] = true
                            AddKillToList(player.Name, 100)
                            print("[KILL] You killed:", player.Name)
                        end
                    end
                end
            end
        end
    end
    
    CheckAllPlayers()
    
    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            player.CharacterAdded:Connect(function(char)
                task.wait(0.5)
                local hum = char:FindFirstChildWhichIsA("Humanoid")
                if hum then
                    hum.Died:Connect(function()
                        if not KilledPlayers[player.Name] then
                            KilledPlayers[player.Name] = true
                            AddKillToList(player.Name, 100)
                            print("[KILL] You killed:", player.Name)
                        end
                    end)
                end
            end)
        end
    end)
    
    task.spawn(function()
        while true do
            task.wait(1)
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and not KilledPlayers[player.Name] then
                    local char = player.Character
                    if char then
                        local hum = char:FindFirstChildWhichIsA("Humanoid")
                        if hum and hum.Health <= 0 then
                            KilledPlayers[player.Name] = true
                            AddKillToList(player.Name, 100)
                            print("[KILL] You killed:", player.Name)
                        end
                    end
                end
            end
        end
    end)
end

task.spawn(function()
    task.wait(1)
    SetupKillDetection()
    print("[LOG] Kill Log System: Active (Press RIGHT SHIFT to open)")
end)

print("[LOG] === ALL SYSTEMS LOADED ===")
print("[LOG] ESP: OFF (Default) - Press P to toggle ON")
print("[LOG] Aimbot: OFF (Default) - HEAD RANDOM - Press 0 to toggle ON")
print("[LOG] Keybinds Menu: Fixed position - Cannot move")
print("[LOG] Kill Log: Press RIGHT SHIFT to open")
--!native
--!optimize 2

if game.GameId == 6035872082 then
    -- Biến điều khiển bật/tắt (mặc định là TẮT)
    local ScriptEnabled = false  -- Đổi từ true thành false
    
    local Storage = game:GetService("ReplicatedStorage")
    local Items = require(Storage.Modules.ItemLibrary).Items

    -- ====================== MAX SPEED UNLOCKED ======================
    local gunExceptions = {
        ["Sniper"] = false,
        ["Crossbow"] = false,
        ["Bow"] = false,
        ["RPG"] = false,
    }

    -- TỐC ĐỘ MAX: 0.0001 (nhanh gấp 10 lần)
    -- Nếu muốn nhanh hơn nữa thì đổi thành 0.00001 (gấp 100 lần)
    local MAX_SPEED = 0.000000000000001  

    -- Lưu giá trị gốc để có thể khôi phục
    local originalValues = {}

    -- Backup values trước khi thay đổi
    for name, data in pairs(Items) do
        if typeof(data) == "table" then
            originalValues[name] = {}
            if data.ShootSpread then originalValues[name].ShootSpread = data.ShootSpread end
            if data.ShootAccuracy then originalValues[name].ShootAccuracy = data.ShootAccuracy end
            if data.ShootRecoil then originalValues[name].ShootRecoil = data.ShootRecoil end
            if data.ShootCooldown then originalValues[name].ShootCooldown = data.ShootCooldown end
            if data.ShootBurstCooldown then originalValues[name].ShootBurstCooldown = data.ShootBurstCooldown end
            if data.AttackCooldown then originalValues[name].AttackCooldown = data.AttackCooldown end
            if data.SwingCooldown then originalValues[name].SwingCooldown = data.SwingCooldown end
            if data.MeleeCooldown then originalValues[name].MeleeCooldown = data.MeleeCooldown end
            if data.Cooldown then originalValues[name].Cooldown = data.Cooldown end
            if data.RecoveryTime then originalValues[name].RecoveryTime = data.RecoveryTime end
            if data.ResetTime then originalValues[name].ResetTime = data.ResetTime end
        end
    end

    -- Hàm áp dụng max speed
    local function ApplyMaxSpeed()
        for name, data in pairs(Items) do
            if typeof(data) == "table" and not gunExceptions[name] then
                if data.ShootSpread then data.ShootSpread = 0 end
                if data.ShootAccuracy then data.ShootAccuracy = 0 end
                if data.ShootRecoil then data.ShootRecoil = 0 end
                if data.ShootCooldown then data.ShootCooldown = MAX_SPEED end
                if data.ShootBurstCooldown then data.ShootBurstCooldown = MAX_SPEED end
            end
        end

        -- ====================== FAST MELEE ======================
        for name, data in pairs(Items) do
            if typeof(data) == "table" then
                if data.AttackCooldown then data.AttackCooldown = MAX_SPEED end
                if data.SwingCooldown then data.SwingCooldown = MAX_SPEED end
                if data.MeleeCooldown then data.MeleeCooldown = MAX_SPEED end
                if data.Cooldown then data.Cooldown = MAX_SPEED end
                if data.RecoveryTime then data.RecoveryTime = MAX_SPEED end
                if data.ResetTime then data.ResetTime = MAX_SPEED end
            end
        end
        print("⚡ MAX SPEED ENABLED ⚡")
    end

    -- Hàm khôi phục giá trị gốc
    local function RestoreOriginalValues()
        for name, data in pairs(Items) do
            if typeof(data) == "table" and originalValues[name] then
                if originalValues[name].ShootSpread ~= nil then data.ShootSpread = originalValues[name].ShootSpread end
                if originalValues[name].ShootAccuracy ~= nil then data.ShootAccuracy = originalValues[name].ShootAccuracy end
                if originalValues[name].ShootRecoil ~= nil then data.ShootRecoil = originalValues[name].ShootRecoil end
                if originalValues[name].ShootCooldown ~= nil then data.ShootCooldown = originalValues[name].ShootCooldown end
                if originalValues[name].ShootBurstCooldown ~= nil then data.ShootBurstCooldown = originalValues[name].ShootBurstCooldown end
                if originalValues[name].AttackCooldown ~= nil then data.AttackCooldown = originalValues[name].AttackCooldown end
                if originalValues[name].SwingCooldown ~= nil then data.SwingCooldown = originalValues[name].SwingCooldown end
                if originalValues[name].MeleeCooldown ~= nil then data.MeleeCooldown = originalValues[name].MeleeCooldown end
                if originalValues[name].Cooldown ~= nil then data.Cooldown = originalValues[name].Cooldown end
                if originalValues[name].RecoveryTime ~= nil then data.RecoveryTime = originalValues[name].RecoveryTime end
                if originalValues[name].ResetTime ~= nil then data.ResetTime = originalValues[name].ResetTime end
            end
        end
        print("🔄 MAX SPEED DISABLED - Restored original values")
    end

    -- Xử lý phím 0 để bật/tắt
    game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.Zero then
            ScriptEnabled = not ScriptEnabled
            if ScriptEnabled then
                ApplyMaxSpeed()
            else
                RestoreOriginalValues()
            end
        end
    end)

    -- KHÔNG áp dụng max speed ban đầu (đã comment dòng này)
    -- ApplyMaxSpeed()  -- <--- ĐÃ COMMENT để mặc định TẮT

    print("⚡ MAX SPEED SCRIPT LOADED - Press '0' to ENABLE ⚡")
    print("📌 Default: OFF - Press '0' to toggle ON/OFF")
end
-- =====================================================
-- THANH MÁU CÁ NHÂN - ĐỔI MÀU THEO MỨC MÁU CỤ THỂ
-- Nằm dưới, căn giữa, chữ đậm, nền tối
-- TIM ĐẬP 2 NHỊP LIÊN TIẾP - KHÔNG BAO GIỜ DỪNG
-- =====================================================

local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")

-- Hàm tìm Humanoid
local function getHumanoid(char)
    if not char then return nil end
    
    local hum = char:FindFirstChild("Humanoid")
    if hum then return hum end
    
    for _, child in pairs(char:GetChildren()) do
        if child:IsA("Humanoid") then
            return child
        end
    end
    
    for _, child in pairs(char:GetDescendants()) do
        if child:IsA("Humanoid") then
            return child
        end
    end
    
    return nil
end

-- Hàm lấy màu dựa trên phần trăm máu (CÁC MỨC RÕ RÀNG)
local function getHealthColor(percent)
    -- Các mức máu với màu sắc cụ thể
    if percent >= 0.9 then
        -- 90-100%: Xanh lá đậm (Khỏe mạnh)
        return Color3.fromRGB(50, 230, 80)
    elseif percent >= 0.7 then
        -- 70-90%: Xanh lá nhạt (Hơi mất máu)
        return Color3.fromRGB(100, 220, 100)
    elseif percent >= 0.5 then
        -- 50-70%: Xanh lá vàng (Mất máu vừa)
        return Color3.fromRGB(180, 210, 60)
    elseif percent >= 0.35 then
        -- 35-50%: Vàng cam (Nguy hiểm vừa)
        return Color3.fromRGB(240, 180, 40)
    elseif percent >= 0.2 then
        -- 20-35%: Cam (Nguy hiểm)
        return Color3.fromRGB(240, 130, 30)
    elseif percent >= 0.1 then
        -- 10-20%: Cam đỏ (Rất nguy hiểm)
        return Color3.fromRGB(230, 80, 30)
    else
        -- 0-10%: Đỏ (Cực kỳ nguy hiểm - sắp chết)
        return Color3.fromRGB(220, 30, 30)
    end
end

-- Tạo GUI
local function createGUI()
    -- Xóa GUI cũ nếu có
    local oldGUI = player.PlayerGui:FindFirstChild("CustomHealthBar")
    if oldGUI then oldGUI:Destroy() end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CustomHealthBar"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player.PlayerGui
    
    -- Khung nền (DÀI HƠN)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 42)
    frame.Position = UDim2.new(0.5, -200, 1, -65)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.6
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = screenGui
    
    -- Bo góc
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    -- Thanh máu nền
    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, 0, 0.6, 0)
    barBg.Position = UDim2.new(0, 0, 0.5, -11)
    barBg.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    barBg.BackgroundTransparency = 0.5
    barBg.BorderSizePixel = 0
    barBg.Parent = frame
    
    local cornerBg = Instance.new("UICorner")
    cornerBg.CornerRadius = UDim.new(0, 6)
    cornerBg.Parent = barBg
    
    -- Thanh máu chính
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 1, 0)
    bar.BackgroundColor3 = Color3.fromRGB(50, 230, 80)  -- Mặc định xanh
    bar.BorderSizePixel = 0
    bar.Parent = barBg
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 6)
    barCorner.Parent = bar
    
    -- Icon tim (Container để scale) - KÍCH THƯỚC NHỎ HƠN
    local heartContainer = Instance.new("Frame")
    heartContainer.Size = UDim2.new(0, 22, 0, 22)
    heartContainer.Position = UDim2.new(0, 10, 0.5, -11)
    heartContainer.BackgroundTransparency = 1
    heartContainer.ZIndex = 2
    heartContainer.Parent = frame
    
    -- Icon tim chính
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.Position = UDim2.new(0, 0, 0, 0)
    icon.BackgroundTransparency = 1
    icon.Text = "❤️"
    icon.TextScaled = true
    icon.Font = Enum.Font.GothamBold
    icon.TextColor3 = Color3.fromRGB(50, 230, 80)
    icon.ZIndex = 2
    icon.Parent = heartContainer
    
    -- Label hiển thị SỐ MÁU - DỊCH SANG PHẢI
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -75, 1, 0)
    label.Position = UDim2.new(0, 38, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBlack
    label.Text = "100/100"
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.ZIndex = 2
    label.Parent = frame
    
    -- Label hiển thị %
    local percentLabel = Instance.new("TextLabel")
    percentLabel.Size = UDim2.new(0, 60, 1, 0)
    percentLabel.Position = UDim2.new(1, -65, 0, 0)
    percentLabel.BackgroundTransparency = 1
    percentLabel.TextColor3 = Color3.fromRGB(50, 230, 80)
    percentLabel.TextScaled = true
    percentLabel.Font = Enum.Font.GothamBlack
    percentLabel.Text = "100%"
    percentLabel.TextXAlignment = Enum.TextXAlignment.Right
    percentLabel.TextYAlignment = Enum.TextYAlignment.Center
    percentLabel.ZIndex = 2
    percentLabel.Parent = frame
    
    return {
        frame = frame,
        bar = bar,
        barBg = barBg,
        label = label,
        percentLabel = percentLabel,
        icon = icon,
        heartContainer = heartContainer,
        gui = screenGui
    }
end

-- ====== HIỆU ỨNG TIM ĐẬP 2 NHỊP LIÊN TIẾP - KHÔNG BAO GIỜ DỪNG ======
local heartBeatConnection = nil
local beatTimer = 0

local function startHeartBeat(gui)
    -- Dừng hiệu ứng cũ nếu có
    if heartBeatConnection then
        heartBeatConnection:Disconnect()
        heartBeatConnection = nil
    end
    
    -- Reset timer
    beatTimer = 0
    
    -- Lưu kích thước ban đầu
    local originalSize = gui.heartContainer.Size
    
    -- Tham số nhịp tim - 72 BPM
    local bpm = 72
    local cycleDuration = 60 / bpm -- 0.833 giây
    
    -- Tạo hiệu ứng tim đập 2 nhịp
    heartBeatConnection = RunService.Heartbeat:Connect(function(deltaTime)
        -- Tăng timer liên tục
        beatTimer = beatTimer + deltaTime
        
        -- Giữ timer trong chu kỳ
        if beatTimer >= cycleDuration then
            beatTimer = beatTimer - cycleDuration
        end
        
        -- Tính vị trí trong chu kỳ (0 -> 1)
        local cyclePos = beatTimer / cycleDuration
        
        -- Tính scale
        local scale = 1.0
        local glowFactor = 1.0
        
        -- Định nghĩa các mốc thời gian trong chu kỳ
        local beat1_start = 0.0
        local beat1_end = 0.12 / cycleDuration
        local beat2_start = (0.12 + 0.08) / cycleDuration
        local beat2_end = (0.12 + 0.08 + 0.12) / cycleDuration
        
        -- KIỂM TRA NHỊP ĐẬP 1
        if cyclePos >= beat1_start and cyclePos < beat1_end then
            local progress = (cyclePos - beat1_start) / (beat1_end - beat1_start)
            
            if progress < 0.3 then
                local p = progress / 0.3
                scale = 1 + (p * 0.1)
                glowFactor = 1 + (p * 0.15)
            elseif progress < 0.6 then
                scale = 1.1
                glowFactor = 1.15
            else
                local p = (progress - 0.6) / 0.4
                scale = 1.1 - (p * 0.1)
                glowFactor = 1.15 - (p * 0.15)
            end
            
        -- KIỂM TRA NHỊP ĐẬP 2
        elseif cyclePos >= beat2_start and cyclePos < beat2_end then
            local progress = (cyclePos - beat2_start) / (beat2_end - beat2_start)
            
            if progress < 0.3 then
                local p = progress / 0.3
                scale = 1 + (p * 0.08)
                glowFactor = 1 + (p * 0.12)
            elseif progress < 0.6 then
                scale = 1.08
                glowFactor = 1.12
            else
                local p = (progress - 0.6) / 0.4
                scale = 1.08 - (p * 0.08)
                glowFactor = 1.12 - (p * 0.12)
            end
            
        else
            -- Nghỉ ngơi
            scale = 1.0
            glowFactor = 1.0
            
            -- Chuẩn bị cho nhịp tiếp theo
            if cyclePos > 0.85 then
                local prep = (cyclePos - 0.85) / 0.15
                scale = 1 + (prep * 0.02)
                glowFactor = 1 + (prep * 0.03)
            end
        end
        
        -- Áp dụng scale với giới hạn
        local finalScale = math.min(scale, 1.12)
        
        local newSize = UDim2.new(
            originalSize.X.Scale * finalScale,
            math.min(originalSize.X.Offset * finalScale, 26),
            originalSize.Y.Scale * finalScale,
            math.min(originalSize.Y.Offset * finalScale, 26)
        )
        
        gui.heartContainer.Size = newSize
        
        -- Cập nhật màu và glow
        local baseColor = gui.bar.BackgroundColor3
        local r = math.min(1, baseColor.R * glowFactor)
        local g = math.min(1, baseColor.G * glowFactor)
        local b = math.min(1, baseColor.B * glowFactor)
        gui.icon.TextColor3 = Color3.new(r, g, b)
    end)
end

-- ====== TỐI ƯU: Cập nhật chỉ khi cần ======
local lastHealth = -1
local lastMaxHealth = -1
local lastPercent = -1

-- Hàm cập nhật thanh máu (TỐI ƯU - KHÔNG LAG)
local function updateHealth(gui, humanoid)
    if not humanoid then return end
    
    local health = humanoid.Health
    local maxHealth = humanoid.MaxHealth
    
    if maxHealth <= 0 then
        if gui.bar.Size.X.Scale ~= 0 then
            gui.bar.Size = UDim2.new(0, 0, 1, 0)
        end
        if gui.label.Text ~= "0/0" then
            gui.label.Text = "0/0"
            gui.percentLabel.Text = "0%"
            gui.bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            gui.icon.TextColor3 = Color3.fromRGB(60, 60, 60)
            gui.percentLabel.TextColor3 = Color3.fromRGB(60, 60, 60)
        end
        return
    end
    
    local percent = math.clamp(health / maxHealth, 0, 1)
    
    -- CHỈ CẬP NHẬT KHI CÓ THAY ĐỔI
    local healthChanged = math.abs(health - lastHealth) > 0.1
    local maxChanged = maxHealth ~= lastMaxHealth
    local percentChanged = math.abs(percent - lastPercent) > 0.001
    
    if healthChanged or maxChanged then
        lastHealth = health
        lastMaxHealth = maxHealth
        
        -- Cập nhật thanh
        gui.bar.Size = UDim2.new(percent, 0, 1, 0)
        
        -- Cập nhật số máu
        local healthDisplay = string.format("%.0f", health)
        local maxDisplay = string.format("%.0f", maxHealth)
        gui.label.Text = healthDisplay .. "/" .. maxDisplay
        
        -- Cập nhật %
        gui.percentLabel.Text = string.format("%.0f%%", percent * 100)
        
        -- ĐỔI MÀU THEO MỨC MÁU
        if percentChanged then
            lastPercent = percent
            
            local color = getHealthColor(percent)
            gui.bar.BackgroundColor3 = color
            gui.icon.TextColor3 = color
            gui.percentLabel.TextColor3 = color
        end
    end
end

-- ====== BẮT ĐẦU CHẠY ======

local gui = createGUI()
local currentHumanoid = nil
local healthConnection = nil

-- Hàm kết nối với nhân vật
local function connectToCharacter(char)
    if not char then return end
    
    char:WaitForChild("Humanoid")
    
    local hum = getHumanoid(char)
    if not hum then 
        warn("Không tìm thấy Humanoid!")
        return 
    end
    
    currentHumanoid = hum
    lastHealth = -1
    lastMaxHealth = -1
    lastPercent = -1
    
    -- Cập nhật lần đầu
    updateHealth(gui, hum)
    
    -- Bắt đầu hiệu ứng tim đập
    startHeartBeat(gui)
    
    -- Lắng nghe thay đổi máu
    if healthConnection then
        healthConnection:Disconnect()
        healthConnection = nil
    end
    
    healthConnection = hum.HealthChanged:Connect(function()
        updateHealth(gui, hum)
    end)
end

-- Kết nối với nhân vật hiện tại
local character = player.Character
if character then
    connectToCharacter(character)
end

-- Khi nhân vật mới xuất hiện
player.CharacterAdded:Connect(function(newChar)
    if healthConnection then
        healthConnection:Disconnect()
        healthConnection = nil
    end
    
    -- Dừng tim đập cũ
    if heartBeatConnection then
        heartBeatConnection:Disconnect()
        heartBeatConnection = nil
    end
    
    task.wait(0.3)
    connectToCharacter(newChar)
    character = newChar
end)

-- Khi nhân vật bị xóa
player.CharacterRemoving:Connect(function()
    if healthConnection then
        healthConnection:Disconnect()
        healthConnection = nil
    end
    
    if heartBeatConnection then
        heartBeatConnection:Disconnect()
        heartBeatConnection = nil
    end
    
    if gui then
        gui.bar.Size = UDim2.new(0, 0, 1, 0)
        gui.label.Text = "0/0"
        gui.percentLabel.Text = "0%"
        gui.bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        gui.icon.TextColor3 = Color3.fromRGB(60, 60, 60)
        gui.percentLabel.TextColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

-- =====================================================
-- THÔNG BÁO KHỞI TẠO
-- =====================================================

print("✅ Thanh máu đã được kích hoạt!")
print("📍 Vị trí: Dưới cùng, căn giữa")
print("📏 Chiều dài: 400px (dài hơn)")
print("🌈 Đổi màu theo 7 mức máu rõ ràng")
print("❤️ Tim đập 2 nhịp liên tiếp - KHÔNG BAO GIỜ DỪNG!")
print("⚡ Tối ưu: Không lag!")

local notify = Instance.new("TextLabel")
notify.Size = UDim2.new(0, 350, 0, 30)
notify.Position = UDim2.new(0.5, -175, 0, 10)
notify.BackgroundColor3 = Color3.fromRGB(80, 220, 120)
notify.BackgroundTransparency = 0.3
notify.TextColor3 = Color3.fromRGB(255, 255, 255)
notify.Text = "❤️ Health Bar Active!"
notify.TextScaled = true
notify.Font = Enum.Font.GothamBold
notify.Parent = gui.gui

task.wait(3)
notify:Destroy()
-- =====================================================
-- HIỂN THỊ TỌA ĐỘ NGƯỜI CHƠI
-- Góc dưới bên phải màn hình
-- Đơn giản, gọn nhẹ
-- =====================================================

local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")

-- Tạo GUI
local function createCoordinateGUI()
    -- Xóa GUI cũ nếu có
    local oldGUI = player.PlayerGui:FindFirstChild("CoordinateDisplay")
    if oldGUI then oldGUI:Destroy() end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CoordinateDisplay"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player.PlayerGui
    
    -- Khung nền
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 180, 0, 35)
    frame.Position = UDim2.new(0, 1, 1, -102) -- Góc dưới bên phải
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.6
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    -- Bo góc
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    -- Label hiển thị tọa độ
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Text = "📍 0, 0, 0"
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.ZIndex = 2
    label.Parent = frame
    
    return {
        frame = frame,
        label = label,
        gui = screenGui
    }
end

-- Tạo GUI
local gui = createCoordinateGUI()

-- Biến lưu tọa độ cũ để tránh cập nhật quá nhiều
local lastPos = nil

-- Hàm cập nhật tọa độ
local function updateCoordinates()
    local character = player.Character
    if not character then
        gui.label.Text = "📍 0, 0, 0"
        return
    end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        gui.label.Text = "📍 0, 0, 0"
        return
    end
    
    local pos = rootPart.Position
    local roundedPos = Vector3.new(
        math.floor(pos.X + 0.5),
        math.floor(pos.Y + 0.5),
        math.floor(pos.Z + 0.5)
    )
    
    -- Chỉ cập nhật khi tọa độ thay đổi
    if lastPos == nil or (lastPos.X ~= roundedPos.X or lastPos.Y ~= roundedPos.Y or lastPos.Z ~= roundedPos.Z) then
        lastPos = roundedPos
        gui.label.Text = string.format("📍 %d, %d, %d", roundedPos.X, roundedPos.Y, roundedPos.Z)
    end
end

-- Cập nhật mỗi khi nhân vật di chuyển
local connection = RunService.Heartbeat:Connect(function()
    updateCoordinates()
end)

-- Khi nhân vật thay đổi
player.CharacterAdded:Connect(function()
    lastPos = nil
    task.wait(0.1)
    updateCoordinates()
end)

-- Khi nhân vật bị xóa
player.CharacterRemoving:Connect(function()
    gui.label.Text = "📍 0, 0, 0"
    lastPos = nil
end)

print("✅ Hiển thị tọa độ đã được kích hoạt!")
print("📍 Vị trí: Góc dưới bên phải màn hình")
-- =====================================================
-- HIỂN THỊ WIN STREAK + TOP STREAK + TÊN HIỂN THỊ
-- GÓC DƯỚI TRÁI - CHỮ TO DỄ ĐỌC
-- CẬP NHẬT THỜI GIAN THỰC
-- =====================================================

local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")

-- Tạo GUI hiển thị Streak
local function createStreakGUI()
    -- Xóa GUI cũ nếu có
    local oldGUI = player.PlayerGui:FindFirstChild("StreakDisplay")
    if oldGUI then oldGUI:Destroy() end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "StreakDisplay"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player.PlayerGui
    
    -- Khung nền - TĂNG KÍCH THƯỚC + ĐƯA XUỐNG GÓC DƯỚI TRÁI
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 190, 0, 65)  -- Tăng từ 160 lên 190, từ 58 lên 65
    frame.Position = UDim2.new(0, 1, 1, -66)  -- Góc dưới trái, cách mép 15px
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = screenGui
    
    -- Bo góc
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    -- ====== DÒNG 1: STREAK ======
    local streakFrame = Instance.new("Frame")
    streakFrame.Size = UDim2.new(1, 0, 0.5, 0)
    streakFrame.Position = UDim2.new(0, 0, 0, 0)
    streakFrame.BackgroundTransparency = 1
    streakFrame.Parent = frame
    
    -- Icon Win Streak
    local winIcon = Instance.new("TextLabel")
    winIcon.Size = UDim2.new(0, 22, 0, 22)  -- Tăng từ 20 lên 22
    winIcon.Position = UDim2.new(0, 4, 0.5, -11)
    winIcon.BackgroundTransparency = 1
    winIcon.Text = "🔥"
    winIcon.TextScaled = true
    winIcon.Font = Enum.Font.GothamBold
    winIcon.TextColor3 = Color3.fromRGB(255, 150, 0)
    winIcon.ZIndex = 2
    winIcon.Parent = streakFrame
    
    -- Label Win Streak
    local winLabel = Instance.new("TextLabel")
    winLabel.Size = UDim2.new(0, 45, 1, 0)  -- Tăng từ 40 lên 45
    winLabel.Position = UDim2.new(0, 30, 0, 0)
    winLabel.BackgroundTransparency = 1
    winLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    winLabel.TextScaled = true
    winLabel.Font = Enum.Font.GothamBlack
    winLabel.Text = "0"
    winLabel.TextXAlignment = Enum.TextXAlignment.Left
    winLabel.TextYAlignment = Enum.TextYAlignment.Center
    winLabel.ZIndex = 2
    winLabel.Parent = streakFrame
    
    -- Separator
    local separator = Instance.new("TextLabel")
    separator.Size = UDim2.new(0, 16, 1, 0)  -- Tăng từ 14 lên 16
    separator.Position = UDim2.new(0, 75, 0, 0)
    separator.BackgroundTransparency = 1
    separator.TextColor3 = Color3.fromRGB(80, 80, 80)
    separator.TextScaled = true
    separator.Font = Enum.Font.GothamBold
    separator.Text = "|"
    separator.TextXAlignment = Enum.TextXAlignment.Center
    separator.TextYAlignment = Enum.TextYAlignment.Center
    separator.ZIndex = 2
    separator.Parent = streakFrame
    
    -- Icon Top Streak
    local topIcon = Instance.new("TextLabel")
    topIcon.Size = UDim2.new(0, 22, 0, 22)  -- Tăng từ 20 lên 22
    topIcon.Position = UDim2.new(0, 95, 0.5, -11)
    topIcon.BackgroundTransparency = 1
    topIcon.Text = "👑"
    topIcon.TextScaled = true
    topIcon.Font = Enum.Font.GothamBold
    topIcon.TextColor3 = Color3.fromRGB(255, 215, 0)
    topIcon.ZIndex = 2
    topIcon.Parent = streakFrame
    
    -- Label Top Streak
    local topLabel = Instance.new("TextLabel")
    topLabel.Size = UDim2.new(0, 75, 1, 0)
    topLabel.Position = UDim2.new(0, 120, 0, 0)
    topLabel.BackgroundTransparency = 1
    topLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    topLabel.TextScaled = true
    topLabel.Font = Enum.Font.GothamBlack
    topLabel.Text = "0"
    topLabel.TextXAlignment = Enum.TextXAlignment.Left
    topLabel.TextYAlignment = Enum.TextYAlignment.Center
    topLabel.ZIndex = 2
    topLabel.Parent = streakFrame
    
    -- ====== DÒNG 2: TÊN HIỂN THỊ ======
    local nameFrame = Instance.new("Frame")
    nameFrame.Size = UDim2.new(1, 0, 0.5, 0)
    nameFrame.Position = UDim2.new(0, 0, 0.5, 0)
    nameFrame.BackgroundTransparency = 1
    nameFrame.Parent = frame
    
    -- Đường kẻ ngăn cách
    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(0.9, 0, 0, 1)
    divider.Position = UDim2.new(0.05, 0, 0, 0)
    divider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    divider.BackgroundTransparency = 0.4
    divider.BorderSizePixel = 0
    divider.Parent = nameFrame
    
    -- Icon người chơi
    local playerIcon = Instance.new("TextLabel")
    playerIcon.Size = UDim2.new(0, 20, 0, 20)  -- Tăng từ 18 lên 20
    playerIcon.Position = UDim2.new(0, 5, 0.5, -10)
    playerIcon.BackgroundTransparency = 1
    playerIcon.Text = "👤"
    playerIcon.TextScaled = true
    playerIcon.Font = Enum.Font.GothamBold
    playerIcon.TextColor3 = Color3.fromRGB(150, 150, 150)
    playerIcon.ZIndex = 2
    playerIcon.Parent = nameFrame
    
    -- Label tên hiển thị
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -30, 1, 0)
    nameLabel.Position = UDim2.new(0, 30, 0, 2)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Text = "Player"
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextYAlignment = Enum.TextYAlignment.Center
    nameLabel.ZIndex = 2
    nameLabel.Parent = nameFrame
    
    -- UIScale để tự động co giãn
    local uiScale = Instance.new("UIScale")
    uiScale.Scale = 1
    uiScale.Parent = nameLabel
    
    return {
        frame = frame,
        winLabel = winLabel,
        winIcon = winIcon,
        topLabel = topLabel,
        topIcon = topIcon,
        nameLabel = nameLabel,
        playerIcon = playerIcon,
        uiScale = uiScale,
        gui = screenGui
    }
end

-- Tạo GUI
local gui = createStreakGUI()

-- Biến lưu giá trị cũ
local lastWinStreak = -1
local lastTopStreak = -1
local lastName = ""

-- Hàm lấy Win Streak
local function getWinStreak()
    local success, streak = pcall(function()
        local leaderstats = player:FindFirstChild("CustomLeaderstats")
        if leaderstats then
            local winStreak = leaderstats:FindFirstChild("Win Streak")
            if winStreak then
                return tonumber(winStreak.Value) or 0
            end
        end
        return 0
    end)
    return success and streak or 0
end

-- Hàm lấy Top Streak Server
local function getTopStreak()
    local maxStreak = 0
    for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
        local success, s = pcall(function()
            local ls = plr:FindFirstChild("CustomLeaderstats")
            if ls then
                local ws = ls:FindFirstChild("Win Streak")
                if ws then
                    return tonumber(ws.Value) or 0
                end
            end
            return 0
        end)
        if success and s > maxStreak then
            maxStreak = s
        end
    end
    return maxStreak
end

-- Hàm tự động căn chỉnh tên - TO HƠN
local function updateNameDisplay(name)
    local label = gui.nameLabel
    local nameLength = #name
    
    gui.uiScale.Scale = 1
    
    if nameLength <= 8 then
        gui.uiScale.Scale = 1.2
    elseif nameLength <= 12 then
        gui.uiScale.Scale = 1.1
    elseif nameLength <= 16 then
        gui.uiScale.Scale = 1.0
    elseif nameLength <= 20 then
        gui.uiScale.Scale = 0.9
    elseif nameLength <= 24 then
        gui.uiScale.Scale = 0.8
    else
        gui.uiScale.Scale = 0.7
        name = string.sub(name, 1, 22) .. "..."
    end
    
    label.Text = name
end

-- Hàm cập nhật hiển thị
local function updateStreak()
    local winStreak = getWinStreak()
    local topStreak = getTopStreak()
    local displayName = player.DisplayName or player.Name or "Player"
    
    local updated = false
    
    -- Cập nhật Win Streak
    if winStreak ~= lastWinStreak then
        lastWinStreak = winStreak
        
        local color
        if winStreak >= 10 then
            color = Color3.fromRGB(255, 50, 0)
            gui.winIcon.TextColor3 = Color3.fromRGB(255, 50, 0)
        elseif winStreak >= 5 then
            color = Color3.fromRGB(255, 150, 0)
            gui.winIcon.TextColor3 = Color3.fromRGB(255, 150, 0)
        elseif winStreak >= 3 then
            color = Color3.fromRGB(255, 200, 0)
            gui.winIcon.TextColor3 = Color3.fromRGB(255, 200, 0)
        else
            color = Color3.fromRGB(255, 255, 255)
            gui.winIcon.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        
        gui.winLabel.TextColor3 = color
        gui.winLabel.Text = tostring(winStreak)
        updated = true
    end
    
    -- Cập nhật Top Streak
    if topStreak ~= lastTopStreak then
        lastTopStreak = topStreak
        gui.topLabel.Text = tostring(topStreak)
        
        if topStreak >= 10 then
            gui.topIcon.TextColor3 = Color3.fromRGB(255, 215, 0)
            gui.topLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
        elseif topStreak >= 5 then
            gui.topIcon.TextColor3 = Color3.fromRGB(192, 192, 192)
            gui.topLabel.TextColor3 = Color3.fromRGB(192, 192, 192)
        else
            gui.topIcon.TextColor3 = Color3.fromRGB(180, 120, 50)
            gui.topLabel.TextColor3 = Color3.fromRGB(180, 120, 50)
        end
        updated = true
    end
    
    -- Cập nhật tên
    if displayName ~= lastName then
        lastName = displayName
        updateNameDisplay(displayName)
        updated = true
    end
end

-- ====== CẬP NHẬT THỜI GIAN THỰC ======

RunService.Heartbeat:Connect(function()
    updateStreak()
end)

-- Lắng nghe thay đổi của Win Streak
local function setupWinStreakListener()
    local leaderstats = player:FindFirstChild("CustomLeaderstats")
    if leaderstats then
        local winStreak = leaderstats:FindFirstChild("Win Streak")
        if winStreak then
            winStreak:GetPropertyChangedSignal("Value"):Connect(function()
                updateStreak()
            end)
        end
        
        leaderstats.ChildAdded:Connect(function(child)
            if child.Name == "Win Streak" then
                child:GetPropertyChangedSignal("Value"):Connect(function()
                    updateStreak()
                end)
            end
        end)
    end
end

if player:FindFirstChild("CustomLeaderstats") then
    setupWinStreakListener()
else
    player.ChildAdded:Connect(function(child)
        if child.Name == "CustomLeaderstats" then
            task.wait(0.1)
            setupWinStreakListener()
        end
    end)
end

game:GetService("Players").PlayerAdded:Connect(function()
    task.wait(0.5)
    lastTopStreak = -1
    updateStreak()
end)

player:GetPropertyChangedSignal("DisplayName"):Connect(function()
    lastName = ""
    updateStreak()
end)

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    lastWinStreak = -1
    lastTopStreak = -1
    updateStreak()
end)

player.CharacterRemoving:Connect(function()
    gui.winLabel.Text = "0"
    gui.topLabel.Text = "0"
    lastWinStreak = -1
    lastTopStreak = -1
end)

print("✅ Hiển thị Streak + Tên đã được kích hoạt!")
print("📍 Vị trí: Góc dưới trái màn hình")
print("📏 Chữ to, dễ đọc!")
