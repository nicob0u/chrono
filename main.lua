
local json = require("dkjson")
local filename = "work_log.json"


local file = io.open("filename", "r")
local data = {}
if file then 
  local content = file:read("*a")

data = json.decode(content) or {}
file:close()
end

local today = os.date("%Y-%m-%d")
data[today] = data[today] or {}

local start_time = os.date("%H:%M")
if type(data[today]) ~= "table" then
    data[today] = {}
end
table.insert(data[today], {start = start_time})

file = io.open(filename, "w")
file:write(json.encode(data, {indent = true}))
file:close()

print("Start time recorded:", start_time)
