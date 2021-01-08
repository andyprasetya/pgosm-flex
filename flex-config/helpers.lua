

-- deep_copy based on copy2: https://gist.github.com/tylerneylon/81333721109155b2d244
function deep_copy(obj)
    if type(obj) ~= 'table' then return obj end
    local res = setmetatable({}, getmetatable(obj))
    for k, v in pairs(obj) do res[deep_copy(k)] = deep_copy(v) end
    return res
end


-- Function make_check_in_list_func from: https://github.com/openstreetmap/osm2pgsql/blob/master/flex-config/compatible.lua
function make_check_in_list_func(list)
    local h = {}
    for _, k in ipairs(list) do
        h[k] = true
    end
    return function(tags)
        for k, _ in pairs(tags) do
            if h[k] then
                return true
            end
        end
        return false
    end
end

-- parses height tag, units in meters
function parse_height(input)
    if not input then
        return nil
    end

    local height = tonumber(input)

    -- If height is just a number, it is in meters, just return it
    if height then
        return height
    end

    -- If there is an 'ft' at the end, convert to meters and return
    if input:sub(-2) == 'ft' then
        local num = tonumber(input:sub(1, -3))
        if num then
            return num * 0.3048
        end
    end

    return nil
end


-- Parse an ele value like "1800", "1955 m" or "8001 ft" and return a number in meters
function parse_ele(input)
    if not input then
        return nil
    end

    local ele = tonumber(input)

    -- If ele is just a number, it is in meters, so just return it
    if ele then
        return ele
    end

    -- If there is an 'm ' at the end, strip off and return
    if input:sub(-1) == 'm' then
        local num = tonumber(input:sub(1, -2))
        if num then
            return num
        end
    end

    -- If there is an 'ft' at the end, strip off and return
    if input:sub(-2) == 'ft' then
        local num = tonumber(input:sub(1, -3))
        if num then
            return math.floor(num * 0.3048)
        end
    end

    return nil
end


-- Parse a maxspeed value like "30" or "55 mph" and return a number in km/h
-- from osm2pgsql/flex-config/data-types.lua
function parse_speed(input)
    if not input then
        return nil
    end

    local maxspeed = tonumber(input)

    -- If maxspeed is just a number, it is in km/h, so just return it
    if maxspeed then
        return maxspeed
    end

    -- If there is an 'mph' at the end, convert to km/h and return
    if input:sub(-3) == 'mph' then
        local num = tonumber(input:sub(1, -4))
        if num then
            return math.floor(num * 1.60934)
        end
    end

    return nil
end


function parse_layer_value(input)
    -- Quick return
    if not input then
        return 0
    end

    -- Try getting a number
    local layer = tonumber(input)
    if layer then
        return layer
    end

    -- Fallback
    return 0
end