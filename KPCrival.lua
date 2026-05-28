-- ESP + SKELETON + AIMBOT + SET VALUE + KEY SYSTEM + DEVICE SPOOFER
-- ULTRA MODERN MENU WITH EFFECTS - FULL ROUNDED CORNERS
-- FIXED: ESP không bị dính, Aimbot hoạt động ổn định
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInput = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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

-- DANH SÁCH KEY HỢP LỆ (RÚT GỌN - BẠN CÓ THỂ THÊM KEY KHÁC)
local validKeysList = {
    "ABCD1-EFGH2-IJKL3-MNOP4", "QRST5-UVWX6-YZAB7-CDEF8", "GHIJ9-KLMN0-OPQR1-STUV2",
    "WXYZ3-ABCD4-EFGH5-IJKL6", "MNOP7-QRST8-UVWX9-YZAB0", "KHANH-PC01-AAAAA-11111",
    "KHANH-PC02-BBBBB-22222", "KHANH-PC03-CCCCC-33333", "KHANH-PC04-DDDDD-44444",
    "KHANH-PC05-EEEEE-55555", "VIPPRO-9999-XXXXX-77777", "PREMIUM-8888-YYYYY-88888",
    "ULTIMA-7777-ZZZZZ-99999", "HACKER-6666-WWWWW-00000", "MASTER-5555-VVVVV-11111",
    "LEGEND-4444-UUUUU-22222", "ELITE-3333-TTTTT-33333", "PRO-2222-SSSSS-44444",
    "GOD-1111-RRRRR-55555", "KING-0000-QQQQQ-66666", "KHANH-PC06-FFFFF-66666",
    "KHANH-PC07-GGGGG-77777", "KHANH-PC08-HHHHH-88888", "KHANH-PC09-IIIII-99999",
    "KHANH-PC10-JJJJJ-00000", "KHANH-PC11-KKKKK-11111", "KHANH-PC12-LLLLL-22222",
    "KHANH-PC13-MMMMM-33333", "KHANH-PC14-NNNNN-44444", "KHANH-PC15-OOOOO-55555",
    "KHANH-PC16-PPPPP-66666", "KHANH-PC17-QQQQQ-77777", "KHANH-PC18-RRRRR-88888",
    "KHANH-PC19-SSSSS-99999", "KHANH-PC20-TTTTT-00000", "KHANH-PC21-UUUUU-11111",
    "KHANH-PC22-VVVVV-22222", "KHANH-PC23-WWWWW-33333", "KHANH-PC24-XXXXX-44444",
    "KHANH-PC25-YYYYY-55555", "KHANH-PC26-ZZZZZ-66666", "KHANH-PC27-AAAAA-77777",
    "KHANH-PC28-BBBBB-88888", "KHANH-PC29-CCCCC-99999", "KHANH-PC30-DDDDD-00000",
    "KHANH-PC31-EEEEE-11111", "KHANH-PC32-FFFFF-22222", "KHANH-PC33-GGGGG-33333",
    "KHANH-PC34-HHHHH-44444", "KHANH-PC35-IIIII-55555", "KHANH-PC36-JJJJJ-66666",
    "KHANH-PC37-KKKKK-77777", "KHANH-PC38-LLLLL-88888", "KHANH-PC39-MMMMM-99999",
    "KHANH-PC40-NNNNN-00000", "KHANH-PC41-OOOOO-11111", "KHANH-PC42-PPPPP-22222",
    "KHANH-PC43-QQQQQ-33333", "KHANH-PC44-RRRRR-44444", "KHANH-PC45-SSSSS-55555",
    "KHANH-PC46-TTTTT-66666", "KHANH-PC47-UUUUU-77777", "KHANH-PC48-VVVVV-88888",
    "KHANH-PC49-WWWWW-99999", "KHANH-PC50-XXXXX-00000", "VIPPRO-0001-AAAAA-11111",
    "VIPPRO-0002-BBBBB-22222", "VIPPRO-0003-CCCCC-33333", "VIPPRO-0004-DDDDD-44444",
    "VIPPRO-0005-EEEEE-55555", "VIPPRO-0006-FFFFF-66666", "VIPPRO-0007-GGGGG-77777",
    "VIPPRO-0008-HHHHH-88888", "VIPPRO-0009-IIIII-99999", "VIPPRO-0010-JJJJJ-00000",
    "VIPPRO-0011-KKKKK-11111", "VIPPRO-0012-LLLLL-22222", "VIPPRO-0013-MMMMM-33333",
    "VIPPRO-0014-NNNNN-44444", "VIPPRO-0015-OOOOO-55555", "VIPPRO-0016-PPPPP-66666",
    "VIPPRO-0017-QQQQQ-77777", "VIPPRO-0018-RRRRR-88888", "VIPPRO-0019-SSSSS-99999",
    "VIPPRO-0020-TTTTT-00000", "VIPPRO-0021-UUUUU-11111", "VIPPRO-0022-VVVVV-22222",
    "VIPPRO-0023-WWWWW-33333", "VIPPRO-0024-XXXXX-44444", "VIPPRO-0025-YYYYY-55555",
    "VIPPRO-0026-ZZZZZ-66666", "VIPPRO-0027-AAAAA-77777", "VIPPRO-0028-BBBBB-88888",
    "VIPPRO-0029-CCCCC-99999", "VIPPRO-0030-DDDDD-00000", "VIPPRO-0031-EEEEE-11111",
    "VIPPRO-0032-FFFFF-22222", "VIPPRO-0033-GGGGG-33333", "VIPPRO-0034-HHHHH-44444",
    "VIPPRO-0035-IIIII-55555", "VIPPRO-0036-JJJJJ-66666", "VIPPRO-0037-KKKKK-77777",
    "VIPPRO-0038-LLLLL-88888", "VIPPRO-0039-MMMMM-99999", "VIPPRO-0040-NNNNN-00000",
    "VIPPRO-0041-OOOOO-11111", "VIPPRO-0042-PPPPP-22222", "VIPPRO-0043-QQQQQ-33333",
    "VIPPRO-0044-RRRRR-44444", "VIPPRO-0045-SSSSS-55555", "VIPPRO-0046-TTTTT-66666",
    "VIPPRO-0047-UUUUU-77777", "VIPPRO-0048-VVVVV-88888", "VIPPRO-0049-WWWWW-99999",
    "VIPPRO-0050-XXXXX-00000", "PREMIUM-001-AAAAAA-111111", "PREMIUM-002-BBBBBB-222222",
    "PREMIUM-003-CCCCCC-333333", "PREMIUM-004-DDDDDD-444444", "PREMIUM-005-EEEEEE-555555",
    "PREMIUM-006-FFFFFF-666666", "PREMIUM-007-GGGGGG-777777", "PREMIUM-008-HHHHHH-888888",
    "PREMIUM-009-IIIIII-999999", "PREMIUM-010-JJJJJJ-000000", "PREMIUM-011-KKKKKK-111111",
    "PREMIUM-012-LLLLLL-222222", "PREMIUM-013-MMMMMM-333333", "PREMIUM-014-NNNNNN-444444",
    "PREMIUM-015-OOOOOO-555555", "PREMIUM-016-PPPPPP-666666", "PREMIUM-017-QQQQQQ-777777",
    "PREMIUM-018-RRRRRR-888888", "PREMIUM-019-SSSSSS-999999", "PREMIUM-020-TTTTTT-000000",
    "PREMIUM-021-UUUUUU-111111", "PREMIUM-022-VVVVVV-222222", "PREMIUM-023-WWWWWW-333333",
    "PREMIUM-024-XXXXXX-444444", "PREMIUM-025-YYYYYY-555555", "PREMIUM-026-ZZZZZZ-666666",
    "PREMIUM-027-AAAAAA-777777", "PREMIUM-028-BBBBBB-888888", "PREMIUM-029-CCCCCC-999999",
    "PREMIUM-030-DDDDDD-000000", "PREMIUM-031-EEEEEE-111111", "PREMIUM-032-FFFFFF-222222",
    "PREMIUM-033-GGGGGG-333333", "PREMIUM-034-HHHHHH-444444", "PREMIUM-035-IIIIII-555555",
    "PREMIUM-036-JJJJJJ-666666", "PREMIUM-037-KKKKKK-777777", "PREMIUM-038-LLLLLL-888888",
    "PREMIUM-039-MMMMMM-999999", "PREMIUM-040-NNNNNN-000000", "ULTIMA-001-AAAAAA-111111",
    "ULTIMA-002-BBBBBB-222222", "ULTIMA-003-CCCCCC-333333", "ULTIMA-004-DDDDDD-444444",
    "ULTIMA-005-EEEEEE-555555", "ULTIMA-006-FFFFFF-666666", "ULTIMA-007-GGGGGG-777777",
    "ULTIMA-008-HHHHHH-888888", "ULTIMA-009-IIIIII-999999", "ULTIMA-010-JJJJJJ-000000",
    "ULTIMA-011-KKKKKK-111111", "ULTIMA-012-LLLLLL-222222", "ULTIMA-013-MMMMMM-333333",
    "ULTIMA-014-NNNNNN-444444", "ULTIMA-015-OOOOOO-555555", "ULTIMA-016-PPPPPP-666666",
    "ULTIMA-017-QQQQQQ-777777", "ULTIMA-018-RRRRRR-888888", "ULTIMA-019-SSSSSS-999999",
    "ULTIMA-020-TTTTTT-000000", "HACKER-001-AAAAAA-111111", "HACKER-002-BBBBBB-222222",
    "HACKER-003-CCCCCC-333333", "HACKER-004-DDDDDD-444444", "HACKER-005-EEEEEE-555555",
    "HACKER-006-FFFFFF-666666", "HACKER-007-GGGGGG-777777", "HACKER-008-HHHHHH-888888",
    "HACKER-009-IIIIII-999999", "HACKER-010-JJJJJJ-000000", "MASTER-001-AAAAAA-111111",
    "MASTER-002-BBBBBB-222222", "MASTER-003-CCCCCC-333333", "MASTER-004-DDDDDD-444444",
    "MASTER-005-EEEEEE-555555", "MASTER-006-FFFFFF-666666", "MASTER-007-GGGGGG-777777",
    "MASTER-008-HHHHHH-888888", "MASTER-009-IIIIII-999999", "MASTER-010-JJJJJJ-000000",
    "LEGEND-001-AAAAAA-111111", "LEGEND-002-BBBBBB-222222", "LEGEND-003-CCCCCC-333333",
    "LEGEND-004-DDDDDD-444444", "LEGEND-005-EEEEEE-555555", "LEGEND-006-FFFFFF-666666",
    "LEGEND-007-GGGGGG-777777", "LEGEND-008-HHHHHH-888888", "LEGEND-009-IIIIII-999999",
    "LEGEND-010-JJJJJJ-000000", "ELITE-001-AAAAA-11111", "ELITE-002-BBBBB-22222",
    "ELITE-003-CCCCC-33333", "ELITE-004-DDDDD-44444", "ELITE-005-EEEEE-55555",
    "ELITE-006-FFFFF-66666", "ELITE-007-GGGGG-77777", "ELITE-008-HHHHH-88888",
    "ELITE-009-IIIII-99999", "ELITE-010-JJJJJ-00000", "PRO-0001-AAAAA-11111",
    "PRO-0002-BBBBB-22222", "PRO-0003-CCCCC-33333", "PRO-0004-DDDDD-44444",
    "PRO-0005-EEEEE-55555", "PRO-0006-FFFFF-66666", "PRO-0007-GGGGG-77777",
    "PRO-0008-HHHHH-88888", "PRO-0009-IIIII-99999", "PRO-0010-JJJJJ-00000",
    "GOD-001-AAAAA-11111", "GOD-002-BBBBB-22222", "GOD-003-CCCCC-33333",
    "GOD-004-DDDDD-44444", "GOD-005-EEEEE-55555", "GOD-006-FFFFF-66666",
    "GOD-007-GGGGG-77777", "GOD-008-HHHHH-88888", "GOD-009-IIIII-99999",
    "GOD-010-JJJJJ-00000", "KING-001-AAAAA-11111", "KING-002-BBBBB-22222",
    "KING-003-CCCCC-33333", "KING-004-DDDDD-44444", "KING-005-EEEEE-55555",
    "KING-006-FFFFF-66666", "KING-007-GGGGG-77777", "KING-008-HHHHH-88888",
    "KING-009-IIIII-99999", "KING-010-JJJJJ-00000", "RANDOM-A1B2-C3D4-E5F6-G7H8",
    "RANDOM-I9J0-K1L2-M3N4-O5P6", "RANDOM-Q7R8-S9T0-U1V2-W3X4", "RANDOM-Y5Z6-A7B8-C9D0-E1F2",
    "RANDOM-G3H4-I5J6-K7L8-M9N0", "RANDOM-O1P2-Q3R4-S5T6-U7V8", "RANDOM-W9X0-Y1Z2-A3B4-C5D6",
    "RANDOM-E7F8-G9H0-I1J2-K3L4", "RANDOM-M5N6-O7P8-Q9R0-S1T2", "RANDOM-U3V4-W5X6-Y7Z8-A9B0",
    "SECRET-001-XXXXX-11111", "SECRET-002-YYYYY-22222", "SECRET-003-ZZZZZ-33333",
    "SECRET-004-AAAAA-44444", "SECRET-005-BBBBB-55555", "SECRET-006-CCCCC-66666",
    "SECRET-007-DDDDD-77777", "SECRET-008-EEEEE-88888", "SECRET-009-FFFFF-99999",
    "SECRET-010-GGGGG-00000", "GOLD-001-HHHHH-11111", "GOLD-002-IIIII-22222",
    "GOLD-003-JJJJJ-33333", "GOLD-004-KKKKK-44444", "GOLD-005-LLLLL-55555",
    "GOLD-006-MMMMM-66666", "GOLD-007-NNNNN-77777", "GOLD-008-OOOOO-88888",
    "GOLD-009-PPPPP-99999", "GOLD-010-QQQQQ-00000", "SILVER-001-RRRRR-11111",
    "SILVER-002-SSSSS-22222", "SILVER-003-TTTTT-33333", "SILVER-004-UUUUU-44444",
    "SILVER-005-VVVVV-55555", "SILVER-006-WWWWW-66666", "SILVER-007-XXXXX-77777",
    "SILVER-008-YYYYY-88888", "SILVER-009-ZZZZZ-99999", "SILVER-010-AAAAA-00000",
    "DIAMOND-01-BBBBB-11111", "DIAMOND-02-CCCCC-22222", "DIAMOND-03-DDDDD-33333",
    "DIAMOND-04-EEEEE-44444", "DIAMOND-05-FFFFF-55555", "DIAMOND-06-GGGGG-66666",
    "DIAMOND-07-HHHHH-77777", "DIAMOND-08-IIIII-88888", "DIAMOND-09-JJJJJ-99999",
    "DIAMOND-10-KKKKK-00000", "PLATINUM-01-LLLLL-11111", "PLATINUM-02-MMMMM-22222",
    "PLATINUM-03-NNNNN-33333", "PLATINUM-04-OOOOO-44444", "PLATINUM-05-PPPPP-55555",
    "PLATINUM-06-QQQQQ-66666", "PLATINUM-07-RRRRR-77777", "PLATINUM-08-SSSSS-88888",
    "PLATINUM-09-TTTTT-99999", "PLATINUM-10-UUUUU-00000", "TITANIUM-01-VVVVV-11111",
    "TITANIUM-02-WWWWW-22222", "TITANIUM-03-XXXXX-33333", "TITANIUM-04-YYYYY-44444",
    "TITANIUM-05-ZZZZZ-55555", "TITANIUM-06-AAAAA-66666", "TITANIUM-07-BBBBB-77777",
    "TITANIUM-08-CCCCC-88888", "TITANIUM-09-DDDDD-99999", "TITANIUM-10-EEEEE-00000",
    "KHANH-SP01-AAAAA-99999", "KHANH-SP02-BBBBB-88888", "KHANH-SP03-CCCCC-77777",
    "KHANH-SP04-DDDDD-66666", "KHANH-SP05-EEEEE-55555", "KHANH-SP06-FFFFF-44444",
    "KHANH-SP07-GGGGG-33333", "KHANH-SP08-HHHHH-22222", "KHANH-SP09-IIIII-11111",
    "KHANH-SP10-JJJJJ-00000", "VIPPRO-1000-XXXXX-12345", "VIPPRO-2000-YYYYY-23456",
    "VIPPRO-3000-ZZZZZ-34567", "VIPPRO-4000-AAAAA-45678", "VIPPRO-5000-BBBBB-56789",
    "VIPPRO-6000-CCCCC-67890", "VIPPRO-7000-DDDDD-78901", "VIPPRO-8000-EEEEE-89012",
    "VIPPRO-9000-FFFFF-90123", "VIPPRO-9999-GGGGG-01234", "PREMIUM-100-HHHHH-123456",
    "PREMIUM-200-IIIII-234567", "PREMIUM-300-JJJJJ-345678", "PREMIUM-400-KKKKK-456789",
    "PREMIUM-500-LLLLL-567890", "PREMIUM-600-MMMMM-678901", "PREMIUM-700-NNNNN-789012",
    "PREMIUM-800-OOOOO-890123", "PREMIUM-900-PPPPP-901234", "PREMIUM-999-QQQQQ-012345",
    "ULTIMA-100-RRRRR-123456", "ULTIMA-200-SSSSS-234567", "ULTIMA-300-TTTTT-345678",
    "ULTIMA-400-UUUUU-456789", "ULTIMA-500-VVVVV-567890", "ULTIMA-600-WWWWW-678901",
    "ULTIMA-700-XXXXX-789012", "ULTIMA-800-YYYYY-890123", "ULTIMA-900-ZZZZZ-901234",
    "ULTIMA-999-AAAAA-012345", "MASTER-100-BBBBB-123456", "MASTER-200-CCCCC-234567",
    "MASTER-300-DDDDD-345678", "MASTER-400-EEEEE-456789", "MASTER-500-FFFFF-567890",
    "MASTER-600-GGGGG-678901", "MASTER-700-HHHHH-789012", "MASTER-800-IIIII-890123",
    "MASTER-900-JJJJJ-901234", "MASTER-999-KKKKK-012345", "LEGEND-100-LLLLL-123456",
    "LEGEND-200-MMMMM-234567", "LEGEND-300-NNNNN-345678", "LEGEND-400-OOOOO-456789",
    "LEGEND-500-PPPPP-567890", "LEGEND-600-QQQQQ-678901", "LEGEND-700-RRRRR-789012",
    "LEGEND-800-SSSSS-890123", "LEGEND-900-TTTTT-901234", "LEGEND-999-UUUUU-012345",
    "ELITE-100-VVVVV-12345", "ELITE-200-WWWWW-23456", "ELITE-300-XXXXX-34567",
    "ELITE-400-YYYYY-45678", "ELITE-500-ZZZZZ-56789", "ELITE-600-AAAAA-67890",
    "ELITE-700-BBBBB-78901", "ELITE-800-CCCCC-89012", "ELITE-900-DDDDD-90123",
    "ELITE-999-EEEEE-01234", "PRO-0100-FFFFF-12345", "PRO-0200-GGGGG-23456",
    "PRO-0300-HHHHH-34567", "PRO-0400-IIIII-45678", "PRO-0500-JJJJJ-56789",
    "PRO-0600-KKKKK-67890", "PRO-0700-LLLLL-78901", "PRO-0800-MMMMM-89012",
    "PRO-0900-NNNNN-90123", "PRO-0999-OOOOO-01234", "GOD-100-PPPPP-12345",
    "GOD-200-QQQQQ-23456", "GOD-300-RRRRR-34567", "GOD-400-SSSSS-45678",
    "GOD-500-TTTTT-56789", "GOD-600-UUUUU-67890", "GOD-700-VVVVV-78901",
    "GOD-800-WWWWW-89012", "GOD-900-XXXXX-90123", "GOD-999-YYYYY-01234",
    "KING-100-ZZZZZ-12345", "KING-200-AAAAA-23456", "KING-300-BBBBB-34567",
    "KING-400-CCCCC-45678", "KING-500-DDDDD-56789", "KING-600-EEEEE-67890",
    "KING-700-FFFFF-78901", "KING-800-GGGGG-89012", "KING-900-HHHHH-90123",
    "KING-999-IIIII-01234"
}
local validKeys = {}
for _, key in ipairs(validKeysList) do
    validKeys[string.upper(key)] = true
