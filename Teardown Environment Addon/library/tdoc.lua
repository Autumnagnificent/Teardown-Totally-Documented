---@meta _

--[[
	Manually created/hand typed by Λutumnatic,
	Help from Thomasims
	Motivation from the awesome modding community, thanks everyone.

	Not all function are catagorized how they are in the offical api documentation
	Some are split up into more catagories, and some
	are moved to better represent their functionality
]]

--#region Types and Classes

---Teardown parses paths in a special way :
---
---| Starts With | Description |
---|-|-|
---| *nothing* | Varies depending on the function, but usually is `<Teardown>/data` or a folder inside it |
---| `MOD/` | The root folder of the mod |
---| `LEVEL/` | Only for campagin levels. Finds the folder in the `<Teardown>/data/level/<currently_loaded_xml_file>/` |
---| `LIBRARY/` | Points to `<Teardown>/data/library>`, this folder is not created when the game is installed, and only exists on the developers end. It can however be created manually to function, though this should not be used |
---| `RAW:` | Uses an absolute path, the disk volume in which game is installed at. This is techinally a sercurity risk and can be used to execute code not contained within the mod itself. |
---
---If you wish you include an encypted teardown file, do not inculde `.tde`, and teardown will decrypt and parse it.
---@class td_path: string

---@class vector
---@feild [1] number
---@feild [2] number
---@feild [3] number
---@class quaternion
---@feild [1] number
---@feild [2] number
---@feild [3] number
---@feild [4] number

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
---| "cameray" Camera y movement, scaled by sensitivity.
---| "mousedx" Mouse horizontal diff.
---| "mousedy" Mouse vertical diff.
---| "mousewheel" Mouse wheel.

---@alias material
---| "none"
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

---@alias path_state
---| "idle" No recent query
---| "busy" Busy computing. No path found yet
---| "fail" Failed to find path. You can still get the resulting path
---| "done" Path planning completed and a path was found. Get it with GetPathLength and GetPathPoint)

---@alias particle_type
---| "plain" No collision with other particles
---| "smoke" Light collision with other smoke particles

---@alias particle_tile
---| 0 smokey
---| 1 splattery
---| 2 bubbles
---| 3 explosion
---| 4 circle
---| 5 flame
---| 6 solid square
---| 7 blank_texture
---| 8 random dots
---| 9 blank_texture
---| 10 blank_texture
---| 11 blank_texture
---| 12 rainfall
---| 13 rainfall blurry
---| 14 water splash
---| 15 water ripple

---@alias transition_method
---|"linear" Linear transition
---|"cosine" Slow at beginning and end
---|"easein" Slow at beginning
---|"easeout" Slow at end
---|"bounce" Bounce and overshoot new value
---|"constant" Instant transition

---@alias environment_property
---| "ambience"
---| "ambient"
---| "ambientexponent"
---| "brightness"
---| "constant"
---| "exposure"
---| "fogcolor"
---| "fogparams"
---| "fogscale"
---| "nightlight"
---| "puddleamount"
---| "puddlesize"
---| "rain"
---| "skybox"
---| "skyboxbrightness"
---| "skyboxrot"
---| "skyboxtint"
---| "slippery"
---| "snowamount"
---| "snowdir"
---| "snowonground"
---| "sunbrightness"
---| "suncolortint"
---| "sundir"
---| "sunfogscale"
---| "sunglare"
---| "sunlength"
---| "sunspread"
---| "waterhurt"
---| "wetness"
---| "wind"

---@alias postprocessing_property
---| "saturation"
---| "colorbalance"
---| "brightness"
---| "gamma"
---| "bloom"

---@alias ui_alignment
---| "left"
---| "center"
---| "right"
---| "top"
---| "middle"
---| "bottom"
---| "left top"
---| "center top"
---| "right top"
---| "left middle"
---| "center middle"
---| "right middle"
---| "left bottom"
---| "center bottom"
---| "right bottom"

---@alias command
---| "game.about"
---| "game.applydisplay"
---| "game.applygraphics"
---| "game.bakemission"
---| "game.exitlevel"
---| "game.menu"
---| "game.openfolder"
---| "game.openurl"
---| "game.path.load"
---| "game.path.save"
---| "game.pausemenu"
---| "game.quickload"
---| "game.quicksave"
---| "game.quit"
---| "game.respawn"
---| "game.restart"
---| "game.screenrecord"
---| "game.selectmod"
---| "game.steam.showbindingpanel"
---| "game.startui"
---| "game.unpause"
---| "hydra.eventToolUpgrade"
---| "hydra.eventTutorial"
---| "mods.deactivate"
---| "mods.publishend"
---| "mods.publishupload"
---| "mods.refresh"
---| "mods.sanitycheck"


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

---<u>underlined</u> parts represent varying values
---| Command | Description |
---|-|-|
---| activate | |
---| exit | Unused |
---| explosion <u>strength</u> <u>x</u> <u>y</u> <u>z</u> | Called when an explosion happens. |
---| quickload | Called instead of init after a quicksave is loaded. |
---| quicksave | Called after the <u>game.quicksave</u> command is run. |
---| resolutionchanged | Called after the <u>game.applydisplay</u> command is run. |
---| shot <u>strength</u> <u>x</u> <u>y</u> <u>z</u> <u>dx</u> <u>dy</u> <u>dz</u> | Called when a gunshot hits a surface.|
---| updatemods |  |
---
---NOT IN OFFICAL DOCUMENTATION
---@param command string
function handleCommand(command) end

---Creates a button that can be accesed via the pause menu. Call every tick
---
---Creating a pause menu button will create a key at `game.pausemenu.items.<current_script_handle>` with the title as it's value
---
---The pause menu button can also be called via `Command('game.pausemenu', <script_handle>)`
---@param title string
---@param primary boolean? The button will show in the center of the pause menu instead of the lower bar. Only one button may occupy this space, otherwise it will show in the lower bar.
---@return boolean activated
function PauseMenuButton(title, primary) end

