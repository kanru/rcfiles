local widget = widget
local button = button
local keybinding = keybinding
local io = io
local awful = require("awful")
local wicked = require("wicked")
local beautiful = require("beautiful")
local theme = beautiful.get()

-- My widgets module
module("mywidgets")

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
    fg = theme.fg_normal,
    bg = theme.bg_normal,
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
                volumewidget:bar_properties_set('volume', {fg = theme.fg_normal})
            end
        end
    end

    f:close()
    volumewidget:bar_data_add('volume', v)
end
wicked.register(volumewidget, 'function', function (widget, args)
    update_volumewidget()
end, 4)
local function amixer_mute()
    awful.spawn('amixer -q set Master toggle')
    update_volumewidget()
end
local function amixer_inc()
    awful.spawn('amixer -q set Master 10%+')
    update_volumewidget() 
end
local function amixer_dec()
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
wicked.register(netwidget, 'net', "<text align='right'/><span color='"..theme.fg_normal.."'>${wlan0 down}</span>", 1)
-- Temp
tempwidget = widget({
    type = 'textbox',
    name = 'tempwidget',
    align = 'right',
})
tempwidget.height = 0.85
tempwidget.width = 30
wicked.register(tempwidget, 'function', function (widget, args)
    local f = io.open('/sys/class/thermal/thermal_zone0/temp')
    local temp = f:read('*n') / 1000.0
    f:close()
    return "<text align='right'/><span color='"..theme.fg_normal.."'>"..temp.."℃</span>"
end, 4)
