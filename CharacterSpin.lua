local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local spinning = false
local spinConnection

local function getRandomRotationSpeed()
    return math.random() * 10 + 5  -- Velocità casuale tra 5 e 15
end

local function startSpinning()
    if spinning then return end
    spinning = true

    local character = LocalPlayer.Character
    if not character then return end

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local xSpeed, ySpeed, zSpeed = getRandomRotationSpeed(), getRandomRotationSpeed(), getRandomRotationSpeed()

    spinConnection = RunService.Heartbeat:Connect(function(dt)
        humanoidRootPart.CFrame = humanoidRootPart.CFrame * 
            CFrame.Angles(math.rad(xSpeed * dt), math.rad(ySpeed * dt), math.rad(zSpeed * dt))
    end)
end

local function stopSpinning()
    if spinConnection then
        spinConnection:Disconnect()
        spinConnection = nil
    end
    spinning = false
end

local function toggleSpin()
    if spinning then
        stopSpinning()
    else
        startSpinning()
    end
end

local function createSpinButton(parent)
    local SpinButton = Instance.new("TextButton")
    SpinButton.Name = "SpinButton"
    SpinButton.Size = UDim2.new(0, 80, 0, 30)
    SpinButton.Position = UDim2.new(0, 10, 0, 210)  -- Adjust position as needed
    SpinButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SpinButton.Text = "Spin"
    SpinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpinButton.TextSize = 14
    SpinButton.Font = Enum.Font.GothamSemibold
    SpinButton.Parent = parent

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 4)
    ButtonCorner.Parent = SpinButton

    SpinButton.MouseButton1Click:Connect(function()
        toggleSpin()
        SpinButton.Text = spinning and "Stop Spin" or "Spin"
        SpinButton.BackgroundColor3 = spinning and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(60, 60, 60)
    end)

    return SpinButton
end

return {
    createSpinButton = createSpinButton,
    stopSpinning = stopSpinning
}