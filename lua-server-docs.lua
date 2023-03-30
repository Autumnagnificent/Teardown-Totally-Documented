---@diagnostic disable: missing-return
---@diagnostic disable: unused-local

--[[
    Not all function are catagorized how they are in the offical api documentation
    Some are split up into more catagories, and some are moved
    into other ones to better represent their functionality
]]

--#region Types and Classes

---@meta _

---@class vector
---@feild [1]:number
---@feild [2]:number
---@feild [3]:number
---@class quaternion
---@feild [1]:number
---@feild [2]:number
---@feild [3]:number
---@feild [4]:number

---@class transform
---@field pos vector
---@field rot quaternion

---A non-negative interger that represents an index to a entity of any type in the World/Entity Table
---@class entity_handle: integer

---A non-negative interger that represents the index/handle to a body in the World/Entity Table
---@class body_handle: entity_handle
---A non-negative interger that represents the index/handle to a shape in the World/Entity Table
---@class shape_handle: entity_handle
---A non-negative interger that represents the index/handle to a joint in the World/Entity Table
---@class joint_handle: entity_handle
---A non-negative interger that represents the index/handle to a light in the World/Entity Table
---@class light_handle: entity_handle
---A non-negative interger that represents the index/handle to a script in the World/Entity Table
---@class script_handle: entity_handle
---A non-negative interger that represents the index/handle to a screen in the World/Entity Table
---@class screen_handle: entity_handle
---A non-negative interger that represents the index/handle to a location in the World/Entity Table
---@class location_handle: entity_handle
---A non-negative interger that represents the index/handle to a trigger in the World/Entity Table
---@class trigger_handle: entity_handle
---A non-negative interger that represents the index/handle to a vehicle in the World/Entity Table
---@class vehicle_handle: entity_handle
---A non-negative interger that represents the index/handle to a wheel in the World/Entity Table
---@class wheel_handle: entity_handle
---A non-negative interger that represents the index/handle to a water in the World/Entity Table
---@class water_handle: entity_handle

---A non-negative interger that represents the index/handle to a sprite in the Sprite Table
---@class sprite_handle: integer
---A non-negative interger that represents the index/handle to a sound in the Sound Table
---@class sound_handle: integer
---A non-negative interger that represents the index/handle to a sound loop in the Sound Table
---@class loop_handle: integer

---@alias key
---| "1"
---| "2"
---| "3"
---| "4"
---| "5"
---| "6"
---| "7"
---| "8"
---| "9"
---| "0"
---| "a"
---| "b"
---| "c"
---| "d"
---| "e"
---| "f"
---| "g"
---| "h"
---| "i"
---| "j"
---| "k"
---| "l"
---| "m"
---| "n"
---| "o"
---| "p"
---| "q"
---| "r"
---| "s"
---| "t"
---| "u"
---| "v"
---| "w"
---| "x"
---| "y"
---| "z"
---| "lmb"
---| "mmb"
---| "rmb"
---| "f1"
---| "f2"
---| "f3"
---| "f4"
---| "f5"
---| "f6"
---| "f7"
---| "f8"
---| "f9"
---| "f10"
---| "f11"
---| "f12"
---| "uparrow"
---| "downarrow"
---| "leftarrow"
---| "rightarrow"
---| "backspace"
---| "alt"
---| "delete"
---| "home"
---| "end"
---| "pgup"
---| "pgdown"
---| "insert"
---| "return"
---| "space"
---| "shift"
---| "ctrl"
---| "tab"
---| "esc"
---| ","
---| "."
---| "-"
---| "+" equals key
---| "any" any key
---| "up" Move forward / Accelerate
---| "down" Move backward / Brake
---| "left" Move left
---| "right" Move right
---| "interact" Interact
---| "flashlight" Flashlight
---| "jump" Jump
---| "crouch" Crouch
---| "usetool" Use tool
---| "grab" Grab
---| "handbrake" Handbrake
---| "map" Map
---| "pause" Pause game (escape)
---| "vehicleraise" Raise vehicle parts
---| "vehiclelower" Lower vehicle parts
---| "vehicleaction" Vehicle action

---@alias key_value
---| "camerax" Camera x movement, scaled by sensitivity.
---| "cameray" Camera y movement, scaled by sensitivit
---| "mousedx" Mouse horizontal diff.
---| "mousedy" Mouse vertical diff.
---| "mousewheel" Mouse wheel.

---@alias material
---| "foliage"
---| "dirt"
---| "plaster"
---| "plastic"
---| "glass"
---| "wood"
---| "masonry"
---| "hardmasonry"
---| "metal"
---| "heavymetal"
---| "hardmetal"
---| "rock"
---| "ice"
---| "unphysical"

---@alias entity_type
---| "body"
---| "shape"
---| "joint"
---| "light"
---| "script"
---| "screen"
---| "location"
---| "trigger"
---| "vehicle"
---| "wheel"
---| "water"

---@alias joint_type
---| "ball"
---| "hinge"
---| "prismatic"
---| "rope"

--#endregion
--#region Callbacks

---Called once at load time
function init() end

---Called exactly once per frame. The time step is variable but always between 0.0 and 0.0333333
---@param dt number between 0.0 and 0.0333333
function tick(dt) end

---Called at a fixed update rate, but at the most two times per frame. Time step is always 0.0166667 (60 updates per second). Depending on frame rate it might not be called at all for a particular frame.
---@param dt number 0.0166667
function update(dt) end

---Called when the 2D overlay is being draw, after the scene but before the standard HUD. Ui functions are only injected into the environment if this function is provided.
---@param dt number
function draw(dt) end