--#endregion
--#region XML Parameters

---Scripts can have parameters defined in the level XML file. This can be used to configure various options and parameters of the script.
---
---While these parameters can be read at any time in the script, it's recommended to copy them to a global variable in or outside the init function. 
---@param name string Parameter name
---@param default integer? Default parameter value
---@return integer
function GetIntParam(name, default) end
---Scripts can have parameters defined in the level XML file. This can be used to configure various options and parameters of the script.
---
---While these parameters can be read at any time in the script, it's recommended to copy them to a global variable in or outside the init function. 
---@param name string Parameter name
---@param default number? Default parameter value
---@return number
function GetFloatParam(name, default) end
---Scripts can have parameters defined in the level XML file. This can be used to configure various options and parameters of the script.
---
---While these parameters can be read at any time in the script, it's recommended to copy them to a global variable in or outside the init function. 
---@param name string Parameter name
---@param default boolean? Default parameter value
---@return boolean
function GetBoolParam(name, default) end
---Scripts can have parameters defined in the level XML file. This can be used to configure various options and parameters of the script.
---
---While these parameters can be read at any time in the script, it's recommended to copy them to a global variable in or outside the init function. 
---@param name string Parameter name
---@param default string? Default parameter value
---@return string
function GetStringParam(name, default) end

--#endregion
--#region Registry

---Remove registry node, including all child nodes.
---@param key string
function ClearKey(key) end

---List all child keys of a registry node.
---@param key string
---@return table<string> keys
function ListKeys(key) end

---Returns true if the registry contains a certain key
---@param key string
---@return boolean exists
function HasKey(key) end

---Returns an integer value of registry node or zero if not found
---@param key string
---@return integer value
function GetInt(key) end

---@param key string
---@param value number
function SetInt(key, value) end

---Returns an float value of registry node or zero if not found
---@param key string
---@return number value
function GetFloat(key) end

---@param key string
---@param value number
function SetFloat(key, value) end

---Returns an boolean value of registry node or false if not found
---@param key string
---@return boolean value
function GetBool(key) end

---@param key string
---@param value boolean
function SetBool(key, value) end

---Returns the value of registry node or a blank string (`""`) if not found
---@param key string
---@return string value
function GetString(key) end

---@param key string
---@param value string
function SetString(key, value) end

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
function VecSub(a, b) end

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
---@param target vector? A vector representing the point to look at
---@return quaternion created_quaternion
function QuatLookAt(eye, target) end

---Interpolates between two quaternions.
---
---@param quatA quaternion
---@param quatB quaternion
---@param t number
---@return quaternion quaternion
function QuatSlerp(quatA, quatB, t) end

---Multiplies two quaternions together (effectively rotates one by another.)
---
---@param quatA quaternion
---@param quatB quaternion
---@return quaternion quaternion
function QuatRotateQuat(quatA, quatB) end

---Rotates a vector using a quaternion.
---
---@param quaternion quaternion
---@param vector vector
---@return vector vector
function QuatRotateVec(quaternion, vector) end

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
---@return transform transform
function TransformToParentTransform(relation, transform) end

---Transfom a position out of the parent space of another transform
---
---One way to think about this is getting the world position of the second parameter realative to the given transform.
---@param relation transform
---@param position vector
---@return vector point
function TransformToParentPoint(relation, position) end

---Transfom a vector out of the parent space of another transform only considering rotation
---@param relation transform
---@param vector vector
---@return vector vector
function TransformToParentVec(relation, vector) end

---Transform one transform into the local space of another transform
---
---One way to think about this is getting the local transform of the second parameter realative to the given transform.
---@param relation transform
---@param transform transform
---@return transform transform
function TransformToLocalTransform(relation, transform) end

---Transfom a position into the local space of another transform
---
---One way to think about this is getting the local position of the second parameter realative to the given transform.
---@param relation transform
---@param position vector
---@return vector point
function TransformToLocalPoint(relation, position) end

---Transfom a vector into the local space of another transform only considering rotation
---@param relation transform
---@param vector vector
---@return vector vector
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
---@return table<string>
function ListTags(entity) end

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
---@param reject_transparent boolean|nil See through transparent materials, Default is false
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

---TODO: explain this
---
---Should only be called from the `update` callback
---@param bodyA body_handle
---@param bodyB body_handle
---@param point vector
---@param dir vector
---@param relative_velocity number
---@param min_impulse? number
---@param max_impulse? number
function ConstrainVelocity(bodyA, bodyB, point, dir, relative_velocity, min_impulse, max_impulse) end

---TODO: explain this
---
---Should only be called from the `update` callback
---@param bodyA body_handle
---@param bodyB body_handle
---@param dir vector
---@param relative_angular_velocity number
---@param min_angular_impulse? number
---@param max_angular_impulse? number
function ConstrainAngularVelocity(bodyA, bodyB, dir, relative_angular_velocity, min_angular_impulse, max_angular_impulse) end

---TODO: explain this
---
---Should only be called from the `update` callback
---@param bodyA body_handle
---@param bodyB body_handle
---@param pointA vector
---@param pointB vector
---@param max_velocity? number
---@param max_impulse? number
function ConstrainPosition(bodyA, bodyB, pointA, pointB, max_velocity, max_impulse) end

---TODO: explain this
---
---Should only be called from the `update` callback
---@param bodyA body_handle
---@param bodyB body_handle
---@param quatA quaternion
---@param quatB quaternion
---@param max_angular_velocity? number
---@param max_angular_impulse? number
function ConstrainOrientation(bodyA, bodyB, quatA, quatB, max_angular_velocity, max_angular_impulse) end

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

