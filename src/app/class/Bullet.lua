local CollisonNode = require("app.class.CollisonNode")
local Bullet = class("Bullet", CollisonNode)
local Define  = require("app.table.Define")
local COLLIDER_NODE = {
	HERO = Define.HERO_TAG,
	ENEMY = Define.ENEMY_TAG
}

function Bullet:ctor(type)
	self:setTag(Define.BULLET_TAG)
	self.type = type
	self:setScale(0.5)
	self:setTexture("image/efx_4.png")
	self:addCollision()	
end

function Bullet:addCollision()
	local box = cc.PhysicsBody:createCircle(self:getBoundingBox().width / 2)
	box:setCategoryBitmask(0x0111)  
   	box:setContactTestBitmask(0x1111)  
   	box:setCollisionBitmask(0x1001)
   	self:setPhysicsBody(box)
end

function Bullet:onEnterCollision(other)
	if other:getTag() == COLLIDER_NODE.ENEMY then
		if self.type == Define.NODE_TYPE.HERO then
			self:destroy()	
		end
	end
	if other:getTag() == COLLIDER_NODE.HERO then
		if self.type == Define.NODE_TYPE.ENEMY then
			self.srcNode.canShoot = true
			self:destroy()	
		end
	end
end

function Bullet:setDirection(dir)
	self.direction = dir
end

function Bullet:setSrcNode(node)
	self.srcNode = node
end

function Bullet:attack(callBack)
	local posX
	if self.direction == 0 then
		posX = 250
	elseif self.direction == 1 then
		posX = -250		
	end
	local act1 = cc.MoveBy:create(0.5, cc.p(posX, 0))
	local act2 = cc.CallFunc:create(function() 
		self:removeSelf()
		if callBack then
			callBack()
		end
	end)
	self:runAction(cc.Sequence:create(act1, act2))
end

function Bullet:destroy()
	self:performWithDelay(function() self:removeSelf() end, 0.1)
end

return Bullet