end

-- Key storage
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

-- Hàm copy link
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
        npcColor = Color3.fromRGB(255, 200, 50)
    },
    aimbot = {
        enabled = true,
        fovRadius = 200,
        smoothness = 2,
        maxDistance = 150,
        lockTarget = true,
        showFOV = true,
        fovColor = Color3.fromRGB(0, 200, 255),
        aimPart = "Head",
        aimMode = "Both",
        autoShot = true
    },
    teleport = {
        enabled = true
    }
}

-- FIX: Dọn dẹp drawing cũ trước khi tạo mới
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
end)

-- Xóa menu cũ
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

local function updateFOVPos()
    aimbotFOV.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end
updateFOVPos()
Camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateFOVPos)

RunService.RenderStepped:Connect(function()
    aimbotFOV.Radius = settings.aimbot.fovRadius
    aimbotFOV.Color = settings.aimbot.fovColor
    aimbotFOV.Visible = settings.aimbot.showFOV
    aimbotFOV.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end)

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

-- AUTO SHOT
local function shoot()
    if mouse1click then mouse1click()
    else
        VirtualInput:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, Enum.UserInputState.Begin, nil, false)
        task.wait(0.01)
        VirtualInput:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, Enum.UserInputState.End, nil, false)
    end
end

-- AIMBOT - FIX: Thêm nhiều cách di chuyển chuột
local isAiming = false
local lockedTarget = nil

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
    if delta.Magnitude < 0.5 then return true end
    local moveX = delta.X / settings.aimbot.smoothness
    local moveY = delta.Y / settings.aimbot.smoothness
    moveX = math.clamp(moveX, -30, 30)
    moveY = math.clamp(moveY, -30, 30)
    if mousemoverel then
        mousemoverel(moveX, moveY)
        return delta.Magnitude < 15
    elseif syn and syn.mouse_move then
        syn.mouse_move(moveX, moveY)
        return delta.Magnitude < 15
    else
        local mouse = LocalPlayer:GetMouse()
        local newX = mouse.X + moveX
        local newY = mouse.Y + moveY
        VirtualInput:SendMouseMoveEvent(newX, newY)
        return delta.Magnitude < 15
    end
    return false
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 and settings.aimbot.enabled then isAiming = true end
end)

