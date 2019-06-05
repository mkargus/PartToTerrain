stds.roblox = {
  globals = {
    "game", "plugin"
  },
  read_globals = {
    -- Roblox globals
    "script", "workspace",

    -- Extra functions
    "tick", "warn", "spawn",
    "wait", "settings", "typeof",

    -- Types
    "Vector2", "Vector3",
    "Color3",
    "UDim", "UDim2",
    "Rect",
    "CFrame",
    "Enum",
    "Instance",
    "DockWidgetPluginGuiInfo"
  }
}

max_line_length = false

ignore = {
  "212", -- unused arguments
  "421", -- shadowing local variable
  "422", -- shadowing argument
  "431", -- shadowing upvalue
  "432", -- shadowing upvalue argument
}

std = "lua51+roblox"
