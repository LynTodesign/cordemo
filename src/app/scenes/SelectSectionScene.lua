local SelectSectionScene = class("SelectSectionScene", function() 
	return display.newScene("SelectSectionScene")
end)
local Define = require("app.table.Define")
local ParseJson = require("app.table.ParseJson")
local socket = require("socket")
local IMAGEMAP_WIDTH = 500
local TOUCH_DISTANCE = 50

function SelectSectionScene:ctor()
	display.newSprite("image/lyBG8.png")
		:pos(display.cx, display.cy)
		:addTo(self)

	local topLabel = ccui.Text:create("Section  Select", "font/BPreplay.ttf", 50)
	topLabel:pos(display.cx , display.cy + 250)
	self:addChild(topLabel)

	self:initScrollView()
end

function SelectSectionScene:initScrollView()
	self.scrollview = ccui.ScrollView:create() 
	self.scrollview:setTouchEnabled(true) 
	self.scrollview:setBounceEnabled(true)
	self.scrollview:setInertiaScrollEnabled(true)
	self.scrollview:setDirection(ccui.ScrollViewDir.horizontal)
	self.scrollview:setContentSize(cc.size(display.width, display.height))
	self.scrollview:setInnerContainerSize(cc.size(Define.SECTION_NUM * display.width, display.height))
	self.scrollview:align(display.TOP_CENTER, display.cx, display.top)				 	  

	local spMap, spClear, nameLabel
	for i = 1, Define.SECTION_NUM do
		local name = string.format("mapIMG/map_%1d.png", i)	
		spMap = display.newSprite(name)
		spMap:pos(display.cx + (i - 1) * display.width, display.cy)
		spMap:setScale(IMAGEMAP_WIDTH / spMap:getContentSize().width)
		local preTime, nextTime
		spMap:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) 
			if event.name == "began" then
				preTime = socket.gettime()
				return true
			end
			if event.name == "ended" then
				nextTime = socket.gettime()
				if nextTime - preTime < 0.13 then
					app:enterScene("GameScene", "fade", 0.5, cc.c3b(0, 0, 0), i)
				end
			end
		end)
		spMap:setTouchEnabled(true)
		spMap:setTouchSwallowEnabled(false)

		local sectionName = "section"..i
		if ParseJson.checkClearWithJson(sectionName) then
			spClear = display.newSprite("image/clear.png")
			spClear:setScale(0.3)
			spClear:pos(display.cx + (i - 1) * display.width, display.cy)
			self.scrollview:addChild(spClear, 10)
		end

		local mapName = ParseJson.getSectionData(i).name
		nameLabel = ccui.Text:create(sectionName .. " : " .. mapName , "font/BPreplay.ttf", 40)
		nameLabel:pos(display.cx + (i - 1) * display.width, display.cy - 200)
		self.scrollview:addChild(nameLabel)

		self.scrollview:addChild(spMap)
	end
	self:addChild(self.scrollview)
end

return SelectSectionScene