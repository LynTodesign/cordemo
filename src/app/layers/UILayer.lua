local UILayer = class("UILayer", function()
		return display.newLayer()
end)
local EventManager = require("app.table.EventManager")
local Rocker = require("app.class.Rocker")
local Define = require("app.table.Define")

function UILayer:ctor()
	-- self:addBtn()
end

function UILayer:setControlGame(target)
	self.ctrGame = target
end

function UILayer:connectGame()
	self.healthLable = cc.Label:create()
	self.healthLable:setSystemFontSize(30)
	self.healthLable:pos(display.width - 100, display.height - 30)
	self.healthLable:setString("Health: " .. self.ctrGame.hero.health)
	self:addChild(self.healthLable)
	self.rocker = Rocker.new()
	self.rocker:registerListen(self.ctrGame.hero)
	self:addChild(self.rocker)

	self.btnShoot = ccui.Button:create("image/btn_shoot_on.png", "image/btn_shoot.png",  0)
	self.btnShoot:pos(display.width - 160, display.cy - 180)
	self:addChild(self.btnShoot)
	self.btnShoot:addTouchEventListener(function(sender, eventType)
		if Define.EVENT_CLICK == eventType then
			self.ctrGame.hero:attack()
		end
	end)

	self.btnPause = ccui.Button:create("image/btn_pause.png", 0)
	self.btnPause:pos(50, display.height - 50)
	self:addChild(self.btnPause)	
	self.btnPause:addTouchEventListener(function(sender, eventType) 
		if Define.EVENT_CLICK == eventType then
			self:setPause()
		end
	end)

	self.btnResume = ccui.Button:create("image/start_swich_btn_right.png", 0)
	self.btnResume:pos(display.cx, display.cy)
	self:addChild(self.btnResume)
	self.btnResume:addTouchEventListener(function(sender, eventType) 
		if Define.EVENT_CLICK == eventType then
			self:setResume()
		end
	end)
	self.btnResume:setEnabled(false)	

	EventManager:EventRegister("injured", function()
		self:injured()		
	end)
end


function UILayer:setUILayerEnabled(isEnabled)
	self.rocker:setTouchEnabled(isEnabled)
	self.btnShoot:setTouchEnabled(isEnabled)
end

function UILayer:setPause()
	display.pause()
	self:setUILayerEnabled(false)
	self.btnPause:setEnabled(false)
	self.btnResume:setEnabled(true)
end  

function UILayer:setResume()
	display.resume()
	self:setUILayerEnabled(true)
	self.btnPause:setEnabled(true)
	self.btnResume:setEnabled(false)
end

function UILayer:injured()
	self.healthLable:setString("Health: " .. self.ctrGame.hero.health)	
end

return UILayer