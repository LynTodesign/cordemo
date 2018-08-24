Define = {}
local ParseJson = require("app.table.ParseJson")

Define.HERO_WIDTH, Define.HERO_HEIGHT = 100, 130

Define.HERO_XMIN, Define.HERO_XMAX = 0, display.width
Define.HERO_YMIN, Define.HERO_YMAX = 50, 530

Define.NODE_TYPE = {
	HERO = 0,
	ENEMY = 1
}

Define.HERO_STATE = {
	STAND = 0,
	RUN = 1,
	INJURED = 10,
	DEATH = 11
}

Define.DIRECTION = {
	RIGHT = 0,
	LEFT = 1
}

Define.ENEMY_TYPE = {
	VAMPIRE = 1,
	CAT = 11
}

Define.ENEMY_DIRECTION = {
	LEFT= 1,
	RIGHT = 0
}

Define.EVENT_CLICK = 0

Define.SECTION_NUM = ParseJson.getSectionNumber()

Define.HERO_HEALTH = 3

Define.HERO_TAG, Define.ENEMY_TAG, Define.BULLET_TAG = 1, 2, 3

return Define