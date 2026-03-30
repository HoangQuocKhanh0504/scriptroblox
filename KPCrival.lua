--[[
    ==================================================
    KHANHPC HACK - PREMIUM EDITION (FULL VERSION) - WITH CONFIG SYSTEM
    KEY: https://hoangquockhanh0504.github.io/key-system/
    ==================================================
]]

-- ============================================
-- LẤY TÊN GAME
-- ============================================
local function getGameName()
    local gameId = game.GameId
    local gameName = game.Name
    
    local popularGames = {
        [292439477] = "Phantom Forces",
        [142823291] = "Murder Mystery 2",
        [286090429] = "Arsenal",
        [4483381587] = "Pet Simulator X",
        [6284583030] = "Pet Simulator 99",
        [920587237] = "Adopt Me!",
        [6872265039] = "Blox Fruits",
        [301549746] = "Brookhaven RP",
        [735030788] = "Royale High",
        [3956818381] = "Tower Defense Simulator",
        [6332533429] = "Shindo Life",
        [6791314335] = "Da Hood",
        [537413528] = "Build A Boat For Treasure",
        [1553296229] = "Jailbreak",
        [6403373529] = "Fisch",
        [9825515356] = "Dress To Impress",
        [16732694052] = "Blade Ball",
        [111028399] = "Natural Disaster Survival",
        [192800] = "MeepCity",
        [606849621] = "Jailbreak",
        [2505034112] = "Tower of Hell",
        [5199423430] = "Mining Simulator 2",
        [7722306047] = "BedWars",
        [8560631822] = "Evade",
        [6243047625] = "Flee the Facility",
    }
    
    return popularGames[gameId] or gameName
end

local GAME_NAME = getGameName()

-- ============================================
-- SERVICES
-- ============================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local mouse = player:GetMouse()

-- ============================================
-- GLOBAL VARIABLES
-- ============================================
_G.dangXoay = false
_G.dangAimBot = false
_G.dangFly = false
_G.dangAutoTele = false
_G.teleportPosition = "sau"
_G.dangWallHack = true
_G.checkWall = true
_G.autoShoot = false
_G.tocDoSpin = 999999
_G.cheDoSpinHienTai = 1
_G.lockedTarget = nil
_G.espNameTags = {}
_G.espBoxes = {}
_G.aimRadius = 200
_G.ketNoiMang = nil
_G.ketNoiAimBot = nil
_G.ketNoiFly = nil
_G.ketNoiAutoTele = nil
_G.ketNoiWallHack = nil
_G.ketNoiAutoClick = nil
_G.menuVisible = true
_G.fixLag = false
_G.originalLightingSettings = {}
_G.teamMates = {}

_G.isClicking = false
_G.clickInterval = 0.1

_G.flySpeed = 50
_G.flyBodyVelocity = nil
_G.flyBodyGyro = nil

_G.keyBinds = {
    spin = Enum.KeyCode.X,
    aim = Enum.KeyCode.Q,
    fly = Enum.KeyCode.F,
    tele = Enum.KeyCode.P,
    telePos = Enum.KeyCode.T,
    mode = Enum.KeyCode.Z,
    reset = Enum.KeyCode.R,
    menu = Enum.KeyCode.H,
    autoClick = Enum.KeyCode.C,
    fixLag = Enum.KeyCode.L,
    wallHack = Enum.KeyCode.V,
    playerList = Enum.KeyCode.K
}

_G.CHE_DO_SPIN = { NGANG = 1, DOC = 2 }

-- ============================================
-- SCREEN SIZE HANDLING
-- ============================================
local ViewportSize = workspace.CurrentCamera.ViewportSize
local ScreenScale = math.min(1, (ViewportSize.X / 1920) * 0.9, (ViewportSize.Y / 1080) * 0.9)

local MENU_WIDTH = math.floor(math.min(650, ViewportSize.X * 0.35))
local MENU_HEIGHT = math.floor(math.min(800, ViewportSize.Y * 0.7))
local MENU_PADDING = 10
local CARD_HEIGHT = 95
local HEADER_HEIGHT = 80

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================
local function CreateShadow(parent, size, transparency)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = size or UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://13111269966"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = transparency or 0.7
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = parent
    shadow.ZIndex = parent.ZIndex - 1
    return shadow
end

local function CreateGlow(parent, color)
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Size = UDim2.new(1, 10, 1, 10)
    glow.Position = UDim2.new(0, -5, 0, -5)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5025757733"
    glow.ImageColor3 = color or Color3.fromRGB(0, 200, 255)
    glow.ImageTransparency = 0.7
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(10, 10, 118, 118)
    glow.Parent = parent
    glow.ZIndex = parent.ZIndex - 1
    return glow
end

local function GetKeyName(keyCode)
    local keyNames = {
        [Enum.KeyCode.Q] = "Q", [Enum.KeyCode.W] = "W", [Enum.KeyCode.E] = "E",
        [Enum.KeyCode.R] = "R", [Enum.KeyCode.T] = "T", [Enum.KeyCode.Y] = "Y",
        [Enum.KeyCode.U] = "U", [Enum.KeyCode.I] = "I", [Enum.KeyCode.O] = "O",
        [Enum.KeyCode.P] = "P", [Enum.KeyCode.A] = "A", [Enum.KeyCode.S] = "S",
        [Enum.KeyCode.D] = "D", [Enum.KeyCode.F] = "F", [Enum.KeyCode.G] = "G",
        [Enum.KeyCode.H] = "H", [Enum.KeyCode.J] = "J", [Enum.KeyCode.K] = "K",
        [Enum.KeyCode.L] = "L", [Enum.KeyCode.Z] = "Z", [Enum.KeyCode.X] = "X",
        [Enum.KeyCode.C] = "C", [Enum.KeyCode.V] = "V", [Enum.KeyCode.B] = "B",
        [Enum.KeyCode.N] = "N", [Enum.KeyCode.M] = "M", [Enum.KeyCode.One] = "1",
        [Enum.KeyCode.Two] = "2", [Enum.KeyCode.Three] = "3", [Enum.KeyCode.Four] = "4",
        [Enum.KeyCode.Five] = "5", [Enum.KeyCode.Six] = "6", [Enum.KeyCode.Seven] = "7",
        [Enum.KeyCode.Eight] = "8", [Enum.KeyCode.Nine] = "9", [Enum.KeyCode.Zero] = "0",
        [Enum.KeyCode.F1] = "F1", [Enum.KeyCode.F2] = "F2", [Enum.KeyCode.F3] = "F3",
        [Enum.KeyCode.F4] = "F4", [Enum.KeyCode.F5] = "F5", [Enum.KeyCode.F6] = "F6",
        [Enum.KeyCode.F7] = "F7", [Enum.KeyCode.F8] = "F8", [Enum.KeyCode.F9] = "F9",
        [Enum.KeyCode.F10] = "F10", [Enum.KeyCode.LeftShift] = "LShift",
        [Enum.KeyCode.RightShift] = "RShift", [Enum.KeyCode.LeftControl] = "LCtrl",
        [Enum.KeyCode.RightControl] = "RCtrl", [Enum.KeyCode.LeftAlt] = "LAlt",
        [Enum.KeyCode.RightAlt] = "RAlt", [Enum.KeyCode.Space] = "Space",
        [Enum.KeyCode.Return] = "Enter", [Enum.KeyCode.Backspace] = "Backspace",
        [Enum.KeyCode.Tab] = "Tab", [Enum.KeyCode.Escape] = "Esc",
    }
    return keyNames[keyCode] or tostring(keyCode):gsub("Enum.KeyCode.", "")
end

-- ============================================
-- HÀM GỬI THÔNG BÁO
-- ============================================
local function sendNotification(title, message, duration, icon)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "KHANHPC",
            Text = message or "",
            Duration = duration or 2,
            Icon = icon or ""
        })
    end)
    
    pcall(function()
        local notificationGui = CoreGui:FindFirstChild("KhanhPC_Notifications")
        if not notificationGui then
            notificationGui = Instance.new("ScreenGui")
            notificationGui.Name = "KhanhPC_Notifications"
            notificationGui.Parent = CoreGui
            notificationGui.ResetOnSpawn = false
            notificationGui.IgnoreGuiInset = true
            notificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            notificationGui.DisplayOrder = 999999
        end
        
        local notif = Instance.new("Frame")
        notif.Size = UDim2.new(0, 300, 0, 70)
        notif.Position = UDim2.new(1, -320, 1, -100)
        notif.BackgroundColor3 = Color3.fromRGB(20, 23, 31)
        notif.BackgroundTransparency = 0.1
        notif.BorderSizePixel = 0
        notif.Parent = notificationGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 15)
        corner.Parent = notif
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(0, 200, 255)
        stroke.Thickness = 1.5
        stroke.Transparency = 0.3
        stroke.Parent = notif
        
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.new(0, 40, 1, 0)
        iconLabel.Position = UDim2.new(0, 10, 0, 0)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = icon or "🔔"
        iconLabel.Font = Enum.Font.GothamBlack
        iconLabel.TextSize = 30
        iconLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
        iconLabel.Parent = notif
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -60, 0, 30)
        titleLabel.Position = UDim2.new(0, 55, 0, 5)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.Font = Enum.Font.GothamBlack
        titleLabel.TextSize = 16
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = notif
        
        local msgLabel = Instance.new("TextLabel")
        msgLabel.Size = UDim2.new(1, -60, 0, 25)
        msgLabel.Position = UDim2.new(0, 55, 0, 35)
        msgLabel.BackgroundTransparency = 1
        msgLabel.Text = message
        msgLabel.Font = Enum.Font.GothamBold
        msgLabel.TextSize = 14
        msgLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
        msgLabel.TextXAlignment = Enum.TextXAlignment.Left
        msgLabel.Parent = notif
        
        notif.Position = UDim2.new(1, 0, 1, -100)
        TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -320, 1, -100)
        }):Play()
        
        task.wait(duration or 2)
        TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 0, 1, -100),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.3)
        notif:Destroy()
    end)
end

-- ============================================
-- KEY SYSTEM
-- ============================================
local WEB_URL = "https://hoangquockhanh0504.github.io/key-system/"
local VALID_KEYS = {
    ["ABCD1-EFGH2-IJKL3-MNOP4"] = true,
    ["QRST5-UVWX6-YZAB7-CDEF8"] = true,
    ["GHIJ9-KLMN0-OPQR1-STUV2"] = true,
    ["WXYZ3-ABCD4-EFGH5-IJKL6"] = true,
    ["MNOP7-QRST8-UVWX9-YZAB0"] = true,
    ["KHANH-PC01-AAAAA-11111"] = true,
    ["KHANH-PC02-BBBBB-22222"] = true,
    ["KHANH-PC03-CCCCC-33333"] = true,
    ["KHANH-PC04-DDDDD-44444"] = true,
    ["KHANH-PC05-EEEEE-55555"] = true,
    ["VIPPRO-9999-XXXXX-77777"] = true,
    ["PREMIUM-8888-YYYYY-88888"] = true,
    ["ULTIMA-7777-ZZZZZ-99999"] = true,
    ["HACKER-6666-WWWWW-00000"] = true,
    ["MASTER-5555-VVVVV-11111"] = true,
    ["LEGEND-4444-UUUUU-22222"] = true,
    ["ELITE-3333-TTTTT-33333"] = true,
    ["PRO-2222-SSSSS-44444"] = true,
    ["GOD-1111-RRRRR-55555"] = true,
    ["KING-0000-QQQQQ-66666"] = true,
    ["KHANH-PC06-FFFFF-66666"] = true,
    ["KHANH-PC07-GGGGG-77777"] = true,
    ["KHANH-PC08-HHHHH-88888"] = true,
    ["KHANH-PC09-IIIII-99999"] = true,
    ["KHANH-PC10-JJJJJ-00000"] = true,
    ["KHANH-PC11-KKKKK-11111"] = true,
    ["KHANH-PC12-LLLLL-22222"] = true,
    ["KHANH-PC13-MMMMM-33333"] = true,
    ["KHANH-PC14-NNNNN-44444"] = true,
    ["KHANH-PC15-OOOOO-55555"] = true,
    ["KHANH-PC16-PPPPP-66666"] = true,
    ["KHANH-PC17-QQQQQ-77777"] = true,
    ["KHANH-PC18-RRRRR-88888"] = true,
    ["KHANH-PC19-SSSSS-99999"] = true,
    ["KHANH-PC20-TTTTT-00000"] = true,
    ["KHANH-PC21-UUUUU-11111"] = true,
    ["KHANH-PC22-VVVVV-22222"] = true,
    ["KHANH-PC23-WWWWW-33333"] = true,
    ["KHANH-PC24-XXXXX-44444"] = true,
    ["KHANH-PC25-YYYYY-55555"] = true,
    ["KHANH-PC26-ZZZZZ-66666"] = true,
    ["KHANH-PC27-AAAAA-77777"] = true,
    ["KHANH-PC28-BBBBB-88888"] = true,
    ["KHANH-PC29-CCCCC-99999"] = true,
    ["KHANH-PC30-DDDDD-00000"] = true,
    ["KHANH-PC31-EEEEE-11111"] = true,
    ["KHANH-PC32-FFFFF-22222"] = true,
    ["KHANH-PC33-GGGGG-33333"] = true,
    ["KHANH-PC34-HHHHH-44444"] = true,
    ["KHANH-PC35-IIIII-55555"] = true,
    ["KHANH-PC36-JJJJJ-66666"] = true,
    ["KHANH-PC37-KKKKK-77777"] = true,
    ["KHANH-PC38-LLLLL-88888"] = true,
    ["KHANH-PC39-MMMMM-99999"] = true,
    ["KHANH-PC40-NNNNN-00000"] = true,
    ["KHANH-PC41-OOOOO-11111"] = true,
    ["KHANH-PC42-PPPPP-22222"] = true,
    ["KHANH-PC43-QQQQQ-33333"] = true,
    ["KHANH-PC44-RRRRR-44444"] = true,
    ["KHANH-PC45-SSSSS-55555"] = true,
    ["KHANH-PC46-TTTTT-66666"] = true,
    ["KHANH-PC47-UUUUU-77777"] = true,
    ["KHANH-PC48-VVVVV-88888"] = true,
    ["KHANH-PC49-WWWWW-99999"] = true,
    ["KHANH-PC50-XXXXX-00000"] = true,
    ["VIPPRO-0001-AAAAA-11111"] = true,
    ["VIPPRO-0002-BBBBB-22222"] = true,
    ["VIPPRO-0003-CCCCC-33333"] = true,
    ["VIPPRO-0004-DDDDD-44444"] = true,
    ["VIPPRO-0005-EEEEE-55555"] = true,
    ["VIPPRO-0006-FFFFF-66666"] = true,
    ["VIPPRO-0007-GGGGG-77777"] = true,
    ["VIPPRO-0008-HHHHH-88888"] = true,
    ["VIPPRO-0009-IIIII-99999"] = true,
    ["VIPPRO-0010-JJJJJ-00000"] = true,
    ["VIPPRO-0011-KKKKK-11111"] = true,
    ["VIPPRO-0012-LLLLL-22222"] = true,
    ["VIPPRO-0013-MMMMM-33333"] = true,
    ["VIPPRO-0014-NNNNN-44444"] = true,
    ["VIPPRO-0015-OOOOO-55555"] = true,
    ["VIPPRO-0016-PPPPP-66666"] = true,
    ["VIPPRO-0017-QQQQQ-77777"] = true,
    ["VIPPRO-0018-RRRRR-88888"] = true,
    ["VIPPRO-0019-SSSSS-99999"] = true,
    ["VIPPRO-0020-TTTTT-00000"] = true,
    ["VIPPRO-0021-UUUUU-11111"] = true,
    ["VIPPRO-0022-VVVVV-22222"] = true,
    ["VIPPRO-0023-WWWWW-33333"] = true,
    ["VIPPRO-0024-XXXXX-44444"] = true,
    ["VIPPRO-0025-YYYYY-55555"] = true,
    ["VIPPRO-0026-ZZZZZ-66666"] = true,
    ["VIPPRO-0027-AAAAA-77777"] = true,
    ["VIPPRO-0028-BBBBB-88888"] = true,
    ["VIPPRO-0029-CCCCC-99999"] = true,
    ["VIPPRO-0030-DDDDD-00000"] = true,
    ["VIPPRO-0031-EEEEE-11111"] = true,
    ["VIPPRO-0032-FFFFF-22222"] = true,
    ["VIPPRO-0033-GGGGG-33333"] = true,
    ["VIPPRO-0034-HHHHH-44444"] = true,
    ["VIPPRO-0035-IIIII-55555"] = true,
    ["VIPPRO-0036-JJJJJ-66666"] = true,
    ["VIPPRO-0037-KKKKK-77777"] = true,
    ["VIPPRO-0038-LLLLL-88888"] = true,
    ["VIPPRO-0039-MMMMM-99999"] = true,
    ["VIPPRO-0040-NNNNN-00000"] = true,
    ["VIPPRO-0041-OOOOO-11111"] = true,
    ["VIPPRO-0042-PPPPP-22222"] = true,
    ["VIPPRO-0043-QQQQQ-33333"] = true,
    ["VIPPRO-0044-RRRRR-44444"] = true,
    ["VIPPRO-0045-SSSSS-55555"] = true,
    ["VIPPRO-0046-TTTTT-66666"] = true,
    ["VIPPRO-0047-UUUUU-77777"] = true,
    ["VIPPRO-0048-VVVVV-88888"] = true,
    ["VIPPRO-0049-WWWWW-99999"] = true,
    ["VIPPRO-0050-XXXXX-00000"] = true,
    ["PREMIUM-001-AAAAAA-111111"] = true,
    ["PREMIUM-002-BBBBBB-222222"] = true,
    ["PREMIUM-003-CCCCCC-333333"] = true,
    ["PREMIUM-004-DDDDDD-444444"] = true,
    ["PREMIUM-005-EEEEEE-555555"] = true,
    ["PREMIUM-006-FFFFFF-666666"] = true,
    ["PREMIUM-007-GGGGGG-777777"] = true,
    ["PREMIUM-008-HHHHHH-888888"] = true,
    ["PREMIUM-009-IIIIII-999999"] = true,
    ["PREMIUM-010-JJJJJJ-000000"] = true,
    ["PREMIUM-011-KKKKKK-111111"] = true,
    ["PREMIUM-012-LLLLLL-222222"] = true,
    ["PREMIUM-013-MMMMMM-333333"] = true,
    ["PREMIUM-014-NNNNNN-444444"] = true,
    ["PREMIUM-015-OOOOOO-555555"] = true,
    ["PREMIUM-016-PPPPPP-666666"] = true,
    ["PREMIUM-017-QQQQQQ-777777"] = true,
    ["PREMIUM-018-RRRRRR-888888"] = true,
    ["PREMIUM-019-SSSSSS-999999"] = true,
    ["PREMIUM-020-TTTTTT-000000"] = true,
    ["PREMIUM-021-UUUUUU-111111"] = true,
    ["PREMIUM-022-VVVVVV-222222"] = true,
    ["PREMIUM-023-WWWWWW-333333"] = true,
    ["PREMIUM-024-XXXXXX-444444"] = true,
    ["PREMIUM-025-YYYYYY-555555"] = true,
    ["PREMIUM-026-ZZZZZZ-666666"] = true,
    ["PREMIUM-027-AAAAAA-777777"] = true,
    ["PREMIUM-028-BBBBBB-888888"] = true,
    ["PREMIUM-029-CCCCCC-999999"] = true,
    ["PREMIUM-030-DDDDDD-000000"] = true,
    ["PREMIUM-031-EEEEEE-111111"] = true,
    ["PREMIUM-032-FFFFFF-222222"] = true,
    ["PREMIUM-033-GGGGGG-333333"] = true,
    ["PREMIUM-034-HHHHHH-444444"] = true,
    ["PREMIUM-035-IIIIII-555555"] = true,
    ["PREMIUM-036-JJJJJJ-666666"] = true,
    ["PREMIUM-037-KKKKKK-777777"] = true,
    ["PREMIUM-038-LLLLLL-888888"] = true,
    ["PREMIUM-039-MMMMMM-999999"] = true,
    ["PREMIUM-040-NNNNNN-000000"] = true,
    ["ULTIMA-001-AAAAAA-111111"] = true,
    ["ULTIMA-002-BBBBBB-222222"] = true,
    ["ULTIMA-003-CCCCCC-333333"] = true,
    ["ULTIMA-004-DDDDDD-444444"] = true,
    ["ULTIMA-005-EEEEEE-555555"] = true,
    ["ULTIMA-006-FFFFFF-666666"] = true,
    ["ULTIMA-007-GGGGGG-777777"] = true,
    ["ULTIMA-008-HHHHHH-888888"] = true,
    ["ULTIMA-009-IIIIII-999999"] = true,
    ["ULTIMA-010-JJJJJJ-000000"] = true,
    ["ULTIMA-011-KKKKKK-111111"] = true,
    ["ULTIMA-012-LLLLLL-222222"] = true,
    ["ULTIMA-013-MMMMMM-333333"] = true,
    ["ULTIMA-014-NNNNNN-444444"] = true,
    ["ULTIMA-015-OOOOOO-555555"] = true,
    ["ULTIMA-016-PPPPPP-666666"] = true,
    ["ULTIMA-017-QQQQQQ-777777"] = true,
    ["ULTIMA-018-RRRRRR-888888"] = true,
    ["ULTIMA-019-SSSSSS-999999"] = true,
    ["ULTIMA-020-TTTTTT-000000"] = true,
    ["HACKER-001-AAAAAA-111111"] = true,
    ["HACKER-002-BBBBBB-222222"] = true,
    ["HACKER-003-CCCCCC-333333"] = true,
    ["HACKER-004-DDDDDD-444444"] = true,
    ["HACKER-005-EEEEEE-555555"] = true,
    ["HACKER-006-FFFFFF-666666"] = true,
    ["HACKER-007-GGGGGG-777777"] = true,
    ["HACKER-008-HHHHHH-888888"] = true,
    ["HACKER-009-IIIIII-999999"] = true,
    ["HACKER-010-JJJJJJ-000000"] = true,
    ["MASTER-001-AAAAAA-111111"] = true,
    ["MASTER-002-BBBBBB-222222"] = true,
    ["MASTER-003-CCCCCC-333333"] = true,
    ["MASTER-004-DDDDDD-444444"] = true,
    ["MASTER-005-EEEEEE-555555"] = true,
    ["MASTER-006-FFFFFF-666666"] = true,
    ["MASTER-007-GGGGGG-777777"] = true,
    ["MASTER-008-HHHHHH-888888"] = true,
    ["MASTER-009-IIIIII-999999"] = true,
    ["MASTER-010-JJJJJJ-000000"] = true,
    ["LEGEND-001-AAAAAA-111111"] = true,
    ["LEGEND-002-BBBBBB-222222"] = true,
    ["LEGEND-003-CCCCCC-333333"] = true,
    ["LEGEND-004-DDDDDD-444444"] = true,
    ["LEGEND-005-EEEEEE-555555"] = true,
    ["LEGEND-006-FFFFFF-666666"] = true,
    ["LEGEND-007-GGGGGG-777777"] = true,
    ["LEGEND-008-HHHHHH-888888"] = true,
    ["LEGEND-009-IIIIII-999999"] = true,
    ["LEGEND-010-JJJJJJ-000000"] = true,
    ["ELITE-001-AAAAA-11111"] = true,
    ["ELITE-002-BBBBB-22222"] = true,
    ["ELITE-003-CCCCC-33333"] = true,
    ["ELITE-004-DDDDD-44444"] = true,
    ["ELITE-005-EEEEE-55555"] = true,
    ["ELITE-006-FFFFF-66666"] = true,
    ["ELITE-007-GGGGG-77777"] = true,
    ["ELITE-008-HHHHH-88888"] = true,
    ["ELITE-009-IIIII-99999"] = true,
    ["ELITE-010-JJJJJ-00000"] = true,
    ["PRO-0001-AAAAA-11111"] = true,
    ["PRO-0002-BBBBB-22222"] = true,
    ["PRO-0003-CCCCC-33333"] = true,
    ["PRO-0004-DDDDD-44444"] = true,
    ["PRO-0005-EEEEE-55555"] = true,
    ["PRO-0006-FFFFF-66666"] = true,
    ["PRO-0007-GGGGG-77777"] = true,
    ["PRO-0008-HHHHH-88888"] = true,
    ["PRO-0009-IIIII-99999"] = true,
    ["PRO-0010-JJJJJ-00000"] = true,
    ["GOD-001-AAAAA-11111"] = true,
    ["GOD-002-BBBBB-22222"] = true,
    ["GOD-003-CCCCC-33333"] = true,
    ["GOD-004-DDDDD-44444"] = true,
    ["GOD-005-EEEEE-55555"] = true,
    ["GOD-006-FFFFF-66666"] = true,
    ["GOD-007-GGGGG-77777"] = true,
    ["GOD-008-HHHHH-88888"] = true,
    ["GOD-009-IIIII-99999"] = true,
    ["GOD-010-JJJJJ-00000"] = true,
    ["KING-001-AAAAA-11111"] = true,
    ["KING-002-BBBBB-22222"] = true,
    ["KING-003-CCCCC-33333"] = true,
    ["KING-004-DDDDD-44444"] = true,
    ["KING-005-EEEEE-55555"] = true,
    ["KING-006-FFFFF-66666"] = true,
    ["KING-007-GGGGG-77777"] = true,
    ["KING-008-HHHHH-88888"] = true,
    ["KING-009-IIIII-99999"] = true,
    ["KING-010-JJJJJ-00000"] = true,
    ["RANDOM-A1B2-C3D4-E5F6-G7H8"] = true,
    ["RANDOM-I9J0-K1L2-M3N4-O5P6"] = true,
    ["RANDOM-Q7R8-S9T0-U1V2-W3X4"] = true,
    ["RANDOM-Y5Z6-A7B8-C9D0-E1F2"] = true,
    ["RANDOM-G3H4-I5J6-K7L8-M9N0"] = true,
    ["RANDOM-O1P2-Q3R4-S5T6-U7V8"] = true,
    ["RANDOM-W9X0-Y1Z2-A3B4-C5D6"] = true,
    ["RANDOM-E7F8-G9H0-I1J2-K3L4"] = true,
    ["RANDOM-M5N6-O7P8-Q9R0-S1T2"] = true,
    ["RANDOM-U3V4-W5X6-Y7Z8-A9B0"] = true,
    ["SECRET-001-XXXXX-11111"] = true,
    ["SECRET-002-YYYYY-22222"] = true,
    ["SECRET-003-ZZZZZ-33333"] = true,
    ["SECRET-004-AAAAA-44444"] = true,
    ["SECRET-005-BBBBB-55555"] = true,
    ["SECRET-006-CCCCC-66666"] = true,
    ["SECRET-007-DDDDD-77777"] = true,
    ["SECRET-008-EEEEE-88888"] = true,
    ["SECRET-009-FFFFF-99999"] = true,
    ["SECRET-010-GGGGG-00000"] = true,
    ["GOLD-001-HHHHH-11111"] = true,
    ["GOLD-002-IIIII-22222"] = true,
    ["GOLD-003-JJJJJ-33333"] = true,
    ["GOLD-004-KKKKK-44444"] = true,
    ["GOLD-005-LLLLL-55555"] = true,
    ["GOLD-006-MMMMM-66666"] = true,
    ["GOLD-007-NNNNN-77777"] = true,
    ["GOLD-008-OOOOO-88888"] = true,
    ["GOLD-009-PPPPP-99999"] = true,
    ["GOLD-010-QQQQQ-00000"] = true,
    ["SILVER-001-RRRRR-11111"] = true,
    ["SILVER-002-SSSSS-22222"] = true,
    ["SILVER-003-TTTTT-33333"] = true,
    ["SILVER-004-UUUUU-44444"] = true,
    ["SILVER-005-VVVVV-55555"] = true,
    ["SILVER-006-WWWWW-66666"] = true,
    ["SILVER-007-XXXXX-77777"] = true,
    ["SILVER-008-YYYYY-88888"] = true,
    ["SILVER-009-ZZZZZ-99999"] = true,
    ["SILVER-010-AAAAA-00000"] = true,
    ["DIAMOND-01-BBBBB-11111"] = true,
    ["DIAMOND-02-CCCCC-22222"] = true,
    ["DIAMOND-03-DDDDD-33333"] = true,
    ["DIAMOND-04-EEEEE-44444"] = true,
    ["DIAMOND-05-FFFFF-55555"] = true,
    ["DIAMOND-06-GGGGG-66666"] = true,
    ["DIAMOND-07-HHHHH-77777"] = true,
    ["DIAMOND-08-IIIII-88888"] = true,
    ["DIAMOND-09-JJJJJ-99999"] = true,
    ["DIAMOND-10-KKKKK-00000"] = true,
    ["PLATINUM-01-LLLLL-11111"] = true,
    ["PLATINUM-02-MMMMM-22222"] = true,
    ["PLATINUM-03-NNNNN-33333"] = true,
    ["PLATINUM-04-OOOOO-44444"] = true,
    ["PLATINUM-05-PPPPP-55555"] = true,
    ["PLATINUM-06-QQQQQ-66666"] = true,
    ["PLATINUM-07-RRRRR-77777"] = true,
    ["PLATINUM-08-SSSSS-88888"] = true,
    ["PLATINUM-09-TTTTT-99999"] = true,
    ["PLATINUM-10-UUUUU-00000"] = true,
    ["TITANIUM-01-VVVVV-11111"] = true,
    ["TITANIUM-02-WWWWW-22222"] = true,
    ["TITANIUM-03-XXXXX-33333"] = true,
    ["TITANIUM-04-YYYYY-44444"] = true,
    ["TITANIUM-05-ZZZZZ-55555"] = true,
    ["TITANIUM-06-AAAAA-66666"] = true,
    ["TITANIUM-07-BBBBB-77777"] = true,
    ["TITANIUM-08-CCCCC-88888"] = true,
    ["TITANIUM-09-DDDDD-99999"] = true,
    ["TITANIUM-10-EEEEE-00000"] = true,
    ["KHANH-SP01-AAAAA-99999"] = true,
    ["KHANH-SP02-BBBBB-88888"] = true,
    ["KHANH-SP03-CCCCC-77777"] = true,
    ["KHANH-SP04-DDDDD-66666"] = true,
    ["KHANH-SP05-EEEEE-55555"] = true,
    ["KHANH-SP06-FFFFF-44444"] = true,
    ["KHANH-SP07-GGGGG-33333"] = true,
    ["KHANH-SP08-HHHHH-22222"] = true,
    ["KHANH-SP09-IIIII-11111"] = true,
    ["KHANH-SP10-JJJJJ-00000"] = true,
    ["VIPPRO-1000-XXXXX-12345"] = true,
    ["VIPPRO-2000-YYYYY-23456"] = true,
    ["VIPPRO-3000-ZZZZZ-34567"] = true,
    ["VIPPRO-4000-AAAAA-45678"] = true,
    ["VIPPRO-5000-BBBBB-56789"] = true,
    ["VIPPRO-6000-CCCCC-67890"] = true,
    ["VIPPRO-7000-DDDDD-78901"] = true,
    ["VIPPRO-8000-EEEEE-89012"] = true,
    ["VIPPRO-9000-FFFFF-90123"] = true,
    ["VIPPRO-9999-GGGGG-01234"] = true,
    ["PREMIUM-100-HHHHH-123456"] = true,
    ["PREMIUM-200-IIIII-234567"] = true,
    ["PREMIUM-300-JJJJJ-345678"] = true,
    ["PREMIUM-400-KKKKK-456789"] = true,
    ["PREMIUM-500-LLLLL-567890"] = true,
    ["PREMIUM-600-MMMMM-678901"] = true,
    ["PREMIUM-700-NNNNN-789012"] = true,
    ["PREMIUM-800-OOOOO-890123"] = true,
    ["PREMIUM-900-PPPPP-901234"] = true,
    ["PREMIUM-999-QQQQQ-012345"] = true,
    ["ULTIMA-100-RRRRR-123456"] = true,
    ["ULTIMA-200-SSSSS-234567"] = true,
    ["ULTIMA-300-TTTTT-345678"] = true,
    ["ULTIMA-400-UUUUU-456789"] = true,
    ["ULTIMA-500-VVVVV-567890"] = true,
    ["ULTIMA-600-WWWWW-678901"] = true,
    ["ULTIMA-700-XXXXX-789012"] = true,
    ["ULTIMA-800-YYYYY-890123"] = true,
    ["ULTIMA-900-ZZZZZ-901234"] = true,
    ["ULTIMA-999-AAAAA-012345"] = true,
    ["MASTER-100-BBBBB-123456"] = true,
    ["MASTER-200-CCCCC-234567"] = true,
    ["MASTER-300-DDDDD-345678"] = true,
    ["MASTER-400-EEEEE-456789"] = true,
    ["MASTER-500-FFFFF-567890"] = true,
    ["MASTER-600-GGGGG-678901"] = true,
    ["MASTER-700-HHHHH-789012"] = true,
    ["MASTER-800-IIIII-890123"] = true,
    ["MASTER-900-JJJJJ-901234"] = true,
    ["MASTER-999-KKKKK-012345"] = true,
    ["LEGEND-100-LLLLL-123456"] = true,
    ["LEGEND-200-MMMMM-234567"] = true,
    ["LEGEND-300-NNNNN-345678"] = true,
    ["LEGEND-400-OOOOO-456789"] = true,
    ["LEGEND-500-PPPPP-567890"] = true,
    ["LEGEND-600-QQQQQ-678901"] = true,
    ["LEGEND-700-RRRRR-789012"] = true,
    ["LEGEND-800-SSSSS-890123"] = true,
    ["LEGEND-900-TTTTT-901234"] = true,
    ["LEGEND-999-UUUUU-012345"] = true,
    ["ELITE-100-VVVVV-12345"] = true,
    ["ELITE-200-WWWWW-23456"] = true,
    ["ELITE-300-XXXXX-34567"] = true,
    ["ELITE-400-YYYYY-45678"] = true,
    ["ELITE-500-ZZZZZ-56789"] = true,
    ["ELITE-600-AAAAA-67890"] = true,
    ["ELITE-700-BBBBB-78901"] = true,
    ["ELITE-800-CCCCC-89012"] = true,
    ["ELITE-900-DDDDD-90123"] = true,
    ["ELITE-999-EEEEE-01234"] = true,
    ["PRO-0100-FFFFF-12345"] = true,
    ["PRO-0200-GGGGG-23456"] = true,
    ["PRO-0300-HHHHH-34567"] = true,
    ["PRO-0400-IIIII-45678"] = true,
    ["PRO-0500-JJJJJ-56789"] = true,
    ["PRO-0600-KKKKK-67890"] = true,
    ["PRO-0700-LLLLL-78901"] = true,
    ["PRO-0800-MMMMM-89012"] = true,
    ["PRO-0900-NNNNN-90123"] = true,
    ["PRO-0999-OOOOO-01234"] = true,
    ["GOD-100-PPPPP-12345"] = true,
    ["GOD-200-QQQQQ-23456"] = true,
    ["GOD-300-RRRRR-34567"] = true,
    ["GOD-400-SSSSS-45678"] = true,
    ["GOD-500-TTTTT-56789"] = true,
    ["GOD-600-UUUUU-67890"] = true,
    ["GOD-700-VVVVV-78901"] = true,
    ["GOD-800-WWWWW-89012"] = true,
    ["GOD-900-XXXXX-90123"] = true,
    ["GOD-999-YYYYY-01234"] = true,
    ["KING-100-ZZZZZ-12345"] = true,
    ["KING-200-AAAAA-23456"] = true,
    ["KING-300-BBBBB-34567"] = true,
    ["KING-400-CCCCC-45678"] = true,
    ["KING-500-DDDDD-56789"] = true,
    ["KING-600-EEEEE-67890"] = true,
    ["KING-700-FFFFF-78901"] = true,
    ["KING-800-GGGGG-89012"] = true,
    ["KING-900-HHHHH-90123"] = true,
    ["KING-999-IIIII-01234"] = true
}
local isKeyValid = false

