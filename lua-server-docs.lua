---@diagnostic disable: missing-return
---@diagnostic disable: unused-local

--#region Types and Classes

---@class vector: { [1]:number, [2]:number, [3]:number }
---@type vector

---@class quaternion: { [1]:number, [2]:number, [3]:number, [4]:number }
---@type quaternion

---@class transform: { pos:vector, rot:quaternion }
---@type transform


---A non-negative interger that represents an index
---@class handle: integer
---@type handle

---@class entity: handle
---@type entity


---A non-negative interger that represents the index/handle to a entity in the World/Entity Table
---
---May not be accurate, still waiting on a comfirmation
---@class body: entity
---@type body

---A non-negative interger that represents the index/handle to a shape in the World/Entity Table
---
---May not be accurate, still waiting on a comfirmation
---@class shape: entity
---@type shape

---A non-negative interger that represents the index/handle to a joint in the World/Entity Table
---
---May not be accurate, still waiting on a comfirmation
---@class joint: entity
---@type joint

---A non-negative interger that represents the index/handle to a light in the World/Entity Table
---
---May not be accurate, still waiting on a comfirmation
---@class light: entity
---@type light

---A non-negative interger that represents the index/handle to a script in the World/Entity Table
---
---May not be accurate, still waiting on a comfirmation
---@class script: entity
---@type script

---A non-negative interger that represents the index/handle to a screen in the World/Entity Table
---
---May not be accurate, still waiting on a comfirmation
---@class screen: entity
---@type screen

---A non-negative interger that represents the index/handle to a location in the World/Entity Table
---
---May not be accurate, still waiting on a comfirmation
---@class location: entity
---@type location

---A non-negative interger that represents the index/handle to a trigger in the World/Entity Table
---
---May not be accurate, still waiting on a comfirmation
---@class trigger: entity
---@type trigger

---A non-negative interger that represents the index/handle to a vehicle in the World/Entity Table
---
---May not be accurate, still waiting on a comfirmation
---@class vehicle: entity
---@type vehicle

---A non-negative interger that represents the index/handle to a wheel in the World/Entity Table
---
---May not be accurate, still waiting on a comfirmation
---@class wheel: entity
---@type wheel

---A non-negative interger that represents the index/handle to a water in the World/Entity Table
---
---May not be accurate, still waiting on a comfirmation
---@class water: entity
---@type water


---A non-negative interger that represents the index/handle to a sprite in the Sprite Table
---
---May not be accurate, still waiting on a comfirmation
---@class sprite: handle
---@type sprite

---A non-negative interger that represents the index/handle to a sound in the Sound Table
---
---May not be accurate, still waiting on a comfirmation
---@class sound: handle
---@type sound

---A non-negative interger that represents the index/handle to a sound loop in the Sound Table
---
---May not be accurate, still waiting on a comfirmation
---@class soundloop: handle
---@type soundloop


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
---@param entity entity
---@param tag string
---@param value nil|string
function SetTag(entity, tag, value) end

---
---@param entity entity
---@param tag string
function RemoveTag(entity, tag) end

---
---@param entity entity
---@param tag string
---@return boolean
function HasTag(entity, tag) end

---
---@param entity entity
---@param tag string
---@return string value
function GetTagValue(entity, tag) end

---
---@param entity entity
---@return string description
function GetDescription(entity) end

---
---@param entity entity
---@param description string
function SetDescription(entity, description) end

---
---@param entity entity
function Delete(entity) end

---
---@param entity entity
---@return boolean
function IsHandleValid(entity) end

---
---@param entity entity
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
---@return body body
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
---@return table<body> bodies A table contraining the handle for each body found
function FindBodies(tag, global) end

---@param body body
---@return transform transform
function GetBodyTransform(body) end

---@param body body
---@param transform transform
function SetBodyTransform(body, transform) end

---@param body body
---@return number mass
function GetBodyMass(body) end

---@param body body
---@return boolean dynamic
function IsBodyDynamic(body) end

---@param body body
---@param dynamic boolean
function SetBodyDynamic(body, dynamic) end

---@param body body
---@return boolean active
function IsBodyActive(body) end

---@param body body
---@param active boolean
function SetBodyActive(body, active) end

---@param body body
---@param velocity vector
function SetBodyVelocity(body, velocity) end

---@param body body
---@return vector velocity
function GetBodyVelocity(body) end

---@param body body
---@param position vector
---@return vector velocity
function GetBodyVelocityAtPos(body, position) end

---@param body body
---@param velocity vector
function SetBodyAngularVelocity(body, velocity) end

---@param body body
---@return vector velocity
function GetBodyAngularVelocity(body) end

---@param body body
---@param position vector
---@param impulse vector
function ApplyBodyImpulse(body, position, impulse) end

---@param body body
---@return table<shape> shapes
function GetBodyShapes(body) end

---Returns the parent vehicle of the given body
---
---Returns 0 if the body is not a children of a vehicle
---@param body body
---@return vehicle
function GetBodyVehicle(body) end

---Returns a world space Axis Aligned Bounding Box (AABB) if a body
---
---This is seperate from a Oriented Bounding Box (OBB) which supports rotations
---@param body body
---@return vector aa The position of the lower bound
---@return vector bb The position of the upper bound
function GetBodyBounds(body) end

---@param body body
---@return vector position
function GetBodyCenterOfMass(body) end

---A very inaccurate way of testing if a body is visible to the camera.
---
---If any level of perscion is needed, It is recommended to use alternative methods such as raycasting or dot products.
---
---Offical documentation says :
---
---This will check if a body is currently visible in the camera frustum and not occluded by other objects.
---@param body body
---@param maxdistance number
---@param rejectTransparent number|nil See through transparent materials, Default is false
---@return boolean
function IsBodyVisible(body, maxdistance, rejectTransparent) end

---Determine if any shape of a body has been broken. 
---@param body body
---@return boolean
function IsBodyBroken(body) end

---@param body body
---@return boolean
function IsBodyJointedToStatic(body) end

---Renders an outline around a body for the next frame
---
---If only the body is given, { r, g, b, a } will default to { 1, 1, 1, 1 } (white)
---@param body body
---@param r number|nil Default is 0
---@param g number|nil Default is 0
---@param b number|nil Default is 0
---@param a number|nil Default is 0
function DrawBodyOutline(body, r, g, b, a) end

---Renders a solid while color over a body for this frame
---
---This is used for valuables in the game
---@param body body
---@param alpha number
function DrawBodyHighlight(body, alpha) end

---Returns the closest point of a specific body
---
---Usually, the point will be in 0.1 unit (1 voxel) increments of the body's shape
---@param body body
---@param origin vector
---@return boolean hit If a point was found
---@return vector point world-space point
---@return vector normal world-space normal
---@return shape shape The handle to the closest shape 
function GetBodyClosestPoint(body, origin) end

---HUSK
---@param body body
function ConstrainVelocity(body) end

---HUSK
---@param body body
function ConstrainAngularVelocity(body) end

---HUSK
---@param body body
function ConstrainPosition(body) end

---HUSK
---@param body body
function ConstrainOrientation(body) end

---@return body world_body
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
---@return shape shape
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
---@return table<shape> bodies A table contraining the handle for each shape found
function FindShapes(tag, global) end

---Gets the transform of the shape realative to the body it is attached to.
---@param shape shape
---@return transform local_transform
function GetShapeLocalTransform(shape) end

---Sets the transform of the shape realative to the body it is attached to.
---@param shape shape
---@param transform transform
function SetShapeLocalTransform(shape, transform) end

---Gets the transform of the shape in the world space
---@param shape shape
---@param transform world_transform
function GetShapeWorldTransform(shape) end

---@param shape shape
---@return body shapebody
function GetShapeBody(shape) end

---@param shape shape
---@return table<joint> joints
function GetShapeJoints(shape) end

---@param shape shape
---@return table<light> lights
function GetShapeLights(shape) end

---Returns a world space Axis Aligned Bounding Box (AABB) if a shape
---
---This is seperate from a Oriented Bounding Box (OBB) which supports rotations
---@param shape shape
---@return vector aa The position of the lower bound
---@return vector bb The position of the upper bound
function GetShapeBounds(shape) end

---Scale emissiveness for shape. If the shape has light sources attached, their intensity will be scaled by the same amount.
---@param shape shape
---@param amount number
function SetShapeEmissiveScale(shape, amount) end

---Return material properties for a particular voxel given a world-space position
---@param shape shape
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
---@param shape shape
---@param x integer
---@param y integer
---@param z integer
---@return material|'' type
---@return number red
---@return number green
---@return number blue
---@return number alpha
function GetShapeMaterialAtIndex(shape, x, y, z) end

---@param shape shape
---@return integer xsize Size in voxels along x axis
---@return integer ysize Size in voxels along y axis
---@return integer zsize Size in voxels along z axis
---@return number scale The size of one voxel in meters (with default scale it is 0.1)
function GetShapeSize(shape, xsize, ysize, zsize, scale) end

---Returns the voxels in a given shape
---
---Well lets see here; 1, 2, 3--, hold still here, 4! ahh ahh ahh ahh!
---@param shape shape
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
---@param shape shape
---@param maxdistance number
---@param rejectTransparent number|nil See through transparent materials, Default is false
---@return boolean
function IsShapeVisible(shape, maxdistance, rejectTransparent) end

---Determine if shape has been broken.
---
---Note that a shape can be transfered to another body during destruction, but might still not be considered broken if all voxels are intact.
---@param shape shape
function IsShapeBroken(shape) end

---Renders an outline around a shape for the next frame
---
---If only the shape is given, { r, g, b, a } will default to { 1, 1, 1, 1 } (white)
---@param shape shape
---@param r number|nil Default is 0
---@param g number|nil Default is 0
---@param b number|nil Default is 0
---@param a number|nil Default is 0
function DrawShapeOutline(shape, r, g, b, a) end

---Renders a solid while color over a shape for this frame
---
---This is used for valuables in the game
---@param shape shape
---@param alpha number
function DrawShapeHighlight(shape, alpha) end

---This is used to filter out collisions with other shapes.
---
---Each shape can be given a layer bitmask (8 bits, 0-255) along with a mask (also 8 bits).
---
---The layer of one object must be in the mask of the other object and vice versa for the collision to be valid.
---
---The default layer for all objects is 1 and the default mask is 255 (collide with all layers).
---@param shape shape
---@param layer integer Layer bits (0-255)
---@param mask integer Mask bits (0-255)
function SetShapeCollisionFilter(shape, layer, mask) end

---Returns the closest point of a specific shape
---
---Usually, the point will be in 0.1 unit (1 voxel) increments of the body's shape
---@param shape body
---@param origin vector
---@return boolean hit If a point was found
---@return vector point world-space point
---@return vector normal world-space normal
function GetShapeClosestPoint(shape, origin) end

---Returns true if two shapes has physical overlap
---@param a shape
---@param b shape
---@return boolean overlap
function IsShapeTouching(a, b) end

--#endregion
--#region Locations

function FindLocation() end
function FindLocations() end
function GetLocationTransform() end

--#endregion
--#region Joints

function FindJoint() end
function FindJoints() end
function IsJointBroken() end
function GetJointType() end
function GetJointOtherShape() end
function GetJointShapes() end
function SetJointMotor() end
function SetJointMotorTarget() end
function GetJointLimits() end
function GetJointMovement() end
function GetJointedBodies() end
function DetachJointFromShape() end

--#endregion
--#region Lights

function PointLight() end

function FindLight() end
function FindLights() end
function SetLightEnabled() end
function SetLightColor() end
function SetLightIntensity() end
function GetLightTransform() end
function GetLightShape() end
function IsLightActive() end
function IsPointAffectedByLight() end

--#endregion
--#region Trigger

function FindTrigger() end
function FindTriggers() end
function GetTriggerTransform() end
function SetTriggerTransform() end
function GetTriggerBounds() end
function IsBodyInTrigger() end
function IsVehicleInTrigger() end
function IsShapeInTrigger() end
function IsPointInTrigger() end
function IsTriggerEmpty() end
function GetTriggerDistance() end
function GetTriggerClosestPoint() end

--#endregion
--#region Screen

function FindScreen() end
function FindScreens() end
function SetScreenEnabled() end
function IsScreenEnabled() end
function GetScreenShape() end

--#endregion
--#region Vehicle

function FindVehicle() end
function FindVehicles() end
function GetVehicleTransform() end
function GetVehicleBody() end
function GetVehicleHealth() end
function GetVehicleDriverPos() end
function DriveVehicle() end

--#endregion
--#region Player

function GetPlayerPos() end
function GetPlayerTransform() end
function SetPlayerTransform() end
function SetPlayerGroundVelocity() end
function GetPlayerCameraTransform() end
function SetPlayerCameraOffsetTransform() end
function SetPlayerSpawnTransform() end
function GetPlayerVelocity() end
function SetPlayerVehicle() end
function SetPlayerVelocity() end
function GetPlayerVehicle() end
function GetPlayerGrabShape() end
function GetPlayerGrabBody() end
function ReleasePlayerGrab() end
function GetPlayerPickShape() end
function GetPlayerPickBody() end
function GetPlayerInteractShape() end
function GetPlayerInteractBody() end
function SetPlayerScreen() end
function GetPlayerScreen() end
function SetPlayerHealth() end
function GetPlayerHealth() end
function RespawnPlayer() end
function RegisterTool() end
function GetToolBody() end
function SetToolTransform() end

--#endregion
--#region Sound

function LoadSound() end
function LoadLoop() end
function PlaySound() end
function PlayLoop() end
function PlayMusic() end
function StopMusic() end

--#endregion
--#region Sprite

function LoadSprite() end
function DrawSprite() end

--#endregion
--#region Scene Queries

function QueryRequire() end
function QueryRejectVehicle() end
function QueryRejectBody() end
function QueryRejectShape() end
function QueryRaycast() end
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
--#region UserInput

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
