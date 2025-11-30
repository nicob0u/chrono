local Period = {}
Period._index = Period


local json = require("dkjson")
local script_path = arg[0]:match("^(.*[\\/])") or "./"
local filename = script_path .. "work_log.json"


local function load_data()
  local file = io.open(filename, "r")
  local data = { type, time }
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

function Period:Start()
  local start_time = os.date("%H:%M")
  data[today]["Session"] = data[today]["Session"] or {}
  local new_session = { { type = "start", time = start_time } }

  table.insert(data[today]["Session"], new_session)
  save_data(data)
  return start_time
end

function Period:Pause()
  local pause_time = os.date("%H:%M")
  local sessions = data[today]["Session"]
  local last_session = sessions[#sessions]
  if last_session and last_session.type ~= "pause" then
    table.insert(last_session, { { type = "pause", time = pause_time } })
  elseif last_session.type == "pause" then
    print("session already paused.")
  else
    print("no sessions found to pause.")
  end
  save_data(data)
  return pause_time
end

function Period:CalculateDuration()

end

function Period:ConvertToDecimal()
end

return Period
