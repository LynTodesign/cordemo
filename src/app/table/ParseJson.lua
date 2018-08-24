local ParseJson = {}

function ParseJson.checkClearWithJson(name)
	local jsonPath = cc.FileUtils:getInstance():fullPathForFilename("function.json")
	local file = io.open(jsonPath, "r")
	local content = file:read("*all")
	file.close()
	
	local cjson = json.decode(content)
	return cjson[name].isClear
end

function ParseJson.getSectionData(section)
	local jsonFile = cc.FileUtils:getInstance():fullPathForFilename("section.json")
 	local file = io.open(jsonFile, "r")
 	local content  = file:read("*all")
 	file:close()
 	
    local cjson = json.decode(content)
    local sectionDate = cjson["section"]
    local index = section
    local data = sectionDate[index] 
    return data
end

function ParseJson.setSectionClear(section)
	local jsonFile = cc.FileUtils:getInstance():fullPathForFilename("function.json")
	local file = io.open(jsonFile, "r")
 	local content  = file:read("*all")
 	local cjson = json.decode(content)
 	local name = "section" .. section
 	cjson[name].isClear = true

 	local json = json.encode(cjson)
 	file = io.open(jsonFile, "w")
 	file:write(json)
 	file:flush()
 	file:close()
end

function ParseJson.getSectionNumber()
	local jsonFile = cc.FileUtils:getInstance():fullPathForFilename("section.json")
 	local file = io.open(jsonFile, "r")
 	local content  = file:read("*all")
 	file:close()
 	
    local cjson = json.decode(content)
    return #cjson["section"]
end

return ParseJson