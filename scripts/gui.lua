local flib_gui = require("__flib__.gui-lite")

local RED = "utility/status_not_working"
local GREEN = "utility/status_working"
local YELLOW = "utility/status_yellow"

local STATUS_SPRITES = {}
STATUS_SPRITES[defines.entity_status.working] = GREEN
STATUS_SPRITES[defines.entity_status.normal] = GREEN
STATUS_SPRITES[defines.entity_status.no_power] = RED
STATUS_SPRITES[defines.entity_status.low_power] = YELLOW
STATUS_SPRITES[defines.entity_status.disabled_by_control_behavior] = RED
STATUS_SPRITES[defines.entity_status.disabled_by_script] = RED
STATUS_SPRITES[defines.entity_status.marked_for_deconstruction] = RED
local STATUS_SPRITES_DEFAULT = RED

local STATUS_NAMES = {}
STATUS_NAMES[defines.entity_status.working] = "entity-status.working"
STATUS_NAMES[defines.entity_status.normal] = "entity-status.normal"
STATUS_NAMES[defines.entity_status.no_power] = "entity-status.no-power"
STATUS_NAMES[defines.entity_status.low_power] = "entity-status.low-power"
STATUS_NAMES[defines.entity_status.disabled_by_control_behavior] = "entity-status.disabled"
STATUS_NAMES[defines.entity_status.disabled_by_script] = "entity-status.disabled-by-script"
STATUS_NAMES[defines.entity_status.marked_for_deconstruction] = "entity-status.marked-for-deconstruction"
STATUS_NAMES_DEFAULT = "entity-status.disabled"


HEADING={font_color={255, 230, 192},font="heading-3"}
UNITS = {
	{{"pigo-selector-combinator-gui.random-input-second" }, {"pigo-selector-combinator-gui.random-input-tick" }},
	{{"pigo-selector-combinator-gui.random-input-seconds" }, {"pigo-selector-combinator-gui.random-input-ticks" }},
}

local function update_gui(comb, element)
	local gui = element.gui.screen[SCOMBINATOR_NAME]

	local settings = comb.settings

	local currentMode = settings.mode

	-- update radio buttons and interactivity
	for _, mode in pairs({'select-input', 'count-inputs', 'random-input', 'stack-size'}) do
		gui.frame.vflow[mode].btn.state = mode == currentMode
	end

	gui.titlebar.title.caption = {"", {"entity-name.pigo-selector-combinator"}, ": ", {"pigo-selector-combinator-gui." .. currentMode}}

	-- set fields
	gui.frame.vflow['input-index'].txt.text = tostring(settings.index)
	gui.frame.vflow['input-index'].elem.elem_value = settings.index_signal
	gui.frame.vflow['input-direction'].switch_state = settings.descending and "left" or "right"
	gui.frame.vflow.signal.elem.elem_value = settings.count_signal
	gui.frame.vflow['update-interval'].slider.slider_value = settings.update_interval
	gui.frame.vflow['update-interval'].txt.text = tostring(settings.update_interval)
	gui.frame.vflow['update-interval'].unit.selected_index = settings.update_unit == 'seconds' and 1 or 2
	gui.frame.vflow['update-interval'].unit.items = settings.update_interval == 1 and UNITS[1] or UNITS[2]
	gui.frame.vflow['random-unique'].state = settings.random_unique
end

local function destroygui(player)
	if not player then return end
	local rootgui = player.gui.screen
	if rootgui[SCOMBINATOR_NAME] then
		rootgui[SCOMBINATOR_NAME].destroy()
		player.play_sound({path = SCOMBINATOR_CLOSE_SOUND})
	end
end

local function handle_close(e)
	destroygui(game.get_player(e.player_index))
end

local function on_gui_closed(e)
	if not e.element or e.element.name ~= SCOMBINATOR_NAME then return end
	destroygui(game.get_player(e.player_index))
end

