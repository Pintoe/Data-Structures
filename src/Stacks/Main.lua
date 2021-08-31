local Stack = {}
Stack.__index  = Stack

local DefaultStackSize = 10

local function _RepeatedPush(Table, ...)
	for _, Value in ipairs{...} do
		Table:Push(Value)
	end
end

function Stack.New(...)

	local NewStack = setmetatable({
		Values = table.create(DefaultStackSize),
		Top = 0,
		IsEmpty = true,
		IsFull = DefaultStackSize == 0 or false,
		MaxSize = DefaultStackSize
	}, Stack)

	if (...) then _RepeatedPush(NewStack, ...) end

	return NewStack

end

function Stack:Pop()

	if ( self.IsEmpty ) then return error("Attempt to run :Pop() on an empty stack") end

	self.Values[self.Top] = nil
	self.Top = self.Top - 1

	if ( self.IsFull ) then self.IsFull = false end
end

function Stack:Push(Value, ...)

	if ( self.IsFull ) then return error("Attempt to run :Push() on a full stack") end

	Value = Value or error("Value not specified")

	self.Top = self.Top + 1
	self.Values[self.Top] = Value

	if ( self.IsEmpty ) then self.IsEmpty = false end
	if (...) then _RepeatedPush(self, ...) end

end

function Stack:Iterate()
	
	local Values = self.Values
	local Index = 0
	local Value
	
	return function()
		
		Index = Index + 1
		Value = Values[Index]
		
		return Index, Value or nil
		
	end
	
end

function Stack:Peek()
	return self.Values[self.Top]
end

return Stack
