--[[
    As of now this framework requires the latest version of
    The Automatic framework, please download and include both

    CREATED BY AUTUMNATIC / AUTUMN
]]

SHRED_Timescale =                     1
SHRED_ShrapnelTable =                 {}

SHRED_Stats =                         {}
SHRED_Stats.SubSteps =                4      -- Default is 4

SHRED_Stats.GlobalDamageScale =       1      -- Default is 1
SHRED_Stats.BodyImpulseScale =        1      -- Default is 1

SHRED_Stats.BaseSpeed =               125    -- Default is 125
SHRED_Stats.BaseShrapnel =            4      -- Default is 4

SHRED_Stats.SpeedRandomness =         1 / 8  -- Default is 1 / 8

SHRED_Stats.SoftMaxSplits =           3.5    -- Default is 3.5
SHRED_Stats.SpeedDiminish =           2 / 3  -- Default is 2 / 3

SHRED_Stats.SplitDiminish =           (0.5 / SHRED_Stats.BaseShrapnel) ^ (1 / SHRED_Stats.SoftMaxSplits) -- Precalc

SHRED_Stats.DeletionSpeedThreshhold = 1 / 50 -- Default is 1 / 50
SHRED_Stats.DeletionAfterDriftSec =   1      -- Default is 1; Time in seconds that the shrapnel can stay out for without hitting something before it is deleted

SHRED_Stats.DustParticles =           true   -- Default is true
SHRED_Stats.VoxelChunkParticles =     true   -- Default is true

SHRED_Stats.WhizzSound    =   LoadSound('bullet-pass0.ogg')
SHRED_Stats.RicochetSound =   LoadSound('bullet-hit0.ogg')

SHRED_Stats.Lookup = {
    none        = { damage = true,  reflect = false, rndangle = 3.5,     splitscale = 1.0,  spark = false },

    glass       = { damage = true,  reflect = false, rndangle = 1.75,    splitscale = 1.0,  spark = false },
    foliage     = { damage = true,  reflect = false, rndangle = 3.5,     splitscale = 1.0,  spark = false },
    plastic     = { damage = true,  reflect = false, rndangle = 8.75,    splitscale = 1.0,  spark = false },
    plaster     = { damage = true,  reflect = false, rndangle = 13.125,  splitscale = 1.0,  spark = false },
    dirt        = { damage = true,  reflect = false, rndangle = 17.5,    splitscale = 1.0,  spark = false },
    ice         = { damage = true,  reflect = false, rndangle = 17.5,    splitscale = 1.0,  spark = false },
    wood        = { damage = true,  reflect = false, rndangle = 21.875,  splitscale = 0.8,  spark = false },
    metal       = { damage = true,  reflect = false, rndangle = 26.25,   splitscale = 0.65, spark = true  },
    masonry     = { damage = true,  reflect = false, rndangle = 35,      splitscale = 0.7,  spark = false },

    heavymetal  = { damage = true,  reflect = true,  rndangle = 17.5,    splitscale = 0.5,  spark = true  },
    rock        = { damage = false, reflect = true,  rndangle = 17.5,    splitscale = 0.5,  spark = false },
    hardmetal   = { damage = false, reflect = true,  rndangle = 17.5,    splitscale = 0.5,  spark = true  },
    hardmasonry = { damage = false, reflect = true,  rndangle = 17.5,    splitscale = 0.5,  spark = false },
    unphysical  = { damage = false, reflect = true,  rndangle = 17.5,    splitscale = 1.0,  spark = false },
}

SHRED_MaterialSoundBank = {
    none        = false,
    glass       = { small = LoadSound('glass/break-s0'),      medium = LoadSound('glass/break-m0'),      large = LoadSound('glass/break-l0')      },
    foliage     = { small = LoadSound('foliage/break-s0'),    medium = LoadSound('foliage/break-m0'),    large = LoadSound('foliage/break-l0')    },
    plastic     = { small = LoadSound('plastic/break-s0'),    medium = LoadSound('plastic/break-m0'),    large = LoadSound('plastic/break-l0')    },
    plaster     = { small = LoadSound('plastic/break-s0'),    medium = LoadSound('plastic/break-m0'),    large = LoadSound('plastic/break-l0')    },
    dirt        = { small = LoadSound('dirt/break-s0'),       medium = LoadSound('dirt/break-m0'),       large = LoadSound('dirt/break-l0')       },
    ice         = { small = LoadSound('ice/break-s0'),        medium = LoadSound('ice/break-m0'),        large = LoadSound('ice/break-l0')        },
    wood        = { small = LoadSound('wood/break-s0'),       medium = LoadSound('wood/break-m0'),       large = LoadSound('wood/break-l0')       },
    metal       = { small = LoadSound('metal/break-s0'),      medium = LoadSound('metal/break-m0'),      large = LoadSound('metal/break-l0')      },
    masonry     = { small = LoadSound('masonry/break-s0'),    medium = LoadSound('masonry/break-m0'),    large = LoadSound('masonry/break-l0')    },
    rock        = { small = LoadSound('masonry/break-s0'),    medium = LoadSound('masonry/break-m0'),    large = LoadSound('masonry/break-l0')    },
    heavymetal  = { small = LoadSound('metal/break-s0'),      medium = LoadSound('metal/break-m0'),      large = LoadSound('metal/break-l0')      },
    hardmetal   = { small = LoadSound('metal/break-s0'),      medium = LoadSound('metal/break-m0'),      large = LoadSound('metal/break-l0')      },
    hardmasonry = { small = LoadSound('masonry/break-s0'),    medium = LoadSound('masonry/break-m0'),    large = LoadSound('masonry/break-l0')    },
    unphysical  = { small = LoadSound('unphysical/break-s0'), medium = LoadSound('unphysical/break-m0'), large = LoadSound('unphysical/break-l0') },
}

local function SHRED_DustParticle(origin, dir, scale, color)
    scale = scale or 1
    ParticleReset()
    ParticleType('smoke')
    ParticleCollide(0, 1, 'constant', 0.1)
    ParticleRadius(0.125 * scale, 0.25 * scale)
    ParticleDrag(0.25)
    ParticleAlpha(0.55, 0.25)
    ParticleGravity(-0.1)

    ParticleTile(0)
    ParticleColor(unpack(color or { 0.55, 0.55, 0.55 }))
    ParticleStretch(20, 0, 'cosine')

    local vel = VecScale(dir or AutoVecRnd(1), math.random() * 3)
    local life = math.random() * 0.9 + 0.125
    SpawnParticle(origin, vel, life)
end

local function SHRED_VoxelParticle(origin, vel, life, color)
    ParticleReset()
    ParticleType('plain')
    ParticleCollide(0, 1)
    ParticleRadius(0.04, 0.04)
    ParticleDrag(0.025)
    ParticleAlpha(1, 0, 'smooth', 0, 0.8)
    ParticleGravity(-10)
    ParticleSticky(0.1, 0.35)

    ParticleTile(6)
    ParticleColor(unpack(color or { 0.55, 0.55, 0.55 }))
    -- ParticleStretch(20, 0, 'cosine')

    SpawnParticle(origin, vel or Vec(), life or 0.25)
end

---Creates a single shrapnel in the SHRED simulation, automatically adding it to the table. Returns the shrapnel and the new index
---@return { origin:vector, fwd:table, speed:number, dist:number, split:number, explosive:boolean, time:number, whizz:boolean, random:number }, integer
function SHRED_CreateShrapnel(origin, fwd, speed, split, explosive)
    local shrapnel = {
        pos = VecCopy(origin),
        fwd = VecCopy(fwd),
        speed = (speed or 100) - (math.random() * speed * SHRED_Stats.SpeedRandomness),
        split = split or 0,
        explosive = explosive,
        
        time = 0,
        whizz = false,
        origin = VecCopy(origin),
        random = math.random()
    }
    
    local index = #SHRED_ShrapnelTable+1
    SHRED_ShrapnelTable[index] = shrapnel
    return shrapnel, index
end

