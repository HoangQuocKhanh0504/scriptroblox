--[[
    Emote Wheel - PERSISTENT (Không mất sau khi hồi sinh)
    Luôn ở trên cùng mọi giao diện game
    Giữ Alt → Menu hình tròn
    Rê chuột → Highlight
    Thả Alt → Chạy emote
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- EMOTE DATA
local WheelEmotes = {
    "Take The L", "ROFL", "Smile", "Think", "Facepalm", "Agree", "Denial", "Kneel"
}

local AllEmotes = {
    "Take The L", "ROFL", "Smile", "Think", "Facepalm", "Agree", "Denial", "Kneel",
    "Coo Coo", "Cream Cheese Honey", "Criss Cross", "Off of You", "Round & Round",
    "Shivering", "Shoulder Brush", "Side To Side", "Snow Angels", "Superhero", "Vegetable",
    "Illumina Storm", "Whimsical", "Tiptoe", "Busting A Move", "Portal Glitch", "It's Time", "Step Dancing", "Summer Days"
}

-- ANIMATION DATA
local KnownAnimations = {
    Agree = { ID = 85429197687197, SOUNDS = {78663178795648}, LOOPSOUNDS = false },
    ["Coo Coo"] = { ID = 125921589993721, SOUNDS = {134218301690577, 71288358864209}, LOOPSOUNDS = false },
    ["Cream Cheese Honey"] = { ID = 71250144811352, SOUNDS = {120250934207816}, LOOPSOUNDS = true },
    ["Criss Cross"] = { ID = 95986480266032, SOUNDS = {120250934207816}, LOOPSOUNDS = true },
    Denial = { ID = 81555757574094, SOUNDS = {75485128790168, 13158735106, 13158735106, 13158735106}, LOOPSOUNDS = false },
    Facepalm = { ID = 103862270973168, SOUNDS = {88377109323880, 13160326139}, LOOPSOUNDS = false },
    Kneel = { ID = 84754316528381, SOUNDS = {134140996504107}, LOOPSOUNDS = false },
    ["Off of You"] = { ID = 105875604689697, SOUNDS = {137662451042014}, LOOPSOUNDS = true },
    ROFL = { ID = 73786487009083, SOUNDS = {122605533507524, 126514820442685}, LOOPSOUNDS = false },
    ["Round & Round"] = { ID = 104273989039620, SOUNDS = {129000171133220}, LOOPSOUNDS = true },
    Shivering = { ID = 102458102253574, SOUNDS = {121062822157622}, LOOPSOUNDS = true },
    ["Shoulder Brush"] = { ID = 119282539520778, SOUNDS = {79768694812211, 79768694812211, 79768694812211, 79768694812211}, LOOPSOUNDS = false },
    ["Side To Side"] = { ID = 77255514751814, SOUNDS = {88051081362116}, LOOPSOUNDS = true },
    Smile = { ID = 98020061651338, SOUNDS = {98020061651338, 100664444144490}, LOOPSOUNDS = true },
    ["Snow Angels"] = { ID = 93924392025280, SOUNDS = {}, LOOPSOUNDS = false },
    Superhero = { ID = 115000869501227, SOUNDS = {80133530921906, 98970356172671}, LOOPSOUNDS = true },
    ["Take The L"] = { ID = 104639476409829, SOUNDS = {116605809326430}, LOOPSOUNDS = true },
    Think = { ID = 133733650708343, SOUNDS = {13160326139, 13160326139}, LOOPSOUNDS = false },
    Vegetable = { ID = 95292230449040, SOUNDS = {120797927157164}, LOOPSOUNDS = true },
    ["Illumina Storm"] = { ID = {77038993402535, 114436319908436}, SOUNDS = {114436319908436}, LOOPSOUNDS = true },
    ["Whimsical"] = { ID = 76972261050513, SOUNDS = {131474770610272}, LOOPSOUNDS = true },
    ["Tiptoe"] = { ID = 104184203029073, SOUNDS = {}, LOOPSOUNDS = false },
    ["Busting A Move"] = { ID = 79831320697486, SOUNDS = {70973334446412}, LOOPSOUNDS = true },
    ["Portal Glitch"] = { ID = 114622720984788, SOUNDS = {81610952487049, 7127702569}, LOOPSOUNDS = false, DURATION = 1.15 },
    ["It's Time"] = { ID = 137924113002985, SOUNDS = {85464929329408, 135970869546121}, LOOPSOUNDS = false },
    ["Step Dancing"] = { ID = 138552028009125, SOUNDS = {104785220885260}, LOOPSOUNDS = true },
    ["Summer Days"] = { ID = 102680180184838, SOUNDS = {72826710402631}, LOOPSOUNDS = true }
    
}

local currentAnims = {}
local currentSounds = {}
local selectedEmote = nil
local menuOpen = false
local currentView = "wheel"
local currentHoverIndex = nil
local wheelGui = nil
local listGui = nil
local wheelBtns = nil
local centerName = nil
local listBtns = nil
local listSelectedText = nil

local function StopEmote()
    for _, anim in ipairs(currentAnims) do
        pcall(function() anim:Stop() end)
    end
    currentAnims = {}
    
    for _, s in ipairs(currentSounds) do
        pcall(function() s:Stop() end)
    end
    currentSounds = {}
end

local function PlayEmote(name)
    if not name then return end
    local data = KnownAnimations[name]
    if not data then return end
    
    StopEmote()
    task.wait(0.05)
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    local animIDs = data.ID
    if type(animIDs) == "table" then
        for _, id in ipairs(animIDs) do
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://" .. id
            local animTrack = humanoid:LoadAnimation(anim)
            animTrack:Play()
            table.insert(currentAnims, animTrack)
        end
    else
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://" .. animIDs
        local animTrack = humanoid:LoadAnimation(anim)
        animTrack:Play()
        table.insert(currentAnims, animTrack)
    end
    
    local runningConn
    runningConn = humanoid.Running:Connect(function(speed)
        if speed > 0 then
            StopEmote()
            if runningConn then runningConn:Disconnect() end
        end
    end)
    
    for _, id in ipairs(data.SOUNDS) do
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://" .. id
        s.Volume = data.VOLUME or 1
        s.Looped = data.LOOPSOUNDS
        s.Parent = char
        pcall(function() s:Play() end)
        table.insert(currentSounds, s)
    end
end

local function getIcon(name)
    local icons = {
        ["Take The L"] = "🏆", ROFL = "😂", Smile = "😊", Think = "🤔",
        Facepalm = "😩", Agree = "👍", Denial = "🙅", Kneel = "🙇",
        ["Coo Coo"] = "🤪", ["Cream Cheese Honey"] = "🧀", ["Criss Cross"] = "✖️",
        ["Off of You"] = "👋", ["Round & Round"] = "🔄", Shivering = "🥶",
        ["Shoulder Brush"] = "💪", ["Side To Side"] = "↔️", ["Snow Angels"] = "❄️",
        Superhero = "🦸", Vegetable = "🥦", Flex = "💪"
    }
    return icons[name] or "🎭"
end

local function CreateWheelMenu()
    local gui = Instance.new("ScreenGui")
    gui.Name = "EmoteWheel"
    gui.Enabled = false
    gui.Parent = PlayerGui:FindFirstChild("CoreGui") or PlayerGui
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 999
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 360, 0, 360)
    container.Position = UDim2.new(0.5, -180, 0.5, -180)
    container.BackgroundTransparency = 1
    container.Parent = gui
    container.ZIndex = 10
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.65
    bg.BorderSizePixel = 0
    bg.Parent = container
    bg.ZIndex = 5
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = bg
    
    local outerRing = Instance.new("Frame")
    outerRing.Size = UDim2.new(0.9, 0, 0.9, 0)
    outerRing.Position = UDim2.new(0.05, 0, 0.05, 0)
    outerRing.BackgroundTransparency = 1
    outerRing.BorderSizePixel = 2
    outerRing.BorderColor3 = Color3.fromRGB(255, 200, 0)
    outerRing.Parent = container
    outerRing.ZIndex = 6
    local ringCorner = Instance.new("UICorner")
    ringCorner.CornerRadius = UDim.new(1, 0)
    ringCorner.Parent = outerRing
    
    local centerArea = Instance.new("Frame")
    centerArea.Size = UDim2.new(0, 95, 0, 95)
    centerArea.Position = UDim2.new(0.5, -47.5, 0.5, -47.5)
    centerArea.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    centerArea.BackgroundTransparency = 0.25
    centerArea.BorderSizePixel = 1
    centerArea.BorderColor3 = Color3.fromRGB(255, 200, 0)
    centerArea.Parent = container
    centerArea.ZIndex = 7
    local centerCorner = Instance.new("UICorner")
    centerCorner.CornerRadius = UDim.new(1, 0)
    centerCorner.Parent = centerArea
    
    local centerIcon = Instance.new("TextLabel")
    centerIcon.Size = UDim2.new(1, 0, 0.5, 0)
    centerIcon.Position = UDim2.new(0, 0, 0.2, 0)
    centerIcon.BackgroundTransparency = 1
    centerIcon.Text = "🎭"
    centerIcon.TextColor3 = Color3.fromRGB(255, 200, 0)
    centerIcon.TextSize = 34
    centerIcon.Font = Enum.Font.GothamBold
    centerIcon.Parent = centerArea
    centerIcon.ZIndex = 8
    
    local centerNameLabel = Instance.new("TextLabel")
    centerNameLabel.Size = UDim2.new(1, 0, 0.25, 0)
    centerNameLabel.Position = UDim2.new(0, 0, 0.7, 0)
    centerNameLabel.BackgroundTransparency = 1
    centerNameLabel.Text = ""
    centerNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    centerNameLabel.TextSize = 11
    centerNameLabel.Font = Enum.Font.GothamBold
    centerNameLabel.Parent = centerArea
    centerNameLabel.ZIndex = 8
    
    local buttons = {}
    local radius = 130
    local angles = { -90, -45, 0, 45, 90, 135, 180, 225 }
    
    for i, name in ipairs(WheelEmotes) do
        local angle = angles[i]
        local rad = math.rad(angle)
        local x = radius * math.cos(rad)
        local y = radius * math.sin(rad)
        
        local btn = Instance.new("ImageButton")
        btn.Size = UDim2.new(0, 62, 0, 62)
        btn.Position = UDim2.new(0.5, x - 31, 0.5, y - 31)
        btn.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
        btn.BackgroundTransparency = 0.2
        btn.BorderSizePixel = 0
        btn.Parent = container
        btn.ZIndex = 9
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(1, 0)
        btnCorner.Parent = btn
        
        local icon = Instance.new("TextLabel")
        icon.Size = UDim2.new(1, 0, 0.55, 0)
        icon.Position = UDim2.new(0, 0, 0.15, 0)
        icon.BackgroundTransparency = 1
        icon.Text = getIcon(name)
        icon.TextColor3 = Color3.fromRGB(255, 255, 255)
        icon.TextSize = 26
        icon.Font = Enum.Font.GothamBold
        icon.Parent = btn
        icon.ZIndex = 10
        
        local short = name == "Take The L" and "L" or name:sub(1, 4)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0.3, 0)
        label.Position = UDim2.new(0, 0, 0.7, 0)
        label.BackgroundTransparency = 1
        label.Text = short
        label.TextColor3 = Color3.fromRGB(210, 210, 230)
        label.TextSize = 9
        label.Font = Enum.Font.GothamBold
        label.Parent = btn
        label.ZIndex = 10
        
        local highlight = Instance.new("Frame")
        highlight.Size = UDim2.new(1, 10, 1, 10)
        highlight.Position = UDim2.new(0, -5, 0, -5)
        highlight.BackgroundTransparency = 1
        highlight.BorderSizePixel = 3
        highlight.BorderColor3 = Color3.fromRGB(255, 200, 0)
        highlight.Parent = btn
        highlight.ZIndex = 8
        local highCorner = Instance.new("UICorner")
        highCorner.CornerRadius = UDim.new(1, 0)
        highCorner.Parent = highlight
        
        btn.MouseEnter:Connect(function()
            if menuOpen and currentView == "wheel" then
                if currentHoverIndex then
                    local prev = buttons[currentHoverIndex]
                    prev.highlight.BackgroundTransparency = 1
                    prev.btn.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
                    prev.btn.BackgroundTransparency = 0.2
                end
                currentHoverIndex = i
                selectedEmote = name
                centerNameLabel.Text = name
                highlight.BackgroundTransparency = 0.7
                btn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
                btn.BackgroundTransparency = 0.15
                
                local tween = TweenService:Create(btn, TweenInfo.new(0.08), {Size = UDim2.new(0, 68, 0, 68)})
                tween:Play()
                tween.Completed:Connect(function()
                    TweenService:Create(btn, TweenInfo.new(0.08), {Size = UDim2.new(0, 62, 0, 62)}):Play()
                end)
            end
        end)
        
        table.insert(buttons, {btn = btn, highlight = highlight, name = name})
    end
    
    local centerBlocker = Instance.new("ImageButton")
    centerBlocker.Size = UDim2.new(0, 95, 0, 95)
    centerBlocker.Position = UDim2.new(0.5, -47.5, 0.5, -47.5)
    centerBlocker.BackgroundTransparency = 1
    centerBlocker.AutoButtonColor = false
    centerBlocker.Parent = container
    centerBlocker.ZIndex = 15
    
    centerBlocker.MouseEnter:Connect(function()
        if menuOpen and currentView == "wheel" and currentHoverIndex then
            local prev = buttons[currentHoverIndex]
            prev.highlight.BackgroundTransparency = 1
            prev.btn.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
            prev.btn.BackgroundTransparency = 0.2
            currentHoverIndex = nil
            selectedEmote = nil
            centerNameLabel.Text = ""
        end
    end)
    
    local hint = Instance.new("TextLabel")
    hint.Size = UDim2.new(1, 0, 0, 24)
    hint.Position = UDim2.new(0, 0, 1, 5)
    hint.BackgroundTransparency = 1
    hint.Text = "✨ Hover on any slice | Right click → List view ✨"
    hint.TextColor3 = Color3.fromRGB(160, 160, 180)
    hint.TextSize = 10
    hint.Font = Enum.Font.Gotham
    hint.Parent = container
    hint.ZIndex = 10
    
    return gui, buttons, centerNameLabel
