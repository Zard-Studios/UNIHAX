local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local noClipEnabled = false

local function toggleNoClip(enabled)
    noClipEnabled = enabled
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

return {
    toggleNoClip = toggleNoClip
}