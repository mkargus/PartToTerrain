return {
  {
    id = 'CheckUpdates',
    defaultValue = true,
    label = 'Check for updates',
    description = 'If checked, the plugin will check for updates at Studio launch and display a notice on the plugin when outdated. If unchecked, the plugin will not for any updates.'
  },
  {
    id = 'DeletePart',
    defaultValue = true,
    label = 'Delete part when converted',
    description = 'If checked, the part used to be converted will be delete. If unchecked, it will stay in the Workspace when converted.'
  },
  {
    id = 'EnabledSelectionBox',
    defaultValue = true,
    label = 'Enable SelectionBox when hovered',
    description = 'Allow a SelectionBox overlay when the mouse is hovering over a part.'
  },
  {
    id = 'IgnoreLockedParts',
    defaultValue = false,
    label = 'Ignore locked parts',
    description = 'Parts with their Locked property set to true will not be converted.'
  }
}
