-- Script thử nghiệm với VirtualInputManager
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = game:GetService("Players").LocalPlayer

local function pressThree()
    for i = 1, 5 do
        -- Gửi sự kiện nhấn phím 3 xuống
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Three, false, game)
        task.wait(0.05)
        -- Gửi sự kiện nhả phím 3
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Three, false, game)
        task.wait(0.05)
    end
    print("✅ Đã gửi sự kiện nhấn phím 3.")
end

player.CharacterAdded:Connect(function()
    task.wait(0.8)
    pressThree()
end)

if player.Character then
    task.wait(0.8)
    pressThree()
end
