local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
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

function Library:CreateWindow(hubName)
    local Window = {
        Tabs = {},
        FirstTab = true
    }

    local ScreenGui = renderObject("ScreenGui", {
        Name = "SkeetMenu_Seamless_PuppyWare",
        Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui"),
        ResetOnSpawn = false
    })

    -- Главное окно
    local MainFrame = renderObject("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 560, 0, 420),
        Position = UDim2.new(0.5, -280, 0.5, -210),
        BackgroundColor3 = Color3.fromRGB(17, 17, 17),
        BorderSizePixel = 1,
        BorderColor3 = Color3.fromRGB(10, 10, 10),
        Active = true,
        Parent = ScreenGui
    })

    local UIScale = renderObject("UIScale", {
        Scale = 0.85,
        Parent = MainFrame
    })

    -- Верхняя неоновая линия Skeet
    local GlowBar = renderObject("Frame", {
        Size = UDim2.new(1, 0, 0, 3),
        BorderSizePixel = 0,
        ZIndex = 5,
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

    -- Драг окна за любую точку
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
        Size = UDim2.new(0, 74, 1, -3),
        Position = UDim2.new(0, 0, 0, 3),
        BackgroundColor3 = Color3.fromRGB(12, 12, 12),
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = MainFrame
    })
    renderObject("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Parent = Sidebar
    })

    -- Разделитель
    renderObject("Frame", {
        Size = UDim2.new(0, 1, 1, -3),
        Position = UDim2.new(0, 74, 0, 3),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0,
        Parent = MainFrame
    })

    -- Основной контейнер страниц
    local Container = renderObject("Frame", {
        Size = UDim2.new(1, -75, 1, -3),
        Position = UDim2.new(0, 75, 0, 3),
        BackgroundColor3 = Color3.fromRGB(17, 17, 17),
        Parent = MainFrame
    })

    -- Пиксельная сетка на фоне
    renderObject("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://8509210785",
        ImageColor3 = Color3.fromRGB(15, 15, 15),
        ScaleType = Enum.ScaleType.Tile,
        TileSize = UDim2.new(0, 8, 0, 8),
        ZIndex = 0,
        Parent = Container
    })

    function Window:CreateTab(tabName, iconId)
        local TabObj = {}
        local isDefault = Window.FirstTab
        Window.FirstTab = false

        -- Кнопка вкладки в сайдбаре
        local Page_Tab = renderObject("Frame", {
            Size = isDefault and UDim2.new(0, 75, 0, 55) or UDim2.new(0, 74, 0, 55),
            BorderSizePixel = 0,
            BackgroundColor3 = isDefault and Color3.fromRGB(17, 17, 17) or Color3.fromRGB(12, 12, 12),
            ClipsDescendants = true,
            Parent = Sidebar
        })

        local Pattern = renderObject("ImageLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = "rbxassetid://8509210785",
            ImageColor3 = Color3.fromRGB(14, 14, 14),
            ScaleType = Enum.ScaleType.Tile,
            TileSize = UDim2.new(0, 8, 0, 8),
            Visible = isDefault,
            ZIndex = 1,
            Parent = Page_Tab
        })

        local Page_Tab_Image = renderObject("ImageLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(0, 38, 0, 38),
            Position = UDim2.new(0, 37, 0.5, 0),
            BackgroundTransparency = 1,
            Image = iconId or "rbxassetid://8547236654",
            ImageColor3 = isDefault and Color3.fromRGB(160, 200, 50) or Color3.fromRGB(80, 80, 80),
            ZIndex = 2,
            Parent = Page_Tab
        })

        local Page_Tab_Button = renderObject("TextButton", {
            Size = UDim2.new(0, 74, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 3,
            Parent = Page_Tab
        })

        -- Сама страница элементов
        local Page = renderObject("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = isDefault,
            ZIndex = 2,
            Parent = Container
        })

        Window.Tabs[tabName] = {Frame = Page_Tab, Icon = Page_Tab_Image, Pattern = Pattern, Page = Page}

        Page_Tab_Button.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do
                t.Page.Visible = false
                t.Frame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
                t.Frame.Size = UDim2.new(0, 74, 0, 55)
                t.Icon.ImageColor3 = Color3.fromRGB(80, 80, 80)
                t.Pattern.Visible = false
            end
            Page.Visible = true
            Page_Tab.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
            Page_Tab.Size = UDim2.new(0, 75, 0, 55)
            Page_Tab_Image.ImageColor3 = Color3.fromRGB(160, 200, 50)
            Pattern.Visible = true
        end)

        function TabObj:CreateSection(sectionName, side)
            local SectionObj = {}
            local isRight = (side == "Right")
            local pos = isRight and UDim2.new(0.5, 4, 0, 10) or UDim2.new(0, 8, 0, 10)

            local Section = renderObject("ScrollingFrame", {
                Size = UDim2.new(0.5, -12, 1, -20),
                Position = pos,
                BackgroundColor3 = Color3.fromRGB(21, 21, 21),
                BorderColor3 = Color3.fromRGB(35, 35, 35),
                BorderSizePixel = 1,
                ScrollBarThickness = 0,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ZIndex = 2,
                Parent = Page
            })

            renderObject("TextLabel", {
                Size = UDim2.new(1, 0, 0, 18),
                BackgroundTransparency = 1,
                Text = "<b>  " .. sectionName:upper() .. "</b>",
                TextColor3 = Color3.fromRGB(230, 230, 230),
                Font = Enum.Font.Code,
                TextSize = 10,
                RichText = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3,
                Parent = Section
            })

            renderObject("UIListLayout", {
                Padding = UDim.new(0, 5),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = Section
            })

            function SectionObj:CreateButton(text, callback)
                local BtnFrame = renderObject("Frame", { Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Parent = Section })
                local Btn = renderObject("TextButton", {
                    Size = UDim2.new(1, -16, 0, 18), Position = UDim2.new(0, 8, 0, 3),
                    BackgroundColor3 = Color3.fromRGB(28, 28, 28), BorderColor3 = Color3.fromRGB(45, 45, 45),
                    BorderSizePixel = 1, Text = text, TextColor3 = Color3.fromRGB(200, 200, 200),
                    Font = Enum.Font.Code, TextSize = 11, ZIndex = 4, Parent = BtnFrame
                })
                Btn.MouseButton1Click:Connect(function()
                    if callback then callback() end
                end)
            end

            function SectionObj:CreateToggle(text, default, callback)
                local Frame = renderObject("Frame", { Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Parent = Section })
                local Box = renderObject("TextButton", {
                    Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(0, 8, 0.5, -5),
                    BackgroundColor3 = default and Color3.fromRGB(160, 200, 50) or Color3.fromRGB(26, 26, 26),
                    BorderSizePixel = 1, BorderColor3 = Color3.fromRGB(45, 45, 45), Text = "", AutoButtonColor = false, ZIndex = 4, Parent = Frame
                })
                renderObject("TextLabel", {
                    Size = UDim2.new(1, -26, 1, 0), Position = UDim2.new(0, 26, 0, 0), BackgroundTransparency = 1,
                    Text = text, TextColor3 = Color3.fromRGB(195, 195, 195), Font = Enum.Font.Code, TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = Frame
                })
                Box.MouseButton1Click:Connect(function()
                    local enabled = not (Box.BackgroundColor3 == Color3.fromRGB(160, 200, 50))
                    Box.BackgroundColor3 = enabled and Color3.fromRGB(160, 200, 50) or Color3.fromRGB(26, 26, 26)
                    callback(enabled)
                end)
            end

            function SectionObj:CreateSlider(text, min, max, default, callback)
                local Frame = renderObject("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Parent = Section })
                local Label = renderObject("TextLabel", {
                    Size = UDim2.new(1, -12, 0, 14), Position = UDim2.new(0, 8, 0, 0), BackgroundTransparency = 1,
                    Text = text .. ": " .. tostring(default), TextColor3 = Color3.fromRGB(195, 195, 195), Font = Enum.Font.Code, TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = Frame
                })
                local SliderBG = renderObject("TextButton", {
                    Size = UDim2.new(1, -16, 0, 5), Position = UDim2.new(0, 8, 0, 16), BackgroundColor3 = Color3.fromRGB(26, 26, 26),
                    BorderSizePixel = 1, BorderColor3 = Color3.fromRGB(45, 45, 45), Text = "", AutoButtonColor = false, ZIndex = 4, Parent = Frame
                })
                local SliderFill = renderObject("Frame", {
                    Size = UDim2.new((default - min) / (max - min), 0, 1, 0), BackgroundColor3 = Color3.fromRGB(160, 200, 50),
                    BorderSizePixel = 0, ZIndex = 5, Parent = SliderBG
                })
                local sliding = false
                local function updateSlider(input)
                    local absPos = SliderBG.AbsolutePosition.X
                    local absSize = SliderBG.AbsoluteSize.X
                    local mousePos = input.Position.X
                    local percentage = math.clamp((mousePos - absPos) / absSize, 0, 1)
                    SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                    local value = math.round(min + (max - min) * percentage)
                    Label.Text = text .. ": " .. tostring(value)
                    callback(value)
                end
                SliderBG.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = true
                        updateSlider(input)
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        updateSlider(input)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = false end
                end)
            end

            function SectionObj:CreateDropdown(text, options, default, callback)
                local Frame = renderObject("Frame", { Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, Parent = Section })
                renderObject("TextLabel", {
                    Size = UDim2.new(1, -12, 0, 14), Position = UDim2.new(0, 8, 0, 0), BackgroundTransparency = 1,
                    Text = text, TextColor3 = Color3.fromRGB(195, 195, 195), Font = Enum.Font.Code, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame
                })
                local DropdownBtn = renderObject("TextButton", {
                    Size = UDim2.new(1, -16, 0, 16), Position = UDim2.new(0, 8, 0, 15), BackgroundColor3 = Color3.fromRGB(28, 28, 28),
                    BorderColor3 = Color3.fromRGB(45, 45, 45), BorderSizePixel = 1, Font = Enum.Font.Code, Text = "  " .. options[default or 1],
                    TextColor3 = Color3.fromRGB(180, 180, 180), TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = Frame
                })
                local currentIdx = default or 1
                DropdownBtn.MouseButton1Click:Connect(function()
                    currentIdx = currentIdx + 1
                    if currentIdx > #options then currentIdx = 1 end
                    DropdownBtn.Text = "  " .. options[currentIdx]
                    callback(options[currentIdx])
                end)
            end

            return SectionObj
        end
        return TabObj
    end
    return Window
end

return Library
