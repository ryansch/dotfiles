local spoon_install = hs.loadSpoon("SpoonInstall")
spoon_install:andUse("EmmyLua")

local Packer = hs.loadSpoon("Packer")
local packer = Packer:new()

packer
  :setLogLevel('info')
  :setSpoonDir("Packer")
  :bindHotKeys({ update = { {'cmd', 'shift'}, 'u' }})
  :use('dbalatero/VimMode.spoon', function(VimMode)
    local vim = VimMode:new()
    vim
      :disableForApp("iTerm")
      :disableForApp("kitty")
      :disableForApp("Terminal")
      :disableForApp("Code")
      :enterWithSequence("jk", 100)

    vim:useFallbackMode("Brave")
    vim:useFallbackMode("Chrome")
    vim:useFallbackMode("Firefox")
  end)
  :activate()

--
-- If the ipc program is not installed, then install it. This also enables the ipc
-- commands to work.
--
if hs.ipc.cliStatus() == false then
  hs.ipc.cliInstall()
end

hs.window.animationDuration = 0

local units = {
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

local windowModeAlertWindow = nil
local windowMode = hs.hotkey.modal.new({}, nil, nil)

local function leaveMode()
  if windowModeAlertWindow ~= nil then
    hs.alert.closeSpecific(windowModeAlertWindow, 0)
    windowModeAlertWindow = nil
  end
  windowMode:exit()
end

hs.hotkey.bind({ 'option' }, 'delete', function()
  windowMode:enter()
  windowModeAlertWindow = hs.alert.show('Window Mode', {
      strokeColor = hs.drawing.color.x11.orangered,
      fillColor = hs.drawing.color.x11.cyan,
      textColor = hs.drawing.color.x11.black,
      strokeWidth = 20,
      radius = 30,
      textSize = 128,
      fadeInDuration = 0,
      atScreenEdge = 0
    }, 'infinite')
end)

windowMode:bind({ 'ctrl' }, 'space', function() leaveMode() end)
windowMode:bind({}, 'escape', function() leaveMode() end)

windowMode:bind({}, 'a', function() hs.window.focusedWindow():move(units.left50,    hs.mouse.getCurrentScreen(), true); leaveMode() end)
windowMode:bind({}, 's', function() hs.window.focusedWindow():move(units.right50,   hs.mouse.getCurrentScreen(), true); leaveMode() end)
windowMode:bind({}, 'd', function() hs.window.focusedWindow():move(units.maximum,   hs.mouse.getCurrentScreen(), true); leaveMode() end)
windowMode:bind({}, 'f', function() hs.window.focusedWindow():move(units.fill,      hs.mouse.getCurrentScreen(), true); leaveMode() end)
