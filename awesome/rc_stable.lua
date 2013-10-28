------------------------------------------------
--            Awesome 3.5 rc.lua              --    
--           by Ivan            --
--          edited by Ivan
------------------------------------------------

-- {{{ libraries

-- Standard awesome library
local gears     = require("gears")
local awful     = require("awful")
awful.rules     = require("awful.rules")
awful.autofocus = require("awful.autofocus")

-- Widget and layout library
local wibox     = require("wibox")
vicious         = require("vicious")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty   = require("naughty")
local menubar   = require("menubar")

-- for quake terminal
local scratch = require("scratch")
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions

-- Useful Paths
home = os.getenv("HOME")
confdir = home .. "/.config/awesome"

-- Themes define colours, icons, and wallpapers
--beautiful.init("/usr/share/awesome/themes/zenburn/theme.lua")
beautiful.init(awful.util.getdir("config") .. "/themes/current/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "terminator"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
browser = "chromium"
fileman = "thunar " .. home
cli_fileman = terminal .. " -title Ranger -e ranger "
music = terminal .. " -title Music -e ncmpcpp "
tasks = terminal .. " -e sudo htop "

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier
}

-- }}}

-- {{{ Naughty presets
naughty.config.defaults.timeout = 5
naughty.config.defaults.screen = 1
naughty.config.defaults.position = "top_right"
naughty.config.defaults.margin = 8
naughty.config.defaults.gap = 1
naughty.config.defaults.ontop = true
naughty.config.defaults.font = "Monaco 18"
naughty.config.defaults.icon = nil
naughty.config.defaults.icon_size = 256
naughty.config.defaults.fg = beautiful.fg_tooltip
naughty.config.defaults.bg = beautiful.bg_tooltip
naughty.config.defaults.border_color = beautiful.border_tooltip
naughty.config.defaults.border_width = 2
naughty.config.defaults.hover_timeout = nil
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
    names = {"main", "www", "code", "skype", "office", "multimedia"},
    layout = {
        layouts[1], -- main
        layouts[1], -- www
        layouts[1], -- code
        layouts[1], -- skype
        layouts[1], -- office
        layouts[1]  -- multimedia
    }
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, tags.layout)
    -- tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1]) --old
end

-- }}}

-- {{{ Menu

-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal },
                                    { "reboot",
                                        terminal .. " -e reboot " },
                                    { "power off",
                                        terminal .. " -e poweroff " }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- end Menu
-- }}}