-- ============================================
-- HÀM KIỂM TRA
-- ============================================
local function isInSameArea(targetPosition)
    local character = player.Character
    if not character then return false end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local distance = (targetPosition - root.Position).Magnitude
    return distance <= 500
end

local function isTargetVisible(targetPosition)
    if not _G.checkWall then return true end
    
    local character = player.Character
    if not character then return false end
    local head = character:FindFirstChild("Head")
    if not head then return false end
    
    local origin = head.Position
    local direction = (targetPosition - origin).Unit * (targetPosition - origin).Magnitude
    
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {character, camera}
    
    local result = workspace:Raycast(origin, direction, params)
    if not result then return true end
    
    local hitInstance = result.Instance
    if hitInstance then
        local hitParent = hitInstance.Parent
        if hitParent and hitParent:IsA("Model") and hitParent:FindFirstChild("Humanoid") then
            return true
        end
    end
    return false
end

-- ============================================
-- FIX LAG (FIXED)
-- ============================================
local function saveLightingSettings()
    _G.originalLightingSettings = {
        Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
        FogEnd = Lighting.FogEnd, FogStart = Lighting.FogStart, FogColor = Lighting.FogColor,
        Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
        ColorShift_Bottom = Lighting.ColorShift_Bottom, ColorShift_Top = Lighting.ColorShift_Top,
        Technology = Lighting.Technology, EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
        GlobalShadows = Lighting.GlobalShadows, ShadowSoftness = Lighting.ShadowSoftness
    }
end

local function applyFixLag(enabled)
    if enabled then
        if next(_G.originalLightingSettings) == nil then saveLightingSettings() end
        
        Lighting.Brightness = 1
        Lighting.ClockTime = 12
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        Lighting.FogColor = Color3.new(0, 0, 0)
        Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
        Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
        Lighting.ColorShift_Top = Color3.new(0, 0, 0)
        Lighting.Technology = Enum.Technology.Compatibility
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.GlobalShadows = false
        Lighting.ShadowSoftness = 0
        
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or 
               v:IsA("ColorCorrectionEffect") or v:IsA("DepthOfFieldEffect") or 
               v:IsA("SunRaysEffect") then
                pcall(function() v.Enabled = false end)
            end
            if v:IsA("Sky") then
                pcall(function() v.Enabled = false end)
            end
        end
        
        if camera then camera.FieldOfView = 70 end
        Debris.MaxItems = 100
        sendNotification("FIX LAG", "✅ ĐÃ BẬT CHẾ ĐỘ TỐI ƯU", 2, "⚡")
    else
        if next(_G.originalLightingSettings) ~= nil then
            for k, v in pairs(_G.originalLightingSettings) do
                pcall(function() Lighting[k] = v end)
            end
        end
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or 
               v:IsA("ColorCorrectionEffect") or v:IsA("DepthOfFieldEffect") or 
               v:IsA("SunRaysEffect") then
                pcall(function() v.Enabled = true end)
            end
            if v:IsA("Sky") then
                pcall(function() v.Enabled = true end)
            end
        end
        sendNotification("FIX LAG", "❌ ĐÃ TẮT CHẾ ĐỘ TỐI ƯU", 2, "⚡")
    end
end

-- ============================================
-- AUTO CLICK
-- ============================================
local function autoClick()
    if not _G.autoShoot then 
        _G.isClicking = false
        return 
    end
    
    if _G.lockedTarget then
        local targetChar = _G.lockedTarget.character
        if not targetChar then
            _G.lockedTarget = nil
            _G.isClicking = false
            return
        end
        
        local targetHead = _G.lockedTarget.head
        if not targetHead or not targetHead.Parent then
            _G.lockedTarget = nil
            _G.isClicking = false
            return
        end
        
        local targetHumanoid = _G.lockedTarget.humanoid or targetChar:FindFirstChildOfClass("Humanoid")
        if not targetHumanoid or targetHumanoid.Health <= 0 then
            _G.lockedTarget = nil
            _G.isClicking = false
            return
        end
        
        if isTargetVisible(targetHead.Position) then
            if not _G.isClicking then
                _G.isClicking = true
                task.spawn(function()
                    while _G.autoShoot and _G.lockedTarget and _G.isClicking do
                        mouse1press()
                        task.wait(0.05)
                        mouse1release()
                        task.wait(_G.clickInterval)
                    end
                end)
            end
        else
            _G.isClicking = false
        end
    else
        _G.isClicking = false
    end
end

-- ============================================
-- WALLHACK ESP
-- ============================================
local function createNameTag(plr)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "WallHack_" .. plr.Name
    billboard.Size = UDim2.new(0, 220, 0, 90)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = true
    billboard.ResetOnSpawn = false
    billboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    billboard.ClipsDescendants = false
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
    bg.BackgroundTransparency = 0.2
    bg.BorderSizePixel = 0
    bg.Parent = billboard
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 12)
    bgCorner.Parent = bg
    
    local bgGradient = Instance.new("UIGradient")
    bgGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 28, 35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 13, 20))
    })
    bgGradient.Rotation = 90
    bgGradient.Parent = bg
    
    local bgStroke = Instance.new("UIStroke")
    bgStroke.Color = Color3.fromRGB(0, 200, 255)
    bgStroke.Thickness = 2
    bgStroke.Transparency = 0.5
    bgStroke.Parent = bg
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -10, 0, 28)
    nameLabel.Position = UDim2.new(0, 5, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = plr.DisplayName
    nameLabel.Font = Enum.Font.GothamBlack
    nameLabel.TextSize = 18
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.Parent = bg
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "Distance"
    distanceLabel.Size = UDim2.new(0.5, -5, 0, 22)
    distanceLabel.Position = UDim2.new(0, 5, 0, 33)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "📏 0m"
    distanceLabel.Font = Enum.Font.GothamBold
    distanceLabel.TextSize = 14
    distanceLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    distanceLabel.TextXAlignment = Enum.TextXAlignment.Left
    distanceLabel.Parent = bg
    
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Name = "Health"
    healthLabel.Size = UDim2.new(0.5, -5, 0, 22)
    healthLabel.Position = UDim2.new(0.5, 0, 0, 33)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "❤️ 150/150"
    healthLabel.Font = Enum.Font.GothamBold
    healthLabel.TextSize = 14
    healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    healthLabel.TextXAlignment = Enum.TextXAlignment.Right
    healthLabel.Parent = bg
    
    local weaponLabel = Instance.new("TextLabel")
    weaponLabel.Name = "Weapon"
    weaponLabel.Size = UDim2.new(1, -10, 0, 20)
    weaponLabel.Position = UDim2.new(0, 5, 0, 55)
    weaponLabel.BackgroundTransparency = 1
    weaponLabel.Text = "🔫 No Weapon"
    weaponLabel.Font = Enum.Font.GothamBold
    weaponLabel.TextSize = 12
    weaponLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    weaponLabel.TextXAlignment = Enum.TextXAlignment.Center
    weaponLabel.Parent = bg
    
    local hpBar = Instance.new("Frame")
    hpBar.Name = "HPBar"
    hpBar.Size = UDim2.new(1, -10, 0, 6)
    hpBar.Position = UDim2.new(0, 5, 0, 76)
    hpBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    hpBar.BorderSizePixel = 0
    hpBar.Parent = bg
    
    local hpBarCorner = Instance.new("UICorner")
    hpBarCorner.CornerRadius = UDim.new(0, 3)
    hpBarCorner.Parent = hpBar
    
    local hpFill = Instance.new("Frame")
    hpFill.Name = "HPFill"
    hpFill.Size = UDim2.new(1, 0, 1, 0)
    hpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    hpFill.BorderSizePixel = 0
    hpFill.Parent = hpBar
    
    local hpFillCorner = Instance.new("UICorner")
    hpFillCorner.CornerRadius = UDim.new(0, 3)
    hpFillCorner.Parent = hpFill
    
    return billboard
end

local function createBoxESP(plr)
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "BoxESP_" .. plr.Name
    box.Size = Vector3.new(4, 5.5, 2.2)
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Transparency = 0.3
    box.Color3 = Color3.fromRGB(0, 200, 255)
    box.Adornee = nil
    box.Visible = true
    return box
end

local function isTeamMate(plr)
    return _G.teamMates[plr.UserId] == true
end

local function wallHack()
    if not _G.dangWallHack then
        for _, tag in pairs(_G.espNameTags) do
            pcall(function() tag.Enabled = false end)
        end
        for _, box in pairs(_G.espBoxes) do
            pcall(function() box.Visible = false end)
        end
        return
    end
    
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= player then
            local otherChar = other.Character
            if otherChar and otherChar:FindFirstChild("Head") and otherChar:FindFirstChild("HumanoidRootPart") then
                local head = otherChar.Head
                local hrp = otherChar.HumanoidRootPart
                local humanoid = otherChar:FindFirstChildOfClass("Humanoid")
                local distance = (hrp.Position - root.Position).Magnitude
                local showESP = isInSameArea(hrp.Position) and distance < 1000
                
                if not _G.espNameTags[other] and showESP then
                    _G.espNameTags[other] = createNameTag(other)
                    _G.espNameTags[other].Parent = head
                end
                
                if not _G.espBoxes[other] and showESP then
                    _G.espBoxes[other] = createBoxESP(other)
                    _G.espBoxes[other].Parent = otherChar
                end
                
                if _G.espNameTags[other] then
                    _G.espNameTags[other].Enabled = showESP
                end
                
                if _G.espBoxes[other] then
                    _G.espBoxes[other].Visible = showESP
                end
                
                if showESP and _G.espNameTags[other] then
                    local tag = _G.espNameTags[other]
                    local frame = tag:FindFirstChild("Frame")
                    if frame then
                        local distLabel = frame:FindFirstChild("Distance")
                        if distLabel then
                            distLabel.Text = string.format("📏 %.0fm", distance)
                        end
                        
                        local healthLabel = frame:FindFirstChild("Health")
                        local hpBar = frame:FindFirstChild("HPBar")
                        local hpFill = hpBar and hpBar:FindFirstChild("HPFill")
                        
                        if humanoid and healthLabel and hpFill then
                            local hp = humanoid.Health
                            local maxHp = humanoid.MaxHealth
                            healthLabel.Text = string.format("❤️ %.0f/%.0f", hp, maxHp)
                            local hpPercent = (hp / maxHp) * 100
                            hpFill.Size = UDim2.new(hpPercent/100, 0, 1, 0)
                            
                            if hpPercent > 60 then
                                healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                                hpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                            elseif hpPercent > 30 then
                                healthLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                                hpFill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                            else
                                healthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                                hpFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                            end
                        end
                        
                        local weaponLabel = frame:FindFirstChild("Weapon")
                        if weaponLabel then
                            local tool = otherChar:FindFirstChildOfClass("Tool")
                            weaponLabel.Text = tool and "🔫 " .. tool.Name or "🔫 No Weapon"
                        end
                        
                        local stroke = frame:FindFirstChildOfClass("UIStroke")
                        if stroke then
                            if isTeamMate(other) then
                                stroke.Color = Color3.fromRGB(0, 255, 0)
                                stroke.Thickness = 2.5
                                stroke.Transparency = 0.2
                            elseif _G.lockedTarget and _G.lockedTarget.player == other then
                                stroke.Color = Color3.fromRGB(255, 0, 0)
                                stroke.Thickness = 2.5
                                stroke.Transparency = 0.2
                            else
                                stroke.Color = Color3.fromRGB(0, 255, 255)
                                stroke.Thickness = 2
                                stroke.Transparency = 0.5
                            end
                        end
                    end
                end
                
                local box = _G.espBoxes[other]
                if box and showESP then
                    box.Adornee = hrp
                    box.Visible = true
                    if isTeamMate(other) then
                        box.Color3 = Color3.fromRGB(0, 255, 0)
                        box.Transparency = 0.1
                    elseif _G.lockedTarget and _G.lockedTarget.player == other then
                        box.Color3 = Color3.fromRGB(255, 0, 0)
                        box.Transparency = 0.1
                    else
                        box.Color3 = Color3.fromRGB(0, 255, 255)
                        box.Transparency = 0.3
                    end
                end
            end
        end
    end
end

local function khoiTaoWallHack()
    for _, tag in pairs(_G.espNameTags) do
        pcall(function() tag:Destroy() end)
    end
    for _, box in pairs(_G.espBoxes) do
        pcall(function() box:Destroy() end)
    end
    _G.espNameTags = {}
    _G.espBoxes = {}
    
    if _G.dangWallHack then
        for _, other in ipairs(Players:GetPlayers()) do
            if other ~= player then
                local char = other.Character
                if char and char:FindFirstChild("Head") then
                    _G.espNameTags[other] = createNameTag(other)
                    _G.espNameTags[other].Parent = char.Head
                    _G.espBoxes[other] = createBoxESP(other)
                    _G.espBoxes[other].Parent = char
                end
            end
        end
    end
    
    if _G.ketNoiWallHack then
        _G.ketNoiWallHack:Disconnect()
    end
    _G.ketNoiWallHack = RunService.Heartbeat:Connect(wallHack)
end

-- ============================================
-- AIM BOT
-- ============================================
local function findTarget()
    local char = player.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    local target = nil
    local minDist = 999999
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and not isTeamMate(p) then
            local c = p.Character
            if c and c:FindFirstChild("Head") and c:FindFirstChild("HumanoidRootPart") then
                local head = c.Head
                local humanoid = c:FindFirstChildOfClass("Humanoid")
                
                if humanoid and humanoid.Health > 0 then
                    local dist = (head.Position - root.Position).Magnitude
                    if dist < minDist and isTargetVisible(head.Position) and isInSameArea(head.Position) then
                        minDist = dist
                        target = {
                            player = p, character = c, head = head,
                            root = c.HumanoidRootPart, humanoid = humanoid
                        }
                    end
                end
            end
        end
    end
    return target
end

local function huyTarget()
    _G.lockedTarget = nil
    _G.isClicking = false
end

local function aimBot()
    if not _G.dangAimBot then
        _G.lockedTarget = nil
        return
    end
    
    if not _G.lockedTarget then
        _G.lockedTarget = findTarget()
    end
    
    if _G.lockedTarget then
        local c = _G.lockedTarget.character
        if not c or not c.Parent then
            _G.lockedTarget = nil
            return
        end
        
        local head = _G.lockedTarget.head
        if not head or not head.Parent then
            _G.lockedTarget = nil
            return
        end
        
        local humanoid = _G.lockedTarget.humanoid or c:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then
            _G.lockedTarget = nil
            return
        end
        
        if isInSameArea(head.Position) and isTargetVisible(head.Position) then
            camera.CFrame = CFrame.lookAt(camera.CFrame.Position, head.Position)
        else
            _G.lockedTarget = findTarget()
        end
    end
end

-- ============================================
-- FLY MODE
-- ============================================
local function startFly()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    humanoid.PlatformStand = true
    _G.flyBodyVelocity = Instance.new("BodyVelocity")
    _G.flyBodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    _G.flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    _G.flyBodyVelocity.Parent = root
    
    _G.flyBodyGyro = Instance.new("BodyGyro")
    _G.flyBodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
    _G.flyBodyGyro.P = 1000
    _G.flyBodyGyro.D = 50
    _G.flyBodyGyro.CFrame = root.CFrame
    _G.flyBodyGyro.Parent = root
end

local function stopFly()
    local char = player.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.PlatformStand = false end
    if _G.flyBodyVelocity then _G.flyBodyVelocity:Destroy() end
    if _G.flyBodyGyro then _G.flyBodyGyro:Destroy() end
    _G.flyBodyVelocity = nil
    _G.flyBodyGyro = nil
end

local function flyUpdate()
    if not _G.dangFly then
        if _G.flyBodyVelocity or _G.flyBodyGyro then stopFly() end
        return
    end
    
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    if not _G.flyBodyVelocity or not _G.flyBodyVelocity.Parent then startFly() end
    
    local cameraDirection = camera.CFrame.LookVector
    local cameraRight = camera.CFrame.RightVector
    local moveDirection = Vector3.new(0, 0, 0)
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + cameraDirection end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - cameraDirection end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - cameraRight end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + cameraRight end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
    
    if moveDirection.Magnitude > 0 then moveDirection = moveDirection.Unit * _G.flySpeed end
    if _G.flyBodyVelocity then _G.flyBodyVelocity.Velocity = moveDirection end
    if _G.flyBodyGyro then _G.flyBodyGyro.CFrame = camera.CFrame end
end

-- ============================================
-- AUTO TELE
-- ============================================
local function getTeleportOffset()
    if _G.teleportPosition == "dau" then
        return CFrame.new(0, 3, 0)
    elseif _G.teleportPosition == "truoc" then
        return CFrame.new(0, 1, 3)
    else
        return CFrame.new(0, 1, -3)
    end
end

local function autoTele()
    if not _G.dangAutoTele then return end
    if not _G.lockedTarget then return end
    
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local targetChar = _G.lockedTarget.character
    if not targetChar then
        _G.lockedTarget = nil
        return
    end
    
    local targetRoot = _G.lockedTarget.root or targetChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot then
        _G.lockedTarget = nil
        return
    end
    
    local offset = getTeleportOffset()
    root.CFrame = targetRoot.CFrame * offset
end

-- ============================================
-- SPIN BOT
-- ============================================
local function spinBot()
    if not _G.dangXoay then return end
    
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.AutoRotate = false end
    
    local speed = math.clamp(_G.tocDoSpin, 1, 10000)
    
    if _G.cheDoSpinHienTai == 1 then
        root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(speed * 0.1), 0)
    else
        root.CFrame = root.CFrame * CFrame.Angles(math.rad(speed * 0.05), 0, 0)
    end
