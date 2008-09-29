-- awesome 3 configuration file

-- Include awesome library, with lots of useful function!
require("awful")
require("tabulous")
require("wicked")
require("beautiful")

-- {{{ Variable definitions
-- This is a file path to a theme file which will defines colors.
theme_path = "/home/kanru/.config/awesome/themes/default"

-- This is used later as the default terminal to run.
terminal = "/home/kanru/bin/myterm.sh"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
alt = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    "tile",
    "tileleft",
    "tilebottom",
    "tiletop",
    "fairh",
    "fairv",
    "magnifier",
    "max",
    "spiral",
    "dwindle",
    "floating"
}

-- Table of clients that should be set floating. The index may be either
-- the application class or instance. The instance is useful when running
-- a console app in a terminal like (Music on Console)
--    xterm -name mocp -e mocp
floatapps_cls =
{
    -- by class
    ["MPlayer"] = true,
    ["pinentry"] = true
}
floatapps_ins =
{
    -- by instance
    ["mocp"] = true,
    ["emesene"] = true
}

-- Applications to be moved to a pre-defined tag by class or instance.
-- Use the screen and tags indices.
apptags =
{
    ["Minefield"] = { screen = screen.count(), tag = 3 },
    ["xchat"] = { screen = screen.count(), tag = 2 },
    -- ["mocp"] = { screen = 2, tag = 4 },
}

-- Define if we want to use titlebar on all applications.
use_titlebar = false
-- }}}

-- {{{ Initialization
-- Initialize theme (colors).
beautiful.init(theme_path)

-- Register theme in awful.
-- This allows to not pass plenty of arguments to each function
-- to inform it about colors we want it to draw.
awful.beautiful.register(beautiful)

-- Uncomment this to activate autotabbing
-- tabulous.autotab_start()
-- }}}

-- {{{ Tags
-- Define tags table.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = {}
    -- Create 9 tags per screen.
    for tagnumber = 1, 9 do
        tags[s][tagnumber] = tag({ name = tagnumber, layout = layouts[1] })
        -- Add tags to screen one by one
        tags[s][tagnumber].mwfact = 0.618033988769
        tags[s][tagnumber].screen = s
    end
    -- I'm sure you want to see at least one tag.
    tags[s][1].selected = true
end
-- }}}

