-- load "secret" or server specific configurations
-- example file format
---------------- 
-- local _M = {}
-- _M.iMessage = {
--     me = "myImessageAddress"
-- }
-- return _M
----------------
-- load the config
local config = dofile(os.getenv( "HOME" ).."/.hammerspoon.env.lua")

-- a place to store hotkey objects for later manipulation
-- toggle functions at bottom of file (after all of the toggly keys are put in the togglyHotkeys table)
togglyHotkeys = {} -- when binding a hotkey, add it to this table to allow it to be toggled of and on

-- set some booleans that indicate what host we are on (os.getenv('HOST') does not work, HOST is not set in this context)
isPersonalHost=false
isWorkHost=false
for k,v in pairs(hs.host.names()) do
  if string.match(v, config.hostname.personal) then
    isPersonalHost
  =true
  end
  if string.match(v, config.hostname.work) then
    isWorkHost=true
  end
end


--------------------
-- NoZ
-- Create a menu item to toggle sleep (z's) on and off
--------------------
noz = hs.menubar.new()
isNoz = true -- start true, causing initial load to toggle to false, --> sleep works by default
function setNozDisplay(state)
    if state then
      local handle = io.popen("sudo "..os.getenv("HOME").."/bin/macos-enablesleep.sh")
      local result = handle:read("*a")
      handle:close()
      noz:setTitle('|-[') -- sleepyface
      isNoz=false
    else
      local handle = io.popen("sudo "..os.getenv("HOME").."/bin/macos-disablesleep.sh")
      local result = handle:read("*a")
      handle:close()
      noz:setTitle('8-]') -- tweakingface
      isNoz=true
    end
end
function nozClicked()
  setNozDisplay(isNoz)
end
if noz then
  noz:setClickCallback(nozClicked)
  setNozDisplay(isNoz)
end
--------------------


hs.window.animationDuration = 0

-------------------------------------------------------------
-- Window Management
-----------------------------------------------------------

units = {
  right50 = { x = 0.50, y = 0.00, w = 0.50, h = 1.00 },
  right75 = { x = 0.25, y = 0.00, w = 0.75, h = 1.00 },
  left50 = { x = 0.00, y = 0.00, w = 0.50, h = 1.00 },
  left75 = { x = 0.00, y = 0.00, w = 0.75, h = 1.00 },
  top50 = { x = 0.00, y = 0.00, w = 1.00, h = 0.50 },
  top75 = { x = 0.00, y = 0.00, w = 1.00, h = 0.75 },
  bot50 = { x = 0.00, y = 0.50, w = 1.00, h = 0.50 },
  bot75 = { x = 0.00, y = 0.25, w = 1.00, h = 0.75 },
  upright = { x = 0.50, y = 0.00, w = 0.50, h = 0.50 },
  botright = { x = 0.50, y = 0.50, w = 0.50, h = 0.50 },
  upleft = { x = 0.00, y = 0.00, w = 0.50, h = 0.50 },
  botleft = { x = 0.00, y = 0.50, w = 0.50, h = 0.50 },
  maximum = { x = 0.00, y = 0.00, w = 1.00, h = 1.00 },
  middle = {x = 0.12, y = 0.13, w = 0.75, h = 0.75 }
}

-----------------------------------------------------------
-- Window SNAPping.
-----------------------------------------------------------

-- window right, left, up and down. 
windowKeys = { 'ctrl', 'alt' }
windowKeysBig = { 'ctrl', 'alt', 'shift' }

togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowKeys, 'right', function() hs.window.focusedWindow():move(units.right50, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowKeysBig, 'right', function() hs.window.focusedWindow():move(units.right75, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowKeys, 'left', function() hs.window.focusedWindow():move(units.left50, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowKeysBig, 'left', function() hs.window.focusedWindow():move(units.left75, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowKeys, 'up', function() hs.window.focusedWindow():move(units.top50, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowKeysBig, 'up', function() hs.window.focusedWindow():move(units.top75, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowKeys, 'down', function() hs.window.focusedWindow():move(units.bot50, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowKeysBig, 'down', function() hs.window.focusedWindow():move(units.bot75, nil, true) end)

-- windows to all the corners, always 1/4 screen.
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowKeys, 'l', function() hs.window.focusedWindow():move(units.upright, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowKeys, 'k', function() hs.window.focusedWindow():move(units.upleft, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowKeys, ',', function() hs.window.focusedWindow():move(units.botleft, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowKeys, ".", function() hs.window.focusedWindow():move(units.botright, nil, true) end)

togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowKeys, 'f', function() hs.window.focusedWindow():move(units.maximum, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowKeys, 'm', function() hs.window.focusedWindow():move(units.middle, nil, true) end)

-----------------------------------------------------------
--Window to workspace movement
-----------------------------------------------------------
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind({ 'ctrl', 'shift' }, 'right', function()  hs.window.focusedWindow():moveOneScreenEast(false, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind({ 'ctrl', 'shift' }, 'left', function() hs.window.focusedWindow():moveOneScreenWest(false, true) end)

-----------------------------------------------------------
-- LAUNCH MODE (alt)
-----------------------------------------------------------
-- alt+space alternative to cmd+space

-- We need to store the reference to the alert window
appLauncherAlertWindow = nil

-- This is the key mode handle
launchMode = hs.hotkey.modal.new({}, nil, '')

-- Leaves the launch mode, returning the keyboard to its normal
-- state, and closes the alert window, if it's showing
function leaveMode()
  if appLauncherAlertWindow ~= nil then
    hs.alert.closeSpecific(appLauncherAlertWindow, 0)
    appLauncherAlertWindow = nil
  end
  launchMode:exit()
end

function switchToApp(app)
  hs.alert.show(app, {
    strokeColor = hs.drawing.color.x11.black,
    fillColor = hs.drawing.color.x11.black,
    textColor = hs.drawing.color.x11.yellow,
    strokeWidth = 5,
    -- radius = 40,
    textSize = 20,
    -- fadeInDuration = 0,
    atScreenEdge = 1
  }, nil, 1)
  if string.find(app, '/') == 1 -- starts with a /? Must be a path, otherwise assume it's an app by name
  then 
    hs.open(app)
  else
    hs.application.open(app)
  end
  leaveMode()
end

hs.hotkey.bind({ 'alt' }, 'space', function()
  launchMode:enter()
  appLauncherAlertWindow = hs.alert.show('Launcher Mode', {
    strokeColor = hs.drawing.color.x11.black,
    -- fillColor = hs.drawing.color.x11.white,
    textColor = hs.drawing.color.x11.green,
    strokeWidth = 5,
    -- radius = 40,
    -- textSize = 16,
    -- fadeInDuration = 0,
    -- atScreenEdge = 2
  }, 'infinite')
end)

-- When in launch mode, hitting alt+space again leaves it
launchMode:bind({ 'alt' }, 'space', function() leaveMode() end)

-- Mapped keys
if isPersonalHost
then
  launchMode:bind({}, 'm', function() switchToApp('Mail.app') end)
end
if isWorkHost
then
  launchMode:bind({}, 'm', function() switchToApp('Microsoft Outlook.app') end)
  launchMode:bind({}, 'b',  function() switchToApp('BlueJeans.app') end) -- bluejeans
end
launchMode:bind({}, 'w',  function() switchToApp('Firefox.app') end)
-- launchMode:bind({}, 'w',  function() switchToApp('Google Chrome.app') end)
-- launchMode:bind({}, 'w',  function() switchToApp('Safari') end)
launchMode:bind({}, 's',  function() switchToApp('Slack.app') end) -- slack
launchMode:bind({}, 't',  function() switchToApp('iTerm.app') end) -- zsh 
launchMode:bind({}, 'v',  function() switchToApp('MacVim.app') end) -- vim 
launchMode:bind({}, 'c',  function() switchToApp('Visual Studio Code.app') end) -- text edit
launchMode:bind({}, 'f',  function() switchToApp(os.getenv("HOME")) end) -- text edit

-----------------------------------------------------------
-- alt shift LAUNCH MODE (alternate apps)
-----------------------------------------------------------
-- alt+shift+space for alternative app lanches
-- place any shortcut collisions here 
-- ( e.g. shift will make the alternative choice for the letter, w = firefix shift w = brave, or e = vscode, shift+e = codium)

-- We need to store the reference to the alert window
appShiftLauncherAlertWindow = nil

-- This is the key mode handle
shiftLaunchMode = hs.hotkey.modal.new({}, nil, '')

-- Leaves the shift launch mode, returning the keyboard to its normal
-- state, and closes the alert window, if it's showing
function leaveShiftLaunchMode()
  if appShiftLauncherAlertWindow ~= nil then
    hs.alert.closeSpecific(appShiftLauncherAlertWindow, 0)
    appShiftLauncherAlertWindow = nil
  end
  shiftLaunchMode:exit()
end

function switchToShiftApp(app)
  hs.alert.show(app,nil,nil,1)
  hs.application.open(app)
  leaveShiftLaunchMode()
end

hs.hotkey.bind({ 'alt', 'shift' }, 'space', function()
  shiftLaunchMode:enter()
  appShiftLauncherAlertWindow = hs.alert.show('Shift Launcher Mode', {
    strokeColor = hs.drawing.color.x11.black,
    -- fillColor = hs.drawing.color.x11.white,
    textColor = hs.drawing.color.x11.green,
    strokeWidth = 5,
    -- radius = 40,
    -- textSize = 16,
    -- fadeInDuration = 0,
    -- atScreenEdge = 2
  }, 'infinite')
end)

-- When in shift launch mode, hitting alt+shift+space again leaves it
shiftLaunchMode:bind({ 'alt', 'shift' }, 'space', function() leaveShiftLaunchMode() end)

-- Mapped keys
shiftLaunchMode:bind({}, 'm',  function() switchToShiftApp('Mail.app') end)
shiftLaunchMode:bind({}, 'w',  function() switchToShiftApp('Brave Browser.app') end)
shiftLaunchMode:bind({}, 'e',  function() switchToShiftApp('VSCodium.app') end)

-----------------------------------------------------------
-- Reload hammerspoon config
-----------------------------------------------------------
-- manual reload
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
--   hs.reload()
-- end)
-- hs.alert.show("Config loaded")

-- file change triggers reload
function reloadConfig(files)
  doReload = false
  for _,file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    hs.reload()
  end
end
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show(".hammerspoon config loaded")

-----------------------------------------------------------
-- Do stuff based on wifi SSID
-----------------------------------------------------------
wifiWatcher = nil
homeSSID = config.wifi.home
workSSID = config.wifi.work
lastSSID = hs.wifi.currentNetwork()

function ssidChangedCallback()
  newSSID = hs.wifi.currentNetwork()
  
  if newSSID == workSSID then
    hs.audiodevice.defaultOutputDevice():setVolume(0)
  end

  if newSSID == homeSSID and lastSSID ~= homeSSID then
      -- We just joined our home WiFi network
      --hs.audiodevice.defaultOutputDevice():setVolume(25)
  -- elseif newSSID ~= homeSSID and lastSSID == homeSSID then
  --     -- We just departed our home WiFi network
  --     hs.audiodevice.defaultOutputDevice():setVolume(0)
  else
    hs.audiodevice.defaultOutputDevice():setVolume(0)
    
  end
  lastSSID = newSSID
end

wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()

-----------------------------------------------------------
-- url triggers
-----------------------------------------------------------
-- example use from the command line: `open -g hammerspoon://alert?message="A message for you!"`
-- example use from the command line (-g seems not needed): `open hammerspoon://alert?message="A message for you!"`
hs.urlevent.bind("alert", function(eventName, params)
  --hs.alert.show(params["message"]) -- hammerspoon alert (shorter, less intrusive)
  hs.notify.new({title="Hammerspoon", informativeText=params["message"]}):send() -- native macos notifier
end)

hs.urlevent.bind("imessage", function(eventName, params)
  hs.messages.iMessage(config.iMessage.me, params["message"])
end)

hs.urlevent.bind("say", function(eventName, params)
  talker = hs.speech.new()
  talker:speak(params["message"])
end)

-------------
-- for every hotkey stored in togglyHotkeys table, we can turn them on and off
-- togglyHotkeys has to be defined at the top, and these binding set up AFTER keybinds are added to the togglyHotkeys table
-------------
hs.hotkey.bind({"ctrl","alt","cmd"}, 'e', function() enableTogglyHotKeys() end)
hs.hotkey.bind({"ctrl","alt","cmd"}, 'd', function() disableTogglyHotkeys() end)
function enableTogglyHotKeys()
  for i = 1, #togglyHotkeys, 1 
  do
    togglyHotkeys[i]:enable();
  end
end

function disableTogglyHotkeys()
  for i = 1, #togglyHotkeys, 1 
  do
    togglyHotkeys[i]:disable();
  end
end