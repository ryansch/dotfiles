_G.logger = require("logger").new {
  level = "trace",
}

function _G.put(...)
  return logger.debug(...)
end