---1ssnl's documentation for now :
---
---https://x4fx77x4f.github.io/dennispedia/teardown/g/handleCommand.html
---
---NOT IN OFFICAL DOCUMENTATION
function handleCommand(command)
end

--#endregion
--#region XML Parameters

function GetIntParam() end
function GetFloatParam() end
function GetBoolParam() end
function GetStringParam() end

--#endregion
--#region Registry

function ClearKey() end
function ListKeys() end
function HasKey() end
function SetInt() end
function GetInt() end
function SetFloat() end
function GetFloat() end
function SetBool() end
function GetBool() end
function SetString() end
function GetString() end

--#endregion
--#region Vector Math

---Returns a standard lua table of 3 numbers.
---
---The default for each parameter is 0.
---
---Vec() will result in { 0, 0, 0 }
---@param x number|nil X value
---@param y number|nil Y value
---@param z number|nil Z value
---@return vector vector
function Vec(x, y, z) end

---Copies a vector to prevent multiple references pointing to the same data
---@param orginal vector
---@return vector copy
function VecCopy(orginal) end

---Gets the length of a vector
---@param vector vector
---@return number length Length (magnitude) of the vector
function VecLength(vector) end

---Normalizes a vector so it has the length of 1
---
---Normalizing a vector of length 0 returns { 0, 0, -1, }
---@param vector vector
---@return vector normalized A vector with the length of 1
function VecNormalize(vector) end

---Multiplies a vector by a scalar
---@param vector vector
---@param scalar number
---@return vector scaled_vector
function VecScale(vector, scalar) end

---Adds two vectors
---@param a vector
---@param b vector
---@return vector added_vector
function VecAdd(a, b) end

---Subtracts two vectors
---@param a vector
---@param b vector
---@return vector subtracted_vector
function VecSubtract(a, b) end

---Gets the dot product between two vectors
---@param a vector
---@param b vector
---@return number dot
function VecDot(a, b) end

---Gets the cross product/vector product between two vectors
---@param a vector
---@param b vector
---@return vector cross_product
function VecCross(a, b) end

---Linearly interpolates a vector between a and b, using t
---@param a vector
---@param b vector
---@param t number fraction (usually between 0.0 and 1.0)
---@return vector interpolated_vector
function VecLerp(a, b, t) end

--#endregion
--#region Quaternion Math

---Returns a standard lua table of 4 numbers.
---
---The default for each parameter is 0.
---
---If no arguments are provided, Quat() will result in { 0, 0, 0, 1 }
---@param x number|nil X value
---@param y number|nil Y value
---@param z number|nil Z value
---@param w number|nil W value
---@return quaternion created_quaternion
function Quat(x, y, z, w) end

---Copies a quaternion to prevent multiple references pointing to the same data
---@param orginal quaternion
---@return quaternion copy
function QuatCopy(orginal) end

---Returns a quaternion using euler angle notation
---
---The order of applied rotations uses the "NASA standard aeroplane"
---
---The default for each parameter is 0.
---@param x number|nil
---@param y number|nil
---@param z number|nil
---@return quaternion created_quaternion
function QuatEuler(x, y, z) end

---Return 3 seperate values representing euler angle notation
---
---The order of rotations uses the "NASA standard aeroplane" model
---
---The Inverse of QuatEuler()
---@param quaternion quaternion
---@return number x Angle around X axis in degrees
---@return number y Angle around Y axis in degrees
---@return number z Angle around Z axis in degrees
function GetQuatEuler(quaternion) end

---Returns a quaternion representing a rotation around a given axis
---@param axis vector A unit vector representing the axis of rotation
---@param angle number A number representing the angle in degrees that is rotated around the given axis
---@return quaternion created_quaternion
function QuatAxisAngle(axis, angle) end

---Returns a quaternion that points the negative Z axis (typically foward in Teardown) towards a specific point, keeping the Y axis upwards.
---
---
---@param eye vector A vector representing the origin
---@param target vector A vector representing the point to look at
---@return quaternion created_quaternion
function QuatLookAt(eye, target) end

--#endregion
--#region Transforms

---Returns a standard lua table representing a transform.
---
---The default of pos is Vec()
---
---The default of rot is Quat()
---
---Transform() will result in { pos = { 0, 0, 0 }, rot = { 0, 0, 0, 1 } }
---@param pos vector|nil the position of the Transform
---@param rot quaternion|nil the rotation of the Transform
---@return transform trans
function Transform(pos, rot) end

---Copies a transform to prevent multiple references pointing to the same data
---@param orginal transform
---@return transform copy
function TransformCopy(orginal) end


---Transform one transform out of the local space of another transform
---
---One way to think about this is getting the world transform of the second parameter realative to the given transform.
---@param relation transform
---@param transform transform
function TransformToParentTransform(relation, transform) end

---Transfom a position out of the parent space of another transform
---
---One way to think about this is getting the world position of the second parameter realative to the given transform.
---@param relation transform
---@param position vector
function TransformToParentPoint(relation, position) end

---Transfom a vector out of the parent space of another transform only considering rotation
---@param relation transform
---@param vector vector
function TransformToParentVec(relation, vector) end

---Transform one transform into the local space of another transform
---
---One way to think about this is getting the local transform of the second parameter realative to the given transform.
---@param relation transform
---@param transform transform
function TransformToLocalTransform(relation, transform) end

---Transfom a position into the local space of another transform
---
---One way to think about this is getting the local position of the second parameter realative to the given transform.
---@param relation transform
---@param position vector
function TransformToLocalPoint(relation, position) end

---Transfom a vector into the local space of another transform only considering rotation
---@param relation transform
---@param vector vector
function TransformToLocalVec(relation, vector) end

