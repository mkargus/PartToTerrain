-- Made By Fastcar48
local version = '1.1.0-dev'
local sp = script.Parent

-- Services
local mouse = plugin:GetMouse()
local marketplaceService = game:GetService('MarketplaceService')
local runService = game:GetService('RunService')
local materialList = require(sp.materialList)
local outlineManager = require(sp.outlineManager)
local settingsList = require(sp.settingsList)
local terrainConverter = require(sp.terrainConverter)
local uiBuilder = require(sp.uiBuilder)

-- Settings
for _, settings in pairs(settingsList) do
  if plugin:GetSetting(settings.id) == nil then
    plugin:SetSetting(settings.id, settings.defaultValue)
  end
end

local enabled = false
local materialSelected = Enum.Material.Air

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

-- Bottom Bar Frame
local bottomBar = uiBuilder:createElement('Frame', {
  Parent = mainFrame,
  Size = UDim2.new(1,0,0,30),
  Position = UDim2.new(0,0,1,-30),
  BackgroundColor3 = Enum.StudioStyleGuideColor.InputFieldBorder
})

local bottomMaterial = uiBuilder:createElement('TextButton', {
  Parent = bottomBar,
  BackgroundColor3 = Enum.StudioStyleGuideColor.ButtonBorder,
  Position = UDim2.new(0,5,0,5),
  Size = UDim2.new(0.5,-10,0,20),
  Font = 'SourceSans',
  Text = 'Materials',
  TextColor3 = Enum.StudioStyleGuideColor.MainText,
  TextSize = 14
})

local bottomSettings = uiBuilder:createElement('TextButton', {
  Parent = bottomBar,
  BackgroundColor3 = Enum.StudioStyleGuideColor.ButtonBorder,
  Position = UDim2.new(0.5,5,0,5),
  Size = UDim2.new(0.5,-10,0,20),
  Font = 'SourceSans',
  Text = 'Settings',
  TextColor3 = Enum.StudioStyleGuideColor.MainText,
  TextSize = 14
})

-- Material Selection Frame
local materialFrame = uiBuilder:createElement('ScrollingFrame', {
  BackgroundTransparency = 1,
  Parent = mainFrame,
  Position = UDim2.new(0,5,0,5),
  CanvasSize = UDim2.new(0,0,0,295),
  ScrollBarImageColor3 = Enum.StudioStyleGuideColor.InputFieldBorder,
  ScrollBarThickness = 7,
  Size = UDim2.new(1,-10,1,-40)
})

uiBuilder:CreateGrid('UIGridLayout', { CellPadding = UDim2.new(0,5,0,5), CellSize = UDim2.new(0,45,0,45), Parent = materialFrame })
local selectionHover = uiBuilder:createElement('TextLabel', {
  BackgroundTransparency = .4,
  BackgroundColor3 = Enum.StudioStyleGuideColor.MainBackground,
  Size = UDim2.new(1,0,1,0),
  Font = 'SourceSans',
  TextColor3 = Enum.StudioStyleGuideColor.MainText,
  TextSize = 14,
  TextWrapped = true
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
  CanvasSize = UDim2.new(0,0,0,51),
  Parent = mainFrame,
  Position = UDim2.new(0,5,0,5),
  ScrollBarImageColor3 = Enum.StudioStyleGuideColor.InputFieldBorder,
  ScrollBarThickness = 7,
  Size = UDim2.new(1,-10,1,-40),
  Visible = false
})
uiBuilder:CreateGrid('UIListLayout', { Padding = UDim.new(0,1), Parent = settingsFrame })

------------------------
-- Fill UI
------------------------

-- Material
for _, material in pairs(materialList) do
  local materialBtn = uiBuilder:createElement('ImageButton', { Parent = materialFrame, Image = material.img, Active = true })
  materialBtn.MouseButton1Click:connect(function()
    materialSelected = material.enum
    selectionImage.Parent = materialBtn
  end)
  materialBtn.MouseEnter:connect(function()
    selectionHover.Visible = true
    selectionHover.Parent = materialBtn
    selectionHover.Text = material.text
  end)
  materialBtn.MouseLeave:connect(function()
    selectionHover.Visible = false
  end)
end

if plugin:GetSetting('CheckUpdates') then
  local success, info = pcall(marketplaceService.GetProductInfo, marketplaceService, 2673110695)
  if success and info.Description ~= version then
    uiBuilder:createElement('TextLabel', {
      Parent = ui,
      BackgroundColor3 = Enum.StudioStyleGuideColor.WarningText,
      Size = UDim2.new(1,0,0,20),
      Font = 'SourceSans',
      Text = info.Description..' is now available to download!',
      TextColor3 = Enum.StudioStyleGuideColor.Light,
      TextSize = 14
    })
    mainFrame.Position = UDim2.new(0,0,0,20)
    mainFrame.Size = UDim2.new(1,0,1,-20)
  end
end

------------------------
-- UI input
------------------------
local function ActiveFrame(frame)
  materialFrame.Visible = false
  settingsFrame.Visible = false
  frame.Visible = true
end

local function changeSettings(settingId, ui)
  local value = not plugin:GetSetting(settingId)
  plugin:SetSetting(settingId, value)
  if plugin:GetSetting(settingId) then
    ui.ImageButton.Image = 'rbxasset://textures/ui/LuaChat/icons/ic-check@3x.png'
  else
    ui.ImageButton.Image = ''
  end

end

bottomMaterial.MouseButton1Click:connect(function()
  ActiveFrame(materialFrame)
end)

bottomSettings.MouseButton1Click:connect(function()
  ActiveFrame(settingsFrame)
end)

-- Settings
for _, settings in pairs(settingsList) do
  local settingBtn = uiBuilder:CreateSettingBtn(settingsFrame, settings.label, plugin:GetSetting(settings.id), settings.description)
  settingBtn.ImageButton.MouseButton1Click:connect(function()
    changeSettings(settings.id, settingBtn)
  end)
end

------------------------
-- Inputs
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

--MOUSE
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
  if enabled and part then
    outlineManager:Set(part)
  end
end)
