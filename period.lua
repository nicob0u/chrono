Period = {}
Period._index = Period


function Period:new(start, stop)
local obj = {start, stop}
setmetatable(obj, self)
return obj
end