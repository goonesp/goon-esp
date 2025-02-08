local function createESP(player)
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local highlight = Instance.new("Highlight")
		highlight.Parent = player.Character
		highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Red color for enemies
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- White outline
		highlight.FillTransparency = 0.5
		highlight.OutlineTransparency = 0
	end
end

-- Apply ESP to all players when they join
game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		createESP(player)
	end)
end)

-- Apply ESP to existing players
for _, player in pairs(game.Players:GetPlayers()) do
	if player.Character then
		createESP(player)
	end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")

local Button = Instance.new("TextButton")
Button.Parent = ScreenGui
Button.Size = UDim2.new(0, 100, 0, 50)
Button.Position = UDim2.new(0, 10, 0, 10)
Button.Text = "Toggle ESP"
Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.BorderSizePixel = 2
Button.BorderColor3 = Color3.fromRGB(255, 0, 0)

-- ESP Toggle Function
local espEnabled = false

local function createESP(player)
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local highlight = player.Character:FindFirstChild("ESP_Highlight")
		if not highlight then
			highlight = Instance.new("Highlight")
			highlight.Name = "ESP_Highlight"
			highlight.Parent = player.Character
			highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Red ESP
			highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- White Outline
			highlight.FillTransparency = 0.5
			highlight.OutlineTransparency = 0
		end
	end
end

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
			if player.Character and player.Character:FindFirstChild("ESP_Highlight") then
				player.Character.ESP_Highlight:Destroy()
			end
		end
	end
end

Button.MouseButton1Click:Connect(toggleESP)

-- Apply ESP to new players
game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		if espEnabled then
			createESP(player)
		end
	end)
end)
