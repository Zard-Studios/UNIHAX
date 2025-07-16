-- Script di test per dimostrare che le impostazioni funzionano
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Aspetta che il sistema di impostazioni sia caricato
repeat wait() until _G.UniHaxSettings

print("🎯 SISTEMA DI TEST IMPOSTAZIONI ATTIVO")
print("Valori iniziali:")
print("ESP Opacity:", _G.UniHaxSettings.espOpacity)
print("ESP Color:", _G.UniHaxSettings.espColor)
print("Fly Speed:", _G.UniHaxSettings.flySpeed)

-- Registra callback per ESP
_G.UniHaxSettings.onESPSettingsChange(function(opacity, color)
    print("🔴 ESP CAMBIATO!")
    print("Nuova Opacity:", opacity)
    print("Nuovo Color:", color)
    
    -- Esempio: aggiorna tutti gli ESP esistenti
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character then
            local highlight = player.Character:FindFirstChild("ESPHighlight")
            if highlight then
                highlight.FillTransparency = opacity
                highlight.FillColor = color
                print("✅ Aggiornato ESP per", player.Name)
            end
        end
    end
end)

-- Registra callback per Fly
_G.UniHaxSettings.onFlySettingsChange(function(speed)
    print("🚀 FLY SPEED CAMBIATO!")
    print("Nuova Speed:", speed)
    
    -- Esempio: aggiorna la velocità di volo se attiva
    if _G.iyflyspeed then
        _G.iyflyspeed = speed
        print("✅ Velocità di volo aggiornata a", speed)
    end
end)

-- Crea ESP di test per dimostrare che funziona
local function createTestESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character and not player.Character:FindFirstChild("ESPHighlight") then
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESPHighlight"
            highlight.FillColor = _G.UniHaxSettings.espColor
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = _G.UniHaxSettings.espOpacity
            highlight.OutlineTransparency = 0
            highlight.Parent = player.Character
            print("🎯 Creato ESP di test per", player.Name)
        end
    end
end

-- Crea ESP di test ogni 5 secondi
spawn(function()
    while wait(5) do
        createTestESP()
    end
end)

print("📝 ISTRUZIONI:")
print("1. Apri il menu UNIHAX (RightAlt)")
print("2. Clicca sull'ingranaggio ⚙️ accanto a ESP")
print("3. Cambia opacità e colore")
print("4. Guarda la console per vedere i cambiamenti!")
print("5. Gli ESP sui giocatori si aggiorneranno automaticamente!")