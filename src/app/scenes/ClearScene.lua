local ClearScene = class("ClearScene", function() 
		return display.newScene("ClearScene")
end)
local app = require("app.MyApp")
local LoadManager = require("app.table.LoadManager")
local Define = require("app.table.Define")

function ClearScene:ctor(section) 
	local spBG = display.newSprite("image/lyBG8.png")
				 :pos(display.cx, display.cy)
	self:addChild(spBG)

	LoadManager.preLoadBonesAnimation("spine/spineboy.json", "spine/spineboy.atlas")
	local heroNode = LoadManager.createBonesAnimation('gun toss', 1, false)
	heroNode:pos(display.cx, display.cy + 100)
	heroNode:setScale(0.2)
	self:addChild(heroNode)

	local label
	local params = {}
	params.text = "You Clear The Section "..section
	params.font = "font/BPreplay.ttf"
	params.size = 50
	params.x = display.cx
	params.y = display.cy + 50
	label = display.newTTFLabel(params)
	self:addChild(label)

	local touchNode = display.newNode()
	local par = cc.ParticleExplosion:create()
				:pos(display.cx, display.cy + 70)
				:setSpeed(100)
	self:addChild(par)

	local home
	local nextSection
	local btnBgLeft = display.newSprite("image/img_swich_start_bg.png")
	              :setScale(0.4)
	local btnBgRight = display.newSprite("image/img_swich_start_bg.png")
	              :setScale(-0.4)
  	params.font = "font/Lot.ttf"
	params.size = 50
	params.y = display.cy - 140

	btnBgLeft:pos(display.cx - 120, display.cy - 140)
	self:addChild(btnBgLeft)
	params.text = "HOME"
	params.x = display.cx - 120
	home = display.newTTFLabel(params)
	self:addTouchListener(home, function()
		app.new():enterScene("MainScene", "fade", 0.5)
	end)


	btnBgRight:pos(display.cx + 120, display.cy - 140)
	self:addChild(btnBgRight)
	params.text = "NEXT"
	params.x = display.cx + 120
	nextSection = display.newTTFLabel(params)
	self:addTouchListener(nextSection, function()
		if section == Define.SECTION_NUM then
			section = 0
		end
		app.new():enterScene("GameScene", "fade", 0.5, {cc.c3b(0, 0, 0)}, section + 1)
	end)

	self:addChild(home, 2)
	self:addChild(nextSection, 2)
end

function ClearScene:addTouchListener(target, func)
	if target == nil then
		return
	end
	target:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) 
		if event.name == "began" then
			func()
		end
	end)
	target:setTouchEnabled(true)
end

return ClearScene