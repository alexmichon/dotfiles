--[[===========================================================================
Example for 15.6" HD screen with 100% font scaling, evenly split CPU thread rings (close to original work)

Date    : 2016/11/13
Author  : SeaJey, modified by JPvRiel
Version : v0.3
License : Distributed under the terms of GNU GPL version 2 or later

This version is a modification of lunatico_rings.lua wich is modification of conky_orange.lua
- conky_orange.lua:    http://gnome-look.org/content/show.php?content=137503&forumpage=0
- lunatico_rings.lua:  http://gnome-look.org/content/show.php?content=142884
===========================================================================]]--

require 'cairo'

gauge = {

--====--
-- Data here is loaded only once when included and is therefore static
-- 'name' and 'arg' for simple conky objects with static arguments
-- 'conky_line' for complex, conditional and dynamic behavior
-- 'conky_line' supersedes 'name' and 'arg' (in case both are present)
--====--

-- CPU rings
{
    name='cpu',                    arg='cpu0',                  max_value=100,
    x=80,                          y=180,
    graph_radius=30,
    graph_thickness=10,
    graph_start_angle=225,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.3,
    graph_fg_colour=0xffffff,      graph_fg_alpha=1.0,
    hand_fg_colour=0xea0fe0,       hand_fg_alpha=1.0,
    txt_radius=0,
    txt_weight=0.8,                txt_size=10.0,
    txt_fg_colour=0xea0fe0,        txt_fg_alpha=1.0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=0,
    graduation_unit_angle=27,
    graduation_fg_colour=0x0000ff, graduation_fg_alpha=1.0,
    caption='',
    caption_weight=0.8,            caption_size=9.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.3,
},
-- Memory rings
{
    name='memperc',                arg='',                      max_value=100,
    x=190,                         y=180,
    graph_radius=30,
    graph_thickness=10,
    graph_start_angle=225,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.3,
    graph_fg_colour=0xffffff,      graph_fg_alpha=1.0,
    hand_fg_colour=0xea0fe0,       hand_fg_alpha=1.0,
    txt_radius=0,
    txt_weight=0.8,                txt_size=10.0,
    txt_fg_colour=0xea0fe0,        txt_fg_alpha=1.0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=0,
    graduation_unit_angle=27,
    graduation_fg_colour=0xff0000, graduation_fg_alpha=1.0,
    caption='',
    caption_weight=0.8,            caption_size=9.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.3,
},
}

-- converts color in hexa to decimal
function rgb_to_r_g_b(colour, alpha)
    return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

-- convert degree to rad and rotate (0 degree is top/north)
function angle_to_position(start_angle, current_angle)
    local pos = current_angle + start_angle
    return ( ( pos * (2 * math.pi / 360) ) - (math.pi / 2) )
end


