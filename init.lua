-- a place to store hotkey objects for later manipulation
-- toggle functions at bottom of file (after all of the toggly keys are put in the togglyHotkeys table)
togglyHotkeys = {} -- when binding a hotkey, add it to this table to allow it to be toggled of and on

-- hotkey to place a timestamp in the pasteboard/clibpoard
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind({'cmd', 'alt'}, '`', function()
  hs.pasteboard.setContents(os.date("%Y-%m-%dT%H:%M:%S"))
end)

-- macos host caps lock is confured (karabiner-elements' "complex modifications") to act as hyperkey
hyperkey = {'cmd','ctrl','option','shift'}

togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(hyperkey, '1', function()
  -- run once for each notes domain, each has it's own TODO list
  hs.execute ("notesman /Users/robert/docs.plaintext/dendron/notes/todo.disney.md", true) -- DISNEY notes management
  hs.execute ("notesman /Users/robert/docs.plaintext/dendron/notes/todo.personal.md", true) -- ME notes management
end) -- notesman task management


-- configure hotkeys to launch apps
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(hyperkey, 'v', function()
  switchTo('visual studio Code.app') -- "v"scode
end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(hyperkey, 'f', function()
  switchTo('/System/Library/CoreServices/Finder.app')
end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(hyperkey, 'm', function()
  switchTo('Calendar.app','Mail.app')
end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(hyperkey, 'c', function()
  switchTo('VSCodium.app') -- "c"odium
end)
--togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(hyperkey, 'e', function()
--  switchTo('Emacs.app') -- "e"macs
--end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(hyperkey, 'g', function()
 switchTo('neovide')
 switchTo('Neovide.app') -- "g"vim
end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(hyperkey, 't', function()
  switchTo('iTerm.app') 
  --switchTo('warp.app') -- "t"erminal
end)
-- no w for web...hyper-w disabled via karabiner
-- adding b for browsers, hyper-w was creating _massive_ WiFi diagnostics files in /private/var/tmp, no way to override this key combo!
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(hyperkey, 'b', function()
  switchTo('/Applications/Brave Browser.app') -- "b"rowser
end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(hyperkey, 'z', function()
  switchTo('zoom.us.app')
end)

-- launch if not running OR switch to app
-- this now allows an optional second app (eg. launching mail can also launch calendar)
function switchTo(app,app2)
  
  if (string.find(app, '/') == 1) -- starts with a /, it is a path, otherwise assume it's an app by name
  then
    hs.open(app)
  else
    hs.application.open(app)
  end

  if (string.find(app2, '/') == 1) -- starts with a /, it is a path, otherwise assume it's an app by name
  then
    hs.open(app2)
  else
    hs.application.open(app2)
  end
  
  hyper.triggered = true

end

-- load secrets or other server specific configurations from local file
-- example file format
---------------- 
-- local _M = {}
-- _M.iMessage = {
--     me = "myImessageAddress"
-- }
-- return _M
----------------
-- load the config
-- set some booleans that indicate what host we are on (os.getenv('HOST') does not work, HOST is not set in this context)
isPersonalHost=false
isWorkHost=false
--if hs.fs.fileUTI(os.getenv( "HOME" ).."/.hammerspoon.env.lua") then
  local config = dofile(os.getenv( "HOME" ).."/.hammerspoon.env.lua")

  for k,v in pairs(hs.host.names()) do
    if string.match(v, config.hostname.personal) then
      isPersonalHost=true
    end
    if string.match(v, config.hostname.work) then
      isWorkHost=true
    end
  end
--end

--------------------
-- NoZZZ
-- Create a menu item to toggle sleep (z's) on and off
--------------------
noZzz = hs.menubar.new()
isNoZzz = true -- start true, causing initial load to toggle to false, --> sleep works by default
function setNoZzzDisplay(state)
    if state then
      hs.caffeinate.set("system", false, true) -- false to allow sleep, true to apply to both ac and battery (NOTE APPEARS TO HAVE NO EFFECT)      -- manually take care of this, hs.caffeinate appears...useless?      -- manually take care of this, hs.caffeinate appears...useless?      -- manually take care of this, hs.caffeinate appears...useless?      -- manually take care of this, hs.caffeinate appears...useless?      -- manually take care of this, hs.caffeinate appears...useless?      -- manually take care of this, hs.caffeinate appears...useless?      -- manually take care of this, hs.caffeinate appears...useless?
      -- manually take care of this, hs.caffeinate appears...useless?
      local handle = io.popen("sudo "..os.getenv("HOME").."/bin/macos-enablesleep.sh")
      local result = handle:read("*a")
      handle:close()
      noZzz:setTitle('💤') -- sleepingface
      hs.alert.show("💤 sleep on 💤", {                  
        strokeColor = hs.drawing.color.x11.black,
        -- fillColor = hs.drawing.color.x11.black,
        textColor = hs.drawing.color.x11.blue,
        -- strokeWidth = 5,
        radius = 20,
        textSize = 50,
        fadeInDuration = .5,
        -- atScreenEdge = 1
      }, 2)
      isNoZzz=false
    else
      hs.caffeinate.set("system", true, true) -- true to prevent sleep, true to apply to both ac and battery (NOTE APPEARS TO HAVE NO EFFECT)
      -- manually take care of this, hs.caffeinate appears...useless?
      local handle = io.popen("sudo "..os.getenv("HOME").."/bin/macos-disablesleep.sh")
      local result = handle:read("*a")
      handle:close()
      noZzz:setTitle('💥') -- tweakingface
      hs.alert.show("💥 NO SLEEP 💥", {                  
        strokeColor = hs.drawing.color.x11.black,
        -- fillColor = hs.drawing.color.x11.black,
        textColor = hs.drawing.color.x11.yellow,
        -- strokeWidth = 5,
        radius = 20,
        textSize = 50,
        fadeInDuration = .5,
        -- atScreenEdge = 1
      }, 2)
      isNoZzz=true
    end
end
function noZzzClicked()
  setNoZzzDisplay(isNoZzz)
end
if noZzz then
  noZzz:setClickCallback(noZzzClicked)
  setNoZzzDisplay(isNoZzz)
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
-- Window snap placement: position on screen
-----------------------------------------------------------

-- window right, left, up and down. 
windowSnapHotkey = {'alt', 'ctrl'}
windowBigSnapHotkey = { 'alt', 'ctrl', 'shift' }

togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowSnapHotkey, 'right', function() hs.window.focusedWindow():move(units.right, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowBigSnapHotkey, 'right', function() hs.window.focusedWindow():move(units.rightBig, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowSnapHotkey, 'left', function() hs.window.focusedWindow():move(units.left, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowBigSnapHotkey, 'left', function() hs.window.focusedWindow():move(units.leftBig, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowSnapHotkey, 'up', function() hs.window.focusedWindow():move(units.top, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowBigSnapHotkey, 'up', function() hs.window.focusedWindow():move(units.topBig, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowSnapHotkey, 'down', function() hs.window.focusedWindow():move(units.bot, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowBigSnapHotkey, 'down', function() hs.window.focusedWindow():move(units.botBig, nil, true) end)

-- windows to all the corners, always 1/4 screen.
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowSnapHotkey, 'l', function() hs.window.focusedWindow():move(units.upright, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowBigSnapHotkey, 'l', function() hs.window.focusedWindow():move(units.topRightBig, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowSnapHotkey, 'k', function() hs.window.focusedWindow():move(units.upleft, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowBigSnapHotkey, 'k', function() hs.window.focusedWindow():move(units.topLeftBig, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowSnapHotkey, ',', function() hs.window.focusedWindow():move(units.botleft, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowBigSnapHotkey, ',', function() hs.window.focusedWindow():move(units.botLeftBig, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowSnapHotkey, ".", function() hs.window.focusedWindow():move(units.botright, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowBigSnapHotkey, ".", function() hs.window.focusedWindow():move(units.botRightBig, nil, true) end)

togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowSnapHotkey, 'f', function() hs.window.focusedWindow():move(units.maximum, nil, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind(windowSnapHotkey, 'm', function() hs.window.focusedWindow():move(units.middle, nil, true) end)

-----------------------------------------------------------
-- Window placement: which screen to place on
-----------------------------------------------------------

togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind({ 'ctrl', 'shift' }, 'right', function()  hs.window.focusedWindow():moveOneScreenEast(false, true) end)
togglyHotkeys[#togglyHotkeys+1] = hs.hotkey.bind({ 'ctrl', 'shift' }, 'left', function() hs.window.focusedWindow():moveOneScreenWest(false, true) end)


-----------------------------------------------------------
-- SCREENS (macos spaces)
-----------------------------------------------------------

-- spacesHotKey = {'cmd', 'shift'}
-- these are actually set in keyboard shortcuts, MacOS can do this without Hammerspoon help


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
      hs.audiodevice.defaultOutputDevice():setVolume(25)
  elseif newSSID ~= homeSSID and lastSSID == homeSSID then
      -- We just departed our home WiFi network
      hs.audiodevice.defaultOutputDevice():setVolume(0)
  -- else
  --   hs.audiodevice.defaultOutputDevice():setVolume(10)
    
  end
  lastSSID = newSSID
end

wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()


-----------------------------------------------------------
-- url triggers
-----------------------------------------------------------
-- example use from the command line: `open hammerspoon://alert\?title="testtitle"\&message="hopethisworks"`
hs.urlevent.bind("alert", function(eventName, params)
  --hs.alert.show(params["message"]) -- hammerspoon alert (shorter, less intrusive)
  hs.notify.new({title=params['title'], informativeText=params['message']}):send() -- native macos notifier
end)

-- ¿this method does not alert me of my text messages?
-- example use: `open hammerspoon://imessage\?message="test message to myself"`
hs.urlevent.bind("imessage", function(eventName, params)
  hs.messages.iMessage(config.iMessage.me, params["message"])
end)

-- this seems to silently fail now
-- example use: `open hammerspoon://say\?message="say something"`
hs.urlevent.bind("say", function(eventName, params)
  talker = hs.speech.new()
  talker:speak(params["message"])
end)


--------------------------------------------------------------------------------
-- for every hotkey stored in togglyHotkeys table, we can turn them on and off
-- togglyHotkeys has to be defined at the top, and these binding set up AFTER keybinds are added to the togglyHotkeys table

--------------------------------------------------------------------------------
hs.hotkey.bind({"ctrl","alt","cmd"}, '1', function() enableTogglyHotKeys() end)
hs.hotkey.bind({"ctrl","alt","cmd"}, '0', function() disableTogglyHotkeys() end)

function enableTogglyHotKeys()
  for i = 1, #togglyHotkeys, 1 
  do
    togglyHotkeys[i]:enable();
  end
  hs.alert("enabling togglyHotkeys", {                  
    strokeColor = hs.drawing.color.x11.black,
    -- fillColor = hs.drawing.color.x11.black,
    textColor = hs.drawing.color.x11.green,
    -- strokeWidth = 5,
    radius = 20,
    textSize = 35,
    fadeInDuration = .5,
    -- atScreenEdge = 1
  }, 2)
end

function disableTogglyHotkeys()
  for i = 1, #togglyHotkeys, 1 
  do
    togglyHotkeys[i]:disable();
  end
  hs.alert("disabling togglyHotkeys", {                  
    strokeColor = hs.drawing.color.x11.black,
    -- fillColor = hs.drawing.color.x11.black,
    textColor = hs.drawing.color.x11.orange,
    -- strokeWidth = 5,
    radius = 20,
    textSize = 35,
    fadeInDuration = .5,
    -- atScreenEdge = 1
  }, 2)
end

