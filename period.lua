local Period = {}
Period._index = Period


local json = require("dkjson")
local script_path = arg[0]:match("^(.*[\\/])") or "./"
local filename = script_path .. "work_log.json"


local function load_data()
  local file = io.open(filename, "r")
  local data = {}
  if file then
    local content = file:read("*a")

    data = json.decode(content) or {}
    file:close()
  end
  return data
end

local function save_data(data)
  local file = io.open(filename, "w")
  if not file then
    print("failed to find work_log.json")
  end
  print("Saving to:", filename)
  print("Full path:", io.popen("cd"):read("*l"))

  file:write(json.encode(data, { indent = true }))
  file:close()
end


local data = load_data()
local today = os.date("%Y-%m-%d")
data[today] = data[today] or {}


function Period:new(start, stop)
  local obj = { start, stop }
  setmetatable(obj, self)
  return obj
end

function Period:CommandTest()
  print("This is a CLI test.")
end

function Period:Start()
  local start_time = os.date("%H:%M")
  table.insert(data[today], { start = start_time, pause = nil })
  save_data(data)
  return start_time
end

function Period:Pause()
  local pause_time = os.date("%H:%M")

  local last_session = data[today][#data[today]]
  if last_session ~= nil and last_session.pause == nil then
    last_session.pause = pause_time
  else
    table.insert(data[today], { start = nil, pause = pause_time })
  end
  save_data(data)
  return pause_time
end

function Period:CalculateDuration(start, stop)
  local duration = start - stop
  print(duration)
  return duration
end

function Period:ConvertToDecimal()
end

return Period
