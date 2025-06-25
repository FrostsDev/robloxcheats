local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- === GUI Setup ===
local gui = Instance.new("ScreenGui")
gui.Name = "FrostsHackGUI"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 600, 0, 340)
main.Position = UDim2.new(0.5, -300, 0.5, -170)
main.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
main.BackgroundTransparency = 0.2
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui
main.Visible = true

-- Title Bar
local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 0, 60)
titleBar.BackgroundTransparency = 0.2
titleBar.Text = "Frosts | ESP & Aimbot"
titleBar.TextColor3 = Color3.new(1, 1, 1)
titleBar.Font = Enum.Font.GothamBold
titleBar.TextSize = 18
titleBar.TextXAlignment = Enum.TextXAlignment.Center
titleBar.Parent = main

-- Close Button (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 3)
closeBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.Text = "X"
closeBtn.AutoButtonColor = false
closeBtn.Parent = main

closeBtn.MouseEnter:Connect(function()
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
end)
closeBtn.MouseLeave:Connect(function()
    closeBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Tabs setup
local tabNames = {"Visuals", "Aimbot"}
local tabButtons = {}
local pages = {}

local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 35)
tabFrame.Position = UDim2.new(0, 0, 0, 35)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = main

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -70)
contentFrame.Position = UDim2.new(0, 0, 0, 70)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 0, 45)
contentFrame.BackgroundTransparency = 0.2
contentFrame.BorderSizePixel = 0
contentFrame.Parent = main

local function createPage(name)
    local page = Instance.new("Frame")
    page.Name = name
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = contentFrame
    pages[name] = page
end

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 30)
    btn.Position = UDim2.new(0, (i - 1) * 105, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 0, 70)
    btn.BackgroundTransparency = 0.2
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = tabFrame
    tabButtons[name] = btn
    createPage(name)

    btn.MouseButton1Click:Connect(function()
        for _, page in pairs(pages) do
            page.Visible = false
        end
        pages[name].Visible = true
    end)
end

pages["Visuals"].Visible = true

-- RightShift toggles GUI
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end)

-- UI Helpers
local function createLabel(parent, text, pos, width)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, width or 150, 0, 20)
    lbl.Position = pos
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.new(1, 1, 1)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 16
    lbl.Text = text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent
    return lbl
end

local function createToggle(parent, text, pos, default, callback)
    local cb = Instance.new("TextButton")
    cb.Size = UDim2.new(0, 20, 0, 20)
    cb.Position = pos
    cb.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
    cb.AutoButtonColor = false
    cb.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 130, 0, 20)
    label.Position = UDim2.new(pos.X.Scale, pos.X.Offset + 25, pos.Y.Scale, pos.Y.Offset)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.Text = text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent

    local checked = default
    local function updateColor()
        cb.BackgroundColor3 = checked and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
    end
    updateColor()

    cb.MouseButton1Click:Connect(function()
        checked = not checked
        updateColor()
        if callback then callback(checked) end
    end)

    return cb, label
end

local function createDropdown(parent, pos, width, options, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, width, 0, 25)
    frame.Position = pos
    frame.BackgroundColor3 = Color3.fromRGB(50, 0, 80)
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local selectedLabel = Instance.new("TextLabel")
    selectedLabel.Size = UDim2.new(1, -20, 1, 0)
    selectedLabel.Position = UDim2.new(0, 5, 0, 0)
    selectedLabel.BackgroundTransparency = 1
    selectedLabel.TextColor3 = Color3.new(1, 1, 1)
    selectedLabel.Font = Enum.Font.Gotham
    selectedLabel.TextSize = 14
    selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    selectedLabel.Text = options[1]
    selectedLabel.Parent = frame

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 15, 1, 0)
    arrow.Position = UDim2.new(1, -20, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.TextColor3 = Color3.new(1, 1, 1)
    arrow.Font = Enum.Font.SourceSansBold
    arrow.TextSize = 18
    arrow.Text = "▼"
    arrow.Parent = frame

    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Position = UDim2.new(0, 0, 1, 2)
    dropdownFrame.Size = UDim2.new(1, 0, 0, #options * 25)
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 0, 70)
    dropdownFrame.Visible = false
    dropdownFrame.ClipsDescendants = true
    dropdownFrame.Parent = frame

    for i, opt in ipairs(options) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 25)
        btn.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
        btn.BackgroundColor3 = Color3.fromRGB(50, 0, 80)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.Text = opt
        btn.Parent = dropdownFrame

        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(70, 0, 110)
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(50, 0, 80)
        end)

        btn.MouseButton1Click:Connect(function()
            selectedLabel.Text = opt
            dropdownFrame.Visible = false
            if callback then
                callback(i, opt)
            end
        end)
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dropdownFrame.Visible = not dropdownFrame.Visible
        end
    end)

    return frame, selectedLabel, dropdownFrame
