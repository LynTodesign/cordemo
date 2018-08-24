local Rocker = class("Rocker", function() 
		return display.newNode()
end)
local Define = require("app.table.Define")
local ROC_START_POINT = cc.p(120, 120)


function Rocker:ctor()
	self:size(230, 230)
	display.newSprite("image/battle_rocker_bottom.png")
		:setPosition(ROC_START_POINT)
		:addTo(self)
	self.roc = display.newSprite("image/battle_rocker_normal.png")
		:setPosition(ROC_START_POINT)
	self:addChild(self.roc)
end

function Rocker:registerListen(obj)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		local pos = self:getPosInThisLayer(event)
		if event.name == "began" then
			self.roc:pos(pos.x, pos.y)
			obj:onRockerTouchBegan(cc.p(pos.x, pos.y))
			return true
		end

		if event.name == "moved" then 
			self.roc:pos(pos.x, pos.y) 
			obj:onRockerTouchMoved(cc.p(pos.x, pos.y))
		end	

		if event.name == "ended" then
			self.roc:pos(120, 120)
			obj:onRockerTouchEnded(cc.p(pos.x, pos.y))
		end	
	end)
	self:setTouchEnabled(true)
end

function Rocker:getPosInThisLayer(pos)
	local WorldPos = self:convertToWorldSpace(cc.p(0, 0))
	local rpos = cc.p(pos.x - WorldPos.x, pos.y - WorldPos.y)
	local mag = cc.pGetDistance(rpos, ROC_START_POINT)
	if  mag > 100 then
		rpos = cc.pNormalize(cc.pSub(rpos, ROC_START_POINT))
		local mult = cc.pMul(rpos, 100)
		rpos = cc.pAdd(ROC_START_POINT, mult)
	end
	if mag == 0 then
		rpos.x, rpos.y = ROC_START_POINT.x, ROC_START_POINT.y
	end
	return rpos
end

return Rocker