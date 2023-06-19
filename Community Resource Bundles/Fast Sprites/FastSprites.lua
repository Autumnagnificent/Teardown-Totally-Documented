---------------------------------------
--MAKE SURE THE AUTOMATIC FRAMEWORK----
--IS INCLUDED IN THE ENVIRONMENT-------
---------------------------------------
--https://github.com/SpunkyTheHedgeHog/Automatic-Framework
---------------------------------------

---------------------------------------
--WHAT IS THIS-------------------------
---------------------------------------
--Fast Sprites work by using Triggers--
--of type box, and a z size of 0-------
---------------------------------------
--To mark a trigger as a Fast Sprite---
--Give it the tag "sprite"-------------
---------------------------------------
--They can have many options in the----
--form of extra tags-------------------
---------------------------------------
--USAGE-------------------------------
---------------------------------------
--Call InitializeFastSprites() in init-
--Call DrawFastSprites() in tick-------
---------------------------------------
---TAGS--------------------------------
---------------------------------------
--"color"  "0,0,1,1"  for solid blue---
--You can also put any any colors------
--from the AutoColors Table------------
--"red_light"  Is the default color----
---------------------------------------
--"wireframe"  renders the sprite as---
---a wireframe plane drawn with lines--
---------------------------------------
---"oneway"  Only draws the sprite-----
---When the camera is infront of it----
---------------------------------------
---"additive"  Sets the additive-------
---setting of DrawSprite to true-------
---------------------------------------
---"id"  Fast Sprites are added to a---
---# indexed table called FastSprites--
---Setting an-id will make this sprite-
---be added as FastSprites[id] instead-
---------------------------------------
---Additional Tags---------------------
---If InitializeFastSprites-is given---
---a table of strings, it will add-----
---them as values for each sprite------
---------------------------------------
---------------------------------------
---------------------------------------
---I Recommend using Type Filtering----
---and enabling Triggers so you can----
---see all triggers in the editor------
---without having to select them-------
---------------------------------------

---------------------------------------
---CREATED BY AUTUMNATIC / AUTUMN------
---------------------------------------

---@class FastSprite {}
---@field pos vector
---@field rot quaternion
---@field size { [1]:number, [2]:number }
---@field color table
---@field wireframe boolean
---@field oneway boolean
---@field additive boolean

local function TagOrDefault(entity, tag, default)
    local has = HasTag(entity, tag)
    return has and GetTagValue(entity, tag) or default
end

---@param additional_tags table<string>?
function InitializeFastSprites(additional_tags)
    ---@type table<FastSprite>
    FastSprites = FastSprites or {}
    
    for _, trigger in pairs(FindTriggers('sprite', true)) do
        ---@type FastSprite
        local data = {}
        
        -- Initial Setup
        local orginal_transform = GetTriggerTransform(trigger)
        data.pos, data.rot = orginal_transform.pos, orginal_transform.rot
        SetTriggerTransform(trigger, Transform())
        data.size = AutoSwizzle(VecScale(GetTriggerBounds(trigger), 2), 'xy')

        -- Technicals
        local id = TagOrDefault(trigger, 'id', #FastSprites + 1)

        -- Visuals
        local colorTag = TagOrDefault(trigger, 'color', 'red_light')
        data.color = AutoColors[colorTag] or AutoSplit(colorTag, ',', true)
        data.wireframe = HasTag(trigger, 'wireframe')
        data.oneway = HasTag(trigger, 'oneway')
        data.additive = HasTag(trigger, 'additive')

        -- Additionals
        if additional_tags then
            for _, tag in pairs(additional_tags) do
                data[tag] = TagOrDefault(trigger, tag, false)
            end
        end

        Delete(trigger)
        FastSprites[id] = data
    end

    AutoInspectWatch(FastSprites, 'FastSprites', 2)
end

function DrawFastSprites()
    local camera = GetCameraTransform()
    
    for _, data in pairs(FastSprites) do
        local color = data.color
        
        if data.wireframe then
            AutoDrawPlane(data, 1, 8, data.oneway, unpack(color))
        else
            local forward = AutoTransformFwd(data)

            if not data.oneway or VecDot(VecSub(data.pos, camera.pos), forward) < 0 then
                DrawSprite(
                    AutoFlatSprite, data,
                    data.size[1], data.size[2],
                    color[1], color[2], color[3], color[4] or 1,
                    true, data.additive
                )
            end
        end
    end
end

function AngleToFastSprite(id, pos)
    local data = FastSprites[id]
    local forward = AutoTransformFwd(data)
    return -math.acos(VecDot(VecSub(data.pos, pos), forward))
end