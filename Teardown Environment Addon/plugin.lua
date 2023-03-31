function OnSetText(uri, text)
    local diffs = {}
    for startp, line, endp in ("\r\n" .. text):gmatch("\r?\n()(#include[^\r\n]+)()") do
        diffs[#diffs + 1] = {
            start = startp - 2,
            finish = endp - 3,
            text = "--" .. line
        }
    end
    return diffs
end