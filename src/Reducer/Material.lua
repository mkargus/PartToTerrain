return function(state, action)
  state = state or ""

  if action.type == 'SetMaterial' then
    assert(typeof(action.material) == 'EnumItem')
    return action.material
  end

  return state
end
