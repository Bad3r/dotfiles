local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi


-- calendar
local styles = {}

styles.month = {
	bg_color = "#00000000",
    border_width = 0,
}

styles.normal = {
	padding = dpi(7),
}

styles.focus = {
	fg_color = beautiful.fg_normal,
    markup   = function(t) return '<b>' .. t .. '</b>' end,
	bg_color = beautiful.bg_focus,
	padding = dpi(7),
	shape = gears.shape.circle
}

styles.header = {
	fg_color = beautiful.fg_normal,
	bg_color = beautiful.bg_button,
    markup = function(t) return '<b>' .. string.upper(t) .. '</b>' end,
	shape = beautiful.widget_shape
}

styles.weekday = {
	fg_color = beautiful.bg_focus,
    markup = function(t) return '<b>' .. string.upper(t) .. '</b>' end,
}

local function decorate_cell(widget, flag, date)
	if flag=='monthheader' and not styles.monthheader then
		flag = 'header'
	end
	local props = styles[flag] or {}
	if props.markup and widget.get_text and widget.set_markup then
		widget:set_markup(props.markup(widget:get_text()))
	end
	-- Change bg color for weekends
	local d = {year=date.year, month=(date.month or 1), day=(date.day or 1)}
	local weekday = tonumber(os.date('%w', os.time(d)))
	local default_bg = (weekday==0 or weekday==7) and '#00000000' or '#00000000'
	local ret = wibox.widget {
		{
			widget,
			margins = (props.padding or 0) + (props.border_width or 0),
			widget  = wibox.container.margin
		},
		shape              = props.shape,
		shape_border_color = props.border_color or default_bg,
		shape_border_width = props.border_width or 0,
		fg                 = props.fg_color or beautiful.fg_normal,
		bg                 = props.bg_color or default_bg,
		widget             = wibox.container.background
	}
	return ret
end

local calendar = wibox.widget{
	date = os.date('*t'),
	font = beautiful.font,
	long_weekdays = false,
	start_sunday = false,
	fn_embed = decorate_cell,
	widget = wibox.widget.calendar.month
}


local button = function(icon_path) 
	local widget = wibox.widget{
		{
			{
				image = icon_path,
				resize = true,
				forced_width = dpi(12),
				forced_height = dpi(12),
				widget = wibox.widget.imagebox	
			},
			margins = dpi(2),
			widget = wibox.container.margin
		},
		bg = beautiful.bg_button,
		border_width = beautiful.btn_border_width,
		shape = beautiful.btn_xs_shape,
		border_color = beautiful.border_button,
		widget = wibox.container.background
	}
	
	local old_cursor, old_wibox

	widget:connect_signal("mouse::enter", function(c)
    	local wb = mouse.current_wibox
    	old_cursor, old_wibox = wb.cursor, wb
    	wb.cursor = "hand1"
	end)
	widget:connect_signal("mouse::leave", function(c)
    	if old_wibox then
        	old_wibox.cursor = old_cursor
        	old_wibox = nil
    	end
	end)

	return widget
end

local button_previous = button(beautiful.icon_previous)
local button_next = button(beautiful.icon_next)


button_previous:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			function()
				local date = calendar:get_date()
            	date.month = date.month - 1
            	calendar:set_date(nil)
            	calendar:set_date(date)
			end
		)
	)
)

button_next:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			function()
				local date = calendar:get_date()
            	date.month = date.month + 1
            	calendar:set_date(nil)
            	calendar:set_date(date)
			end
		)
	)
)

local calendar_widget = wibox.widget {
	layout = wibox.layout.align.vertical,
	calendar,
	{
		{
			layout = wibox.layout.align.horizontal,
			expand = "inside",
			nil, 
			nil, 
			{
				layout = wibox.layout.fixed.horizontal,
				spacing = beautiful.widget_margin,
				button_previous,
				button_next
			}
		},
		top = dpi(-15),
		widget = wibox.container.margin
	}
}
-- Old style calender, keeping because if I want to use that sometimes
--local calendar_widget = wibox.widget {
	--{
		--nil,
		--button_previous,
		--nil,
        --expand = "none", 
		--layout = wibox.layout.align.vertical
	--},
	--{
		--calendar,
		--margins = dpi(6),
		--widget = wibox.container.margin
	--},
	--{
		--nil,
		--button_next,
		--nil,
        --expand = "none", 
		--layout = wibox.layout.align.vertical
	--},
	--layout = wibox.layout.align.horizontal
--}

return calendar_widget
