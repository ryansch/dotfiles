hs.loadSpoon("SpoonInstall")

hs.window.animationDuration = 0

units = {
  right50       = { x = 0.50, y = 0.00, w = 0.50, h = 1.00 },
  left50        = { x = 0.00, y = 0.00, w = 0.50, h = 1.00 },
  right30       = { x = 0.70, y = 0.00, w = 0.30, h = 1.00 },
  right70       = { x = 0.30, y = 0.00, w = 0.70, h = 1.00 },
  left70        = { x = 0.00, y = 0.00, w = 0.70, h = 1.00 },
  left30        = { x = 0.00, y = 0.00, w = 0.30, h = 1.00 },
  top50         = { x = 0.00, y = 0.00, w = 1.00, h = 0.50 },
  bot50         = { x = 0.00, y = 0.50, w = 1.00, h = 0.50 },
  upright30     = { x = 0.70, y = 0.00, w = 0.30, h = 0.50 },
  botright30    = { x = 0.70, y = 0.50, w = 0.30, h = 0.50 },
  upleft70      = { x = 0.00, y = 0.00, w = 0.70, h = 0.50 },
  botleft70     = { x = 0.00, y = 0.50, w = 0.70, h = 0.50 },
  fill          = { x = 0.05, y = 0.05, w = 0.90, h = 0.90 },
  maximum       = { x = 0.00, y = 0.00, w = 1.00, h = 1.00 }
}

windowModeAlertWindow = nil
windowMode = hs.hotkey.modal.new({}, nil, nil)

function leaveMode()
  if windowModeAlertWindow ~= nil then
    hs.alert.closeSpecific(windowModeAlertWindow, 0)
    windowModeAlertWindow = nil
  end
  windowMode:exit()
end

hs.hotkey.bind({ 'ctrl' }, 'space', function()
  windowMode:enter()
  windowModeAlertWindow = hs.alert.show('Window Mode', {
      strokeColor = hs.drawing.color.x11.orangered,
      fillColor = hs.drawing.color.x11.cyan,
      textColor = hs.drawing.color.x11.black,
      strokeWidth = 20,
      radius = 30,
      textSize = 128,
      fadeInDuration = 0,
      atScreenEdge = 2
    }, 'infinite')
end)

windowMode:bind({ 'ctrl' }, 'space', function() leaveMode() end)
windowMode:bind({}, 'escape', function() leaveMode() end)

windowMode:bind({}, 'a', function() hs.window.focusedWindow():move(units.left50,    hs.mouse.getCurrentScreen(), true); leaveMode() end)
windowMode:bind({}, 's', function() hs.window.focusedWindow():move(units.right50,   hs.mouse.getCurrentScreen(), true); leaveMode() end)
windowMode:bind({}, 'd', function() hs.window.focusedWindow():move(units.maximum,   hs.mouse.getCurrentScreen(), true); leaveMode() end)
windowMode:bind({}, 'f', function() hs.window.focusedWindow():move(units.fill,      hs.mouse.getCurrentScreen(), true); leaveMode() end)