end

local function resetSpin(char)
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.AutoRotate = true end
    if _G.ketNoiMang then
        _G.ketNoiMang:Disconnect()
        _G.ketNoiMang = nil
    end
end

-- ============================================
-- PLAYER LIST OVERLAY (ALWAYS VISIBLE WITH TEAM MARK)
-- ============================================
local playerOverlay = nil
local playerOverlayUpdateConnection = nil
local playerListContainer = nil
local playerItemsOverlay = {}
local playerDataOverlay = {}
local currentModeOverlay = "near"
local NEAR_DISTANCE = 250
local overlayVisible = true
local currentSearchText = ""

local function createPlayerOverlay()
    if playerOverlay and playerOverlay.Parent then
        return
    end
    
    local oldOverlay = CoreGui:FindFirstChild("PlayerOverlay")
    if oldOverlay then oldOverlay:Destroy() end
    
    playerOverlay = Instance.new("ScreenGui")
    playerOverlay.Name = "PlayerOverlay"
    playerOverlay.Parent = CoreGui
    playerOverlay.ResetOnSpawn = false
    playerOverlay.IgnoreGuiInset = true
    playerOverlay.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    playerOverlay.DisplayOrder = 999999
    
    local overlayWidth = math.floor(340 * ScreenScale)
    local overlayHeight = math.floor(480 * ScreenScale)
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, overlayWidth, 0, overlayHeight)
    mainFrame.Position = UDim2.new(0.02, 0, 0.2, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
    mainFrame.BackgroundTransparency = 0.08
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = playerOverlay
    
    CreateShadow(mainFrame, UDim2.new(1, 20, 1, 20), 0.7)
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(0, 200, 255)
    mainStroke.Thickness = 1.5
    mainStroke.Transparency = 0.4
    mainStroke.Parent = mainFrame
    
    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 50 * ScreenScale)
    header.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    header.BackgroundTransparency = 0.15
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = header
    
    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 230))
    })
    headerGradient.Rotation = 45
    headerGradient.Parent = header
    
    local titleIcon = Instance.new("TextLabel")
    titleIcon.Size = UDim2.new(0, 30 * ScreenScale, 1, 0)
    titleIcon.Position = UDim2.new(0, 8 * ScreenScale, 0, 0)
    titleIcon.BackgroundTransparency = 1
    titleIcon.Text = "👥"
    titleIcon.Font = Enum.Font.GothamBlack
    titleIcon.TextSize = 20 * ScreenScale
    titleIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleIcon.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 120 * ScreenScale, 1, 0)
    title.Position = UDim2.new(0, 40 * ScreenScale, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "PLAYER LIST"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 16 * ScreenScale
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 30 * ScreenScale, 0, 30 * ScreenScale)
    minimizeBtn.Position = UDim2.new(1, -70 * ScreenScale, 0, 10 * ScreenScale)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    minimizeBtn.BackgroundTransparency = 0.1
    minimizeBtn.Text = "➖"
    minimizeBtn.Font = Enum.Font.GothamBlack
    minimizeBtn.TextSize = 16 * ScreenScale
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.AutoButtonColor = false
    minimizeBtn.Parent = header
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 8)
    minimizeCorner.Parent = minimizeBtn
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30 * ScreenScale, 0, 30 * ScreenScale)
    closeBtn.Position = UDim2.new(1, -35 * ScreenScale, 0, 10 * ScreenScale)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    closeBtn.BackgroundTransparency = 0.1
    closeBtn.Text = "✖"
    closeBtn.Font = Enum.Font.GothamBlack
    closeBtn.TextSize = 16 * ScreenScale
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.BorderSizePixel = 0
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = header
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn
    
    -- 2 nút chọn chế độ
    local modeFrame = Instance.new("Frame")
    modeFrame.Size = UDim2.new(1, -10, 0, 32 * ScreenScale)
    modeFrame.Position = UDim2.new(0, 5, 0, 55 * ScreenScale)
    modeFrame.BackgroundTransparency = 1
    modeFrame.Parent = mainFrame
    
    local nearBtn = Instance.new("TextButton")
    nearBtn.Size = UDim2.new(0.5, -3, 1, 0)
    nearBtn.Position = UDim2.new(0, 0, 0, 0)
    nearBtn.BackgroundColor3 = currentModeOverlay == "near" and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(50, 50, 70)
    nearBtn.BackgroundTransparency = 0.1
    nearBtn.Text = "🎯 GẦN"
    nearBtn.Font = Enum.Font.GothamBold
    nearBtn.TextSize = 11 * ScreenScale
    nearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    nearBtn.BorderSizePixel = 0
    nearBtn.AutoButtonColor = false
    nearBtn.Parent = modeFrame
    
    local nearCorner = Instance.new("UICorner")
    nearCorner.CornerRadius = UDim.new(0, 8)
    nearCorner.Parent = nearBtn
    
    local allBtn = Instance.new("TextButton")
    allBtn.Size = UDim2.new(0.5, -3, 1, 0)
    allBtn.Position = UDim2.new(0.5, 3, 0, 0)
    allBtn.BackgroundColor3 = currentModeOverlay == "all" and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(50, 50, 70)
    allBtn.BackgroundTransparency = 0.1
    allBtn.Text = "🌍 ALL"
    allBtn.Font = Enum.Font.GothamBold
    allBtn.TextSize = 11 * ScreenScale
    allBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    allBtn.BorderSizePixel = 0
    allBtn.AutoButtonColor = false
    allBtn.Parent = modeFrame
    
    local allCorner = Instance.new("UICorner")
    allCorner.CornerRadius = UDim.new(0, 8)
    allCorner.Parent = allBtn
    
    nearBtn.MouseButton1Click:Connect(function()
        currentModeOverlay = "near"
        nearBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        allBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        updateOverlayList()
    end)
    
    allBtn.MouseButton1Click:Connect(function()
        currentModeOverlay = "all"
        allBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        nearBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        updateOverlayList()
    end)
    
    -- Thanh tìm kiếm
    local searchFrame = Instance.new("Frame")
    searchFrame.Size = UDim2.new(1, -10, 0, 32 * ScreenScale)
    searchFrame.Position = UDim2.new(0, 5, 0, 92 * ScreenScale)
    searchFrame.BackgroundColor3 = Color3.fromRGB(20, 23, 31)
    searchFrame.BackgroundTransparency = 0.2
    searchFrame.BorderSizePixel = 0
    searchFrame.Parent = mainFrame
    
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 8)
    searchCorner.Parent = searchFrame
    
    local searchIcon = Instance.new("TextLabel")
    searchIcon.Size = UDim2.new(0, 25 * ScreenScale, 1, 0)
    searchIcon.Position = UDim2.new(0, 6 * ScreenScale, 0, 0)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Text = "🔍"
    searchIcon.Font = Enum.Font.GothamBold
    searchIcon.TextSize = 14 * ScreenScale
    searchIcon.TextColor3 = Color3.fromRGB(0, 200, 255)
    searchIcon.Parent = searchFrame
    
    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -35 * ScreenScale, 1, 0)
    searchBox.Position = UDim2.new(0, 32 * ScreenScale, 0, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.PlaceholderText = "Tìm..."
    searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
    searchBox.Text = ""
    searchBox.Font = Enum.Font.GothamBold
    searchBox.TextSize = 12 * ScreenScale
    searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.ClearTextOnFocus = true
    searchBox.Parent = searchFrame
    
    -- Count label
    local countLabel = Instance.new("TextLabel")
    countLabel.Name = "CountLabel"
    countLabel.Size = UDim2.new(1, -10, 0, 22 * ScreenScale)
    countLabel.Position = UDim2.new(0, 5, 0, 128 * ScreenScale)
    countLabel.BackgroundTransparency = 1
    countLabel.Text = "🎯 Đang tải..."
    countLabel.Font = Enum.Font.GothamBold
    countLabel.TextSize = 10 * ScreenScale
    countLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
    countLabel.TextXAlignment = Enum.TextXAlignment.Center
    countLabel.Parent = mainFrame
    
    -- Scroll frame
    playerListContainer = Instance.new("ScrollingFrame")
    playerListContainer.Size = UDim2.new(1, -10, 1, -165 * ScreenScale)
    playerListContainer.Position = UDim2.new(0, 5, 0, 155 * ScreenScale)
    playerListContainer.BackgroundTransparency = 1
    playerListContainer.BorderSizePixel = 0
    playerListContainer.ScrollBarThickness = 4
    playerListContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
    playerListContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    playerListContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    playerListContainer.Parent = mainFrame
    
    local playerListLayout = Instance.new("UIListLayout")
    playerListLayout.Padding = UDim.new(0, 3)
    playerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    playerListLayout.Parent = playerListContainer
    
    -- Hàm lấy thông tin người chơi
    local function getPlayerInfoOverlay(plr)
        local userId = plr.UserId
        local cached = playerDataOverlay[userId]
        local currentTime = tick()
        
        if cached and cached.time and (currentTime - cached.time) < 0.2 then
            return cached.data
        end
        
        local data = {
            name = plr.DisplayName,
            userId = userId,
            isPlayer = plr == player,
            isTeamMate = _G.teamMates[userId] == true,
            distance = "?",
            health = "?",
            rawDistance = 999999,
            hpPercent = 1
        }
        
        local plrChar = plr.Character
        local playerChar = player.Character
        
        if plrChar and plrChar:FindFirstChild("HumanoidRootPart") and playerChar and playerChar:FindFirstChild("HumanoidRootPart") then
            local dist = (plrChar.HumanoidRootPart.Position - playerChar.HumanoidRootPart.Position).Magnitude
            data.rawDistance = dist
            data.distance = string.format("%.0fm", dist)
            
            local humanoid = plrChar:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local hp = humanoid.Health
                local maxHp = humanoid.MaxHealth
                data.health = string.format("%.0f", hp)
                data.hpPercent = hp / maxHp
            end
        end
        
        playerDataOverlay[userId] = {
            time = currentTime,
            data = data
        }
        
        return data
    end
    
    -- Tạo item người chơi (có nút đánh dấu đồng đội)
    local function createPlayerItemOverlay(plr, data)
        local item = Instance.new("Frame")
        item.Size = UDim2.new(1, 0, 0, 42 * ScreenScale)
        item.BackgroundColor3 = Color3.fromRGB(20, 23, 31)
        item.BackgroundTransparency = 0.1
        item.BorderSizePixel = 0
        
        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, 6)
        itemCorner.Parent = item
        
        -- Avatar icon (màu xanh cho đồng đội)
        local avatar = Instance.new("TextLabel")
        avatar.Size = UDim2.new(0, 28 * ScreenScale, 0, 28 * ScreenScale)
        avatar.Position = UDim2.new(0, 4 * ScreenScale, 0.5, -14 * ScreenScale)
        avatar.BackgroundColor3 = data.isTeamMate and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(0, 150, 200)
        avatar.BackgroundTransparency = 0.1
        avatar.Text = string.sub(data.name, 1, 1):upper()
        avatar.Font = Enum.Font.GothamBlack
        avatar.TextSize = 14 * ScreenScale
        avatar.TextColor3 = Color3.fromRGB(255, 255, 255)
        avatar.BorderSizePixel = 0
        
        local avatarCorner = Instance.new("UICorner")
        avatarCorner.CornerRadius = UDim.new(0, 6)
        avatarCorner.Parent = avatar
        avatar.Parent = item
        
        -- Tên
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0, 150 * ScreenScale, 0, 18 * ScreenScale)
        nameLabel.Position = UDim2.new(0, 38 * ScreenScale, 0, 4 * ScreenScale)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = data.name
        nameLabel.Font = Enum.Font.GothamBlack
        nameLabel.TextSize = 11 * ScreenScale
        nameLabel.TextColor3 = data.isPlayer and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(255, 255, 255)
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
        nameLabel.Parent = item
        
        -- Thông tin khoảng cách và máu
        local infoLabel = Instance.new("TextLabel")
        infoLabel.Name = "InfoLabel"
        infoLabel.Size = UDim2.new(0, 150 * ScreenScale, 0, 14 * ScreenScale)
        infoLabel.Position = UDim2.new(0, 38 * ScreenScale, 0, 22 * ScreenScale)
        infoLabel.BackgroundTransparency = 1
        infoLabel.Text = string.format("📏 %s | ❤️ %s", data.distance, data.health)
        infoLabel.Font = Enum.Font.GothamBold
        infoLabel.TextSize = 9 * ScreenScale
        infoLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
        infoLabel.TextXAlignment = Enum.TextXAlignment.Left
        infoLabel.Parent = item
        
        -- Thanh máu
        local hpBar = Instance.new("Frame")
        hpBar.Size = UDim2.new(0, 60 * ScreenScale, 0, 3 * ScreenScale)
        hpBar.Position = UDim2.new(0, 38 * ScreenScale, 0, 36 * ScreenScale)
        hpBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        hpBar.BorderSizePixel = 0
        hpBar.Parent = item
        
        local hpBarCorner = Instance.new("UICorner")
        hpBarCorner.CornerRadius = UDim.new(0, 2)
        hpBarCorner.Parent = hpBar
        
        local hpFill = Instance.new("Frame")
        hpFill.Name = "HPFill"
        hpFill.Size = UDim2.new(data.hpPercent or 1, 0, 1, 0)
        hpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        hpFill.BorderSizePixel = 0
        hpFill.Parent = hpBar
        
        local hpFillCorner = Instance.new("UICorner")
        hpFillCorner.CornerRadius = UDim.new(0, 2)
        hpFillCorner.Parent = hpFill
        
        -- Nút đánh dấu đồng đội (⭐)
        if not data.isPlayer then
            local teamBtn = Instance.new("TextButton")
            teamBtn.Name = "TeamBtn"
            teamBtn.Size = UDim2.new(0, 24 * ScreenScale, 0, 24 * ScreenScale)
            teamBtn.Position = UDim2.new(1, -55 * ScreenScale, 0.5, -12 * ScreenScale)
            teamBtn.BackgroundColor3 = data.isTeamMate and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 90)
            teamBtn.BackgroundTransparency = 0.2
            teamBtn.Text = data.isTeamMate and "⭐" or "☆"
            teamBtn.Font = Enum.Font.GothamBlack
            teamBtn.TextSize = 14 * ScreenScale
            teamBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
            teamBtn.BorderSizePixel = 0
            teamBtn.AutoButtonColor = false
            teamBtn.Visible = false
            teamBtn.Parent = item
            
            local teamCorner = Instance.new("UICorner")
            teamCorner.CornerRadius = UDim.new(0, 4)
            teamCorner.Parent = teamBtn
            
            teamBtn.MouseButton1Click:Connect(function()
                if _G.teamMates[data.userId] then
                    _G.teamMates[data.userId] = nil
                    teamBtn.Text = "☆"
                    teamBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
                    avatar.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
                    sendNotification("KHANHPC", string.format("❌ Đã bỏ đánh dấu %s", data.name), 0.8, "⭐")
                else
                    _G.teamMates[data.userId] = true
                    teamBtn.Text = "⭐"
                    teamBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                    avatar.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                    sendNotification("KHANHPC", string.format("✅ Đã đánh dấu %s là đồng đội", data.name), 0.8, "⭐")
                end
                playerDataOverlay[data.userId] = nil
            end)
        end
        
        -- Nút teleport
        if not data.isPlayer then
            local teleBtn = Instance.new("TextButton")
            teleBtn.Name = "TeleBtn"
            teleBtn.Size = UDim2.new(0, 24 * ScreenScale, 0, 24 * ScreenScale)
            teleBtn.Position = UDim2.new(1, -28 * ScreenScale, 0.5, -12 * ScreenScale)
            teleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
            teleBtn.BackgroundTransparency = 0.3
            teleBtn.Text = "📍"
            teleBtn.Font = Enum.Font.GothamBlack
            teleBtn.TextSize = 12 * ScreenScale
            teleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            teleBtn.BorderSizePixel = 0
            teleBtn.AutoButtonColor = false
            teleBtn.Visible = false
            teleBtn.Parent = item
            
            local teleCorner = Instance.new("UICorner")
            teleCorner.CornerRadius = UDim.new(0, 4)
            teleCorner.Parent = teleBtn
            
            teleBtn.MouseButton1Click:Connect(function()
                local targetChar = plr.Character
                if targetChar and targetChar:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local targetPos = targetChar.HumanoidRootPart.Position
                    player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
                    sendNotification("KHANHPC", string.format("📍 Teleport đến %s", data.name), 0.8, "📍")
                end
            end)
        end
        
        -- Hover effect
        item.MouseEnter:Connect(function()
            TweenService:Create(item, TweenInfo.new(0.1), {
                BackgroundTransparency = 0.3
            }):Play()
            if item:FindFirstChild("TeamBtn") then
                item.TeamBtn.Visible = true
            end
            if item:FindFirstChild("TeleBtn") then
                item.TeleBtn.Visible = true
            end
        end)
        
        item.MouseLeave:Connect(function()
            TweenService:Create(item, TweenInfo.new(0.1), {
                BackgroundTransparency = 0.1
            }):Play()
            if item:FindFirstChild("TeamBtn") then
                item.TeamBtn.Visible = false
            end
            if item:FindFirstChild("TeleBtn") then
                item.TeleBtn.Visible = false
            end
        end)
        
        return item
    end
    
    -- Cập nhật item
    local function updatePlayerItemOverlay(item, data)
        if not item then return end
        
        local nameLabel = item:FindFirstChildOfClass("TextLabel")
        if nameLabel then
            nameLabel.Text = data.name
        end
        
        local infoLabel = item:FindFirstChild("InfoLabel")
        if infoLabel then
            infoLabel.Text = string.format("📏 %s | ❤️ %s", data.distance, data.health)
        end
        
        local hpBar = item:FindFirstChildOfClass("Frame")
        if hpBar then
            local hpFill = hpBar:FindFirstChild("HPFill")
            if hpFill then
                hpFill.Size = UDim2.new(data.hpPercent or 1, 0, 1, 0)
                if data.hpPercent > 0.6 then
                    hpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                elseif data.hpPercent > 0.3 then
                    hpFill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                else
                    hpFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                end
            end
        end
        
        local avatar = item:FindFirstChildOfClass("TextLabel")
        if avatar then
            avatar.BackgroundColor3 = data.isTeamMate and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(0, 150, 200)
        end
        
        local teamBtn = item:FindFirstChild("TeamBtn")
        if teamBtn and not data.isPlayer then
            teamBtn.Text = data.isTeamMate and "⭐" or "☆"
            teamBtn.BackgroundColor3 = data.isTeamMate and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 90)
        end
    end
    
    -- Lọc người chơi
    local function filterPlayersOverlay(allPlayers)
        if currentModeOverlay == "near" then
            local filtered = {}
            local playerChar = player.Character
            local playerRoot = playerChar and playerChar:FindFirstChild("HumanoidRootPart")
            
            if playerRoot then
                for _, plr in ipairs(allPlayers) do
                    if plr ~= player then
                        local char = plr.Character
                        local root = char and char:FindFirstChild("HumanoidRootPart")
                        if root then
                            local dist = (root.Position - playerRoot.Position).Magnitude
                            if dist <= NEAR_DISTANCE then
                                table.insert(filtered, plr)
                            end
                        end
                    end
                end
            end
            table.sort(filtered, function(a, b)
                local aData = getPlayerInfoOverlay(a)
                local bData = getPlayerInfoOverlay(b)
                return aData.rawDistance < bData.rawDistance
            end)
            table.insert(filtered, 1, player)
            return filtered
        else
            local all = {}
            for _, plr in ipairs(allPlayers) do
                table.insert(all, plr)
            end
            table.sort(all, function(a, b)
                if a == player then return true
                elseif b == player then return false
                else
                    local aData = getPlayerInfoOverlay(a)
                    local bData = getPlayerInfoOverlay(b)
                    return aData.rawDistance < bData.rawDistance
                end
            end)
            return all
        end
    end
    
    -- Cập nhật danh sách
    local function updateOverlayList()
        if not playerListContainer then return end
        
        local allPlayers = Players:GetPlayers()
        local filteredPlayers = filterPlayersOverlay(allPlayers)
        local playerCount = #allPlayers
        local displayCount = #filteredPlayers
        
        for _, plr in ipairs(filteredPlayers) do
            getPlayerInfoOverlay(plr)
        end
        
        for _, plr in ipairs(filteredPlayers) do
            local userId = plr.UserId
            local data = getPlayerInfoOverlay(plr)
            local searchMatch = currentSearchText == "" or data.name:lower():find(currentSearchText, 1, true)
            
            if searchMatch then
                if not playerItemsOverlay[userId] then
                    local item = createPlayerItemOverlay(plr, data)
                    item.Parent = playerListContainer
                    playerItemsOverlay[userId] = item
                    item.Visible = true
                else
                    updatePlayerItemOverlay(playerItemsOverlay[userId], data)
                    playerItemsOverlay[userId].Visible = true
                end
            elseif playerItemsOverlay[userId] then
                playerItemsOverlay[userId].Visible = false
            end
        end
        
        local validIds = {}
        for _, plr in ipairs(filteredPlayers) do
            validIds[plr.UserId] = true
        end
        for userId, item in pairs(playerItemsOverlay) do
            if not validIds[userId] then
                item.Visible = false
            end
        end
        
        if countLabel then
            if currentModeOverlay == "near" then
                countLabel.Text = string.format("🎯 GẦN: %d/%d", displayCount - 1, playerCount - 1)
            else
                countLabel.Text = string.format("🌍 TOÀN SERVER: %d", playerCount)
            end
        end
    end
    
    -- Thu gọn
    local isMinimized = false
    local originalHeight = overlayHeight
    
    minimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, overlayWidth, 0, 50 * ScreenScale)
            }):Play()
            minimizeBtn.Text = "➕"
            playerListContainer.Visible = false
            modeFrame.Visible = false
            searchFrame.Visible = false
            countLabel.Visible = false
        else
            TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, overlayWidth, 0, originalHeight)
            }):Play()
            minimizeBtn.Text = "➖"
            playerListContainer.Visible = true
            modeFrame.Visible = true
            searchFrame.Visible = true
            countLabel.Visible = true
        end
    end)
    
    -- Đóng overlay
    closeBtn.MouseButton1Click:Connect(function()
        if playerOverlay then
            playerOverlay:Destroy()
            playerOverlay = nil
        end
        if playerOverlayUpdateConnection then
            playerOverlayUpdateConnection:Disconnect()
            playerOverlayUpdateConnection = nil
        end
        overlayVisible = false
        sendNotification("KHANHPC", "👥 ĐÃ TẮT OVERLAY DANH SÁCH\nNhấn K để bật lại", 1.5, "👥")
    end)
    
    -- Search box change
    searchBox.Changed:Connect(function(prop)
        if prop == "Text" then
            currentSearchText = searchBox.Text:lower()
            updateOverlayList()
        end
    end)
    
    -- Update loop
    if playerOverlayUpdateConnection then
        playerOverlayUpdateConnection:Disconnect()
    end
    playerOverlayUpdateConnection = RunService.Heartbeat:Connect(function()
        if overlayVisible and playerListContainer then
            updateOverlayList()
        end
    end)
    
    updateOverlayList()
    
    return playerOverlay