-- displays gauges
function draw_gauge_ring(display, data, value, border)
    local max_value = data['max_value']
    local x, y = data['x'] + border, data['y'] + border
    local graph_radius = data['graph_radius']
    local graph_thickness, graph_unit_thickness = data['graph_thickness'], data['graph_unit_thickness']
    local graph_start_angle = data['graph_start_angle']
    local graph_unit_angle = data['graph_unit_angle']
    local graph_bg_colour, graph_bg_alpha = data['graph_bg_colour'], data['graph_bg_alpha']
    local graph_fg_colour, graph_fg_alpha = data['graph_fg_colour'], data['graph_fg_alpha']
    local hand_fg_colour, hand_fg_alpha = data['hand_fg_colour'], data['hand_fg_alpha']
    local graph_end_angle = (max_value * graph_unit_angle) % 360

    -- background ring
    cairo_arc(display, x, y, graph_radius, angle_to_position(graph_start_angle, 0), angle_to_position(graph_start_angle, graph_end_angle))
    cairo_set_source_rgba(display, rgb_to_r_g_b(graph_bg_colour, graph_bg_alpha))
    cairo_set_line_width(display, graph_thickness)
    cairo_stroke(display)

    -- arc of value
    local val = value % (max_value + 1)
    local start_arc = 0
    local stop_arc = 0
    local i = 1
    while i <= val do
        start_arc = (graph_unit_angle * i) - graph_unit_thickness
        stop_arc = (graph_unit_angle * i)
        cairo_arc(display, x, y, graph_radius, angle_to_position(graph_start_angle, start_arc), angle_to_position(graph_start_angle, stop_arc))
        cairo_set_source_rgba(display, rgb_to_r_g_b(graph_fg_colour, graph_fg_alpha))
        cairo_stroke(display)
        i = i + 1
    end
    local angle = start_arc

    -- hand
    start_arc = (graph_unit_angle * val) - (graph_unit_thickness)
    stop_arc = (graph_unit_angle * val)
    cairo_arc(display, x, y, graph_radius, angle_to_position(graph_start_angle, start_arc), angle_to_position(graph_start_angle, stop_arc))
    cairo_set_source_rgba(display, rgb_to_r_g_b(hand_fg_colour, hand_fg_alpha))
    cairo_stroke(display)

    -- graduations marks
    local graduation_radius = data['graduation_radius']
    local graduation_thickness, graduation_mark_thickness = data['graduation_thickness'], data['graduation_mark_thickness']
    local graduation_unit_angle = data['graduation_unit_angle']
    local graduation_fg_colour, graduation_fg_alpha = data['graduation_fg_colour'], data['graduation_fg_alpha']
    if graduation_radius > 0 and graduation_thickness > 0 and graduation_unit_angle > 0 then
        local nb_graduation = graph_end_angle / graduation_unit_angle
        local i = 0
        while i < nb_graduation do
            cairo_set_line_width(display, graduation_thickness)
            start_arc = (graduation_unit_angle * i) - (graduation_mark_thickness / 2)
            stop_arc = (graduation_unit_angle * i) + (graduation_mark_thickness / 2)
            cairo_arc(display, x, y, graduation_radius, angle_to_position(graph_start_angle, start_arc), angle_to_position(graph_start_angle, stop_arc))
            cairo_set_source_rgba(display,rgb_to_r_g_b(graduation_fg_colour,graduation_fg_alpha))
            cairo_stroke(display)
            cairo_set_line_width(display, graph_thickness)
            i = i + 1
        end
    end

    -- text
    local txt_radius = data['txt_radius']
    local txt_weight, txt_size = data['txt_weight'], data['txt_size']
    local txt_fg_colour, txt_fg_alpha = data['txt_fg_colour'], data['txt_fg_alpha']
    local movex = txt_radius * math.cos(angle_to_position(graph_start_angle, angle))
    local movey = txt_radius * math.sin(angle_to_position(graph_start_angle, angle))
    cairo_select_font_face (display, "ubuntu", CAIRO_FONT_SLANT_NORMAL, txt_weight)
    cairo_set_source_rgba (display, rgb_to_r_g_b(txt_fg_colour, txt_fg_alpha))
    cairo_set_font_size (display, txt_size)
    if txt_radius > 0 then
        cairo_move_to (display, x + movex - (txt_size / 2), y + movey + 3)
        cairo_show_text (display, value)
        cairo_stroke (display)
    end

    -- caption
    local caption = data['caption']
    local caption_weight, caption_size = data['caption_weight'], data['caption_size']
    local caption_fg_colour, caption_fg_alpha = data['caption_fg_colour'], data['caption_fg_alpha']
    local tox = graph_radius * (math.cos((graph_start_angle * 2 * math.pi / 360)-(math.pi/2)))
    local toy = graph_radius * (math.sin((graph_start_angle * 2 * math.pi / 360)-(math.pi/2)))
    cairo_select_font_face (display, "ubuntu", CAIRO_FONT_SLANT_NORMAL, caption_weight);
    cairo_set_font_size (display, caption_size)
    cairo_set_source_rgba (display, rgb_to_r_g_b(caption_fg_colour, caption_fg_alpha))
    cairo_move_to (display, x + tox + 5, y + toy + 5)
    -- bad hack but not enough time !
    if graph_start_angle < 105 then
        cairo_move_to (display, x + tox - 30, y + toy + 1)
    end
    cairo_show_text (display, caption)
    cairo_stroke (display)
end


-- loads data and displays gauges
function go_gauge_rings(display, border)
    local function load_gauge_rings(display, data)
        local str, value = '', 0
        if data['conky_line'] == nil then
            str = string.format('${%s %s}',data['name'], data['arg'])
        else
            str = data['conky_line']
        end
        str = conky_parse(str)
        value = tonumber(str)
        if (value == nil) then
            value = 0
        else
            value = math.floor(value + 0.5)
        end
        draw_gauge_ring(display, data, value, border)
    end

    for i in pairs(gauge) do
        load_gauge_rings(display, gauge[i])
    end

end


-- other util functions

function conky_nproc()
  return io.popen('nproc'):read('*n')
end

-- provide a global var of nproc so that it is run only once, not every interval
nproc = conky_nproc()

function cpu_freq_list()
  fl = {}
  for i=1, nproc do
    fl[i] = conky_parse('${freq ' .. i .. '}')
  end
  return fl
end

function conky_freq_min()
  return math.min(unpack(cpu_freq_list()))
end

function conky_freq_max()
  return math.max(unpack(cpu_freq_list()))
end

function conky_freq_avg()
  fl = cpu_freq_list()
  sum = 0
  for i=1, #fl do
    sum = sum + fl[i]
  end
  return math.floor((sum/#fl) + 0.5)
end


-------------------------------------------------------------------------------
--                                                                         MAIN
function conky_main()
    if conky_window == nil then
        return
    end

    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
    local display = cairo_create(cs)

    go_gauge_rings(display, conky_window.border_outer_margin)

    cairo_surface_destroy(cs)
    cairo_destroy(display)

end

