local GameLayer = class("GameLayer", function()
		return display.newLayer()
end)
local Bullet = require("app.class.Bullet")
local Hero = require("app.class.Hero")
local Enemy = require("app.class.Enemy")
local ParseJson = require("app.table.ParseJson")
local EventManager = require("app.table.EventManager")
local MapManager = require("app.table.MapManager")

function GameLayer:ctor(section)
	self.section = section
	self.enemyCount = 0
	local data = ParseJson.getSectionData(self.section)
	self.initHeroX = data.heroPosition.x
	self.initHeroY = data.heroPosition.y
	local enemyPos = data.enemyPositon
	local enemyCanShoot = data.enemyCanShoot
	self:initGameWithSection()
	self.hero = Hero.new(self.section)
				:pos(self.initHeroX, self.initHeroY)
	self:addChild(self.hero, 2) 
	self:addEnemy(enemyPos, enemyCanShoot)
	EventManager:EventRegister("completed", function()
		self:preLoadComplete()
	end)
	EventManager:EventRegister("enemyDead", function()
		self:enemyDead()
	end)
	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt) 
		self:upDateGameLayer(dt)
	end)
	self:scheduleUpdate()
	local pos = self.hero:convertToWorldSpace(display.zeroPoint)
	local offsetX, offsetY = pos.x - self.initHeroX, pos.y - self.initHeroY
	self.hero.spineAnimation:pos(offsetX, offsetY)
end

function GameLayer:initGameWithSection()
	self.tiledMap = MapManager.loadTileMap(self.section)
	self:addChild(self.tiledMap)
	local mapProp = self.tiledMap:getLayer("map"):getProperties()
	local yMax, yMin = mapProp["heightMax"], mapProp["heightMin"]
	Define.HERO_YMAX = yMax * self.tiledMap:getTileSize().height
	Define.HERO_YMIN = yMin * self.tiledMap:getTileSize().height
	Define.HERO_XMIN = self.tiledMap:getTileSize().width / 2
	Define.HERO_XMAX = self.tiledMap:getMapSize().width * self.tiledMap:getTileSize().width
	self.moveMinX = -(Define.HERO_XMAX - display.width)
end

function GameLayer:addEnemy(posArr, canShoot)
	self.enemyCount = #posArr
	self.enemyArr = {}
	for k, v in pairs(posArr) do
		local posX, posY = v.x, v.y
		local enemy = Enemy.new(canShoot)
					  :pos(posX, posY)
					  :addTo(self)
		table.insert(self.enemyArr, enemy)			
		-- self:registerEnemyUpDateFuc(enemy)
	end
end

function GameLayer:enemyDead()
	self.enemyCount = self.enemyCount - 1
	if self.enemyCount == 0 then
		EventManager:Dispatch("gameClear")
		ParseJson.setSectionClear(self.section)
	end
end

-- @param node witch node shoot the bullet
-- @param type bullet type enemy or hero
-- @param callback function
function GameLayer:addBullet(node, type, callback)
	local posX, posY = node:getPositionX(), node:getPositionY()
	local bullet = Bullet.new(type)
	local offSetY = 0
	if type == Define.NODE_TYPE.HERO then
		offSetY = 25
	end
	if type == Define.NODE_TYPE.ENEMY then
		offSetY = -10
	end
	bullet:pos(posX, posY + offSetY)
	bullet:setDirection(node.direction)
	bullet:setSrcNode(node)
	self.tiledMap:addChild(bullet, 2)
	bullet:attack(callback)
end

function GameLayer:registerEnemyUpDateFuc(target)
	local frameFunc = function(dt) 
		local posX, posY = target:getPosition()
		local heroPos = cc.p(self.hero:getPositionX(), self.hero:getPositionY())
		local mag = cc.pGetDistance(cc.p(posX, posY), heroPos)

		if mag < 250 and mag > 10 and self.hero.canInjured then
			target:attack(self.hero)
			local movePos = cc.pAdd(cc.p(target:getPositionX(), target:getPositionY()), cc.pMul(target.moveDireciton, dt * target.moveSpeed))
			if  MapManager.checkLayerLimit(movePos.x, movePos.y) == 0 then
				return 
			end 
			target:setPosition(movePos)

		elseif mag > 250 or not self.hero.canInjured then
			target:upDateEnemyPos()
			local movePos = cc.pAdd(cc.p(target:getPositionX(), target:getPositionY()), cc.pMul(target.moveDireciton, dt * target.moveSpeed))
			if MapManager.checkLayerLimit(movePos.x, movePos.y) == 0 then
				target.canMove = true
				return 
			end
			local selfX, selfY = target:getPosition()
			if target.enemyRanX == selfX and target.enemyRanY == selfY then
				target.canMove = true
				return 
			end
			target:setPosition(movePos) 			
		end  	
	end

	target:setIntervals(frameFunc)
end

function GameLayer:registerHeroUpDateFuc(target)
	local frameFunc = function(dt)
		if target.state == Define.HERO_STATE.RUN then
			local x, y = target:getPosition()
			local movePos = cc.pAdd(cc.p(x, y), cc.pMul(target.moveDirection, dt * target.moveSpeed))
			if MapManager.checkLayerLimit(movePos.x, movePos.y) ~= 0 then
				target:setPosition(movePos)
			end
		end
	end

	target:setIntervals(frameFunc)

function GameLayer:preLoadComplete()
	for k, v in pairs(self.enemyArr) do
		self:registerEnemyUpDateFuc(v)
	end
	self:registerHeroUpDateFuc(self.hero)
	self.enemyArr = nil
end

function GameLayer:upDateGameLayer()
	local heroX, layerX = self.hero:getPositionX(), self:getPositionX()
	local nextMove = -(heroX - self.initHeroX - Define.HERO_WIDTH) * 0.75
	if nextMove > self.moveMinX and nextMove < 0 then
		self:setPositionX(nextMove)
	end
end

return GameLayer