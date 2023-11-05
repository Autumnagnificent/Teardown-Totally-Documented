--[[
    Shape Animation Framework, provides tools for moving shapes within a body in a armature like fashion
]]

--[[
    This framework is meant to be loaded in as a file, not using #include.
    
    As of now this framework requires the latest version of the Automatic Framework.
    The Automatic Framework should be present within the environment, either via injecting or metatables

    CREATED BY AUTUMNAGNIFICENT / AUTUMNATIC / AUTUMN
]]

Shape_Animation = {}

local getTransformTable = {
	body = GetBodyTransform,
	location = GetLocationTransform,
	shape = GetShapeWorldTransform,
	light = GetLightTransform,
	trigger = GetTriggerTransform,
    vehicle = GetVehicleTransform,
}

---@class shape_animation_bone:            { handle:body_handle, tags:table<string, string>, transform:transform, local_transform:transform }
---@class shape_animation_bone_shape_data: { handle:shape_handle, tags:table<string, string>, transform:transform, local_transform:transform }
---@class shape_animation:                 { xml:string, body:body_handle, bones:table<string, shape_animation_bone>, shapes:table<string, shape_animation_bone_shape_data[]>, transformations:transform[], entities:entity_handle[], origin:transform }
local animation_class = {}
animation_class.__index = animation_class

function animation_class:Reject()
    AutoQueryRejectShapes(self.shapes)
end

---@param id string
---@return transform
function animation_class:GetBoneLocalTransform(id)
	local order = AutoSplit(id, '.')
	local transform = Transform()

	for o = 1, #order do
		local bid = table.concat(order, '.', 1, o)
        local bone = self.bones[bid]
        if not bone then error(string.format('[ANIM] : Bone not found, searched for [%s], given id [%s]', AutoToString(bid), AutoToString(id))) end
		transform = TransformToParentTransform(transform, bone.local_transform)

		local add = self.transformations[bid]
		if add then
			transform = TransformToParentTransform(transform, add)
		end
	end

	return TransformToParentTransform(self.origin, transform)
end

---@param id string
---@return transform
function animation_class:GetBoneWorldTransform(id)
    local body_world_transform = GetBodyTransform(self.body)
    local bone_local_transform = self:GetBoneLocalTransform(id)

    return TransformToParentTransform(body_world_transform, bone_local_transform)
end

---@param id string
---@return shape_handle[]
function animation_class:GetShapesOfBone(id)
    return AutoTableSub(self.shapes[id], 'handle')
end

---@param id string
---@param transformation transform
function animation_class:SetTransformation(id, transformation)
    self.transformations[id] = transformation
end

function animation_class:ApplyRig()
    for bone_id, connected_shapes in pairs(self.shapes) do
        local bone_transform = self:GetBoneLocalTransform(bone_id)

        for i, shape_data in pairs(connected_shapes) do
            if IsHandleValid(shape_data.handle) then
                local shape_transform = TransformToParentTransform(bone_transform, shape_data.local_transform)
                SetShapeLocalTransform(shape_data.handle, shape_transform)
            end
        end
    end
end

--------------------------------------------------------------------------------------------------------------------------------

---@param xml string
---@param parent_body body_handle The Parent Body
---@return shape_animation
function Shape_Animation.Create(xml, parent_body, world_origin)
    if not xml then error('xml not defined, xml = ' .. AutoToString(xml)) end

    local origin = world_origin and TransformToLocalTransform(GetBodyTransform(parent_body), world_origin) or Transform()
    local anim = { body = parent_body, bones = {}, shapes = {}, transformations = {}, origin = origin }
    setmetatable(anim, animation_class)

    local entities = Spawn(xml, origin, true, false)
    anim.entities = entities

    for _, ent in pairs(entities) do
        local data = {}
        local handle_type = GetEntityType(ent)

        data.handle = ent
        data.tags = AutoGetTags(data.handle)

        -- Gets the transform from the spawn origin of the weapon
        local transform_f = getTransformTable[handle_type]
        data.transform = transform_f and TransformToLocalTransform(origin, transform_f(data.handle)) or Transform()

        if handle_type ~= "shape" then
            local id = data.tags.id
            if id then
                anim.bones[id] = data
                anim.shapes[id] = {}
            end
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

    anim:ApplyRig()

    return anim
end

---@param shapes shape_handle[]
---@param transform transform
---@param density number
---@return shape_handle[] colliders
function Shape_Animation.FakeScaledPhysics(shapes, body, transform, density)
    colliders = {}
    
    for _, s in pairs(shapes) do
        if IsHandleValid(s) then
            local shape_world_transform = GetShapeWorldTransform(s)
            local new_transform = TransformToLocalTransform(transform, shape_world_transform)

            local x, y, z, scale = GetShapeSize(s)
            local shape_local_size = Vec(x, y, z)
            local shape_world_size = VecScale(shape_local_size, scale)

            local new_size = AutoVecCeil(VecScale(shape_world_size, 10))
            local offset = VecScale(new_size, -0.1)
            local centered_transform = AutoTransformOffset(new_transform, VecAdd(shape_world_size, offset))

            local xml = ('<vox file="tool/wire.vox" density="%s"/>'):format(density or 0.5)
            local collider_shape = Spawn(xml, Transform(), true, true)[1]

            ResizeShape(collider_shape, 0, 0, 0, new_size[1] - 1, new_size[2] - 1, new_size[3] - 1)
            SetBrush('cube', -1, 1)
            DrawShapeBox(collider_shape, 0, 0, 0, new_size[1] - 1, new_size[2] - 1, new_size[3] - 1)

            SetShapeBody(collider_shape, body, centered_transform)
            SetTag(collider_shape, 'invisible')
            SetTag(collider_shape, 'unbreakable')
            colliders[#colliders + 1] = collider_shape
        end
    end

    return colliders
end

return Shape_Animation