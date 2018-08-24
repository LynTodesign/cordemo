local CollisonNode = require("app.class.CollisonNode")
local AliveBaseNode = class("AliveBaseNode", CollisonNode)
local Define = require("app.table.Define")

function AliveBaseNode:ctor()
	self.moveSpeed = 350
end

function AliveBaseNode:run()
	if self.playRunAni == nil then
		error("alive child class must have handle run method")
	end

	self:playRunAni()				
end

function AliveBaseNode:attack(node)
	if self.playAttackAni == nil then
		error("alive child class must have handle attack method")
	end

	self:playAttackAni(node)
end

function AliveBaseNode:injured(node)
	if self.playInjured == nil then
		error("alive child class must have handle injured method")
	end

	if node then
		local selfPosX = self:getPositionX()
		local hurtPosX = node:getPositionX()
		if selfPosX > hurtPosX then
			self.direction = Define.DIRECTION.LEFT
		else
			self.direction = Define.DIRECTION.RIGHT
		end
	end
	self:playInjured()
end

function AliveBaseNode:stop()
	self:actionStop()
end

function AliveBaseNode:setIntervals(func)
	if func == nil then
		self:unscheduleUpdate()
		return 
	end
	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
		func(dt)
	end)
	self:scheduleUpdate()
end

return AliveBaseNode