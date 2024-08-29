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
            
            -- Rotazione estremamente veloce su tutte le assi
            local rotationSpeed = 360 -- Velocità estremamente elevata
            local xRotation = math.rad(rotationSpeed * deltaTime * 360)
            local yRotation = math.rad(rotationSpeed * deltaTime * 360)
            local zRotation = math.rad(rotationSpeed * deltaTime * 360)
            
            humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.Angles(xRotation, yRotation, zRotation)
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