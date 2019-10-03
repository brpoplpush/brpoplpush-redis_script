local function redis_version()
  local serverinfo = redis.call("INFO", "SERVER")
  local _, _, maj, min, pat = string.find(serverinfo, "redis_version%:(%d+)%.(%d+)%.(%d+)")
  return {
    ["version"] = maj .. "." .. min .. "." .. pat,
    ["major"]   = tonumber(maj),
    ["minor"]   = tonumber(min),
    ["patch"]   = tonumber(pat)
  }
end

local function toboolean(val)
  val = tostring(val)
  return val == "1" or val == "true"
end

local function log_debug( ... )
  if debug_lua ~= true then return end

  local result = ""
  for _,v in ipairs(arg) do
    result = result .. " " .. tostring(v)
  end
  redis.log(redis.LOG_DEBUG, script_name .. " -" ..  result)
end