-- {{{ Statusbar
-- Create a alsamixer widget
volumewidget = widget({
    type = 'progressbar',
    name = 'volumewidget',
    align = 'right'
})
volumewidget.width = 10
volumewidget.vertical = true
volumewidget.ticks_count = 6
volumewidget.ticks_gap = 1
volumewidget.border_width = 0
volumewidget:bar_properties_set('volume', {
    min_value = 0,
    max_value = 100,
    fg = beautiful.fg_normal,
    bg = beautiful.bg_normal,
})
volumewidget:bar_data_add('volume', 100)
local function update_volumewidget()
    local f = io.popen('amixer get Master')
    local l = f:lines()
    local v = ''

    for line in l do
        if line:find('Mono:') ~= nil then
            pend = line:find('%]', 0, true)
            pstart = line:find('[', 0, true)
            v = line:sub(pstart+1, pend-1)
            if line:find('[off]', 1, true) ~= nil then
                volumewidget:bar_properties_set('volume', {fg = '#666666'})
            else
                volumewidget:bar_properties_set('volume', {fg = beautiful.fg_normal})
            end
        end
    end

    f:close()
    volumewidget:bar_data_add('volume', v)
end
wicked.register(volumewidget, 'function', function (widget, args)
    update_volumewidget()
end, 4)
function amixer_mute()
    awful.spawn('amixer -q set Master toggle')
    update_volumewidget()
end
function amixer_inc()
    awful.spawn('amixer -q set Master 10%+')
    update_volumewidget() 
end
function amixer_dec()
    awful.spawn('amixer -q set Master 10%-')
    update_volumewidget() 
end
volumewidget:buttons({
    button({ }, 1, amixer_mute),
    button({ }, 4, amixer_inc),
    button({ }, 5, amixer_dec),
})
keybinding({}, "XF86AudioMute", amixer_mute):add()
keybinding({}, "XF86AudioRaiseVolume", amixer_inc):add()
keybinding({}, "XF86AudioLowerVolume", amixer_dec):add()
-- Create a CPU usage graph widget
cpugraphwidget = widget({
    type = 'graph',
    name = 'cpugraphwidget',
    align = 'right'
})
cpugraphwidget.height = 0.85
cpugraphwidget.width = 40
cpugraphwidget.bg = '#333333'
cpugraphwidget.border_color = '#0a0a0a'
cpugraphwidget.grow = 'right'
cpugraphwidget:plot_properties_set('cpu', {
    fg = '#AEC6D8',
    fg_center = '#285577',
    fg_end = '#285577',
    vertical_gradient = false,
})
wicked.register(cpugraphwidget, 'cpu', '$1', 1, 'cpu')
-- Network
netwidget = widget({
    type = 'textbox',
    name = 'netwidget',
    align = 'right'
})
netwidget.height = 0.85
netwidget.width = 60
wicked.register(netwidget, 'net', "<text align='right'/><span color='"..beautiful.fg_normal.."'>${eth2 down}</span>", 1)
-- Create a taglist widget
mytaglist = widget({ type = "taglist", name = "mytaglist" })
mytaglist:buttons({
    button({ }, 1, function (object, tag) awful.tag.viewonly(tag) end),
    button({ modkey }, 1, function (object, tag) awful.client.movetotag(tag) end),
    button({ }, 3, function (object, tag) tag.selected = not tag.selected end),
    button({ modkey }, 3, function (object, tag) awful.client.toggletag(tag) end),
    button({ }, 4, awful.tag.viewnext),
    button({ }, 5, awful.tag.viewprev)
})
mytaglist.label = awful.widget.taglist.label.all

-- Create a tasklist widget
mytasklist = widget({ type = "tasklist", name = "mytasklist" })
mytasklist:buttons({
    button({ }, 1, function (object, c) client.focus = c; c:raise() end),
    button({ }, 4, function () awful.client.focusbyidx(1) end),
    button({ }, 5, function () awful.client.focusbyidx(-1) end)
})
mytasklist.label = awful.widget.tasklist.label.currenttags

-- Create a textbox widget
mytextbox = widget({ type = "textbox", name = "mytextbox", align = "right" })
-- Set the default text in textbox
mytextbox.text = "<b><small> " .. AWESOME_RELEASE .. " </small></b>"
mypromptbox = widget({ type = "textbox", name = "mypromptbox", align = "left" })

-- Create a laucher widget
mylauncher = awful.widget.launcher({ name = "mylauncher",
                                     image = "/usr/local/share/awesome/icons/awesome16.png",
                                     command = terminal .. " -e man awesome"})

-- Create a systray
mysystray = widget({ type = "systray", name = "mysystray", align = "right" })

-- Create an iconbox widget which will contains an icon indicating which layout we're using.
-- We need one layoutbox per screen.
mylayoutbox = {}
for s = 1, screen.count() do
    mylayoutbox[s] = widget({ type = "imagebox", name = "mylayoutbox", align = "right" })
    mylayoutbox[s]:buttons({
        button({ }, 1, function () awful.layout.inc(layouts, 1) end),
        button({ }, 3, function () awful.layout.inc(layouts, -1) end),
        button({ }, 4, function () awful.layout.inc(layouts, 1) end),
        button({ }, 5, function () awful.layout.inc(layouts, -1) end)
    })
    mylayoutbox[s].image = image("/usr/local/share/awesome/icons/layouts/tilew.png")
end

-- Create a wibox for each screen and add it
mywibox = {}
for s = 1, screen.count() do
    mywibox[s] = wibox({ position = "top", name = "mywibox" .. s,
                             fg = beautiful.fg_normal, bg = beautiful.bg_normal })
    -- Add widgets to the wibox - order matters
    mywibox[s]:widgets({
        mytaglist,
        mytasklist,
        mylauncher,
        mypromptbox,
        netwidget,
        cpugraphwidget,
        volumewidget,
        mytextbox,
        s == screen.count() and mysystray or nil,
        mylayoutbox[s]
    })
    mywibox[s].screen = s
end
-- }}}

-- {{{ Mouse bindings
awesome.buttons({
    button({ }, 3, function () awful.spawn(terminal) end),
    button({ }, 4, awful.tag.viewnext),
    button({ }, 5, awful.tag.viewprev)
})
-- }}}

