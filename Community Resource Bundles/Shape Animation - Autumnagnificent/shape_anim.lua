--[[
    Shape Animation Framework, provides tools for moving shapes within a body in a armature like fashion
]]

--[[
    This framework is meant to be loaded in as a file, not using #include.
    
    As of now this framework requires the latest version of the Automatic Framework.
    The Automatic Framework should be present within the environment, either via injecting or metatables

    CREATED BY AUTUMNAGNIFICENT / AUTUMNATIC / AUTUMN
]]

shape_anim = {}

local getTransformTable = {
	body = GetBodyTransform,
	location = GetLocationTransform,
	shape = GetShapeWorldTransform,
	light = GetLightTransform,
	trigger = GetTriggerTransform,
    vehicle = GetVehicleTransform,
}

---@class shape_animation_shape_bone:      { handle:shape_handle, transform:transform, tags:table<string, string> }
---@class shape_animation_bone:            { transform:transform, shape_bones:shape_animation_shape_bone[], tags:table<string, string> }
---@class shape_animation:                 { xml:string, body:body_handle, bones:table<string, shape_animation_bone>, shapes:shape_handle[], transformations:table<string, transform>, entities:entity_handle[], origin:transform, scale:number }
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
		transform = TransformToParentTransform(transform, bone.transform)

        local add = self.transformations[bid]
        if add then
            if self.scale ~= 1 then add.pos = VecScale(add.pos, self.scale) end

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
    return AutoTableSub(self.bones[id].shape_bones, 'handle')
    -- return AutoTableSub(self.shapes[id], 'handle')
end

---@param id string
---@param transformation transform
function animation_class:SetTransformation(id, transformation)
    self.transformations[id] = transformation
end

function animation_class:ApplyRig()
    for bone_id, bone_data in pairs(self.bones) do
        local bone_transform = self:GetBoneLocalTransform(bone_id)

        for i, shape_data in pairs(bone_data.shape_bones) do
            if IsHandleValid(shape_data.handle) then
                local shape_transform = TransformToParentTransform(bone_transform, shape_data.transform)
                SetShapeLocalTransform(shape_data.handle, shape_transform)
            end
        end
    end
end

--------------------------------------------------------------------------------------------------------------------------------

---@param xml string
---@param parent_body body_handle The Parent Body
---@return shape_animation
function shape_anim.Create(xml, parent_body, world_origin, scale)
    if not xml then error('xml not defined, xml = ' .. AutoToString(xml)) end

    local origin = world_origin and TransformToLocalTransform(GetBodyTransform(parent_body), world_origin) or Transform()

    ---@type shape_animation
    local anim = { body = parent_body, bones = {}, shapes = {}, transformations = {}, origin = origin, scale = scale or 1 }
    setmetatable(anim, animation_class)

    local entities = Spawn(xml, origin, true, false)
    anim.entities = entities

    local bone_handles_by_id = {}
    local transforms_by_handle = {}

    for _, ent in pairs(entities) do
        ---@type shape_animation_bone|shape_animation_shape_bone
        local entity_data = {}
        local handle_type = GetEntityType(ent)

        entity_data.tags = AutoGetTags(ent)

        -- Gets the transform from the spawn origin of the weapon
        local transform_f = getTransformTable[handle_type]
        local transform = transform_f and TransformToLocalTransform(origin, transform_f(ent)) or Transform()

        if anim.scale ~= 1 then transform.pos = VecScale(transform.pos, anim.scale) end
        
        if handle_type ~= "shape" then
            transforms_by_handle[ent] = transform
            
            local id = entity_data.tags.id

            if id then
                bone_handles_by_id[id] = ent
                entity_data.shape_bones = {}
                anim.bones[id] = entity_data
            end
        else
            if anim.scale ~= 1 then
                local old_ent = ent
                local scaled_vox_xml = string.format('<vox file="tool/wire.vox" scale="%s"/>', anim.scale)
                local new_ent = Spawn(scaled_vox_xml, GetShapeWorldTransform(old_ent), true, false)[1]
                
                SetShapeBody(new_ent, GetShapeBody(old_ent))
                CopyShapeContent(old_ent, new_ent)
                CopyShapePalette(old_ent, new_ent)

                
                ent = new_ent
                AutoSetTags(ent, entity_data.tags)
                Delete(old_ent)
            end

            transforms_by_handle[ent] = transform
            
            entity_data.handle = ent
            anim.shapes[#anim.shapes+1] = ent

            local shape_body = GetShapeBody(ent)
            local shape_body_tags = AutoGetTags(shape_body)

            local shape_bones = anim.bones[shape_body_tags.id].shape_bones
            shape_bones[#shape_bones+1] = entity_data
        end
    end

    for id, bone in pairs(anim.bones) do
        local bone_handle = bone_handles_by_id[id]
        local bone_transform = transforms_by_handle[bone_handle]
        
        local order = AutoSplit(id, '.')
        local last_id = table.concat(order, '.', 1, #order - 1)

        if last_id and anim.bones[last_id] then
            bone.transform = TransformToLocalTransform(transforms_by_handle[bone_handles_by_id[last_id]], bone_transform)
        else
            bone.transform = TransformCopy(bone_transform)
        end

        for _, shape_bone in pairs(bone.shape_bones) do
            shape_bone.transform = TransformToLocalTransform(bone_transform, transforms_by_handle[shape_bone.handle])
            SetShapeBody(shape_bone.handle, anim.body)
        end
        
        anim.bones[id] = bone
    end

    for id, handle in pairs(bone_handles_by_id) do
        Delete(handle)
    end

    anim:ApplyRig()

    return anim
end

---@param shapes shape_handle[]
---@param transform transform
---@param density number
---@return shape_handle[] colliders
function shape_anim.FakeScaledPhysics(shapes, body, transform, density)
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

---@param xml_original td_path|string
---@param xml_keyframes table<any, td_path|string>
function shape_anim.ExportAsTransformations(xml_original, xml_keyframes)
    local original_anim = shape_anim.Create(xml_original, GetWorldBody(), Transform())
    
    local transformation_tables = {}
    
    for k, xml in pairs(xml_keyframes) do
        local keyframe_anim = shape_anim.Create(xml, GetWorldBody(), Transform())

        local tt = {}

        for bone_id, _ in pairs(original_anim.bones) do
            local difference = TransformToLocalTransform(original_anim.bones[bone_id].transform, keyframe_anim.bones[bone_id].transform)
            tt[bone_id] = difference
        end
        
        transformation_tables[k] = tt
    end

    return transformation_tables
end

return shape_anim