end

-- === Visuals Tab ===
do
    local page = pages["Visuals"]

    local ESP_ENABLED = false
    local RGB_MODE = false
    local ESP_COLOR = Color3.fromRGB(255, 0, 255)
    local DRAWINGS, CONNECTIONS = {}, {}
    local RGB_HUE = 0
    local MAX_RENDER_DISTANCE = 1000
    local renderDistanceSliderValue = 1000

    local presetColors = {
        {Name = "Magenta", Color = Color3.fromRGB(255, 0, 255)},
        {Name = "Red", Color = Color3.fromRGB(255, 0, 0)},
        {Name = "Green", Color = Color3.fromRGB(0, 255, 0)},
        {Name = "Blue", Color = Color3.fromRGB(0, 0, 255)},
        {Name = "Yellow", Color = Color3.fromRGB(255, 255, 0)},
        {Name = "Cyan", Color = Color3.fromRGB(0, 255, 255)},
        {Name = "White", Color = Color3.fromRGB(255, 255, 255)},
        {Name = "Custom", Color = nil}
    }
    local selectedColorIndex = 1

    local showHealthBar = false
    local showName = false
    local showDistance = false
    local showSkeleton = true
    local showTracer = true
    local showBox = true

    -- Create UI Controls
    local espToggle = Instance.new("TextButton")
    espToggle.Size = UDim2.new(0, 280, 0, 40)
    espToggle.Position = UDim2.new(0, 20, 0, 20)
    espToggle.BackgroundColor3 = Color3.fromRGB(60, 0, 110)
    espToggle.TextColor3 = Color3.new(1, 1, 1)
    espToggle.Font = Enum.Font.GothamBold
    espToggle.TextSize = 18
    espToggle.Text = "Enable ESP: OFF"
    espToggle.Parent = page

    local rgbToggle = Instance.new("TextButton")
    rgbToggle.Size = UDim2.new(0, 260, 0, 40)
    rgbToggle.Position = UDim2.new(0, 320, 0, 20)
    rgbToggle.BackgroundColor3 = Color3.fromRGB(60, 0, 110)
    rgbToggle.TextColor3 = Color3.new(1, 1, 1)
    rgbToggle.Font = Enum.Font.GothamBold
    rgbToggle.TextSize = 18
    rgbToggle.Text = "RGB Mode: OFF"
    rgbToggle.Parent = page

    -- Color dropdown
    local dropdown, dropdownLabel = createDropdown(page, UDim2.new(0, 20, 0, 80), 200,
        (function()
            local t = {}
            for _, v in ipairs(presetColors) do
                table.insert(t, v.Name)
            end
            return t
        end)(),
        function(index, name)
            selectedColorIndex = index
            if name ~= "Custom" then
                ESP_COLOR = presetColors[index].Color
                redBox.Visible = false
                greenBox.Visible = false
                blueBox.Visible = false
            else
                redBox.Visible = true
                greenBox.Visible = true
                blueBox.Visible = true
            end
        end

    -- Render Distance Slider
    local renderDistanceLabel = createLabel(page, "Render Distance: "..MAX_RENDER_DISTANCE, UDim2.new(0, 20, 0, 230), 200)
    
    local renderDistanceSlider = Instance.new("Frame")
    renderDistanceSlider.Size = UDim2.new(0, 300, 0, 20)
    renderDistanceSlider.Position = UDim2.new(0, 20, 0, 250)
    renderDistanceSlider.BackgroundColor3 = Color3.fromRGB(50, 0, 80)
    renderDistanceSlider.BorderSizePixel = 0
    renderDistanceSlider.Parent = page
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(1, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(80, 0, 160)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = renderDistanceSlider
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 10, 1, 0)
    sliderButton.Position = UDim2.new(1, -5, 0, 0)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.Text = ""
    sliderButton.AutoButtonColor = false
    sliderButton.Parent = renderDistanceSlider
    
    local function updateSlider(value)
        local percent = math.clamp((value - 100) / 1900, 0, 1)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderButton.Position = UDim2.new(percent, -5, 0, 0)
        MAX_RENDER_DISTANCE = math.floor(value)
        renderDistanceLabel.Text = "Render Distance: "..MAX_RENDER_DISTANCE
    end
    
    updateSlider(MAX_RENDER_DISTANCE)
    
    local sliding = false
    sliderButton.MouseButton1Down:Connect(function()
        sliding = true
    end)
    
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = false
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UIS:GetMouseLocation()
            local sliderPos = renderDistanceSlider.AbsolutePosition
            local sliderSize = renderDistanceSlider.AbsoluteSize
            local percent = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
            local value = math.floor(100 + percent * 1900)
            updateSlider(value)
        end
    end)

    -- RGB Boxes for custom color
    local function createRGBBox(pos, default)
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(0, 60, 0, 30)
        box.Position = pos
        box.BackgroundColor3 = Color3.fromRGB(40, 0, 70)
        box.TextColor3 = Color3.new(1, 1, 1)
        box.Font = Enum.Font.Gotham
        box.TextSize = 16
        box.ClearTextOnFocus = false
        box.Text = tostring(default)
        box.Parent = page
        box.Visible = false
        return box
    end

    local redBox = createRGBBox(UDim2.new(0, 240, 0, 80), 255)
    local greenBox = createRGBBox(UDim2.new(0, 310, 0, 80), 0)
    local blueBox = createRGBBox(UDim2.new(0, 380, 0, 80), 255)

    -- Create toggles
    local healthToggle = createToggle(page, "Health Bar", UDim2.new(0, 20, 0, 130), showHealthBar, function(val) showHealthBar = val end)
    local nameToggle = createToggle(page, "Name ESP", UDim2.new(0, 160, 0, 130), showName, function(val) showName = val end)
    local distToggle = createToggle(page, "Distance ESP", UDim2.new(0, 20, 0, 160), showDistance, function(val) showDistance = val end)
    local skeletonToggle = createToggle(page, "Skeleton ESP", UDim2.new(0, 160, 0, 160), showSkeleton, function(val) showSkeleton = val end)
    local tracerToggle = createToggle(page, "Tracer ESP", UDim2.new(0, 20, 0, 190), showTracer, function(val) showTracer = val end)
    local boxToggle = createToggle(page, "Box ESP", UDim2.new(0, 160, 0, 190), showBox, function(val) showBox = val end)

    -- Drawing Helpers
    local function newDraw(kind, color)
        local d
        if kind == "Square" then
            d = Drawing.new("Square")
            d.Filled = false
            d.Thickness = 2
            d.Color = color
            d.Visible = false
        elseif kind == "Line" then
            d = Drawing.new("Line")
            d.Thickness = 2
            d.Color = color
            d.Visible = false
        elseif kind == "Text" then
            d = Drawing.new("Text")
            d.Center = true
            d.Outline = true
            d.OutlineColor = Color3.new(0, 0, 0)
            d.Font = 2
            d.Visible = false
            d.Color = color
        end
        return d
    end

    local skeletonJoints = {
        {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
    }

    local function createESP(player)
        if player == LocalPlayer then return end
        local d = {
            Box = newDraw("Square", ESP_COLOR),
            Tracer = newDraw("Line", ESP_COLOR),
            Skeleton = {},
            HealthBar = newDraw("Square", Color3.new(0, 1, 0)),
            HealthBarOutline = newDraw("Square", Color3.new(0, 0, 0)),
            HealthText = newDraw("Text", ESP_COLOR),
            NameText = newDraw("Text", ESP_COLOR),
            DistText = newDraw("Text", ESP_COLOR),
        }
        for _ in pairs(skeletonJoints) do
            table.insert(d.Skeleton, newDraw("Line", ESP_COLOR))
        end
        DRAWINGS[player] = d
    end

    local function removeESP(player)
        if DRAWINGS[player] then
            DRAWINGS[player].Box:Remove()
            DRAWINGS[player].Tracer:Remove()
            DRAWINGS[player].HealthBar:Remove()
            DRAWINGS[player].HealthBarOutline:Remove()
            DRAWINGS[player].HealthText:Remove()
            DRAWINGS[player].NameText:Remove()
            DRAWINGS[player].DistText:Remove()
            for _, line in pairs(DRAWINGS[player].Skeleton) do
                line:Remove()
            end
            DRAWINGS[player] = nil
        end
    end

    local function getPart(char, name)
        local p = char:FindFirstChild(name)
        if not p then return nil end
        local pos, onScreen = Camera:WorldToViewportPoint(p.Position)
        return Vector2.new(pos.X, pos.Y), onScreen
    end

    local function updateESP()
        if RGB_MODE then
            RGB_HUE = (RGB_HUE + 0.0025) % 1
            ESP_COLOR = Color3.fromHSV(RGB_HUE, 1, 1)
        end

        for player, d in pairs(DRAWINGS) do
            if player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                for _, drawing in pairs(d) do
                    if type(drawing) == "table" then
                        for _, line in ipairs(drawing) do
                            line.Visible = false
                        end
                    else
                        drawing.Visible = false
                    end
                end
                continue
            end

            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then
                for _, drawing in pairs(d) do
                    if type(drawing) == "table" then
                        for _, line in ipairs(drawing) do
                            line.Visible = false
                        end
                    else
                        drawing.Visible = false
                    end
                end
                continue
            end

            local root = char.HumanoidRootPart
            local distance = (root.Position - Camera.CFrame.Position).Magnitude
            if distance > MAX_RENDER_DISTANCE then
                for _, drawing in pairs(d) do
                    if type(drawing) == "table" then
                        for _, line in ipairs(drawing) do
                            line.Visible = false
                        end
                    else
                        drawing.Visible = false
                    end
                end
                continue
            end

            local pos, visible = Camera:WorldToViewportPoint(root.Position)
            if not visible then
                for _, drawing in pairs(d) do
                    if type(drawing) == "table" then
                        for _, line in ipairs(drawing) do
                            line.Visible = false
                        end
                    else
                        drawing.Visible = false
                    end
                end
                continue
            end

            local boxSize = Vector2.new(60, 100)

            -- Box
            d.Box.Position = Vector2.new(pos.X - boxSize.X / 2, pos.Y - boxSize.Y / 2)
            d.Box.Size = boxSize
            d.Box.Color = ESP_COLOR
            d.Box.Visible = ESP_ENABLED and showBox

            -- Tracer
            d.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            d.Tracer.To = Vector2.new(pos.X, pos.Y)
            d.Tracer.Color = ESP_COLOR
            d.Tracer.Visible = ESP_ENABLED and showTracer

            -- Skeleton
            for i, partPair in ipairs(skeletonJoints) do
                local p1, v1 = getPart(char, partPair[1])
                local p2, v2 = getPart(char, partPair[2])
                if v1 and v2 and ESP_ENABLED and showSkeleton then
                    d.Skeleton[i].From = p1
                    d.Skeleton[i].To = p2
                    d.Skeleton[i].Color = ESP_COLOR
                    d.Skeleton[i].Visible = true
                else
                    d.Skeleton[i].Visible = false
                end
            end

            -- Health Bar
            if showHealthBar and ESP_ENABLED then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                    local barHeight = boxSize.Y * healthPercent
                    
                    d.HealthBarOutline.Position = Vector2.new(pos.X - boxSize.X / 2 - 9, pos.Y + boxSize.Y / 2 - boxSize.Y - 1)
                    d.HealthBarOutline.Size = Vector2.new(7, boxSize.Y + 2)
                    d.HealthBarOutline.Visible = true
                    d.HealthBarOutline.Filled = true
                    
                    d.HealthBar.Position = Vector2.new(pos.X - boxSize.X / 2 - 8, pos.Y + boxSize.Y / 2 - barHeight)
                    d.HealthBar.Size = Vector2.new(5, barHeight)
                    d.HealthBar.Filled = true
                    
                    if healthPercent < 0.65 then
                        d.HealthBar.Color = Color3.fromRGB(255, 0, 0)
                    else
                        d.HealthBar.Color = Color3.fromRGB(0, 255, 0)
                    end
                    
                    d.HealthBar.Visible = true
                    
                    local healthText = string.format("%d/%d", math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
                    d.HealthText.Text = healthText
                    d.HealthText.Position = Vector2.new(pos.X - boxSize.X / 2 - 45, pos.Y)
                    d.HealthText.Color = ESP_COLOR
                    d.HealthText.Size = 14
                    d.HealthText.Outline = true
                    d.HealthText.OutlineColor = Color3.new(0, 0, 0)
                    d.HealthText.Visible = true
                else
                    d.HealthBar.Visible = false
                    d.HealthBarOutline.Visible = false
                    d.HealthText.Visible = false
                end
            else
                d.HealthBar.Visible = false
                d.HealthBarOutline.Visible = false
                d.HealthText.Visible = false
            end

            -- Name ESP
            if showName and ESP_ENABLED then
                d.NameText.Text = player.Name
                d.NameText.Position = Vector2.new(pos.X, pos.Y - boxSize.Y / 2 - 16)
                d.NameText.Color = ESP_COLOR
                d.NameText.Size = 18
                d.NameText.Outline = true
                d.NameText.OutlineColor = Color3.new(0, 0, 0)
                d.NameText.Visible = true
            else
                d.NameText.Visible = false
            end

            -- Distance ESP
            if showDistance and ESP_ENABLED then
                d.DistText.Text = string.format("%.1f studs", distance)
                d.DistText.Position = Vector2.new(pos.X, pos.Y + boxSize.Y / 2 + 6)
                d.DistText.Color = ESP_COLOR
                d.DistText.Size = 16
                d.DistText.Outline = true
                d.DistText.OutlineColor = Color3.new(0, 0, 0)
                d.DistText.Visible = true
            else
                d.DistText.Visible = false
            end
        end
    end

    local function enableESP()
        ESP_ENABLED = true
        espToggle.Text = "Enable ESP: ON"
        for _, p in pairs(Players:GetPlayers()) do createESP(p) end
        CONNECTIONS.step = RunService.RenderStepped:Connect(updateESP)
        CONNECTIONS.join = Players.PlayerAdded:Connect(createESP)
        CONNECTIONS.leave = Players.PlayerRemoving:Connect(removeESP)
    end

    local function disableESP()
        ESP_ENABLED = false
        espToggle.Text = "Enable ESP: OFF"
        for _, c in pairs(CONNECTIONS) do c:Disconnect() end
        for _, d in pairs(DRAWINGS) do
            for _, drawing in pairs(d) do
                if type(drawing) == "table" then
                    for _, line in ipairs(drawing) do
                        line:Remove()
                    end
                else
                    drawing:Remove()
                end
            end
        end
        DRAWINGS, CONNECTIONS = {}, {}
    end

    espToggle.MouseButton1Click:Connect(function()
        if ESP_ENABLED then
            disableESP()
        else
            enableESP()
        end
    end)

    rgbToggle.MouseButton1Click:Connect(function()
        RGB_MODE = not RGB_MODE
        rgbToggle.Text = "RGB Mode: " .. (RGB_MODE and "ON" or "OFF")
    end)

    local function onColorBoxFocusLost(box)
        box.FocusLost:Connect(function()
            if not RGB_MODE and presetColors[selectedColorIndex].Name == "Custom" then
                ESP_COLOR = Color3.fromRGB(
                    math.clamp(tonumber(redBox.Text) or 255, 0, 255),
                    math.clamp(tonumber(greenBox.Text) or 0, 0, 255),
                    math.clamp(tonumber(blueBox.Text) or 255, 0, 255)
                )
            end
        end)
    end

    onColorBoxFocusLost(redBox)
    onColorBoxFocusLost(greenBox)
    onColorBoxFocusLost(blueBox)
end

-- === Aimbot Tab ===
do
    local page = pages["Aimbot"]
    
    -- Aimbot settings
    local AIMBOT_ENABLED = false
    local AIMBOT_KEY = Enum.UserInputType.MouseButton2
    local AIMBOT_SMOOTHNESS = 3
    local AIMBOT_HEADSHOT = false
    local AIMBOT_VISIBILITY_CHECK = true
    local AIMBOT_TEAM_CHECK = true
    local AIMBOT_FOV = 100
    local AIMBOT_FOV_VISIBLE = false
    local MAX_AIMBOT_DISTANCE = 500

    -- Aimbot Toggle
    local aimbotToggle = Instance.new("TextButton")
    aimbotToggle.Size = UDim2.new(0, 280, 0, 40)
    aimbotToggle.Position = UDim2.new(0, 20, 0, 20)
    aimbotToggle.BackgroundColor3 = Color3.fromRGB(60, 0, 110)
    aimbotToggle.TextColor3 = Color3.new(1, 1, 1)
    aimbotToggle.Font = Enum.Font.GothamBold
    aimbotToggle.TextSize = 18
    aimbotToggle.Text = "Enable Aimbot: OFF"
    aimbotToggle.Parent = page

    -- FOV Circle
    local fovCircle = Drawing.new("Circle")
    fovCircle.Visible = AIMBOT_FOV_VISIBLE
    fovCircle.Radius = AIMBOT_FOV
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    fovCircle.Color = Color3.fromRGB(255, 255, 255)
    fovCircle.Thickness = 1
    fovCircle.Filled = false

    -- Get closest player within FOV and distance
    local function getClosestPlayer()
        local closestPlayer = nil
        local closestDistance = math.huge
        local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        
        for _, player in pairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            if AIMBOT_TEAM_CHECK and player.Team == LocalPlayer.Team then continue end
            
            local character = player.Character
            if not character then continue end
            
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid or humanoid.Health <= 0 then continue end
            
            local targetPart = AIMBOT_HEADSHOT and character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
            if not targetPart then continue end
            
            -- Distance check
            local distance = (targetPart.Position - Camera.CFrame.Position).Magnitude
            if distance > MAX_AIMBOT_DISTANCE then continue end
            
            -- Visibility check
            if AIMBOT_VISIBILITY_CHECK then
                local raycastParams = RaycastParams.new()
                raycastParams.FilterDescendantsInstances = {character, LocalPlayer.Character}
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                
                local raycastResult = workspace:Raycast(
                    Camera.CFrame.Position,
                    (targetPart.Position - Camera.CFrame.Position).Unit * MAX_AIMBOT_DISTANCE,
                    raycastParams
                )
                
                if raycastResult and not raycastResult.Instance:IsDescendantOf(character) then
                    continue
                end
            end
            
            local screenPoint, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
            if not onScreen then continue end
            
            local screenPos = Vector2.new(screenPoint.X, screenPoint.Y)
            local fovDistance = (center - screenPos).Magnitude
            
            if fovDistance <= AIMBOT_FOV then
                if fovDistance < closestDistance then
                    closestDistance = fovDistance
                    closestPlayer = player
                end
            end
        end
        
        return closestPlayer
    end

    -- Smooth mouse movement to target
    local function moveMouseToTarget(target)
        local character = target.Character
        if not character then return end
        
        local targetPart = AIMBOT_HEADSHOT and character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
        if not targetPart then return end
        
        local screenPoint = Camera:WorldToViewportPoint(targetPart.Position)
        local targetPos = Vector2.new(screenPoint.X, screenPoint.Y)
        local currentPos = UIS:GetMouseLocation()
        
        local direction = (targetPos - currentPos).Unit
        local distance = (targetPos - currentPos).Magnitude
        
        local smoothFactor = math.clamp(1/AIMBOT_SMOOTHNESS, 0.1, 1)
        local moveDistance = distance * smoothFactor
        
        local newPos = currentPos + (direction * moveDistance)
        
        mousemoverel(newPos.X - currentPos.X, newPos.Y - currentPos.Y)
    end

    -- Aimbot activation
    local aimbotConnection
    aimbotToggle.MouseButton1Click:Connect(function()
        AIMBOT_ENABLED = not AIMBOT_ENABLED
        aimbotToggle.Text = "Enable Aimbot: " .. (AIMBOT_ENABLED and "ON" or "OFF")
        fovCircle.Visible = AIMBOT_ENABLED and AIMBOT_FOV_VISIBLE
        
        if AIMBOT_ENABLED then
            aimbotConnection = RunService.RenderStepped:Connect(function()
                if UIS:IsMouseButtonPressed(AIMBOT_KEY) then
                    local target = getClosestPlayer()
                    if target then
                        moveMouseToTarget(target)
                    end
                end
            end)
        elseif aimbotConnection then
            aimbotConnection:Disconnect()
            aimbotConnection = nil
            fovCircle.Visible = false
        end
    end)

    -- Cleanup when GUI is closed
    gui.Destroying:Connect(function()
        if aimbotConnection then
            aimbotConnection:Disconnect()
        end
        fovCircle:Remove()
    end)

    -- UI Elements
    local keybindLabel = createLabel(page, "Aimbot Keybind: Right Click", UDim2.new(0, 20, 0, 80), 200)
    local distanceLabel = createLabel(page, "Max Distance: 500 studs", UDim2.new(0, 20, 0, 110), 200)

    -- Smoothness slider
    local smoothnessLabel = createLabel(page, "Smoothness: "..AIMBOT_SMOOTHNESS, UDim2.new(0, 20, 0, 160), 200)
    local smoothnessSlider = Instance.new("Frame")
    smoothnessSlider.Size = UDim2.new(0, 200, 0, 20)
    smoothnessSlider.Position = UDim2.new(0, 20, 0, 180)
    smoothnessSlider.BackgroundColor3 = Color3.fromRGB(50, 0, 80)
    smoothnessSlider.BorderSizePixel = 0
    smoothnessSlider.Parent = page

    local smoothnessFill = Instance.new("Frame")
    smoothnessFill.Size = UDim2.new((AIMBOT_SMOOTHNESS - 1) / 9, 0, 1, 0)
    smoothnessFill.BackgroundColor3 = Color3.fromRGB(80, 0, 160)
    smoothnessFill.BorderSizePixel = 0
    smoothnessFill.Parent = smoothnessSlider

    local smoothnessBtn = Instance.new("TextButton")
    smoothnessBtn.Size = UDim2.new(0, 10, 1, 0)
    smoothnessBtn.Position = UDim2.new((AIMBOT_SMOOTHNESS - 1) / 9, -5, 0, 0)
    smoothnessBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    smoothnessBtn.Text = ""
    smoothnessBtn.AutoButtonColor = false
    smoothnessBtn.Parent = smoothnessSlider

    local smoothSliding = false
    smoothnessBtn.MouseButton1Down:Connect(function()
        smoothSliding = true
    end)

    local function updateSmoothness(value)
        local percent = math.clamp((value - 1) / 9, 0, 1)
        smoothnessFill.Size = UDim2.new(percent, 0, 1, 0)
        smoothnessBtn.Position = UDim2.new(percent, -5, 0, 0)
        AIMBOT_SMOOTHNESS = math.floor(value)
        smoothnessLabel.Text = "Smoothness: "..AIMBOT_SMOOTHNESS
    end

    -- FOV Slider (10-500)
    local fovLabel = createLabel(page, "FOV: "..AIMBOT_FOV, UDim2.new(0, 240, 0, 160), 100)
    local fovSlider = Instance.new("Frame")
    fovSlider.Size = UDim2.new(0, 200, 0, 20)
    fovSlider.Position = UDim2.new(0, 240, 0, 180)
    fovSlider.BackgroundColor3 = Color3.fromRGB(50, 0, 80)
    fovSlider.BorderSizePixel = 0
    fovSlider.Parent = page

    local fovFill = Instance.new("Frame")
    fovFill.Size = UDim2.new((AIMBOT_FOV - 10) / 490, 0, 1, 0)
    fovFill.BackgroundColor3 = Color3.fromRGB(80, 0, 160)
    fovFill.BorderSizePixel = 0
    fovFill.Parent = fovSlider

    local fovBtn = Instance.new("TextButton")
    fovBtn.Size = UDim2.new(0, 10, 1, 0)
    fovBtn.Position = UDim2.new((AIMBOT_FOV - 10) / 490, -5, 0, 0)
    fovBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fovBtn.Text = ""
    fovBtn.AutoButtonColor = false
    fovBtn.Parent = fovSlider

    local fovSliding = false
    fovBtn.MouseButton1Down:Connect(function()
        fovSliding = true
    end)

    local function updateFOV(value)
        local percent = math.clamp((value - 10) / 490, 0, 1)
        fovFill.Size = UDim2.new(percent, 0, 1, 0)
        fovBtn.Position = UDim2.new(percent, -5, 0, 0)
        AIMBOT_FOV = math.floor(value)
        fovLabel.Text = "FOV: "..AIMBOT_FOV
        fovCircle.Radius = AIMBOT_FOV
    end

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            smoothSliding = false
            fovSliding = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if smoothSliding then
                local mousePos = UIS:GetMouseLocation()
                local sliderPos = smoothnessSlider.AbsolutePosition
                local sliderSize = smoothnessSlider.AbsoluteSize
                local percent = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
                local value = math.floor(1 + percent * 9)
                updateSmoothness(value)
            elseif fovSliding then
                local mousePos = UIS:GetMouseLocation()
                local sliderPos = fovSlider.AbsolutePosition
                local sliderSize = fovSlider.AbsoluteSize
                local percent = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
                local value = math.floor(10 + percent * 490)
                updateFOV(value)
            end
        end
    end)

    -- FOV Visibility Toggle
    local fovToggle = createToggle(page, "Show FOV Circle", UDim2.new(0, 240, 0, 210), AIMBOT_FOV_VISIBLE, function(val) 
        AIMBOT_FOV_VISIBLE = val
        fovCircle.Visible = AIMBOT_ENABLED and val
    end)

    -- Aimbot toggles
    local headshotToggle = createToggle(page, "Headshot Priority", UDim2.new(0, 20, 0, 210), AIMBOT_HEADSHOT, function(val) AIMBOT_HEADSHOT = val end)
    local visibilityToggle = createToggle(page, "Visibility Check", UDim2.new(0, 160, 0, 210), AIMBOT_VISIBILITY_CHECK, function(val) AIMBOT_VISIBILITY_CHECK = val end)
    local teamToggle = createToggle(page, "Team Check", UDim2.new(0, 20, 0, 240), AIMBOT_TEAM_CHECK, function(val) AIMBOT_TEAM_CHECK = val end)
end
