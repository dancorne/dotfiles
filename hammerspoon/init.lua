-- Useful command: hs.inspect(hs.keycodes.map)
-- Hyper key defined in Karabiner-Elements (capslock when held)
local hyper = {'alt', 'ctrl', 'shift'}
local cmdhyper = {'cmd', 'alt', 'ctrl', 'shift'}
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
    local output, status = hs.execute("open -n -a /Users/dan/code/alacritty/target/release/osx/Alacritty.app")
    if status == nil then
      log:e(string.format('Opening terminal failed: %s', output))
    end
end)

-- Shortcuts: Timewarrior prompt
function timewarrior(tbl)
  if tbl == nil then
    return
  end
  if tbl["text"] == "stop" or tbl["text"] == "continue" then
    cmd = "/usr/local/bin/timew "
  elseif tbl["update"] then
    cmd = "/usr/local/bin/timew tag @1 "
  else
    cmd = "/usr/local/bin/timew start "
  end
  log:i(string.format("Running command: %s", cmd .. tbl["text"]))
  local output, status = hs.execute(cmd .. tbl["text"])
  if status == nil then
    log:e(string.format("Output: %s", output))
  else
    log:i(string.format("Output: %s", output))
  end
  get_timew()
end

type_choices = {
  { ["text"] = "dev" },
  { ["text"] = "support" },
  { ["text"] = "incident" },
  { ["text"] = "meeting" },
  { ["text"] = "admin" },
  { ["text"] = "recruit", ["noproject"] = true },
  { ["text"] = "stop", ["noproject"] = true },
  { ["text"] = "continue", ["noproject"] = true }
}
proj_choices = {
  { ["text"] = "project1", ["update"] = true },
  { ["text"] = "project2", ["update"] = true },
  { ["text"] = "project3", ["update"] = true }
}

type_chooser = hs.chooser.new(timewarrior)
type_chooser:choices(type_choices)
proj_chooser = hs.chooser.new(timewarrior)
proj_chooser:choices(proj_choices)

function timewarrior_prompt()
  type_chooser:show()
end
hs.hotkey.bind(hyper, 't', nil, timewarrior_prompt)

function open_proj_prompt(chooser, event)
  if event == 'willOpen' then
    focused_window = hs.window.focusedWindow()
    return
  end
  if event == 'didClose' then
    focused_window:focus()
    if chooser == type_chooser and not type_chooser:selectedRowContents()["noproject"] then
      proj_chooser:show()
    end
  end
end
hs.chooser.globalCallback = open_proj_prompt

-- Shortcuts: Webex prompt
function open_webex(tbl)
  local cmd = string.format('open -a firefox "%s"', tbl['url'])
  local output, status = hs.execute(cmd)