end

-- Toggle overlay
local function togglePlayerOverlay()
    if playerOverlay and playerOverlay.Parent then
        playerOverlay:Destroy()
        playerOverlay = nil
        if playerOverlayUpdateConnection then
            playerOverlayUpdateConnection:Disconnect()
            playerOverlayUpdateConnection = nil
        end
        overlayVisible = false
        playerItemsOverlay = {}
        playerDataOverlay = {}
        sendNotification("KHANHPC", "👥 ĐÃ TẮT OVERLAY DANH SÁCH\nNhấn K để bật lại", 1.5, "👥")
    else
        playerItemsOverlay = {}
        playerDataOverlay = {}
        createPlayerOverlay()
        overlayVisible = true
        sendNotification("KHANHPC", "👥 ĐÃ BẬT OVERLAY DANH SÁCH\nKéo thả để di chuyển\n⭐ = Đánh dấu đồng đội", 2.5, "👥")
    end
end

-- ============================================
-- CONFIG SYSTEM (FIXED - Using DataStore)
-- ============================================

-- Sử dụng DataStoreService thay vì HttpService
local DataStoreService = game:GetService("DataStoreService")
local CONFIG_DATASTORE_NAME = "KhanhPC_Configs"
local DEFAULT_CONFIG_NAME = "default"

-- Khởi tạo DataStore
local configDataStore = nil
local dataStoreSuccess, dataStoreError = pcall(function()
    configDataStore = DataStoreService:GetDataStore(CONFIG_DATASTORE_NAME)
end)

if not dataStoreSuccess then
    warn("Cannot create DataStore:", dataStoreError)
    configDataStore = nil
end

-- Lưu key binds dưới dạng string để JSON serialize
local function serializeKeyBinds(keyBinds)
    local serialized = {}
    for k, v in pairs(keyBinds) do
        serialized[k] = tostring(v)
    end
    return serialized
end

-- Khôi phục key binds từ string
local function deserializeKeyBinds(serialized)
    local keyBinds = {}
    for k, v in pairs(serialized) do
        for _, enum in pairs(Enum.KeyCode:GetEnumItems()) do
            if tostring(enum) == v then
                keyBinds[k] = enum
                break
            end
        end
        if not keyBinds[k] then
            keyBinds[k] = _G.keyBinds[k]
        end
    end
    return keyBinds
end

-- Lưu config (dùng DataStore)
local function saveConfig(configName)
    if not configName or configName == "" then
        configName = "custom"
    end
    
    if not configDataStore then
        sendNotification("CONFIG", "⚠️ Không thể lưu config (DataStore không khả dụng)!", 2, "⚠️")
        return false
    end
    
    local saveData = {
        name = configName,
        features = {
            spinBot = _G.dangXoay,
            aimBot = _G.dangAimBot,
            flyMode = _G.dangFly,
            autoTele = _G.dangAutoTele,
            autoClick = _G.autoShoot,
            fixLag = _G.fixLag,
            wallHack = _G.dangWallHack,
            checkWall = _G.checkWall,
            menuVisible = _G.menuVisible,
            overlayVisible = overlayVisible
        },
        settings = {
            spinSpeed = _G.tocDoSpin,
            spinMode = _G.cheDoSpinHienTai,
            flySpeed = _G.flySpeed,
            teleportPosition = _G.teleportPosition,
            clickInterval = _G.clickInterval,
            aimRadius = _G.aimRadius
        },
        keyBinds = serializeKeyBinds(_G.keyBinds),
        teamMates = _G.teamMates,
        savedAt = os.time()
    }
    
    -- Lấy danh sách config hiện có
    local configs = {}
    local success, data = pcall(function()
        return configDataStore:GetAsync("configs_list")
    end)
    
    if success and data then
        configs = data
    end
    
    -- Cập nhật hoặc thêm config mới
    local found = false
    for i, cfg in ipairs(configs) do
        if cfg.name == configName then
            configs[i] = saveData
            found = true
            break
        end
    end
    if not found then
        table.insert(configs, saveData)
    end
    
    -- Lưu danh sách config
    local success2, err = pcall(function()
        configDataStore:SetAsync("configs_list", configs)
    end)
    
    if success2 then
        sendNotification("CONFIG", string.format("✅ Đã lưu config: %s", configName), 2, "💾")
        return true
    else
        warn("Save config error:", err)
        sendNotification("CONFIG", "❌ Lưu config thất bại!", 2, "❌")
        return false
    end
end

-- Load config
local function loadConfig(configName)
    if not configName then return false end
    
    if not configDataStore then
        sendNotification("CONFIG", "⚠️ Không thể load config (DataStore không khả dụng)!", 2, "⚠️")
        return false
    end
    
    local success, data = pcall(function()
        return configDataStore:GetAsync("configs_list")
    end)
    
    if not success or not data then
        sendNotification("CONFIG", "❌ Không tìm thấy config!", 2, "❌")
        return false
    end
    
    local configData = nil
    for _, cfg in ipairs(data) do
        if cfg.name == configName then
            configData = cfg
            break
        end
    end
    
    if not configData then
        sendNotification("CONFIG", string.format("❌ Không tìm thấy config: %s", configName), 2, "❌")
        return false
    end
    
    -- Áp dụng features
    _G.dangXoay = configData.features.spinBot
    _G.dangAimBot = configData.features.aimBot
    _G.dangFly = configData.features.flyMode
    _G.dangAutoTele = configData.features.autoTele
    _G.autoShoot = configData.features.autoClick
    _G.fixLag = configData.features.fixLag
    _G.dangWallHack = configData.features.wallHack
    _G.checkWall = configData.features.checkWall
    _G.menuVisible = configData.features.menuVisible
    overlayVisible = configData.features.overlayVisible
    
    -- Áp dụng settings
    _G.tocDoSpin = configData.settings.spinSpeed
    _G.cheDoSpinHienTai = configData.settings.spinMode
    _G.flySpeed = configData.settings.flySpeed
    _G.teleportPosition = configData.settings.teleportPosition
    _G.clickInterval = configData.settings.clickInterval
    _G.aimRadius = configData.settings.aimRadius
    
    -- Áp dụng key binds
    if configData.keyBinds then
        local newKeyBinds = deserializeKeyBinds(configData.keyBinds)
        for k, v in pairs(newKeyBinds) do
            _G.keyBinds[k] = v
        end
    end
    
    -- Áp dụng team mates
    if configData.teamMates then
        _G.teamMates = configData.teamMates
    end
    
    -- Cập nhật UI
    updateConfigUI()
    
    -- Kích hoạt lại các tính năng
    pcall(function()
        if _G.dangFly and not _G.ketNoiFly then
            _G.ketNoiFly = RunService.RenderStepped:Connect(flyUpdate)
            if player.Character then startFly() end
        end
        
        if _G.dangXoay then
            if _G.ketNoiMang then _G.ketNoiMang:Disconnect() end
            if player.Character then _G.ketNoiMang = RunService.Heartbeat:Connect(spinBot) end
        end
        
        if _G.dangAimBot then
            if _G.ketNoiAimBot then _G.ketNoiAimBot:Disconnect() end
            _G.ketNoiAimBot = RunService.RenderStepped:Connect(aimBot)
        end
        
        if _G.dangAutoTele then
            if _G.ketNoiAutoTele then _G.ketNoiAutoTele:Disconnect() end
            _G.ketNoiAutoTele = RunService.RenderStepped:Connect(autoTele)
        end
        
        if _G.autoShoot then
            if _G.ketNoiAutoClick then _G.ketNoiAutoClick:Disconnect() end
            _G.ketNoiAutoClick = RunService.RenderStepped:Connect(autoClick)
        end
        
        if _G.fixLag then
            applyFixLag(true)
        else
            applyFixLag(false)
        end
        
        if _G.dangWallHack then
            khoiTaoWallHack()
        else
            for _, tag in pairs(_G.espNameTags) do pcall(function() tag:Destroy() end) end
            for _, box in pairs(_G.espBoxes) do pcall(function() box:Destroy() end) end
            _G.espNameTags = {}
            _G.espBoxes = {}
        end
        
        if overlayVisible then
            if not playerOverlay or not playerOverlay.Parent then
                createPlayerOverlay()
            end
        else
            if playerOverlay and playerOverlay.Parent then
                playerOverlay:Destroy()
                playerOverlay = nil
            end
        end
    end)
    
    sendNotification("CONFIG", string.format("✅ Đã load config: %s", configName), 2, "📂")
    return true
end

-- Hàm cập nhật UI sau khi load config
local function updateConfigUI()
    pcall(function()
        local menu = CoreGui:FindFirstChild("KhanhHackPremium")
        if menu then
            local content = menu:FindFirstChild("Main"):FindFirstChild("Content")
            if content then
                for _, card in ipairs(content:GetChildren()) do
                    if card:IsA("Frame") then
                        local toggleBtn = card:FindFirstChild("ToggleButton")
                        if toggleBtn then
                            if card.Name == "SpinCard" then
                                toggleBtn.Text = _G.dangXoay and "ON" or "OFF"
                                toggleBtn.BackgroundColor3 = _G.dangXoay and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(255, 70, 70)
                            elseif card.Name == "AimCard" then
                                toggleBtn.Text = _G.dangAimBot and "ON" or "OFF"
                                toggleBtn.BackgroundColor3 = _G.dangAimBot and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(255, 70, 70)
                            elseif card.Name == "FlyCard" then
                                toggleBtn.Text = _G.dangFly and "ON" or "OFF"
                                toggleBtn.BackgroundColor3 = _G.dangFly and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(255, 70, 70)
                            elseif card.Name == "TeleCard" then
                                toggleBtn.Text = _G.dangAutoTele and "ON" or "OFF"
                                toggleBtn.BackgroundColor3 = _G.dangAutoTele and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(255, 70, 70)
                            elseif card.Name == "AutoClickCard" then
                                toggleBtn.Text = _G.autoShoot and "ON" or "OFF"
                                toggleBtn.BackgroundColor3 = _G.autoShoot and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(255, 70, 70)
                            elseif card.Name == "FixLagCard" then
                                toggleBtn.Text = _G.fixLag and "ON" or "OFF"
                                toggleBtn.BackgroundColor3 = _G.fixLag and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(255, 70, 70)
                            elseif card.Name == "WallHackCard" then
                                toggleBtn.Text = _G.dangWallHack and "ON" or "OFF"
                                toggleBtn.BackgroundColor3 = _G.dangWallHack and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(255, 70, 70)
                            end
                        end
                        
                        local checkWallToggle = card:FindFirstChild("CheckWallToggle")
                        if checkWallToggle then
                            checkWallToggle.Text = _G.checkWall and "ON" or "OFF"
                            checkWallToggle.BackgroundColor3 = _G.checkWall and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(255, 70, 70)
                        end
                    end
                end
            end
            
            local speedBox = content and content:FindFirstChild("SpeedCard"):FindFirstChild("TextBox")
            if speedBox then speedBox.Text = tostring(_G.tocDoSpin) end
            
            local flySpeedBox = content and content:FindFirstChild("FlySpeedCard"):FindFirstChild("TextBox")
            if flySpeedBox then flySpeedBox.Text = tostring(_G.flySpeed) end
            
            local modeValue = content and content:FindFirstChild("ModeCard"):FindFirstChild("ModeValue")
            if modeValue then modeValue.Text = _G.cheDoSpinHienTai == 1 and "NGANG" or "DỌC" end
            
            local telePosMenuBtn = content and content:FindFirstChild("TeleCard"):FindFirstChild("TelePosMenuBtn")
            if telePosMenuBtn then
                local telePosStatus = telePosMenuBtn:FindFirstChild("TelePosStatus")
                if telePosStatus then
                    local text = _G.teleportPosition == "dau" and "TRÊN ĐẦU" or (_G.teleportPosition == "truoc" and "TRƯỚC MẶT" or "SAU LƯNG")
                    telePosStatus.Text = "📍 " .. text
                end
            end
        end
    end)
end

-- Xóa config
local function deleteConfig(configName)
    if configName == DEFAULT_CONFIG_NAME then
        sendNotification("CONFIG", "⚠️ Không thể xóa config mặc định!", 2, "⚠️")
        return false
    end
    
    if not configDataStore then
        sendNotification("CONFIG", "⚠️ Không thể xóa config (DataStore không khả dụng)!", 2, "⚠️")
        return false
    end
    
    local success, data = pcall(function()
        return configDataStore:GetAsync("configs_list")
    end)
    
    if not success or not data then
        return false
    end
    
    local newData = {}
    for _, cfg in ipairs(data) do
        if cfg.name ~= configName then
            table.insert(newData, cfg)
        end
    end
    
    local success2, err = pcall(function()
        configDataStore:SetAsync("configs_list", newData)
    end)
    
    if success2 then
        sendNotification("CONFIG", string.format("✅ Đã xóa config: %s", configName), 2, "🗑️")
        return true
    else
        warn("Delete config error:", err)
        return false
    end
end

-- Lấy danh sách config
local function getConfigList()
    if not configDataStore then
        return {}
    end
    
    local success, data = pcall(function()
        return configDataStore:GetAsync("configs_list")
    end)
    
    if not success or not data then
        return {}
    end
    
    local configs = {}
    for _, cfg in ipairs(data) do
        table.insert(configs, cfg.name)
    end
    
    return configs
end

-- Tạo menu config (có nút làm mới)
local configMenu = nil
local configMenuVisible = false