--#endregion
--#region Entities

---
---@param entity entity_handle
---@param tag string
---@param value nil|string
function SetTag(entity, tag, value) end

---
---@param entity entity_handle
---@param tag string
function RemoveTag(entity, tag) end

---
---@param entity entity_handle
---@param tag string
---@return boolean
function HasTag(entity, tag) end

---
---@param entity entity_handle
---@param tag string
---@return string value
function GetTagValue(entity, tag) end

---
---@param entity entity_handle
---@return string description
function GetDescription(entity) end

---
---@param entity entity_handle
---@param description string
function SetDescription(entity, description) end

---
---@param entity entity_handle
function Delete(entity) end

---
---@param entity entity_handle
---@return boolean
function IsHandleValid(entity) end

---
---@param entity entity_handle
---@return entity_type type
function GetEntityType(entity) end

--#endregion
--#region Bodies

---Searches the scene for a body, requiring a specified tag
---
---If tag is a blank string or nil, then it will return a body regardless of tag.
---
---If global, then the script will search the entire scene, not the children of this script.
---
---If no body is found, the function returns 0
---@param tag string|nil
---@param global boolean|nil
---@return body_handle body
function FindBody(tag, global) end

---Searches the scene for any body, requiring a specified tag
---
---If tag is a blank string or nil, then it will return any body regardless of tag.
---
---If global, then the script will search the entire scene, not the children of this script.
---
---If no bodies are found, the function returns a blank table
---@param tag string|nil
---@param global boolean|nil
---@return table<body_handle> bodies A table contraining the handle for each body found
function FindBodies(tag, global) end

---@param body body_handle
---@return transform transform
function GetBodyTransform(body) end

---@param body body_handle
---@param transform transform
function SetBodyTransform(body, transform) end

---@param body body_handle
---@return number mass
function GetBodyMass(body) end

---@param body body_handle
---@return boolean dynamic
function IsBodyDynamic(body) end

---@param body body_handle
---@param dynamic boolean
function SetBodyDynamic(body, dynamic) end

---@param body body_handle
---@return boolean active
function IsBodyActive(body) end

---@param body body_handle
---@param active boolean
function SetBodyActive(body, active) end

---@param body body_handle
---@param velocity vector
function SetBodyVelocity(body, velocity) end

---@param body body_handle
---@return vector velocity
function GetBodyVelocity(body) end

---@param body body_handle
---@param position vector
---@return vector velocity
function GetBodyVelocityAtPos(body, position) end

---@param body body_handle
---@param velocity vector
function SetBodyAngularVelocity(body, velocity) end

---@param body body_handle
---@return vector velocity
function GetBodyAngularVelocity(body) end

---@param body body_handle
---@param position vector
---@param impulse vector
function ApplyBodyImpulse(body, position, impulse) end

---@param body body_handle
---@return table<shape_handle> shapes
function GetBodyShapes(body) end

---Handles to all dynamic bodies in the jointed structure. The input handle will also be included.
---@param body body_handle
---@return table<body_handle> bodies
function GetJointedBodies(body) end

---Returns the parent vehicle of the given body
---
---Returns 0 if the body is not a children of a vehicle
---@param body body_handle
---@return vehicle_handle
function GetBodyVehicle(body) end

---Returns a world space Axis Aligned Bounding Box (AABB) if a body
---
---This is seperate from a Oriented Bounding Box (OBB) which supports rotations
---@param body body_handle
---@return vector aa The position of the lower bound
---@return vector bb The position of the upper bound
function GetBodyBounds(body) end

---@param body body_handle
---@return vector position
function GetBodyCenterOfMass(body) end

---A very inaccurate way of testing if a body is visible to the camera.
---
---If any level of perscion is needed, It is recommended to use alternative methods such as raycasting or dot products.
---
---Offical documentation says :
---
---This will check if a body is currently visible in the camera frustum and not occluded by other objects.
---@param body body_handle
---@param max_distance number
---@param reject_transparent number|nil See through transparent materials, Default is false
---@return boolean
function IsBodyVisible(body, max_distance, reject_transparent) end

---Determine if any shape of a body has been broken. 
---@param body body_handle
---@return boolean
function IsBodyBroken(body) end

---@param body body_handle
---@return boolean
function IsBodyJointedToStatic(body) end

---Renders an outline around a body for the next frame
---
---If only the body is given, { r, g, b, a } will default to { 1, 1, 1, 1 } (white)
---@param body body_handle
---@param r number|nil Default is 0
---@param g number|nil Default is 0
---@param b number|nil Default is 0
---@param a number|nil Default is 0
function DrawBodyOutline(body, r, g, b, a) end

---Renders a solid while color over a body for this frame
---
---This is used for valuables in the game
---@param body body_handle
---@param alpha number
function DrawBodyHighlight(body, alpha) end

---Returns the closest point of a specific body
---
---Usually, the point will be in 0.1 unit (1 voxel) increments of the body's shape
---@param body body_handle
---@param origin vector
---@return boolean hit If a point was found
---@return vector point world-space point
---@return vector normal world-space normal
---@return shape_handle shape The handle to the closest shape 
function GetBodyClosestPoint(body, origin) end

---HUSK
---@param body body_handle
function ConstrainVelocity(body) end

---HUSK
---@param body body_handle
function ConstrainAngularVelocity(body) end

---HUSK
---@param body body_handle
function ConstrainPosition(body) end

---HUSK
---@param body body_handle
function ConstrainOrientation(body) end

---@return body_handle world_body
function GetWorldBody() end

--#endregion
--#region Shapes

