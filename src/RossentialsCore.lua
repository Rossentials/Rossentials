local CoreCode = {}

CoreCode.version_to_hex = function(version)
	local v = 0
	local partitions = version:split(".")
	
	for _, partition in pairs(partitions) do
		v *= 256
		v += tonumber(partition)
	end
	
	return v
end

local Version = CoreCode.version_to_hex("1.0.0")

CoreCode.has_required_core_version = function(required_version)
	return Version >= required_version
end

_G.ROSSENTIALS_DATA = {
	CoreCode = CoreCode,
	Version = Version,
	Modules = {}
}