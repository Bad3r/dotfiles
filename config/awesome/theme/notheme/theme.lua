local gears = require("gears")
local lain = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme = {}
theme.tasklist_bg_normal = "#282C34"
theme.tasklist_bg_focus = "#282C34"
theme.tasklist_bg_urgent = "#282C34"

theme.notification_font = "Noto Sans 10"
theme.notification_shape = function(cr, width, height)
	gears.shape.rounded_rect(cr, width, height, 10)
end
theme.notification_opacity = 0.95
theme.dir = os.getenv("HOME") .. "/.config/awesome/themes/notheme/"
theme.wallpaper = theme.dir .. "tile.jpeg"
theme.font = "Noto Sans 9"
theme.taglist_font = "Noto Sans 15"
theme.fg_normal = "#5B626F"
theme.fg_focus = "#ABB2BF"
theme.fg_urgent = "#ABB2BF"
theme.bg_normal = "#1e222a"
theme.bg_focus = "#383C44"
theme.bg_urgent = "#120900"
theme.border_normal = "#555C69"
theme.border_focus = "#FBG2GF"
theme.border_marked = "#ABB2BF"
theme.tasklist_plain_task_name = true
theme.tasklist_disable_icon = true
theme.useless_gap = dpi(4)
theme.gap_single_client = false