---Searches the scene for a shape, requiring a specified tag
---
---If tag is a blank string or nil, then it will return a shape regardless of tag.
---
---If global, then the script will search the entire scene, not the children of this script.
---
---If no shape is found, the function returns 0
---@param tag string|nil
---@param global boolean|nil
---@return shape_handle shape
function FindShape(tag, global) end

---Searches the scene for any shape, requiring a specified tag
---
---If tag is a blank string or nil, then it will return any shape regardless of tag.
---
---If global, then the script will search the entire scene, not the children of this script.
---
---If no bodies are found, the function returns a blank table
---@param tag string|nil
---@param global boolean|nil
---@return table<shape_handle> bodies A table contraining the handle for each shape found
function FindShapes(tag, global) end

---Gets the transform of the shape realative to the body it is attached to.
---@param shape shape_handle
---@return transform local_transform
function GetShapeLocalTransform(shape) end

---Sets the transform of the shape realative to the body it is attached to.
---@param shape shape_handle
---@param transform transform
function SetShapeLocalTransform(shape, transform) end

---Gets the transform of the shape in the world space
---@param shape shape_handle
---@return transform world_transform
function GetShapeWorldTransform(shape) end

---@param shape shape_handle
---@return body_handle shapebody
function GetShapeBody(shape) end

---@param shape shape_handle
---@return table<joint_handle> joints
function GetShapeJoints(shape) end

---@param shape shape_handle
---@return table<light_handle> lights
function GetShapeLights(shape) end

---Returns a world space Axis Aligned Bounding Box (AABB) if a shape
---
---This is seperate from a Oriented Bounding Box (OBB) which supports rotations
---@param shape shape_handle
---@return vector aa The position of the lower bound
---@return vector bb The position of the upper bound
function GetShapeBounds(shape) end

---Scale emissiveness for shape. If the shape has light sources attached, their intensity will be scaled by the same amount.
---@param shape shape_handle
---@param amount number
function SetShapeEmissiveScale(shape, amount) end

---Return material properties for a particular voxel given a world-space position
---@param shape shape_handle
---@param position vector
---@return material|'' type
---@return number red
---@return number green
---@return number blue
---@return number alpha
function GetShapeMaterialAtPosition(shape, position) end

---Return material properties for a particular voxel in the voxel grid indexed by integer values.
---
---Note that the first index is zero, rather than one.
---@param shape shape_handle
---@param x integer
---@param y integer
---@param z integer
---@return material|'' type
---@return number red
---@return number green
---@return number blue
---@return number alpha
function GetShapeMaterialAtIndex(shape, x, y, z) end

---@param shape shape_handle
---@return integer xsize Size in voxels along x axis
---@return integer ysize Size in voxels along y axis
---@return integer zsize Size in voxels along z axis
---@return number scale The size of one voxel in meters (with default scale it is 0.1)
function GetShapeSize(shape, xsize, ysize, zsize, scale) end

---Returns the voxels in a given shape
---
---Well lets see here; 1, 2, 3--, hold still here, 4! ahh ahh ahh ahh!
---@param shape shape_handle
---@return number voxels
function GetShapeVoxelCount(shape) end

---
---A very inaccurate way of testing if a shape is visible to the camera.
---
---If any level of perscion is needed, It is recommended to use alternative methods such as raycasting or dot products.
---
---Offical documentation says :
---
---This will check if a shape is currently visible in the camera frustum and not occluded by other objects.
---@param shape shape_handle
---@param max_distance number
---@param reject_transparent number|nil See through transparent materials, Default is false
---@return boolean
function IsShapeVisible(shape, max_distance, reject_transparent) end

---Determine if shape has been broken.
---
---Note that a shape can be transfered to another body during destruction, but might still not be considered broken if all voxels are intact.
---@param shape shape_handle
function IsShapeBroken(shape) end

---Renders an outline around a shape for the next frame
---
---If only the shape is given, { r, g, b, a } will default to { 1, 1, 1, 1 } (white)
---@param shape shape_handle
---@param r number|nil Default is 0
---@param g number|nil Default is 0
---@param b number|nil Default is 0
---@param a number|nil Default is 0
function DrawShapeOutline(shape, r, g, b, a) end

---Renders a solid while color over a shape for this frame
---
---This is used for valuables in the game
---@param shape shape_handle
---@param alpha number
function DrawShapeHighlight(shape, alpha) end

---This is used to filter out collisions with other shapes.
---
---Each shape can be given a layer bitmask (8 bits, 0-255) along with a mask (also 8 bits).
---
---The layer of one object must be in the mask of the other object and vice versa for the collision to be valid.
---
---The default layer for all objects is 1 and the default mask is 255 (collide with all layers).
---@param shape shape_handle
---@param layer integer Layer bits (0-255)
---@param mask integer Mask bits (0-255)
function SetShapeCollisionFilter(shape, layer, mask) end

---Returns the closest point of a specific shape
---
---Usually, the point will be in 0.1 unit (1 voxel) increments of the body's shape
---@param shape body_handle
---@param origin vector
---@return boolean hit If a point was found
---@return vector point world-space point
---@return vector normal world-space normal
function GetShapeClosestPoint(shape, origin) end

---Returns true if two shapes has physical overlap
---@param a shape_handle
---@param b shape_handle
---@return boolean overlap
function IsShapeTouching(a, b) end

--#endregion
--#region Locations

---Searches the scene for a location, requiring a specified tag
---
---If tag is a blank string or nil, then it will return a location regardless of tag.
---
---If global, then the script will search the entire scene, not the children of this script.
---
---If no location is found, the function returns 0
---@param tag string|nil
---@param global boolean|nil
---@return location_handle location
function FindLocation(tag, global) end

