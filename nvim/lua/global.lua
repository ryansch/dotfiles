_G.logger = require("logger").new {
  level = "info",
}

function _G.put(...)
  return logger.debug(...)
end
