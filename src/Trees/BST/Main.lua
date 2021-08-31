local Tree = {}

Tree.__index = Tree

local function _RepeatedAppend(Table, ...)
	for _, Value in ipairs{...} do
		Table:Insert(Value)
	end	
end

function Tree.New(...)

	local NewTree = setmetatable({}, Tree)

	if (...) then _RepeatedAppend(NewTree, ...) end

	return NewTree
end

function Tree:Insert(Value, ...)
	
	Value = ( type(Value) == "number" and Value ) or error("A tree can only hold numbers")

	local Node = {Value = Value}
	
	if ( not self.Head ) then self.Head = Node return true end

	local Current, CurrentValue = self.Head, nil 

	while true do

		CurrentValue = Current.Value
		
		if Value <= CurrentValue then
			if not Current.Left then
				Current.Left = Node
				return Node
			else
				Current = Current.Left
			end
		else 
			if not Current.Right then
				Current.Right = Node
				return Node
			else 	
				Current = Current.Right
			end
		end

	end
	
	if (...) then _RepeatedAppend(self, ...) end

	return true
end

function Tree:Remove(Value)

	if ( not self.Head.Value ) then return false end
	Value = ( type(Value) == "number" and Value ) or error("Only numbers are in this tree")

	local Current = self.Head
	local CurrentValue, Last, Key

	while true do

		Last, CurrentValue = Current.Value, Current

		if ( CurrentValue == Value ) then break end

		Key = ( Value < CurrentValue and "Left" ) or ( CurrentValue < Value and "Right" )
		Current = Current[Key]

		if ( Current == nil ) then return false end

	end	

	if ( Current.Left and Current.Right ) then
		local Copy = Current.Right.Left or Current.Right
		self:Remove(Copy.Value)
		Last[Key] = Copy
	else 
		Last[Key] = ( not Current.Left and Current.Right ) or ( not Current.Right and Current.Left ) or nil
	end

	return true

end

function Tree:Search(Value)

	if ( not self.Head.Value ) then return end
	Value = ( type(Value) == "number" and Value ) or error("Only numbers are in this tree") 

	local Current, CurrentValue = self.Head, nil

	while Current do

		CurrentValue = Current.Value
		if ( CurrentValue == Value ) then return true end

		Current = ( Value <= CurrentValue and Current.Left ) or ( CurrentValue < Value and Current.Right )

	end	

	return false
end


return Tree
