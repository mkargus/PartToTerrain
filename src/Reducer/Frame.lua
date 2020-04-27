return function(state, action)
  state = state or ""

  if action.type == 'SetFrame' then
    assert(typeof(action.frame) == 'string')
    return action.frame
  end

  return state
end
