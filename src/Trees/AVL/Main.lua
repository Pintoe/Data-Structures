-- UNFINISHED CODE 
-- UNFINISHED CODE 
-- UNFINISHED CODE 
-- UNFINISHED CODE 
-- UNFINISHED CODE 

local AVL = {}
AVL._index = AVL

local function _RepeatedInsert(Tree, ...)
	for _, Value in ipairs{...} do
		Tree:Insert(Value)
	end
end

local function _Height(Node)
	return Node and Node.Height or -1
end

local function _ComputeHeight(Node)
	Node._Height = math.max(_Height(Node.Left), _Height(Node.Right)) + 1
end

local function _RightRotate(Tree, Root) -- Root : x; Left : y; RightTemp : temp var
	local Left = Root.Left
	local RightTemp = Left.Right
	Left.Right = Root
	if Root == Tree.Head then
		Tree.Head = Left
	end
	Left.Height = _ComputeHeight(Left)
	Root.Height = _ComputeHeight(Root)
	Tree:Insert(RightTemp)
end

local function _LeftRotate(Tree, Root)
	local Right = Root.Right
	local LeftTemp = Right.Left
	Right.Left = Root
	if Root == Tree.Head then 
		Tree.Head = Right
	end
	Right.Height = _ComputeHeight(Right)
	Root.Height = _ComputeHeight(Root)
	Tree:Insert(LeftTemp)
end

function AVL.New(...)
	
	local NewTree = setmetatable({}, AVL)
	
	if (...) then _RepeatedInsert(...) end
		
	return NewTree
	
end

function AVL:Insert(Value, ...)

	Value = ( type(Value) == "number" and Value ) or error("A tree can only hold numbers")

	local Node = {Value = Value, Height = 0}
	local NodesAccessed = {}

	if ( not self.Head.Value ) then self.Head = Node return true end

	local Current, CurrentValue = self.Head, nil 

	while true do

		CurrentValue = Current.Value
		NodesAccessed[#NodesAccessed+1] = Current

		if Value <= CurrentValue then
			if not Current.Left then
				Current.Left = Node
				break
			else
				Current = Current.Left
			end
		else 
			if not Current.Right then
				Current.Right = Node
				break
			else 	
				Current = Current.Right
			end
		end

	end
	
	NodesAccessed[#NodesAccessed+1] = Node
	
	for Index, Node in ipairs(NodesAccessed) do
		
		Node.Height = _ComputeHeight(Node)
		
		local Difference = ( Node.Left.Height - Node.Right.Height )
		
		if math.abs(Difference) > 1 then		
			if Difference > 1 then -- Left Imbalance | left bigger den right
				_RightRotate(self, Node)
			elseif Difference < -1 then -- Right Imbalance | right bigger den left
				_LeftRotate(self, Node)
			end
		end	
	end

	if (...) then _RepeatedInsert(self, ...) end

	return Node
end

return AVL