UserInputService.InputEnded:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then isAiming = false; lockedTarget = nil end
end)

RunService.RenderStepped:Connect(function()
    if not (settings.aimbot.enabled and isAiming) then return end
    local targetData = nil
    if settings.aimbot.lockTarget and lockedTarget then targetData = lockedTarget
    else targetData = getBestTarget(); if settings.aimbot.lockTarget then lockedTarget = targetData end end
    if targetData and targetData.part then
        local isOnTarget = moveToTarget(targetData)
        if settings.aimbot.autoShot and isOnTarget then
            if canSeeTarget(targetData.part) then shoot() end
        end
    end
end)

-- ESP + SKELETON
local espBoxes = {}
local espSkeletons = {}

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

-- FIX: Xóa sạch drawing khi remove
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

-- FIX: Cleanup khi tắt ESP
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

RunService.RenderStepped:Connect(function()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local myPos = myRoot and myRoot.Position or nil
    
    -- FIX: Nếu ESP tắt thì ẩn hết
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

-- MENU CHÍNH (RÚT GỌN NHƯNG ĐẦY ĐỦ CHỨC NĂNG)
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
menu.Size = UDim2.new(0, 520, 0, 620)
menu.Position = UDim2.new(0.5, -260, 0.5, -310)
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
subTitle.Text = "ESP • SKELETON • AIMBOT • VALUE • DEVICE • TELEPORT"
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
local tabNames = {"🎯 AIM", "🎨 ESP", "🦴 BONE", "⚡ VALUE", "🎮 DEVICE", "🌀 TP"}
local tabWidth = 520 / #tabNames

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, tabWidth, 1, 0)
    btn.Position = UDim2.new(0, (i-1) * tabWidth, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(160, 160, 200)
    btn.TextSize = 12
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
aimbotPanel.CanvasSize = UDim2.new(0, 0, 0, 650)
aimbotPanel.ScrollBarThickness = 4
aimbotPanel.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 200)
aimbotPanel.Parent = contentArea