---Return material properties for specific matirial entry.
---@param shape shape_handle
---@param index integer
---@return material type
---@return number red
---@return number green
---@return number blue
---@return number alpha
---@return number reflectivity Range 0 - 1
---@return number shininess Range 0 - 1
---@return number metallic Range 0 - 1
---@return number emissive Range 0 - 32
function GetShapeMaterial(shape, index) end

---Return material properties for a particular voxel given a world-space position
---@param shape shape_handle
---@param position vector
---@return material|'' type
---@return number red
---@return number green
---@return number blue
---@return number alpha
---@return integer entry
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
---@return integer entry
function GetShapeMaterialAtIndex(shape, x, y, z) end

---@param shape shape_handle
---@return integer xsize Size in voxels along x axis
---@return integer ysize Size in voxels along y axis
---@return integer zsize Size in voxels along z axis
---@return number scale The size of one voxel in meters (with default scale it is 0.1)
function GetShapeSize(shape) end

---Returns the voxels in a given shape
---
---Well lets see here; 1, 2, 3, hold still here, 4! ahh ahh ahh ahh!
---@param shape shape_handle
---@return number voxels
function GetShapeVoxelCount(shape) end

---A very inaccurate way of testing if a shape is visible to the camera.
---
---If any level of perscion is needed, It is recommended to use alternative methods such as raycasting or dot products.
---
---Offical documentation says :
---
---This will check if a shape is currently visible in the camera frustum and not occluded by other objects.
---@param shape shape_handle
---@param max_distance number
---@param reject_transparent boolean|nil See through transparent materials, Default is false
---@return boolean
function IsShapeVisible(shape, max_distance, reject_transparent) end

---Determine if shape has been broken.
---
---Note that a shape can be transfered to another body during destruction, but might still not be considered broken if all voxels are intact.
---@param shape shape_handle
---@return boolean
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
---@param shape shape_handle
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
--#region Shape Modification

---Creates a new _empty_ shape in the world under an existing body.
---
---A empty body can easily be created with
---```
---Spawn('<body/>')[1]
---```
---@param body body_handle The parent body to create the shape under
---@param transform transform transform of shape relative to the body
---@param reference_shape shape_handle|td_path What palette to use, can be a shape handle or a vox file
---@return shape_handle
function CreateShape(body, transform, reference_shape) end

---Fill a voxel shape with zeroes, thus removing all voxels.
---@param shape shape_handle
function ClearShape(shape) end

---Resize an existing shape.
---
---The new coordinates are expressed in the existing shape coordinate frame, so you can provide negative values.
---
---The existing content is preserved, but may be cropped if needed. The local shape transform will be moved automatically with an offset vector to preserve the original content in body space.
---
---This offset vector is returned in shape local space.
---@param shape shape_handle
---@param xmi integer Lower X coordinate
---@param ymi integer Lower Y coordinate
---@param zmi integer Lower Z coordinate
---@param xma integer Upper X coordinate
---@param yma integer Upper Y coordinate
---@param zma integer Upper Z coordinate
---@return vector offset Offset vector in local space
function ResizeShape(shape, xmi, ymi, zmi, xma, yma, zma) end

---Move existing shape to a new body, optionally providing a new local transform.
---@param shape shape_handle
---@param body body_handle
---@param transform transform?
function SetShapeBody(shape, body, transform) end

---Copy voxel content from source shape to destination shape.
---
---If destination shape has a different size, it will be resized to match the source shape.
---@param source shape_handle
---@param destination shape_handle
function CopyShapeContent(source, destination) end

---Copy the palette from source shape to destination shape.
---@param source shape_handle
---@param destination shape_handle
function CopyShapePalette(source, destination) end

---Return list of material entries, each entry is a material index that can be provided to GetShapeMaterial or used as brush for populating a shape.
---@param shape shape_handle
---@return table palette palette material entries
function GetShapePalette(shape) end

---Set material index to be used for following calls to DrawShapeLine and DrawShapeBox and ExtrudeShape.
---
---An optional brush vox file and subobject can be used and provided instead of material index, in which case the content of the brush will be used and repeated.
---
---Use material index zero to remove of voxels.
---@param type 'sphere'|'cube'|'noise'
---@param size number Size of the brush, must be from 1-16
---@param index integer|td_path A material or vox file in which to sample from
---@param object td_path? Optional vox file and subobject can be used and provided instead of material index
function SetBrush(type, size, index, object) end

---Draw voxelized line between (x0,y0,z0) and (x1,y1,z1) into shape using the material set up with SetBrush.
---
---Paint mode will only change material of existing voxels (where the current material index is non-zero).
---
---noOverwrite mode will only fill in voxels if the space isn't already accupied by another shape in the scene.
---@param shape shape_handle
---@param x0 number Start X coordinate
---@param y0 number Start Y coordinate
---@param z0 number Start Z coordinate
---@param x1 number End X coordinate
---@param y1 number End Y coordinate
---@param z1 number End Z coordinate
---@param paint boolean? Paint mode. Default is false.
---@param noOverwrite boolean? Only fill in voxels if space isn't already occupied. Default is false.
function DrawShapeLine(shape, x0, y0, z0, x1, y1, z1, paint, noOverwrite) end

---Draw box between `{ x0, y0, z0 }` and `{ x1, y1, z1 }` into shape using the material set up with SetBrush.
---@param x0 number Start X coordinate
---@param y0 number Start Y coordinate
---@param z0 number Start Z coordinate
---@param x1 number End X coordinate
---@param y1 number End Y coordinate
---@param z1 number End Z coordinate
function DrawShapeBox(shape, x0, y0, z0, x1, y1, z1) end

