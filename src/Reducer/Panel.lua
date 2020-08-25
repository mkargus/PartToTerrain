return function(state, action)
  state = state or ""

  if action.type == 'SetPanel' then
    assert(typeof(action.panel) == 'string')
    return action.panel
  end

  return state
end
