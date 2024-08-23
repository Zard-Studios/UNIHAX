local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local function createGUI()
    local existingGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("ESPControl")
    if existingGui then
        existingGui:Destroy()
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ESPControl"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = MainFrame
    
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 10)
    TitleCorner.Parent = TitleBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -40, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "UNIHAX"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 22
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Parent = TitleBar
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    local function createButton(name, position)
        local Button = Instance.new("TextButton")
        Button.Name = name
        Button.Size = UDim2.new(0.9, 0, 0, 50)
        Button.Position = position
        Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        Button.Text = "Enable " .. name
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 18
        Button.Font = Enum.Font.GothamSemibold
        Button.Parent = MainFrame
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = Button
        
        local ButtonStroke = Instance.new("UIStroke")
        ButtonStroke.Color = Color3.fromRGB(100, 100, 100)
        ButtonStroke.Thickness = 2
        ButtonStroke.Parent = Button
        
        return Button
    end
    
    local ESPButton = createButton("ESP", UDim2.new(0.05, 0, 0.15, 0))
    local NoClipButton = createButton("NoClip", UDim2.new(0.05, 0, 0.3, 0))
    local TeleportButton = createButton("Teleport", UDim2.new(0.05, 0, 0.45, 0))
    local FlyButton = createButton("Fly", UDim2.new(0.05, 0, 0.6, 0))
    
    local TeleportFrame = Instance.new("Frame")
    TeleportFrame.Name = "TeleportFrame"
    TeleportFrame.Size = UDim2.new(0.9, 0, 0.4, 0)
    TeleportFrame.Position = UDim2.new(0.05, 0, 0.6, 0)
    TeleportFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TeleportFrame.BorderSizePixel = 0
    TeleportFrame.Visible = false
    TeleportFrame.Parent = MainFrame
    
    local TeleportCorner = Instance.new("UICorner")
    TeleportCorner.CornerRadius = UDim.new(0, 8)
    TeleportCorner.Parent = TeleportFrame
    
    local TeleportLabel = Instance.new("TextLabel")
    TeleportLabel.Name = "TeleportLabel"
    TeleportLabel.Size = UDim2.new(1, 0, 0, 30)
    TeleportLabel.BackgroundTransparency = 1
    TeleportLabel.Text = "Teleport to Player"
    TeleportLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeleportLabel.TextSize = 18
    TeleportLabel.Font = Enum.Font.GothamSemibold
    TeleportLabel.Parent = TeleportFrame
    
    local PlayerList = Instance.new("ScrollingFrame")
    PlayerList.Name = "PlayerList"
    PlayerList.Size = UDim2.new(1, -20, 1, -40)
    PlayerList.Position = UDim2.new(0, 10, 0, 35)
    PlayerList.BackgroundTransparency = 1
    PlayerList.BorderSizePixel = 0
    PlayerList.ScrollBarThickness = 8
    PlayerList.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 150)
    PlayerList.Parent = TeleportFrame
    
    local PlayerListLayout = Instance.new("UIListLayout")
    PlayerListLayout.Parent = PlayerList
    PlayerListLayout.SortOrder = Enum.SortOrder.Name
    PlayerListLayout.Padding = UDim.new(0, 5)
    
    local PlayerPadding = Instance.new("UIPadding")
    PlayerPadding.PaddingTop = UDim.new(0, 5)
    PlayerPadding.PaddingLeft = UDim.new(0, 5)
    PlayerPadding.PaddingRight = UDim.new(0, 5)
    PlayerPadding.Parent = PlayerList

        -- Add Flight Speed Control
        local SpeedFrame = Instance.new("Frame")
        SpeedFrame.Name = "SpeedFrame"
        SpeedFrame.Size = UDim2.new(0.9, 0, 0, 50)
        SpeedFrame.Position = UDim2.new(0.05, 0, 0.75, 0)
        SpeedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        SpeedFrame.BorderSizePixel = 0
        SpeedFrame.Parent = MainFrame
    
        local SpeedCorner = Instance.new("UICorner")
        SpeedCorner.CornerRadius = UDim.new(0, 8)
        SpeedCorner.Parent = SpeedFrame
    
        local SpeedLabel = Instance.new("TextLabel")
        SpeedLabel.Name = "SpeedLabel"
        SpeedLabel.Size = UDim2.new(0.3, 0, 1, 0)
        SpeedLabel.BackgroundTransparency = 1
        SpeedLabel.Text = "Speed:"
        SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        SpeedLabel.TextSize = 16
        SpeedLabel.Font = Enum.Font.GothamSemibold
        SpeedLabel.Parent = SpeedFrame
    
        local SpeedValue = Instance.new("TextBox")
        SpeedValue.Name = "SpeedValue"
        SpeedValue.Size = UDim2.new(0.3, 0, 0.6, 0)
        SpeedValue.Position = UDim2.new(0.35, 0, 0.2, 0)
        SpeedValue.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        SpeedValue.Text = "50"
        SpeedValue.TextColor3 = Color3.fromRGB(255, 255, 255)
        SpeedValue.TextSize = 16
        SpeedValue.Font = Enum.Font.GothamSemibold
        SpeedValue.Parent = SpeedFrame
    
        local SpeedValueCorner = Instance.new("UICorner")
        SpeedValueCorner.CornerRadius = UDim.new(0, 4)
        SpeedValueCorner.Parent = SpeedValue
    
        local SpeedSlider = Instance.new("TextButton")
        SpeedSlider.Name = "SpeedSlider"
        SpeedSlider.Size = UDim2.new(0.3, 0, 0.1, 0)
        SpeedSlider.Position = UDim2.new(0.68, 0, 0.45, 0)
        SpeedSlider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        SpeedSlider.Text = ""
        SpeedSlider.Parent = SpeedFrame
    
        local SpeedSliderCorner = Instance.new("UICorner")
        SpeedSliderCorner.CornerRadius = UDim.new(0, 4)
        SpeedSliderCorner.Parent = SpeedSlider
    
        local SpeedHandle = Instance.new("Frame")
        SpeedHandle.Name = "SpeedHandle"
        SpeedHandle.Size = UDim2.new(0.1, 0, 1.8, 0)
        SpeedHandle.Position = UDim2.new(0.5, -5, -0.4, 0)
        SpeedHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SpeedHandle.Parent = SpeedSlider
    
        local SpeedHandleCorner = Instance.new("UICorner")
        SpeedHandleCorner.CornerRadius = UDim.new(0, 4)
        SpeedHandleCorner.Parent = SpeedHandle
    
        -- Speed slider functionality
        local isDragging = false
        local minSpeed = 1
        local maxSpeed = 100
    
    -- Speed slider functionality
    local isDragging = false
    local minSpeed = 1

    local function updateSpeedValue(value)
        speed = math.floor(value)
        SpeedValue.Text = tostring(speed)
        updateFlightSpeed(speed)
    end

    SpeedSlider.MouseButton1Down:Connect(function()
        isDragging = true
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
            local sliderPosition = SpeedSlider.AbsolutePosition
            local sliderSize = SpeedSlider.AbsoluteSize
            local relativeX = math.clamp((input.Position.X - sliderPosition.X) / sliderSize.X, 0, 1)
            SpeedHandle.Position = UDim2.new(relativeX, -5, -0.4, 0)
            local newSpeed = minSpeed + (maxSpeed - minSpeed) * relativeX
            updateSpeedValue(newSpeed)
        end
    end)

    SpeedValue.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local newSpeed = tonumber(SpeedValue.Text)
            if newSpeed and newSpeed >= minSpeed and newSpeed <= maxSpeed then
                local relativeX = (newSpeed - minSpeed) / (maxSpeed - minSpeed)
                SpeedHandle.Position = UDim2.new(relativeX, -5, -0.4, 0)
                updateSpeedValue(newSpeed)
            else
                SpeedValue.Text = tostring(speed)
            end
        end
    end)

    FlyButton.MouseButton1Click:Connect(function()
        toggleFly()
        FlyButton.Text = flying and "Disable Fly" or "Enable Fly"
    end)
    
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.RightAlt then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)
    
    ScreenGui.Enabled = true
end

createGUI()

return {
    toggleFly = toggleFly,
    updateFlightSpeed = updateFlightSpeed
}