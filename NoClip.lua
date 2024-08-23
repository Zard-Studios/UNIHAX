local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local NoClip = {}

local noClipEnabled = false

function NoClip.toggleNoClip()
    noClipEnabled = not noClipEnabled
    NoClipButton.Text = noClipEnabled and "Disable NoClip" or "Enable NoClip"
    NoClipButton.BackgroundColor3 = noClipEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(60, 60, 60)

    if noClipEnabled then
        RunService:BindToRenderStep("NoClip", 100, function()
            if Character and Character:IsDescendantOf(workspace) then
                for _, part in ipairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        RunService:UnbindFromRenderStep("NoClip")
        if Character and Character:IsDescendantOf(workspace) then
            for _, part in ipairs(Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
end

return NoClip