---Extrude region of shape. The extruded region will be filled in with the material set up with SetBrush.
---
---The mode parameter sepcifies how the region is determined.
---
---Exact mode selects region of voxels that exactly match the input voxel at input coordinate.
---
---Material mode selects region that has the same material type as the input voxel.
---
---Geometry mode selects any connected voxel in the same plane as the input voxel.
---@param shape shape_handle
---@param x number X coordinate to extrude
---@param y number Y coordinate to extrude
---@param z number Z coordinate to extrude
---@param dx number X component of extrude direction, should be -1, 0 or 1
---@param dy number Y component of extrude direction, should be -1, 0 or 1
---@param dz number Z component of extrude direction, should be -1, 0 or 1
---@param steps number Length of extrusion in voxels
---@param mode string Extrusion mode, one of "exact", "material", "geometry". Default is "exact"
function ExtrudeShape(shape, x, y, z, dx, dy, dz, steps, mode) end

---Trim away empty regions of shape, thus potentially making it smaller.
---
---If the size of the shape changes, the shape will be automatically moved to preserve the shape content in body space.
---
---The offset vector for this translation is returned in shape local space.
---@param shape shape_handle
---@return vector offset Offset vector in local space
function TrimShape(shape) end

---Split up a shape into multiple shapes based on connectivity.
---
---If the removeResidual flag is used, small disconnected chunks will be removed during this process to reduce the number of newly created shapes.
---@param shape shape_handle
---@param removeResidual boolean?
---@return table<shape_handle> new_shapes List of new shape handles that have been created 
function SplitShape(shape, removeResidual) end

---Try to merge shape with a nearby, matching shape. For a merge to happen, the shapes need to be aligned to the same rotation and touching.
---
---If the provided shape was merged into another shape, that shape may be resized to fit the merged content.
---
---If shape was merged, the handle to the other shape is returned, otherwise the input handle is returned.
---@param shape shape_handle
---@return shape_handle result Shape handle after merge
function MergeShape(shape) end

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
--#region Triggers

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
---@param vehicle vehicle_handle
---@return boolean inside
function IsVehicleInTrigger(trigger, vehicle) end

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
---@return boolean empty
---@return vector? maxpoint
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
--#region Screens

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

---Returns the handle to the screen running this script or zero if none.
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@return screen_handle screen
function UiGetScreen() end

--#endregion
--#region Vehicles

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
---@return transform transform
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
--#region Camera

---Returns the transform of the current camera
---@return transform camera_transform
function GetCameraTransform() end

---Sets the transform of the camera, Call continuously
---
---Has an optional parameter for setting fiewld of view
---@param transform transform
---@param field_of_view number|nil Default is 90, regardless of player's set fov in the options menu
function SetCameraTransform(transform, field_of_view) end

---Override field of view for the next frame for all camera modes, except when explicitly set in SetCameraTransform
---
---Call continuously
---@param field_of_view number
function SetCameraFov(field_of_view) end

---Override depth of field for the next frame for all camera modes. Depth of field will be used even if turned off in options.
---@param distance number
---@param amount number|nil Default is 1.0
function SetCameraDof(distance, amount) end

--#endregion
--#region Tools

---Register a custom tool that will show up in the player inventory and can be selected with scroll wheel.
---
---Do this only once per tool. You also need to enable the tool in the registry before it can be used.
---@param id string
---@param name string
---@param file td_path
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
--#region Sounds

---Loads a Sound and returns the handle for it
---
---Multiple sounds can be loaded into the same handle to be played at random.
---
---LoadSound("example-sound")
---
---"example-sound0.ogg", "example-sound1.ogg", "example-sound2.ogg", ...
---@param path td_path
---@param nominal_distance number|nil The distance in meters this sound is recorded at. Affects attenuation. Default is 10
---@return sound_handle
function LoadSound(path, nominal_distance) end

---Loads a Loop and returns the handle for it
---@param path td_path
---@param nominal_distance number|nil The distance in meters this sound is recorded at. Affects attenuation. Default is 10
---@return loop_handle
function LoadLoop(path, nominal_distance) end

---@param sound sound_handle
---@param position vector|nil Default is player position
---@param volume number|nil Default is 1.0
function PlaySound(sound, position, volume) end

---Call continuously
---@param loop loop_handle
---@param position vector|nil Default is player position
---@param volume number Default is 1.0
function PlayLoop(loop, position, volume) end

---@param path td_path
function PlayMusic(path) end

function StopMusic() end

---UI sounds are not affected by acoustics simulation.
---
---Use LoadSound / PlaySound for that.
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param path td_path
---@param volume number|nil Default is 1.0
---@param pitch number|nil Default is 1.0
---@param pan number|nil Stero panning (*-1.0 to 1.0*) Default is 0.0
function UiSound(path, volume, pitch, pan)
end

---Call this continuously to keep playing loop.
---
---UI sounds are not affected by acoustics simulation.
---
---Use LoadLoop / PlayLoop for that.
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param path td_path
---@param volume number|nil Default is 1.0
function UiSoundLoop(path, volume)
end

---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param amount number Mute by this amount (*-1.0 to 1.0*)
---@param mute_music boolean|nil Mute the music as well. Default is false
function UiMute(amount, mute_music)
end

--#endregion
--#region Sprites

---Loads a sprite into the Sprite Table and returns the handle
---
---If LoadSprite is called with a nil path, then when the handle is drawn, it will use the last drawn sprite on the screen.
---
---If no sprite have been drawn on screen before this one, it will default to the Render Texture 0, albedo/color buffer
---
---https://acko.net/files/teardown-teardown/01-color-pass-albedo.png
---@param path string
---@return sprite_handle
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
---| physical | have a physical representation |
---| dynamic | part of a dynamic body |
---| static | part of a static body |
---| large | above debris threshold |
---| small | below debris threshold |
---| visible | only hit visible shapes |
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

