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

-- TextBox for Transparency (0 to 100)
local hitboxTransparencyInput = Instance.new("TextBox")
hitboxTransparencyInput.Parent = ScreenGui
hitboxTransparencyInput.Size = UDim2.new(0, 50, 0, 30)
hitboxTransparencyInput.Position = UDim2.new(0, 230, 0, 10)
hitboxTransparencyInput.Text = "0"  -- Default transparency (0 = opaque)
hitboxTransparencyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxTransparencyInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
hitboxTransparencyInput.BorderSizePixel = 2
hitboxTransparencyInput.BorderColor3 = Color3.fromRGB(255, 165, 0)

-- TextBox for Hitbox Size (1 to 6)
local hitboxSizeInput = Instance.new("TextBox")
hitboxSizeInput.Parent = ScreenGui
hitboxSizeInput.Size = UDim2.new(0, 50, 0, 30)
hitboxSizeInput.Position = UDim2.new(0, 230, 0, 50)
hitboxSizeInput.Text = "3"  -- Default hitbox size
hitboxSizeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxSizeInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
hitboxSizeInput.BorderSizePixel = 2
hitboxSizeInput.BorderColor3 = Color3.fromRGB(0, 255, 0)

-- Track whether ESP is enabled or not
local espEnabled = false
local teamESPEnabled = false
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
                highlight.FillTransparency = 1
            else
                -- Show enemies with red ESP, teammates with green (if Team ESP is off)
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
            removeESP(player)  -- Remove previous ESP
            if espEnabled then
                createESP(player)  -- Recreate ESP based on new settings
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
    hitboxSizeInput.Visible = buttonsVisible
    hitboxTransparencyInput.Visible = buttonsVisible
end

-- Connect the buttons to their respective functions
Button.MouseButton1Click:Connect(toggleESP)
TeamButton.MouseButton1Click:Connect(toggleTeamESP)

-- Function to listen for custom key bindings
local function listenForKeyPresses()
    local userInputService = game:GetService("UserInputService")

    userInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end

        local espKey = ESPKeyInput.Text:upper()  -- Get the key from the input box and convert to uppercase
        local teamKey = TeamKeyInput.Text:upper()

        if input.KeyCode.Name == espKey then
            toggleESP()  -- Toggle ESP on key press
        elseif input.KeyCode.Name == teamKey then
            toggleTeamESP()  -- Toggle Team ESP on key press
        end
    end)
end

-- Listen for the INSERT key press to toggle the visibility of buttons
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        toggleButtons()  -- Call toggleButtons when INSERT is pressed
    end
end)

-- Initialize the key press listener
listenForKeyPresses()

-- Apply ESP to players when they join
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if espEnabled then
            createESP(player)
        end
    end)
end)

-- Function to create and manage the expanded hitbox around the player's head
local function createHeadHitbox(character)
    -- Get the hitbox size from the TextBox
    local hitboxSize = tonumber(hitboxSizeInput.Text)
    if hitboxSize < 1 or hitboxSize > 6 then
        hitboxSize = 3  -- Default to size 3 if the input is invalid
    end

    -- Get the transparency from the TextBox (0 to 100)
    local transparencyValue = tonumber(hitboxTransparencyInput.Text)
    if transparencyValue < 0 then
        transparencyValue = 0
    elseif transparencyValue > 100 then
        transparencyValue = 100
    end
    local transparency = transparencyValue / 100  -- Convert to 0-1 range

    -- Create a square hitbox part around the player's head
    local head = character:FindFirstChild("Head")
    if not head then return end  -- Exit if the character doesn't have a head

    local hitboxPart = Instance.new("Part")
    hitboxPart.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)  -- Square size
    hitboxPart.Position = head.Position
    hitboxPart.Anchored = true
    hitboxPart.CanCollide = true
    hitboxPart.Color = Color3.fromRGB(255, 0, 0)  -- Red color
    hitboxPart.Transparency = transparency  -- Set transparency based on input
    hitboxPart.Parent = workspace

    -- Attach the part to the player's head so it moves with them
    local attachment = Instance.new("Attachment")
    attachment.Parent = head
    hitboxPart.CFrame = attachment.CFrame

    -- Update the hitbox position to follow the player's head
    game:GetService("RunService").Heartbeat:Connect(function()
        hitboxPart.Position = head.Position
    end)

    -- Detect when something touches the expanded hitbox
    hitboxPart.Touched:Connect(function(otherPart)
        if otherPart.Parent and otherPart.Parent ~= character then
            local hitPlayer = game.Players:GetPlayerFromCharacter(otherPart.Parent)
            if hitPlayer then
                print(hitPlayer.Name .. " was hit by the head hitbox!")
                -- Apply effects like damage or knockback here
            end
        end
    end)
end

-- Apply expanded head hitbox when players join
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        createHeadHitbox(character)
    end)
end)