local function createConfigMenu()
    if configMenu and configMenu.Parent then
        configMenu:Destroy()
    end
    
    configMenu = Instance.new("ScreenGui")
    configMenu.Name = "ConfigMenu"
    configMenu.Parent = CoreGui
    configMenu.ResetOnSpawn = false
    configMenu.IgnoreGuiInset = true
    configMenu.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    configMenu.DisplayOrder = 999999
    
    local blur = Instance.new("Frame")
    blur.Size = UDim2.new(1, 0, 1, 0)
    blur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    blur.BackgroundTransparency = 0.5
    blur.BorderSizePixel = 0
    blur.Parent = configMenu
    
    local configWidth = math.floor(550 * ScreenScale)
    local configHeight = math.floor(600 * ScreenScale)
    
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, configWidth, 0, configHeight)
    main.Position = UDim2.new(0.5, -configWidth/2, 0.5, -configHeight/2)
    main.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
    main.BackgroundTransparency = 0.05
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = blur
    
    CreateShadow(main, UDim2.new(1, 30, 1, 30), 0.8)
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 25)
    mainCorner.Parent = main
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(0, 200, 255)
    mainStroke.Thickness = 2
    mainStroke.Transparency = 0.3
    mainStroke.Parent = main
    
    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 70 * ScreenScale)
    header.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    header.BackgroundTransparency = 0.1
    header.BorderSizePixel = 0
    header.Parent = main
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 25)
    headerCorner.Parent = header
    
    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 230))
    })
    headerGradient.Rotation = 45
    headerGradient.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚙️ QUẢN LÝ CONFIG"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 22 * ScreenScale
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    -- Nút làm mới
    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Size = UDim2.new(0, 40 * ScreenScale, 0, 40 * ScreenScale)
    refreshBtn.Position = UDim2.new(1, -100 * ScreenScale, 0, 15 * ScreenScale)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
    refreshBtn.BackgroundTransparency = 0.1
    refreshBtn.Text = "🔄"
    refreshBtn.Font = Enum.Font.GothamBlack
    refreshBtn.TextSize = 22 * ScreenScale
    refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshBtn.BorderSizePixel = 0
    refreshBtn.AutoButtonColor = false
    refreshBtn.Parent = header
    
    local refreshCorner = Instance.new("UICorner")
    refreshCorner.CornerRadius = UDim.new(0, 12)
    refreshCorner.Parent = refreshBtn
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 40 * ScreenScale, 0, 40 * ScreenScale)
    closeBtn.Position = UDim2.new(1, -50 * ScreenScale, 0, 15 * ScreenScale)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    closeBtn.BackgroundTransparency = 0.1
    closeBtn.Text = "✖"
    closeBtn.Font = Enum.Font.GothamBlack
    closeBtn.TextSize = 20 * ScreenScale
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.BorderSizePixel = 0
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = header
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 12)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        configMenu:Destroy()
        configMenuVisible = false
    end)
    
    -- Content
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -30, 1, -140 * ScreenScale)
    content.Position = UDim2.new(0, 15, 0, 85 * ScreenScale)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 6
    content.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.Parent = main
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = content
    
    -- Hàm refresh danh sách config
    local function refreshConfigList()
        -- Xóa tất cả con của content (giữ lại UIListLayout)
        for _, child in ipairs(content:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") then
                child:Destroy()
            end
        end
        
        -- Tạo lại UI
        -- Tạo config mới
        local newConfigFrame = Instance.new("Frame")
        newConfigFrame.Size = UDim2.new(1, 0, 0, 80 * ScreenScale)
        newConfigFrame.BackgroundColor3 = Color3.fromRGB(20, 23, 31)
        newConfigFrame.BackgroundTransparency = 0.1
        newConfigFrame.BorderSizePixel = 0
        newConfigFrame.LayoutOrder = 1
        newConfigFrame.Parent = content
        
        local newConfigCorner = Instance.new("UICorner")
        newConfigCorner.CornerRadius = UDim.new(0, 15)
        newConfigCorner.Parent = newConfigFrame
        
        local newConfigTitle = Instance.new("TextLabel")
        newConfigTitle.Size = UDim2.new(1, 0, 0, 30 * ScreenScale)
        newConfigTitle.Position = UDim2.new(0, 15, 0, 10)
        newConfigTitle.BackgroundTransparency = 1
        newConfigTitle.Text = "📝 TẠO CONFIG MỚI"
        newConfigTitle.Font = Enum.Font.GothamBlack
        newConfigTitle.TextSize = 16 * ScreenScale
        newConfigTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
        newConfigTitle.TextXAlignment = Enum.TextXAlignment.Left
        newConfigTitle.Parent = newConfigFrame
        
        local newConfigInput = Instance.new("TextBox")
        newConfigInput.Size = UDim2.new(0.6, -10, 0, 35 * ScreenScale)
        newConfigInput.Position = UDim2.new(0, 15, 0, 40)
        newConfigInput.BackgroundColor3 = Color3.fromRGB(10, 12, 20)
        newConfigInput.BackgroundTransparency = 0.2
        newConfigInput.PlaceholderText = "Tên config..."
        newConfigInput.Text = ""
        newConfigInput.Font = Enum.Font.GothamBold
        newConfigInput.TextSize = 14 * ScreenScale
        newConfigInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        newConfigInput.BorderSizePixel = 0
        newConfigInput.Parent = newConfigFrame
        
        local newConfigInputCorner = Instance.new("UICorner")
        newConfigInputCorner.CornerRadius = UDim.new(0, 10)
        newConfigInputCorner.Parent = newConfigInput
        
        local createBtn = Instance.new("TextButton")
        createBtn.Size = UDim2.new(0.3, 0, 0, 35 * ScreenScale)
        createBtn.Position = UDim2.new(0.68, 5, 0, 40)
        createBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        createBtn.BackgroundTransparency = 0.1
        createBtn.Text = "LƯU"
        createBtn.Font = Enum.Font.GothamBlack
        createBtn.TextSize = 14 * ScreenScale
        createBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        createBtn.BorderSizePixel = 0
        createBtn.AutoButtonColor = false
        createBtn.Parent = newConfigFrame
        
        local createCorner = Instance.new("UICorner")
        createCorner.CornerRadius = UDim.new(0, 10)
        createCorner.Parent = createBtn
        
        createBtn.MouseButton1Click:Connect(function()
            local name = newConfigInput.Text:gsub("%s+", "")
            if name == "" then
                sendNotification("CONFIG", "⚠️ Vui lòng nhập tên config!", 1.5, "⚠️")
                return
            end
            if name == DEFAULT_CONFIG_NAME then
                sendNotification("CONFIG", "⚠️ Không thể đặt tên '" .. DEFAULT_CONFIG_NAME .. "'!", 1.5, "⚠️")
                return
            end
            if saveConfig(name) then
                newConfigInput.Text = ""
                refreshConfigList()
            end
        end)
        
        -- Danh sách config
        local listTitle = Instance.new("TextLabel")
        listTitle.Size = UDim2.new(1, 0, 0, 30 * ScreenScale)
        listTitle.BackgroundTransparency = 1
        listTitle.Text = "📋 DANH SÁCH CONFIG"
        listTitle.Font = Enum.Font.GothamBlack
        listTitle.TextSize = 16 * ScreenScale
        listTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
        listTitle.TextXAlignment = Enum.TextXAlignment.Left
        listTitle.LayoutOrder = 2
        listTitle.Parent = content
        
        -- Lấy danh sách config
        local configs = getConfigList()
        if #configs == 0 then
            local emptyLabel = Instance.new("TextLabel")
            emptyLabel.Size = UDim2.new(1, 0, 0, 60 * ScreenScale)
            emptyLabel.BackgroundTransparency = 1
            emptyLabel.Text = "Chưa có config nào\nNhấn LƯU để tạo config mới"
            emptyLabel.Font = Enum.Font.GothamBold
            emptyLabel.TextSize = 14 * ScreenScale
            emptyLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
            emptyLabel.TextWrapped = true
            emptyLabel.LayoutOrder = 3
            emptyLabel.Parent = content
        else
            for i, cfgName in ipairs(configs) do
                local item = Instance.new("Frame")
                item.Size = UDim2.new(1, 0, 0, 70 * ScreenScale)
                item.BackgroundColor3 = Color3.fromRGB(20, 23, 31)
                item.BackgroundTransparency = 0.1
                item.BorderSizePixel = 0
                item.LayoutOrder = 3 + i
                item.Parent = content
                
                local itemCorner = Instance.new("UICorner")
                itemCorner.CornerRadius = UDim.new(0, 12)
                itemCorner.Parent = item
                
                local itemStroke = Instance.new("UIStroke")
                itemStroke.Color = Color3.fromRGB(0, 200, 255)
                itemStroke.Thickness = 1
                itemStroke.Transparency = 0.6
                itemStroke.Parent = item
                
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(0.5, -10, 1, 0)
                nameLabel.Position = UDim2.new(0, 15, 0, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = cfgName
                nameLabel.Font = Enum.Font.GothamBlack
                nameLabel.TextSize = 16 * ScreenScale
                nameLabel.TextColor3 = cfgName == DEFAULT_CONFIG_NAME and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(255, 255, 255)
                nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                nameLabel.Parent = item
                
                local loadBtn = Instance.new("TextButton")
                loadBtn.Size = UDim2.new(0, 60 * ScreenScale, 0, 35 * ScreenScale)
                loadBtn.Position = UDim2.new(1, -140 * ScreenScale, 0.5, -17.5 * ScreenScale)
                loadBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
                loadBtn.BackgroundTransparency = 0.1
                loadBtn.Text = "LOAD"
                loadBtn.Font = Enum.Font.GothamBlack
                loadBtn.TextSize = 12 * ScreenScale
                loadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                loadBtn.BorderSizePixel = 0
                loadBtn.AutoButtonColor = false
                loadBtn.Parent = item
                
                local loadCorner = Instance.new("UICorner")
                loadCorner.CornerRadius = UDim.new(0, 8)
                loadCorner.Parent = loadBtn
                
                loadBtn.MouseButton1Click:Connect(function()
                    loadConfig(cfgName)
                    pcall(function()
                        if configDataStore then
                            configDataStore:SetAsync("default_config", cfgName)
                        end
                    end)
                    configMenu:Destroy()
                    configMenuVisible = false
                end)
                
                if cfgName ~= DEFAULT_CONFIG_NAME then
                    local deleteBtn = Instance.new("TextButton")
                    deleteBtn.Size = UDim2.new(0, 60 * ScreenScale, 0, 35 * ScreenScale)
                    deleteBtn.Position = UDim2.new(1, -75 * ScreenScale, 0.5, -17.5 * ScreenScale)
                    deleteBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                    deleteBtn.BackgroundTransparency = 0.1
                    deleteBtn.Text = "XÓA"
                    deleteBtn.Font = Enum.Font.GothamBlack
                    deleteBtn.TextSize = 12 * ScreenScale
                    deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    deleteBtn.BorderSizePixel = 0
                    deleteBtn.AutoButtonColor = false
                    deleteBtn.Parent = item
                    
                    local deleteCorner = Instance.new("UICorner")
                    deleteCorner.CornerRadius = UDim.new(0, 8)
                    deleteCorner.Parent = deleteBtn
                    
                    deleteBtn.MouseButton1Click:Connect(function()
                        deleteConfig(cfgName)
                        refreshConfigList()
                    end)
                end
            end
        end
        
        -- Nút Set Default
        local defaultFrame = Instance.new("Frame")
        defaultFrame.Size = UDim2.new(1, 0, 0, 70 * ScreenScale)
        defaultFrame.BackgroundColor3 = Color3.fromRGB(20, 23, 31)
        defaultFrame.BackgroundTransparency = 0.1
        defaultFrame.BorderSizePixel = 0
        defaultFrame.LayoutOrder = 999
        defaultFrame.Parent = content
        
        local defaultCorner = Instance.new("UICorner")
        defaultCorner.CornerRadius = UDim.new(0, 15)
        defaultCorner.Parent = defaultFrame
        
        local defaultTitle = Instance.new("TextLabel")
        defaultTitle.Size = UDim2.new(1, 0, 0, 30 * ScreenScale)
        defaultTitle.Position = UDim2.new(0, 15, 0, 10)
        defaultTitle.BackgroundTransparency = 1
        defaultTitle.Text = "⭐ CONFIG MẶC ĐỊNH"
        defaultTitle.Font = Enum.Font.GothamBlack
        defaultTitle.TextSize = 14 * ScreenScale
        defaultTitle.TextColor3 = Color3.fromRGB(255, 200, 0)
        defaultTitle.TextXAlignment = Enum.TextXAlignment.Left
        defaultTitle.Parent = defaultFrame
        
        local defaultDesc = Instance.new("TextLabel")
        defaultDesc.Size = UDim2.new(0.6, -10, 0, 25 * ScreenScale)
        defaultDesc.Position = UDim2.new(0, 15, 0, 40)
        defaultDesc.BackgroundTransparency = 1
        defaultDesc.Text = "Config tự động load khi khởi động"
        defaultDesc.Font = Enum.Font.GothamBold
        defaultDesc.TextSize = 10 * ScreenScale
        defaultDesc.TextColor3 = Color3.fromRGB(150, 150, 200)
        defaultDesc.TextXAlignment = Enum.TextXAlignment.Left
        defaultDesc.Parent = defaultFrame
        
        local defaultName = Instance.new("TextLabel")
        defaultName.Size = UDim2.new(0.3, 0, 0, 25 * ScreenScale)
        defaultName.Position = UDim2.new(0.65, 0, 0, 40)
        defaultName.BackgroundTransparency = 1
        defaultName.Font = Enum.Font.GothamBold
        defaultName.TextSize = 12 * ScreenScale
        defaultName.TextColor3 = Color3.fromRGB(0, 255, 200)
        defaultName.TextXAlignment = Enum.TextXAlignment.Right
        defaultName.Parent = defaultFrame
        
        local currentDefault = nil
        if configDataStore then
            pcall(function()
                currentDefault = configDataStore:GetAsync("default_config")
            end)
        end
        defaultName.Text = currentDefault and currentDefault or "Chưa đặt"
        
        local setDefaultBtn = Instance.new("TextButton")
        setDefaultBtn.Size = UDim2.new(0, 80 * ScreenScale, 0, 30 * ScreenScale)
        setDefaultBtn.Position = UDim2.new(1, -95 * ScreenScale, 1, -40 * ScreenScale)
        setDefaultBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
        setDefaultBtn.BackgroundTransparency = 0.1
        setDefaultBtn.Text = "ĐẶT"
        setDefaultBtn.Font = Enum.Font.GothamBlack
        setDefaultBtn.TextSize = 12 * ScreenScale
        setDefaultBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        setDefaultBtn.BorderSizePixel = 0
        setDefaultBtn.AutoButtonColor = false
        setDefaultBtn.Parent = defaultFrame
        
        local setDefaultCorner = Instance.new("UICorner")
        setDefaultCorner.CornerRadius = UDim.new(0, 8)
        setDefaultCorner.Parent = setDefaultBtn
        
        setDefaultBtn.MouseButton1Click:Connect(function()
            local currentConfigName = "auto_save_" .. os.time()
            if saveConfig(currentConfigName) then
                if configDataStore then
                    pcall(function()
                        configDataStore:SetAsync("default_config", currentConfigName)
                    end)
                end
                defaultName.Text = currentConfigName
                sendNotification("CONFIG", "⭐ Đã đặt config hiện tại làm mặc định", 2, "⭐")
                refreshConfigList()
            end
        end)
    end
    
    -- Gán sự kiện làm mới
    refreshBtn.MouseButton1Click:Connect(function()
        refreshConfigList()
        sendNotification("CONFIG", "🔄 Đã làm mới danh sách config", 1.5, "🔄")
    end)
    
    -- Khởi tạo danh sách
    refreshConfigList()
    
    configMenuVisible = true
end

-- Auto load config mặc định
local function autoLoadDefaultConfig()
    if not configDataStore then
        return
    end
    
    local defaultConfig = nil
    pcall(function()
        defaultConfig = configDataStore:GetAsync("default_config")
    end)
    
    if defaultConfig and defaultConfig ~= "" then
        task.wait(2)
        local success = loadConfig(defaultConfig)
        if success then
            sendNotification("CONFIG", string.format("⭐ Đã tự động load config: %s", defaultConfig), 2, "⭐")
        end
    end
end

-- Thêm nút Config vào menu chính
local function addConfigButtonToMenu()
    task.spawn(function()
        repeat task.wait() until CoreGui:FindFirstChild("KhanhHackPremium")
        
        local menu = CoreGui:FindFirstChild("KhanhHackPremium")
        if menu then
            local main = menu:FindFirstChild("Main")
            if main then
                local header = main:FindFirstChild("Header")
                if header then
                    local configBtn = Instance.new("TextButton")
                    configBtn.Size = UDim2.new(0, 36 * ScreenScale, 0, 36 * ScreenScale)
                    configBtn.Position = UDim2.new(1, -160 * ScreenScale, 0, 22 * ScreenScale)
                    configBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
                    configBtn.BackgroundTransparency = 0.2
                    configBtn.Text = "⚙️"
                    configBtn.Font = Enum.Font.GothamBlack
                    configBtn.TextSize = 20 * ScreenScale
                    configBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    configBtn.BorderSizePixel = 0
                    configBtn.AutoButtonColor = false
                    configBtn.Parent = header
                    
                    local configCorner = Instance.new("UICorner")
                    configCorner.CornerRadius = UDim.new(0, 12)
                    configCorner.Parent = configBtn
                    
                    configBtn.MouseButton1Click:Connect(function()
                        if configMenuVisible then
                            if configMenu then configMenu:Destroy() end
                            configMenuVisible = false
                        else
                            createConfigMenu()
                        end
                    end)
                    
                    configBtn.MouseEnter:Connect(function()
                        TweenService:Create(configBtn, TweenInfo.new(0.2), {
                            Size = UDim2.new(0, 40 * ScreenScale, 0, 40 * ScreenScale),
                            Position = UDim2.new(1, -162 * ScreenScale, 0, 20 * ScreenScale),
                            BackgroundColor3 = Color3.fromRGB(150, 150, 250)
                        }):Play()
                    end)
                    
                    configBtn.MouseLeave:Connect(function()
                        TweenService:Create(configBtn, TweenInfo.new(0.2), {
                            Size = UDim2.new(0, 36 * ScreenScale, 0, 36 * ScreenScale),
                            Position = UDim2.new(1, -160 * ScreenScale, 0, 22 * ScreenScale),
                            BackgroundColor3 = Color3.fromRGB(100, 100, 200)
                        }):Play()
                    end)
                end
            end
        end
    end)
end

-- ============================================
-- KEY BINDING MENU
-- ============================================
local bindMenu = nil
local currentBinding = nil

local function createBindMenu()
    if bindMenu and bindMenu.Parent then
        bindMenu:Destroy()
    end
    
    bindMenu = Instance.new("ScreenGui")
    bindMenu.Name = "KeyBindMenu"
    bindMenu.Parent = CoreGui
    bindMenu.ResetOnSpawn = false
    bindMenu.IgnoreGuiInset = true
    bindMenu.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    bindMenu.DisplayOrder = 999999
    
    local bindMenuWidth = math.floor(450 * ScreenScale)
    local bindMenuHeight = math.floor(300 * ScreenScale)
    
    local blur = Instance.new("Frame")
    blur.Size = UDim2.new(1, 0, 1, 0)
    blur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    blur.BackgroundTransparency = 0.5
    blur.BorderSizePixel = 0
    blur.Parent = bindMenu
    
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, bindMenuWidth, 0, bindMenuHeight)
    main.Position = UDim2.new(0.5, -bindMenuWidth/2, 0.5, -bindMenuHeight/2)
    main.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
    main.BackgroundTransparency = 0.05
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = blur
    
    CreateShadow(main, UDim2.new(1, 30, 1, 30), 0.8)
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 25)
    mainCorner.Parent = main
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(0, 200, 255)
    mainStroke.Thickness = 2
    mainStroke.Transparency = 0.3
    mainStroke.Parent = main
    
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 70 * ScreenScale)
    header.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    header.BackgroundTransparency = 0.1
    header.BorderSizePixel = 0
    header.Parent = main
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 25)
    headerCorner.Parent = header
    
    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 230))
    })
    headerGradient.Rotation = 45
    headerGradient.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚙️ BIND PHÍM"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 28 * ScreenScale
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Parent = header
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -40, 1, -110 * ScreenScale)
    content.Position = UDim2.new(0, 20, 0, 90 * ScreenScale)
    content.BackgroundTransparency = 1
    content.Parent = main
    
    local instruction = Instance.new("TextLabel")
    instruction.Size = UDim2.new(1, 0, 0, 70 * ScreenScale)
    instruction.BackgroundTransparency = 1
    instruction.Text = "NHẤN PHÍM BẤT KỲ\nĐỂ GÁN CHO CHỨC NĂNG NÀY"
    instruction.Font = Enum.Font.GothamBold
    instruction.TextSize = 20 * ScreenScale
    instruction.TextColor3 = Color3.fromRGB(255, 255, 0)
    instruction.TextWrapped = true
    instruction.Parent = content
    
    local currentKeyLabel = Instance.new("TextLabel")
    currentKeyLabel.Size = UDim2.new(1, 0, 0, 60 * ScreenScale)
    currentKeyLabel.Position = UDim2.new(0, 0, 0, 80 * ScreenScale)
    currentKeyLabel.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    currentKeyLabel.BackgroundTransparency = 0.2
    currentKeyLabel.Text = "PHÍM HIỆN TẠI: ?"
    currentKeyLabel.Font = Enum.Font.GothamBlack
    currentKeyLabel.TextSize = 24 * ScreenScale
    currentKeyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    currentKeyLabel.Parent = content
    
    local currentKeyCorner = Instance.new("UICorner")
    currentKeyCorner.CornerRadius = UDim.new(0, 15)
    currentKeyCorner.Parent = currentKeyLabel
    
    local cancelBtn = Instance.new("TextButton")
    cancelBtn.Size = UDim2.new(0, 120 * ScreenScale, 0, 45 * ScreenScale)
    cancelBtn.Position = UDim2.new(0.5, -60 * ScreenScale, 1, -60 * ScreenScale)
    cancelBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    cancelBtn.BackgroundTransparency = 0.1
    cancelBtn.Text = "HỦY"
    cancelBtn.Font = Enum.Font.GothamBlack
    cancelBtn.TextSize = 20 * ScreenScale
    cancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    cancelBtn.BorderSizePixel = 0
    cancelBtn.AutoButtonColor = false
    cancelBtn.Parent = main
    
    local cancelCorner = Instance.new("UICorner")
    cancelCorner.CornerRadius = UDim.new(0, 15)
    cancelCorner.Parent = cancelBtn
    
    cancelBtn.MouseButton1Click:Connect(function()
        bindMenu:Destroy()
        currentBinding = nil
    end)
    
    local connection
    connection = UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if currentBinding then
                local keyName = GetKeyName(input.KeyCode)
                currentKeyLabel.Text = "PHÍM HIỆN TẠI: " .. keyName
                _G.keyBinds[currentBinding] = input.KeyCode
                
                local menu = CoreGui:FindFirstChild("KhanhHackPremium")
                if menu then
                    local mainFrame = menu:FindFirstChild("Main")
                    if mainFrame then
                        local content = mainFrame:FindFirstChild("Content")
                        if content then
                            for _, card in ipairs(content:GetChildren()) do
                                if card:IsA("Frame") then
                                    local keyHint = card:FindFirstChild("KeyHint")
                                    if keyHint and keyHint:IsA("TextLabel") then
                                        local cardType = card.Name
                                        if cardType == "SpinCard" then
                                            keyHint.Text = "[" .. GetKeyName(_G.keyBinds.spin) .. "]"
                                        elseif cardType == "AimCard" then
                                            keyHint.Text = "[" .. GetKeyName(_G.keyBinds.aim) .. "]"
                                        elseif cardType == "FlyCard" then
                                            keyHint.Text = "[" .. GetKeyName(_G.keyBinds.fly) .. "]"
                                        elseif cardType == "TeleCard" then
                                            keyHint.Text = "[" .. GetKeyName(_G.keyBinds.tele) .. "]"
                                        elseif cardType == "AutoClickCard" then
                                            keyHint.Text = "[" .. GetKeyName(_G.keyBinds.autoClick) .. "]"
                                        elseif cardType == "FixLagCard" then
                                            keyHint.Text = "[" .. GetKeyName(_G.keyBinds.fixLag) .. "]"
                                        elseif cardType == "WallHackCard" then
                                            keyHint.Text = "[" .. GetKeyName(_G.keyBinds.wallHack) .. "]"
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                
                task.wait(1)
                bindMenu:Destroy()
                currentBinding = nil
                if connection then connection:Disconnect() end
            end
        end
    end)
end

