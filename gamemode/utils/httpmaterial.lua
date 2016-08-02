local HTTPMaterialList = {}

if !file.Exists("httpmaterials", "DATA") then
	file.CreateDir("httpmaterials")
end


function HTTPMaterial(httpmaterial, pngParameters)
	local CRC = util.CRC(httpmaterial)
	HTTPMaterialList[CRC] = {
		FilePath = "httpmaterials/"..CRC..".png",
		FileDownloaded = false,
		MaterialParameters = pngParameters
	}
	local HTTPMaterial = HTTPMaterialList[CRC]
	
	if !file.Exists(HTTPMaterial.FilePath, "DATA") then
		http.Fetch(httpmaterial, function(body, len, headers, code)
				file.Write(HTTPMaterial.FilePath, body)
				HTTPMaterial.FileDownloaded = true
			end,
			function (err)
				print("HTTPMaterialErrror ["..httpmaterial.."] "..err)
			end
		)
	else
		HTTPMaterial.FileDownloaded = true
	end
	
	function HTTPMaterial:GetMaterial()
		if HTTPMaterial.FileDownloaded && !HTTPMaterial.Material then
			HTTPMaterial.Material = Material("../data/"..HTTPMaterial.FilePath, HTTPMaterial.MaterialParameters)
		end
		
		return HTTPMaterial.Material
	end
	
	return HTTPMaterial
end