---To retrieve the intersected point, you can add the distance multipled by the direction
---
---```lua
---local _, distance = QueryRaycast(origin, direction, max_distance)
---local intersection = VecAdd(origin, VecScale(direction, distance))
---```
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

---Querys the closest point to all shapes in the world
---@param origin vector
---@param max_dist number
---@return boolean hit
---@return vector point
---@return vector normal
---@return shape_handle shape
function QueryClosestPoint(origin, max_dist) end


---Return all shapes in which there origins are witin the provided world space, axis-aligned bounding box 
---
---This is seperate from a Oriented Bounding Box (OBB) which supports rotations
---@param lower_bound vector
---@param upper_bound vector
---@return shape_handle[]
function QueryAabbShapes(lower_bound, upper_bound) end

---Return all bodies in which there origins are witin the provided world space, axis-aligned bounding box 
---
---This is seperate from a Oriented Bounding Box (OBB) which supports rotations
---@param lower_bound vector
---@param upper_bound vector
---@return body_handle[]
function QueryAabbBodies(lower_bound, upper_bound) end

---@param origin vector
---@param max_distance number
---@return boolean hit
---@return vector position
function QueryClosestFire(origin, max_distance) end

---Counts how many fires are within the given Axis Aligned Bounding Box
---
---If you are trying to find the position of fires within a large range, one method is to use an octree
---
---This is seperate from a Oriented Bounding Box (OBB) which supports rotations
---@param lower_bound vector
---@param upper_bound vector
---@return number count
function QueryAabbFireCount(lower_bound, upper_bound) end

---Removes all fires within the given Axis Aligned Bounding Box, returns how many were removed
---
---This is seperate from a Oriented Bounding Box (OBB) which supports rotations
---@param lower_bound vector
---@param upper_bound vector
---@return number count 
function RemoveAabbFires(lower_bound, upper_bound) end

---Returns the loudest sound played last frame
---@return number volume volume of the loudest sound of last frame
---@return vector world_position position of the loudest sound of last frame
function GetLastSound() end

---@param point vector
---@return boolean in_water
---@return number depth Depth of point into water, or zero if not in water
function IsPointInWater(point) end

---Get the wind velocity at provided point.
---
---The wind will be determined by wind property of the environment, but it varies with position procedurally.
---@param point vector
---@return vector velocity
function GetWindVelocity(point) end

--#endregion
--#region Path finding

---Initiate path planning query.
---
---The result will run asynchronously as long as GetPathState retuns "busy". An ongoing path query can be aborted with AbortPath.
---
---The path planning query will use the currently set up query filter, just like the other query functions.
---@param start vector
---@param target vector
---@param max_distance number|nil Maximum path length before giving up. Default is infinite.
---@param target_radius number|nil Maximum allowed distance to target in meters. Default is 2.0
function QueryPath(start, target, max_distance, target_radius) end

---Abort current path query, regardless of what state it is currently in.
---
---This is a way to save computing resources if the result of the current query is no longer of interest.
function AbortPath() end

---Return the current state of the last path planning query.
---@return path_state path_state
function GetPathState() end

---Return the path length (*in meters*) of the most recently computed path query.
---
---Note that the result can often be retrieved even if the path query failed.
---@return number length Length of last path planning result (in meters)
function GetPathLength() end

---Return a point along the path for the most recently computed path query
---
---If the target point couldn't be reached, the path endpoint will be the point closest to the target.
---@param distance number A distance (*in meters*) of how far along the path should the point be sampled
function GetPathPoint(distance) end

--#endregion
--#region Particles

---Reset to default particle state:
---
---plain, white particle of radius 0.5. Collision is enabled and it alpha animates from 1 to 0.
function ParticleReset() end

---@param particle_type particle_type Changes the behaviour of the particle
function ParticleType(particle_type) end

---@param particle_tile particle_tile Tile in the particle texture atlas (*0-15*)
function ParticleTile(particle_tile) end

---Set particle color to either constant (*three arguments*) or linear interpolation (*six arguments*)
---@param red number
---@param green number
---@param blue number
---@param red_end number|nil interpolated to over the particle's life
---@param green_end number|nil interpolated to over the particle's life
---@param blue_end number|nil interpolated to over the particle's life
function ParticleColor(red, green, blue, red_end, green_end, blue_end) end

---Set the particle radius. Max radius for smoke particles is 1.0. 
---@param radius number
---@param radius_end number|nil
---@param interpolation transition_method|nil
---@param fadein number|nil
---@param fadeout number|nil
function ParticleRadius(radius, radius_end, interpolation, fadein, fadeout) end

---@param alpha number
---@param alpha_end number|nil
---@param interpolation transition_method|nil
---@param fadein number|nil
---@param fadeout number|nil
function ParticleAlpha(alpha, alpha_end, interpolation, fadein, fadeout) end

---Set particle gravity. It will be applied along the world Y axis. A negative value will move the particle downwards.
---@param gravity number
---@param gravity_end number|nil
---@param interpolation transition_method|nil
---@param fadein number|nil
---@param fadeout number|nil
function ParticleGravity(gravity, gravity_end, interpolation, fadein, fadeout) end

---@param drag number
---@param drag_end number|nil
---@param interpolation transition_method|nil
---@param fadein number|nil
---@param fadeout number|nil
function ParticleDrag(drag, drag_end, interpolation, fadein, fadeout) end

---Draw particle as emissive (glow in the dark). This is useful for fire and embers. 
---@param emissive number
---@param emissive_end number|nil
---@param interpolation transition_method|nil
---@param fadein number|nil
---@param fadeout number|nil
function ParticleEmissive(emissive, emissive_end, interpolation, fadein, fadeout) end