local espPanel = Instance.new("ScrollingFrame")
espPanel.Size = UDim2.new(1, 0, 1, 0)
espPanel.BackgroundTransparency = 1
espPanel.BorderSizePixel = 0
espPanel.CanvasSize = UDim2.new(0, 0, 0, 550)
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
devicePanel.CanvasSize = UDim2.new(0, 0, 0, 300)
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

-- Build UI
local y = 10
createModernToggle(aimbotPanel, y, "⚡ ENABLE AIMBOT", function() return settings.aimbot.enabled end, function(v) settings.aimbot.enabled = v end)
y = y + 60

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

y = 10
createModernToggle(skeletonPanel, y, "🦴 ENABLE SKELETON", function() return settings.esp.skeleton end, function(v) settings.esp.skeleton = v end)

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

-- Device Panel
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

-- TP Panel
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

-- Tab switching
local function switchTab(tabIndex, panel, btn)
    TweenService:Create(contentArea, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    task.wait(0.1)
    aimbotPanel.Visible = false
    espPanel.Visible = false
    skeletonPanel.Visible = false
    setValuePanel.Visible = false
    devicePanel.Visible = false
    tpPanel.Visible = false
    panel.Visible = true
    if tabIndex == 4 then refreshWinStreakDisplay() end
    for i, b in ipairs(tabs) do
        TweenService:Create(b, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(160, 160, 200), Font = Enum.Font.GothamSemibold}):Play()
    end
    TweenService:Create(btn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold}):Play()
    TweenService:Create(indicator, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, (tabIndex-1) * tabWidth, 1, -3)}):Play()
    TweenService:Create(contentArea, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
end

for i, btn in ipairs(tabs) do
    local panels = {aimbotPanel, espPanel, skeletonPanel, setValuePanel, devicePanel, tpPanel}
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
        Size = UDim2.new(0, 520, 0, 620),
        Position = UDim2.new(0.5, -260, 0.5, -310)
    }):Play()
    TweenService:Create(blur, TweenInfo.new(0.3), {Size = 12}):Play()
