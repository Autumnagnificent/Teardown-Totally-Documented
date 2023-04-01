function OnSetText(uri, text)
    local diffs = {{start=1,finish=1,text="\n"}} -- Avoid the first line not getting the right syntax highlight
    for startp, _, file, endp in ("\n" .. text):gmatch("\n()#include *([\"'])([^\r\n]+)%2()") do
        diffs[#diffs + 1] = {
            start = startp - 1,
            finish = endp - 2,
            text = string.format("---@module \"%s\"", file:gsub("%.lua$", ""))
        }
    end
    return diffs
end