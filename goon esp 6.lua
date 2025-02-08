-- Services
local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local gui = player:WaitForChild("PlayerGui"):WaitForChild("MainUI")

-- UI elements
local espKeyInput = gui:WaitForChild("ESPKeyInput") -- TextBox to set ESP key
local teamCheckKeyInput = gui:WaitForChild("TeamCheckKeyInput") -- TextBox to set team check key
local hitboxSizeInput = gui:WaitForChild("HitboxSizeInput") -- TextBox to set hitbox size
local hitboxTransparencyInput = gui:WaitForChild("HitboxTransparencyInput") -- TextBox to set hitbox transparency
local toggleESPButton = gui:WaitForChild("ToggleESPButton") -- Button to toggle ESP
local toggleTeamCheckButton = gui:WaitForChild("ToggleTeamCheckButton") -- Button to toggle team check
local espStatusLabel = gui:WaitForChild("ESPStatusLabel") -- Label to show ESP status

-- Variables
local espEnabled = false
local teamCheckEnabled = false
local isUIVisible = true  -- UI visibility status

-- Hitbox Expander Function
local function createHitboxExpander(player)
	if player.Character and player.Character:FindFirstChild("Head") then
		local head = player.Character:FindFirstChild("Head")

		-- Size from the textbox
		local size = tonumber(hitboxSizeInput.Text) or 3  -- Default to 3 if invalid input
		size = math.clamp(size, 1, 6)  -- Clamp between 1 and 6

		-- Transparency from the textbox
		local transparency = tonumber(hitboxTransparencyInput.Text) or 0  -- Default to 0 if invalid input
		transparency = math.clamp(transparency, 0, 100) / 100  -- Normalize to 0-1 range

		-- Remove existing hitbox if present
		if head:FindFirstChild("HitboxExpander") then
			head.HitboxExpander:Destroy()
		end

		-- Create new part for the hitbox
		local hitbox = Instance.new("Part")
		hitbox.Parent = head
		hitbox.Name = "HitboxExpander"
		hitbox.Size = Vector3.new(size, size, size)  -- Size based on input
		hitbox.Position = head.Position
		hitbox.Anchored = true
		hitbox.CanCollide = false
		hitbox.Transparency = transparency
		hitbox.BrickColor = BrickColor.new("Bright red")

		-- Optional: Adding a BillboardGui to show the hitbox better
		local billboard = Instance.new("BillboardGui")
		billboard.Parent = hitbox
		billboard.Adornee = hitbox
		billboard.Size = UDim2.new(4, 0, 4, 0)  -- Make it larger so it shows up well
		billboard.StudsOffset = Vector3.new(0, 0, 0)
		billboard.AlwaysOnTop = true

		local textLabel = Instance.new("TextLabel")
		textLabel.Parent = billboard
		textLabel.Size = UDim2.new(1, 0, 1, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = "Hitbox Expander"
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel.TextSize = 14
		textLabel.TextStrokeTransparency = 0.5
	end
end

-- Function to enable/disable ESP
local function toggleESP()
	espEnabled = not espEnabled
	espStatusLabel.Text = espEnabled and "ESP: ON" or "ESP: OFF"
	-- Logic to turn ESP on/off
	-- Add your ESP functionality here
end

-- Function to enable/disable Team Check
local function toggleTeamCheck()
	teamCheckEnabled = not teamCheckEnabled
	-- Logic to turn Team Check on/off
	-- Add your team check functionality here
end

-- Handle Key Bindings for ESP and Team Check
espKeyInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local espKey = espKeyInput.Text:upper()
		userInputService.InputBegan:Connect(function(input)
			if input.KeyCode == Enum.KeyCode[espKey] then
				toggleESP()
			end
		end)
	end
end)

teamCheckKeyInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local teamCheckKey = teamCheckKeyInput.Text:upper()
		userInputService.InputBegan:Connect(function(input)
			if input.KeyCode == Enum.KeyCode[teamCheckKey] then
				toggleTeamCheck()
			end
		end)
	end
end)

-- Button Events
toggleESPButton.MouseButton1Click:Connect(toggleESP)
toggleTeamCheckButton.MouseButton1Click:Connect(toggleTeamCheck)

-- Handling hitbox expander key
local hitboxKeyInput = gui:WaitForChild("HitboxKeyInput") -- TextBox to set hitbox key
hitboxKeyInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local hitboxKey = hitboxKeyInput.Text:upper()  -- Use upper case for easier input checking

		-- Check if the entered key matches the one for the hitbox expander
		userInputService.InputBegan:Connect(function(input)
			if input.KeyCode == Enum.KeyCode[hitboxKey] then
				-- Toggle the hitbox expander when the correct key is pressed
				createHitboxExpander(player)
			end
		end)
	end
end)

-- Make the UI draggable
local dragInput, dragStart, startPos
local function onDrag(input)
	local delta = input.Position - dragStart
	gui.Position = UDim2.new(gui.Position.X.Scale, gui.Position.X.Offset + delta.X, gui.Position.Y.Scale, gui.Position.Y.Offset + delta.Y)
end

gui.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragStart = input.Position
		dragInput = input.InputChanged:Connect(onDrag)
	end
end)

gui.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragInput:Disconnect()
	end
end)

-- Insert key to toggle the UI visibility
userInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end  -- Ignore if the game already processed the input (e.g., typing in a textbox)

	if input.KeyCode == Enum.KeyCode.Insert then
		isUIVisible = not isUIVisible
		gui.Visible = isUIVisible  -- Toggle UI visibility
	end
end)















