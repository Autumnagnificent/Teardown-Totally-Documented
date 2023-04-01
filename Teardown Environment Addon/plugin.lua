function OnSetText(uri, text)
    local diffs = {}
    -- local diffs = { { start = 1, finish = 0, text = "" } } -- Avoid the first line not getting the right syntax highlight

    for start, _, file, finish in ("\n" .. text):gmatch("\n()#include ([\"']?)([^\r\n]*)%2()") do
        -- local path = file:gsub("%.lua$", "")
        
        diffs[#diffs + 1] = {
            start = start - 1,
            finish = finish - 1,
            text = string.format("---Including File \"%s\"", file)
        }

        -- #include \"%s\"
    end
    return diffs
end