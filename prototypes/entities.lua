local selector_entity = flib.copy_prototype(data.raw["arithmetic-combinator"]["arithmetic-combinator"], SCOMBINATOR_NAME)
selector_entity.icon = "__pigo-selector-combinator__/graphics/combinator/selector-combinator-icon.png"

local COMBINATOR_SPRITE = "__pigo-selector-combinator__/graphics/combinator/selector-combinator.png"
local COMBINATOR_HR_SPRITE = "__pigo-selector-combinator__/graphics/combinator/hr-selector-combinator.png"
local COMBINATOR_SHADOW = "__base__/graphics/entity/combinator/arithmetic-combinator-shadow.png"
local COMBINATOR_HR_SHADOW = "__base__/graphics/entity/combinator/hr-arithmetic-combinator-shadow.png"

selector_entity.sprites = {
	north = {layers = {
		{
			filename=COMBINATOR_SPRITE,
			priority="high",
			x=0, y=0,
			width=74, height=64,
			frame_count=1,
			shift={ 0.03125, 0.25, },
			scale=1,
			hr_version={
				filename=COMBINATOR_HR_SPRITE,
				priority="high",
				x=0, y=0,
				width=144, height=124,
				frame_count=1,
				shift={ 0.015625, 0.234375, },
				scale=0.5,
			},
		},
		{
			filename=COMBINATOR_SHADOW,
			priority="high",
			x=0, y=0,
			width=76, height=78,
			frame_count=1,
			shift={ 0.4375, 0.75, },
			draw_as_shadow=true,
			scale=1,
			hr_version={
				filename=COMBINATOR_HR_SHADOW,
				priority="high",
				x=0, y=0,
				width=148, height=156,
				frame_count=1,
				shift={ 0.421875, 0.765625, },
				draw_as_shadow=true,
				scale=0.5,
			},
		}
	}},
	east = {layers={
		{
			filename=COMBINATOR_SPRITE,
			priority="high",
			x=74, y=0,
			width=74, height=64,
			frame_count=1,
			shift={ 0.03125, 0.25, },
			scale=1,
			hr_version={
				filename=COMBINATOR_HR_SPRITE,
				priority="high",
				x=144, y=0,
				width=144, height=124,
				frame_count=1,
				shift={ 0.015625, 0.234375, },
				scale=0.5,
			},
		},
		{
			filename=COMBINATOR_SHADOW,
			priority="high",
			x=76, y=0,
			width=76, height=78,
			frame_count=1,
			shift={ 0.4375, 0.75, },
			draw_as_shadow=true,
			scale=1,
			hr_version={
				filename=COMBINATOR_HR_SHADOW,
				priority="high",
				x=148, y=0,
				width=148, height=156,
				frame_count=1,
				shift={ 0.421875, 0.765625, },
				draw_as_shadow=true,
				scale=0.5,
			},
		},
	}},
	south = {layers={
		{
			filename=COMBINATOR_SPRITE,
			priority="high",
			x=148, y=0,
			width=74, height=64,
			frame_count=1,
			shift={ 0.03125, 0.25, },
			scale=1,
			hr_version={
				filename=COMBINATOR_HR_SPRITE,
				priority="high",
				x=288, y=0,
				width=144, height=124,
				frame_count=1,
				shift={ 0.015625, 0.234375, },
				scale=0.5,
			},
		},
		{
			filename=COMBINATOR_SHADOW,
			priority="high",
			x=152, y=0,
			width=76, height=78,
			frame_count=1,
			shift={ 0.4375, 0.75, },
			draw_as_shadow=true,
			scale=1,
			hr_version={
				filename=COMBINATOR_HR_SHADOW,
				priority="high",
				x=296, y=0,
				width=148, height=156,
				frame_count=1,
				shift={ 0.421875, 0.765625, },
				draw_as_shadow=true,
				scale=0.5,
			},
		}
	}},
	west = {layers={
		{
			filename=COMBINATOR_SPRITE,
			priority="high",
			x=222, y=0,
			width=74, height=64,
			frame_count=1,
			shift={ 0.03125, 0.25, },
			scale=1,
			hr_version={
				filename=COMBINATOR_HR_SPRITE,
				priority="high",
				x=432, y=0,
				width=144, height=124,
				frame_count=1,
				shift={ 0.015625, 0.234375, },
				scale=0.5,
			},
		},
		{
			filename=COMBINATOR_SHADOW,
			priority="high",
			x=228, y=0,
			width=76, height=78,
			frame_count=1,
			shift={ 0.4375, 0.75, },
			draw_as_shadow=true,
			scale=1,
			hr_version={
				filename=COMBINATOR_HR_SHADOW,
				priority="high",
				x=444, y=0,
				width=148, height=156,
				frame_count=1,
				shift={ 0.421875, 0.765625, },
				draw_as_shadow=true,
				scale=0.5,
			},
		}
	}},
}

