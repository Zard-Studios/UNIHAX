local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local flying = false
local speed = 50
local flyConnection

local function startFlying()
    local character = LocalPlayer.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoidRootPart then return end

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    bodyVelocity.Parent = humanoidRootPart

    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.CFrame = humanoidRootPart.CFrame
    bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
    bodyGyro.P = 3000
    bodyGyro.Parent = humanoidRootPart

    flyConnection = UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then
            bodyVelocity.Velocity = humanoidRootPart.CFrame.LookVector * speed
        elseif input.KeyCode == Enum.KeyCode.S then
            bodyVelocity.Velocity = -humanoidRootPart.CFrame.LookVector * speed
        elseif input.KeyCode == Enum.KeyCode.A then
            bodyVelocity.Velocity = -humanoidRootPart.CFrame.RightVector * speed
        elseif input.KeyCode == Enum.KeyCode.D then
            bodyVelocity.Velocity = humanoidRootPart.CFrame.RightVector * speed
        elseif input.KeyCode == Enum.KeyCode.Space then
            bodyVelocity.Velocity = Vector3.new(0, speed, 0)
        elseif input.KeyCode == Enum.KeyCode.LeftShift then
            bodyVelocity.Velocity = Vector3.new(0, -speed, 0)
        end
    end)
    
    flying = true
end

local function stopFlying()
    local character = LocalPlayer.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoidRootPart then return end

    for _, v in pairs(humanoidRootPart:GetChildren()) do
        if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
            v:Destroy()
        end
    end

    if flyConnection then
        flyConnection:Disconnect()
    end
    
    flying = false
end

local function toggleFly()
    if flying then
        stopFlying()
    else
        startFlying()
    end
end

return {
    toggleFly = toggleFly
}