end

local function closeMenu()
    -- FIX: Tắt ESP khi đóng menu để tránh bị dính
    cleanupAllESP()
    
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
        if menuVisible then
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
successNotif.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - 50)
successNotif.Visible = true

local subNotif = Drawing.new("Text")
subNotif.Text = "Key: " .. currentKey
subNotif.Size = 12
subNotif.Color = Color3.fromRGB(0, 200, 255)
subNotif.Center = true
subNotif.Outline = true
subNotif.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - 30)
subNotif.Visible = true

local deviceNotif = Drawing.new("Text")
deviceNotif.Text = "🎮 Device Spoofer Ready!"
deviceNotif.Size = 12
deviceNotif.Color = Color3.fromRGB(200, 200, 100)
deviceNotif.Center = true
deviceNotif.Outline = true
deviceNotif.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - 10)
deviceNotif.Visible = true

task.wait(2.5)
successNotif.Visible = false
subNotif.Visible = false
deviceNotif.Visible = false
successNotif:Remove()
subNotif:Remove()
deviceNotif:Remove()

print("========================================")
print("     ✦ KHANHGD CHEAT v3.0 ✦")
print("========================================")
print("  VERIFIED KEY: " .. currentKey)
print("  PLAYER: " .. playerName)
print("========================================")
print("  RIGHT SHIFT = MENU")
print("  HOLD RIGHT CLICK = AIMBOT")
print("  X = TELEPORT")
print("========================================")
print("  🎮 DEVICE SPOOFER READY")
print("========================================")
end

-- Nếu key đã được xác thực từ đầu, chạy menu luôn
if isKeyValidated then
    loadMainMenu()
end
