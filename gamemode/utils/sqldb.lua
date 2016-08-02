SqlDB = {}

local SQLTypeSupported = {
	["SQLite"] = {
		"DebugMode"
	}
}

function SqlDB.Initialize()
	for k,v in pairs(SQLTypeSupported[GAMEMODE.SQL.Type]) do
		if !GAMEMODE.SQL[v] then
			error("[SqlDB] "..v.." not found !")
		end
	end

	if SQLTypeSupported[GAMEMODE.SQL.Type] then
		print("[SqlDB] Initialize on "..GAMEMODE.SQL.Type)
	else
		error("[SqlDB] "..GAMEMODE.SQL.Type.." is not supported by SqlDB")
	end
end

function SqlDB.Query(sqlquery)
	if GAMEMODE.SQL.DebugMode > 5 then
		print("[SqlDB] "..sqlquery)
	end

	if GAMEMODE.SQL.Type == "SQLite" then
		return sql.Query(sqlquery)
	end

	return
end