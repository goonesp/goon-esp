-- Main Script for ESP, Hitbox Expander, Aimbot, and UI Toggle with Customizable Features

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local mouse = player:GetMouse()

-- Create ScreenGui (UI)
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

-- Create Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 450) -- Adjusted size for bigger UI
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -225)  -- Center the frame
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Parent = screenGui

-- Create a Title Bar (Tabs)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 122, 255)  -- Blue Color
titleBar.Parent = mainFrame

-- Tabs for UI
local espTab = Instance.new("TextButton")
espTab.Size = UDim2.new(0.33, 0, 1, 0)
espTab.Text = "ESP"
espTab.BackgroundColor3 = Color3.fromRGB(0, 102, 204)
espTab.TextColor3 = Color3.fromRGB(255, 255, 255)
espTab.Parent = titleBar

local hitboxTab = Instance.new("TextButton")
hitboxTab.Size = UDim2.new(0.33, 0, 1, 0)
hitboxTab.Position = UDim2.new(0.33, 0, 0, 0)
hitboxTab.Text = "Hitbox Expander"
hitboxTab.BackgroundColor3 = Color3.fromRGB(0, 102, 204)
hitboxTab.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxTab.Parent = titleBar

local aimbotTab = Instance.new("TextButton")
aimbotTab.Size = UDim2.new(0.33, 0, 1, 0)
aimbotTab.Position = UDim2.new(0.66, 0, 0, 0)
aimbotTab.Text = "Aimbot"
aimbotTab.BackgroundColor3 = Color3.fromRGB(0, 102, 204)
aimbotTab.TextColor3 = Color3.fromRGB(255, 255, 255)
aimbotTab.Parent = titleBar

-- Tab contents
local espFrame = Instance.new("Frame")
espFrame.Size = UDim2.new(1, 0, 1, -40)  -- Fill the rest of the space below the title bar
espFrame.Position = UDim2.new(0, 0, 0, 40)
espFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
espFrame.Visible = true  -- Default tab is visible
espFrame.Parent = mainFrame

local hitboxFrame = Instance.new("Frame")
hitboxFrame.Size = UDim2.new(1, 0, 1, -40)
hitboxFrame.Position = UDim2.new(0, 0, 0, 40)
hitboxFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
hitboxFrame.Visible = false  -- Default hitbox tab is hidden
hitboxFrame.Parent = mainFrame

local aimbotFrame = Instance.new("Frame")
aimbotFrame.Size = UDim2.new(1, 0, 1, -40)
aimbotFrame.Position = UDim2.new(0, 0, 0, 40)
aimbotFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
aimbotFrame.Visible = false  -- Default aimbot tab is hidden
aimbotFrame.Parent = mainFrame

-- Function to switch between tabs
espTab.MouseButton1Click:Connect(function()
	espFrame.Visible = true
	hitboxFrame.Visible = false
	aimbotFrame.Visible = false
end)

hitboxTab.MouseButton1Click:Connect(function()
	espFrame.Visible = false
	hitboxFrame.Visible = true
	aimbotFrame.Visible = false
end)

aimbotTab.MouseButton1Click:Connect(function()
	espFrame.Visible = false
	hitboxFrame.Visible = false
	aimbotFrame.Visible = true
end)

-- Toggle the UI with Insert Key
local uiVisible = true
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.Insert then
		uiVisible = not uiVisible
		mainFrame.Visible = uiVisible
	end
end)

-- --- ESP Feature ---
local espEnabled = false
local teamCheckEnabled = false
local teamPlayers = {}

-- Create ESP Toggle Button
local toggleESP = Instance.new("TextButton")
toggleESP.Size = UDim2.new(0, 200, 0, 50)
toggleESP.Position = UDim2.new(0.5, -100, 0.1, 0)
toggleESP.Text = "Toggle ESP"
toggleESP.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
toggleESP.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleESP.Parent = espFrame

-- Team ESP Toggle Button
local toggleTeamESP = Instance.new("TextButton")
toggleTeamESP.Size = UDim2.new(0, 200, 0, 50)
toggleTeamESP.Position = UDim2.new(0.5, -100, 0.2, 0)
toggleTeamESP.Text = "Toggle Team ESP"
toggleTeamESP.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
toggleTeamESP.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleTeamESP.Parent = espFrame