end

local function CreateListMenu()
    local gui = Instance.new("ScreenGui")
    gui.Name = "EmoteList"
    gui.Enabled = false
    gui.Parent = PlayerGui:FindFirstChild("CoreGui") or PlayerGui
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 999
    
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 320, 0, 440)
    main.Position = UDim2.new(0.5, -160, 0.5, -220)
    main.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    main.BackgroundTransparency = 0.12
    main.BorderSizePixel = 1
    main.BorderColor3 = Color3.fromRGB(255, 200, 0)
    main.Parent = gui
    main.ZIndex = 10
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 20)
    mainCorner.Parent = main
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 45)
    title.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    title.BackgroundTransparency = 0.15
    title.Text = "📋 ALL EMOTES (20)"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.Parent = main
    title.ZIndex = 11
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 20)
    titleCorner.Parent = title
    
    local selectedFrame = Instance.new("Frame")
    selectedFrame.Size = UDim2.new(0.9, 0, 0, 38)
    selectedFrame.Position = UDim2.new(0.05, 0, 0.12, 0)
    selectedFrame.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    selectedFrame.BackgroundTransparency = 0.85
    selectedFrame.BorderSizePixel = 1
    selectedFrame.BorderColor3 = Color3.fromRGB(255, 200, 0)
    selectedFrame.Parent = main
    selectedFrame.ZIndex = 11
    local selCorner = Instance.new("UICorner")
    selCorner.CornerRadius = UDim.new(0, 10)
    selCorner.Parent = selectedFrame
    
    local selectedText = Instance.new("TextLabel")
    selectedText.Size = UDim2.new(1, 0, 1, 0)
    selectedText.BackgroundTransparency = 1
    selectedText.Text = "Hover over an emote..."
    selectedText.TextColor3 = Color3.fromRGB(255, 200, 0)
    selectedText.TextSize = 13
    selectedText.Font = Enum.Font.GothamBold
    selectedText.Parent = selectedFrame
    selectedText.ZIndex = 12
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(0.94, 0, 0.62, 0)
    scroll.Position = UDim2.new(0.03, 0, 0.21, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 200, 0)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.Parent = main
    scroll.ZIndex = 11
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = scroll
    
    local hint = Instance.new("TextLabel")
    hint.Size = UDim2.new(1, 0, 0, 24)
    hint.Position = UDim2.new(0, 0, 0.93, 0)
    hint.BackgroundTransparency = 1
    hint.Text = "👉 Right click anywhere → Switch to Wheel"
    hint.TextColor3 = Color3.fromRGB(130, 130, 150)
    hint.TextSize = 10
    hint.Font = Enum.Font.Gotham
    hint.Parent = main
    hint.ZIndex = 11
    
    local buttons = {}
    for i, name in ipairs(AllEmotes) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        btn.BackgroundTransparency = 0.4
        btn.Text = "  " .. getIcon(name) .. "   " .. name
        btn.TextColor3 = Color3.fromRGB(220, 220, 240)
        btn.TextSize = 12
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Font = Enum.Font.GothamSemibold
        btn.BorderSizePixel = 0
        btn.Parent = scroll
        btn.ZIndex = 12
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = btn
        
        btn.MouseEnter:Connect(function()
            if menuOpen and currentView == "list" then
                for _, b in ipairs(buttons) do
                    b.btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                    b.btn.BackgroundTransparency = 0.4
                    b.btn.TextColor3 = Color3.fromRGB(220, 220, 240)
                end
                selectedEmote = name
                selectedText.Text = "▶ " .. name
                btn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
                btn.BackgroundTransparency = 0.2
                btn.TextColor3 = Color3.fromRGB(0, 0, 0)
            end
        end)
        
        table.insert(buttons, {btn = btn, name = name})
    end
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 15)
    end)
    
    return gui, buttons, selectedText
