local EndScene = class('EndScene', function() 
		return display.newScene("EndScene")
end)
local Define = require("app.table.Define")
local LoadManager = require("app.table.LoadManager")

function EndScene:ctor(section)

	self.section = section

	local spBG = display.newSprite("image/lyBG8.png")
	LoadManager.preLoadBonesAnimation("spine/spineboy.json", "spine/spineboy.atlas")
	local spHero = LoadManager.createBonesAnimation("death", 1, false)
	spHero:setScale(0.2)
	spBG:pos(display.cx, display.cy)
	self:addChild(spBG)

	spHero:pos(display.cx, display.cy - 50)
	self:addChild(spHero)

	local sequenceAction = cc.Sequence:create(cc.MoveBy:create(0.5, cc.p(0, 10)), cc.MoveBy:create(0.5, cc.p(0, -10)))
	local spLose = display.newSprite("image/lose.png")
	spLose:pos(display.cx, display.cy + 80)
	spLose:runAction(cc.RepeatForever:create(sequenceAction))
	self:addChild(spLose)

	local btnBox = display.newSprite("image/img_power_2_box_0.99.png")
				   :pos(display.cx, display.cy - 180)
				   :setScaleY(1.2)
	self:addChild(btnBox)

	
	local layout = ccui.Layout:create()
				   :pos(display.cx, display.cy)
	layout:setLayoutType(ccui.LayoutType.VERTICAL)
	self:addChild(layout)
	self.btnMain = self:createTextButton("Main Menu")		  	
	local lp1 = ccui.LinearLayoutParameter:create()			 
	self.btnMain:setLayoutParameter(lp1)
	lp1:setGravity(ccui.LinearGravity.centerHorizontal)
	lp1:setMargin({ left = 0, top = 50, right = 0, bottom = 10 })
	self.btnMain:addTouchEventListener(function(sender, eventType)
		if Define.EVENT_CLICK == eventType then
			app:enterScene("MainScene", "fade", 0.5)
		end
	end)

	self.btnAgain = self:createTextButton("Try Again")	
	local lp2 = ccui.LinearLayoutParameter:create()			 
	self.btnAgain:setLayoutParameter(lp2)
	lp2:setGravity(ccui.LinearGravity.centerHorizontal)
	lp2:setMargin({ left = 0, top = -90, right = 0, bottom = 10 })
	self.btnAgain:addTouchEventListener(function(sender, eventType)
		if Define.EVENT_CLICK == eventType then								
			app:enterScene("GameScene", "fade", 0.5, {cc.c3b(0, 0, 0)}, self.section)	
		end
	end)

	self.btnExit = self:createTextButton("Exit")	
	local lp3 = lp2:clone()
	self.btnExit:setLayoutParameter(lp3)
	self.btnExit:addTouchEventListener(function(sender, eventType)
		if Define.EVENT_CLICK == eventType then
			os.exit()	
		end
	end)

	layout:addChild(self.btnMain)
	layout:addChild(self.btnAgain)
	layout:addChild(self.btnExit)
end

function EndScene:createTextButton(text)
	local item = ccui.Button:create("image/hero_power_avatar_box_line.png", 0)
				 :setScaleX(0.3)
		    	 :setScaleY(0.4)
				 :setTitleText(text)
				 :setTitleFontSize(70)	
	return item
end
	
return EndScene