-- Add Team Check TextBox for Key Input
local teamCheckTextbox = Instance.new("TextBox")
teamCheckTextbox.Size = UDim2.new(0, 200, 0, 50)
teamCheckTextbox.Position = UDim2.new(0.5, -100, 0.3, 0)
teamCheckTextbox.PlaceholderText = "Enter Team Check Key"
teamCheckTextbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
teamCheckTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
teamCheckTextbox.Parent = espFrame

-- Toggle ESP functionality
toggleESP.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	if espEnabled then
		print("ESP Enabled!")
		-- Insert actual ESP logic here
		game:GetService("RunService").Heartbeat:Connect(function()
			for _,v in pairs(game.Players:GetPlayers()) do
				if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
					local espBox = Instance.new("BillboardGui")
					espBox.Adornee = v.Character:WaitForChild("HumanoidRootPart")
					espBox.Size = UDim2.new(0, 10, 0, 10)
					espBox.StudsOffset = Vector3.new(0, 2, 0)
					espBox.Parent = player.Character.Head
					local frame = Instance.new("Frame")
					frame.Size = UDim2.new(1, 0, 1, 0)
					frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
					frame.BorderSizePixel = 0
					frame.Parent = espBox
				end
			end
		end)
	else
		print("ESP Disabled!")
		-- Remove ESP logic here
	end
end)

-- Toggle Team ESP functionality
toggleTeamESP.MouseButton1Click:Connect(function()
	teamCheckEnabled = not teamCheckEnabled
	if teamCheckEnabled then
		print("Team ESP Enabled!")
		-- Implement team check here (hide ESP for teammates)
	else
		print("Team ESP Disabled!")
		-- Remove team check logic here
	end
end)

-- --- Hitbox Expander Feature ---
local hitboxEnabled = false

-- Hitbox Expander Toggle Button
local toggleHitbox = Instance.new("TextButton")
toggleHitbox.Size = UDim2.new(0, 200, 0, 50)
toggleHitbox.Position = UDim2.new(0.5, -100, 0.1, 0)
toggleHitbox.Text = "Toggle Hitbox Expander"
toggleHitbox.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
toggleHitbox.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleHitbox.Parent = hitboxFrame

-- Hitbox Size TextBox
local hitboxSizeTextbox = Instance.new("TextBox")
hitboxSizeTextbox.Size = UDim2.new(0, 200, 0, 50)
hitboxSizeTextbox.Position = UDim2.new(0.5, -100, 0.2, 0)
hitboxSizeTextbox.PlaceholderText = "Enter Hitbox Size (1-6)"
hitboxSizeTextbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
hitboxSizeTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxSizeTextbox.Parent = hitboxFrame

-- Toggle Hitbox Expander functionality
toggleHitbox.MouseButton1Click:Connect(function()
	hitboxEnabled = not hitboxEnabled
	if hitboxEnabled then
		print("Hitbox Expander Enabled!")
		-- Insert hitbox expander logic here
	else
		print("Hitbox Expander Disabled!")
		-- Remove hitbox expander logic here
	end
end)

-- --- Aimbot Feature ---
local aimbotEnabled = false
local aimbotKey = Enum.KeyCode.F
local aimbotFOV = 50

-- Create Aimbot Toggle Button
local toggleAimbot = Instance.new("TextButton")
toggleAimbot.Size = UDim2.new(0, 200, 0, 50)
toggleAimbot.Position = UDim2.new(0.5, -100, 0.1, 0)
toggleAimbot.Text = "Toggle Aimbot"
toggleAimbot.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
toggleAimbot.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleAimbot.Parent = aimbotFrame

-- FOV TextBox
local fovTextbox = Instance.new("TextBox")
fovTextbox.Size = UDim2.new(0, 200, 0, 50)
fovTextbox.Position = UDim2.new(0.5, -100, 0.2, 0)
fovTextbox.PlaceholderText = "Enter Aimbot FOV (50-180)"
fovTextbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
fovTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
fovTextbox.Parent = aimbotFrame

-- Aimbot Toggle functionality
toggleAimbot.MouseButton1Click:Connect(function()
	aimbotEnabled = not aimbotEnabled
	if aimbotEnabled then
		print("Aimbot Enabled!")
		-- Implement aimbot logic here
	else
		print("Aimbot Disabled!")
		-- Remove aimbot logic here
	end
end)
