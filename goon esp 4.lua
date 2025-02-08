-- Create the GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")

-- Toggle ESP Button
local Button = Instance.new("TextButton")
Button.Parent = ScreenGui
Button.Size = UDim2.new(0, 100, 0, 50)
Button.Position = UDim2.new(0, 10, 0, 10)
Button.Text = "Toggle ESP"
Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.BorderSizePixel = 2
Button.BorderColor3 = Color3.fromRGB(255, 0, 0)

-- Team Check Button
local TeamButton = Instance.new("TextButton")
TeamButton.Parent = ScreenGui
TeamButton.Size = UDim2.new(0, 100, 0, 50)
TeamButton.Position = UDim2.new(0, 120, 0, 10)
TeamButton.Text = "Toggle Team ESP"
TeamButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TeamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeamButton.BorderSizePixel = 2
TeamButton.BorderColor3 = Color3.fromRGB(0, 0, 255)

-- Track whether ESP is enabled or not
local espEnabled = false
local teamESPEnabled = false  -- New variable for team ESP
local activeESP = {}

-- Function to create ESP for a player
local function createESP(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local highlight = Instance.new("Highlight")
        highlight.Parent = player.Character

        -- Determine the color based on whether it's a teammate or enemy
        local team = player.Team
        if team then
            if teamESPEnabled and player.Team == game.Players.LocalPlayer.Team then
                -- Hide teammates' ESP when Team ESP is enabled
                highlight.FillTransparency = 1 -- Make it invisible for teammates
            else
                -- Show enemies with red ESP, teammates with green
                if player.Team ~= game.Players.LocalPlayer.Team then
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)  -- Red for enemies
                else
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)  -- Green for teammates (if Team ESP is off)
                end
            end
        else
            highlight.FillColor = Color3.fromRGB(255, 255, 0)  -- Default Yellow for no team
        end

        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)  -- White outline
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0

        -- Store the highlight for easy removal later
        activeESP[player] = highlight
    end
end

-- Function to remove ESP for a player
local function removeESP(player)
    if activeESP[player] then
        activeESP[player]:Destroy()
        activeESP[player] = nil
    end
end

-- Toggle ESP function
local function toggleESP()
    espEnabled = not espEnabled

    if espEnabled then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character then
                createESP(player)
            end
        end
    else
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character then
                removeESP(player)
            end
        end
    end
end

-- Toggle Team ESP function
local function toggleTeamESP()
    teamESPEnabled = not teamESPEnabled

    -- Re-apply ESP based on the new team ESP setting
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            removeESP(player)
            if espEnabled then
                createESP(player)
            end
        end
    end
end

-- Toggle Buttons visibility
local buttonsVisible = true
local function toggleButtons()
    buttonsVisible = not buttonsVisible

    -- Toggle visibility of the buttons
    Button.Visible = buttonsVisible
    TeamButton.Visible = buttonsVisible
end

-- Connect the buttons to their respective functions
Button.MouseButton1Click:Connect(toggleESP)
TeamButton.MouseButton1Click:Connect(toggleTeamESP)

-- Apply ESP to players when they join
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if espEnabled then
            createESP(player)
        end
    end)
end)

-- Listen for the INSERT key press to toggle the visibility of buttons
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        toggleButtons()  -- Call toggleButtons when INSERT is pressed
    end
end)