-- ============================================
-- HACK MENU CHÍNH (RÚT GỌN)
-- ============================================
function CreateHackMenu()
    pcall(function()
        local old = CoreGui:FindFirstChild("KhanhHackPremium")
        if old then old:Destroy() end
    end)
    
    local menu = Instance.new("ScreenGui")
    menu.Name = "KhanhHackPremium"
    menu.Parent = CoreGui
    menu.ResetOnSpawn = false
    menu.IgnoreGuiInset = true
    menu.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    menu.DisplayOrder = 999999
    
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, MENU_WIDTH, 0, MENU_HEIGHT)
    main.Position = UDim2.new(0.02, MENU_PADDING, 0.5, -MENU_HEIGHT/2)
    main.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
    main.BackgroundTransparency = 0.1
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Active = true
    main.Draggable = true
    main.Parent = menu
    
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Position = UDim2.new(0, -20, 0, -20)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://13111269966"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = main
    shadow.ZIndex = -1
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 25)
    mainCorner.Parent = main
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(0, 200, 255)
    mainStroke.Thickness = 2
    mainStroke.Transparency = 0.4
    mainStroke.Parent = main
    
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, HEADER_HEIGHT)
    header.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    header.BackgroundTransparency = 0.1
    header.BorderSizePixel = 0
    header.Parent = main
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 25)
    headerCorner.Parent = header
    
    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 230))
    })
    headerGradient.Rotation = 45
    headerGradient.Parent = header
    
    local titleIcon = Instance.new("TextLabel")
    titleIcon.Size = UDim2.new(0, 50 * ScreenScale, 1, 0)
    titleIcon.Position = UDim2.new(0, 15 * ScreenScale, 0, 0)
    titleIcon.BackgroundTransparency = 1
    titleIcon.Text = "⚡"
    titleIcon.Font = Enum.Font.GothamBlack
    titleIcon.TextSize = 40 * ScreenScale
    titleIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleIcon.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 200 * ScreenScale, 1, 0)
    title.Position = UDim2.new(0, 65 * ScreenScale, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "KHANHPC"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 30 * ScreenScale
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextStrokeTransparency = 0.3
    title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    local gameNameTitle = Instance.new("TextLabel")
    gameNameTitle.Size = UDim2.new(0, 280 * ScreenScale, 1, 0)
    gameNameTitle.Position = UDim2.new(0, 240 * ScreenScale, 0, 0)
    gameNameTitle.BackgroundTransparency = 1
    gameNameTitle.Text = " | " .. GAME_NAME
    gameNameTitle.Font = Enum.Font.GothamBold
    gameNameTitle.TextSize = 16 * ScreenScale
    gameNameTitle.TextColor3 = Color3.fromRGB(255, 255, 100)
    gameNameTitle.TextXAlignment = Enum.TextXAlignment.Left
    gameNameTitle.TextTruncate = Enum.TextTruncate.AtEnd
    gameNameTitle.Parent = header
    
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(0, 120 * ScreenScale, 1, 0)
    statusText.Position = UDim2.new(0, 360 * ScreenScale, 0, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "PREMIUM"
    statusText.Font = Enum.Font.GothamBold
    statusText.TextSize = 16 * ScreenScale
    statusText.TextColor3 = Color3.fromRGB(255, 255, 100)
    statusText.TextXAlignment = Enum.TextXAlignment.Right
    statusText.Parent = header
    
    local function createControlButton(parent, pos, text, color)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 36 * ScreenScale, 0, 36 * ScreenScale)
        btn.Position = pos
        btn.BackgroundColor3 = color
        btn.BackgroundTransparency = 0.2
        btn.Text = text
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = 20 * ScreenScale
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = parent
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 12)
        btnCorner.Parent = btn
        
        return btn
    end
    
    local hideBtn = createControlButton(header, UDim2.new(1, -120 * ScreenScale, 0, 22 * ScreenScale), "👁️", Color3.fromRGB(100, 100, 100))
    local minimizeBtn = createControlButton(header, UDim2.new(1, -80 * ScreenScale, 0, 22 * ScreenScale), "➖", Color3.fromRGB(255, 150, 0))
    local closeBtn = createControlButton(header, UDim2.new(1, -40 * ScreenScale, 0, 22 * ScreenScale), "✖", Color3.fromRGB(255, 70, 70))
    
    local showBtn = Instance.new("TextButton")
    showBtn.Size = UDim2.new(0, 0, 0, 0)
    showBtn.Position = UDim2.new(1, -140 * ScreenScale, 1, -60 * ScreenScale)
    showBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    showBtn.BackgroundTransparency = 0.1
    showBtn.Text = "📱 MENU"
    showBtn.Font = Enum.Font.GothamBlack
    showBtn.TextSize = 20 * ScreenScale
    showBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    showBtn.BorderSizePixel = 0
    showBtn.AutoButtonColor = false
    showBtn.Parent = menu
    showBtn.Visible = false
    showBtn.ZIndex = 999999
    
    local showCorner = Instance.new("UICorner")
    showCorner.CornerRadius = UDim.new(0, 18)
    showCorner.Parent = showBtn
    
    local showGradient = Instance.new("UIGradient")
    showGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 230))
    })
    showGradient.Rotation = 45
    showGradient.Parent = showBtn
    
    CreateShadow(showBtn, UDim2.new(1, 20, 1, 20), 0.7)
    
    hideBtn.MouseButton1Click:Connect(function()
        _G.menuVisible = false
        TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.02, MENU_PADDING, 0.5, 0),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.2)
        main.Visible = false
        showBtn.Visible = true
        TweenService:Create(showBtn, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 150 * ScreenScale, 0, 55 * ScreenScale),
            Position = UDim2.new(1, -160 * ScreenScale, 1, -65 * ScreenScale),
            BackgroundTransparency = 0.1
        }):Play()
    end)
    
    minimizeBtn.MouseButton1Click:Connect(function()
        if main.Size == UDim2.new(0, MENU_WIDTH, 0, MENU_HEIGHT) then
            TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, MENU_WIDTH, 0, HEADER_HEIGHT)
            }):Play()
            minimizeBtn.Text = "➕"
        else
            TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, MENU_WIDTH, 0, MENU_HEIGHT)
            }):Play()
            minimizeBtn.Text = "➖"
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        _G.menuVisible = false
        TweenService:Create(main, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.02, MENU_PADDING, 0.5, 0),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.3)
        main.Visible = false
    end)
    
    showBtn.MouseButton1Click:Connect(function()
        showBtn.Visible = false
        main.Visible = true
        TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, MENU_WIDTH, 0, MENU_HEIGHT),
            Position = UDim2.new(0.02, MENU_PADDING, 0.5, -MENU_HEIGHT/2),
            BackgroundTransparency = 0.1
        }):Play()
        _G.menuVisible = true
    end)
    
    local function addHoverEffect(btn, normalColor, hoverColor)
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 40 * ScreenScale, 0, 40 * ScreenScale),
                Position = UDim2.new(btn.Position.X.Scale, btn.Position.X.Offset - 2 * ScreenScale, 0, 20 * ScreenScale),
                BackgroundColor3 = hoverColor,
                BackgroundTransparency = 0
            }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 36 * ScreenScale, 0, 36 * ScreenScale),
                Position = UDim2.new(btn.Position.X.Scale, btn.Position.X.Offset + 2 * ScreenScale, 0, 22 * ScreenScale),
                BackgroundColor3 = normalColor,
                BackgroundTransparency = 0.2
            }):Play()
        end)
    end
    
    addHoverEffect(hideBtn, Color3.fromRGB(100, 100, 100), Color3.fromRGB(150, 150, 150))
    addHoverEffect(minimizeBtn, Color3.fromRGB(255, 150, 0), Color3.fromRGB(255, 180, 0))
    addHoverEffect(closeBtn, Color3.fromRGB(255, 70, 70), Color3.fromRGB(255, 100, 100))
    
    local content = Instance.new("ScrollingFrame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -30, 1, -(HEADER_HEIGHT + 20))
    content.Position = UDim2.new(0, 15, 0, HEADER_HEIGHT + 10)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 6
    content.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
    content.ScrollBarImageTransparency = 0.3
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.Parent = main
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 15)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = content
    
    local function createToggleCard(parent, title, icon, color, defaultKey, order, defaultValue, cardName)
        local card = Instance.new("Frame")
        card.Name = cardName or title .. "Card"
        card.Size = UDim2.new(1, 0, 0, CARD_HEIGHT)
        card.BackgroundColor3 = Color3.fromRGB(20, 23, 31)
        card.BackgroundTransparency = 0.1
        card.BorderSizePixel = 0
        card.LayoutOrder = order
        card.Parent = parent
        
        local cardCorner = Instance.new("UICorner")
        cardCorner.CornerRadius = UDim.new(0, 20)
        cardCorner.Parent = card
        
        local cardStroke = Instance.new("UIStroke")
        cardStroke.Color = color
        cardStroke.Thickness = 1.8
        cardStroke.Transparency = 0.6
        cardStroke.Parent = card
        
        local cardGradient = Instance.new("UIGradient")
        cardGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 33, 41)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 18, 25))
        })
        cardGradient.Rotation = 90
        cardGradient.Parent = card
        
        local iconFrame = Instance.new("Frame")
        iconFrame.Size = UDim2.new(0, 60, 0, 60)
        iconFrame.Position = UDim2.new(0, 20, 0.5, -30)
        iconFrame.BackgroundColor3 = color
        iconFrame.BackgroundTransparency = 0.2
        iconFrame.BorderSizePixel = 0
        iconFrame.Parent = card
        
        local iconCorner = Instance.new("UICorner")
        iconCorner.CornerRadius = UDim.new(0, 18)
        iconCorner.Parent = iconFrame
        
        local iconGlow = CreateGlow(iconFrame, color)
        iconGlow.ImageTransparency = 0.6
        
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.new(1, 0, 1, 0)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = icon
        iconLabel.Font = Enum.Font.GothamBlack
        iconLabel.TextSize = 32
        iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        iconLabel.Parent = iconFrame
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(0, 280 * ScreenScale, 0, 32)
        titleLabel.Position = UDim2.new(0, 100, 0, 15)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.Font = Enum.Font.GothamBlack
        titleLabel.TextSize = 22 * ScreenScale
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = card
        
        local keyHint = Instance.new("TextLabel")
        keyHint.Name = "KeyHint"
        keyHint.Size = UDim2.new(0, 150 * ScreenScale, 0, 24)
        keyHint.Position = UDim2.new(0, 100, 0, 50)
        keyHint.BackgroundTransparency = 1
        keyHint.Text = "[" .. GetKeyName(defaultKey) .. "]"
        keyHint.Font = Enum.Font.GothamBold
        keyHint.TextSize = 18 * ScreenScale
        keyHint.TextColor3 = color
        keyHint.TextXAlignment = Enum.TextXAlignment.Left
        keyHint.Parent = card
        
        local gearBtn = Instance.new("TextButton")
        gearBtn.Name = "GearButton"
        gearBtn.Size = UDim2.new(0, 50 * ScreenScale, 0, 50 * ScreenScale)
        gearBtn.Position = UDim2.new(1, -160 * ScreenScale, 0.5, -25 * ScreenScale)
        gearBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
        gearBtn.BackgroundTransparency = 0.2
        gearBtn.Text = "⚙️"
        gearBtn.Font = Enum.Font.GothamBlack
        gearBtn.TextSize = 26 * ScreenScale
        gearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        gearBtn.BorderSizePixel = 0
        gearBtn.AutoButtonColor = false
        gearBtn.Parent = card
        
        local gearCorner = Instance.new("UICorner")
        gearCorner.CornerRadius = UDim.new(0, 15)
        gearCorner.Parent = gearBtn
        
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Name = "ToggleButton"
        toggleBtn.Size = UDim2.new(0, 90 * ScreenScale, 0, 45 * ScreenScale)
        toggleBtn.Position = UDim2.new(1, -100 * ScreenScale, 0.5, -22.5 * ScreenScale)
        toggleBtn.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(255, 70, 70)
        toggleBtn.BackgroundTransparency = 0.1
        toggleBtn.Text = defaultValue and "ON" or "OFF"
        toggleBtn.Font = Enum.Font.GothamBlack
        toggleBtn.TextSize = 20 * ScreenScale
        toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleBtn.BorderSizePixel = 0
        toggleBtn.AutoButtonColor = false
        toggleBtn.Parent = card
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 15)
        toggleCorner.Parent = toggleBtn
        
        gearBtn.MouseEnter:Connect(function()
            TweenService:Create(gearBtn, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 54 * ScreenScale, 0, 54 * ScreenScale),
                Position = UDim2.new(1, -163 * ScreenScale, 0.5, -27 * ScreenScale),
                BackgroundColor3 = Color3.fromRGB(120, 120, 130)
            }):Play()
        end)
        
        gearBtn.MouseLeave:Connect(function()
            TweenService:Create(gearBtn, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 50 * ScreenScale, 0, 50 * ScreenScale),
                Position = UDim2.new(1, -160 * ScreenScale, 0.5, -25 * ScreenScale),
                BackgroundColor3 = Color3.fromRGB(80, 80, 90)
            }):Play()
        end)
        
        return card, toggleBtn, gearBtn
    end
    
    local spinCard, spinBtn, spinGear = createToggleCard(content, "SPIN BOT", "🌀", Color3.fromRGB(255, 200, 0), _G.keyBinds.spin, 1, _G.dangXoay, "SpinCard")
    local aimCard, aimBtn, aimGear = createToggleCard(content, "AIM BOT", "🎯", Color3.fromRGB(255, 80, 80), _G.keyBinds.aim, 2, _G.dangAimBot, "AimCard")
    local flyCard, flyBtn, flyGear = createToggleCard(content, "FLY MODE", "🕊️", Color3.fromRGB(100, 200, 255), _G.keyBinds.fly, 3, _G.dangFly, "FlyCard")
    local teleCard, teleBtn, teleGear = createToggleCard(content, "AUTO TELE", "📡", Color3.fromRGB(0, 200, 100), _G.keyBinds.tele, 4, _G.dangAutoTele, "TeleCard")
    
    local telePosMenuBtn = Instance.new("TextButton")
    telePosMenuBtn.Name = "TelePosMenuBtn"
    telePosMenuBtn.Size = UDim2.new(0, 50 * ScreenScale, 0, 50 * ScreenScale)
    telePosMenuBtn.Position = UDim2.new(1, -200 * ScreenScale, 0.5, -25 * ScreenScale)
    telePosMenuBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    telePosMenuBtn.BackgroundTransparency = 0.1
    telePosMenuBtn.Text = "📍"
    telePosMenuBtn.Font = Enum.Font.GothamBlack
    telePosMenuBtn.TextSize = 26 * ScreenScale
    telePosMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    telePosMenuBtn.BorderSizePixel = 0
    telePosMenuBtn.AutoButtonColor = false
    telePosMenuBtn.Parent = teleCard
    
    local telePosMenuCorner = Instance.new("UICorner")
    telePosMenuCorner.CornerRadius = UDim.new(0, 15)
    telePosMenuCorner.Parent = telePosMenuBtn
    
    local telePosStatus = Instance.new("TextLabel")
    telePosStatus.Name = "TelePosStatus"
    telePosStatus.Size = UDim2.new(1, 0, 0, 20)
    telePosStatus.Position = UDim2.new(0, 0, 1, 5)
    telePosStatus.BackgroundTransparency = 1
    telePosStatus.Text = "📍 " .. (_G.teleportPosition == "dau" and "TRÊN ĐẦU" or (_G.teleportPosition == "truoc" and "TRƯỚC MẶT" or "SAU LƯNG"))
    telePosStatus.Font = Enum.Font.GothamBold
    telePosStatus.TextSize = 12 * ScreenScale
    telePosStatus.TextColor3 = Color3.fromRGB(0, 255, 255)
    telePosStatus.TextXAlignment = Enum.TextXAlignment.Center
    telePosStatus.Parent = telePosMenuBtn
    
    local telePosMenu = Instance.new("Frame")
    telePosMenu.Name = "TelePosMenu"
    telePosMenu.Size = UDim2.new(0, 200 * ScreenScale, 0, 0)
    telePosMenu.Position = UDim2.new(0.5, -100 * ScreenScale, 0, -5)
    telePosMenu.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
    telePosMenu.BackgroundTransparency = 0.1
    telePosMenu.BorderSizePixel = 0
    telePosMenu.ClipsDescendants = true
    telePosMenu.Visible = false
    telePosMenu.Parent = telePosMenuBtn
    
    local telePosMenuCorner2 = Instance.new("UICorner")
    telePosMenuCorner2.CornerRadius = UDim.new(0, 15)
    telePosMenuCorner2.Parent = telePosMenu
    
    local telePosMenuStroke = Instance.new("UIStroke")
    telePosMenuStroke.Color = Color3.fromRGB(0, 200, 100)
    telePosMenuStroke.Thickness = 2
    telePosMenuStroke.Transparency = 0.3
    telePosMenuStroke.Parent = telePosMenu
    
    local function createTeleOption(parent, text, icon, pos, order)
        local option = Instance.new("TextButton")
        option.Name = "Option_" .. pos
        option.Size = UDim2.new(1, 0, 0, 50 * ScreenScale)
        option.Position = UDim2.new(0, 0, 0, (order-1) * 50 * ScreenScale)
        option.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
        option.BackgroundTransparency = 0.2
        option.Text = ""
        option.BorderSizePixel = 0
        option.AutoButtonColor = false
        option.Parent = telePosMenu
        
        local optionCorner = Instance.new("UICorner")
        optionCorner.CornerRadius = UDim.new(0, 10)
        optionCorner.Parent = option
        
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.new(0, 40 * ScreenScale, 1, 0)
        iconLabel.Position = UDim2.new(0, 10 * ScreenScale, 0, 0)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = icon
        iconLabel.Font = Enum.Font.GothamBold
        iconLabel.TextSize = 24 * ScreenScale
        iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        iconLabel.Parent = option
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, -60 * ScreenScale, 1, 0)
        textLabel.Position = UDim2.new(0, 55 * ScreenScale, 0, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = text
        textLabel.Font = Enum.Font.GothamBlack
        textLabel.TextSize = 16 * ScreenScale
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.Parent = option
        
        local checkMark = Instance.new("TextLabel")
        checkMark.Name = "CheckMark"
        checkMark.Size = UDim2.new(0, 30 * ScreenScale, 1, 0)
        checkMark.Position = UDim2.new(1, -35 * ScreenScale, 0, 0)
        checkMark.BackgroundTransparency = 1
        checkMark.Text = (_G.teleportPosition == pos) and "✓" or ""
        checkMark.Font = Enum.Font.GothamBlack
        checkMark.TextSize = 24 * ScreenScale
        checkMark.TextColor3 = Color3.fromRGB(0, 255, 0)
        checkMark.Parent = option
        
        option.MouseEnter:Connect(function()
            TweenService:Create(option, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(40, 45, 55),
                Size = UDim2.new(1, 5, 0, 50 * ScreenScale),
                Position = UDim2.new(0, -2.5, 0, (order-1) * 50 * ScreenScale)
            }):Play()
        end)
        
        option.MouseLeave:Connect(function()
            TweenService:Create(option, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(25, 28, 35),
                Size = UDim2.new(1, 0, 0, 50 * ScreenScale),
                Position = UDim2.new(0, 0, 0, (order-1) * 50 * ScreenScale)
            }):Play()
        end)
        
        option.MouseButton1Click:Connect(function()
            _G.teleportPosition = pos
            for _, child in ipairs(telePosMenu:GetChildren()) do
                if child:IsA("TextButton") then
                    local check = child:FindFirstChild("CheckMark")
                    if check then
                        if child.Name == "Option_" .. pos then
                            check.Text = "✓"
                        else
                            check.Text = ""
                        end
                    end
                end
            end
            telePosStatus.Text = "📍 " .. text
            TweenService:Create(telePosMenu, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 200 * ScreenScale, 0, 0)
            }):Play()
            task.wait(0.3)
            telePosMenu.Visible = false
            sendNotification("KHANHPC", "📍 TELEPORT: " .. text, 1.5, "📍")
        end)
        
        return option
    end
    
    createTeleOption(telePosMenu, "TRÊN ĐẦU", "⬆️", "dau", 1)
    createTeleOption(telePosMenu, "SAU LƯNG", "⬇️", "sau", 2)
    createTeleOption(telePosMenu, "TRƯỚC MẶT", "↗️", "truoc", 3)
    
    telePosMenuBtn.MouseButton1Click:Connect(function()
        if telePosMenu.Visible then
            TweenService:Create(telePosMenu, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 200 * ScreenScale, 0, 0)
            }):Play()
            task.wait(0.3)
            telePosMenu.Visible = false
        else
            telePosMenu.Visible = true
            TweenService:Create(telePosMenu, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 200 * ScreenScale, 0, 150 * ScreenScale)
            }):Play()
        end
    end)
    
    telePosMenuBtn.MouseEnter:Connect(function()
        TweenService:Create(telePosMenuBtn, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 54 * ScreenScale, 0, 54 * ScreenScale),
            Position = UDim2.new(1, -202 * ScreenScale, 0.5, -27 * ScreenScale),
            BackgroundColor3 = Color3.fromRGB(0, 230, 130)
        }):Play()
    end)
    
    telePosMenuBtn.MouseLeave:Connect(function()
        TweenService:Create(telePosMenuBtn, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 50 * ScreenScale, 0, 50 * ScreenScale),
            Position = UDim2.new(1, -200 * ScreenScale, 0.5, -25 * ScreenScale),
            BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        }):Play()
    end)
    
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            local absolutePos = telePosMenu.AbsolutePosition
            local absoluteSize = telePosMenu.AbsoluteSize
            if telePosMenu.Visible then
                if mousePos.X < absolutePos.X or mousePos.X > absolutePos.X + absoluteSize.X or
                   mousePos.Y < absolutePos.Y or mousePos.Y > absolutePos.Y + absoluteSize.Y then
                    TweenService:Create(telePosMenu, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                        Size = UDim2.new(0, 200 * ScreenScale, 0, 0)
                    }):Play()
                    task.wait(0.3)
                    telePosMenu.Visible = false
                end
            end
        end
    end)
    
    local autoClickCard, autoClickBtn, autoClickGear = createToggleCard(content, "AUTO CLICK", "🖱️", Color3.fromRGB(255, 150, 0), _G.keyBinds.autoClick, 5, _G.autoShoot, "AutoClickCard")
    local fixLagCard, fixLagBtn, fixLagGear = createToggleCard(content, "FIX LAG", "⚡", Color3.fromRGB(255, 100, 255), _G.keyBinds.fixLag, 6, _G.fixLag, "FixLagCard")
    local wallCard, wallBtn, wallGear = createToggleCard(content, "WALLHACK", "👁️", Color3.fromRGB(0, 255, 255), _G.keyBinds.wallHack, 7, _G.dangWallHack, "WallHackCard")
    
    local checkWallCard = Instance.new("Frame")
    checkWallCard.Size = UDim2.new(1, 0, 0, CARD_HEIGHT)
    checkWallCard.BackgroundColor3 = Color3.fromRGB(20, 23, 31)
    checkWallCard.BackgroundTransparency = 0.1
    checkWallCard.BorderSizePixel = 0
    checkWallCard.LayoutOrder = 8
    checkWallCard.Parent = content
    
    local checkWallCorner = Instance.new("UICorner")
    checkWallCorner.CornerRadius = UDim.new(0, 20)
    checkWallCorner.Parent = checkWallCard
    
    local checkWallStroke = Instance.new("UIStroke")
    checkWallStroke.Color = Color3.fromRGB(255, 200, 0)
    checkWallStroke.Thickness = 1.8
    checkWallStroke.Transparency = 0.6
    checkWallStroke.Parent = checkWallCard
    
    local checkWallGradient = Instance.new("UIGradient")
    checkWallGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 33, 41)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 18, 25))
    })
    checkWallGradient.Rotation = 90
    checkWallGradient.Parent = checkWallCard
    
    local checkWallIconFrame = Instance.new("Frame")
    checkWallIconFrame.Size = UDim2.new(0, 60, 0, 60)
    checkWallIconFrame.Position = UDim2.new(0, 20, 0.5, -30)
    checkWallIconFrame.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    checkWallIconFrame.BackgroundTransparency = 0.2
    checkWallIconFrame.BorderSizePixel = 0
    checkWallIconFrame.Parent = checkWallCard
    
    local checkWallIconCorner = Instance.new("UICorner")
    checkWallIconCorner.CornerRadius = UDim.new(0, 18)
    checkWallIconCorner.Parent = checkWallIconFrame
    
    local checkWallIconGlow = CreateGlow(checkWallIconFrame, Color3.fromRGB(255, 200, 0))
    checkWallIconGlow.ImageTransparency = 0.6
    
    local checkWallIcon = Instance.new("TextLabel")
    checkWallIcon.Size = UDim2.new(1, 0, 1, 0)
    checkWallIcon.BackgroundTransparency = 1
    checkWallIcon.Text = "🧱"
    checkWallIcon.Font = Enum.Font.GothamBlack
    checkWallIcon.TextSize = 34
    checkWallIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    checkWallIcon.Parent = checkWallIconFrame
    
    local checkWallTitle = Instance.new("TextLabel")
    checkWallTitle.Size = UDim2.new(0, 280 * ScreenScale, 0, 32)
    checkWallTitle.Position = UDim2.new(0, 100, 0, 15)
    checkWallTitle.BackgroundTransparency = 1
    checkWallTitle.Text = "CHECK WALL"
    checkWallTitle.Font = Enum.Font.GothamBlack
    checkWallTitle.TextSize = 22 * ScreenScale
    checkWallTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    checkWallTitle.TextXAlignment = Enum.TextXAlignment.Left
    checkWallTitle.Parent = checkWallCard
    
    local checkWallDesc = Instance.new("TextLabel")
    checkWallDesc.Size = UDim2.new(0, 280 * ScreenScale, 0, 24)
    checkWallDesc.Position = UDim2.new(0, 100, 0, 50)
    checkWallDesc.BackgroundTransparency = 1
    checkWallDesc.Text = "KHÔNG AIM QUA TƯỜNG"
    checkWallDesc.Font = Enum.Font.GothamBold
    checkWallDesc.TextSize = 14 * ScreenScale
    checkWallDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
    checkWallDesc.TextXAlignment = Enum.TextXAlignment.Left
    checkWallDesc.Parent = checkWallCard
    
    local checkWallToggle = Instance.new("TextButton")
    checkWallToggle.Name = "CheckWallToggle"
    checkWallToggle.Size = UDim2.new(0, 90 * ScreenScale, 0, 45 * ScreenScale)
    checkWallToggle.Position = UDim2.new(1, -100 * ScreenScale, 0.5, -22.5 * ScreenScale)
    checkWallToggle.BackgroundColor3 = _G.checkWall and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(255, 70, 70)
    checkWallToggle.BackgroundTransparency = 0.1
    checkWallToggle.Text = _G.checkWall and "ON" or "OFF"
    checkWallToggle.Font = Enum.Font.GothamBlack
    checkWallToggle.TextSize = 20 * ScreenScale
    checkWallToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    checkWallToggle.BorderSizePixel = 0
    checkWallToggle.AutoButtonColor = false
    checkWallToggle.Parent = checkWallCard
    
    local checkWallToggleCorner = Instance.new("UICorner")
    checkWallToggleCorner.CornerRadius = UDim.new(0, 15)
    checkWallToggleCorner.Parent = checkWallToggle
    
    local speedCard = Instance.new("Frame")
    speedCard.Name = "SpeedCard"
    speedCard.Size = UDim2.new(1, 0, 0, CARD_HEIGHT)
    speedCard.BackgroundColor3 = Color3.fromRGB(20, 23, 31)
    speedCard.BackgroundTransparency = 0.1
    speedCard.BorderSizePixel = 0
    speedCard.LayoutOrder = 9
    speedCard.Parent = content
    
    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 20)
    speedCorner.Parent = speedCard
    
    local speedStroke = Instance.new("UIStroke")
    speedStroke.Color = Color3.fromRGB(255, 200, 0)
    speedStroke.Thickness = 1.8
    speedStroke.Transparency = 0.6
    speedStroke.Parent = speedCard
    
    local speedGradient = Instance.new("UIGradient")
    speedGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 33, 41)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 18, 25))
    })
    speedGradient.Rotation = 90
    speedGradient.Parent = speedCard
    
    local speedIconFrame = Instance.new("Frame")
    speedIconFrame.Size = UDim2.new(0, 60, 0, 60)
    speedIconFrame.Position = UDim2.new(0, 20, 0.5, -30)
    speedIconFrame.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    speedIconFrame.BackgroundTransparency = 0.2
    speedIconFrame.BorderSizePixel = 0
    speedIconFrame.Parent = speedCard
    
    local speedIconCorner = Instance.new("UICorner")
    speedIconCorner.CornerRadius = UDim.new(0, 18)
    speedIconCorner.Parent = speedIconFrame
    
    local speedIconGlow = CreateGlow(speedIconFrame, Color3.fromRGB(255, 200, 0))
    speedIconGlow.ImageTransparency = 0.6
    
    local speedIcon = Instance.new("TextLabel")
    speedIcon.Size = UDim2.new(1, 0, 1, 0)
    speedIcon.BackgroundTransparency = 1
    speedIcon.Text = "⚙️"
    speedIcon.Font = Enum.Font.GothamBlack
    speedIcon.TextSize = 34
    speedIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedIcon.Parent = speedIconFrame
    
    local speedTitle = Instance.new("TextLabel")
    speedTitle.Size = UDim2.new(0, 280 * ScreenScale, 0, 32)
    speedTitle.Position = UDim2.new(0, 100, 0, 15)
    speedTitle.BackgroundTransparency = 1
    speedTitle.Text = "SPIN SPEED"
    speedTitle.Font = Enum.Font.GothamBlack
    speedTitle.TextSize = 22 * ScreenScale
    speedTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedTitle.TextXAlignment = Enum.TextXAlignment.Left
    speedTitle.Parent = speedCard
    
    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(0, 150 * ScreenScale, 0, 40 * ScreenScale)
    speedBox.Position = UDim2.new(0, 100, 0, 50)
    speedBox.BackgroundColor3 = Color3.fromRGB(10, 12, 20)
    speedBox.BackgroundTransparency = 0.2
    speedBox.Text = tostring(_G.tocDoSpin)
    speedBox.Font = Enum.Font.Code
    speedBox.TextSize = 18 * ScreenScale
    speedBox.TextColor3 = Color3.fromRGB(255, 255, 0)
    speedBox.TextXAlignment = Enum.TextXAlignment.Center
    speedBox.BorderSizePixel = 0
    speedBox.Parent = speedCard
    
    local speedBoxCorner = Instance.new("UICorner")
    speedBoxCorner.CornerRadius = UDim.new(0, 12)
    speedBoxCorner.Parent = speedBox
    
    local plusBtn = Instance.new("TextButton")
    plusBtn.Size = UDim2.new(0, 50 * ScreenScale, 0, 40 * ScreenScale)
    plusBtn.Position = UDim2.new(0, 260 * ScreenScale, 0, 50)
    plusBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    plusBtn.BackgroundTransparency = 0.1
    plusBtn.Text = "➕"
    plusBtn.Font = Enum.Font.GothamBlack
    plusBtn.TextSize = 22 * ScreenScale
    plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    plusBtn.BorderSizePixel = 0
    plusBtn.AutoButtonColor = false
    plusBtn.Parent = speedCard
    
    local plusCorner = Instance.new("UICorner")
    plusCorner.CornerRadius = UDim.new(0, 12)
    plusCorner.Parent = plusBtn
    
    local minusBtn = Instance.new("TextButton")
    minusBtn.Size = UDim2.new(0, 50 * ScreenScale, 0, 40 * ScreenScale)
    minusBtn.Position = UDim2.new(0, 315 * ScreenScale, 0, 50)
    minusBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    minusBtn.BackgroundTransparency = 0.1
    minusBtn.Text = "➖"
    minusBtn.Font = Enum.Font.GothamBlack
    minusBtn.TextSize = 22 * ScreenScale
    minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minusBtn.BorderSizePixel = 0
    minusBtn.AutoButtonColor = false
    minusBtn.Parent = speedCard
    
    local minusCorner = Instance.new("UICorner")
    minusCorner.CornerRadius = UDim.new(0, 12)
    minusCorner.Parent = minusBtn
    
    local flySpeedCard = Instance.new("Frame")
    flySpeedCard.Name = "FlySpeedCard"
    flySpeedCard.Size = UDim2.new(1, 0, 0, CARD_HEIGHT)
    flySpeedCard.BackgroundColor3 = Color3.fromRGB(20, 23, 31)
    flySpeedCard.BackgroundTransparency = 0.1
    flySpeedCard.BorderSizePixel = 0
    flySpeedCard.LayoutOrder = 10
    flySpeedCard.Parent = content
    
    local flySpeedCorner = Instance.new("UICorner")
    flySpeedCorner.CornerRadius = UDim.new(0, 20)
    flySpeedCorner.Parent = flySpeedCard
    
    local flySpeedStroke = Instance.new("UIStroke")
    flySpeedStroke.Color = Color3.fromRGB(100, 200, 255)
    flySpeedStroke.Thickness = 1.8
    flySpeedStroke.Transparency = 0.6
    flySpeedStroke.Parent = flySpeedCard
    
    local flySpeedGradient = Instance.new("UIGradient")
    flySpeedGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 33, 41)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 18, 25))
    })
    flySpeedGradient.Rotation = 90
    flySpeedGradient.Parent = flySpeedCard
    
    local flySpeedIconFrame = Instance.new("Frame")
    flySpeedIconFrame.Size = UDim2.new(0, 60, 0, 60)
    flySpeedIconFrame.Position = UDim2.new(0, 20, 0.5, -30)
    flySpeedIconFrame.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    flySpeedIconFrame.BackgroundTransparency = 0.2
    flySpeedIconFrame.BorderSizePixel = 0
    flySpeedIconFrame.Parent = flySpeedCard
    
    local flySpeedIconCorner = Instance.new("UICorner")
    flySpeedIconCorner.CornerRadius = UDim.new(0, 18)
    flySpeedIconCorner.Parent = flySpeedIconFrame
    
    local flySpeedIconGlow = CreateGlow(flySpeedIconFrame, Color3.fromRGB(100, 200, 255))
    flySpeedIconGlow.ImageTransparency = 0.6
    
    local flySpeedIcon = Instance.new("TextLabel")
    flySpeedIcon.Size = UDim2.new(1, 0, 1, 0)
    flySpeedIcon.BackgroundTransparency = 1
    flySpeedIcon.Text = "🚀"
    flySpeedIcon.Font = Enum.Font.GothamBlack
    flySpeedIcon.TextSize = 34
    flySpeedIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    flySpeedIcon.Parent = flySpeedIconFrame
    
    local flySpeedTitle = Instance.new("TextLabel")
    flySpeedTitle.Size = UDim2.new(0, 280 * ScreenScale, 0, 32)
    flySpeedTitle.Position = UDim2.new(0, 100, 0, 15)
    flySpeedTitle.BackgroundTransparency = 1
    flySpeedTitle.Text = "FLY SPEED"
    flySpeedTitle.Font = Enum.Font.GothamBlack
    flySpeedTitle.TextSize = 22 * ScreenScale
    flySpeedTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    flySpeedTitle.TextXAlignment = Enum.TextXAlignment.Left
    flySpeedTitle.Parent = flySpeedCard
    
    local flySpeedBox = Instance.new("TextBox")
    flySpeedBox.Size = UDim2.new(0, 150 * ScreenScale, 0, 40 * ScreenScale)
    flySpeedBox.Position = UDim2.new(0, 100, 0, 50)
    flySpeedBox.BackgroundColor3 = Color3.fromRGB(10, 12, 20)
    flySpeedBox.BackgroundTransparency = 0.2
    flySpeedBox.Text = tostring(_G.flySpeed)
    flySpeedBox.Font = Enum.Font.Code
    flySpeedBox.TextSize = 18 * ScreenScale
    flySpeedBox.TextColor3 = Color3.fromRGB(100, 200, 255)
    flySpeedBox.TextXAlignment = Enum.TextXAlignment.Center
    flySpeedBox.BorderSizePixel = 0
    flySpeedBox.Parent = flySpeedCard
    
    local flySpeedBoxCorner = Instance.new("UICorner")
    flySpeedBoxCorner.CornerRadius = UDim.new(0, 12)
    flySpeedBoxCorner.Parent = flySpeedBox
    
    local flyPlusBtn = Instance.new("TextButton")
    flyPlusBtn.Size = UDim2.new(0, 50 * ScreenScale, 0, 40 * ScreenScale)
    flyPlusBtn.Position = UDim2.new(0, 260 * ScreenScale, 0, 50)
    flyPlusBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    flyPlusBtn.BackgroundTransparency = 0.1
    flyPlusBtn.Text = "➕"
    flyPlusBtn.Font = Enum.Font.GothamBlack
    flyPlusBtn.TextSize = 22 * ScreenScale
    flyPlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyPlusBtn.BorderSizePixel = 0
    flyPlusBtn.AutoButtonColor = false
    flyPlusBtn.Parent = flySpeedCard
    
    local flyPlusCorner = Instance.new("UICorner")
    flyPlusCorner.CornerRadius = UDim.new(0, 12)
    flyPlusCorner.Parent = flyPlusBtn
    
    local flyMinusBtn = Instance.new("TextButton")
    flyMinusBtn.Size = UDim2.new(0, 50 * ScreenScale, 0, 40 * ScreenScale)
    flyMinusBtn.Position = UDim2.new(0, 315 * ScreenScale, 0, 50)
    flyMinusBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    flyMinusBtn.BackgroundTransparency = 0.1
    flyMinusBtn.Text = "➖"
    flyMinusBtn.Font = Enum.Font.GothamBlack
    flyMinusBtn.TextSize = 22 * ScreenScale
    flyMinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyMinusBtn.BorderSizePixel = 0
    flyMinusBtn.AutoButtonColor = false
    flyMinusBtn.Parent = flySpeedCard
    
    local flyMinusCorner = Instance.new("UICorner")
    flyMinusCorner.CornerRadius = UDim.new(0, 12)
    flyMinusCorner.Parent = flyMinusBtn
    
    local modeCard = Instance.new("Frame")
    modeCard.Name = "ModeCard"
    modeCard.Size = UDim2.new(1, 0, 0, CARD_HEIGHT)
    modeCard.BackgroundColor3 = Color3.fromRGB(20, 23, 31)
    modeCard.BackgroundTransparency = 0.1
    modeCard.BorderSizePixel = 0
    modeCard.LayoutOrder = 11
    modeCard.Parent = content
    
    local modeCorner = Instance.new("UICorner")
    modeCorner.CornerRadius = UDim.new(0, 20)
    modeCorner.Parent = modeCard
    
    local modeStroke = Instance.new("UIStroke")
    modeStroke.Color = Color3.fromRGB(150, 150, 255)
    modeStroke.Thickness = 1.8
    modeStroke.Transparency = 0.6
    modeStroke.Parent = modeCard
    
    local modeGradient = Instance.new("UIGradient")
    modeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 33, 41)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 18, 25))
    })
    modeGradient.Rotation = 90
    modeGradient.Parent = modeCard
    
    local modeIconFrame = Instance.new("Frame")
    modeIconFrame.Size = UDim2.new(0, 60, 0, 60)
    modeIconFrame.Position = UDim2.new(0, 20, 0.5, -30)
    modeIconFrame.BackgroundColor3 = Color3.fromRGB(150, 150, 255)
    modeIconFrame.BackgroundTransparency = 0.2
    modeIconFrame.BorderSizePixel = 0
    modeIconFrame.Parent = modeCard
    
    local modeIconCorner = Instance.new("UICorner")
    modeIconCorner.CornerRadius = UDim.new(0, 18)
    modeIconCorner.Parent = modeIconFrame
    
    local modeIconGlow = CreateGlow(modeIconFrame, Color3.fromRGB(150, 150, 255))
    modeIconGlow.ImageTransparency = 0.6
    
    local modeIcon = Instance.new("TextLabel")
    modeIcon.Size = UDim2.new(1, 0, 1, 0)
    modeIcon.BackgroundTransparency = 1
    modeIcon.Text = "🔄"
    modeIcon.Font = Enum.Font.GothamBlack
    modeIcon.TextSize = 34
    modeIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    modeIcon.Parent = modeIconFrame
    
    local modeTitle = Instance.new("TextLabel")
    modeTitle.Size = UDim2.new(0, 280 * ScreenScale, 0, 32)
    modeTitle.Position = UDim2.new(0, 100, 0, 20)
    modeTitle.BackgroundTransparency = 1
    modeTitle.Text = "SPIN MODE"
    modeTitle.Font = Enum.Font.GothamBlack
    modeTitle.TextSize = 22 * ScreenScale
    modeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    modeTitle.TextXAlignment = Enum.TextXAlignment.Left
    modeTitle.Parent = modeCard
    
    local modeValue = Instance.new("TextLabel")
    modeValue.Name = "ModeValue"
    modeValue.Size = UDim2.new(0, 150 * ScreenScale, 0, 24)
    modeValue.Position = UDim2.new(0, 100, 0, 55)
    modeValue.BackgroundTransparency = 1
    modeValue.Text = _G.cheDoSpinHienTai == 1 and "NGANG" or "DỌC"
    modeValue.Font = Enum.Font.GothamBold
    modeValue.TextSize = 18 * ScreenScale
    modeValue.TextColor3 = Color3.fromRGB(255, 255, 0)
    modeValue.TextXAlignment = Enum.TextXAlignment.Left
    modeValue.Parent = modeCard
    
    local modeBtn = Instance.new("TextButton")
    modeBtn.Size = UDim2.new(0, 100 * ScreenScale, 0, 45 * ScreenScale)
    modeBtn.Position = UDim2.new(1, -120 * ScreenScale, 0.5, -22.5 * ScreenScale)
    modeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    modeBtn.BackgroundTransparency = 0.1
    modeBtn.Text = "ĐỔI"
    modeBtn.Font = Enum.Font.GothamBlack
    modeBtn.TextSize = 20 * ScreenScale
    modeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    modeBtn.BorderSizePixel = 0
    modeBtn.AutoButtonColor = false
    modeBtn.Parent = modeCard
    
    local modeBtnCorner = Instance.new("UICorner")
    modeBtnCorner.CornerRadius = UDim.new(0, 15)
    modeBtnCorner.Parent = modeBtn
    
    local modeBtnGradient = Instance.new("UIGradient")
    modeBtnGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 130, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 200))
    })
    modeBtnGradient.Rotation = 45
    modeBtnGradient.Parent = modeBtn
    
    local resetBtn = Instance.new("TextButton")
    resetBtn.Size = UDim2.new(1, 0, 0, 65 * ScreenScale)
    resetBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    resetBtn.BackgroundTransparency = 0.1
    resetBtn.Text = "🎯 RESET AIM"
    resetBtn.Font = Enum.Font.GothamBlack
    resetBtn.TextSize = 24 * ScreenScale
    resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    resetBtn.BorderSizePixel = 0
    resetBtn.AutoButtonColor = false
    resetBtn.LayoutOrder = 12
    resetBtn.Parent = content
    
    local resetCorner = Instance.new("UICorner")
    resetCorner.CornerRadius = UDim.new(0, 18)
    resetCorner.Parent = resetBtn
    
    local resetStroke = Instance.new("UIStroke")
    resetStroke.Color = Color3.fromRGB(255, 200, 0)
    resetStroke.Thickness = 2
    resetStroke.Transparency = 0.5
    resetStroke.Parent = resetBtn
    
    local resetGradient = Instance.new("UIGradient")
    resetGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 130, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 70, 0))
    })
    resetGradient.Rotation = 45
    resetGradient.Parent = resetBtn
    
    local playerListBtn = Instance.new("TextButton")
    playerListBtn.Size = UDim2.new(1, 0, 0, 65 * ScreenScale)
    playerListBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
    playerListBtn.BackgroundTransparency = 0.1
    playerListBtn.Text = "👥 OVERLAY DANH SÁCH [K]"
    playerListBtn.Font = Enum.Font.GothamBlack
    playerListBtn.TextSize = 20 * ScreenScale
    playerListBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    playerListBtn.BorderSizePixel = 0
    playerListBtn.AutoButtonColor = false
    playerListBtn.LayoutOrder = 13
    playerListBtn.Parent = content
    
    local playerListCorner = Instance.new("UICorner")
    playerListCorner.CornerRadius = UDim.new(0, 18)
    playerListCorner.Parent = playerListBtn
    
    local playerListStroke = Instance.new("UIStroke")
    playerListStroke.Color = Color3.fromRGB(0, 200, 255)
    playerListStroke.Thickness = 2
    playerListStroke.Transparency = 0.5
    playerListStroke.Parent = playerListBtn
    
    playerListBtn.MouseButton1Click:Connect(function()
        togglePlayerOverlay()
    end)
    
    spinGear.MouseButton1Click:Connect(function()
        currentBinding = "spin"
        createBindMenu()
    end)
    
    aimGear.MouseButton1Click:Connect(function()
        currentBinding = "aim"
        createBindMenu()
    end)
    
    flyGear.MouseButton1Click:Connect(function()
        currentBinding = "fly"
        createBindMenu()
    end)
    
    teleGear.MouseButton1Click:Connect(function()
        currentBinding = "tele"
        createBindMenu()
    end)
    
    autoClickGear.MouseButton1Click:Connect(function()
        currentBinding = "autoClick"
        createBindMenu()
    end)
    
    fixLagGear.MouseButton1Click:Connect(function()
        currentBinding = "fixLag"
        createBindMenu()
    end)
    
    wallGear.MouseButton1Click:Connect(function()
        currentBinding = "wallHack"
        createBindMenu()
    end)
    
    spinBtn.MouseButton1Click:Connect(function()
        _G.dangXoay = not _G.dangXoay
        if _G.dangXoay then
            spinBtn.Text = "ON"
            spinBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            if _G.ketNoiMang then _G.ketNoiMang:Disconnect() end
            if player.Character then _G.ketNoiMang = RunService.Heartbeat:Connect(spinBot) end
            sendNotification("KHANHPC", "✅ SPIN BOT: BẬT", 1.5, "🌀")
        else
            spinBtn.Text = "OFF"
            spinBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
            if _G.ketNoiMang then _G.ketNoiMang:Disconnect() end
            resetSpin(player.Character)
            sendNotification("KHANHPC", "❌ SPIN BOT: TẮT", 1.5, "🌀")
        end
    end)
    
    aimBtn.MouseButton1Click:Connect(function()
        _G.dangAimBot = not _G.dangAimBot
        if _G.dangAimBot then
            aimBtn.Text = "ON"
            aimBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            if _G.ketNoiAimBot then _G.ketNoiAimBot:Disconnect() end
            _G.ketNoiAimBot = RunService.RenderStepped:Connect(aimBot)
            sendNotification("KHANHPC", "✅ AIM BOT: BẬT", 1.5, "🎯")
        else
            aimBtn.Text = "OFF"
            aimBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
            if _G.ketNoiAimBot then _G.ketNoiAimBot:Disconnect() end
            huyTarget()
            sendNotification("KHANHPC", "❌ AIM BOT: TẮT", 1.5, "🎯")
        end
    end)
    
    flyBtn.MouseButton1Click:Connect(function()
        _G.dangFly = not _G.dangFly
        if _G.dangFly then
            flyBtn.Text = "ON"
            flyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            if not _G.ketNoiFly then _G.ketNoiFly = RunService.RenderStepped:Connect(flyUpdate) end
            if player.Character then startFly() end
            sendNotification("KHANHPC", "✅ FLY MODE: BẬT", 1.5, "🕊️")
        else
            flyBtn.Text = "OFF"
            flyBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
            if _G.ketNoiFly then _G.ketNoiFly:Disconnect() end
            stopFly()
            sendNotification("KHANHPC", "❌ FLY MODE: TẮT", 1.5, "🕊️")
        end
    end)
    
    teleBtn.MouseButton1Click:Connect(function()
        _G.dangAutoTele = not _G.dangAutoTele
        if _G.dangAutoTele then
            teleBtn.Text = "ON"
            teleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            if _G.ketNoiAutoTele then _G.ketNoiAutoTele:Disconnect() end
            _G.ketNoiAutoTele = RunService.RenderStepped:Connect(autoTele)
            sendNotification("KHANHPC", "✅ AUTO TELE: BẬT", 1.5, "📡")
        else
            teleBtn.Text = "OFF"
            teleBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
            if _G.ketNoiAutoTele then _G.ketNoiAutoTele:Disconnect() end
            sendNotification("KHANHPC", "❌ AUTO TELE: TẮT", 1.5, "📡")
        end
    end)
    
    autoClickBtn.MouseButton1Click:Connect(function()
        _G.autoShoot = not _G.autoShoot
        if _G.autoShoot then
            autoClickBtn.Text = "ON"
            autoClickBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            if _G.ketNoiAutoClick then _G.ketNoiAutoClick:Disconnect() end
            _G.ketNoiAutoClick = RunService.RenderStepped:Connect(autoClick)
            sendNotification("KHANHPC", "🖱️ AUTO CLICK: BẬT", 1.5, "🖱️")
        else
            autoClickBtn.Text = "OFF"
            autoClickBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
            if _G.ketNoiAutoClick then _G.ketNoiAutoClick:Disconnect() end
            _G.isClicking = false
            sendNotification("KHANHPC", "🖱️ AUTO CLICK: TẮT", 1.5, "🖱️")
        end
    end)
    
    fixLagBtn.MouseButton1Click:Connect(function()
        _G.fixLag = not _G.fixLag
        if _G.fixLag then
            fixLagBtn.Text = "ON"
            fixLagBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            applyFixLag(true)
        else
            fixLagBtn.Text = "OFF"
            fixLagBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
            applyFixLag(false)
        end
    end)
    
    wallBtn.MouseButton1Click:Connect(function()
        _G.dangWallHack = not _G.dangWallHack
        if _G.dangWallHack then
            wallBtn.Text = "ON"
            wallBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            khoiTaoWallHack()
            sendNotification("KHANHPC", "👁️ WALLHACK: BẬT", 1.5, "👁️")
        else
            wallBtn.Text = "OFF"
            wallBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
            for _, tag in pairs(_G.espNameTags) do pcall(function() tag:Destroy() end) end
            for _, box in pairs(_G.espBoxes) do pcall(function() box:Destroy() end) end
            _G.espNameTags = {}
            _G.espBoxes = {}
            sendNotification("KHANHPC", "👁️ WALLHACK: TẮT", 1.5, "👁️")
        end
    end)
    
    checkWallToggle.MouseButton1Click:Connect(function()
        _G.checkWall = not _G.checkWall
        if _G.checkWall then
            checkWallToggle.Text = "ON"
            checkWallToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            sendNotification("KHANHPC", "🧱 CHECK WALL: BẬT", 1.5, "🧱")
        else
            checkWallToggle.Text = "OFF"
            checkWallToggle.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
            sendNotification("KHANHPC", "🧱 CHECK WALL: TẮT", 1.5, "🧱")
        end
    end)
    
    plusBtn.MouseButton1Click:Connect(function()
        local val = tonumber(speedBox.Text) or 1
        val = val * 2
        speedBox.Text = tostring(val)
        _G.tocDoSpin = val
        sendNotification("KHANHPC", "⚡ SPIN SPEED: " .. val, 1, "⚙️")
    end)
    
    minusBtn.MouseButton1Click:Connect(function()
        local val = tonumber(speedBox.Text) or 1
        val = math.max(1, val / 2)
        speedBox.Text = tostring(val)
        _G.tocDoSpin = val
        sendNotification("KHANHPC", "⚡ SPIN SPEED: " .. val, 1, "⚙️")
    end)
    
    speedBox.FocusLost:Connect(function()
        local val = tonumber(speedBox.Text) or 1
        val = math.max(1, math.min(10000, val))
        speedBox.Text = tostring(val)
        _G.tocDoSpin = val
        sendNotification("KHANHPC", "⚡ SPIN SPEED: " .. val, 1, "⚙️")
    end)
    
    flyPlusBtn.MouseButton1Click:Connect(function()
        local val = tonumber(flySpeedBox.Text) or 50
        val = val + 10
        flySpeedBox.Text = tostring(val)
        _G.flySpeed = val
        sendNotification("KHANHPC", "🚀 FLY SPEED: " .. val, 1, "🚀")
    end)
    
    flyMinusBtn.MouseButton1Click:Connect(function()
        local val = tonumber(flySpeedBox.Text) or 50
        val = math.max(10, val - 10)
        flySpeedBox.Text = tostring(val)
        _G.flySpeed = val
        sendNotification("KHANHPC", "🚀 FLY SPEED: " .. val, 1, "🚀")
    end)
    
    flySpeedBox.FocusLost:Connect(function()
        local val = tonumber(flySpeedBox.Text) or 50
        val = math.max(10, math.min(500, val))
        flySpeedBox.Text = tostring(val)
        _G.flySpeed = val
        sendNotification("KHANHPC", "🚀 FLY SPEED: " .. val, 1, "🚀")
    end)
    
    modeBtn.MouseButton1Click:Connect(function()
        _G.cheDoSpinHienTai = _G.cheDoSpinHienTai == 1 and 2 or 1
        modeValue.Text = _G.cheDoSpinHienTai == 1 and "NGANG" or "DỌC"
        if _G.dangXoay and player.Character then
            if _G.ketNoiMang then _G.ketNoiMang:Disconnect() end
            _G.ketNoiMang = RunService.Heartbeat:Connect(spinBot)
        end
        sendNotification("KHANHPC", "🔄 SPIN MODE: " .. modeValue.Text, 1.5, "🔄")
    end)
    
    resetBtn.MouseButton1Click:Connect(function()
        huyTarget()
        resetBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        task.wait(0.1)
        resetBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
        sendNotification("KHANHPC", "🎯 AIM ĐÃ ĐƯỢC RESET", 1.5, "🎯")
    end)
    
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        
        if input.KeyCode == _G.keyBinds.spin then
            _G.dangXoay = not _G.dangXoay
            if spinBtn then
                if _G.dangXoay then
                    spinBtn.Text = "ON"
                    spinBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                    if _G.ketNoiMang then _G.ketNoiMang:Disconnect() end
                    if player.Character then _G.ketNoiMang = RunService.Heartbeat:Connect(spinBot) end
                    sendNotification("KHANHPC", "[PHÍM TẮT] ✅ SPIN BOT: BẬT", 1.5, "🌀")
                else
                    spinBtn.Text = "OFF"
                    spinBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
                    if _G.ketNoiMang then _G.ketNoiMang:Disconnect() end
                    resetSpin(player.Character)
                    sendNotification("KHANHPC", "[PHÍM TẮT] ❌ SPIN BOT: TẮT", 1.5, "🌀")
                end
            end
        
        elseif input.KeyCode == _G.keyBinds.aim then
            _G.dangAimBot = not _G.dangAimBot
            if aimBtn then
                if _G.dangAimBot then
                    aimBtn.Text = "ON"
                    aimBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                    if _G.ketNoiAimBot then _G.ketNoiAimBot:Disconnect() end
                    _G.ketNoiAimBot = RunService.RenderStepped:Connect(aimBot)
                    sendNotification("KHANHPC", "[PHÍM TẮT] ✅ AIM BOT: BẬT", 1.5, "🎯")
                else
                    aimBtn.Text = "OFF"
                    aimBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
                    if _G.ketNoiAimBot then _G.ketNoiAimBot:Disconnect() end
                    huyTarget()
                    sendNotification("KHANHPC", "[PHÍM TẮT] ❌ AIM BOT: TẮT", 1.5, "🎯")
                end
            end
        
        elseif input.KeyCode == _G.keyBinds.fly then
            _G.dangFly = not _G.dangFly
            if flyBtn then
                if _G.dangFly then
                    flyBtn.Text = "ON"
                    flyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                    if not _G.ketNoiFly then _G.ketNoiFly = RunService.RenderStepped:Connect(flyUpdate) end
                    if player.Character then startFly() end
                    sendNotification("KHANHPC", "[PHÍM TẮT] ✅ FLY MODE: BẬT", 1.5, "🕊️")
                else
                    flyBtn.Text = "OFF"
                    flyBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
                    if _G.ketNoiFly then _G.ketNoiFly:Disconnect() end
                    stopFly()
                    sendNotification("KHANHPC", "[PHÍM TẮT] ❌ FLY MODE: TẮT", 1.5, "🕊️")
                end
            end
        
        elseif input.KeyCode == _G.keyBinds.tele then
            _G.dangAutoTele = not _G.dangAutoTele
            if teleBtn then
                if _G.dangAutoTele then
                    teleBtn.Text = "ON"
                    teleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                    if _G.ketNoiAutoTele then _G.ketNoiAutoTele:Disconnect() end
                    _G.ketNoiAutoTele = RunService.RenderStepped:Connect(autoTele)
                    sendNotification("KHANHPC", "[PHÍM TẮT] ✅ AUTO TELE: BẬT", 1.5, "📡")
                else
                    teleBtn.Text = "OFF"
                    teleBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
                    if _G.ketNoiAutoTele then _G.ketNoiAutoTele:Disconnect() end
                    sendNotification("KHANHPC", "[PHÍM TẮT] ❌ AUTO TELE: TẮT", 1.5, "📡")
                end
            end
            
        elseif input.KeyCode == _G.keyBinds.telePos then
            if telePosMenu.Visible then
                TweenService:Create(telePosMenu, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                    Size = UDim2.new(0, 200 * ScreenScale, 0, 0)
                }):Play()
                task.wait(0.3)
                telePosMenu.Visible = false
            else
                telePosMenu.Visible = true
                TweenService:Create(telePosMenu, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 200 * ScreenScale, 0, 150 * ScreenScale)
                }):Play()
            end
        
        elseif input.KeyCode == _G.keyBinds.autoClick then
            _G.autoShoot = not _G.autoShoot
            if autoClickBtn then
                if _G.autoShoot then
                    autoClickBtn.Text = "ON"
                    autoClickBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                    if _G.ketNoiAutoClick then _G.ketNoiAutoClick:Disconnect() end
                    _G.ketNoiAutoClick = RunService.RenderStepped:Connect(autoClick)
                    sendNotification("KHANHPC", "[PHÍM TẮT] ✅ AUTO CLICK: BẬT", 1.5, "🖱️")
                else
                    autoClickBtn.Text = "OFF"
                    autoClickBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
                    if _G.ketNoiAutoClick then _G.ketNoiAutoClick:Disconnect() end
                    _G.isClicking = false
                    sendNotification("KHANHPC", "[PHÍM TẮT] ❌ AUTO CLICK: TẮT", 1.5, "🖱️")
                end
            end
        
        elseif input.KeyCode == _G.keyBinds.fixLag then
            _G.fixLag = not _G.fixLag
            if fixLagBtn then
                if _G.fixLag then
                    fixLagBtn.Text = "ON"
                    fixLagBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                    applyFixLag(true)
                else
                    fixLagBtn.Text = "OFF"
                    fixLagBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
                    applyFixLag(false)
                end
            end
        
        elseif input.KeyCode == _G.keyBinds.wallHack then
            _G.dangWallHack = not _G.dangWallHack
            if wallBtn then
                if _G.dangWallHack then
                    wallBtn.Text = "ON"
                    wallBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                    khoiTaoWallHack()
                    sendNotification("KHANHPC", "[PHÍM TẮT] 👁️ WALLHACK: BẬT", 1.5, "👁️")
                else
                    wallBtn.Text = "OFF"
                    wallBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
                    for _, tag in pairs(_G.espNameTags) do pcall(function() tag:Destroy() end) end
                    for _, box in pairs(_G.espBoxes) do pcall(function() box:Destroy() end) end
                    _G.espNameTags = {}
                    _G.espBoxes = {}
                    sendNotification("KHANHPC", "[PHÍM TẮT] 👁️ WALLHACK: TẮT", 1.5, "👁️")
                end
            end
        
        elseif input.KeyCode == _G.keyBinds.playerList then
            togglePlayerOverlay()
        
        elseif input.KeyCode == _G.keyBinds.mode then
            _G.cheDoSpinHienTai = _G.cheDoSpinHienTai == 1 and 2 or 1
            if modeValue then modeValue.Text = _G.cheDoSpinHienTai == 1 and "NGANG" or "DỌC" end
            if _G.dangXoay and player.Character then
                if _G.ketNoiMang then _G.ketNoiMang:Disconnect() end
                _G.ketNoiMang = RunService.Heartbeat:Connect(spinBot)
            end
            sendNotification("KHANHPC", "🔄 SPIN MODE: " .. modeValue.Text, 1.5, "🔄")
        
        elseif input.KeyCode == _G.keyBinds.reset then
            huyTarget()
            if resetBtn then
                resetBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
                task.wait(0.1)
                resetBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
            end
            sendNotification("KHANHPC", "🎯 AIM ĐÃ ĐƯỢC RESET", 1.5, "🎯")
        
        elseif input.KeyCode == _G.keyBinds.menu then
            if main and main.Visible then
                TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                    Size = UDim2.new(0, 0, 0, 0),
                    Position = UDim2.new(0.02, MENU_PADDING, 0.5, 0),
                    BackgroundTransparency = 1
                }):Play()
                task.wait(0.2)
                main.Visible = false
                showBtn.Visible = true
                TweenService:Create(showBtn, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 150 * ScreenScale, 0, 55 * ScreenScale),
                    Position = UDim2.new(1, -160 * ScreenScale, 1, -65 * ScreenScale),
                    BackgroundTransparency = 0.1
                }):Play()
                _G.menuVisible = false
            else
                showBtn.Visible = false
                main.Visible = true
                TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, MENU_WIDTH, 0, MENU_HEIGHT),
                    Position = UDim2.new(0.02, MENU_PADDING, 0.5, -MENU_HEIGHT/2),
                    BackgroundTransparency = 0.1
                }):Play()
                _G.menuVisible = true
            end
        end
    end)
    
    local function onCharacterAdded(char)
        task.wait(0.5)
        resetSpin(char)
        if _G.dangXoay then
            if _G.ketNoiMang then _G.ketNoiMang:Disconnect() end
            _G.ketNoiMang = RunService.Heartbeat:Connect(spinBot)
        end
        if _G.dangFly then
            if _G.ketNoiFly then _G.ketNoiFly:Disconnect() end
            _G.ketNoiFly = RunService.RenderStepped:Connect(flyUpdate)
            startFly()
        end
        if _G.autoShoot then
            if _G.ketNoiAutoClick then _G.ketNoiAutoClick:Disconnect() end
            _G.ketNoiAutoClick = RunService.RenderStepped:Connect(autoClick)
        end
        task.wait(0.5)
        khoiTaoWallHack()
    end
    
    player.CharacterAdded:Connect(onCharacterAdded)
    if player.Character then onCharacterAdded(player.Character) end
    
    local function onPlayerAdded(newPlayer)
        newPlayer.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            if char and char:FindFirstChild("Head") then
                if _G.espNameTags[newPlayer] then pcall(function() _G.espNameTags[newPlayer]:Destroy() end) end
                if _G.espBoxes[newPlayer] then pcall(function() _G.espBoxes[newPlayer]:Destroy() end) end
                if _G.dangWallHack then
                    _G.espNameTags[newPlayer] = createNameTag(newPlayer)
                    _G.espNameTags[newPlayer].Parent = char.Head
                    _G.espBoxes[newPlayer] = createBoxESP(newPlayer)
                    _G.espBoxes[newPlayer].Parent = char
                end
            end
        end)
    end
    
    Players.PlayerAdded:Connect(onPlayerAdded)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then onPlayerAdded(plr) end
    end
    
    return menu
