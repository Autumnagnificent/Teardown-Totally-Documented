do -- Adapted from UMF
    do
        local stacktrace
        if HasFile('MOD/_') then
            local p = AutoSpawnScript('MOD/_')
            stacktrace = GetTagValue(p, 'stacktrace')
            Delete(p)
        else
            stacktrace = AutoGetStackTrace()
        end
        
        local mod_name = stacktrace:match("^(.-)/[^/]*$"):match(".*/([^/]+)$")
        
        for _, id in pairs(ListKeys('mods.available')) do
            local full = AutoKey('mods.available', id)
            local directory = GetString(AutoKey(full, 'path')):match(".*/([^/]+)$")
            if directory == mod_name then
                Mod_Id = full:match("([^%.]+)$")
                Mod_Key = full
                Mod_Data = AutoExpandRegistryKey(Mod_Key)
            end
        end
    end
        
    if not Mod_Key then -- Couldn't find from stacktrace 
        -- Will be true if the player is in action level. Otherwise would be false if the player is in UI, as in loaded via `Command('game.startui', 'script.lua')`
        -- For example, This will return false in options.lua
        local is_level = HasKey('game.mod')
    
        if is_level then
            Mod_Id = GetString('game.mod')
            Mod_Key = 'mods.available.' .. Mod_Id
            Mod_Data = AutoExpandRegistryKey(Mod_Key)
        else
            -- Need to resolve mod Id from main.xml path
            local main_xml = GetString('game.levelpath')
            local path = main_xml:sub(1, -10)
    
            for _, k in pairs(ListKeys('mods.available')) do
                local full = AutoKey('mods.available', k)
                if GetString(AutoKey(full, 'path')) == path then
                    Mod_Id = k
                    Mod_Key = full
                    Mod_Data = AutoExpandRegistryKey(Mod_Key)
    
                    break
                end
            end
        end
    end
end

--------------------------------------------------------------------------------------------------------------------------------

---Converts a path relative to the root mod folder to a RAW: path
---@param relative_path string
---@return string absolute_path Absolute Path
---@return td_path td_path RAW: Path
function Serve_ResolvePath(relative_path)
    local absolute_path = Mod_Data.path .. '/' .. relative_path
    local td_path = 'RAW:' .. absolute_path

    if not HasFile(td_path) then print(('File [%s] not found'):format(absolute_path)) end

    return absolute_path, td_path
end

local environment_metatable = {
    __index = function (self, key)
        return _G[key]
    end
}

---Relative Path
---@param path string
---@return any
---@return table
---@nodiscard
function Serve_File(path, inherit_env)
    local absolute_path = Serve_ResolvePath(path)
    local success, f = pcall(loadfile, absolute_path)

    if success and f then
        local env = inherit_env or {}
        env.metadata = {
            path = path,
            loadtime = GetTime(),
            hot_reloaded = false,
        }

        setmetatable(env, environment_metatable)

        setfenv(f, env)
        return f(), env
    else
        print(('[SERVE] Error : [relative path] %s : [absolute_path] %s'):format(path, absolute_path))
        return nil, nil
    end
end

function Serve_Reload(env)
    local new = Serve_File(env.metadata.path)

    new.metadata = env.metadata
    new.metadata.hot_reloaded = true
    new.metadata.loadtime = GetTime()

    local reload_f = rawget(env, 'reload')
    if reload_f then reload_f() end
    
    AutoTableMerge(env, new)

    local init_f = rawget(env, 'init')
    if init_f then init_f() end
end

--------------------------------------------------------------------------------------------------------------------------------

--- Real simple way, shouldn't be used.
function PirateDetection()
    AutoInspectWatch(Mod_Data)

    if Mod_Data['local'] == '1' then
        return false
    elseif Mod_Data.steamtime ~= '0' then
        return false
    else
        return true
    end
end