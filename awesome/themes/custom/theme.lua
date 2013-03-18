---------------------------------
--  "Solarized" awesome theme  --
--     By Gwenhael Le Moine    --
---------------------------------

---------------------------------
--  edited by Ivan             --
--      looking up to:         --
--          theImmortalPhoenix --
---------------------------------

-- Alternative icon sets and widget icons:
--  * http://awesome.naquadah.org/wiki/Nice_Icons

-- {{{ Main
theme = {}
theme.default_themes_path = "/usr/share/awesome/themes"
theme.confdir = os.getenv("HOME") .. "/.config/awesome/themes/custom"

--theme.wallpaper_cmd = { "awsetbg "..theme.default_themes_path.."/zenburn/zenburn-background.png" }
theme.wallpaper = "~/Images/wallpapers/wallpaper.jpg" -- changed by Ivan

theme.colors = {}
theme.colors.base3   = "#002b36"
theme.colors.base2   = "#073642"
theme.colors.base1   = "#586e75"
theme.colors.base0   = "#657b83"
theme.colors.base00  = "#839496"
theme.colors.base01  = "#93a1a1"
theme.colors.base02  = "#eee8d5"
theme.colors.base03  = "#fdf6e3"
theme.colors.yellow  = "#b58900"
theme.colors.orange  = "#cb4b16"
theme.colors.red     = "#dc322f"
theme.colors.magenta = "#d33682"
theme.colors.violet  = "#6c71c4"
theme.colors.blue    = "#268bd2"
theme.colors.cyan    = "#2aa198"
theme.colors.green   = "#859900"
-- }}}

-- {{{ Styles
--theme.font      = "Dejavu Sans 8"
theme.font = "ubuntu mono 10"

-- {{{ Colors
theme.fg_normal  = theme.colors.base02
theme.fg_focus   = theme.colors.base03
theme.fg_urgent  = theme.colors.base3

theme.bg_normal  = theme.colors.base3
theme.bg_focus   = theme.colors.base1
theme.bg_urgent  = theme.colors.red
theme.bg_systray = theme.bg_normal
-- }}}

-- {{{ Borders
theme.border_width  = "2"
theme.border_normal = theme.bg_normal
theme.border_focus  = theme.bg_focus
theme.border_marked = theme.bg_urgent
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = theme.bg_focus
theme.titlebar_bg_normal = theme.bg_normal
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = theme.colors.green
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = "15"
theme.menu_width  = "100"
-- }}}

-- {{{ Icons

-- {{{ Widget icons

theme.widget_uptime     = theme.confdir .. "/widgets/magenta/ac_01.png"
theme.widget_cpu        = theme.confdir .. "/widgets/green/cpu.png"
theme.widget_temp       = theme.confdir .. "/widgets/yellow/temp.png"
theme.widget_mem        = theme.confdir .. "/widgets/cyan/mem.png"
theme.widget_fs         = theme.confdir .. "/widgets/cyan/usb.png"
theme.widget_netdown    = theme.confdir .. "/widgets/green/net_down_03.png"
theme.widget_netup      = theme.confdir .. "/widgets/red/net_up_03.png"
theme.widget_gmail      = theme.confdir .. "/widgets/magenta/mail.png"
theme.widget_sys        = theme.confdir .. "/widgets/green/dish.png"
theme.widget_pac        = theme.confdir .. "/widgets/green/pacman.png"
theme.widget_batt       = theme.confdir .. "/widgets/yellow/bat_full_01.png"
theme.widget_clock      = theme.confdir .. "/widgets/cyan/clock.png"
theme.widget_vol        = theme.confdir .. "/widgets/cyan/spkr_01.png"

-- }}}

-- {{{ Taglist
--theme.taglist_squares_sel   = theme.default_themes_path.."/zenburn/taglist/squarefz.png"
--theme.taglist_squares_unsel = theme.default_themes_path.."/zenburn/taglist/squarez.png"

theme.taglist_squares_sel   = theme.confdir .. "/taglist/squaref_b.png"
theme.taglist_squares_unsel = theme.confdir .. "/taglist/square_b.png"

--theme.taglist_squares_resize = "false"

-- }}}

-- {{{ Misc

theme.awesome_icon           = "~/.config/awesome/icons/arch_red.png"
theme.menu_submenu_icon      = theme.default_themes_path.."/default/submenu.png"

theme.tasklist_floating_icon = theme.confdir .. "/floating.png"

-- }}}

-- {{{ Layout

theme.layout_tile       = theme.confdir .. "/layouts/tile.png"
theme.layout_tileleft   = theme.confdir .. "/layouts/tileleft.png"
theme.layout_tilebottom = theme.confdir .. "/layouts/tilebottom.png"
theme.layout_tiletop    = theme.confdir .. "/layouts/tiletop.png"
theme.layout_fairv      = theme.confdir .. "/layouts/fairv.png"
theme.layout_fairh      = theme.confdir .. "/layouts/fairh.png"
theme.layout_spiral     = theme.confdir .. "/layouts/spiral.png"
theme.layout_dwindle    = theme.confdir .. "/layouts/dwindle.png"
theme.layout_max        = theme.confdir .. "/layouts/max.png"
theme.layout_fullscreen = theme.confdir .. "/layouts/fullscreen.png"
theme.layout_magnifier  = theme.confdir .. "/layouts/magnifier.png"
theme.layout_floating   = theme.confdir .. "/layouts/floating.png"

-- }}}

-- {{{ Titlebar

theme.titlebar_close_button_focus  = theme.confdir.."/titlebar/close_focus.png"
theme.titlebar_close_button_normal = theme.confdir.."/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active  = theme.confdir.."/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = theme.confdir.."/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = theme.confdir.."/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = theme.confdir.."/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = theme.confdir.."/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = theme.confdir.."/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = theme.confdir.."/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = theme.confdir.."/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = theme.confdir.."/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = theme.confdir.."/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = theme.confdir.."/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = theme.confdir.."/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = theme.confdir.."/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = theme.confdir.."/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.confdir.."/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.confdir.."/titlebar/maximized_normal_inactive.png"

-- }}}

-- }}}

return theme
