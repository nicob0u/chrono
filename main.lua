local exe_path = arg[0]:gsub("[^/\\]*$", "")
package.path = exe_path .. "?.lua;" .. exe_path .. "?/init.lua;" .. package.path

package.path = exe_path .. "modules/?.lua;" ..
               exe_path .. "modules/?/init.lua;" ..
               package.path
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
