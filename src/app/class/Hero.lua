local AliveBaseNode = require("app.class.AliveBaseNode")
local Hero = class("Hero", AliveBaseNode)
local Define = require("app.table.Define")
local LoadManager = require("app.table.LoadManager")
local EventManager = require("app.table.EventManager")
local MapManager = require("app.table.MapManager")
local ParseJson = require("app.table.ParseJson")
local scheduler = require("framework.scheduler")
local COLLIDER_NODE = {
	ENEMY = Define.ENEMY_TAG,
	BULLET = Define.BULLET_TAG
}

function Hero:ctor(section)
	self:setTag(Define.HERO_TAG)
	self:setContentSize({height = 250 * 0.2, width = 100 * 0.2})
	self.moveSpeed = 350
	self.canInjured = true
	self.canShoot = true
	self.spineAnimation = nil
	self.moveDirection = cc.p(120, 120)
	self.state = Define.HERO_STATE.STAND
	self.section = section
	self.direction = Define.DIRECTION.RIGHT  
	self.health = ParseJson.getSectionData(section).heroHealth
	self:loadSpineAnimation()
	self:addCollision()
end

function Hero:onEnterCollision(other)
	if other:getTag() == COLLIDER_NODE.ENEMY then
		self:injured(other)
	end
	if other:getTag() == COLLIDER_NODE.BULLET then
		if other.type ~= Define.NODE_TYPE.ENEMY then
			return 	
		end
		self:injured(other)	
	end
end

function Hero:loadSpriteAndAnimation()
	local png = "image/hero.png"
	local pList = "image/hero.plist" 
	LoadManager.loadSpriteFramesWithFile(png, pList)
	local animation = LoadManager.getAnimation({name = "player_blast_huxi_%04d.png", sIndex = 1, eIndex = 5, frameRate = 17})
	self.standAni = cc.RepeatForever:create(animation)
	self.standAni:retain()
	animation = LoadManager.getAnimation({name = "player_blast_run_%04d.png", sIndex = 1, eIndex = 9, frameRate = 56})
	self.runAni = cc.RepeatForever:create(animation)
	self.runAni:retain()
	self.injuredAni = LoadManager.getAnimation({name = "player_blast_shoushang_%04d.png", sIndex = 1, eIndex = 3, frameRate = 10})
	self.injuredAni:retain()
	self:runAction(cc.RepeatForever:create(self.standAni))
end

function Hero:loadSpineAnimation()
	local json = "spine/spineboy.json"
	local atlas = "spine/spineboy.atlas"
	LoadManager.preLoadBonesAnimation(json, atlas)
	self.spineAnimation = LoadManager.createBonesAnimation('idle', 0, true)
    self.spineAnimation:setScale(0.2)
	self:addChild(self.spineAnimation)
	self.spineAnimation:registerSpineEventHandler(function(event)
		if self.state == Define.HERO_STATE.DEATH then
			EventManager:Dispatch("gameEnd")
			return 
		end
		if self.state ~= Define.HERO_STATE.INJURED then
			return
		end	
		self.spineAnimation:setAnimation(0, 'idle', true)
		self.canShoot = true
		self.state = Define.HERO_STATE.STAND
		local xact = cc.Blink:create(1, 5)
		local xfunc = cc.CallFunc:create(function()
			self.canInjured = true
		end)
		self:runAction(cc.Sequence:create(xact, xfunc))
	end, sp.EventType.ANIMATION_COMPLETE)
end

function Hero:setDirection(pos)
    if self.state == Define.HERO_STATE.INJURED or self.state == Define.HERO_STATE.DEATH then
    	return 
    end
	self.moveDirection = cc.pNormalize(cc.pSub(pos, cc.p(120, 120)))
	if pos.x > 120 and self.direction == Define.DIRECTION.LEFT then
		self:setScaleX(0.8)
		self.direction = Define.DIRECTION.RIGHT
	end

	if pos.x < 120 and self.direction == Define.DIRECTION.RIGHT then
	 	self:setScaleX(-0.8)
	 	self.direction = Define.DIRECTION.LEFT
	end
end


function Hero:onRockerTouchBegan(pos)
	self:setDirection(pos)
	self:run()
end

function Hero:onRockerTouchMoved(pos)
	self:setDirection(pos)
	if self.state == Define.HERO_STATE.INJURED then
		return 
	end
	self:run()
end

function Hero:onRockerTouchEnded()
	self:stop()
end

function Hero:playRunAni()
	if self.state ~= Define.HERO_STATE.STAND then
		return
	end

	self.state = Define.HERO_STATE.RUN
	self.spineAnimation:setAnimation(0, 'run', true)
end

function Hero:playAttackAni()
	if  not self.canShoot then
		return
	end
	local gameLayer = self:getParent()
	self:stop()
	self.spineAnimation:setAnimation(1, 'shoot', false)
	gameLayer:addBullet(self, Define.NODE_TYPE.HERO)
end

function Hero:playInjured()
	if not self.canInjured then
		return
	end
	self.canShoot = false
	self.health = self.health - 1
	EventManager:Dispatch("injured")
	self.canInjured = false

	local posX, scaleX
	if self.direction == Define.DIRECTION.RIGHT then
		posX = -30
		scaleX = 0.8
	end
	if self.direction == Define.DIRECTION.LEFT then
		posX = 30
		scaleX = -0.8
	end

	if MapManager.checkLayerLimit(self:getPositionX() + posX, self:getPositionY()) == 0 then
		posX = 0
	end

	self:setScaleX(scaleX)

	if self.health == 0 then
		self.state = Define.HERO_STATE.DEATH
		self.spineAnimation:setToSetupPose()
		self.spineAnimation:setAnimation(1, 'death', false)
		return	
	end	
	self.state = Define.HERO_STATE.INJURED

	local actMove = cc.MoveBy:create(0.28, cc.p(posX, 0))
	local funcPlayinjured = cc.CallFunc:create(function()
		self.spineAnimation:setToSetupPose()
		self.spineAnimation:setAnimation(1, 'hit', false)
	end)
	self:runAction(cc.Spawn:create(actMove, funcPlayinjured))
end

function Hero:actionStop()
	if self.state ~= Define.HERO_STATE.RUN then
		return 
	end

	self.state = Define.HERO_STATE.STAND
	self.moveDirection = cc.p(120, 120)
	self.spineAnimation:setAnimation(0, 'idle', true)	
end

function Hero:destroy()
    self:removeSelf()
	LoadManager.releaseBoneseAnimation()
end

return Hero