-- {{{ Key bindings

-- Bind keyboard digits
-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
    keybinding({ modkey }, i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           awful.tag.viewonly(tags[screen][i])
                       end
                   end):add()
    keybinding({ modkey, "Control" }, i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           tags[screen][i].selected = not tags[screen][i].selected
                       end
                   end):add()
    keybinding({ modkey, "Shift" }, i,
                   function ()
                       if client.focus then
                           if tags[client.focus.screen][i] then
                               awful.client.movetotag(tags[client.focus.screen][i])
                           end
                       end
                   end):add()
    keybinding({ modkey, "Control", "Shift" }, i,
                   function ()
                       if client.focus then
                           if tags[client.focus.screen][i] then
                               awful.client.toggletag(tags[client.focus.screen][i])
                           end
                       end
                   end):add()
end

keybinding({ modkey }, "Left", awful.tag.viewprev):add()
keybinding({ modkey }, "Right", awful.tag.viewnext):add()
keybinding({ modkey }, "Escape", awful.tag.history.restore):add()

-- Standard program
keybinding({ modkey }, "Return", function () awful.spawn(terminal) end):add()

keybinding({ modkey, "Control" }, "r", awesome.restart):add()
keybinding({ modkey, "Shift" }, "q", awesome.quit):add()

-- Client manipulation
keybinding({ modkey }, "m", awful.client.maximize):add()
keybinding({ modkey }, "f", function () client.focus.fullscreen = not client.focus.fullscreen end):add()
keybinding({ modkey, "Shift" }, "c", function () client.focus:kill() end):add()
keybinding({ modkey }, "j", function () awful.client.focusbyidx(1); client.focus:raise() end):add()
keybinding({ modkey }, "k", function () awful.client.focusbyidx(-1);  client.focus:raise() end):add()
keybinding({ modkey, "Shift" }, "j", function () awful.client.swap(1) end):add()
keybinding({ modkey, "Shift" }, "k", function () awful.client.swap(-1) end):add()
keybinding({ modkey, "Control" }, "j", function () awful.screen.focus(1) end):add()
keybinding({ modkey, "Control" }, "k", function () awful.screen.focus(-1) end):add()
keybinding({ modkey, "Control" }, "space", awful.client.togglefloating):add()
keybinding({ modkey, "Control" }, "Return", function () client.focus:swap(awful.client.master()) end):add()
keybinding({ modkey }, "o", awful.client.movetoscreen):add()
keybinding({ modkey }, "Tab", awful.client.focus.history.previous):add()
keybinding({ modkey }, "u", awful.client.urgent.jumpto):add()
keybinding({ modkey, "Shift" }, "r", function () client.focus:redraw() end):add()
keybinding({ alt }, "F4", function () client.focus:kill() end):add()

-- Layout manipulation
keybinding({ modkey }, "l", function () awful.tag.incmwfact(0.05) end):add()
keybinding({ modkey }, "h", function () awful.tag.incmwfact(-0.05) end):add()
keybinding({ modkey, "Shift" }, "h", function () awful.tag.incnmaster(1) end):add()
keybinding({ modkey, "Shift" }, "l", function () awful.tag.incnmaster(-1) end):add()
keybinding({ modkey, "Control" }, "h", function () awful.tag.incncol(1) end):add()
keybinding({ modkey, "Control" }, "l", function () awful.tag.incncol(-1) end):add()
keybinding({ modkey }, "space", function () awful.layout.inc(layouts, 1) end):add()
keybinding({ modkey, "Shift" }, "space", function () awful.layout.inc(layouts, -1) end):add()

-- Prompt
keybinding({ modkey }, "F1", function ()
                                 awful.prompt.run({ prompt = "Run: " }, mypromptbox, awful.spawn, awful.completion.bash,
os.getenv("HOME") .. "/.cache/awesome/history") end):add()
keybinding({ modkey }, "F4", function ()
                                 awful.prompt.run({ prompt = "Run Lua code: " }, mypromptbox, awful.eval, awful.prompt.bash,
os.getenv("HOME") .. "/.cache/awesome/history_eval") end):add()
keybinding({ modkey, "Ctrl" }, "i", function ()
                                        if mypromptbox.text then
                                            mypromptbox.text = nil
                                        else
                                            mypromptbox.text = nil
                                            if client.focus.class then
                                                mypromptbox.text = "Class: " .. client.focus.class .. " "
                                            end
                                            if client.focus.instance then
                                                mypromptbox.text = mypromptbox.text .. "Instance: ".. client.focus.instance .. " "
                                            end
                                            if client.focus.role then
                                                mypromptbox.text = mypromptbox.text .. "Role: ".. client.focus.role
                                            end
                                        end
                                    end):add()

--- Tabulous, tab manipulation
keybinding({ modkey, "Control" }, "y", function ()
    local tabbedview = tabulous.tabindex_get()
    local nextclient = awful.client.next(1)

    if not tabbedview then
        tabbedview = tabulous.tabindex_get(nextclient)

        if not tabbedview then
            tabbedview = tabulous.tab_create()
            tabulous.tab(tabbedview, nextclient)
        else
            tabulous.tab(tabbedview, client.focus)
        end
    else
        tabulous.tab(tabbedview, nextclient)
    end
end):add()

keybinding({ modkey, "Shift" }, "y", tabulous.untab):add()

keybinding({ modkey }, "y", function ()
   local tabbedview = tabulous.tabindex_get()

   if tabbedview then
       local n = tabulous.next(tabbedview)
       tabulous.display(tabbedview, n)
   end
end):add()

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
keybinding({ modkey }, "t", awful.client.togglemarked):add()
keybinding({ modkey, 'Shift' }, "t", function ()
    local tabbedview = tabulous.tabindex_get()
    local clients = awful.client.getmarked()

    if not tabbedview then
        tabbedview = tabulous.tab_create(clients[1])
        table.remove(clients, 1)
    end

    for k,c in pairs(clients) do
        tabulous.tab(tabbedview, c)
    end

end):add()

for i = 1, keynumber do
    keybinding({ modkey, "Shift" }, "F" .. i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           for k, c in pairs(awful.client.getmarked()) do
                               awful.client.movetotag(tags[screen][i], c)
                           end
                       end
                   end):add()
end

keybinding({ modkey }, "b",
    function ()
        local screen = mouse.screen
        if mystatusbar[screen].position == "top" then
            mystatusbar[screen].position = "off"
        else
            mystatusbar[screen].position = "top"
        end
    end):add()
-- }}}