---Makes the particle rotate. Positive values is counter-clockwise rotation.
---@param rotation number - radians per second
---@param rotation_end number|nil - radians per second
---@param interpolation transition_method|nil
---@param fadein number|nil
---@param fadeout number|nil
function ParticleRotation(rotation, rotation_end, interpolation, fadein, fadeout) end

---Stretch particle along with velocity.
---
---0.0 means no stretching. 1.0 stretches with the particle motion over one frame. Larger values stretches the particle even more.
---@param stretch number
---@param stretch_end number|nil
---@param interpolation transition_method|nil
---@param fadein number|nil
---@param fadeout number|nil
function ParticleStretch(stretch, stretch_end, interpolation, fadein, fadeout) end

---Make particle stick when in contact with objects. This can be used for friction. 
---@param sticky number
---@param sticky_end number|nil
---@param interpolation transition_method|nil
---@param fadein number|nil
---@param fadeout number|nil
function ParticleSticky(sticky, sticky_end, interpolation, fadein, fadeout) end

---Control particle collisions.
---
---A value of zero means that collisions are ignored. One means full collision.
---
---It is sometimes useful to animate this value from zero to one in order to not collide with objects around the emitter.
---@param collision number
---@param collision_end number|nil
---@param interpolation transition_method|nil
---@param fadein number|nil
---@param fadeout number|nil
function ParticleCollide(collision, collision_end, interpolation, fadein, fadeout) end

---Set particle bitmask.
---
---The value 256 means fire extinguishing particles and is currently the only flag in use.
---
---There might be support for custom flags and queries in the future.
---@param bitmask number
function ParticleFlags(bitmask) end

---Set orientation of particles to be spawned.
---
---| Flag | Description |
---|-|-|
---| `normalup` | Face the camera, with a random roll each frame
---| `up` | Face up.
---| `fixed` | Face the camera, but with a constant roll.
---| `flat` | The particle will be flat instead of a pyramid shape.
---(*mutually exclusive, prioritized in that order*)
---
---NOT IN OFFICAL DOCUMENTATION
---@param flags string
function ParticleOrientation(flags) end

---Spawns a particle using the previously set up particle state. You can call this multiple times using the same particle state, but with different position, velocity and lifetime. You can also modify individual properties in the particle state in between calls to to this function.
---@param position vector
---@param velocity vector
---@param lifetime number
function SpawnParticle(position, velocity, lifetime) end

--#endregion
--#region Spawning

---The first argument can be either a prefab XML file in your mod folder or a string with XML content
---
---It possible to spawn prefabs from other mods, by using the mod id followed by colon, followed by the prefab path. Spawning prefabs from other mods should be used with causion since the referenced mod might not be installed.
---@param xml string|td_path Teardown Path or XML content
---@param transform transform? Transform of the spawned XML
---@param allow_static boolean? Allow spawning static shapes and bodies. Default is false
---@param joint_existing boolean? Allow joints to connect to existing scene geometry. Default is false
---@return table<entity_handle> entities An indexed table of the entities spawned in order
function Spawn(xml, transform, allow_static, joint_existing) end

--#endregion
--#region User Interface

---Calling this function will disable game input, bring up the mouse pointer and allow Ui interaction with the calling script without pausing the game. This can be useful to make interactive user interfaces from scripts while the game is running. Call this continuously every frame as long as Ui interaction is desired.
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiMakeInteractive() end

---Push state onto stack. This is used in combination with `UiPop` to remember a state and restore to that state later.
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiPush() end

---Pop state from stack and make it the current one. This is used in combination with UiPush to remember a previous state and go back to it later.
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiPop() end

---Width of draw context
---
---Can be effected by UiWindow; *but otherwise will usally be 1920*
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@return number width
function UiWidth() end

---Height of draw context
---
---Can be effected by UiWindow; *but otherwise will usally be 1080*
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@return number height
function UiHeight() end

---Half of the width of the draw context, equivalent to
---```
---UiWidth() / 2
---```
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@return number halfwidth
function UiCenter() end

---Half of the height of the draw context, equivalent to
---```
---UiHeight() / 2
---```
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@return number halfheight
function UiMiddle() end

---Sets the color of the scope
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param red number|nil Default is 0.0
---@param green number|nil Default is 0.0
---@param blue number|nil Default is 0.0
---@param alpha number|nil Default is 1.0
function UiColor(red, green, blue, alpha) end

---Multiplies every color by these values within this scope
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param red number|nil Default is 0.0
---@param green number|nil Default is 0.0
---@param blue number|nil Default is 0.0
---@param alpha number|nil Default is 1.0
function UiColorFilter(red, green, blue, alpha) end

---Translates/Moves the draw cursor around
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param x number?
---@param y number?
function UiTranslate(x, y) end

---Rotates the cursor
---
---When combined with UiScale, this can be used to skew the Ui
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param degrees number
function UiRotate(degrees) end

---Scales the cursor
---
---If y is nil, then the cursor will be scaled uniformly, otherwise the x and y axis will be scaled independently
---
---When combined with UiRotate, this can be used to skew the Ui
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param x number
---@param y number|nil
function UiScale(x, y) end

---Set up new bounds. Calls to UiWidth, UiHeight, UiCenter and UiMiddle will operate in the context of the window size.
---
---If clip is set to true, contents of window will be clipped to bounds (only works properly for non-rotated windows).
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param width number Window width
---@param height number Window height
---@param clip boolean|nil boolean Clip content outside window. Default is false.
---@param inherit boolean|nil boolean Inherit current clip region (for nested clip regions)
function UiWindow(width, height, clip, inherit) end

---Return a safe drawing area that will always be visible regardless of display aspect ratio.
---
---The safe drawing area will always be 1920 by 1080 in size. This is useful for setting up a fixed size UI.
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiSafeMargins() end

---The alignment determines how content is aligned with respect to the cursor.
---| Alignment | Description |
---|-|-|
---| left | Horizontally align to the left |
---| right | Horizontally align to the right |
---| center | Horizontally align to the center |
---| top | Vertically align to the top |
---| bottom | Veritcally align to the bottom |
---| middle | Vertically align to the middle |
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param alignment ui_alignment
function UiAlign(alignment) end

---Disable input for everything, except what's between UiModalBegin and UiModalEnd (or if modal state is popped)
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiModalBegin() end

---Disable input for everything, except what's between UiModalBegin and UiModalEnd Calling this function is optional. Modality is part of the current state and will be lost if modal state is popped.
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiModalEnd() end

---Disables input
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiDisableInput() end

---Enables input that has been previously disabled
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
function UiEnableInput() end

---This function will check current state receives input. This is the case if input is not explicitly disabled with (with UiDisableInput) and no other state is currently modal (with UiModalBegin). Input functions and UI elements already do this check internally, but it can sometimes be useful to read the input state manually to trigger things in the UI.
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@return boolean received
function UiReceivesInput() end

---Returns the mouse pointer position relative to the cursor
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@return number x
---@return number y
function UiGetMousePos() end

---Returns true if the mouse pointer is within a specified rectangle.
---
---Note that this function respects alignment.
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param width number
---@param height number
---@return boolean inside
function UiIsMouseInRect(width, height) end

---Convert world space position to user interface X and Y coordinate relative to the cursor.
---
---The distance is in meters and positive if in front of camera, negative otherwise.
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param position vector
---@return number x X coordinate
---@return number y Y coordinate
---@return number distance Distance to point
function UiWorldToPixel(position) end

---Convert X and Y UI coordinate to a world direction, as seen from current camera.
---
---This can be used to raycast into the scene from the mouse pointer position.
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param x number
---@param y number
---@return vector direction world-space direction
function UiPixelToWorld(x ,y) end

---Perform a gaussian blur on current screen content
---
---Using an amount of zero will still effect the screen, using UiBlur serveral times can give some interesting screen effects
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param amount number
function UiBlur(amount) end

---Sets the font for the current scope
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param path td_path
---@param size number
function UiFont(path, size) end

---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@return number size Current font size
function UiFontHeight() end

---Renders text at the cursor position
---
---If auto_move is enabled, then the cursor will be translated moved back and down like a typewriter
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param text string|number
---@param auto_move boolean|nil
---@return number width
---@return number height
function UiText(text, auto_move) end

---Gets the space that the text will take up without rendering it
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param text string|number
---@return number width
---@return number height
function UiGetTextSize(text) end

---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param width number
function UiWordWrap(width) end

---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param red number|nil Default is 0
---@param green number|nil Default is 0
---@param blue number|nil Default is 0
---@param alpha number|nil Default is 0
---@param thickness number|nil Default is 0.1
function UiTextOutline(red, green, blue, alpha, thickness) end

---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param red number|nil Default is 0
---@param green number|nil Default is 0
---@param blue number|nil Default is 0
---@param alpha number|nil Default is 0
---@param distance number|nil Default is 1.0
---@param blur number|nil Default is 0.5
function UiTextShadow(red, green, blue, alpha, distance, blur) end

---Draw solid rectangle at cursor position
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param width number
---@param height number
function UiRect(width, height) end

---Draw image at cursor position.
---
---If x0, y0, x1, y1 is provided a cropped version will be drawn in that coordinate range.
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param path td_path
---@param x0 number|nil Lower x coordinate. Default is 0
---@param y0 number|nil Lower y coordinate. Default is 0
---@param x1 number|nil Upper x coordinate. Default is image width
---@param y1 number|nil Upper y coordinate. Default is image height
---@return number width
---@return number height
function UiImage(path, x0, y0, x1, y1) end

---Will unload an image that was previously loaded. This is useful to free up memory or if the image has changed since the iamge was first drawn/loaded
---@param path td_path
function UiUnloadImage(path) end

---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param path td_path
---@return number width
---@return number height
function UiGetImageSize(path) end

---Draw 9-slice image at cursor position.
---
---Width should be at least 2*border_width. Height should be at least 2*border_height.
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param path td_path
---@param width number
---@param height number
---@param border_width number
---@param border_height number
function UiImageBox(path, width, height, border_width, border_height) end

---Set up 9-slice image to be used as background for buttons.
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param path td_path
---@param border_width number
---@param border_height number
---@param red number|nil Default is 1.0
---@param green number|nil Default is 1.0
---@param blue number|nil Default is 1.0
---@param alpha number|nil Default is 1.0
function UiButtonImageBox(path, border_width, border_height, red, green, blue, alpha) end

---Button color filter when hovering mouse pointer.
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param red number|nil Default is 0.0
---@param green number|nil Default is 0.0
---@param blue number|nil Default is 0.0
---@param alpha number|nil Default is 1.0
function UiButtonHoverColor(red, green, blue, alpha) end

---Button color filter when pressing down.
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param red number|nil Default is 0.0
---@param green number|nil Default is 0.0
---@param blue number|nil Default is 0.0
---@param alpha number|nil Default is 1.0
function UiButtonPressColor(red, green, blue, alpha) end

---The button offset when being pressed
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param distance number
function UiButtonPressDist(distance) end

---Renders a button on screen displaing the text, returns true if it was pressed
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@return boolean pressed
---@param display_text string
---@param width number|nil If not specified, will be the width of the displayed text
---@param height number|nil If not specified, will be the height of the displayed text
function UiTextButton(display_text, width, height) end

---Renders a image on screen, returns true if it was pressed
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param path td_path
function UiImageButton(path) end

---Creates a button without rendering anything on the screen
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param width number
---@param height number
function UiBlankButton(width, height) end

