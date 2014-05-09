----------------------------------------------------------------------------
-- @author Damien Leone &lt;damien.leone@gmail.com&gt;
-- @author Julien Danjou &lt;julien@danjou.info&gt;
-- @copyright 2008-2009 Damien Leone, Julien Danjou
-- @release debian/3.4.13-1
----------------------------------------------------------------------------

-- Grab environment
local io = io
local os = os
local print = print
local pcall = pcall
local pairs = pairs
local type = type
local dofile = dofile
local setmetatable = setmetatable
local util = require("awful.util")
local package = package
local capi =
{
    screen = screen,
    awesome = awesome,
    image = image
}

--- Theme library.
module("beautiful")

-- Local data
local theme

-- Checks the entries in the wallpaper_cmd are valid.
-- @param tw A table with wallpaper commands.
-- @return False if there is no way that this can be a valid wallpaper cmd.
local function wallpaper_is_valid(tw)
    if type(tw) ~= 'table' then return false end
    for _, v in pairs(tw) do
        if type(v) ~= 'string' then return false end
    end
    return (#tw > 0) and true
end

--- Init function, should be runned at the beginning of configuration file.
-- @param path The theme file path.
function init(path)
    if path then
        local success
        success, theme = pcall(function() return dofile(path) end)

        if not success then
            return print("E: beautiful: error loading theme file " .. theme)
        elseif theme then
            -- try and grab user's $HOME directory
            local homedir = os.getenv("HOME")
            -- expand '~'
            if homedir then
                for k, v in pairs(theme) do
                    if type(v) == "string" then theme[k] = v:gsub("~", homedir) end
                end
            end

            -- setup wallpaper
            if wallpaper_is_valid(theme.wallpaper_cmd) then
                for s = 1, capi.screen.count() do
                    util.spawn(theme.wallpaper_cmd[util.cycle(#theme.wallpaper_cmd, s)], false, s)
                end
            else
                if theme.wallpaper_cmd then
                    -- There is a wallpaper_cmd, but wallpaper_is_valid doesn't like it
                    print("W: beautiful: invalid wallpaper_cmd in theme file " .. path)
                end
            end
            if theme.font then capi.awesome.font = theme.font end
            if theme.fg_normal then capi.awesome.fg = theme.fg_normal end
            if theme.bg_normal then capi.awesome.bg = theme.bg_normal end
        else
            return print("E: beautiful: error loading theme file " .. path)
        end
    else
        return print("E: beautiful: error loading theme: no path specified")
    end
end

--- Get the current theme.
-- @return The current theme table.
function get()
    return theme
end

setmetatable(_M, { __index = function(t, k) return theme[k] end })

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
