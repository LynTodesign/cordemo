local CollisonNode = class("CollisonNode", function() 
	return display.newSprite()
end)

function CollisonNode:addCollision()
	local width, height = self:getBoundingBox().width, self:getBoundingBox().height
	local box = cc.PhysicsBody:createBox({height = height, width = width})
	box:setCategoryBitmask(0x1111)  
   	box:setContactTestBitmask(0x1111)  
   	box:setCollisionBitmask(0)
   	self:setPhysicsBody(box)
end

function CollisonNode:handlerCollision(obj)
	if self.onEnterCollision == nil then
		print("onEnterCollision function must be writed in derived classes")
		return
	end
	self:onEnterCollision(obj)
end

return CollisonNode