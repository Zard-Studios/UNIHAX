local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

local scriptButtons = {}

local function loadExternalScript(url)
    local success, result = pcall(function()
        return HttpService:GetAsync(url)
    end)

    if success then
        local fn, err = loadstring(result)
        if fn then
            return fn()
        else
            warn("Failed to load script:", err)
        end
    else
        warn("Failed to fetch script:", result)
    end
end

local function createGUI()
    local existingGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("ModularESPControl")
    if existingGui then
        existingGui:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModularESPControl"
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
    TitleLabel.Text = "Modular Game Controls"
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

    local ButtonContainer = Instance.new("ScrollingFrame")
    ButtonContainer.Name = "ButtonContainer"
    ButtonContainer.Size = UDim2.new(1, -20, 1, -50)
    ButtonContainer.Position = UDim2.new(0, 10, 0, 45)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.BorderSizePixel = 0
    ButtonContainer.ScrollBarThickness = 6
    ButtonContainer.Parent = MainFrame

    local ButtonLayout = Instance.new("UIListLayout")
    ButtonLayout.Parent = ButtonContainer
    ButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ButtonLayout.Padding = UDim.new(0, 10)

    local function createButton(name, callback)
        local Button = Instance.new("TextButton")
        Button.Name = name
        Button.Size = UDim2.new(1, -10, 0, 50)
        Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        Button.Text = name
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 18
        Button.Font = Enum.Font.GothamSemibold
        Button.Parent = ButtonContainer

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = Button

        local ButtonStroke = Instance.new("UIStroke")
        ButtonStroke.Color = Color3.fromRGB(100, 100, 100)
        ButtonStroke.Thickness = 2
        ButtonStroke.Parent = Button

        Button.MouseButton1Click:Connect(callback)

        table.insert(scriptButtons, Button)
        ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, ButtonLayout.AbsoluteContentSize.Y)
        
        return Button
    end

    local function addExternalScript(url)
        local scriptContent = loadExternalScript(url)
        if scriptContent and type(scriptContent) == "table" then
            for name, callback in pairs(scriptContent) do
                createButton(name, callback)
            end
        end
    end

    local AddScriptButton = Instance.new("TextButton")
    AddScriptButton.Name = "AddScriptButton"
    AddScriptButton.Size = UDim2.new(1, -20, 0, 40)
    AddScriptButton.Position = UDim2.new(0, 10, 1, -45)
    AddScriptButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    AddScriptButton.Text = "Add External Script"
    AddScriptButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    AddScriptButton.TextSize = 16
    AddScriptButton.Font = Enum.Font.GothamSemibold
    AddScriptButton.Parent = MainFrame

    local AddScriptCorner = Instance.new("UICorner")
    AddScriptCorner.CornerRadius = UDim.new(0, 8)
    AddScriptCorner.Parent = AddScriptButton

    AddScriptButton.MouseButton1Click:Connect(function()
        local url = game:GetService("CoreGui").RobloxPromptGui.promptOverlay:Clone().Dialog.TextBox.Text
        addExternalScript(url)
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

    --script ESP esterno
    addExternalScript("https://raw.githubusercontent.com/tuoURLdelRepository/ESP.lua")
end

createGUI()