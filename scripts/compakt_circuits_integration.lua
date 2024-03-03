function add_compakt_circuits_integration()
    if not remote.interfaces["compaktcircuit"] then
        return
    end

    local driver = {
        name = SCOMBINATOR_NAME,
        packed_names = { SCOMBINATOR_NAME_PACKED, SCOMBINATOR_OUT_NAME_PACKED },
        interface_name = SCOMBINATOR_NAME
    }
    remote.call("compaktcircuit", "add_combinator", driver)

    remote.add_interface(SCOMBINATOR_NAME,
        {
            get_info = function(entity)
                return {
                    [SCOMBINATOR_NAME] = table.deepcopy(global.selector[entity.unit_number].settings),
                    unpacked_unit_number = entity.unit_number
                }
            end,

            ---@param surface LuaSurface
            ---@param position MapPosition
            ---@param force LuaForce
            create_packed_entity = function(info, surface, position, force)
                local settings = info[SCOMBINATOR_NAME]

                local packed_input = surface.create_entity {
                    name = SCOMBINATOR_NAME_PACKED,
                    force = force,
                    position = position,
                    raise_built = true,
                }

                if packed_input then
                    global.selector[packed_input.unit_number].settings = settings
                end

                return packed_input
            end,

            create_entity = function(info, surface, force)
                local entity = surface.create_entity { name = SCOMBINATOR_NAME, force = force, position = info.position,
                    direction = info.direction }
                local cb = entity.get_or_create_control_behavior()
                cb.set_signal(1, { signal = { type = "item", name = "iron-ore" }, count = info.value })
                return entity
            end

        })
end

script.on_load(add_compakt_circuits_integration)
script.on_init(add_compakt_circuits_integration)