local function handle_gui_update(e)
	local element = e.element
	if not element then return end
	local comb = global.selector[element.tags.id]
	if not comb or not comb.input.valid then return end

	local settings = comb.settings

	local type = element.tags.type
	if type == "mode" then
		settings.mode = element.tags.mode
	elseif type == "interval-unit" then
		settings.update_unit = element.selected_index == 1 and "seconds" or "ticks"
	elseif type == "text" then
		local num = tonumber(element.text)
		if num == nil then return end
		if num < 0 then return end

		if element.tags.field == "interval" then
			settings.update_interval = num
		elseif element.tags.field == "index" then
			settings.index = num
		end
	elseif type == "slider" then
		settings.update_interval = element.slider_value
	elseif type == "signal" then
		if element.tags.field == "count-inputs" then
			settings.count_signal = element.elem_value
		else
			settings.index_signal = element.elem_value
		end
	elseif type == "input-order" then
		settings.descending = element.switch_state == "left"
	elseif type == "checkbox" then
		settings.random_unique = element.state
	end

	update_gui(comb, element)
	update_selector(comb)
end

local function gui_opened(comb, player)
	local rootgui = player.gui.screen

    local signal = {name="signal-A", type="virtual"}

	local entry = global.selector[comb.unit_number]

	local _, main_window = flib_gui.add(rootgui, {
		{type="frame", direction="vertical", name=SCOMBINATOR_NAME, children={
			--title bar
			{type="flow", name="titlebar", children={
				{type="label", name="title", style="frame_title", caption="title", elem_mods={ignored_by_interaction=true}},
				{type="empty-widget", style="flib_titlebar_drag_handle", elem_mods={ignored_by_interaction=true}},
				{type="sprite-button", style="frame_action_button", mouse_button_filter={"left"}, sprite="utility/close_white", hovered_sprite="utility/close_black", name=SCOMBINATOR_NAME, handler=handle_close, tags={id=comb.unit_number}}
			}},
			{type="frame", name="frame", style="inside_shallow_frame_with_padding", style_mods={padding=12, bottom_padding=9}, children={
				{type="flow", name="vflow", direction="vertical", style_mods={horizontal_align="left"}, children={
					--status
					{type="flow", style="status_flow", direction="horizontal", style_mods={vertical_align="center", horizontally_stretchable=true, bottom_padding=4}, children={
						{type="sprite", sprite=STATUS_SPRITES[comb.status] or STATUS_SPRITES_DEFAULT, style="status_image", style_mods={stretch_image_to_widget_size=true}},
						{type="label", caption={STATUS_NAMES[comb.status] or STATUS_NAMES_DEFAULT}}
					}},
					--preview
					{type="frame", name="preview_frame", style="deep_frame_in_shallow_frame", style_mods={minimal_width=0, horizontally_stretchable=true, padding=0}, children={
						{type="entity-preview", name="preview", style="wide_entity_button"},
					}},
                    --select input
                    {type="flow", name="select-input", direction="horizontal", style_mods={vertical_align="center", top_padding=8, horizontal_spacing=8}, children={
                        {type="radiobutton", style_mods=HEADING, name="btn", state=false, handler=handle_gui_update, tags={id=comb.unit_number, mode="select-input", type="mode"},
                        caption={"", {"pigo-selector-combinator-gui.select-input"}, " [img=info]"}, tooltip = { "pigo-selector-combinator-gui.select-input-description" }},
					}},
					{type="flow", name="input-index", direction="horizontal", style_mods={vertical_align="center", horizontal_spacing=8}, children={
						{type="choose-elem-button", name="elem", style="slot_button_in_shallow_frame", elem_type="signal", signal=signal, handler=handle_gui_update, tags={id=comb.unit_number, type="signal", field="select-input"}},
						{type="label", style="heading_3_label", caption={"pigo-selector-combinator-gui.select-input-index-or" }},
						{type="textfield", name="txt", style = "very_short_number_textfield", text = "0", numeric = true, allow_decimal = false, clear_and_focus_on_right_click = true, tags={id=comb.unit_number, field="index", type="text"}, handler = { [defines.events.on_gui_text_changed] = handle_gui_update }},
						{type="label", style="heading_3_label", caption={"pigo-selector-combinator-gui.select-input-index" }}
					}},
					{type="switch", name="input-direction", allow_none_state=false, switch_state="left", left_label_caption={"pigo-selector-combinator-gui.select-input-descending"}, right_label_caption={"pigo-selector-combinator-gui.select-input-ascending"}, handler=handle_gui_update, tags={id=comb.unit_number, type="input-order"}},
                    {type="line", style_mods={top_padding=4}},
					--count inputs
					{type="flow", name="count-inputs", direction="horizontal", style_mods={vertical_align="center", top_padding=8, horizontal_spacing=8}, children={
                        {type="radiobutton", style_mods=HEADING, name="btn", state=false, handler=handle_gui_update, tags={id=comb.unit_number, mode="count-inputs", type="mode"},
                        caption={"", {"pigo-selector-combinator-gui.count-inputs"}, " [img=info]"}, tooltip = { "pigo-selector-combinator-gui.count-inputs-description" }},
					}},
					{type="flow", name="signal", direction="horizontal", style_mods={vertical_align="center", horizontal_spacing=8}, children={
						{type="choose-elem-button", name="elem", style="slot_button_in_shallow_frame", elem_type="signal", signal=signal, handler=handle_gui_update, tags={id=comb.unit_number, type="signal", field="count-inputs"}},
						{type="label", style="heading_3_label", caption={"pigo-selector-combinator-gui.count-inputs-output" }}
					}},
                    {type="line", style_mods={top_padding=4}},
					--random input
                    {type="flow", name="random-input", direction="horizontal", style_mods={vertical_align="center", top_padding=8, horizontal_spacing=8}, children={
                        {type="radiobutton", name="btn", style_mods=HEADING, state=false, handler=handle_gui_update, tags={id=comb.unit_number, mode="random-input", type="mode"},
						caption={"", {"pigo-selector-combinator-gui.random-input"}, " [img=info]"}, tooltip = { "pigo-selector-combinator-gui.random-input-description" }}
					}},
					{type="flow", name="update-interval", direction="horizontal", style_mods={vertical_align="center", horizontal_spacing=8}, children={
						{type="label", style="heading_3_label", caption={"pigo-selector-combinator-gui.random-input-update-interval" }},
						{type="slider", name="slider", style_mods={horizontally_stretchable = true}, minimum_value=1, maximum_value=60, value=1, tags={id=comb.unit_number, type="slider"},handler = { [defines.events.on_gui_value_changed] = handle_gui_update } },
						{type="textfield", name="txt", style = "very_short_number_textfield", text = "1", numeric = true, allow_decimal = false, clear_and_focus_on_right_click = true, tags={id=comb.unit_number, type="text", field="interval"}, handler = { [defines.events.on_gui_text_changed] = handle_gui_update }},
						{type = "drop-down", name = "unit", style_mods={width = 90}, style="circuit_condition_comparator_dropdown", selected_index = 1, items=UNITS[1], tags={id=comb.unit_number, type="interval-unit"}, handler = { [defines.events.on_gui_selection_state_changed] = handle_gui_update, },},
					}},
					{type="checkbox", name="random-unique", caption={"pigo-selector-combinator-gui.random-input-unique"}, state=false, tags={id=comb.unit_number, type="checkbox"}, handler = handle_gui_update },
					{type="line", style_mods={top_padding=4}},
					--stack sizes
					{type="flow", name="stack-size", direction="horizontal", style_mods={vertical_align="center", top_padding=8, horizontal_spacing=8}, children={
                        {type="radiobutton", name="btn", style_mods=HEADING, state=false, handler=handle_gui_update, tags={id=comb.unit_number, mode="stack-size", type="mode"},
						caption={"", {"pigo-selector-combinator-gui.stack-size"}, " [img=info]"}, tooltip = { "pigo-selector-combinator-gui.stack-size-description" }},
					}}
				}}
			}}
		}}
	})

	update_gui(entry, main_window)

	main_window.frame.vflow.preview_frame.preview.entity = comb
	main_window.titlebar.drag_target = main_window
	main_window.force_auto_center()

	player.opened = main_window
end

local function on_gui_opened(event)
	local entity = event.entity
	if not entity or not entity.valid or entity.name ~= SCOMBINATOR_NAME then return end
	local player = game.get_player(event.player_index)
	if not player then return end

	gui_opened(entity, player)
end

flib_gui.add_handlers({
	["handle_close"] = handle_close,
    ["handle_gui_update"] = handle_gui_update
})
flib_gui.handle_events()
script.on_event(defines.events.on_gui_opened, on_gui_opened)
script.on_event(defines.events.on_gui_closed, on_gui_closed)