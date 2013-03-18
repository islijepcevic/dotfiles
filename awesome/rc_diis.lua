-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
-- Widget library
local vicious = require("vicious")

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
-- Themes define colours, icons, and wallpapers
--beautiful.init("/usr/share/awesome/themes/default/theme.lua")
beautiful.init(os.getenv("HOME") .. "/dotfiles/theme/onecolor.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- colors
local fontwidget  = beautiful.fg_normal
local fontwidgetb = beautiful.fg_focus

-- paths
local icons = os.getenv("HOME") .. "/dotfiles/icons/light-blue/"

-- etc
local barheight = 16

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
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
    names = { "1:main", "2:im", "3:www", "4:email", "5:win", "6:foo", "7:bar" },
    layouts = { layouts[2], layouts[1], layouts[2], layouts[1], layouts[2], layouts[2], layouts[2] }
}
tags2 = {
    names = { "nil" },
    layouts = { layouts[2] }
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    if s == 1 then tags[s] = awful.tag(tags.names, s, tags.layouts)
    else tags[s] = awful.tag(tags2.names, s, tags2.layouts)
    end
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
		{ "open terminal", terminal }
	}
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Widgets

format = function(str)
    return "<span color='" .. fontwidget .."'>" .. str .. "</span>"
end

formatbold = function(str)
    return "<b><span color='" .. fontwidgetb .."'>" .. str .. "</span></b>"
end

-- spacer
--spacer = wibox.widget.textbox()
--spacer:set_markup(formatbold("    "))
spacer = wibox.widget.imagebox()
spacer:set_image(icons .. "spacer.png")

spacer_small = wibox.widget.textbox()
spacer_small:set_markup(" ")

-- battery icons
baticon = wibox.widget.imagebox()
powericon = wibox.widget.imagebox()

-- battery widget
batwidget = wibox.widget.textbox()
--vicious.register(batwidget, vicious.widgets.bat, formatbold("BAT ") .. format("$1$2%"), 67, "BAT0")
vicious.register(batwidget, vicious.widgets.bat, function(widget, args)
    local low = 33
    local high = 66
    if (args[1] == "+") then
        powericon:set_image(icons .. "power_on.png")
        if (args[2] <= low) then
            baticon:set_image(icons .. "battery_1_charging.png")
        elseif (args[2] > high) then
            baticon:set_image(icons .. "battery_3_charging.png")
        else
            baticon:set_image(icons .. "battery_2_charging.png")
        end
    else
        if (args[1] == "-") then
            powericon:set_image(icons .. "power_off.png")
        else
            powericon:set_image(icons .. "power_on.png")
        end

        if (args[2] <= low) then
            baticon:set_image(icons .. "battery_1.png")
        elseif (args[2] > high) then
            baticon:set_image(icons .. "battery_3.png")
        else
            baticon:set_image(icons .. "battery_2.png")
        end
    end
    return format(args[2] .. "% (" .. args[3] .. ")")
end, 60, "BAT0")
            
-- volume icon
volicon = wibox.widget.imagebox()

-- volume widget
volwidget = wibox.widget.textbox()
vicious.register(volwidget, vicious.widgets.volume,
function(widget, args)
	--local label = { ["♫"] = " ", ["♩"] = "M" }
    if (args[2] == "♩") then 
        volicon:set_image(icons .. "volume_m.png")
    elseif (args[1] <= 30) then
        volicon:set_image(icons .. "volume_low.png")
    elseif (args[1] > 31 and args[1] <= 50) then
        volicon:set_image(icons .. "volume_mid.png")
    elseif (args[1] > 51) then
        volicon:set_image(icons .. "volume_hi.png")
    end
    return format(args[1] .. "%")
end, 2, "Master")
volwidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("pavol ! &") end),
    awful.button({ }, 4, function () awful.util.spawn("pavol + &") end),
    awful.button({ }, 5, function () awful.util.spawn("pavol - &") end)
))

-- wifi icon
wifiicon = wibox.widget.imagebox()
wifiicon:set_image(icons .. "wifi.png")

-- wifi widget
wifiwidget = wibox.widget.textbox()
vicious.register(wifiwidget, vicious.widgets.wifi,
function (widget, args)
    return format(args["{ssid}"] .. " (" .. math.floor(((args["{link}"]/70)*100)) .. "%)")
end, 13, "wlan0")

-- date widget
datewidget = wibox.widget.textbox()
vicious.register(datewidget, vicious.widgets.date,
format("%d.%m.%Y, ") .. formatbold("%R"))

-- }}}


-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mytopbox = {}
mybotbox = {}
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

    if s == 1 then

        -- TOP BOX
        mytopbox[s] = awful.wibox({ position = "top", screen = s, height = barheight })
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(mylauncher)
        left_layout:add(mytaglist[s])
        left_layout:add(mylayoutbox[s])
        left_layout:add(mypromptbox[s])

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(spacer)

        right_layout:add(wifiicon)
        right_layout:add(spacer_small)
        right_layout:add(wifiwidget)
        right_layout:add(spacer)

        right_layout:add(volicon)
        right_layout:add(spacer_small)
        right_layout:add(volwidget)
        right_layout:add(spacer)

        right_layout:add(powericon)
        right_layout:add(baticon)
        right_layout:add(spacer_small)
        right_layout:add(batwidget)
        right_layout:add(spacer)

        right_layout:add(datewidget)
        right_layout:add(spacer_small)

        -- Now bring it all together (with the tasklist in the middle)
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)

        mytopbox[s]:set_widget(layout)

    end

    -- BOT BOX
    mybotbox[s] = awful.wibox({ position = "bottom", screen = s, height = barheight })
    local layout = wibox.layout.align.horizontal()
    layout:set_middle(mytasklist[s])
    if s == 1 then layout:set_right(wibox.widget.systray()) end
    mybotbox[s]:set_widget(layout)    
    
end
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
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
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
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
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
      awful.key({ }, "XF86AudioRaiseVolume", function () awful.util.spawn("pavol + &") end),
      awful.key({ }, "XF86AudioLowerVolume", function () awful.util.spawn("pavol - &") end),
      awful.key({ }, "XF86AudioMute", function () awful.util.spawn("pavol ! &") end),
      awful.key({ }, "XF86ScreenSaver", function () awful.util.spawn("xscreensaver-command --lock") end),
      awful.key({ }, "XF86TouchpadToggle", function () awful.util.spawn("./scripts/touchpadToggle.sh") end),
      awful.key({ }, "XF86Display", function () awful.util.spawn("./scripts/rotate.sh") end),
      awful.key({ modkey }, "p", function () awful.util.spawn("./scripts/vgaToggle.sh") end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "c",      function (c) c:kill()                         end),
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
        end)
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
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
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
                     size_hints_honor = false,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },

    { rule = { class = "plugin-container" },
      properties = { floating = false, maximized_vertical = false,
      maximized_horizontal = false } },
    { rule = { instance = "exe" },
      properties = { floating = true } },

    -- 1:main

    -- 2:im
    { rule = { class = "Pidgin" },
      properties = {tag = tags[1][2] } },

    -- 3:web
    { rule = { class = "Chromium" },
      properties = { tag = tags[1][3] } },
      
    -- 4:email
    { rule = { class = "Thunderbird" },
      properties = { tag = tags[1][4] } },

    -- 5:win
    { rule = { class = "VirtualBox" },
      properties = { tag = tags[1][5] } },    
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

-- disable startup-notification globally
local oldspawn = awful.util.spawn
awful.util.spawn = function (s)
	oldspawn(s, false)
end
