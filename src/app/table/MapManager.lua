local MapManager = {}
MapManager.curMap = nil
MapManager.curSection = nil

function MapManager.loadTileMap(section)
	local mapname = string.format("tiledmap/bgmap_%1d.tmx", section);
	local tiledMap = cc.TMXTiledMap:create(mapname)
	MapManager.curSection = section
	MapManager.curMap = tiledMap
	return tiledMap
end

function MapManager.checkLayerLimit(posX, posY)
	if MapManager.curMap == nil then
		error(MapManager.curSection .. " map has not loaded!")
	end

	local tiledMap = MapManager.curMap

	local tile, map = tiledMap:getTileSize(), tiledMap:getMapSize()
	local x = math.floor(posX / tile.width)	
	local y = math.floor((tile.height * map.height - posY) / tile.height)

	if x <= 0 or x >= map.width then
		return 0 
	end
	if y <= 0 or y >= map.height then
		return 0
	end

	local mapLayer = tiledMap:getLayer("map")
	local gid = mapLayer:getTileGIDAt(cc.p(x, y)) 
	return gid
end

function MapManager.releaseMap(tiledMap)
	MapManager.curMap = nil
	MapManager.curMap = nil
	-- tiledMap:release() 
end

return MapManager