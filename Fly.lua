local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local flying = false
local speed = 50
local maxspeed = 100
local acceleration = 2
local deceleration = 1

local controls = {
    W = false,
    S = false,
    A = false,
    D = false,
    Space = false,
    LeftShift = false
}

local function updateVelocity(bodyVelocity, character)
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local moveDirection = Vector3.new(
        (controls.D and 1 or 0) - (controls.A and 1 or 0),
        (controls.Space and 1 or 0) - (controls.LeftShift and 1 or 0),
        (controls.S and 1 or 0) - (controls.W and 1 or 0)
    ).Unit

    if moveDirection.Magnitude > 0 then
        speed = math.min(speed + acceleration, maxspeed)
    else
        speed = math.max(speed - deceleration, 0)
    end

    bodyVelocity.Velocity = humanoidRootPart.CFrame:VectorToWorldSpace(moveDirection * speed)
end

local function startFlying()
    local character = LocalPlayer.Character
    if not character then return end

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
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
        updateVelocity(bodyVelocity, character)
        bodyGyro.CFrame = workspace.CurrentCamera.CFrame
    end)

    flying = true
end

local function stopFlying()
    local character = LocalPlayer.Character
    if not character then return end

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    for _, v in pairs(humanoidRootPart:GetChildren()) do
        if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
            v:Destroy()
        end
    end

    RunService:UnbindFromRenderStep("FlyUpdate")
    flying = false
    speed = 50
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        if flying then
            stopFlying()
        else
            startFlying()
        end
    elseif controls[input.KeyCode.Name] ~= nil then
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