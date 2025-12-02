local exe_path = arg[0]:gsub("[^/\\]*$", "")
package.path = exe_path .. "?.lua;" .. exe_path .. "?/init.lua;" .. package.path

-- get script dir
local info = debug.getinfo(1, "S")
local script_dir

if info.source:sub(1, 1) == "@" then
  script_dir = info.source:match("@(.*[/\\])")
else
  script_dir = ""
end


package.path = script_dir .. "?.lua;" .. package.path

local Period = require("period")

local command = arg[1]

if command == "start" then
  print(Period:Start())
elseif command == "pause" then
  print(Period:Pause())
elseif command == "calculate" then
  Period:CalculateDuration()
elseif command == nil then
  print([[ welcome to chrono! :3
 the following commands are available:
  > start
  > pause
  > calculate
  ]])
end