---Searches the scene for any location, requiring a specified tag
---
---If tag is a blank string or nil, then it will return any location regardless of tag.
---
---If global, then the script will search the entire scene, not the children of this script.
---
---If no locations are found, the function returns a blank table
---@param tag string|nil
---@param global boolean|nil
---@return table<location_handle> locations
function FindLocations(tag, global) end

---Returns the transform of the given location
---
---Note that *unintuitively* locations' transforms do not follow their respective parents.
---@param location location_handle
---@return transform transform
function GetLocationTransform(location) end

--#endregion
--#region Joints

---Searches the scene for a joint, requiring a specified tag
---
---If tag is a blank string or nil, then it will return a joint regardless of tag.
---
---If global, then the script will search the entire scene, not the children of this script.
---
---If no joint is found, the function returns 0
---@param tag string|nil
---@param global boolean|nil
---@return joint_handle joint
function FindJoint(tag, global) end

---Searches the scene for any joint, requiring a specified tag
---
---If tag is a blank string or nil, then it will return any joint regardless of tag.
---
---If global, then the script will search the entire scene, not the children of this script.
---
---If no joints are found, the function returns a blank table
---@param tag string|nil
---@param global boolean|nil
---@return table<joint_handle> joints
function FindJoints(tag, global) end

---@param joint joint_handle
---@return boolean broken
function IsJointBroken(joint) end

---@param joint joint_handle
---@return joint_type type
function GetJointType(joint) end

---A joint is always connected to two shapes. Use this function if you know one shape and want to find the other one.
---@param joint joint_handle
---@param shape shape_handle
---@return shape_handle other_shape
function GetJointOtherShape(joint, shape) end

---@param joint joint_handle
---@return table<shape_handle> shapes
function GetJointShapes(joint) end

---Set joint motor target velocity.
---
---If joint is of type hinge, velocity is given in radians per second angular velocity. If joint type is prismatic joint velocity is given in meters per second.
---
---Calling this function will override and void any previous call to SetJointMotorTarget.
---@param joint joint_handle
---@param velocity number Desired velocity
---@param strength number|nil Desired strength. Default is infinite. Zero to disable
function SetJointMotor(joint, velocity, strength) end

---If a joint has a motor target, it will try to maintain its relative movement.
---
---If joint is of type hinge, target is an angle in degrees (-180 to 180) and velocity is given in radians per second. If joint type is prismatic, target is given in meters and velocity is given in meters per second.
---
---Setting a motor target will override any previous call to SetJointMotor.
---@param joint joint_handle
---@param target number Desired movement target
---@param max_velocity number|nil Maximum velocity to reach target. Default is infinite
---@param strength number|nil Desired strength. Default is infinite. Zero to disable
function SetJointMotorTarget(joint, target, max_velocity, strength) end

---@param joint joint_handle
---@return number min Minimum joint limit (angle or distance)
---@return number max Maximum joint limit (angle or distance)
function GetJointLimits(joint) end

---Returns the current position or angle or the joint, measured in same way as joint limits.
---@param joint joint_handle
---@return number movement
function GetJointMovement(joint) end

---If the given joint is attached to the given shape, detach it.
---@param joint joint_handle
---@param shape shape_handle
function DetachJointFromShape(joint, shape) end

--#endregion
--#region Lights

---Add a temporary point light to the world for this frame. Call continuously for a steady light.
---
---Setting the intensity of the point light to a negative number can have very weird effects,
---
---If the intensity is negative infinity (`-1/0`) then it will permantly spread black pixels when looked at until the game is restarted or the render quality options are changed.
---
---*when you stare into the void, the void stares back at you*
---@param position vector
---@param red number
---@param green number
---@param blue number
---@param intensity number
function PointLight(position, red, green, blue, intensity) end

---Searches the scene for a light, requiring a specified tag
---
---If tag is a blank string or nil, then it will return a light regardless of tag.
---
---If global, then the script will search the entire scene, not the children of this script.
---
---If no light is found, the function returns 0
---@param tag string|nil
---@param global boolean|nil
---@return light_handle light
function FindLight(tag, global) end

---Searches the scene for any light, requiring a specified tag
---
---If tag is a blank string or nil, then it will return any light regardless of tag.
---
---If global, then the script will search the entire scene, not the children of this script.
---
---If no lights are found, the function returns a blank table
---@param tag string|nil
---@param global boolean|nil
---@return table<light_handle> lights
function FindLights(tag, global) end

---@param light light_handle
---@param enabled boolean
function SetLightEnabled(light, enabled) end

---@param light light_handle
---@param red number
---@param green number
---@param blue number
function SetLightColor(light, red, green, blue) end

---@param light light_handle
---@param intensity number
function SetLightIntensity(light, intensity) end

---@param light light_handle
---@return transform transform
function GetLightTransform(light) end

---@param light light_handle
---@return shape_handle shape
function GetLightShape(light) end

---@param light light_handle
---@return boolean active
function IsLightActive(light) end

---Return true if point is in light cone and range
---@param light light_handle
---@param point vector
---@return boolean effected
function IsPointAffectedByLight(light, point) end

--#endregion
--#region Trigger

---Searches the scene for a trigger, requiring a specified tag
---
---If tag is a blank string or nil, then it will return a trigger regardless of tag.
---
---If global, then the script will search the entire scene, not the children of this script.
---
---If no trigger is found, the function returns 0
---@param tag string|nil
---@param global boolean|nil
---@return trigger_handle trigger
function FindTrigger(tag, global) end

