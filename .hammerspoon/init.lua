-- Useful command: hs.inspect(hs.keycodes.map)
-- Hyper key defined in Karabiner-Elements (capslock when held)
local hyper = {'cmd', 'ctrl', 'shift'}
local althyper = {'cmd', 'alt', 'ctrl', 'shift'}
local log = hs.logger.new('main')
hs.logger.setGlobalLogLevel('info')
local default_browser = "/Users/dancorne/bin/qutebrowser"

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

-- URL handler
function url_handler(scheme, host, params, fullURL)
  local browser = default_browser
  local args = {fullURL}
  if host == "meet.google.com" then
    browser = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
  end
  log:i(string.format("Opening browser with arguments: %s", hs.inspect(args)))
  local new_browser = hs.task.new(browser, nil, args):start()
end
hs.urlevent.httpCallback = url_handler

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

-- Choosers
-- Chooser: Lastpass Clipboard
function chooser_get_lpass()
  local output, status, _, rc = hs.execute('/usr/local/bin/lpass ls')
  if status == nil then
    hs.notify.new({title="Hammerspoon", informativeText='Running lpass command failed, see log for details'})
    log:e(string.format('Getting lpass password list return code %d: %s', rc, output))
    return {}
  end

  local passwords_table = {}
  for line in output:gmatch('[^\n]+') do
    password_name = line:gsub(' %[id:.+%]', ''):gsub('%(none%)/', '')
    if not password_name:match('/$') then
      table.insert(passwords_table, {['text'] = password_name})
    end
  end

  return passwords_table
end

function chooser_paste_lpass(choice)
  if choice == nil then
    return
  end
  local cmd = string.format('/usr/local/bin/lpass show --password "%s"', choice['text'])
  local output, status, _, rc = hs.execute(cmd)
  if status == nil then
    hs.notify.new({title="Hammerspoon", informativeText='Running lpass command failed, see log for details'})
    log:e(string.format('Getting lpass password return code %d: %s', rc, output))
  end
  password = output:gsub('\n', '')
  hs.eventtap.keyStrokes(password)
end
password_chooser = hs.chooser.new(chooser_paste_lpass)
password_chooser:choices(chooser_get_lpass)
hs.hotkey.bind(althyper, 'v', function()
  password_chooser:refreshChoicesCallback()
  password_chooser:show()
end)

-- Chooser: Meetings Chooser
function meeting_choices()
  meeting_choices = {
    {
      ["text"] = "Meeting 1",
      ["url"] = "https://meet.google.com/ID"
    }
  }
  return meeting_choices
end

function open_meeting(choice)
  if choice == nil then
    return
  end
  local cmd = string.format('open -a "Google Chrome" "%s"', choice['url'])
  local output, status, _, rc = hs.execute(cmd)
  if status == nil then
    hs.notify.new({title="Hammerspoon", informativeText='Opening Chrome failed, see log for details'})
    log:e(string.format('Opening Chrome return code %d: %s', rc, output))
    return
  end

end
meetings_chooser = hs.chooser.new(open_meeting)
meetings_chooser:choices(meeting_choices)
hs.hotkey.bind(hyper, '=', function()
  meetings_chooser:show()
end)

-- Screen Management
hs.window.animationDuration = 0 

-- Screen Management: Useful debuggin
--for screen, position in pairs(hs.screen.screenPositions()) do
--  log:i(hs.inspect(screen:currentMode()), hs.inspect(position))
--  log:i(hs.inspect(hs.window.orderedWindows()))
--end


-- Window Management
yabai_bin = '/usr/local/bin/yabai'
hs.hotkey.bind(hyper, 'h', nil, function() hs.execute(yabai_bin .. ' -m window --focus west') end) 
hs.hotkey.bind(hyper, 'l', nil, function() hs.execute(yabai_bin .. ' -m window --focus east') end) 
hs.hotkey.bind(hyper, 'j', nil, function() hs.execute(yabai_bin .. ' -m window --focus south') end) 
hs.hotkey.bind(hyper, 'k', nil, function() hs.execute(yabai_bin .. ' -m window --focus north') end) 

-- equalize size of windows
hs.hotkey.bind(hyper, '0', nil, function() hs.execute(yabai_bin .. ' -m space --balance') end) 

-- move window
hs.hotkey.bind(althyper, 'h', nil, function() hs.execute(yabai_bin .. ' -m window --warp west') end)
hs.hotkey.bind(althyper, 'j', nil, function() hs.execute(yabai_bin .. ' -m window --warp south') end)
hs.hotkey.bind(althyper, 'k', nil, function() hs.execute(yabai_bin .. ' -m window --warp north') end)
hs.hotkey.bind(althyper, 'l', nil, function() hs.execute(yabai_bin .. ' -m window --warp east') end)

-- change how windows are split
hs.hotkey.bind(hyper, '\\', nil, function() hs.execute(yabai_bin .. ' -m window --toggle split') end)

-- make floating window fill screen
hs.hotkey.bind(hyper, 'up', nil, function() hs.execute(yabai_bin .. ' -m window --grid 1:1:0:0:1:1') end)
-- make floating window fill left-half of screen
hs.hotkey.bind(hyper, 'left', nil, function() hs.execute(yabai_bin .. ' -m window --grid 1:2:0:0:1:1') end)
-- make floating window fill right-half of screen
hs.hotkey.bind(hyper, 'right', nil, function() hs.execute(yabai_bin .. ' -m window --grid 1:2:1:0:1:1') end)
-- hide window, it feels more natural to have a hyper-key binding rather than just use CMD+H
hs.hotkey.bind(hyper, 'm', nil, function() hs.window.focusedWindow():application():hide() end)

-- increase region size
-- TODO Only works for windows in the bottom/left
hs.hotkey.bind(hyper, 'a', nil, function () hs.execute(yabai_bin .. ' -m window --resize right:-50:0') end)
hs.hotkey.bind(hyper, 's', nil, function () hs.execute(yabai_bin .. ' -m window --resize top:0:50') end)
hs.hotkey.bind(hyper, 'w', nil, function () hs.execute(yabai_bin .. ' -m window --resize top:0:-50') end)
hs.hotkey.bind(hyper, 'd', nil, function () hs.execute(yabai_bin .. ' -m window --resize right:50:0') end)

-- focus monitor
hs.hotkey.bind(hyper, '[', nil, function() hs.execute(yabai_bin .. ' -m display --focus prev || ' .. yabai_bin .. ' -m display --focus last') end)
hs.hotkey.bind(hyper, ']', nil, function() hs.execute(yabai_bin .. ' -m display --focus next || ' .. yabai_bin .. ' -m display --focus first') end)

-- send window to monitor and follow focus
function send_window_to_next_monitor()
  local current_window = hs.window.focusedWindow()
  hs.execute(yabai_bin .. ' -m window --display next || ' .. yabai_bin .. ' -m window --display first')
  current_window:focus()
end
hs.hotkey.bind(hyper, 'o', nil, send_window_to_next_monitor)

-- toggle window fullscreen
hs.hotkey.bind(hyper, 'f', nil, function() hs.execute(yabai_bin .. ' -m window --toggle zoom-fullscreen') end)

-- vim: set expandtab shiftwidth=2:
