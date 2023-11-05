--[[
#include scripts/libraries/Automatic.lua
#include scripts/libraries/loader.lua
]]

local reload_times = 0

local function rawcall(t, k, ...)
    if t then
        local raw = rawget(t, k)
        if raw then
            local s, r = pcall(raw, ...)
            if not s then print(r) end
            return r
        end
    end
end

function init( ... )
    _, F = Loader.File 'scripts/F.lua'
    rawcall(F, 'init', reload_times > 0, ... )
end

function handleCommand( ... )
    rawcall(F, 'handleCommand', ... )
end

function tick( ... )
    if InputPressed 'f1' then
        reload_times = reload_times + 1
        print(string.format('[%s Reloaded] : [Script Id %s] : [Reload %s]', Loader.mod_id, GetScriptId(), reload_times))

        rawcall(F, 'reload', reload_times)
        init()
        
        return
    end

    rawcall(F, 'tick', ... )
end

function update( ... )
    rawcall(F, 'update', ... )
end

function draw( ... )
    rawcall(F, 'draw', ... )
end