end
hs.hotkey.bind(hyper, 'F12', function()
  local choices = {
    {
      ["text"] = "Meeting1",
      ["url"] = "Meeting1 URL"
    },
    {
      ["text"] = "Meeting2",
      ["url"] = "Meeting2 URL"
    },
  webex_chooser = hs.chooser.new(open_webex)
  webex_chooser:choices(choices)
  webex_chooser:show()
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

-- Status Bar: Timewarrior
function run_timew(timew_tags)
  if timew_tags:find('^stop') then
    cmd = string.format('/usr/local/bin/timew %s', timew_tags)
    msg = string.format('Stopped time logging')
  elseif timew_tags:find('^continue') then
    cmd = string.format('/usr/local/bin/timew %s', timew_tags)
    msg = string.format('Continuing work')
  else
    cmd = string.format('/usr/local/bin/timew start %s', timew_tags)
    msg = string.format("Starting work on %s", timew_tags)
  end
  local output, status = hs.execute(cmd)
  if status == nil then
    hs.notify.new({title="Hammerspoon", informativeText='Running timew command failed, see log for details'})
    log:e(string.format('Command: %s', cmd))
    log:e(output)
  else
    hs.notify.new({title="Hammerspoon", informativeText=msg}):send()
    get_timew()
  end
end
timew_options = { "dev", "support", "incident", "meeting", "admin", "recruit" }
function timew_menu_wrapperfunction(_, item)
  run_timew(item["title"])
  get_timew()
end
function build_timew_menu(timew_options)
  local options = {}
  for _, option in pairs(timew_options) do
    table.insert(options, { title = option, fn = timew_menu_wrapperfunction })
  end
  return options
end
timew_menu_options = build_timew_menu(timew_options)

function get_timew()
  local cmd = string.format('/usr/local/bin/timew')
  local output, status = hs.execute(cmd)
  local tags = output:match('Tracking (.-)\n.*')
  timew_menu:setTitle(string.format("Working on: %s", tags))
  timew_menu:setMenu(timew_menu_options)
end

-- Status Bar: Todo.txt
function get_todo_data()
  local todotxt = io.open('/Users/dan/notes/work.todo.txt', 'r')
  local todos = {}
  local thisweek = {}
  local countA = 0
  local countDone = 0
  for line in todotxt:lines() do
    table.insert(todos, line);
    if line:sub(1,1) == 'x' then
      countDone = countDone + 1
    elseif line:sub(1, 3) == '(A)' then
      countA = countA + 1
      table.insert(thisweek, {title = line})
    end
  end
  io.close(todotxt)
  --local new_todotxt = "\n" .. todotxt -- Workaround for simpler pattern matching below
  --local _, countA = string.gsub(new_todotxt, '\n%(A%)', '')
  --local _, countB = string.gsub(new_todotxt, '\n%(B%)', '')
  --local _, countDone = string.gsub(new_todotxt, '\nx', '')
  todo_menu:setTitle(string.format("%s ☐ %s ☑", countA, countDone))
  todo_menu:setMenu(thisweek)
end
    
-- Status Bar: General
function update_menuinfo()
  spotify_status()
  get_timew()
  get_todo_data()
end

spotify_menu = hs.menubar.new()
timew_menu = hs.menubar.new()
todo_menu = hs.menubar.new()
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

-- equalize size of windows
hs.hotkey.bind(hyper, '0', nil, function() hs.execute('/usr/local/bin/chunkc tiling::desktop --equalize') end) 

-- swap window
--hs.hotkey.bind(hyper, 'h', nil, function() hs.execute('/usr/local/bin/chunkc tiling::window --swap west') end)
--hs.hotkey.bind(hyper, 'j', nil, function() hs.execute('/usr/local/bin/chunkc tiling::window --swap south') end)
--hs.hotkey.bind(hyper, 'k', nil, function() hs.execute('/usr/local/bin/chunkc tiling::window --swap north') end)
--hs.hotkey.bind(hyper, 'l', nil, function() hs.execute('/usr/local/bin/chunkc tiling::window --swap east') end)

-- move window
hs.hotkey.bind(cmdhyper, 'h', nil, function() hs.execute('/usr/local/bin/chunkc tiling::window --warp west') end)
hs.hotkey.bind(cmdhyper, 'j', nil, function() hs.execute('/usr/local/bin/chunkc tiling::window --warp south') end)
hs.hotkey.bind(cmdhyper, 'k', nil, function() hs.execute('/usr/local/bin/chunkc tiling::window --warp north') end)
hs.hotkey.bind(cmdhyper, 'l', nil, function() hs.execute('/usr/local/bin/chunkc tiling::window --warp east') end)

-- make floating window fill screen
hs.hotkey.bind(hyper, 'up', nil, function() hs.execute('/usr/local/bin/chunkc tiling::window --grid-layout 1:1:0:0:1:1') end)
-- make floating window fill left-half of screen
hs.hotkey.bind(hyper, 'left', nil, function() hs.execute('/usr/local/bin/chunkc tiling::window --grid-layout 1:2:0:0:1:1') end)
-- make floating window fill right-half of screen
hs.hotkey.bind(hyper, 'right', nil, function() hs.execute('/usr/local/bin/chunkc tiling::window --grid-layout 1:2:1:0:1:1') end)

-- fast focus desktop
hs.hotkey.bind(hyper, 'x', nil, function() hs.execute('/usr/local/bin/chunkc tiling::desktop --focus $(/usr/local/bin/chunkc get _last_active_desktop)') end)
hs.hotkey.bind(hyper, 'z', nil, function() hs.execute('/usr/local/bin/chunkc tiling::desktop --focus prev') end)
hs.hotkey.bind(hyper, 'c', nil, function() hs.execute('/usr/local/bin/chunkc tiling::desktop --focus next') end)
hs.hotkey.bind(hyper, '1', nil, function() hs.execute('/usr/local/bin/chunkc tiling::desktop --focus 1') end)
hs.hotkey.bind(hyper, '2', nil, function() hs.execute('/usr/local/bin/chunkc tiling::desktop --focus 2') end)
hs.hotkey.bind(hyper, '3', nil, function() hs.execute('/usr/local/bin/chunkc tiling::desktop --focus 3') end)
hs.hotkey.bind(hyper, '4', nil, function() hs.execute('/usr/local/bin/chunkc tiling::desktop --focus 4') end)
hs.hotkey.bind(hyper, '5', nil, function() hs.execute('/usr/local/bin/chunkc tiling::desktop --focus 5') end)
hs.hotkey.bind(hyper, '6', nil, function() hs.execute('/usr/local/bin/chunkc tiling::desktop --focus 6') end)

-- send window to desktop
hs.hotkey.bind(cmdhyper, 'x', nil, function() hs.execute('/usr/local/bin/chunkc tiling::window --send-to-desktop $(/usr/local/bin/chunkc get _last_active_desktop)') end)
hs.hotkey.bind(cmdhyper, 'z', nil, function() hs.execute('/usr/local/bin/chunkc tiling::window --send-to-desktop prev') end)
hs.hotkey.bind(cmdhyper, 'c', nil, function() hs.execute('/usr/local/bin/chunkc tiling::window --send-to-desktop next') end)
hs.hotkey.bind(cmdhyper, '1', nil, function() hs.execute('/usr/local/bin/chunkc tiling::window --send-to-desktop 1') end)
hs.hotkey.bind(cmdhyper, '2', nil, function() hs.execute('/usr/local/bin/chunkc tiling::window --send-to-desktop 2') end)
hs.hotkey.bind(cmdhyper, '3', nil, function() hs.execute('/usr/local/bin/chunkc tiling::window --send-to-desktop 3') end)
hs.hotkey.bind(cmdhyper, '4', nil, function() hs.execute('/usr/local/bin/chunkc tiling::window --send-to-desktop 4') end)
hs.hotkey.bind(cmdhyper, '5', nil, function() hs.execute('/usr/local/bin/chunkc tiling::window --send-to-desktop 5') end)
hs.hotkey.bind(cmdhyper, '6', nil, function() hs.execute('/usr/local/bin/chunkc tiling::window --send-to-desktop 6') end)

-- increase region size
hs.hotkey.bind(hyper, 'a', nil, function () hs.execute('/usr/local/bin/chunkc tiling::window --use-temporary-ratio 0.1 --adjust-window-edge west') end)
hs.hotkey.bind(hyper, 's', nil, function () hs.execute('/usr/local/bin/chunkc tiling::window --use-temporary-ratio 0.1 --adjust-window-edge south') end)
hs.hotkey.bind(hyper, 'w', nil, function () hs.execute('/usr/local/bin/chunkc tiling::window --use-temporary-ratio 0.1 --adjust-window-edge north') end)
hs.hotkey.bind(hyper, 'd', nil, function () hs.execute('/usr/local/bin/chunkc tiling::window --use-temporary-ratio 0.1 --adjust-window-edge east') end)

-- decrease region size
hs.hotkey.bind(cmdhyper, 'a', nil, function () hs.execute('/usr/local/bin/chunkc tiling::window --use-temporary-ratio -0.1 --adjust-window-edge west') end)
hs.hotkey.bind(cmdhyper, 's', nil, function () hs.execute('/usr/local/bin/chunkc tiling::window --use-temporary-ratio -0.1 --adjust-window-edge south') end)
hs.hotkey.bind(cmdhyper, 'w', nil, function () hs.execute('/usr/local/bin/chunkc tiling::window --use-temporary-ratio -0.1 --adjust-window-edge north') end)
hs.hotkey.bind(cmdhyper, 'd', nil, function () hs.execute('/usr/local/bin/chunkc tiling::window --use-temporary-ratio -0.1 --adjust-window-edge east') end)

-- focus monitor
hs.hotkey.bind(hyper, 'n', nil, function() hs.execute('/usr/local/bin/chunkc tiling::monitor -f prev') end)
hs.hotkey.bind(hyper, 'm', nil, function() hs.execute('/usr/local/bin/chunkc tiling::monitor -f next') end)

-- send window to monitor and follow focus
hs.hotkey.bind(hyper, 'p', nil, function() hs.execute('WINDOWID=$(/usr/local/bin/chunkc tiling::query --window id) && /usr/local/bin/chunkc tiling::window --send-to-monitor next && /usr/local/bin/chunkc tiling::window --focus $WINDOWID') end)
hs.hotkey.bind(hyper, 'o', nil, function() hs.execute('WINDOWID=$(/usr/local/bin/chunkc tiling::query --window id) && /usr/local/bin/chunkc tiling::window --send-to-monitor prev && /usr/local/bin/chunkc tiling::window --focus $WINDOWID') end)

hs.hotkey.bind(hyper, 'f', nil, function() hs.execute('/usr/local/bin/chunkc tiling::window --toggle fullscreen') end)

-- vim: set expandtab shiftwidth=2:
