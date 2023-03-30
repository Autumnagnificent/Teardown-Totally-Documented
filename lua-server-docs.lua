---@diagnostic disable: missing-return
---@diagnostic disable: unused-local

-------------------------------------------------------------------------------------------------------------------------------------------------------
----------------Classes--------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

---@class vector: { [1]:number, [2]:number, [3]:number }
---@type vector

---@class quaternion: { [1]:number, [2]:number, [3]:number, [4]:number }
---@type quaternion

---@class transform: { pos:vector, rot:quaternion }
---@type transform


---@class handle: integer -- non-negative
---@type handle

---@class entity: handle
---@type entity


---@class body: entity
---@type body

---@class shape: entity
---@type shape

---@class joint: entity
---@type joint

---@class light: entity
---@type light

---@class script: entity
---@type script

---@class screen: entity
---@type screen

---@class location: entity
---@type location

---@class trigger: entity
---@type trigger

---@class vehicle: entity
---@type vehicle

---@class wheel: entity
---@type wheel

---@class water: entity
---@type water


---@class sprite: handle
---@type sprite

---@class sound: handle
---@type sound

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
---| "camerax" Camera x movement, scaled by sensitivity. Only valid in InputValue.
---| "cameray" Camera y movement, scaled by sensitivity. Only valid in InputValue
---| "mousedx" Mouse horizontal diff. Only valid in InputValue.
---| "mousedy" Mouse vertical diff. Only valid in InputValue.
---| "mousewheel" Mouse wheel. Only valid in InputValue.

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

-------------------------------------------------------------------------------------------------------------------------------------------------------
----------------Vector Math--------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

---Returns a standard lua table of 3 numbers.
---
---The default for each parameter is 0.
---
---Vec() will result in { 0, 0, 0 }
---@param x number|nil X value
---@param y number|nil Y value
---@param z number|nil Z value
---@return vector vector {x, y, z}
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

-------------------------------------------------------------------------------------------------------------------------------------------------------
----------------Quaternion Math--------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------------------------------------------------------------------------------
----------------Transforms--------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------------------------------------------------------------------------------
----------------Entities--------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------------------------------------------------------------------------------
----------------Bodies--------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

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

---@param handle body
---@return transform transform
function GetBodyTransform(handle) end

---@param handle body
---@param transform transform
function SetBodyTransform(handle, transform) end

---@param handle body
---@return number mass
function GetBodyMass(handle) end

---@param handle body
---@return boolean dynamic
function IsBodyDynamic(handle) end

---@param handle body
---@param dynamic boolean
function SetBodyDynamic(handle, dynamic) end

---@param handle body
---@return boolean active
function IsBodyActive(handle) end

---@param handle body
---@param active boolean
function SetBodyActive(handle, active) end

---@param handle body
---@param velocity vector
function SetBodyVelocity(handle, velocity) end

---@param handle body
---@return vector velocity
function GetBodyVelocity(handle) end

---@param handle body
---@param position vector
---@return vector velocity
function GetBodyVelocityAtPos(handle, position) end

---@param handle body
---@param velocity vector
function SetBodyAngularVelocity(handle, velocity) end

---@param handle body
---@return vector velocity
function GetBodyAngularVelocity(handle) end

---@param handle body
---@param position vector
---@param impulse vector
function ApplyBodyImpulse(handle, position, impulse) end

---@param handle body
---@return table<shape> shapes
function GetBodyShapes(handle) end

---Returns the parent vehicle of the given body
---
---Returns 0 if the body is not a children of a vehicle
---@param handle body
---@return vehicle
function GetBodyVehicle(handle) end

---Returns a world space Axis Aligned Bounding Box (AABB) if a body
---
---This is seperate from a Oriented Bounding Box (OBB) which supports rotations
---@param handle body
---@return vector aa The position of the lower bound
---@return vector bb The position of the upper bound
function GetBodyBounds(handle) end

---@param handle body
---@return vector position
function GetBodyCenterOfMass(handle) end

---A very inaccurate way of testing if a body is visible to the camera.
---
---If any level of perscion is needed, It is recommended to use alternative methods such as raycasting or dot products.
---
---Offical documentation says :
---
---This will check if a body is currently visible in the camera frustum and not occluded by other objects.
---@param handle body
---@param maxdistance number
---@param rejectTransparent number|nil See through transparent materials, Default is false
---@return boolean
function IsBodyVisible(handle, maxdistance, rejectTransparent) end

---@param handle body
---@return boolean
function IsBodyBroken(handle) end

---@param handle body
---@return boolean
function IsBodyJointedToStatic(handle) end

---Renders an outline around a body for the next frame
---
---If only the handle is given, { r, g, b, a } will default to { 1, 1, 1, 1 } (white)
---@param handle body
---@param r number|nil Default is 0
---@param g number|nil Default is 0
---@param b number|nil Default is 0
---@param a number|nil Default is 0
function DrawBodyOutline(handle, r, g, b, a) end

---Renders a solid while color over a body for this frame
---
---This is used for valuables in the game
---@param handle body
---@param alpha number
function DrawBodyHighlight(handle, alpha) end

---Returns the closest point of a specific body
---
---Usually, the point will be in 0.1 unit (1 voxel) increments of the body's shape
---@param handle body
---@param origin vector
---@return boolean hit If a point was found
---@return vector point Worldspace point
---@return vector normal World space normal
---@return shape shape The handle to the closest shape 
function GetBodyClosestPoint(handle, origin) end

-- ---@param handle body
-- function ConstrainVelocity(handle) end

-- ---@param handle body
-- function ConstrainAngularVelocity(handle) end

-- ---@param handle body
-- function ConstrainPosition(handle) end

-- ---@param handle body
-- function ConstrainOrientation(handle) end

---@return body worldbody
function GetWorldBody() end

-------------------------------------------------------------------------------------------------------------------------------------------------------
----------------Shapes--------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

---@param shape shape
---@return body shapebody
function GetShapeBody(shape) end

-------------------------------------------------------------------------------------------------------------------------------------------------------
----------------User Input--------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

---@param key key
---@return boolean key_pressed
function InputPressed(key) end

---@param key key
---@return boolean key_pressed
function InputDown(key) end

---@param key key
---@return boolean key_pressed
function InputReleased(key) end

---@param key key
---@return number value
function InputValue(key) end

---@return key key
function InputLastPressedKey() end