end

local function recreateMenus()
    if wheelGui then pcall(function() wheelGui:Destroy() end) end
    if listGui then pcall(function() listGui:Destroy() end) end
    
    wheelGui, wheelBtns, centerName = CreateWheelMenu()
    listGui, listBtns, listSelectedText = CreateListMenu()
    
    local function addRightClickBlocker(gui)
        local blocker = Instance.new("ImageButton")
        blocker.Size = UDim2.new(1, 0, 1, 0)
        blocker.BackgroundTransparency = 1
        blocker.AutoButtonColor = false
        blocker.Parent = gui
        blocker.ZIndex = 100
        
        blocker.MouseButton2Click:Connect(function()
            if menuOpen then
                if currentView == "wheel" then
                    currentView = "list"
                    wheelGui.Enabled = false
                    listGui.Enabled = true
                    if currentHoverIndex then
                        local prev = wheelBtns[currentHoverIndex]
                        prev.highlight.BackgroundTransparency = 1
                        prev.btn.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
                        prev.btn.BackgroundTransparency = 0.2
                        currentHoverIndex = nil
                    end
                    selectedEmote = nil
                    if centerName then centerName.Text = "" end
                else
                    currentView = "wheel"
                    wheelGui.Enabled = true
                    listGui.Enabled = false
                    for _, btn in ipairs(listBtns) do
                        btn.btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                        btn.btn.BackgroundTransparency = 0.4
                        btn.btn.TextColor3 = Color3.fromRGB(220, 220, 240)
                    end
                    if listSelectedText then listSelectedText.Text = "Hover over an emote..." end
                    selectedEmote = nil
                end
            end
        end)
    end
    
    addRightClickBlocker(wheelGui)
    addRightClickBlocker(listGui)