---Renders a dragable slider on the screen
---
---The range is in pixels
---
---THIS FUNCTION WILL ONLY EXIST IF draw() IS DEFINED
---@param slider_image td_path
---@param axis 'x'|'y'
---@param current number Current value
---@param minimum number Minimum value
---@param maximum number Maximum value
---@return number updated_value
---@return boolean slider_released
function UiSlider(slider_image, axis, current, minimum, maximum) end

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
---@param red? number
---@param green? number
---@param blue? number
---@param alpha? number
function DebugLine(p1, p2, red, green, blue, alpha) end

---Draws a line between two points using Drawsprite()
---
---Will occlude behind walls (*as well as sprites occlude that is*)
---@param p1 vector
---@param p2 vector
---@param red? number
---@param green? number
---@param blue? number
---@param alpha? number
function DrawLine(p1, p2, red, green, blue, alpha) end

---Will draw 2 lines using DebugLine() in the form of a cross on the position of a point
---
---Useful for checking the position of a vector
---@param position vector
---@param red? number
---@param green? number
---@param blue? number
---@param alpha? number
function DebugCross(position, red, green, blue, alpha) end

--#endregion
--#region Scene Properties

---Reset the environment properties to default. This is often useful before setting up a custom environment.
function SetEnvironmentDefault() end

---The return type could vary depending on the property, could be nil if property does not exist
---@param property environment_property
---@return any|nil value0 
---@return any|nil value1 May be nil if property does not have overloads
---@return any|nil value2 May be nil if property does not have overloads
---@return any|nil value3 May be nil if property does not have overloads
---@return any|nil value4 May be nil if property does not have overloads
function GetEnvironmentProperty(property) end

---@param property environment_property
---@param value0 any|nil
---@param value1 any|nil
---@param value2 any|nil
---@param value3 any|nil
function SetEnvironmentProperty(property, value0, value1, value2, value3) end

---Reset the post proccesing properties to default.
function SetPostProcessingDefault() end

---@param property postprocessing_property
---@return any|nil value0
---@return any|nil value1 May be nil if property does not have overloads
---@return any|nil value2 May be nil if property does not have overloads
---@return any|nil value3 May be nil if property does not have overloads
---@return any|nil value4 May be nil if property does not have overloads
function GetPostProcessingProperty(property) end

---@param property postprocessing_property
---@param value0 any|nil
---@param value1 any|nil
---@param value2 any|nil
---@param value3 any|nil
function SetPostProcessingProperty(property, value0, value1, value2, value3) end

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

---Get the time in seconds since the script was created.
---
---@return number time
function GetTime() end

---Get the time in seconds since the last frame.
---
---This is the same as the `dt` parameter from the tick/draw/update callbacks.
---
---@return number time
function GetTimeStep() end

---Get the version of the game.
---
---@return string version
function GetVersion() end

---Tests whether or not the game version is greater or equal to the provided one.
---
---@param version string
---@return boolean match
function HasVersion(version) end

---Creates a projectile.
---
---"bullet" and "rocket" are the only projectiles that can hurt the player.
---
---For backwards compatability, a number will be accepted for the `type` parameter
---
---@param origin vector
---@param direction vector
---@param type  "bullet"|"rocket"|"gun"|"shotgun"|number
---@param strength number
---@param max_distance number
function Shoot(origin, direction, type, strength, max_distance) end

---@param origin vector Origin in world space as vector
---@param radius number Affected radius, in range 0.0 to 5.0
---@param type "spraycan"|"explosion"|nil Default is spraycan.
---@param probability number|nil Dithering probability between zero and one. Default is 1.0
function Paint(origin, radius, type, probability) end

---Makes a hole in the environment
---| Type | Materials |
---|-|-|
---| Soft | <u>glass</u>, <u>foliage</u>, <u>dirt</u>, <u>wood</u>, <u>plaster</u>, <u>plastic</u> |
---| Medium | <u>concrete</u>, <u>brick</u>, <u>weak metal</u> |
---| Hard | <u>hard metal</u>, <u>hard masonry</u> |
---@param position vector
---@param soft_radius number Hole radius for soft materials.
---@param medium_radius number|nil Hole radius for medium materials. Defualt is 0
---@param hard_radius number|nil Hole radius for hard materials. Defualt is 0
---@param silent boolean|nil Disables the breaking sound. Default is false
---@return number voxels_removed Number of voxels removed from all effected shapes, zero if no shapes were effected.
function MakeHole(position, soft_radius, medium_radius, hard_radius, silent) end

---Creates an explosion at the specified location
---
---Explosion sizes are clamped to values ranging from 0.5 to 4.0, if you need to create a bigger explosion, you can use multiple calls to Explosion(), use Shoot() with a large strength, or use MakeHole()
---@param position vector
---@param size number (0.5 to 4.0) Default is 1.0
function Explosion(position, size) end

---@param position vector
function SpawnFire(position) end

---@return number count The number of active fires in the level
function GetFireCount() end

---Sets the time scale for the next frame
---
---Call continuously
---
---Note that this can and will effect physical behaviors
---
---@param scale number (0.1 to 1.0)
function SetTimeScale(scale) end

---Shakes the Camera
---
---Camera Shake will persist through levels
---
---NOT IN OFFICAL DOCUMENTATION
---@param intensity number
function ShakeCamera(intensity) end

---Returns to the menu
function Menu() end

---@param state boolean
function SetPaused(state) end

--#endregion
--#region Special

---NOT IN OFFICAL DOCUMENTATION
---@param command command
---@vararg any
function Command(command, ... ) end

---Checks if a file exists at the specified path. Respects teardown's path parsing, meaning `MOD/`, `LEVEL/`, and `RAW:` will all work
---
---NOT IN OFFICAL DOCUMENTATION
---@param path td_path
---@return boolean
function HasFile(path) end

--#endregion