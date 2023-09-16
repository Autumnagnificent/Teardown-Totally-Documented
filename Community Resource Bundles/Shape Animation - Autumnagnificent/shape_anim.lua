--[[
    This framework is meant to be loaded in as a file, not using #include.
    The loading method I use is `Serve_File`, found in the Serve resource bundle.
    
    As of now this framework requires the latest version of The Automatic framework.
    The Automatic framework should be present within the environment, either via injecting or metatables (*if you are using Serve, this should be handled automatically*).
]]

Animation = {}

---@class bone:            { handle:body_handle, tags:table<string, string>, transform:transform, local_transform:transform }
---@class bone_shape_data: { handle:shape_handle, tags:table<string, string>, transform:transform, local_transform:transform }
---@class animation_data:  { xml:string, body:body_handle, bones:table<string, bone>, shapes:table<string, bone_shape_data[]>, transformations:transform[] }

local getTransformTable = {
	body = GetBodyTransform,
	location = GetLocationTransform,
	shape = GetShapeWorldTransform,
	light = GetLightTransform,
	trigger = GetTriggerTransform,
	vehicle = GetVehicleTransform,
}

---@param xml string
---@param parent_body body_handle The Parent Body
---@return animation_data
function Animation.Init(xml, parent_body)
    if not xml then error('xml not defined, xml = ' .. AutoToString(xml)) end

    local anim = { body = parent_body, bones = {}, shapes = {}, transformations = {} }

    local origin = Transform()
    local entities = Spawn(xml, origin, true, false)

    for _, ent in pairs(entities) do
        local data = {}
        local handle_type = GetEntityType(ent)

        data.handle = ent
        data.tags = AutoGetTags(data.handle)

        -- Gets the transform from the spawn origin of the weapon
        data.transform = TransformToLocalTransform(origin, getTransformTable[handle_type](data.handle))

        if handle_type ~= "shape" then
            local id = data.tags.id
            anim.bones[id] = data
            anim.shapes[id] = {}
        else
            local body = GetShapeBody(data.handle)
            local body_tags = AutoGetTags(body)

            local shape_parent = anim.shapes[body_tags.id]
            shape_parent[#shape_parent + 1] = data
        end
    end

    for id, bone in pairs(anim.bones) do
        local order = AutoSplit(id, '.')

        local last_id = table.concat(order, '.', 1, #order - 1)
        if last_id and anim.bones[last_id] then
            bone.local_transform = TransformToLocalTransform(anim.bones[last_id].transform, bone.transform)
        else
            bone.local_transform = TransformCopy(bone.transform)
        end

        anim.bones[id] = bone
    end

    for bone_id, connected_shapes in pairs(anim.shapes) do
        for i, shape_data in pairs(connected_shapes) do
            local parent_bone = anim.bones[bone_id]
            shape_data.local_transform = TransformToLocalTransform(parent_bone.transform, shape_data.transform)

            anim.shapes[bone_id][i] = shape_data
        end
    end

    for bone_id, connected_shapes in pairs(anim.shapes) do
        for i, shape_data in pairs(connected_shapes) do
            SetShapeBody(shape_data.handle, anim.body, Transform(AutoVecOne(1 / 0)))
        end
    end

    for id, bone in pairs(anim.bones) do
        Delete(bone.handle)
    end

    return anim
end


---@param anim animation_data
---@param id string
---@return transform
function Animation.GetBoneLocalTransform(anim, id)
	local order = AutoSplit(id, '.')
	local transform = Transform()

	for o = 1, #order do
		local bid = table.concat(order, '.', 1, o)
        local bone = anim.bones[bid]
        if not bone then error(string.format('[ANIM] : Bone not found, searched for [%s], given id [%s]', AutoToString(bid), AutoToString(id))) end
		transform = TransformToParentTransform(transform, bone.local_transform)

		local add = anim.transformations[bid]
		if add then
			transform = TransformToParentTransform(transform, add)
		end
	end

	return transform
end

---@param anim animation_data
---@param id string
---@return transform
function Animation.GetBoneWorldTransform(anim, id)
    local body_world_transform = GetBodyTransform(anim.body)
    local bone_local_transform = Animation.GetBoneLocalTransform(anim, id)

    return TransformToParentTransform(body_world_transform, bone_local_transform)
end

---@param anim animation_data
---@return shape_handle[]
function Animation.GetShapes(anim)
    local t = {}
    for id, data_table in pairs(anim.shapes) do
        AutoTableConcat(t, AutoTableSub(data_table, 'handle'))
    end
    return t
end

---@param anim animation_data
---@param id string
---@return shape_handle[]
function Animation.GetShapesOfBone(anim, id)
    return AutoTableSub(anim.shapes[id], 'handle')
end

---@param anim animation_data
---@param id string
---@param transformation transform
function Animation.SetTransformation(anim, id, transformation)
    anim.transformations[id] = transformation
end

---@param anim animation_data
function Animation.ApplyRig(anim)
    for bone_id, connected_shapes in pairs(anim.shapes) do
        local bone_transform = Animation.GetBoneLocalTransform(anim, bone_id)

        for i, shape_data in pairs(connected_shapes) do
            if IsHandleValid(shape_data.handle) then
                local shape_transform = TransformToParentTransform(bone_transform, shape_data.local_transform)
                SetShapeLocalTransform(shape_data.handle, shape_transform)
            end
        end
    end
end

return Animation