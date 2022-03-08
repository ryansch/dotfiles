local ok, _ = pcall(require, "titan.global")
if not ok then
	print("Unable to require titan.global")
end

local user_packer_config = require("user.packer-config").config()

local packer_bootstrap = require("user.packer-bootstrap")
packer_bootstrap.startup(user_packer_config)

local titan = require("titan")
titan.setup{}
