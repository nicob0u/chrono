--todo: get exe, tweak outputs, add ascii art
-- bugs: table resetting at midnight, multiple pauses for a start / or pauseless starts.

-- get script dir
local info = debug.getinfo(1, "S")
local script_dir = info.source:match("@(.*[/\\])")

package.path = script_dir .. "?.lua;" .. package.path

local Period = require("period")


local command = arg[1]

if command == "start" then
  print(Period:Start())
elseif command == "pause" then
  print(Period:Pause())
elseif command == "test" then
  Period:CommandTest()
elseif command == "calculate" then
  Period:CalculateDuration()
end