local function create_combinator_display_direction(x, y, shift)
	return {
			filename="__pigo-selector-combinator__/graphics/combinator/selector-displays.png",
			x=x, y=y,
			width=15, height=11,
			shift=shift,
			draw_as_glow=true,
			hr_version={
				scale=0.5,
				filename="__pigo-selector-combinator__/graphics/combinator/hr-selector-displays.png",
				x=2*x, y=2*y,
				width=30, height=22,
				shift=shift,
				draw_as_glow=true,
			},
		}
end
local function create_combinator_display(x, y, shiftv, shifth)
	return {
		north=create_combinator_display_direction(x, y, shiftv),
		east=create_combinator_display_direction(x, y, shifth),
		south=create_combinator_display_direction(x, y, shiftv),
		west=create_combinator_display_direction(x, y, shifth),
	}
end

selector_entity.multiply_symbol_sprites =   create_combinator_display(15, 0,  { 0, -0.140625, }, { 0, -0.328125, })
selector_entity.divide_symbol_sprites =     create_combinator_display(30, 0, { 0, -0.140625, }, { 0, -0.328125, })
selector_entity.plus_symbol_sprites =       create_combinator_display(0, 0, { 0, -0.140625, }, { 0, -0.328125, })
selector_entity.minus_symbol_sprites =      create_combinator_display(45, 0, { 0, -0.140625, }, { 0, -0.328125, })
selector_entity.modulo_symbol_sprites =     create_combinator_display(60, 0, { 0, -0.140625, }, { 0, -0.328125, })

local selector_out_entity = flib.copy_prototype(data.raw["constant-combinator"]["constant-combinator"], SCOMBINATOR_OUT_NAME)
selector_out_entity.icon = nil
selector_out_entity.icon_size = nil
selector_out_entity.icon_mipmaps = nil
selector_out_entity.next_upgrade = nil
selector_out_entity.minable = nil
selector_out_entity.selection_box = nil
selector_out_entity.collision_box = nil
selector_out_entity.collision_mask = {}
selector_out_entity.item_slot_count = 500
selector_out_entity.circuit_wire_max_distance = 3
selector_out_entity.flags = {"not-blueprintable", "not-deconstructable", "placeable-off-grid"}

local origin = {0.0, 0.0}
local invisible_sprite = {filename = "__core__/graphics/empty.png", width = 1, height = 1}
local wire_con1 = {
	red = origin,
	green = origin
}
local wire_con0 = {wire = wire_con1, shadow = wire_con1}
selector_out_entity.sprites = invisible_sprite
selector_out_entity.activity_led_sprites = invisible_sprite
selector_out_entity.activity_led_light = {
	intensity = 0,
	size = 0,
}
selector_out_entity.activity_led_light_offsets = {origin, origin, origin, origin}
selector_out_entity.draw_circuit_wires = false
selector_out_entity.circuit_wire_connection_points = {
	wire_con0,
	wire_con0,
	wire_con0,
	wire_con0
}

local selector_packed_entity = flib.copy_prototype(selector_entity, SCOMBINATOR_NAME_PACKED)
selector_packed_entity.flags = { "placeable-off-grid", "hidden", "hide-alt-info", "not-on-map", "not-upgradable",
	"not-deconstructable", "not-blueprintable" }
selector_packed_entity.collision_mask = {}
selector_packed_entity.collision_box = nil
selector_packed_entity.minable = nil
selector_packed_entity.selectable_in_game = false
selector_packed_entity.sprites = invisible_sprite
selector_packed_entity.multiply_symbol_sprites = invisible_sprite
selector_packed_entity.divide_symbol_sprites = invisible_sprite
selector_packed_entity.plus_symbol_sprites = invisible_sprite
selector_packed_entity.minus_symbol_sprites = invisible_sprite
selector_packed_entity.modulo_symbol_sprites = invisible_sprite

local selector_out_packed_entity = flib.copy_prototype(selector_out_entity, SCOMBINATOR_OUT_NAME_PACKED)
selector_out_packed_entity.flags = { "placeable-off-grid", "hidden", "hide-alt-info", "not-on-map", "not-upgradable",
	"not-deconstructable", "not-blueprintable" }
selector_out_packed_entity.collision_mask = {}
selector_out_packed_entity.collision_box = nil
selector_out_packed_entity.minable = nil
selector_out_packed_entity.selectable_in_game = false

data:extend { selector_entity, selector_out_entity, selector_packed_entity, selector_out_packed_entity }
