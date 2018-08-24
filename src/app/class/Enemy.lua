local AliveBaseNode = require("app.class.AliveBaseNode")
local Enemy = class("Enemy", AliveBaseNode)
local Define = require("app.table.Define")
local EventManager = require("app.table.EventManager")
local scheduler = require("framework.scheduler")
local Bullet = require("app.class.Bullet")
local socket = require("socket")
local COLLIDER_NODE = {
	HERO = Define.HERO_TAG,
	BULLET = Define.BULLET_TAG
}

function Enemy:ctor(canShoot)
	self.canShoot = canShoot
	self.canMove = true
	self.moveSpeed = 150
	self.direction = Define.DIRECTION.LEFT
	self:setScale(0.8)
	self:setScaleX(-0.8)
	self:setTag(Define.ENEMY_TAG)
	self:loadAnimiSprite()
	self:addCollision()
	self.endEvent = EventManager:EventRegister("gameEnd", function() self:destroy() end) 
end

function Enemy:onEnterCollision(other)
	if other:getTag() == COLLIDER_NODE.BULLET then
		if other.type ~= Define.NODE_TYPE.HERO then
			return 
		end
		self:injured()
	end
end

function Enemy:getRandonAni()
	math.randomseed(socket.gettime())
	local keyTable = {}
	keyTable = table.keys(Define.ENEMY_TYPE)
	local ranKey = keyTable[math.random(1, #keyTable)]
	return Define.ENEMY_TYPE[ranKey]
end

function Enemy:changeDir(preX, nextX)
	if nextX > preX and self.direction == Define.DIRECTION.LEFT then
		self.direction = Define.DIRECTION.RIGHT
		self:setScaleX(0.8)
	end

	if nextX < preX and self.direction == Define.DIRECTION.RIGHT then
		self.direction = Define.DIRECTION.LEFT
		self:setScaleX(-0.8)
	end
end

function Enemy:playAttackAni(hero)
	local selfPosX, selfPosY = self:getPositionX(), self:getPositionY()
	local heroPosX, heroPosY = hero:getPositionX(), hero:getPositionY()
	self:changeDir(selfPosX, heroPosX)
	self.moveSpeed = 280
	self.moveDireciton = cc.pNormalize(cc.pSub(cc.p(heroPosX, heroPosY), cc.p(selfPosX, selfPosY)))

	if self.canShoot then
		local gameLayer = self:getParent()
		local mag = cc.pGetDistance(cc.p(selfPosX, selfPosY), cc.p(heroPosX, heroPosY))
		if mag <= 230 then
			self.canShoot = false		
			local callback = function() self.canShoot = true end
			gameLayer:addBullet(self, Define.NODE_TYPE.ENEMY, callback)
		end
	end
end

function Enemy:playInjured()
	self:setPhysicsBody(nil)
	self:setIntervals(nil)
	self:setTexture(self.diedIMG)
	local act = cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(function() self:destroy() end))
	self:runAction(act)
	EventManager:Dispatch("enemyDead")
end

function Enemy:getUpDatePos()
    local x, y = math.random(Define.HERO_XMIN, Define.HERO_XMAX), math.random(Define.HERO_YMIN, Define.HERO_YMAX)
    return x, y
end

function Enemy:upDateEnemyPos()
	if not self.canMove then 
		return 
	end

	local selfPosX, selfPosY = self:getPositionX(), self:getPositionY()
	local ranX, ranY = self:getUpDatePos()
	self:changeDir(selfPosX, ranX)
	self.moveSpeed = 150
	self.moveDireciton = cc.pNormalize(cc.pSub(cc.p(ranX, ranY), cc.p(selfPosX, selfPosY)))
	self.canMove = false
	self.enemyRanX = ranX
	self.enemyRanY = ranY
end

function Enemy:destroy()
	EventManager:removeEventListener(self.endEvent)
	self:removeSelf()
end

function Enemy:loadAnimiSprite() 
	local type = self:getRandonAni()

	if type == Define.ENEMY_TYPE.VAMPIRE then
		self:setTexture("image/hero_show_7_vampire.png")
		self.diedIMG = "image/hero_dead_7_vampire.png"
	end

	if type == Define.ENEMY_TYPE.CAT then
		self:setTexture("image/hero_show_4_cat.png")
		self.diedIMG = "image/hero_dead_4_cat.png"
	end
end

return Enemy