end

-- ============================================
-- KEY MENU
-- ============================================
local function createKeyMenu()
    pcall(function() 
        local old = CoreGui:FindFirstChild("KeySystem")
        if old then old:Destroy() end
    end)
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "KeySystem"
    gui.Parent = CoreGui
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 999999
    
    local blur = Instance.new("Frame")
    blur.Size = UDim2.new(1, 0, 1, 0)
    blur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    blur.BackgroundTransparency = 0.6
    blur.BorderSizePixel = 0
    blur.Parent = gui
    
    local menuScale = math.min(1, ViewportSize.X / 1920, ViewportSize.Y / 1080)
    local keyMenuWidth = math.floor(550 * menuScale)
    local keyMenuHeight = math.floor(620 * menuScale)
    
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 0, 0, 0)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
    main.BackgroundTransparency = 0.05
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = blur
    
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Position = UDim2.new(0, -20, 0, -20)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://13111269966"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = main
    shadow.ZIndex = -1
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 30)
    mainCorner.Parent = main
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(0, 200, 255)
    mainStroke.Thickness = 2
    mainStroke.Transparency = 0.4
    mainStroke.Parent = main
    
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 100)
    header.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    header.BackgroundTransparency = 0.1
    header.BorderSizePixel = 0
    header.Parent = main
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 30)
    headerCorner.Parent = header
    
    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 80, 200))
    })
    headerGradient.Rotation = 45
    headerGradient.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0.7, 0)
    title.Position = UDim2.new(0, 0, 0, 15)
    title.BackgroundTransparency = 1
    title.Text = "KHANHPC"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 48 * menuScale
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextStrokeTransparency = 0.3
    title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    title.Parent = header
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0.3, 0)
    subtitle.Position = UDim2.new(0, 0, 0.7, -5)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "PREMIUM CHEAT SYSTEM"
    subtitle.Font = Enum.Font.GothamBold
    subtitle.TextSize = 18 * menuScale
    subtitle.TextColor3 = Color3.fromRGB(200, 255, 200)
    subtitle.TextTransparency = 0.2
    subtitle.Parent = header
    
    local gameFrame = Instance.new("Frame")
    gameFrame.Size = UDim2.new(1, -40, 0, 40)
    gameFrame.Position = UDim2.new(0, 20, 0, 105)
    gameFrame.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    gameFrame.BackgroundTransparency = 0.2
    gameFrame.BorderSizePixel = 0
    gameFrame.Parent = main
    
    local gameCorner = Instance.new("UICorner")
    gameCorner.CornerRadius = UDim.new(0, 15)
    gameCorner.Parent = gameFrame
    
    local gameIcon = Instance.new("TextLabel")
    gameIcon.Size = UDim2.new(0, 40, 1, 0)
    gameIcon.Position = UDim2.new(0, 5, 0, 0)
    gameIcon.BackgroundTransparency = 1
    gameIcon.Text = "🎮"
    gameIcon.Font = Enum.Font.GothamBold
    gameIcon.TextSize = 24 * menuScale
    gameIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    gameIcon.Parent = gameFrame
    
    local gameNameLabel = Instance.new("TextLabel")
    gameNameLabel.Size = UDim2.new(1, -50, 1, 0)
    gameNameLabel.Position = UDim2.new(0, 45, 0, 0)
    gameNameLabel.BackgroundTransparency = 1
    gameNameLabel.Text = GAME_NAME
    gameNameLabel.Font = Enum.Font.GothamBlack
    gameNameLabel.TextSize = 20 * menuScale
    gameNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    gameNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    gameNameLabel.Parent = gameFrame
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -60, 1, -190)
    content.Position = UDim2.new(0, 30, 0, 155)
    content.BackgroundTransparency = 1
    content.Parent = main
    
    local profileCard = Instance.new("Frame")
    profileCard.Size = UDim2.new(1, 0, 0, 90)
    profileCard.BackgroundColor3 = Color3.fromRGB(20, 23, 31)
    profileCard.BackgroundTransparency = 0.1
    profileCard.BorderSizePixel = 0
    profileCard.Parent = content
    
    local profileCorner = Instance.new("UICorner")
    profileCorner.CornerRadius = UDim.new(0, 20)
    profileCorner.Parent = profileCard
    
    local profileStroke = Instance.new("UIStroke")
    profileStroke.Color = Color3.fromRGB(0, 200, 255)
    profileStroke.Thickness = 1.5
    profileStroke.Transparency = 0.6
    profileStroke.Parent = profileCard
    
    local profileGradient = Instance.new("UIGradient")
    profileGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 33, 41)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 18, 25))
    })
    profileGradient.Rotation = 90
    profileGradient.Parent = profileCard
    
    local avatarFrame = Instance.new("Frame")
    avatarFrame.Size = UDim2.new(0, 60, 0, 60)
    avatarFrame.Position = UDim2.new(0, 15, 0.5, -30)
    avatarFrame.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    avatarFrame.BackgroundTransparency = 0.1
    avatarFrame.BorderSizePixel = 0
    avatarFrame.Parent = profileCard
    
    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(1, 0)
    avatarCorner.Parent = avatarFrame
    
    local avatarGlow = CreateGlow(avatarFrame, Color3.fromRGB(0, 200, 255))
    avatarGlow.ImageTransparency = 0.5
    
    local avatarIcon = Instance.new("TextLabel")
    avatarIcon.Size = UDim2.new(1, 0, 1, 0)
    avatarIcon.BackgroundTransparency = 1
    avatarIcon.Text = string.sub(player.DisplayName, 1, 1):upper()
    avatarIcon.Font = Enum.Font.GothamBlack
    avatarIcon.TextSize = 32
    avatarIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    avatarIcon.Parent = avatarFrame
    
    local userName = Instance.new("TextLabel")
    userName.Size = UDim2.new(1, -90, 0, 30)
    userName.Position = UDim2.new(0, 85, 0, 18)
    userName.BackgroundTransparency = 1
    userName.Text = player.DisplayName
    userName.Font = Enum.Font.GothamBlack
    userName.TextSize = 22
    userName.TextColor3 = Color3.fromRGB(255, 255, 255)
    userName.TextXAlignment = Enum.TextXAlignment.Left
    userName.Parent = profileCard
    
    local userId = Instance.new("TextLabel")
    userId.Size = UDim2.new(1, -90, 0, 20)
    userId.Position = UDim2.new(0, 85, 0, 48)
    userId.BackgroundTransparency = 1
    userId.Text = "UID: " .. player.UserId
    userId.Font = Enum.Font.GothamBold
    userId.TextSize = 14
    userId.TextColor3 = Color3.fromRGB(150, 150, 255)
    userId.TextXAlignment = Enum.TextXAlignment.Left
    userId.Parent = profileCard
    
    local keyLabel = Instance.new("TextLabel")
    keyLabel.Size = UDim2.new(1, 0, 0, 40)
    keyLabel.Position = UDim2.new(0, 0, 0, 110)
    keyLabel.BackgroundTransparency = 1
    keyLabel.Text = "🔑 NHẬP KEY KÍCH HOẠT"
    keyLabel.Font = Enum.Font.GothamBlack
    keyLabel.TextSize = 20 * menuScale
    keyLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    keyLabel.TextXAlignment = Enum.TextXAlignment.Center
    keyLabel.Parent = content
    
    local keyBoxFrame = Instance.new("Frame")
    keyBoxFrame.Size = UDim2.new(1, 0, 0, 80)
    keyBoxFrame.Position = UDim2.new(0, 0, 0, 150)
    keyBoxFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 20)
    keyBoxFrame.BackgroundTransparency = 0.1
    keyBoxFrame.BorderSizePixel = 0
    keyBoxFrame.Parent = content
    
    local keyBoxCorner = Instance.new("UICorner")
    keyBoxCorner.CornerRadius = UDim.new(0, 20)
    keyBoxCorner.Parent = keyBoxFrame
    
    local keyBoxStroke = Instance.new("UIStroke")
    keyBoxStroke.Color = Color3.fromRGB(0, 200, 255)
    keyBoxStroke.Thickness = 2
    keyBoxStroke.Transparency = 0.5
    keyBoxStroke.Parent = keyBoxFrame
    
    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(1, -40, 1, 0)
    keyInput.Position = UDim2.new(0, 20, 0, 0)
    keyInput.BackgroundTransparency = 1
    keyInput.PlaceholderText = "XXXX-XXX-XXXXX-XXXXX"
    keyInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
    keyInput.Text = ""
    keyInput.Font = Enum.Font.Code
    keyInput.TextSize = 24 * menuScale
    keyInput.TextColor3 = Color3.fromRGB(100, 255, 200)
    keyInput.TextXAlignment = Enum.TextXAlignment.Center
    keyInput.ClearTextOnFocus = true
    keyInput.Parent = keyBoxFrame
    
    local btnContainer = Instance.new("Frame")
    btnContainer.Size = UDim2.new(1, 0, 0, 70)
    btnContainer.Position = UDim2.new(0, 0, 0, 250)
    btnContainer.BackgroundTransparency = 1
    btnContainer.Parent = content
    
    local verifyBtn = Instance.new("TextButton")
    verifyBtn.Size = UDim2.new(0.45, 0, 0, 55)
    verifyBtn.Position = UDim2.new(0, 0, 0, 0)
    verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    verifyBtn.BackgroundTransparency = 0.1
    verifyBtn.Text = "✅ XÁC THỰC"
    verifyBtn.Font = Enum.Font.GothamBlack
    verifyBtn.TextSize = 18 * menuScale
    verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    verifyBtn.BorderSizePixel = 0
    verifyBtn.AutoButtonColor = false
    verifyBtn.Parent = btnContainer
    
    local verifyCorner = Instance.new("UICorner")
    verifyCorner.CornerRadius = UDim.new(0, 18)
    verifyCorner.Parent = verifyBtn
    
    local verifyGradient = Instance.new("UIGradient")
    verifyGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 230, 130)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 70))
    })
    verifyGradient.Rotation = 45
    verifyGradient.Parent = verifyBtn
    
    local getKeyBtn = Instance.new("TextButton")
    getKeyBtn.Size = UDim2.new(0.45, 0, 0, 55)
    getKeyBtn.Position = UDim2.new(0.55, 0, 0, 0)
    getKeyBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    getKeyBtn.BackgroundTransparency = 0.1
    getKeyBtn.Text = "🔗 LẤY KEY"
    getKeyBtn.Font = Enum.Font.GothamBlack
    getKeyBtn.TextSize = 18 * menuScale
    getKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    getKeyBtn.BorderSizePixel = 0
    getKeyBtn.AutoButtonColor = false
    getKeyBtn.Parent = btnContainer
    
    local getKeyCorner = Instance.new("UICorner")
    getKeyCorner.CornerRadius = UDim.new(0, 18)
    getKeyCorner.Parent = getKeyBtn
    
    local getKeyGradient = Instance.new("UIGradient")
    getKeyGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 50, 50))
    })
    getKeyGradient.Rotation = 45
    getKeyGradient.Parent = getKeyBtn
    
    local statusFrame = Instance.new("Frame")
    statusFrame.Size = UDim2.new(1, 0, 0, 70)
    statusFrame.Position = UDim2.new(0, 0, 1, -70)
    statusFrame.BackgroundColor3 = Color3.fromRGB(20, 23, 31)
    statusFrame.BackgroundTransparency = 0.1
    statusFrame.BorderSizePixel = 0
    statusFrame.Parent = content
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 20)
    statusCorner.Parent = statusFrame
    
    local statusIcon = Instance.new("TextLabel")
    statusIcon.Size = UDim2.new(0, 40, 1, 0)
    statusIcon.Position = UDim2.new(0, 15, 0, 0)
    statusIcon.BackgroundTransparency = 1
    statusIcon.Text = "ℹ️"
    statusIcon.Font = Enum.Font.GothamBold
    statusIcon.TextSize = 28
    statusIcon.TextColor3 = Color3.fromRGB(0, 200, 255)
    statusIcon.Parent = statusFrame
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -70, 1, 0)
    statusLabel.Position = UDim2.new(0, 60, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Lấy key tại: " .. WEB_URL
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextSize = 14 * menuScale
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    statusLabel.TextWrapped = true
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = statusFrame
    
    TweenService:Create(main, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, keyMenuWidth, 0, keyMenuHeight),
        Position = UDim2.new(0.5, -keyMenuWidth/2, 0.5, -keyMenuHeight/2)
    }):Play()
    
    local function setupButtonHover(btn, normalColor, hoverColor)
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0.47, 0, 0, 59),
                Position = UDim2.new(btn.Position.X.Scale, btn.Position.X.Offset - 5, 0, -2),
                BackgroundColor3 = hoverColor
            }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0.45, 0, 0, 55),
                Position = UDim2.new(btn.Position.X.Scale, btn.Position.X.Offset + 5, 0, 0),
                BackgroundColor3 = normalColor
            }):Play()
        end)
    end
    
    setupButtonHover(verifyBtn, Color3.fromRGB(0, 200, 100), Color3.fromRGB(0, 240, 140))
    setupButtonHover(getKeyBtn, Color3.fromRGB(255, 70, 70), Color3.fromRGB(255, 120, 120))
    
    verifyBtn.MouseButton1Click:Connect(function()
        local key = keyInput.Text:gsub("%s+", ""):upper()
        if key == "" then
            statusLabel.Text = "❌ VUI LÒNG NHẬP KEY!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            statusIcon.Text = "❌"
            return
        end
        
        statusLabel.Text = "⏳ ĐANG XÁC THỰC..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        statusIcon.Text = "⏳"
        verifyBtn.Text = "..."
        verifyBtn.Active = false
        getKeyBtn.Active = false
        
        task.spawn(function()
            task.wait(1.2)
            local isValid = VALID_KEYS[key] == true
            
            if isValid then
                statusLabel.Text = "✅ XÁC THỰC THÀNH CÔNG!"
                statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                statusIcon.Text = "✅"
                _G.AuthorizedKey = key
                
                TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                    Size = UDim2.new(0, keyMenuWidth + 20, 0, keyMenuHeight + 20),
                    Position = UDim2.new(0.5, -(keyMenuWidth + 20)/2, 0.5, -(keyMenuHeight + 20)/2)
                }):Play()
                
                task.wait(0.2)
                
                TweenService:Create(main, TweenInfo.new(0.3), {
                    Size = UDim2.new(0, 0, 0, 0),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BackgroundTransparency = 1
                }):Play()
                
                task.wait(0.3)
                gui:Destroy()
                isKeyValid = true
                StartHack()
            else
                statusLabel.Text = "❌ KEY KHÔNG HỢP LỆ!"
                statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                statusIcon.Text = "❌"
                verifyBtn.Text = "✅ XÁC THỰC"
                verifyBtn.Active = true
                getKeyBtn.Active = true
            end
        end)
    end)
    
    getKeyBtn.MouseButton1Click:Connect(function()
        statusLabel.Text = "📋 ĐÃ COPY LINK!"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        statusIcon.Text = "📋"
        if setclipboard then setclipboard(WEB_URL) end
    end)
    
    keyInput.FocusLost:Connect(function(enter)
        if enter then verifyBtn.MouseButton1Click:Fire() end
    end)
