local Selection = game:GetService("Selection")
local HttpService = game:GetService("HttpService")

local CoreCode = {}

_G.ROSSENTIALS_ToolbarButtonConnections = _G.ROSSENTIALS_ToolbarButtonConnections or {}

CoreCode.version_to_hex = function(version)
	local v = 0
	local partitions = version:split(".")
	
	for _, partition in pairs(partitions) do
		v *= 256
		v += tonumber(partition)
	end
	
	return v
end

local Version = CoreCode.version_to_hex("1.0.3")

CoreCode.has_required_core_version = function(required_version)
	return Version >= required_version
end

CoreCode.create_toolbar = function(me, title)
	assert(me ~= nil)
	assert(title ~= nil)
	
	return me:CreateToolbar(title)
end

CoreCode.create_button = function(toolbar, title, tooltip, icon)
	assert(toolbar ~= nil)
	assert(title ~= nil)
	assert(tooltip ~= nil)
	
	if not icon then
		icon = "rbxassetid://9536700"
	end
	
	local button = toolbar:CreateButton(title, tooltip, icon)
	button.ClickableWhenViewportHidden = true
	return button
end

CoreCode.add_click_event = function(button, callback)
	assert(button ~= nil)
	assert(callback ~= nil)
	
	if _G.ROSSENTIALS_ToolbarButtonConnections[button] ~= nil then
		_G.ROSSENTIALS_ToolbarButtonConnections[button]:Disconnect()
	end
	
	_G.ROSSENTIALS_ToolbarButtonConnections[button] = button.Click:Connect(callback)
end

CoreCode.initialize = function(module)
	table.insert(_G.ROSSENTIALS_DATA.Modules, module)
	module.initialized()
end

CoreCode.getInstanceFullPath = function(inst)
	local partPath = inst:GetFullName()
	local appendStr = "game"

	for _, token in ipairs(partPath:split(".")) do
		if token:match(" ") then
			appendStr = appendStr .. "[\"" .. token .. "\"]"
		else
			appendStr = appendStr .. "." .. token
		end
	end

	return appendStr
end

local toolbar = CoreCode.create_toolbar(plugin, "RossentialsCore")

local unitTest = CoreCode.create_button(toolbar, "Dump info", "Dumps some info about the RossentialsCore plugin.")
CoreCode.add_click_event(unitTest, function()
	print("RossentialsCore version: " .. Version)
	print("Module count: " .. #_G.ROSSENTIALS_DATA.Modules)
end)

local virusDetector = CoreCode.create_button(toolbar, "Virus detector", "Detects scripts that could potentionally be viruses.")
CoreCode.add_click_event(virusDetector, function()
	for _, inst in pairs(Selection:Get()) do
		local dangers = {}
		
		for _, descendant in pairs(inst:GetDescendants()) do
			local dangerLevel = 0
			
			if descendant:IsA("Script") or descendant:IsA("LocalScript") or descendant:IsA("ModuleScript") then
				local src = descendant.Source:lower():gsub(" ", "")
				if src:find("virus") then
					dangerLevel += 1
				end
				
				if src:find("marketplaceservice") then
					dangerLevel += 1
				end
				
				if src:find("httpservice") then
					dangerLevel += 1
				end

				if src:find("lagg") then
					dangerLevel += 1
				end
				
				if src:find("infect") then
					dangerLevel += 1
				end
				
				if src:find("vaccine") then
					dangerLevel += 1
				end
				
				if src:find(".parent=nil") then
					dangerLevel += 1
				end
			end
			
			if dangerLevel > 0 then
				dangers[CoreCode.getInstanceFullPath(descendant)] = dangerLevel
			end
		end
		
		if HttpService:JSONEncode(dangers) ~= "[]" then
			print("Possible viruses found in " .. inst.Name .. "!")
			print(dangers)
		end
	end
end)

_G.ROSSENTIALS_DATA = {
	CoreCode = CoreCode,
	Version = Version,
	Modules = {}
}