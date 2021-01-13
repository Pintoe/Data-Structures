local Queues = {}
Queues.__index = Queues

local DefaultLength = 10

local function _RepeatedEnqueue(Queue, ...)
	for _, Value in ipairs{...} do
		Queue:Enqueue(Value)
	end
end

function Queues.New(Length, ...)

	Length = Length or not warn(("Length of stack undefined, using DefaultSize : %d"):format(DefaultLength)) and DefaultLength

	local NewQueue = setmetatable({
		Queue = table.create(Length),
		Front = 0,
		Rear = 0,
		IsEmpty = true,
		IsFull = Length == 0 and true or false,
		MaxSize = Length
	}, Queues)

	if (...) then _RepeatedEnqueue(NewQueue, ...) end
	
	return NewQueue
end

function Queues:Enqueue(Value, ...)	

	if ( self.IsFull ) then return false end

	self.Rear = self.Rear + 1
	self.Queue[self.Rear] = Value

	if ( self.Rear == self.MaxSize ) then self.IsFull = true end 
	if ( self.IsEmpty ) then 
		self.IsEmpty, self.Front = false, 1 
	end

	if (...) then _RepeatedEnqueue(self, ...) end
	
	return true
end

function Queues:Dequeue()

	if ( self.IsEmpty ) then return false end

	local ValueToDequeue = self.Queue[self.Front]
	self.Queue[self.Front] = nil
	self.Front = self.Front + 1

	if self.Front > self.Rear then 
		self.IsEmpty = true
		self.Front, self.Rear = 0, 0
	end

	return ValueToDequeue
end

function Queues:Iterate()
	
	local Queue = self.Queue
	local Index = 0
	local Value
	
	return function()
		
		Index = Index + 1
		Value = Queue[Index]
		
		return Value and Index, Value or nil
		
	end
	
end

function Queues:Peek()
	return self.Queue[self.Front]	
end

return Queues
 