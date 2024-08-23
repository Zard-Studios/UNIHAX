-- UI.lua
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

local function createButton(name, position, parent)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Size = UDim2.new(0.9, 0, 0, 50)
    Button.Position = position
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Button.Text = "Enable " .. name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 18
    Button.Font = Enum.Font.GothamSemibold
    Button.Parent = parent

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button

    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(100, 100, 100)
    ButtonStroke.Thickness = 2
    ButtonStroke.Parent = Button

    return Button
end

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

    local ESPButton = createButton("ESP", UDim2.new(0.05, 0, 0.15, 0), MainFrame)
    local NoClipButton = createButton("NoClip", UDim2.new(0.05, 0, 0.3, 0), MainFrame)
    local TeleportButton = createButton("Teleport", UDim2.new(0.05, 0, 0.45, 0), MainFrame)

    local TeleportFrame = Instance.new("Frame")
    TeleportFrame.Name = "TeleportFrame"
    TeleportFrame.Size = UDim2.new(0.9, 0, 0.5, 0)
    TeleportFrame.Position = UDim2.new(0.05, 0, 0.55, 0)
    TeleportFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TeleportFrame.BorderSizePixel = 0
    TeleportFrame.Visible = false
    TeleportFrame.Parent = MainFrame

    local TeleportTitle = Instance.new("TextLabel")
    TeleportTitle.Name = "TeleportTitle"
    TeleportTitle.Size = UDim2.new(1, 0, 0, 40)
    TeleportTitle.BackgroundTransparency = 1
    TeleportTitle.Text = "Teleport to Player"
    TeleportTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeleportTitle.TextSize = 18
    TeleportTitle.Font = Enum.Font.GothamBold
    TeleportTitle.Parent = TeleportFrame

    local PlayerList = Instance.new("ScrollingFrame")
    PlayerList.Name = "PlayerList"
    PlayerList.Size = UDim2.new(1, 0, 1, -40)
    PlayerList.Position = UDim2.new(0, 0, 0, 40)
    PlayerList.BackgroundTransparency = 1
    PlayerList.ScrollBarThickness = 6
    PlayerList.Parent = TeleportFrame

    local PlayerListLayout = Instance.new("UIListLayout")
    PlayerListLayout.Name = "PlayerListLayout"
    PlayerListLayout.FillDirection = Enum.FillDirection.Vertical
    PlayerListLayout.Padding = UDim.new(0, 5)
    PlayerListLayout.Parent = PlayerList

    return {
        ScreenGui = ScreenGui,
        ESPButton = ESPButton,
        NoClipButton = NoClipButton,
        TeleportButton = TeleportButton,
        TeleportFrame = TeleportFrame,
        PlayerList = PlayerList
    }
end

return createGUI