---Simulates the shrapnel within the `SHRED_ShrapnelTable` varaible 
---@param dt any
function SHRED_Update(dt)
    local player_pos = VecAdd(GetPlayerTransform().pos, Vec(0, 1.8 / 2))

    for pi, shrapnel in pairs(SHRED_ShrapnelTable) do
        local raycast = AutoRaycast(shrapnel.pos, shrapnel.fwd, shrapnel.speed * dt)

        shrapnel.time = shrapnel.time + dt
        shrapnel.pos = raycast.intersection

        local distance_to_player = AutoVecDist(player_pos, shrapnel.pos)
        if not shrapnel.whizz and distance_to_player < 1 then
            PlaySound(SHRED_Stats.WhizzSound)
            shrapnel.whizz = true
        end

        local voxels_removed = 0
        if raycast.hit then
            local mat, mat_r, mat_g, mat_b = GetShapeMaterialAtPosition(raycast.shape, raycast.intersection)
            mat = ((not mat) or mat == '') and 'none' or mat
            local mat_color = { mat_r, mat_g, mat_b }

            local lookup = SHRED_Stats.Lookup[mat]
            if not lookup then
                SHRED_ShrapnelTable[pi] = nil
                return
            end

            ApplyBodyImpulse(GetShapeBody(raycast.shape), shrapnel.pos,
                VecScale(VecScale(shrapnel.fwd, shrapnel.speed * SHRED_Stats.BodyImpulseScale), math.abs(raycast.dot)))

            if lookup.reflect or raycast.dot > 0.5 then
                shrapnel.fwd = QuatRotateVec(AutoRandomQuat(lookup.rndangle), raycast.reflection)
                PlaySound(SHRED_Stats.RicochetSound, shrapnel.pos, 0.3 + math.random() * 0.3)
            else
                if lookup.damage then
                    local damage = Vec((shrapnel.speed / SHRED_Stats.BaseSpeed) * 0.625,
                        (shrapnel.speed / SHRED_Stats.BaseSpeed) * 0.525, (shrapnel.speed / SHRED_Stats.BaseSpeed) * 0.1)
                    damage = VecScale(damage, SHRED_Stats.GlobalDamageScale)
                    voxels_removed = MakeHole(shrapnel.pos, damage[1], damage[2], damage[3], true)
                end

                local breaking_multi = math.min(voxels_removed * 1 / 3 + 0.1, 1)
                if SHRED_Stats.DustParticles then
                    SHRED_DustParticle(shrapnel.pos, nil, nil, mat_color)
                    SHRED_DustParticle(shrapnel.pos,
                        AutoVecRescale(VecSub(shrapnel.origin, shrapnel.pos), -5 * breaking_multi), 0.6 * breaking_multi,
                        mat_color)
                end

                if SHRED_Stats.VoxelChunkParticles then
                    for i = 1, breaking_multi do
                        local vel = VecNormalize(VecSub(shrapnel.pos, shrapnel.origin))
                        vel = QuatRotateVec(AutoRandomQuat(lookup.rndangle / 2), vel)
                        vel = VecScale(vel, math.random() * 10 + (shrapnel.speed / SHRED_Stats.BaseSpeed * 10))
                        SHRED_VoxelParticle(shrapnel.pos, vel, math.random() * 2 + 4, mat_color)
                    end
                end

                if math.random() < 0.5 and SHRED_MaterialSoundBank[mat] then
                    PlaySound(SHRED_MaterialSoundBank[mat].small, shrapnel.pos, math.random() * 0.2 + 0.2)
                end

                if lookup.spark then
                    local color = { AutoHSVToRGB(0.02 + shrapnel.random * 0.15, 0.6, 1) }
                    PointLight(shrapnel.pos, color[1], color[2], color[3], shrapnel.speed / SHRED_Stats.BaseSpeed * 0.25)
                end

                if shrapnel.explosive and mat == 'wood' and math.random() < 0.125 then
                    SpawnFire(shrapnel.pos)
                end

                shrapnel.fwd = QuatRotateVec(AutoRandomQuat(lookup.rndangle), shrapnel.fwd)
            end

            for i = 1, math.floor(shrapnel.split) + (math.random() < shrapnel.split % 1 and 1 or 0) do
                SHRED_ShrapnelTable[#SHRED_ShrapnelTable + 1] = SHRED_CreateShrapnel(
                    shrapnel.pos,
                    QuatRotateVec(AutoRandomQuat(lookup.rndangle), shrapnel.fwd),
                    shrapnel.speed * (math.random() < 0.5 and SHRED_Stats.SpeedDiminish or 1),
                    shrapnel.split * SHRED_Stats.SplitDiminish * lookup.splitscale,
                    shrapnel.explosive and math.random() < 0.4
                )
            end
        else
            shrapnel.pos = raycast.intersection
        end

        if raycast.hit or shrapnel.time > SHRED_Stats.DeletionAfterDriftSec or shrapnel.speed < SHRED_Stats.DeletionSpeedThreshhold then
            SHRED_ShrapnelTable[pi] = nil
        end
    end
end

function SHRED_DebugDraw()
    UiAlign('center middle')
	for _, shrapnel in pairs(SHRED_ShrapnelTable) do
		local ui_pos = { UiWorldToPixel(shrapnel.pos) }
		UiPush()
			UiTranslate(ui_pos[1], ui_pos[2])
			AutoUiCircle(16 / ui_pos[3], 2, 8)
		UiPop()
		AutoUIArrowInWorld(shrapnel.pos, AutoVecMove(shrapnel.pos, shrapnel.fwd, 2), 1, 0.5)
	end
end