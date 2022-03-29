local ok, _ = pcall(require, "titan.global")
if not ok then
	print("Unable to require titan.global")
end

local packer_bootstrap = require("user.packer-bootstrap")
local user_packer_config = require("user.packer-config").config()
packer_bootstrap.startup(user_packer_config)

local titan = require("titan")
titan.setup{}

local user = require("user")
user.setup{}