end

-- ============================================
-- START HACK
-- ============================================
function StartHack()
    print("=========================================")
    print("KHANHPC PREMIUM - ACTIVATED (FULL VERSION)")
    print("GAME: " .. GAME_NAME)
    print("KEY: " .. (_G.AuthorizedKey or "VALID"))
    print("USER: " .. player.Name)
    print("=========================================")
    
    StarterGui:SetCore("SendNotification", {
        Title = "KHANHPC PREMIUM",
        Text = "✅ Kích hoạt thành công! (FULL VERSION)\n" .. GAME_NAME .. "\n👥 Overlay danh sách đã bật!",
        Duration = 3
    })
    
    task.spawn(function()
        CreateHackMenu()
        task.wait(0.5)
        khoiTaoWallHack()
    end)
    
    task.spawn(function()
        task.wait(1.5)
        createPlayerOverlay()
        sendNotification("KHANHPC", "👥 OVERLAY DANH SÁCH LUÔN HIỂN THỊ\n⭐ Nhấn K để tắt/mở\n⭐ Hover vào tên để thấy nút teleport\n⭐ Sao vàng = đồng đội", 3, "👥")
    end)
    
    -- Thêm auto load config và nút config
    task.wait(2)
    autoLoadDefaultConfig()
    task.wait(1)
    addConfigButtonToMenu()
    
    print("HOTKEYS (CÓ THỂ THAY ĐỔI):")
    print(GetKeyName(_G.keyBinds.spin) .. " - SPIN BOT")
    print(GetKeyName(_G.keyBinds.aim) .. " - AIM BOT")
    print(GetKeyName(_G.keyBinds.fly) .. " - FLY MODE")
    print(GetKeyName(_G.keyBinds.tele) .. " - AUTO TELE")
    print(GetKeyName(_G.keyBinds.telePos) .. " - MỞ MENU VỊ TRÍ TELE")
    print(GetKeyName(_G.keyBinds.autoClick) .. " - AUTO CLICK")
    print(GetKeyName(_G.keyBinds.fixLag) .. " - FIX LAG")
    print(GetKeyName(_G.keyBinds.wallHack) .. " - WALLHACK")
    print(GetKeyName(_G.keyBinds.playerList) .. " - BẬT/TẮT OVERLAY DANH SÁCH")
    print(GetKeyName(_G.keyBinds.mode) .. " - SPIN MODE")
    print(GetKeyName(_G.keyBinds.reset) .. " - RESET AIM")
    print(GetKeyName(_G.keyBinds.menu) .. " - ẨN/HIỆN MENU")
    print("=========================================")
end

-- ============================================
-- INIT
-- ============================================
if not game:IsLoaded() then
    game.Loaded:Wait()
end

player = Players.LocalPlayer
camera = Workspace.CurrentCamera

repeat task.wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")

task.spawn(function()
    task.wait(1)
    local s, e = pcall(createKeyMenu)
    if s then
        print("KHANHPC PREMIUM - ENTER YOUR KEY!")
        print("GAME: " .. GAME_NAME)
    else
        warn("Key menu error:", e)
    end
end)
