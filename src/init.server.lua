-- Made By Fastcar48
local version = '1.2.2'

-- Services
local mouse = plugin:GetMouse()
local marketplaceService = game:GetService('MarketplaceService')
local runService = game:GetService('RunService')
local materialList = require(script.materialList)
local outlineManager = require(script.outlineManager)
local settingsList = require(script.settingsList)
local terrainConverter = require(script.terrainConverter)
local Roact = require(script.Roact)
-- Deprecated
local uiBuilder = require(script.uiBuilder)

-- Settings
for _, settings in pairs(settingsList) do
  if plugin:GetSetting(settings.id) == nil then
    plugin:SetSetting(settings.id, settings.defaultValue)
  end
end

local enabled = false
local materialSelected = Enum.Material.Air
local currentTooltip = ''

local button = plugin:CreateToolbar('Fasty48'):CreateButton('Part to Terrain','Convert parts into terrain with ease.','rbxassetid://297321964')

------------------------
-- UI
------------------------
local ui = plugin:CreateDockWidgetPluginGui('PartToTerrain', DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, true, 300, 300, 220, 265))
ui.Title = 'Part to Terrain '..version
ui.Name = 'PartToTerrain'

local mainFrame = uiBuilder:createElement('Frame', {
  Parent = ui,
  Size = UDim2.new(1,0,1,0),
  BackgroundColor3 = Enum.StudioStyleGuideColor.MainBackground
})

-- Nav Frame
local navBar = uiBuilder:createElement('Frame', {
  Parent = mainFrame,
  Size = UDim2.new(1,0,0,25),
  BackgroundColor3 = Enum.StudioStyleGuideColor.InputFieldBorder
})

local navMaterial = uiBuilder:createElement('TextButton', {
  Parent = navBar,
  BackgroundColor3 = Enum.StudioStyleGuideColor.MainBackground,
  Size = UDim2.new(0.5,0,1,0),
  Font = 'SourceSans',
  Text = 'Materials',
  TextColor3 = Enum.StudioStyleGuideColor.MainText,
  TextSize = 14
})

local navSettings = uiBuilder:createElement('TextButton', {
  Parent = navBar,
  BackgroundColor3 = Enum.StudioStyleGuideColor.MainBackground,
  BackgroundTransparency = 1,
  Position = UDim2.new(0.5,0,0,0),
  Size = UDim2.new(0.5,0,1,0),
  Font = 'SourceSans',
  Text = 'Settings',
  TextColor3 = Enum.StudioStyleGuideColor.MainText,
  TextSize = 14
})

-- Material Selection Frame
local materialFrame = uiBuilder:createElement('ScrollingFrame', {
  BackgroundTransparency = 1,
  Parent = mainFrame,
  Position = UDim2.new(0,5,0,30),
  ScrollBarImageColor3 = Enum.StudioStyleGuideColor.Mid,
  BottomImage = 'rbxasset://textures/StudioToolbox/ScrollBarBottom.png',
  MidImage = 'rbxasset://textures/StudioToolbox/ScrollBarMiddle.png',
  TopImage = 'rbxasset://textures/StudioToolbox/ScrollBarTop.png',
  ScrollBarThickness = 7,
  Size = UDim2.new(1,-10,1,-35)
})

local materialUIList = uiBuilder:createElement('UIGridLayout', { CellPadding = UDim2.new(0,5,0,5), CellSize = UDim2.new(0,45,0,45), Parent = materialFrame })
materialUIList:GetPropertyChangedSignal('AbsoluteContentSize'):connect(function()
  materialFrame.CanvasSize = UDim2.new(0,0,0,materialUIList.AbsoluteContentSize.Y)
end)

local selectionHover = uiBuilder:createElement('TextLabel', {
  Parent = mainFrame,
  BackgroundTransparency = .4,
  BackgroundColor3 = Enum.StudioStyleGuideColor.MainBackground,
  Font = 'SourceSans',
  TextColor3 = Enum.StudioStyleGuideColor.MainText,
  TextSize = 14,
  TextWrapped = false,
  Visible = false
})