---Searches the scene for any trigger, requiring a specified tag
---
---If tag is a blank string or nil, then it will return any trigger regardless of tag.
---
---If global, then the script will search the entire scene, not the children of this script.
---
---If no triggers are found, the function returns a blank table
---@param tag string|nil
---@param global boolean|nil
---@return table<trigger_handle> triggers
function FindTriggers(tag, global) end

---@param trigger trigger_handle
---@return transform transform
function GetTriggerTransform(trigger) end

---@param trigger trigger_handle
---@param transform transform
function SetTriggerTransform(trigger, transform) end

---Returns a world space Axis Aligned Bounding Box (AABB) if a trigger
---
---This is seperate from a Oriented Bounding Box (OBB) which supports rotations
---@param trigger trigger_handle
---@return vector aa The position of the lower bound
---@return vector bb The position of the upper bound
function GetTriggerBounds(trigger) end

---Checks if the point is within the trigger's volume
---@param trigger trigger_handle
---@param point vector
---@return boolean inside
function IsPointInTrigger(trigger, point) end

---Checks if the center point of the body is within the trigger's volume
---@param trigger trigger_handle
---@param body body_handle
---@return boolean inside
function IsBodyInTrigger(trigger, body) end

---Checks if the origin of the vehicle is within the trigger's volume
---@param trigger trigger_handle
---@param body body_handle
---@return boolean inside
function IsVehicleInTrigger(trigger, body) end

---Checks if the center of the shape is within the trigger's volume
---@param trigger trigger_handle
---@param shape shape_handle
---@return boolean inside
function IsShapeInTrigger(trigger, shape) end

---Checks if trigger contains any part of a body
---
---The highest point will also be returned, this is used in a few missions in the campagin
---@param trigger trigger_handle
---@param demolition boolean|nil If true, small debris and vehicles are ignored
function IsTriggerEmpty(trigger, demolition) end

---Returns the distance to the surface of a trigger volume.
---
---Will return negative distance if inside.
---@param trigger trigger_handle
---@param point vector
---@return number distance
function GetTriggerDistance(trigger, point) end

---Returns the closest point in trigger volume.
---
---Will return the input point itself if inside trigger or closest point on surface of trigger if outside.
---@param trigger trigger_handle
---@param point vector
---@return vector closest_point
function GetTriggerClosestPoint(trigger, point) end

--#endregion
--#region Screen

---Searches the scene for a screen, requiring a specified tag
---
---If tag is a blank string or nil, then it will return a screen regardless of tag.
---
---If global, then the script will search the entire scene, not the children of this script.
---
---If no screen is found, the function returns 0
---@param tag string|nil
---@param global boolean|nil
---@return screen_handle screen
function FindScreen(tag, global) end

---Searches the scene for any screen, requiring a specified tag
---
---If tag is a blank string or nil, then it will return any screen regardless of tag.
---
---If global, then the script will search the entire scene, not the children of this script.
---
---If no screens are found, the function returns a blank table
---@param tag string|nil
---@param global boolean|nil
---@return table<screen_handle> screens
function FindScreens(tag, global) end

---@param screen screen_handle
---@param enabled boolean
function SetScreenEnabled(screen, enabled) end

---@param screen screen_handle
---@return boolean enabled
function IsScreenEnabled(screen) end

---@param screen screen_handle
---@return shape_handle shape
function GetScreenShape(screen) end

--#endregion
--#region Vehicle

---Searches the scene for a vehicle, requiring a specified tag
---
---If tag is a blank string or nil, then it will return a vehicle regardless of tag.
---
---If global, then the script will search the entire scene, not the children of this script.
---
---If no vehicle is found, the function returns 0
---@param tag string|nil
---@param global boolean|nil
---@return vehicle_handle vehicle
function FindVehicle(tag, global) end

---Searches the scene for any vehicle, requiring a specified tag
---
---If tag is a blank string or nil, then it will return any vehicle regardless of tag.
---
---If global, then the script will search the entire scene, not the children of this script.
---
---If no vehicles are found, the function returns a blank table
---@param tag string|nil
---@param global boolean|nil
---@return table<vehicle_handle> vehicles
function FindVehicles(tag, global) end

---@param vehicle vehicle_handle
---@return transform transform
function GetVehicleTransform(vehicle) end

---@param vehicle vehicle_handle
---@return body_handle body
function GetVehicleBody(vehicle) end

---@param vehicle vehicle_handle
---@return number number 0 to 1 value
function GetVehicleHealth(vehicle) end

---Returns the driver position as vector in vehicle space
---@param vehicle vehicle_handle
---@return vector position
function GetVehicleDriverPos(vehicle) end

---Pipes input to vehicles, allowing for autonomous driving.
---
---The vehicle will be turned on automatically and turned off when no longer called.
---
---It is recommended to call DriveVehicle from the tick function rather than update.
---@param vehicle vehicle_handle
---@param drive number Reverse to forward control -1 to 1
---@param steering number Left to right control -1 to 1
---@param handbrake boolean Handbrake control
function DriveVehicle(vehicle, drive, steering, handbrake) end

--#endregion
--#region Player

---Returns center point of player
---@return vector position
---@deprecated Use GetPlayerTransform().pos instead
function GetPlayerPos() end

---Returns the player's transform
---
---Can optionaly include the pitch of the player's camera
---@param includePitch boolean|nil Default is false
---@return vector position
function GetPlayerTransform(includePitch) end

---Sets the player's transform
---
---Can optionaly include the pitch of the player's camera
---
---Note that this will also reset the player's velocity, to keep it you will need to store it, and reapply it after the function has been called.
---
---Also Note that if you are trying to move the player on level load, use SetPlayerSpawnTransform() instead.
---@param transform transform
---@param includePitch boolean|nil Default is false
function SetPlayerTransform(transform, includePitch) end

