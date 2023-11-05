Loader = {}

---Leave blank to sove for find itself.
---@param set_mod_id string?
function Loader.Set(set_mod_id)
	if set_mod_id then
		Loader.mod_id = set_mod_id
		Loader.mod_key = AutoKey('mods.available', set_mod_id)
		Loader.mod_data = AutoExpandRegistryKey(Loader.mod_key)
		return
	end

	do
		local stacktrace
		if HasFile('MOD/L') then
			local p = AutoSpawnScript('MOD/L')
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
				Loader.mod_id = full:match("([^%.]+)$")
				Loader.mod_key = full
				Loader.mod_data = AutoExpandRegistryKey(Loader.mod_key)
			end
		end
	end
		
	if not Loader.mod_key then -- Couldn't find from stacktrace 
		-- Will be true if the player is in action level. Otherwise would be false if the player is in UI, as in loaded via `Command('game.startui', 'script.lua')`
		-- For example, This will return false in options.lua
		local is_level = HasKey('game.mod')
	
		if is_level then
			Loader.mod_id = GetString('game.mod')
			Loader.mod_key = 'mods.available.' .. Loader.mod_id
			Loader.mod_data = AutoExpandRegistryKey(Loader.mod_key)
		else
			-- Need to resolve mod Id from main.xml path
			local main_xml = GetString('game.levelpath')
			local path = main_xml:sub(1, -10)
	
			for _, k in pairs(ListKeys('mods.available')) do
				local full = AutoKey('mods.available', k)
				if GetString(AutoKey(full, 'path')) == path then
					Loader.mod_id = k
					Loader.mod_key = full
					Loader.mod_data = AutoExpandRegistryKey(Loader.mod_key)
	
					break
				end
			end
		end
	end
end

Loader.Set()

--------------------------------------------------------------------------------------------------------------------------------

---Converts a path relative to the root mod folder to a RAW: path
---@param relative_path string
---@return string absolute_path Absolute Path
---@return td_path td_path RAW: Path
function Loader.ResolvePath(relative_path)
	local absolute_path = Loader.mod_data.path .. '/' .. relative_path
	local td_path = 'RAW:' .. absolute_path

	-- if not HasFile(td_path) then print(('[LOADER] File [%s] not found'):format(absolute_path)) end

	return absolute_path, td_path
end

local default_env_meta = {
	__index = _G
}

---Relative Path
---@param path string
---@return any
---@return table
---@nodiscard
function Loader.File(path, default_search_path, inherit_env)
	local absolute_path, td_path = Loader.ResolvePath(path)
	if not HasFile(td_path) then absolute_path, td_path = Loader.ResolvePath((default_search_path or '') .. path) end
	
	local success, f, error_object = pcall(loadfile, absolute_path)

	if success and f then
		local env = inherit_env or {}
		setmetatable(env, default_env_meta)

		setfenv(f, env)
		return f(), env
	else
		print(('[LOADER] Error : [relative path] %s : [absolute_path] %s : [Error on next line ]\n%s'):format(path, absolute_path, error_object))
		return nil, nil
	end
end