local selectionImage = uiBuilder:createElement('ImageLabel', {
  BackgroundTransparency = 1,
  Position = UDim2.new(.5,0,0,0),
  Size = UDim2.new(.5,0,.5,0),
  Image = 'rbxasset://textures/AvatarEditorImages/Portrait/gr-selection-corner-phone@3x.png'
})

-- Settings Frame
local settingsFrame = uiBuilder:createElement('ScrollingFrame', {
  BackgroundTransparency = 1,
  Parent = mainFrame,
  Position = UDim2.new(0,5,0,30),
  ScrollBarImageColor3 = Enum.StudioStyleGuideColor.Mid,
  BottomImage = 'rbxasset://textures/StudioToolbox/ScrollBarBottom.png',
  MidImage = 'rbxasset://textures/StudioToolbox/ScrollBarMiddle.png',
  TopImage = 'rbxasset://textures/StudioToolbox/ScrollBarTop.png',
  ScrollBarThickness = 7,
  Size = UDim2.new(1,-10,1,-35),
  Visible = false
})

local settingList = uiBuilder:createElement('UIListLayout', { Padding = UDim.new(0,5), Parent = settingsFrame })
settingList:GetPropertyChangedSignal('AbsoluteContentSize'):connect(function()
  settingsFrame.CanvasSize = UDim2.new(0,0,0,settingList.AbsoluteContentSize.Y)
end)

-- Update Notice
if plugin:GetSetting('CheckUpdates') then
  local success, info = pcall(marketplaceService.GetProductInfo, marketplaceService, 2673110695)
  if success and info.Description ~= version then
    uiBuilder:createElement('TextLabel', {
      Parent = ui,
      BackgroundColor3 = Enum.StudioStyleGuideColor.WarningText,
      Position = UDim2.new(0,0,1,-20),
      Size = UDim2.new(1,0,0,20),
      Font = 'SourceSans',
      Text = info.Description..' is now available to download!',
      TextColor3 = Enum.StudioStyleGuideColor.Light,
      TextSize = 14
    })
    materialFrame.Size = UDim2.new(1,-10,1,-55)
    settingsFrame.Size = UDim2.new(1,-10,1,-55)
  end
end
------------------------
-- Fill UI
------------------------

-- Material
for _, material in pairs(materialList) do
  local materialBtn = Roact.createElement('ImageButton', {
    BackgroundTransparency = 1,
    Image = material.img,
    [Roact.Event.MouseButton1Click] = function(self)
      materialSelected = material.enum
      selectionImage.Parent = self
    end,
    [Roact.Event.MouseEnter] = function()
      currentTooltip = material.text
      selectionHover.Visible = true
      selectionHover.Text = material.text
      selectionHover.Size = UDim2.new(0,selectionHover.TextBounds.X+5,0,selectionHover.TextBounds.Y+5)
    end,
    [Roact.Event.MouseMoved] = function(self, x, y)
      selectionHover.Position = UDim2.new(0,x-10,0,y-20)
    end,
    [Roact.Event.MouseLeave] = function()
      if currentTooltip == material.text then
        selectionHover.Visible = false
      end
    end
  })
  Roact.mount(materialBtn, materialFrame, material.enum.Name)
end