end

-- KHỞI TẠO
recreateMenus()

-- THEO DÕI HỒI SINH
LocalPlayer.CharacterAdded:Connect(function()
    if menuOpen then
        menuOpen = false
        if wheelGui then wheelGui.Enabled = false end
        if listGui then listGui.Enabled = false end
        if currentHoverIndex and wheelBtns then
            local prev = wheelBtns[currentHoverIndex]
            pcall(function()
                prev.highlight.BackgroundTransparency = 1
                prev.btn.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
                prev.btn.BackgroundTransparency = 0.2
            end)
        end
        currentHoverIndex = nil
        selectedEmote = nil
    end
    
    task.wait(0.5)
    recreateMenus()
end)

-- XỬ LÝ ALT
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    
    if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
        if not menuOpen then
            menuOpen = true
            currentView = "wheel"
            currentHoverIndex = nil
            selectedEmote = nil
            if wheelGui then wheelGui.Enabled = true end
            if listGui then listGui.Enabled = false end
            if centerName then centerName.Text = "" end
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
        if menuOpen then
            menuOpen = false
            if wheelGui then wheelGui.Enabled = false end
            if listGui then listGui.Enabled = false end
            
            if selectedEmote then
                PlayEmote(selectedEmote)
            end
            
            if currentHoverIndex and wheelBtns then
                local prev = wheelBtns[currentHoverIndex]
                pcall(function()
                    prev.highlight.BackgroundTransparency = 1
                    prev.btn.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
                    prev.btn.BackgroundTransparency = 0.2
                end)
                currentHoverIndex = nil
            end
            selectedEmote = nil
            if centerName then centerName.Text = "" end
        end
    end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Emote Wheel",
    Text = "✨ Hold ALT → Hover → Release ALT ✨ | Flex fixed!",
    Duration = 4
})

print("✅ Emote Wheel loaded!")