---Make the ground act as a conveyor belt, pushing the player even if ground shape is static.
---@param velocity vector
function SetPlayerGroundVelocity(velocity) end

---The player camera transform is usually the same as what you get from GetCameraTransform(), but if you have set a camera transform manually with SetCameraTransform(), you can retrieve the standard player camera transform with this function.
---@return transform transform
function GetPlayerCameraTransform() end

---Apply an offset to the player camera for this frame. Can be used for camera effects such as shake and wobble.
---
---Note that this does not stack, and will clash if multiple mods are trying to set an offset.
---
---Also Note that calling SetPlayerTransform() in the same tick as SetPlayerCameraOffsetTransform() will cause absolutely nothing to happen ~~because dennis hates us.~~
---@param transform transform
function SetPlayerCameraOffsetTransform(transform ) end

--Call this function during init to alter the player's spawn transform. 
---@param transform transform
function SetPlayerSpawnTransform(transform) end

---@return vector velocity
function GetPlayerVelocity() end

---@param velocity vector
function SetPlayerVelocity(velocity) end

---@return vehicle_handle vehicle
function GetPlayerVehicle() end

---@param vehicle vehicle_handle
function SetPlayerVehicle(vehicle) end

---Returns the handle to grabbed shape or zero if not grabbing.
---@return shape_handle shape
function GetPlayerGrabShape() end

---Returns the handle to grabbed body or zero if not grabbing.
---@return body_handle body

function GetPlayerGrabBody() end

---Release what the player is currently holding
---
---This can be called continuously to prevent the player from grabbing, but they will still be able to grab for a single frame
function ReleasePlayerGrab() end

---Returns a handle to the picked shape or zero if nothing is picked
---@return shape_handle shape
function GetPlayerPickShape() end

---Returns a handle to the picked body or zero if nothing is picked
---@return body_handle body
function GetPlayerPickBody() end

---Returns a handle to the interacted shape or zero if nothing is interacted with
---
---Interactable shapes has to be tagged with "interact".
---
---The engine determines which interactable shape is currently interactable.
---@return shape_handle shape
function GetPlayerInteractShape() end

---Returns a handle to the interacted body or zero if nothing is interacted with
---
---Interactable shapes has to be tagged with "interact".
---
---The engine determines which interactable shape is currently interactable.
---@return body_handle body
function GetPlayerInteractBody() end

---Returns the handle to interacted screen or zero if none
---@return screen_handle screen
function GetPlayerScreen() end

---Handle to interacted screen or zero if none
---@param screen screen_handle
function SetPlayerScreen(screen) end

---@return number number 0 to 1 value representing the players health
function GetPlayerHealth() end

---@param health number
function SetPlayerHealth(health) end

---Respawn player at spawn position without modifying the scene
function RespawnPlayer() end

--#endregion
--#region Tools

---Register a custom tool that will show up in the player inventory and can be selected with scroll wheel.
---
---Do this only once per tool. You also need to enable the tool in the registry before it can be used.
---@param id string
---@param name string
---@param file string
---@param group integer
function RegisterTool(id, name, file, group) end

---Returns the spawned body of the currently held tool
---
---You can use this to retrieve tool shapes and animate them, change emissiveness, etc. Do not attempt to set the tool body transform, since it is controlled by the engine. Use SetToolTranform for that.
---
---If you are interested in complex animations, Unoffical Modding Framework can help
---@return body_handle tool_body
function GetToolBody() end

---Apply an additional transform on the visible tool body. This can be used to create tool animations.
---
---You need to set this every frame from the tick function. The optional sway parameter control the amount of tool swaying when walking. Set to zero to disable completely.
---@param transform transform
---@param sway number|nil Default is 1
function SetToolTransform(transform, sway) end

--#endregion
--#region Sound

---Loads a Sound and returns the handle for it
---
---Multiple sounds can be loaded into the same handle to be played at random.
---
---LoadSound("example-sound")
---
---"example-sound0.ogg", "example-sound1.ogg", "example-sound2.ogg", ...
---@param path string
---@param nominal_distance number|nil The distance in meters this sound is recorded at. Affects attenuation. Default is 10
---@return sound_handle
function LoadSound(path, nominal_distance) end

---Loads a Loop and returns the handle for it
---@param path string
---@param nominal_distance number|nil The distance in meters this sound is recorded at. Affects attenuation. Default is 10
---@return loop_handle
function LoadLoop(path, nominal_distance) end

---@param sound sound_handle
---@param position vector|nil Default is player position
---@param volume number Default is 1.0
function PlaySound(sound, position, volume) end

---Call continuously
---@param loop loop_handle
---@param position vector|nil Default is player position
---@param volume number Default is 1.0
function PlayLoop(loop, position, volume) end

---@param path string
function PlayMusic(path) end

function StopMusic() end

--#endregion
--#region Sprite

---Loads a sprite into the Sprite Table and returns the handle
---
---If LoadSprite is called with a nil path, then when the handle is drawn, it will use the last drawn sprite on the screen.
---
---If no sprite have been drawn on screen before this one, it will default to the Render Texture 0, albedo/color buffer
---
---https://acko.net/files/teardown-teardown/01-color-pass-albedo.png
---@param path string
function LoadSprite(path) end