-- {{{ Wibox


--[[ by Ivan (testing and learning - wiki tutorial)

-- (by Ivan) Network usage widget
-- Initialize widget
netwidget = wibox.widget.textbox()

--dnicon = wibox.widget.imagebox(beautiful.widget_net)
--upicon = wibox.widget.imagebox(beautiful.widget_netup)

separator = wibox.widget.textbox(" :: ")

-- Register widget
vicious.register(netwidget, vicious.widgets.net, '<span color="#CC9393">${wlp3s0 down_kb}</span> <span color="#7F9F7F">${wlp3s0 up_kb}</span>', 3)

--]]

-- {{{ Clock and date

mytextclock = wibox.widget.textbox()
vicious.register(mytextclock, vicious.widgets.date, 
    "<span color='" .. beautiful.fg_normal .. "'>%d.%m.%Y </span>" ..
    "<b><span color='" .. beautiful.fg_focus .. "'>%R</span></b>"
)

mytextclockicon = wibox.widget.imagebox()
mytextclockicon:set_image(beautiful.widget_clock)

-- }}}

-- {{{ Volume

volicon = wibox.widget.imagebox()
volicon:set_image(beautiful.widget_vol)
volumewidget = wibox.widget.textbox()
vicious.register( volumewidget, vicious.widgets.volume,
    "<span color=\"" .. beautiful.colors.base00 .. "\">$1%</span>", 1, "Master" )

mute = false

volumewidget:buttons(awful.util.table.join(
        awful.button({ }, 1,
            function()
                awful.util.spawn("amixer -q sset Master toggle", false)
                if (mute == false) then
                    volicon:set_image(beautiful.widget_vol_mute)
                    mute = true
                else
                    volicon:set_image(beautiful.widget_vol)
                    mute = false
                end
            end),
        awful.button({ }, 3,
            function()
                awful.util.spawn("" .. terminal .. " -e alsamixer", true)
            end),
        awful.button({ }, 4,
            function()
                awful.util.spawn("amixer -q sset Master 3dB+", false)
            end),
        awful.button({ }, 5,
            function()
                awful.util.spawn("amixer -q sset Master 3dB-", false)
            end)
    )
)

-- }}}

-- {{{ Net

netdownicon = wibox.widget.imagebox()
netdownicon:set_image(beautiful.widget_netdown)
netupicon = wibox.widget.imagebox()
netupicon:set_image(beautiful.widget_netup)

ethdowninfo = wibox.widget.textbox()
vicious.register(ethdowninfo, vicious.widgets.net,
"<span color=\"" .. beautiful.colors.green .. "\">e:${enp4s0 down_kb}</span>", 1)

ethupinfo = wibox.widget.textbox()
vicious.register(ethupinfo, vicious.widgets.net,
"<span color=\"" .. beautiful.colors.red .. "\">e:${enp4s0 up_kb}</span>", 1)

wifidowninfo = wibox.widget.textbox()
vicious.register(wifidowninfo, vicious.widgets.net,
"<span color=\"" .. beautiful.colors.green .. "\">w:${wlp3s0 down_kb}</span>", 1)

wifiupinfo = wibox.widget.textbox()
vicious.register(wifiupinfo, vicious.widgets.net,
"<span color=\"" .. beautiful.colors.red .. "\">w:${wlp3s0 up_kb}</span>", 1)

local function dispip()
    local f, infos
    local capi = {
        mouse = mouse,
        screen = screen
    }

    f = io.popen("sh /home/ivan/.scripts/ip")
    infos = f:read("*all")
    f:close()

    showip = naughty.notify({
        text = infos,
        timeout = 0,
        position = "top_right",
        margin = 10,
        height = 33,
        width = 113,
        border_color = beautiful.colors.base0,
        border_width = 1,
        -- opacity = 0.95,
        screen = capi.mouse.screen
    })
end

--ethdowninfo:connect_signal('mouse::enter', function() dispip(path) end)
ethdowninfo:connect_signal('mouse::leave', function() naughty.destroy(showip) end)
--wifidowninfo:connect_signal('mouse::enter', function() dispip(path) end)
wifidowninfo:connect_signal('mouse::leave', function() naughty.destroy(showip) end)

-- }}}

-- {{{ battery

local baticonsdir = beautiful.confdir .. "/power/"
 
baticon = wibox.widget.imagebox()
powericon = wibox.widget.imagebox()

-- battery widget
batwidget = wibox.widget.textbox()

vicious.register(batwidget, vicious.widgets.bat, function(widget, args)
    local low = 33
    local high = 66
    if (args[1] ~= "-") then
        powericon:set_image(baticonsdir .. "power_on.png")
        powericon:fit(16, 16)
        if (args[2] <= low) then
            baticon:set_image(baticonsdir .. "battery_1_charging.png")
        elseif (args[2] > high) then
            baticon:set_image(baticonsdir .. "battery_3_charging.png")
        else
            baticon:set_image(baticonsdir .. "battery_2_charging.png")
        end
    else
        powericon:set_image(baticonsdir .. "power_off.png")
        --powericon:set_image(beautiful.confdir .. "/1x1_transparent.png")
        powericon:fit(1, 1)

        if (args[2] <= low) then
            baticon:set_image(baticonsdir .. "battery_1.png")
        elseif (args[2] > high) then
            baticon:set_image(baticonsdir .. "battery_3.png")
        else
            baticon:set_image(baticonsdir .. "battery_2.png")
        end
    end

    local retval = args[2] .. "%" --"(" .. args[3] .. ")"
    return "<span color='" .. beautiful.fg_normal .. "'>" .. retval .. "</span>"
end, 60, "BAT0")         

-- }}}

-- {{{ Spacers

rbracket = wibox.widget.textbox()
rbracket:set_text(']')
lbracket = wibox.widget.textbox()
lbracket:set_text('[')
line = wibox.widget.textbox()
line:set_text('|')
space = wibox.widget.textbox()
space:set_text(' ')

-- }}}

-- {{{ Keymap

layoutwidget = wibox.widget.textbox()
layoutwidget:set_markup(
    "<span color=\"" .. beautiful.colors.blue .. "\">dvorak</span>"
)
currentLayout = 'dvorak'
layoutChangeFunction = function ()
    if currentLayout == 'dvorak' then
        os.execute("setxkbmap hr")
        layoutwidget:set_markup(
            "<span color=\"" .. beautiful.colors.blue .. "\">hr</span>"
        )
        currentLayout = 'hr'
    else
        os.execute("setxkbmap dvorak")
        layoutwidget:set_markup(
            "<span color=\"" .. beautiful.colors.blue .. "\">dvorak</span>"
        )
        currentLayout = 'dvorak'
    end
end

layoutwidget:buttons(awful.util.table.join(
    awful.button({ }, 1, layoutChangeFunction)
))

-- }}}

-- {{{ Widgets layout

-- Create a wibox for each screen and add it
mywibox = {}
mybottomwibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(space)
    left_layout:add(mytaglist[s])
    left_layout:add(space)
    left_layout:add(space)
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
--[[ by Ivan for testing and learning
    right_layout:add(dnicon)
    right_layout:add(netwidget) -- (by Ivan)
    right_layout:add(upicon)
    right_layout:add(separator)
--]]
    right_layout:add(netdownicon)   -- net widgets
    right_layout:add(ethdowninfo)
    --right_layout:add(space)
    --right_layout:add(wifidowninfo)
    --right_layout:add(space)
    right_layout:add(netupicon)
    right_layout:add(ethupinfo)
    --right_layout:add(space)
    --right_layout:add(wifiupinfo)
    --right_layout:add(space)
    right_layout:add(space)

    right_layout:add(lbracket)      -- keyboardlayout
    right_layout:add(layoutwidget)
    right_layout:add(rbracket)
    --right_layout:add(space)

    right_layout:add(volicon)       -- volume widgets
    right_layout:add(volumewidget)
    right_layout:add(space)
    right_layout:add(line)

    right_layout:add(powericon)     -- batterry
    right_layout:add(baticon)
    right_layout:add(space)
    right_layout:add(batwidget)
    right_layout:add(space)
    right_layout:add(line)

    right_layout:add(mytextclockicon) -- clock widget
    right_layout:add(mytextclock)
    right_layout:add(space)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)

    -- bottom wibox -----------------------------------------------------------
    mybottomwibox[s] = awful.wibox({
        position = "bottom",
        screen = s,
        border_width = 2,
        height = 20
    })
    --mybottomwibox[s].visible = false

    -- bottom widgets aligned to left
    bottom_left_layout = wibox.layout.fixed.horizontal()
    bottom_left_layout:add(space)

    -- bottom widgets aligned to right
    bottom_right_layout = wibox.layout.fixed.horizontal()
    bottom_right_layout:add(space)
    bottom_right_layout:add(space)
    if s == 1 then bottom_right_layout:add(wibox.widget.systray()) end
    bottom_right_layout:add(mylayoutbox[s])

    -- Now bring it all together (bottom - with tasklist)
    bottom_layout = wibox.layout.align.horizontal()
    bottom_layout:set_left(bottom_left_layout)
    bottom_layout:set_middle(mytasklist[s])
    bottom_layout:set_right(bottom_right_layout)
    
    mybottomwibox[s]:set_widget(bottom_layout)
end

-- widgets layout
-- }}}

-- Wibox
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",
                    function () 
                        for s = 1, screen.count() do
                            awful.tag.viewprev(s)
                        end
                    end),
    awful.key({ modkey,           }, "Right",
                    function ()
                        for s = 1, screen.count() do
                            awful.tag.viewnext(s)
                        end
                    end),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
--[[
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),
--]]

    -- changed by Ivan
    awful.key({ altkey,           }, "Tab",
        function ()
            --awful.client.focus.history.previous()
            awful.client.focus.byidx(1)
            if client.focus then
                client.focus:raise()
            end
        end),
    awful.key({ altkey, "Shift"   }, "Tab",
        function ()
            --awful.client.focus.history.previous()
            awful.client.focus.byidx(-1)
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end),


    -- scratchdrop quake terminal -- by ivan
    awful.key({}, "F12", function() scratch.drop(terminal, "top", "center", 0.75, 0.3, sticky) end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ altkey,           }, "F4",     function (c) c:kill()                         end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),

    -- added by Ivan
    awful.key({ altkey,           }, "space", layoutChangeFunction)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber))
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                      -- changed by Ivan
                        for s = 1, screen.count() do
                            if tags[s][i] then
                                awful.tag.viewonly(tags[s][i])
                            end
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))


-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
