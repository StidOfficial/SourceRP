local oldhttpFetch = http.Fetch
local oldhttpPost = http.Post

local Requests = {}

function GM:OnHTTPRequest(method, url)
end

function http.GetRequests()
	return Requests
end

function http.Fetch(url, onsuccess, onfailure)
	Requests[table.Count(Requests)] = {
		method = "GET",
		url = url
	}
	
	if GAMEMODE then
		GAMEMODE:OnHTTPRequest("GET", url)
	end
	
	oldhttpFetch(url, onsuccess, onfailure)
end

function http.Post(url, params, onsuccess, onfailure)
	Requests[table.Count(Requests)] = {
		method = "POST",
		url = url
	}
	
	if GAMEMODE then
		GAMEMODE:OnHTTPRequest("POST", url)
	end
	
	oldhttpPost(url, params, onsuccess, onfailure)
end