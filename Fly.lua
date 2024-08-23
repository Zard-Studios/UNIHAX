local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local flying = false
local speed = 50
local maxspeed = 100

local controls = {
    W = false,
    S = false,
    A = false,
    D = false,
    Space = false,
    E = false,
    Q = false
}

local function getHumanoidRootPart()
    local character = LocalPlayer.Character
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function updateVelocity(bodyVelocity)
    local humanoidRootPart = getHumanoidRootPart()
    if not humanoidRootPart then return end

    local moveDirection = Vector3.new(
        (controls.D and 1 or 0) - (controls.A and 1 or 0),
        (controls.E and 1 or 0) - (controls.Q and 1 or 0),
        (controls.S and 1 or 0) - (controls.W and 1 or 0)
    )

    if moveDirection.Magnitude > 0 then
        moveDirection = moveDirection.Unit
    end

    local lookVector = workspace.CurrentCamera.CFrame.LookVector
    local rightVector = workspace.CurrentCamera.CFrame.RightVector
    
    local finalVelocity = (lookVector * -moveDirection.Z + rightVector * moveDirection.X + Vector3.new(0, moveDirection.Y, 0)) * speed
    bodyVelocity.Velocity = finalVelocity
end

local function startFlying()
    local humanoidRootPart = getHumanoidRootPart()
    if not humanoidRootPart then return end

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Parent = humanoidRootPart

    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.CFrame = humanoidRootPart.CFrame
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.P = 10000
    bodyGyro.Parent = humanoidRootPart

    RunService:BindToRenderStep("FlyUpdate", Enum.RenderPriority.Character.Value, function()
        updateVelocity(bodyVelocity)
        bodyGyro.CFrame = workspace.CurrentCamera.CFrame
    end)

    flying = true
end

local function stopFlying()
    local humanoidRootPart = getHumanoidRootPart()
    if not humanoidRootPart then return end

    for _, v in pairs(humanoidRootPart:GetChildren()) do
        if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
            v:Destroy()
        end
    end

    RunService:UnbindFromRenderStep("FlyUpdate")
    flying = false
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if controls[input.KeyCode.Name] ~= nil then
        controls[input.KeyCode.Name] = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if controls[input.KeyCode.Name] ~= nil then
        controls[input.KeyCode.Name] = false
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    if flying then
        stopFlying()
    end
end)

-- Funzione da chiamare dal pulsante UI
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