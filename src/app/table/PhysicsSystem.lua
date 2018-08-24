local PhysicsSystem = {}
local Define = require("app.table.Define")

function PhysicsSystem.registerContactHandler()
	if PhysicsSystem.contactListener then
		return 
	end

	PhysicsSystem.contactListener = cc.EventListenerPhysicsContact:create()
	PhysicsSystem.contactListener:registerScriptHandler(function(contact)
		local node1 = contact:getShapeA():getBody():getNode() 	 
		local node2 = contact:getShapeB():getBody():getNode() 
		if node1 == nil or node2 == nil then
			return 
		end
		node1:handlerCollision(node2)
		node2:handlerCollision(node1)					
	end, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
	cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(PhysicsSystem.contactListener, 1)
end

return PhysicsSystem 