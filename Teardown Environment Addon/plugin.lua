local ws = require 'workspace'

function read_file(name)
    local f = io.open(name,"r")
    if f ~= nil then
        local content = f:read("*all")
        f:close()
        return content
    else
        return false
    end
end

function OnSetText(uri, text)
    local diffs = {}
    -- local diffs = { { start = 1, finish = 0, text = "" } } -- Avoid the first line not getting the right syntax highlight

    for start, _, relative_include, finish in ("\n" .. text):gmatch("\n()#include ([\"']?)([^\r\n]*)%2()") do
        local folder_uri = string.match(uri, "(.-)[\\/][^\\/]*$")
        ---@type string
        local file_path = ws.getAbsolutePath(folder_uri, relative_include)
        local formatted_path = string.format("%q", file_path)

        local f = read_file(file_path)
        if f then
            diffs[#diffs + 1] = {
                start = start - 1,
                finish = finish - 1,
                text = string.format('#require %s ---@diagnostic disable-line:exp-in-action, undefined-global', formatted_path)
            }
        else
            diffs[#diffs + 1] = {
                start = start - 1,
                finish = finish - 1,
                text = string.format('-- %s', formatted_path)
            }
        end

        -- #include \"%s\"
    end

    return diffs
end