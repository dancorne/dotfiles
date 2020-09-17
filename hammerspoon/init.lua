-- Useful command: hs.inspect(hs.keycodes.map)
-- Hyper key defined in Karabiner-Elements (capslock when held)
local hyper = {'cmd', 'ctrl', 'shift'}
local althyper = {'cmd', 'alt', 'ctrl', 'shift'}
local log = hs.logger.new('main')
hs.logger.setGlobalLogLevel('info')

-- Hammerspoon Smart Reload
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
hs.hotkey.bind(hyper, 'r', function()
  hs.reload()
end)
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.notify.new({title="Hammerspoon", informativeText="Config reloaded"}):send()

-- Spoons
-- Spoons: ClipboardTool
hs.loadSpoon('ClipboardTool')
spoon.ClipboardTool.show_in_menubar = nil
spoon.ClipboardTool.paste_on_select = true
spoon.ClipboardTool:start()
hs.hotkey.bind(hyper, 'v', function()
  spoon.ClipboardTool:showClipboard()
end)

-- Shortcuts
-- Shortcuts: Common programs
hs.hotkey.bind(hyper, "return", function()
    local output, status = hs.execute("open -n -a Alacritty.app")
    if status == nil then
      log:e(string.format('Opening terminal failed: %s', output))
    end
end)


-- Status Bar
-- Status Bar: Spotify
function spotify_status()
  if hs.spotify.isRunning() == true then
    local state = hs.spotify.getPlaybackState()
    if state == hs.spotify.state_playing then
      state_icon = "▶"
    elseif state == hs.spotify.state_paused then
      state_icon = "⏸"
    end
    local song = string.format("%s %s - %s", state_icon, hs.spotify.getCurrentArtist(), hs.spotify.getCurrentTrack())
    spotify_menu:setTitle(song)
    spotify_menu:setTooltip(song)
--    if song ~= spotify_menu:title() then
--      spotify_menu:setTitle(song)
--      log:i(string.format('New Spotify song: %s', song))
--    end
  else
    spotify_menu:setTitle("")
  end
end

-- Status Bar: General
function update_menuinfo()
  spotify_status()
end

spotify_menu = hs.menubar.new()
menubar_timer = hs.timer.new(10, update_menuinfo, true):start()
update_menuinfo()

-- Screen Management
hs.window.animationDuration = 0 

-- Screen Management: Useful debuggin
--for screen, position in pairs(hs.screen.screenPositions()) do
--  log:i(hs.inspect(screen:currentMode()), hs.inspect(position))
--  log:i(hs.inspect(hs.window.orderedWindows()))
--end

-- Screen Managemnt: Chunkwm
hs.hotkey.bind(hyper, 'h', nil, function() hs.execute('/usr/local/bin/chunkc tiling::window --focus west') end) 
--hs.hotkey.bind(hyper, 'j', nil, function() hs.execute('/usr/local/bin//usr/local/bin/chunkc tiling::window --focus south') end) 
--hs.hotkey.bind(hyper, 'k', nil, function() hs.execute('/usr/local/bin//usr/local/bin/chunkc tiling::window --focus north') end) 
hs.hotkey.bind(hyper, 'l', nil, function() hs.execute('/usr/local/bin/chunkc tiling::window --focus east') end) 
hs.hotkey.bind(hyper, 'j', nil, function() hs.execute('/usr/local/bin/chunkc tiling::window --focus south') end) 
hs.hotkey.bind(hyper, 'k', nil, function() hs.execute('/usr/local/bin/chunkc tiling::window --focus north') end) 


-- Window Management
hs.hotkey.bind(hyper, 'h', nil, function() hs.execute('/usr/local/bin/yabai -m window --focus west') end) 
hs.hotkey.bind(hyper, 'l', nil, function() hs.execute('/usr/local/bin/yabai -m window --focus east') end) 
hs.hotkey.bind(hyper, 'j', nil, function() hs.execute('/usr/local/bin/yabai -m window --focus south') end) 
hs.hotkey.bind(hyper, 'k', nil, function() hs.execute('/usr/local/bin/yabai -m window --focus north') end) 

-- equalize size of windows
hs.hotkey.bind(hyper, '0', nil, function() hs.execute('/usr/local/bin/yabai -m space --balance') end) 

-- move window
hs.hotkey.bind(althyper, 'h', nil, function() hs.execute('/usr/local/bin/yabai -m window --warp west') end)
hs.hotkey.bind(althyper, 'j', nil, function() hs.execute('/usr/local/bin/yabai -m window --warp south') end)
hs.hotkey.bind(althyper, 'k', nil, function() hs.execute('/usr/local/bin/yabai -m window --warp north') end)
hs.hotkey.bind(althyper, 'l', nil, function() hs.execute('/usr/local/bin/yabai -m window --warp east') end)

-- change how windows are split
hs.hotkey.bind(hyper, '\\', nil, function() hs.execute('/usr/local/bin/yabai -m window --toggle split') end)

-- make floating window fill screen
hs.hotkey.bind(hyper, 'up', nil, function() hs.execute('/usr/local/bin/yabai -m window --grid 1:1:0:0:1:1') end)
-- make floating window fill left-half of screen
hs.hotkey.bind(hyper, 'left', nil, function() hs.execute('/usr/local/bin/yabai -m window --grid 1:2:0:0:1:1') end)
-- make floating window fill right-half of screen
hs.hotkey.bind(hyper, 'right', nil, function() hs.execute('/usr/local/bin/yabai -m window --grid 1:2:1:0:1:1') end)

-- increase region size
-- TODO Only works for windows in the bottom/left
hs.hotkey.bind(hyper, 'a', nil, function () hs.execute('/usr/local/bin/yabai -m window --resize right:-50:0') end)
hs.hotkey.bind(hyper, 's', nil, function () hs.execute('/usr/local/bin/yabai -m window --resize top:0:50') end)
hs.hotkey.bind(hyper, 'w', nil, function () hs.execute('/usr/local/bin/yabai -m window --resize top:0:-50') end)
hs.hotkey.bind(hyper, 'd', nil, function () hs.execute('/usr/local/bin/yabai -m window --resize right:50:0') end)

-- focus monitor
hs.hotkey.bind(hyper, 'n', nil, function() hs.execute('/usr/local/bin/yabai -m display --focus prev') end)
hs.hotkey.bind(hyper, 'm', nil, function() hs.execute('/usr/local/bin/yabai -m display --focus next') end)

-- send window to monitor and follow focus
hs.hotkey.bind(hyper, 'o', nil, function() hs.execute('WINDOWID=$(/usr/local/bin/yabai -m query --windows | /usr/local/bin/jq ".[] | select(.focused == 1) | .id") ; /usr/local/bin/yabai -m window --display next || /usr/local/bin/yabai -m window --display first; /usr/local/bin/yabai -m window --focus ${WINDOWID}') end)

-- toggle window fullscreen
hs.hotkey.bind(hyper, 'f', nil, function() hs.execute('/usr/local/bin/yabai -m window --toggle zoom-fullscreen') end)

-- vim: set expandtab shiftwidth=2:
