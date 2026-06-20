local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Library = {}

local function renderObject(className, properties)
    local obj = Instance.new(className)
    if properties then
        for prop, val in pairs(properties) do
            obj[prop] = val
        end
    end
    return obj
end

function Library:CreateWindow(title)
    local Window = {
        Tabs = {},
        Pages = {},
        FirstTab = true
    }

    local ScreenGui = renderObject("ScreenGui", {
        Name = "Gamesense_Dynamic_Library",
        Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui"),
        ResetOnSpawn = false
    })

    -- Главное окно
    local MainFrame = renderObject("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 550, 0, 400),
        Position = UDim2.new(0.5, -275, 0.5, -200),
        BackgroundColor3 = Color3.fromRGB(17, 17, 17),
        BorderSizePixel = 1,
        BorderColor3 = Color3.fromRGB(10, 10, 10),
        Active = true,
        Parent = ScreenGui
    })

    -- Верхняя цветная линия (Gamesense стиль)
    local GlowBar = renderObject("Frame", {
        Size = UDim2.new(1, 0, 0, 3),
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    renderObject("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 175, 225)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 60, 180)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 200, 50))
        }),
        Parent = GlowBar
    })

    -- Перетаскивание меню
    local dragToggle, dragStart, startPos = false, nil, nil
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = false
        end
    end)

    -- Сайдбар для табов
    local Sidebar = renderObject("Frame", {
        Size = UDim2.new(0, 80, 1, -3),
        Position = UDim2.new(0, 0, 0, 3),
        BackgroundColor3 = Color3.fromRGB(12, 12, 12),
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    renderObject("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = Sidebar
    })

    -- Контейнер для страниц
    local Container = renderObject("Frame", {
        Size = UDim2.new(1, -81, 1, -3),
        Position = UDim2.new(0, 81, 0, 3),
        BackgroundColor3 = Color3.fromRGB(17, 17, 17),
        BorderSizePixel = 0,
        Parent = MainFrame
    })

    function Window:CreateTab(tabName, iconId)
        local TabObj = {}
        local isDefault = Window.FirstTab
        Window.FirstTab = false

        local TabButton = renderObject("TextButton", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = isDefault and Color3.fromRGB(17, 17, 17) or Color3.fromRGB(12, 12, 12),
            Text = tabName,
            TextColor3 = isDefault and Color3.fromRGB(160, 200, 50) or Color3.fromRGB(150, 150, 150),
            Font = Enum.Font.Code,
            TextSize = 12,
            BorderSizePixel = 0,
            Parent = Sidebar
        })

        local Page = renderObject("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = isDefault,
            Parent = Container
        })

        Window.Tabs[tabName] = {Button = TabButton, Page = Page}

        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do
                t.Page.Visible = false
                t.Button.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
                t.Button.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
            Page.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
            TabButton.TextColor3 = Color3.fromRGB(160, 200, 50)
        end)

        function TabObj:CreateSection(sectionName, side)
            local SectionObj = {}
            local sidePos = (side == "Right") and UDim2.new(0.5, 5, 0, 10) or UDim2.new(0, 5, 0, 10)

            local SectionFrame = renderObject("Frame", {
                Size = UDim2.new(0.5, -10, 1, -20),
                Position = sidePos,
                BackgroundColor3 = Color3.fromRGB(22, 22, 22),
                BorderColor3 = Color3.fromRGB(35, 35, 35),
                BorderSizePixel = 1,
                Parent = Page
            })

            local TitleLabel = renderObject("TextLabel", {
                Size = UDim2.new(1, 0, 0, 18),
                BackgroundTransparency = 1,
                Text = "  " .. sectionName:upper(),
                TextColor3 = Color3.fromRGB(220, 220, 220),
                Font = Enum.Font.Code,
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SectionFrame
            })

            local ContainerList = renderObject("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 6),
                Parent = SectionFrame
            })
            renderObject("UIPadding", {
                PaddingTop = UDim.new(0, 22),
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                Parent = SectionFrame
            })

            function SectionObj:CreateButton(text, callback)
                local Btn = renderObject("TextButton", {
                    Size = UDim2.new(1, 0, 0, 22),
                    BackgroundColor3 = Color3.fromRGB(28, 28, 28),
                    BorderColor3 = Color3.fromRGB(45, 45, 45),
                    BorderSizePixel = 1,
                    Text = text,
                    TextColor3 = Color3.fromRGB(200, 200, 200),
                    Font = Enum.Font.Code,
                    TextSize = 11,
                    Parent = SectionFrame
                })
                Btn.MouseButton1Click:Connect(function()
                    if callback then callback() end
                end)
            end

            function SectionObj:CreateToggle(text, default, callback)
                local ToggleFrame = renderObject("Frame", {
                    Size = UDim2.new(1, 0, 0, 16),
                    BackgroundTransparency = 1,
                    Parent = SectionFrame
                })
                local Box = renderObject("TextButton", {
                    Size = UDim2.new(0, 10, 0, 10),
                    Position = UDim2.new(0, 0, 0.5, -5),
                    BackgroundColor3 = default and Color3.fromRGB(160, 200, 50) or Color3.fromRGB(28, 28, 28),
                    BorderColor3 = Color3.fromRGB(45, 45, 45),
                    BorderSizePixel = 1,
                    Text = "",
                    Parent = ToggleFrame
                })
                renderObject("TextLabel", {
                    Size = UDim2.new(1, -16, 1, 0),
                    Position = UDim2.new(0, 16, 0, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = Color3.fromRGB(200, 200, 200),
                    Font = Enum.Font.Code,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = ToggleFrame
                })

                local active = default or false
                Box.MouseButton1Click:Connect(function()
                    active = not active
                    Box.BackgroundColor3 = active and Color3.fromRGB(160, 200, 50) or Color3.fromRGB(28, 28, 28)
                    if callback then callback(active) end
                end)
            end

            function SectionObj:CreateDropdown(text, options, defaultIdx, callback)
                local DropdownFrame = renderObject("Frame", {
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundTransparency = 1,
                    Parent = SectionFrame
                })
                renderObject("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 12),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = Color3.fromRGB(140, 140, 140),
                    Font = Enum.Font.Code,
                    TextSize = 10,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = DropdownFrame
                })

                local idx = defaultIdx or 1
                local DBtn = renderObject("TextButton", {
                    Size = UDim2.new(1, 0, 0, 18),
                    Position = UDim2.new(0, 0, 0, 14),
                    BackgroundColor3 = Color3.fromRGB(28, 28, 28),
                    BorderColor3 = Color3.fromRGB(45, 45, 45),
                    BorderSizePixel = 1,
                    Text = "  " .. tostring(options[idx]),
                    TextColor3 = Color3.fromRGB(200, 200, 200),
                    Font = Enum.Font.Code,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = DropdownFrame
                })

                DBtn.MouseButton1Click:Connect(function()
                    idx = idx + 1
                    if idx > #options then idx = 1 end
                    DBtn.Text = "  " .. tostring(options[idx])
                    if callback then callback(options[idx]) end
                end)
            end

            return SectionObj
        end
        return TabObj
    end
    return Window
end

return Library