theme.titlebar_close_button_normal = theme.dir .. "assets/min_unfocused.png"
theme.titlebar_close_button_focus  = theme.dir .. "assets/scale-slider-hover.svg"
theme.titlebar_minimize_button_normal = theme.dir .. "assets/min_unfocused.png"
theme.titlebar_minimize_button_focus  = theme.dir .. "assets/radio-unselected-hover@2.png"
theme.titlebar_sticky_button_normal_inactive = theme.dir .. "assets/radio-selected-insensitive@2.png"
theme.titlebar_sticky_button_focus_inactive  = theme.dir.."assets/radio-selected-insensitive@2.png"
theme.titlebar_sticky_button_normal_active = theme.dir .. "assets/radio-selected@2.png"
theme.titlebar_sticky_button_focus_active  = theme.dir .. "assets/radio-selected@2.png"
--[[
	[theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
	[theme.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
	[theme.titlebar_floating_button_normal_active = themes_path.."default/titlebar/floating_normal_active.png"
	[theme.titlebar_floating_button_focus_active  = themes_path.."default/titlebar/floating_focus_active.png"
]]

local markup = lain.util.markup

-- Textclock
local clock = awful.widget.watch("date +'%R'", 60, function(widget, stdout)
	widget:set_markup(" " .. markup.font(theme.font, stdout))
end)
-- Calendar
theme.cal = lain.widget.cal({
		attach_to = {clock},
		notification_preset = {
			font = theme.font,
			fg = theme.fg_normal,
			bg = theme.bg_normal
		}
})

-- MEM
local memicon = wibox.widget.textbox('<span color="#E5C07B" font="Noto Sans 10"> </span>')
local mem = lain.widget.mem({
	settings = function()
		widget:set_markup(markup.font(theme.font, '<span color="#E5C07B"> ' .. mem_now.used .. "MB</span> "))
	end
})

-- CPU
local cpuicon = wibox.widget.textbox('<span color="#E06C75" font="Noto Sans 10"> </span>')
local cpu = lain.widget.cpu({
		settings = function()
				widget:set_markup(markup.font(theme.font, ' <span color="#E06C75">' .. cpu_now.usage .. "%</span> "))
		end
	})

-- Battery
local baticon = wibox.widget.textbox('<span color="#61AFEF" font="Noto Sans 10"> </span>')
local bat = lain.widget.bat({
	settings = function()
		widget:set_markup(markup.font(theme.font, '<span color="#61AFEF">' .. bat_now.perc .. "%</span> "))
	end
})

-- ALSA volume
local volicon = wibox.widget.textbox('<span color="#98c379" font="Noto Sans 10"> </span>')
theme.volume = lain.widget.alsa({
		settings = function()
			if volume_now.status == "off" then
				volicon:set_markup('<span color="#98c379" font="Noto Sans 10"> </span>')
			elseif tonumber(volume_now.level) == 0 then
				volicon:set_markup('<span color="#98c379" font="Noto Sans 10"> </span>')
			elseif tonumber(volume_now.level) <= 50 then
				volicon:set_markup('<span color="#98c379" font="Noto Sans 10"> </span>')
			else
				volicon:set_markup('<span color="#98c379" font="Noto Sans 10"> </span>')
			end

			widget:set_markup(markup.font(theme.font, '<span color="#98c379"> ' .. volume_now.level .. "%</span> "))
		end
	})

-- Separators
local spr = wibox.widget.textbox('     ')

function theme.at_screen_connect(s)
	-- Quake application
	s.quake = lain.util.quake({
		app = awful.util.terminal
	})

	gears.wallpaper.maximized(theme.dir .. "/tile.jpeg", s)

	-- Tags
	awful.tag(awful.util.tagnames, s, awful.layout.layouts)

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()
	-- Create an imagebox widget which will contains an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(my_table.join(awful.button({}, 1, function()
		awful.layout.inc(1)
	end), awful.button({}, 2, function()
		awful.layout.set(awful.layout.layouts[1])
	end), awful.button({}, 3, function()
		awful.layout.inc(-1)
	end), awful.button({}, 4, function()
		awful.layout.inc(1)
	end), awful.button({}, 5, function()
		awful.layout.inc(-1)
	end)))
	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist {
		screen = s,
		filter = awful.widget.taglist.filter.all,
		style = {
			shape = gears.shape.rounded_bar
		},
		layout = {
			spacing = 0,
			spacing_widget = {
				color = '#dddddd',
				shape = gears.shape.rounded_bar,
			},
			layout = wibox.layout.fixed.horizontal
		},
		widget_template = {
			{
				{
					{
						bg = '#dddddd',
						shape = '',
						widget = wibox.container.background,
					},
					{
						{
							id = 'icon_role',
							widget = wibox.widget.imagebox,
						},
						margins = 0,
						widget = wibox.container.margin,
					},
					{
						id = 'text_role',
						widget = wibox.widget.textbox,
					},
					layout = wibox.layout.fixed.horizontal,
				},
				left = 10,
				right = 10,
				widget = wibox.container.margin
			},
			id = 'background_role',
			widget = wibox.container.background,
			-- Add support for hover colors and an index label
			create_callback = function(self, c3, index, objects) --luacheck: no unused args
				self:connect_signal('mouse::enter', function()
					if self.bg ~= '#515865' then
						self.backup = self.bg
						self.has_backup = true
					end
					self.bg = '#515865'
				end)
				self:connect_signal('mouse::leave', function()
					if self.has_backup then self.bg = self.backup end
				end)
			end,
		},
		buttons = awful.util.taglist_buttons
	}
	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist {
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = awful.util.tasklist_buttons,
		style = {
			shape_border_width = 1,
			shape_border_color = '#1e222a',
			shape = gears.shape.rounded_bar,
		},
		layout = {
			spacing = 20,
			spacing_widget = {
				{
					forced_width = 5,
					shape = gears.shape.circle,
					widget = wibox.widget.separator
				},
				valign = 'center',
				halign = 'center',
				widget = wibox.container.place,
			},
			layout = wibox.layout.flex.horizontal
		},
		-- Notice that there is *NO* wibox.wibox prefix, it is a template,
		-- not a widget instance.
		widget_template = {
			{
				{
					{
						{
							id	 = 'icon_role',
							widget = wibox.widget.imagebox,
						},
						margins = 2,
						widget = wibox.container.margin,
					},
					{
						id = 'text_role',
						widget = wibox.widget.textbox,
					},
					layout = wibox.layout.fixed.horizontal,
				},
				left = 10,
				right = 10,
				widget = wibox.container.margin
			},
			id = 'background_role',
			widget = wibox.container.background,
		},
	}

	s.mywibox = wibox {
		-- get screen size and widget size to calculate centre position
		width = dpi(1360),
		height = dpi(25),
		ontop = false,
		screen = mouse.screen,
		expand = true,
		visible = true,
		bg = '#1e222a',
		x = screen[1].geometry.width / 2 - dpi(680),
		y = dpi(5),
		shape = gears.shape.rounded_bar
	}

	s.mywibox:setup {
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			s.mytaglist,
			s.mypromptbox,
			wibox.widget.textbox(' '),
		},
		s.mytasklist,
		{
			spr,
			volicon,
			theme.volume,
			spr,
			memicon,
			mem,
			spr,
			cpuicon,
			cpu,
			spr,
			baticon,
			bat,
			spr,
			layout = wibox.layout.fixed.horizontal,
			wibox.container.margin(
				wibox.widget.systray(),
				dpi(-10), dpi(0), dpi(3), dpi(3)
			),
			clock,
			spr,
		}
	}
	s.mywibox:struts({
		left=dpi(0),
		right=dpi(0),
		top=dpi(35),
		bottom=dpi(0)
	})
end

return theme

