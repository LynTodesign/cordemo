local EventManager = {}
EventManager.EventTable = {}
local Dispatcher = cc.Director:getInstance():getEventDispatcher()

function EventManager:EventRegister(name, Func) 
	local Listener = cc.EventListenerCustom:create(name, Func)
	Dispatcher:addEventListenerWithFixedPriority(Listener, 1)
	table.insert(EventManager.EventTable, Listener)
	return Listener
end

function EventManager:Dispatch(name)
	local Event = cc.EventCustom:new(name)
	Dispatcher:dispatchEvent(Event)
end

function EventManager:removeEventListener(listener)
	Dispatcher:removeEventListener(listener)
	local tmpTable = {}
	for k, v in pairs(EventManager.EventTable) do
		if v ~= listener then
			table.insert(tmpTable, v)
		end
	end
	EventManager.EventTable = tmpTable
	tmpTable = nil
end

function EventManager:removeAllListeners()
	for k, v in pairs(EventManager.EventTable) do
		Dispatcher:removeEventListener(v)
	end
	EventManager.EventTable = {}
end

return EventManager