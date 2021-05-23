-- !strict

local Stacks = require(script.Stack)
local Queues = require(script.Queues)

local RunService = game:GetService("RunService")

local Graph = {}
Graph.__index = Graph

type GraphStructure = {
	Matrix : {
		[any] : {
			[any] : number?
		}
	}
}

type VertexStructure = {
	[any] : number 
}

type Array = {
	[number] : any
}

type IndexType = Instance

local function _RepeatedAddVertex(CurrentGraph : GraphStructure, ... : VertexStructure) : VertexStructure
	
	local Verticies : { [number] : VertexStructure } = {}
	
	for _ : number, Vertex : VertexStructure in ipairs{...} do
		table.insert(Verticies, CurrentGraph:AddVertex(Vertex))
	end
	
	return unpack(Verticies)
end

local function _RepeatedAddEdge(CurrentGraph : GraphStructure, ... : IndexType) : nil
	
	local Values : Array = {...}
	
	for Index : number = 2, #Values, 2 do
		CurrentGraph:AddEdge(Values[Index - 1], Values[Index])
	end

end

function Graph.New(... : IndexType?) : GraphStructure

	local NewGraph = setmetatable({
		Matrix = {},
		Length = 0,
	}, Graph)

	if (...) then NewGraph:AddVertex(...) end

	return NewGraph

end

function Graph:AddVertex(VertexKey : IndexType, ... : IndexType) : VertexStructure

	if ( not VertexKey ) then error("Argument 1 given was nil") end

	self.Matrix[VertexKey] = {}
	self.Length += 1
	
	if (...) then return self.Matrix[VertexKey], _RepeatedAddVertex(self, ...) end

	return self.Matrix[VertexKey]

end

function Graph:AddEdge(From : IndexType, Too : IndexType, ... : IndexType) : nil

	self.Matrix[From][Too] = 1
	self.Matrix[Too][From] = 1

	if (...) then _RepeatedAddEdge(self, ...) end

end

function Graph:GetConnectedVerticies(Vertex : VertexStructure) : Array

	local ConnctedVerticies : Array = {}

	for Index : any, Value : number in pairs(Vertex) do
		table.insert(ConnctedVerticies, Index) 	
	end

	return ConnctedVerticies

end

function Graph:GetVertex(Key : IndexType) : VertexStructure

	return self.Matrix[Key]

end

function Graph:DepthFirstSearch() : IndexType

	local StartValue : VertexStructure = select(2, next(self.Matrix))
	local NewStack = Stacks.New(StartValue)
	
	local VisitedNodes : { [IndexType] : bool } = {}
	
	local QueueToReturn = Queues.New()
	
	while NewStack.Top ~= 0 do
		local Vertex : VertexStructure = NewStack:Peek()
		NewStack:Pop()
		
		for Index : IndexType, Value : VertexStructure in pairs(Vertex) do
			
			if not VisitedNodes[Index] then
				
				NewStack:Push(self.Matrix[Index])
				VisitedNodes[Index] = true
				QueueToReturn:Enqueue(Index)
				
			end
		end
	end
	
	return function() : number | IndexType
		
		local Position : number = QueueToReturn.Front
		local ValueToReturn : IndexType = QueueToReturn:Dequeue()
		
		return ValueToReturn and Position, ValueToReturn
		
	end
	
end

return Graph 