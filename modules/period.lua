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
  -- print("Saving to:", filename)
  -- print("Full path:", io.popen("cd"):read("*l"))

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
  local sessions = data[today]["Session"]
  local last_session = sessions[#sessions]

  if last_session and #last_session == 1 and last_session[1].type == "start" then
    print("session already started. pause before starting a new session.")
    return start_time
  end
  table.insert(data[today]["Session"], new_session)
  save_data(data)
  return start_time
end

function Period:Pause()
  local last_event = nil
  local pause_time = os.date("%H:%M")
  if not data or not data[today] or not data[today]["Session"] then
    print("no data found specific to this  date. please create a new session.")
    return
  else
    local sessions = data[today]["Session"]
    local last_session = sessions[#sessions]
    if last_session then
      last_event = last_session[#last_session]
    end
    if last_event and last_event.type == "pause" then
      print("session already paused.")
      return pause_time
    end

    table.insert(last_session, { type = "pause", time = pause_time })

    save_data(data)
  end
  return pause_time
end

local function toTimestamp(hhmm)
  local hour, min = hhmm:match("^(%d%d):(%d%d)$")
  return os.time({
    year = os.date("%Y"),
    month = os.date("%m"),
    day = os.date("%d"),
    hour = hour,
    min = min,
    sec = 0,
  })
end

function Period:CalculateDuration()
  if data == nil then
    print("no sessions found.")
    return
  end
  local sum = 0


  print("Date:", today)

  local sessions = data[today]["Session"]
  if sessions then
    for _, session in ipairs(sessions) do
      local start_time_calc
      local pause_time_calc
      for _, event in ipairs(session) do
        if event.type == "start" then
          start_time_calc = toTimestamp(event.time)
        end
        if event.type == "pause" then
          pause_time_calc = toTimestamp(event.time)
        end
      end
      if start_time_calc and pause_time_calc then
        local Start = start_time_calc
        local Pause = pause_time_calc
        local diff = os.difftime(Pause, Start)
        -- print("diff ", diff)
        sum = sum + diff
      else
        print("session has missing data.")
      end
    end
    -- print("sum printed ", sum)
  end
  print(Period:ConvertToDecimal(sum))
end

function Period:ConvertToDecimal(seconds)
  return seconds / 3600
end

function Period:ClearLog()
  local file = io.open(filename, "w")
  if file == nil then
    print("log not found.")
    return
  end
  file:write("{}")
  file:close()
  print("log cleared.")
end

return Period
