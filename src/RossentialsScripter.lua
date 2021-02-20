local initialTime = os.time()

repeat
	wait()
until os.time() - initialTime > 10 or _G.ROSSENTIALS_DATA

REQUIRED_VERSION = "1.0.0"

if not _G.ROSSENTIALS_DATA then
	print("RossentialsScripter: RossentialsCore not found, please make sure this plugin is installed and enabled.")
elseif not _G.ROSSENTIALS_DATA.CoreCode.has_required_core_version(_G.ROSSENTIALS_DATA.CoreCode.version_to_hex(REQUIRED_VERSION)) then
	print("RossentialsScripter: Unsupported version of RossentialsCore was found, please update RossentialsCore.")
else
	----------------------------
	----------------------------
	
	print("RossentialsScripter: Initialized")
	
	----------------------------
	----------------------------
end