console = {}
console.info = {}
console.error = {}

function console.GetInfo()
	return console.info
end

function console.GetError()
	return console.error
end

function GM:OnConsolePrint(text, file, line)
end

function GM:OnConsolePrintError(text, file, line)
end

local oldprint = oldprint or print
function print(...)
	local debuginfo = debug.getinfo(2, "Sl")
	local args = {...}
	
	local infotext = ""
	for k, v in pairs(args) do
		infotext = infotext..tostring(v).."\t"
	end
	
	if GAMEMODE then
		GAMEMODE:OnConsolePrint(infotext, debuginfo.short_src, debuginfo.currentline)
	end
	
	console.info[table.Count(console.info)] = {
		text = infotext,
		file = debuginfo.short_src,
		line = debuginfo.currentline
	}
	
	oldprint(...)
end

local olderror = olderror or error
function exerror(message, errorLevel)
	local debuginfo = debug.getinfo(2, "Sln")
	
	local errortext = "[ERROR] "
	if errorLevel == nil or errorLevel == 1 then
		errortext = errortext..debuginfo.short_src..":"..debuginfo.currentline..": "
	end
	errortext = errortext..message.."\n"
	
	local space = "  "
	local level = 2
	while true do
		local info = debug.getinfo(level, "Sln")
		if (!info) then break end
		
		errortext = errortext..space..level..". "..(info.name == nil and "unknown" or info.name).." - "..info.short_src..":"..info.currentline.."\n"
		space = space.." "		
		level = level + 1
	end
	errortext = errortext.."\n"
	
	if GAMEMODE then
		GAMEMODE:OnConsolePrintError(errortext, debuginfo.short_src, debuginfo.currentline)
	end
	
	console.error[table.Count(console.error)] = {
		text = errortext,
		file = debuginfo.short_src,
		line = debuginfo.currentline
	}
	
	--olderror(message, errorLevel)
end

local oldError = oldError or Error
function Error(...)
	local debuginfo = debug.getinfo(2, "Sl")
	local args = {...}
	
	local errortext = ""
	for k, v in pairs(args) do
		errortext = errortext..tostring(v).."\t"
	end
	
	if GAMEMODE then
		GAMEMODE:OnConsolePrintError(errortext, debuginfo.short_src, debuginfo.currentline)
	end
	
	console.error[table.Count(console.error)] = {
		text = errortext,
		file = debuginfo.short_src,
		line = debuginfo.currentline
	}
	
	oldError(...)
end

local oldErrorNoHalt = oldErrorNoHalt or ErrorNoHalt
function ErrorNoHalt(...)
	local debuginfo = debug.getinfo(2, "Sl")
	local args = {...}
	
	local errortext = ""
	for k, v in pairs(args) do
		errortext = errortext..tostring(v).."\t"
	end
	
	if GAMEMODE then
		GAMEMODE:OnConsolePrintError(errortext, debuginfo.short_src, debuginfo.currentline)
	end
	
	console.error[table.Count(console.error)] = {
		text = errortext,
		file = debuginfo.short_src,
		line = debuginfo.currentline
	}
	
	oldErrorNoHalt(...)
end

if CLIENT then return end
local oldPrintMessage = oldPrintMessage or PrintMessage
function PrintMessage(type, message)
	local debuginfo = debug.getinfo(2, "Sl")
	if type != HUD_PRINTCENTER then
		if GAMEMODE then
			GAMEMODE:OnConsolePrint(message, debuginfo.short_src, debuginfo.currentline)
		end
	
		console.info[table.Count(console.info)] = {
			text = message,
			file = debuginfo.short_src,
			line = debuginfo.currentline
		}
		
		oldPrintMessage(type, message)
	else
		oldPrintMessage(type, message)
	end
end