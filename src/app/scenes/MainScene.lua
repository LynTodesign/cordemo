--game main menu scnene
local MainScene = class("MainScene", function()
    	return display.newScene("MainScene")
end)
local Hero = require("app.class.Hero")
local GameScene = require("app.scenes.GameScene")
local Define = require("app.table.Define")
local ParseJson = require("app.table.ParseJson")


function MainScene:ctor()
	display.newSprite("image/lyBG8.png")
		:pos(display.cx, display.cy)
		:addTo(self)
	display.newSprite("image/hero_head_16_blast.png")
		:setScale(1.5)
		:pos(display.cx - 50, display.cy + 230)
		:addTo(self)
	local move1 = cc.MoveBy:create(0.5, cc.p(0, 10))
	local move2 = cc.MoveBy:create(0.5, cc.p(0, -10))
	local SequenceAction = cc.Sequence:create(move1, move2)
	display.newSprite("image/title.png")
	    :setScale(0.6)
	    :addTo(self)
	    :pos(display.cx - 40, display.cy + 90)
	    :runAction(cc.RepeatForever:create(SequenceAction))
	    
	local selectLabel = ccui.Text:create("Select Section", "font/BPreplay.ttf", 40)
	selectLabel:pos(display.cx + selectLabel:getContentSize().width, display.cy - 200)
	selectLabel:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) 
		if event.name == "began" then
			app:enterScene("SelectSectionScene", "fade", 0.5, cc.c3b(0, 0, 0))
		end
	end)
	selectLabel:setTouchEnabled(true)
	self:addChild(selectLabel)

    local btnStart = ccui.Button:create("image/start1.png", "image/start2.png", 0)
    							:pos(display.cx - 40, display.cy - 100)
    self:addChild(btnStart)
    btnStart:addTouchEventListener(function(sender, eventType) 
    	if eventType == 0 then
    		local entSection = 1
    		for i = 1, Define.SECTION_NUM do
    			local name = "section" .. i
    			if not ParseJson.checkClearWithJson(name) then
    				entSection = i
    				break
    			end
    		end
    		self:gameStart(entSection)
    	end
    end)
end

function MainScene:gameStart(section)
	local gameScene = GameScene.new(section)
	display.replaceScene(gameScene, "fade", 0.5, cc.c3b(0, 0, 0))
end

return MainScene