-- !strict


-- Types --

type VertexStructure = {
	[Instance]: number?
}

type GraphStructure = {
	Matrix: {
		[Instance]: VertexStructure
	}
}

type VerticiesStructure = {
	[number]: VertexStructure
}

type NodeStructure = {
	[Instance]: bool
}

type Array = {
	[number]: Instance?
}

-- Modules --

local Stacks = require(script.Stack)
local Queues = require(script.Queues)


local Graph = {}
Graph.__index = Graph


-- Internal Auxiliary
local function _RepeatedAddVertex(CurrentGraph: GraphStructure, ...: VertexStructure): ...VertexStructure

	local Verticies: VerticiesStructure = {}

	for _, Vertex:VertexStructure in ipairs {...} do
		table.insert( Verticies, CurrentGraph:AddVertex(Vertex) )
	end

	return unpack(Verticies)
end

--[[
local function _RepeatedAddEdge(CurrentGraph: GraphStructure, ...: Instance): nil

	local Values: Array = {...}

	for Index: number = 2, #Values, 2 do
		CurrentGraph:AddEdge( Values[Index - 1], Values[Index] )
	end

end
]]
-- Public API

function Graph.New(...: Instance?): GraphStructure

	local NewGraph = setmetatable({
		Matrix = {},
		Length = 0,
	}, Graph)

	if ... then NewGraph:AddVertex(...) end

	return NewGraph

end

function Graph:AddVertex(VertexKey: Instance, ...: Instance): ...VertexStructure
	if not VertexKey then return error(":AddVertex, Argument 1 given was nil") end

	self.Matrix[VertexKey] = {}
	self.Length += 1

	if ... then return self.Matrix[VertexKey], _RepeatedAddVertex(self, ...) end

	return self.Matrix[VertexKey]

end

function Graph:AddEdge(From: Instance, Connections: Array): nil
	if not From or not Connections then return error(":AddEdge, Argument From or To may be missing.") end

	for _, To in pairs(Connections) do
		self.Matrix[From][To] = 1
		self.Matrix[To][From] = 1
	end

end

function Graph:GetConnectedVerticies(Key: Instance): Array
	if not Key then return error(":GetConnectedVerticies, Argument Key may not have been provided.") end

	local ConnctedVerticies: Array = {}

	for Index: Instance, Value: number in pairs(self.Matrix[Key]) do
		table.insert(ConnctedVerticies, Index) 	
	end

	return ConnctedVerticies
end

function Graph:GetVertex(Key: Instance): VertexStructure
	if not Key then return error(":GetVertex, Argument Key may not have been provided.") end

	return self.Matrix[Key]

end

function Graph:DepthFirstSearch() : () -> (number, Instance)

	local VisitedNodes: NodeStructure = {}

	local NewStack = Stacks.New{next(self.Matrix)}
	local NewQueue = Queues.New()
	
	while NewStack.Top ~= 0 do

		local Part: Instance, Vertex: VertexStructure = unpack(NewStack:Peek())
		NewStack:Pop()

		for Index: Instance, Value: VertexStructure in pairs(Vertex) do

			if VisitedNodes[Index] then continue end
			
			--setTwoEndPoints(Instance.new("Part", workspace), Part.Position, Index.Position).Anchored = true
			VisitedNodes[Index] = true
			NewQueue:Enqueue{Part, Index}
			NewStack:Push{Index, self.Matrix[Index]}

		end
	end
	
	return function(): (number, Instance, Instance)
		
		local Position = NewQueue.Front
		local Table = NewQueue:Dequeue()
		local PreviousPart, CurrentPart
		
		if ( Table and unpack(Table) ) then PreviousPart, CurrentPart = unpack(Table) end
		
	--	setTwoEndPoints(Instance.new("Part", workspace), PreviousPart.Position, CurrentPart.Position).Anchored = true
		
		return CurrentPart and Position, PreviousPart, CurrentPart
	end
	
end


return Graph
