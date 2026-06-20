local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Library = {}

-[span_3](start_span)- Вспомогательная функция для создания объектов[span_3](end_span)
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
    local Window = {}
    
    local ScreenGui = renderObject("ScreenGui", {
        Name = title or "Gamesense_Library",
        Parent = CoreGui or Players.LocalPlayer:WaitForChild("PlayerGui"),
        ResetOnSpawn = false
    })

    -[span_4](start_span)- Плавающая кнопка открытия[span_4](end_span)
    local ToggleButton = renderObject("ImageButton", {
        Name = "ToggleButton", Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0.05, 0, 0.1, 0),
        BackgroundColor3 = Color3.fromRGB(16, 16, 16), BorderColor3 = Color3.fromRGB(45, 45, 45),
        BorderSizePixel = 1, Image = "rbxassetid://113169443526288", ZIndex = 10, Parent = ScreenGui
    })
    renderObject("UICorner", { CornerRadius = UDim.new(0, 6), Parent = ToggleButton })

    local btnDragging, btnDragStart, btnStartPos
    ToggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            btnDragging = true; btnDragStart = input.Position; btnStartPos = ToggleButton.Position
        end
    end)
    ToggleButton.InputChanged:Connect(function(input)
        if btnDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - btnDragStart
            ToggleButton.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
        end
    end)
    ToggleButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then btnDragging = false end
    end)

    -[span_5](start_span)- Главное окно[span_5](end_span)
    local MainFrame = renderObject("Frame", {
        Name = "MainFrame", Size = UDim2.new(0, 560, 0, 420), Position = UDim2.new(0.5, -280, 0.5, -210),
        BackgroundColor3 = Color3.fromRGB(17, 17, 17), BorderSizePixel = 1, BorderColor3 = Color3.fromRGB(10, 10, 10),
        Active = true, Visible = false, Parent = ScreenGui
    })
    
    ToggleButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

    -[span_6](start_span)- Градиентная линия[span_6](end_span)
    local GlowBar = renderObject("Frame", { Size = UDim2.new(1, 0, 0, 3), BorderSizePixel = 0, ZIndex = 5, Parent = MainFrame })
    renderObject("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 175, 225)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 60, 180)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 200, 50))
        }), Parent = GlowBar
    })

    renderObject("Frame", {
        Size = UDim2.new(1, -2, 1, -2), Position = UDim2.new(0, 1, 0, 1), BackgroundTransparency = 1,
        BorderSizePixel = 1, BorderColor3 = Color3.fromRGB(45, 45, 45), ZIndex = 4, Parent = MainFrame
    })

    -[span_7](start_span)- Сайдбар и Контейнер[span_7](end_span)
    local Sidebar = renderObject("Frame", { Size = UDim2.new(0, 74, 1, -3), Position = UDim2.new(0, 0, 0, 3), BackgroundColor3 = Color3.fromRGB(12, 12, 12), BorderSizePixel = 0, ZIndex = 2, Parent = MainFrame })
    local SidebarLayout = renderObject("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Top, Parent = Sidebar })
    
    renderObject("Frame", { Size = UDim2.new(0, 1, 1, -3), Position = UDim2.new(0, 74, 0, 3), BackgroundColor3 = Color3.fromRGB(40, 40, 40), BorderSizePixel = 0, Parent = MainFrame })
    
    local Container = renderObject("Frame", { Size = UDim2.new(1, -75, 1, -3), Position = UDim2.new(0, 75, 0, 3), BackgroundColor3 = Color3.fromRGB(17, 17, 17), Parent = MainFrame })
    renderObject("ImageLabel", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Image = "rbxassetid://8509210785", ImageColor3 = Color3.fromRGB(15, 15, 15), ScaleType = Enum.ScaleType.Tile, TileSize = UDim2.new(0, 8, 0, 8), ZIndex = 0, Parent = Container })

    -[span_8](start_span)- Драг окна[span_8](end_span)
    local dragToggle, dragStart, startPos = false, nil, nil
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true; dragStart = input.Position; startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggle = false end
    end)

    Window.Pages = {}
    Window.TabFrames = {}
    Window.FirstTab = true

    function Window:CreateTab(name, iconId)
        local TabObj = {}
        local isDefault = self.FirstTab
        self.FirstTab = false

        local Page_Tab = renderObject("Frame", {
            Size = isDefault and UDim2.new(0, 75, 0, 55) or UDim2.new(0, 74, 0, 55), BorderSizePixel = 0,
            BackgroundColor3 = isDefault and Color3.fromRGB(17, 17, 17) or Color3.fromRGB(12, 12, 12), ClipsDescendants = true, Parent = Sidebar
        })
        local Pattern = renderObject("ImageLabel", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Image = "rbxassetid://8509210785",
            ImageColor3 = Color3.fromRGB(14, 14, 14), ScaleType = Enum.ScaleType.Tile, TileSize = UDim2.new(0, 8, 0, 8), Visible = isDefault, ZIndex = 1, Parent = Page_Tab
        })
        local Page_Tab_Image = renderObject("ImageLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 38, 0, 38), Position = UDim2.new(0, 37, 0.5, 0),
            BackgroundTransparency = 1, Image = iconId or "rbxassetid://8547236654", ImageColor3 = isDefault and Color3.fromRGB(160, 200, 50) or Color3.fromRGB(80, 80, 80), ZIndex = 2, Parent = Page_Tab
        })
        local Page_Tab_Button = renderObject("TextButton", { Size = UDim2.new(0, 74, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 3, Parent = Page_Tab })
        
        local Page = renderObject("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = isDefault, ZIndex = 2, Parent = Container })
        
        self.Pages[name] = Page
        self.TabFrames[name] = {Frame = Page_Tab, Icon = Page_Tab_Image, Pattern = Pattern}

        Page_Tab_Button.MouseButton1Click:Connect(function()
            for n, t in pairs(self.TabFrames) do
                self.Pages[n].Visible = false
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
            local pos = side == "Right" and UDim2.new(0.5, 4, 0, 10) or UDim2.new(0, 8, 0, 10)
            
            local Section = renderObject("ScrollingFrame", {
                Size = UDim2.new(0.5, -12, 1, -20), Position = pos, BackgroundColor3 = Color3.fromRGB(21, 21, 21),
                BorderColor3 = Color3.fromRGB(35, 35, 35), BorderSizePixel = 1, ScrollBarThickness = 2,
                CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 2, Parent = Page
            })
            renderObject("TextLabel", {
                Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Text = "<b>  " .. sectionName:upper() .. "</b>",
                TextColor3 = Color3.fromRGB(230, 230, 230), Font = Enum.Font.Code, TextSize = 10, RichText = true,
                TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3, Parent = Section
            })
            renderObject("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Section })

            -- ================= Обычная кнопка =================
            function SectionObj:CreateButton(text, callback)
                local Frame = renderObject("Frame", { Size = UDim2.new(1, -16, 0, 25), Position = UDim2.new(0, 8, 0, 0), BackgroundTransparency = 1, Parent = Section })
                local Btn = renderObject("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(26, 26, 26),
                    BorderSizePixel = 1, BorderColor3 = Color3.fromRGB(45, 45, 45), Text = text,
                    TextColor3 = Color3.fromRGB(195, 195, 195), Font = Enum.Font.Code, TextSize = 11, AutoButtonColor = true, ZIndex = 4, Parent = Frame
                })
                Btn.MouseButton1Click:Connect(function() if callback then callback() end end)
            end

            -- ================= Чекбокс (Toggle) =================
            function SectionObj:CreateToggle(text, default, callback)
                local Frame = renderObject("Frame", { Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Parent = Section })
                local Box = renderObject("TextButton", {
                    Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(0, 8, 0.5, -5),
                    BackgroundColor3 = default and Color3.fromRGB(160, 200, 50) or Color3.fromRGB(26, 26, 26),
                    BorderSizePixel = 1, BorderColor3 = Color3.fromRGB(45, 45, 45), Text = "", AutoButtonColor = false, ZIndex = 4, Parent = Frame
                })
                renderObject("TextLabel", {
                    Size = UDim2.new(1, -26, 1, 0), Position = UDim2.new(0, 26, 0, 0), BackgroundTransparency = 1,
                    Text = text, TextColor3 = Color3.fromRGB(195, 195, 195), Font = Enum.Font.Code, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = Frame
                })
                local enabled = default or false
                Box.MouseButton1Click:Connect(function()
                    enabled = not enabled
                    Box.BackgroundColor3 = enabled and Color3.fromRGB(160, 200, 50) or Color3.fromRGB(26, 26, 26)
                    if callback then callback(enabled) end
                end)
            end

            -- ================= Слайдер =================
            function SectionObj:CreateSlider(text, min, max, default, callback)
                local Frame = renderObject("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Parent = Section })
                local Label = renderObject("TextLabel", {
                    Size = UDim2.new(1, -12, 0, 14), Position = UDim2.new(0, 8, 0, 0), BackgroundTransparency = 1,
                    Text = text .. ": " .. tostring(default), TextColor3 = Color3.fromRGB(195, 195, 195), Font = Enum.Font.Code, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = Frame
                })
                local SliderBG = renderObject("TextButton", {
                    Size = UDim2.new(1, -16, 0, 5), Position = UDim2.new(0, 8, 0, 16), BackgroundColor3 = Color3.fromRGB(26, 26, 26),
                    BorderSizePixel = 1, BorderColor3 = Color3.fromRGB(45, 45, 45), Text = "", AutoButtonColor = false, ZIndex = 4, Parent = Frame
                })
                local SliderFill = renderObject("Frame", {
                    Size = UDim2.new((default - min) / (max - min), 0, 1, 0), BackgroundColor3 = Color3.fromRGB(160, 200, 50), BorderSizePixel = 0, ZIndex = 5, Parent = SliderBG
                })
                
                local sliding = false
                local function updateSlider(input)
                    local absPos = SliderBG.AbsolutePosition.X
                    local absSize = SliderBG.AbsoluteSize.X
                    local percentage = math.clamp((input.Position.X - absPos) / absSize, 0, 1)
                    SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                    local value = math.round(min + (max - min) * percentage)
                    Label.Text = text .. ": " .. tostring(value)
                    if callback then callback(value) end
                end

                SliderBG.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = true; updateSlider(input)
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = false end
                end)
            end

            -- ================= Выпадающий список =================
            function SectionObj:CreateDropdown(text, options, defaultIdx, callback)
                local Frame = renderObject("Frame", { Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, Parent = Section })
                renderObject("TextLabel", {
                    Size = UDim2.new(1, -12, 0, 14), Position = UDim2.new(0, 8, 0, 0), BackgroundTransparency = 1,
                    Text = text, TextColor3 = Color3.fromRGB(195, 195, 195), Font = Enum.Font.Code, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame
                })
                local DropdownBtn = renderObject("TextButton", {
                    Size = UDim2.new(1, -16, 0, 16), Position = UDim2.new(0, 8, 0, 15), BackgroundColor3 = Color3.fromRGB(28, 28, 28),
                    BorderColor3 = Color3.fromRGB(45, 45, 45), BorderSizePixel = 1, Font = Enum.Font.Code, Text = "  " .. options[defaultIdx or 1],
                    TextColor3 = Color3.fromRGB(180, 180, 180), TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = Frame
                })
                local currentIdx = defaultIdx or 1
                DropdownBtn.MouseButton1Click:Connect(function()
                    currentIdx = currentIdx + 1
                    if currentIdx > #options then currentIdx = 1 end
                    DropdownBtn.Text = "  " .. options[currentIdx]
                    if callback then callback(options[currentIdx]) end
                end)
            end

            -- ================= Колор пикер (Простой RGB) =================
            function SectionObj:CreateColorPicker(text, defaultColor, callback)
                local Frame = renderObject("Frame", { Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Parent = Section })
                renderObject("TextLabel", {
                    Size = UDim2.new(1, -30, 1, 0), Position = UDim2.new(0, 8, 0, 0), BackgroundTransparency = 1,
                    Text = text, TextColor3 = Color3.fromRGB(195, 195, 195), Font = Enum.Font.Code, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = Frame
                })
                
                local ColorBtn = renderObject("TextButton", {
                    Size = UDim2.new(0, 16, 0, 10), Position = UDim2.new(1, -24, 0.5, -5),
                    BackgroundColor3 = defaultColor or Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 1, BorderColor3 = Color3.fromRGB(45, 45, 45), Text = "", AutoButtonColor = false, ZIndex = 4, Parent = Frame
                })

                -- Простая логика: при клике генерируем случайный цвет (Для полноценной палитры нужно создавать отдельное окно с HSV мапой)
                ColorBtn.MouseButton1Click:Connect(function()
                    local r, g, b = math.random(50, 255), math.random(50, 255), math.random(50, 255)
                    local newColor = Color3.fromRGB(r, g, b)
                    ColorBtn.BackgroundColor3 = newColor
                    if callback then callback(newColor) end
                end)
            end

            return SectionObj
        end
        
        return TabObj
    end

    return Window
end

_G.Library = Library
return Library
