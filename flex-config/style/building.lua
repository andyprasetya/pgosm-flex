require "helpers"

local tables = {}


tables.building_point = osm2pgsql.define_table({
    name = 'building_point',
    schema = schema_name,
    ids = { type = 'node', id_column = 'osm_id' },
    columns = {
        { column = 'osm_type',     type = 'text' , not_null = true},
        { column = 'name',     type = 'text' },
        { column = 'levels',  type = 'int'},
        { column = 'height',  type = 'numeric'},
        { column = 'housenumber', type = 'text'},
        { column = 'street',     type = 'text' },
        { column = 'city',     type = 'text' },
        { column = 'state', type = 'text'},
        { column = 'wheelchair', type = 'bool'},
        { column = 'operator', type = 'text'},
        { column = 'geom',     type = 'point', projection = srid},
    }
})


tables.building_polygon = osm2pgsql.define_table({
    name = 'building_polygon',
    schema = schema_name,
    ids = { type = 'way', id_column = 'osm_id' },
    columns = {
        { column = 'osm_type',     type = 'text' , not_null = true},
        { column = 'name',     type = 'text' },
        { column = 'levels',  type = 'int'},
        { column = 'height',  type = 'numeric'},
        { column = 'housenumber', type = 'text'},
        { column = 'street',     type = 'text' },
        { column = 'city',     type = 'text' },
        { column = 'state', type = 'text'},
        { column = 'wheelchair', type = 'bool'},
        { column = 'operator', type = 'text'},
        { column = 'geom',     type = 'multipolygon', projection = srid},
    }
})



function building_process_node(object)
    if not object.tags.building
            and not object.tags['building:part']
            then
        return
    end

    local osm_type
    if object.tags.building then
        osm_type = object:grab_tag('building')
    elseif object.tags['building:part'] then
        osm_type = 'building_part'
    else
        osm_type = 'unknown'
    end

    local name = get_name(object.tags)
    local street = object:grab_tag('addr:street')
    local city = object:grab_tag('addr:city')
    local state = object:grab_tag('addr:state')
    local wheelchair = object:grab_tag('wheelchair')
    local levels = object:grab_tag('building:levels')
    local height = parse_to_meters(object.tags['height'])
    local housenumber  = object:grab_tag('addr:housenumber')
    local operator  = object:grab_tag('operator')

    tables.building_point:add_row({
        osm_type = osm_type,
        name = name,
        housenumber = housenumber,
        street = street,
        city = city,
        state = state,
        wheelchair = wheelchair,
        levels = levels,
        height = height,
        operator = operator,
        geom = { create = 'point' }
    })


end


function building_process_way(object)
    if not object.tags.building
            and not object.tags['building:part']
            then
        return
    end

    if not object.is_closed then
        return
    end

    local osm_type
    if object.tags.building then
        osm_type = object:grab_tag('building')
    elseif object.tags['building:part'] then
        osm_type = 'building_part'
    else
        osm_type = 'unknown'
    end

    local name = get_name(object.tags)
    local street = object:grab_tag('addr:street')
    local city = object:grab_tag('addr:city')
    local state = object:grab_tag('addr:state')
    local wheelchair = object:grab_tag('wheelchair')
    local levels = object:grab_tag('building:levels')
    local height = parse_to_meters(object.tags['height'])
    local housenumber  = object:grab_tag('addr:housenumber')
    local operator  = object:grab_tag('operator')

    tables.building_polygon:add_row({
        osm_type = osm_type,
        name = name,
        housenumber = housenumber,
        street = street,
        city = city,
        state = state,
        wheelchair = wheelchair,
        levels = levels,
        height = height,
        operator = operator,
        geom = { create = 'area' }
    })


end



if osm2pgsql.process_way == nil then
    osm2pgsql.process_way = building_process_way
else
    local nested = osm2pgsql.process_way
    osm2pgsql.process_way = function(object)
        local object_copy = deep_copy(object)
        nested(object)
        building_process_way(object_copy)
    end
end


if osm2pgsql.process_node == nil then
    osm2pgsql.process_node = building_process_node
else
    local nested = osm2pgsql.process_node
    osm2pgsql.process_node = function(object)
        local object_copy = deep_copy(object)
        nested(object)
        building_process_node(object_copy)
    end
end
