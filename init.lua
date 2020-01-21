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
  right = { x = 0.50, y = 0.00, w = 0.50, h = 1.00 },
  rightBig = { x = 0.25, y = 0.00, w = 0.75, h = 1.00 },
  left = { x = 0.00, y = 0.00, w = 0.50, h = 1.00 },
  leftBig = { x = 0.00, y = 0.00, w = 0.75, h = 1.00 },
  top = { x = 0.00, y = 0.00, w = 1.00, h = 0.50 },
  topBig = { x = 0.00, y = 0.00, w = 1.00, h = 0.75 },
  bot = { x = 0.00, y = 0.50, w = 1.00, h = 0.50 },
  botBig = { x = 0.00, y = 0.25, w = 1.00, h = 0.75 },
  upright = { x = 0.50, y = 0.00, w = 0.50, h = 0.50 },
  botright = { x = 0.50, y = 0.50, w = 0.50, h = 0.50 },
  upleft = { x = 0.00, y = 0.00, w = 0.50, h = 0.50 },
  botleft = { x = 0.00, y = 0.50, w = 0.50, h = 0.50 },
  topRightBig = { x = 0.25, y = 0.00, w = 0.75, h = 0.75 },
  botRightBig = { x = 0.25, y = 0.25, w = 0.75, h = 0.75 },
  topLeftBig = { x = 0.00, y = 0.00, w = 0.75, h = 0.75 },
  botLeftBig = { x = 0.00, y = 0.25, w = 0.75, h = 0.75 },
  maximum = { x = 0.00, y = 0.00, w = 1.00, h = 1.00 },
  middle = {x = 0.12, y = 0.13, w = 0.75, h = 0.75 }
}

-----------------------------------------------------------
-- Window placement: position on screen
-----------------------------------------------------------

-- window right, left, up and down. 
windowPlaceHotkey = { 'ctrl', 'alt' }
windowPlaceBigHotkey = { 'ctrl', 'alt', 'shift' }

togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowPlaceHotkey, 'right', function() hs.window.focusedWindow():move(units.right, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowPlaceBigHotkey, 'right', function() hs.window.focusedWindow():move(units.rightBig, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowPlaceHotkey, 'left', function() hs.window.focusedWindow():move(units.left, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowPlaceBigHotkey, 'left', function() hs.window.focusedWindow():move(units.leftBig, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowPlaceHotkey, 'up', function() hs.window.focusedWindow():move(units.top, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowPlaceBigHotkey, 'up', function() hs.window.focusedWindow():move(units.topBig, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowPlaceHotkey, 'down', function() hs.window.focusedWindow():move(units.bot, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowPlaceBigHotkey, 'down', function() hs.window.focusedWindow():move(units.botBig, nil, true) end)

-- windows to all the corners, always 1/4 screen.
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowPlaceHotkey, 'l', function() hs.window.focusedWindow():move(units.upright, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowPlaceBigHotkey, 'l', function() hs.window.focusedWindow():move(units.topRightBig, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowPlaceHotkey, 'k', function() hs.window.focusedWindow():move(units.upleft, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowPlaceBigHotkey, 'k', function() hs.window.focusedWindow():move(units.topLeftBig, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowPlaceHotkey, ',', function() hs.window.focusedWindow():move(units.botleft, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowPlaceBigHotkey, ',', function() hs.window.focusedWindow():move(units.botLeftBig, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowPlaceHotkey, ".", function() hs.window.focusedWindow():move(units.botright, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowPlaceBigHotkey, ".", function() hs.window.focusedWindow():move(units.botRightBig, nil, true) end)

togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowPlaceHotkey, 'f', function() hs.window.focusedWindow():move(units.maximum, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowPlaceHotkey, 'm', function() hs.window.focusedWindow():move(units.middle, nil, true) end)

-----------------------------------------------------------
-- Window placement: which screen to place on
-----------------------------------------------------------

togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind({ 'ctrl', 'shift' }, 'right', function()  hs.window.focusedWindow():moveOneScreenEast(false, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind({ 'ctrl', 'shift' }, 'left', function() hs.window.focusedWindow():moveOneScreenWest(false, true) end)


-----------------------------------------------------------
-- SCREENS (macos spaces)
-----------------------------------------------------------

spacesHotKey = {'cmd', 'shift'}
-- these are actually set in keyboard shortcuts


-----------------------------------------------------------
-- APP LAUNCHERS (alt)
-----------------------------------------------------------

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

  if (string.find(app, '/') == 1) -- starts with a /, it is a path, otherwise assume it's an app by name
  then 
    hs.open(app)
  else
    hs.application.open(app)
  end
  leaveMode()
end

-- Mapped keys
appLaunchHotkey = {'alt'}
if isPersonalHost
then
  togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(appLaunchHotkey, 'w',  function() switchToApp('/Applications/Firefox.app') end) -- Web
  togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(appLaunchHotkey, 'm', function() switchToApp('Mail.app') end) -- Mail
end
if isWorkHost
then
  togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(appLaunchHotkey, 'w',  function() switchToApp(os.getenv("HOME")..'/Applications/Firefox.app') end) -- Web. avoid old, enterprise managed installation of ff
  togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(appLaunchHotkey, 'm', function() switchToApp('Microsoft Outlook.app') end) -- Mail
  togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(appLaunchHotkey, 'b',  function() switchToApp('BlueJeans.app') end) -- Bluejeans
end
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(appLaunchHotkey, 's',  function() switchToApp('Slack.app') end) -- Slack
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(appLaunchHotkey, 't',  function() switchToApp('iTerm.app') end) -- Terminal 
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(appLaunchHotkey, 'e',  function() switchToApp('Visual Studio Code.app') end) -- Editor
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(appLaunchHotkey, 'v',  function() switchToApp('Visual Studio Code.app') end) -- vscode
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(appLaunchHotkey, 'a',  function() switchToApp('Atom.app') end) -- Atom
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(appLaunchHotkey, 'f',  function() switchToApp(os.getenv("HOME")) end) -- File manager, $HOME
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(appLaunchHotkey, 'a',  function() hs.execute [["/Users/robert/.cargo/bin/notesman" "/Users/robert/Documents-DISNEY/NOTES/DISNEY/todos-DIS.md"]] end)
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


--------------------------------------------------------------------------------
-- for every hotkey stored in togglyHotkeys table, we can turn them on and off
-- togglyHotkeys has to be defined at the top, and these binding set up AFTER keybinds are added to the togglyHotkeys table

--------------------------------------------------------------------------------
hs.hotkey.bind({"ctrl","alt","cmd"}, 'e', function() enableTogglyHotKeys() end)
hs.hotkey.bind({"ctrl","alt","cmd"}, 'd', function() disableTogglyHotkeys() end)

function enableTogglyHotKeys()
  for i = 1, #togglyHotkeys, 1 
  do
    togglyHotkeys[i]:enable();
  end
  hs.alert("enabling togglyHotkeys")
end

function disableTogglyHotkeys()
  for i = 1, #togglyHotkeys, 1 
  do
    togglyHotkeys[i]:disable();
  end
  hs.alert("disabling togglyHotkeys")
end
