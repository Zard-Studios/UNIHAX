local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Variabili di volo
local flying = false
local speed = 50
local maxSpeed = 100
local acceleration = 2
local deceleration = 4
local currentVelocity = Vector3.new(0, 0, 0)

local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHumanoidRootPart()
    local character = getCharacter()
    return character:WaitForChild("HumanoidRootPart")
end

local function updateFlightSpeed(value)
    speed = value
end

local function startFlying()
    local humanoidRootPart = getHumanoidRootPart()
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Parent = humanoidRootPart
    
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.CFrame = humanoidRootPart.CFrame
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.P = 10000
    bodyGyro.Parent = humanoidRootPart
    
    flying = true
    
    RunService:BindToRenderStep("Flying", Enum.RenderPriority.Character.Value, function()
        local moveDirection = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + humanoidRootPart.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - humanoidRootPart.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - humanoidRootPart.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + humanoidRootPart.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit
            currentVelocity = currentVelocity + moveDirection * acceleration
        else
            currentVelocity = currentVelocity:Lerp(Vector3.new(0, 0, 0), deceleration * RunService.RenderStepped:Wait())
        end
        
        if currentVelocity.Magnitude > maxSpeed then
            currentVelocity = currentVelocity.Unit * maxSpeed
        end
        
        bodyVelocity.Velocity = currentVelocity * speed
        bodyGyro.CFrame = CFrame.lookAt(humanoidRootPart.Position, humanoidRootPart.Position + humanoidRootPart.CFrame.LookVector)
    end)
end

local function stopFlying()
    local humanoidRootPart = getHumanoidRootPart()
    
    for _, v in pairs(humanoidRootPart:GetChildren()) do
        if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
            v:Destroy()
        end
    end
    
    RunService:UnbindFromRenderStep("Flying")
    flying = false
    currentVelocity = Vector3.new(0, 0, 0)
end

local function toggleFly()
    if flying then
        stopFlying()
    else
        startFlying()
    end
end