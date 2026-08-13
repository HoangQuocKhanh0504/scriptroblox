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
-- ESP System
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local ESPEnabled = true
local Holder = Instance.new("Folder", game.CoreGui)
Holder.Name = "ESP"

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

-- Health Bar đẹp hơn
local function CreateHealthBar(v)
    local healthGui = Instance.new("BillboardGui")
    healthGui.Name = v.Name .. "HealthBar"
    healthGui.Enabled = false
    healthGui.Size = UDim2.new(0, 120, 0, 16)
    healthGui.StudsOffset = Vector3.new(0, -2, 0)
    healthGui.AlwaysOnTop = true
    healthGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Background (viền đen)
    local bg = Instance.new("Frame", healthGui)
    bg.Name = "Background"
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.6
    bg.BorderSizePixel = 1
    bg.BorderColor3 = Color3.fromRGB(255, 255, 255)
    bg.BorderMode = Enum.BorderMode.Inset
    
    -- Thanh máu chính (gradient)
    local healthFill = Instance.new("Frame", bg)
    healthFill.Name = "HealthFill"
    healthFill.Size = UDim2.new(1, -4, 1, -4)
    healthFill.Position = UDim2.new(0, 2, 0, 2)
    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthFill.BackgroundTransparency = 0
    healthFill.BorderSizePixel = 0
    
    -- Gradient overlay cho đẹp
    local gradient = Instance.new("UIGradient", healthFill)
    gradient.Rotation = 0
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255, 0.3)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255, 0.1)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0, 0.2))
    })
    
    -- Phần bóng sáng ở trên
    local shine = Instance.new("Frame", healthFill)
    shine.Name = "Shine"
    shine.Size = UDim2.new(1, 0, 0.4, 0)
    shine.Position = UDim2.new(0, 0, 0, 0)
    shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    shine.BackgroundTransparency = 0.7
    shine.BorderSizePixel = 0
    
    -- Text số máu
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
        -- Cập nhật size với animation mượt
        healthFill.Size = UDim2.new(healthPercent, -4, 1, -4)
        
        -- Đổi màu gradient theo máu
        local r, g, b
        if healthPercent > 0.6 then
            -- Xanh lá -> Xanh biển
            r = math.floor(255 * (1 - (healthPercent - 0.6) / 0.4 * 0.5))
            g = 255
            b = math.floor(255 * ((healthPercent - 0.6) / 0.4 * 0.8))
        elseif healthPercent > 0.3 then
            -- Xanh biển -> Vàng
            local t = (healthPercent - 0.3) / 0.3
            r = math.floor(255 * t + 255 * (1 - t))
            g = 255
            b = math.floor(255 * (1 - t))
        else
            -- Vàng -> Đỏ
            local t = healthPercent / 0.3
            r = 255
            g = math.floor(255 * t)
            b = 0
        end
        
        healthFill.BackgroundColor3 = Color3.fromRGB(r, g, b)
        
        -- Cập nhật gradient cho đẹp
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
    
    -- Cập nhật visibility
    if _G.ShowHealth and IsInRange(v) and hum.Health > 0 then
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
    
    -- Tạo Health Bar đẹp
    local healthGui = CreateHealthBar(v)
    healthGui.Parent = vHolder
    local root = v.Character:FindFirstChild("HumanoidRootPart") or v.Character:FindFirstChild("Torso") or v.Character:FindFirstChild("Head")
    if root then
        healthGui.Adornee = root
    end
    
    if IsInRange(v) then
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
    while ESPEnabled and task.wait(0.2) do
        local localChar = LocalPlayer.Character
        if not localChar then continue end
        
        for _, v in pairs(Players:GetPlayers()) do
            if v == LocalPlayer then continue end
            
            local vHolder = Holder:FindFirstChild(v.Name)
            if not vHolder then continue end
            
            local box = vHolder:FindFirstChild(v.Name .. "Box")
            local nametag = vHolder:FindFirstChild(v.Name .. "NameTag")
            local healthGui = vHolder:FindFirstChild(v.Name .. "HealthBar")
            
            if IsInRange(v) then
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
            if not IsInRange(target) then
                local highlight = target.Character:FindFirstChild("GetReal")
                if highlight then highlight:Destroy() end
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
            end
        end
    end
    
    task.spawn(function()
        local updateCount = 0
        while ESPEnabled and task.wait() do
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

print("[ESP] ESP System Loaded with 300m limit and Health Bar!")

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
            if not self.__active then return end
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

            if not self.__active or not __x6y7z8 or not __x6y7z8.Character then
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
            local __j8k9l0 = __d2e3f4 - Vector3.new(0, 5, 0)
            local __m1n2o3 = CFrame.lookAt(__j8k9l0, __d2e3f4)
            local __p4q5r6 = __g5h6i7:ToObjectSpace(CFrame.new(__d2e3f4 + Vector3.new(math.random(), math.random(), math.random())))

            __u3v4w5[utf8.char(0)] = __w9x0y1:EncodeCFrame(CFrame.new(__j8k9l0, __d2e3f4) * CFrame.Angles(__m1n2o3:ToOrientation()))
            __u3v4w5[utf8.char(1)] = __w9x0y1:EncodeCFrame(CFrame.new(__d2e3f4) * CFrame.Angles(__m1n2o3:ToOrientation()))
            __u3v4w5[utf8.char(2)] = __a9b0c1
            __u3v4w5[utf8.char(3)] = __w9x0y1:EncodeCFrame(__p4q5r6)

            self.__task1 = task.delay(0.15, function()
                self:__desync_stop()
            end)

            return unpack(__r0s1t2)
        end
        print("[LOG] Aimbot hooked!")
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
            if not self.__desync then return end
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

print("[LOG] === ALL SYSTEMS LOADED ===")
print("[LOG] ESP: Active (300m limit)")
print("[LOG] Aimbot: Active (300m limit)")
print("[LOG] Highlight ESP: Active (300m limit)")
print("[LOG] Health Bar: Active (Smooth)")