-- {{{ Hooks
-- Hook function to execute when focusing a client.
awful.hooks.focus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end)

-- Hook function to execute when unfocusing a client.
awful.hooks.unfocus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end)

-- Hook function to execute when marking a client
awful.hooks.marked.register(function (c)
    c.border_color = beautiful.border_marked
end)

-- Hook function to execute when unmarking a client
awful.hooks.unmarked.register(function (c)
    c.border_color = beautiful.border_focus
end)

-- Hook function to execute when the mouse is over a client.
awful.hooks.mouse_enter.register(function (c)
    -- Sloppy focus, but disabled for magnifier layout
    if awful.layout.get(c.screen) ~= "magnifier"
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

-- Hook function to execute when a new client appears.
awful.hooks.manage.register(function (c)
    if use_titlebar then
        -- Add a titlebar
        awful.titlebar.add(c, { modkey = modkey })
    end
    -- Add mouse bindings
    c:buttons({
        button({ }, 1, function (c) client.focus = c; c:raise() end),
        button({ modkey }, 1, function (c) c:mouse_move() end),
        button({ modkey }, 3, function (c) c:mouse_resize() end)
    })
    -- New client may not receive focus
    -- if they're not focusable, so set border anyway.
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal
    client.focus = c

    -- Check if the application should be floating.
    local cls = c.class
    local inst = c.instance
    if floatapps_cls[cls] then
        c.floating = floatapps_cls[cls]
    elseif floatapps_ins[inst] then
        c.floating = floatapps_ins[inst]
    end

    -- Check application->screen/tag mappings.
    local target
    if apptags[cls] then
        target = apptags[cls]
    elseif apptags[inst] then
        target = apptags[inst]
    end
    if target then
        c.screen = target.screen
        awful.client.movetotag(tags[target.screen][target.tag], c)
    end

    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- awful.client.setslave(c)

    -- Honor size hints: if you want to drop the gaps between windows, set this to false.
    -- c.honorsizehints = false
    -- awful.placement.no_overlap(c)
end)

-- Hook function to execute when arranging the screen
-- (tag switch, new client, etc)
awful.hooks.arrange.register(function (screen)
    local layout = awful.layout.get(screen)
    if layout then
        mylayoutbox[screen].image = image("/usr/local/share/awesome/icons/layouts/" .. layout .. "w.png")
    else
        mylayoutbox[screen].image = nil
    end

    -- Give focus to the latest client in history if no window has focus
    -- or if the current window is a desktop or a dock one.
    if not client.focus then
        local c = awful.client.focus.history.get(screen, 0)
        if c then client.focus = c end
    end

    -- Uncomment if you want mouse warping
    --[[
    if client.focus then
        local c_c = client.focus:coords()
        local m_c = mouse.coords()

        if m_c.x < c_c.x or m_c.x >= c_c.x + c_c.width or
            m_c.y < c_c.y or m_c.y >= c_c.y + c_c.height then
            if table.maxn(m_c.buttons) == 0 then
                mouse.coords({ x = c_c.x + 5, y = c_c.y + 5})
            end
        end
    end
    ]]
end)

-- Hook called every second
awful.hooks.timer.register(1, function ()
    -- For unix time_t lovers
    -- mytextbox.text = " " .. os.time() .. " time_t "
    -- Otherwise use:
    mytextbox.text = ' ' .. os.date('%a %d %b - %H:%M') .. ' '
end)
-- }}}
