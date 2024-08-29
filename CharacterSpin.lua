local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local spinning = false
local spinConnection

local function startSpinning()
    spinning = true
    spinConnection = RunService.RenderStepped:Connect(function(deltaTime)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
            local randomRotation = Vector3.new(
                math.random(-720, 720) * deltaTime,
                math.random(-720, 720) * deltaTime,
                math.random(-720, 720) * deltaTime
            )
            humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.Angles(
                math.rad(randomRotation.X),
                math.rad(randomRotation.Y),
                math.rad(randomRotation.Z)
            )
        end
    end)
end

local function stopSpinning()
    spinning = false
    if spinConnection then
        spinConnection:Disconnect()
        spinConnection = nil
    end
end

local function toggleSpin()
    if spinning then
        stopSpinning()
    else
        startSpinning()
    end
end

return {
    toggleSpin = toggleSpin
}