---Draws a sprite handle at a transform, stetching the texture/sprite to fill the given width and height
---
---While depth testing/culling/occlusion does work in general, it easily breaks with larger sprites at shallow angles
---@param sprite sprite_handle
---@param transform transform
---@param width number
---@param height number
---@param red number
---@param green number
---@param blue number
---@param alpha number
---@param depth_test boolean|nil Defualt is false
---@param additive boolean|nil Defualt is false
function DrawSprite(sprite, transform, width, height, red, green, blue, alpha, depth_test, additive) end

--#endregion
--#region Scene Queries

---Sets required layers for next query
---| Layer | Description |
---| --- | --- |
---| physical |   have a physical representation |
---| dynamic |   part of a dynamic body |
---| static  |   part of a static body |
---| large   |   above debris threshold |
---| small   |   below debris threshold |
---@param layers string A space separate list of layers
function QueryRequire(layers) end

---Excludes a body from the next query
---@param body body_handle
function QueryRejectBody(body) end

---Excludes a shape from the next query
---@param shape shape_handle
function QueryRejectShape(shape) end

---Excludes a vehicle from the next query
---@param vehicle vehicle_handle
function QueryRejectVehicle(vehicle) end

---Performs a raycast
---@param origin vector
---@param direction vector
---@param max_distance number
---@param radius number|nil Default is 0.0
---@param reject_transparent boolean|nil Default is false
---@return boolean hit
---@return number distance
---@return vector normal
---@return shape_handle shape
function QueryRaycast(origin, direction, max_distance, radius, reject_transparent) end

function QueryClosestPoint() end
function QueryAabbShapes() end
function QueryAabbBodies() end
function QueryPath() end
function AbortPath() end
function GetPathState() end
function GetPathLength() end
function GetPathPoint() end
function GetLastSound() end
function IsPointInWater() end
function GetWindVelocity() end
function QueryClosestFire() end
function QueryAabbFireCount() end
function RemoveAabbFires() end


--#endregion
--#region Particles

function ParticleReset() end
function ParticleType() end
function ParticleTile() end
function ParticleColor() end
function ParticleRadius() end
function ParticleAlpha() end
function ParticleGravity() end
function ParticleDrag() end
function ParticleEmissive() end
function ParticleRotation() end
function ParticleStretch() end
function ParticleSticky() end
function ParticleCollide() end
function ParticleFlags() end
function SpawnParticle() end

--#endregion
--#region Spawning

function Spawn() end

--#endregion
--#region User Interface

---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiMakeInteractive() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiPush() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiPop() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiWidth() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiHeight() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiCenter() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiMiddle() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiColor() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiColorFilter() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiTranslate() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiRotate() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiScale() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiWindow() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiSafeMargins() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiAlign() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiModalBegin() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiModalEnd() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiDisableInput() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiEnableInput() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiReceivesInput() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiGetMousePos() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiIsMouseInRect() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiWorldToPixel() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiPixelToWorld() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiBlur() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiFont() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiFontHeight() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiText() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiGetTextSize() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiWordWrap() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiTextOutline() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiTextShadow() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiRect() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiImage() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiGetImageSize() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiImageBox() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiSound() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiSoundLoop() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiMute() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiButtonImageBox() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiButtonHoverColor() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiButtonPressColor() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiButtonPressDist() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiTextButton() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiImageButton() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiBlankButton() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiSlider() end
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiGetScreen() end

--#endregion
--#region Debug


---Dispalys a string in the bottom left corner of the screen
---
---Only the last 20 lines can be displayed, and more will be cut off and removed
---@param string string
function DebugPrint(string) end

---Permantly displays a value in the top left corner of the screen
---
---Follows the format "name = value"
---
---Vectors, Quaternions, and Transforms are converted to strings
---
---Values updated the current frame are drawn opaque. Old values are drawn transparent in white.
---@param name string
---@param value number|string|vector|quaternion|transform
function DebugWatch(name, value) end

---Renders a line between two points
---@param p1 vector
---@param p2 vector
---@param red number
---@param green number
---@param blue number
---@param alpha number
function DebugLine(p1, p2, red, green, blue, alpha) end

---Draws a line between two points using Drawsprite()
---
---Will occlude behind walls (*as well as sprites occlude that is*)
---@param p1 vector
---@param p2 vector
---@param red number
---@param green number
---@param blue number
---@param alpha number
function DrawLine(p1, p2, red, green, blue, alpha) end

---Will draw 2 lines using DebugLine() in the form of a cross on the position of a point
---
---Useful for checking the position of a vector
---@param position vector
---@param red number
---@param green number
---@param blue number
---@param alpha number
function DebugCross(position, red, green, blue, alpha) end

--#endregion
--#region Scene Properties

function SetEnvironmentDefault() end
function SetEnvironmentProperty() end
function GetEnvironmentProperty() end
function SetPostProcessingDefault() end
function SetPostProcessingProperty() end
function GetPostProcessingProperty() end

--#endregion
--#region User Input

---@param key key
---@return boolean key_pressed
function InputPressed(key) end

---@param key key
---@return boolean key_pressed
function InputDown(key) end

---@param key key
---@return boolean key_pressed
function InputReleased(key) end

---@param key_value key_value
---@return number value
function InputValue(key_value) end

---@return key key
function InputLastPressedKey() end

--#endregion
--#region Misc

function Shoot() end
function Paint() end
function MakeHole() end
function Explosion() end
function SpawnFire() end
function GetFireCount() end
function GetCameraTransform() end
function SetCameraTransform() end
function SetCameraFov() end
function SetCameraDof() end
function SetTimeScale() end

--#endregion
--#region Misc - Undocummented

---Shakes the Camera
---
---Camera Shake will persist through levels
---
---NOT IN OFFICAL DOCUMENTATION
---@param intensity number
function ShakeCamera(intensity) end

--#endregion