-- Settings
for _, settings in pairs(settingsList) do
  local isExpanded = false

  local settingItem = uiBuilder:createElement('Frame', {
    Parent = settingsFrame,
    Size = UDim2.new(1,-12,0,30),
    BackgroundColor3 = Enum.StudioStyleGuideColor.Shadow,
    ClipsDescendants = true
  })

  uiBuilder:createElement('TextLabel', {
    Parent = settingItem,
    BackgroundTransparency = 1,
    Font = 'SourceSans',
    Size = UDim2.new(1,-55,0,30),
    Text = ' '..settings.label,
    TextColor3 = Enum.StudioStyleGuideColor.MainText,
    TextSize = 14,
    TextWrapped = true,
    TextXAlignment = 'Left'
  })

  local check = uiBuilder:createElement('ImageButton', {
    Parent = settingItem,
    BackgroundColor3 = Enum.StudioStyleGuideColor.MainBackground,
    ImageColor3 = Enum.StudioStyleGuideColor.MainText,
    Image = plugin:GetSetting(settings.id) and 'rbxasset://textures/ui/LuaChat/icons/ic-check@3x.png' or '',
    Position = UDim2.new(1,-50,0,5),
    Size = UDim2.new(0,20,0,20),
  })

  local expand = uiBuilder:createElement('ImageButton', {
    Parent = settingItem,
    BackgroundTransparency = 1,
    ImageColor3 = Enum.StudioStyleGuideColor.MainText,
    Image = 'rbxasset://textures/ui/LuaChat/icons/ic-back@2x.png',
    Position = UDim2.new(1,-25,0,5),
    Size = UDim2.new(0,20,0,20),
    Rotation = 270
  })

  uiBuilder:createElement('TextLabel', {
    Parent = settingItem,
    BackgroundColor3 = Enum.StudioStyleGuideColor.InputFieldBorder,
    Font = 'SourceSans',
    Position = UDim2.new(0,0,0,30),
    Size = UDim2.new(1,0,0,80),
    Text = ' '..settings.description,
    TextColor3 = Enum.StudioStyleGuideColor.MainText,
    TextSize = 14,
    TextWrapped = true,
    TextXAlignment = 'Left'
  })

  expand.MouseButton1Click:connect(function()
    isExpanded = not isExpanded
    settingItem.Size = isExpanded and UDim2.new(1,-12,0,110) or UDim2.new(1,-12,0,30)
    expand.Rotation = isExpanded and 90 or 270
  end)

  check.MouseButton1Click:connect(function()
    plugin:SetSetting(settings.id, not plugin:GetSetting(settings.id))
    check.Image = plugin:GetSetting(settings.id) and 'rbxasset://textures/ui/LuaChat/icons/ic-check@3x.png' or ''
  end)
end

------------------------
-- Functions
------------------------
local function activate(bool)
  enabled = bool
  button:SetActive(bool)
  plugin:Activate(bool)
  ui.Enabled = bool
  if not bool then
    outlineManager:Hide()
  end
end

local function ActiveFrame(frame, btn)
  navMaterial.BackgroundTransparency = 1
  navSettings.BackgroundTransparency = 1
  materialFrame.Visible = false
  settingsFrame.Visible = false
  frame.Visible = true
  btn.BackgroundTransparency = 0
end

------------------------
-- Events
------------------------
navMaterial.MouseButton1Click:connect(function()
  ActiveFrame(materialFrame, navMaterial)
end)

navSettings.MouseButton1Click:connect(function()
  ActiveFrame(settingsFrame, navSettings)
end)

ui:BindToClose(function()
  activate(false)
end)

plugin.Unloading:connect(function()
  activate(false)
  outlineManager:Destroy()
end)

plugin.Deactivation:connect(function()
  if enabled and ui.Enabled then
    activate(false)
  end
end)

if runService:IsStudio() and not runService:IsRunning() then
  button.Click:connect(function()
    activate(not enabled)
  end)
else
  button.Enabled = false
end

mouse.Button1Down:connect(function()
  if enabled and mouse.Target then
    local success, err = pcall(function() terrainConverter:Convert(mouse.Target, materialSelected, plugin:GetSetting('DeletePart')) end)
    if not success then
      local message = uiBuilder:createElement('TextLabel', {
        Parent = ui,
        BackgroundColor3 = Enum.StudioStyleGuideColor.ErrorText,
        Size = UDim2.new(1,0,0,20),
        Font = 'SourceSans',
        Text = err,
        TextColor3 = Enum.StudioStyleGuideColor.Light,
        TextSize = 16
      })
      game.Debris:AddItem(message, 5)
    end
  end
end)

mouse.Move:connect(function()
  local part = mouse.Target
  if enabled and plugin:GetSetting('EnabledSelectionBox') and part then
    outlineManager:Set(part)
  end
end)
