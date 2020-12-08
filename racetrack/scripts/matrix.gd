extends Node

const Point = preload("res://scripts/point.gd")

onready var RoadMap

var size = 40
var matrix

func creation(road_map):
	RoadMap = road_map
	self.matrix = []
	for x in range(size):
		self.matrix.append([])
		for y in range(size):
			self.matrix[x].append(Point.new())
			self.matrix[x][y].creation(x, y)

func get_point(x, y):
	return self.matrix[x][y]
	
func draw():
	for x in range(size):
		for y in range(size):
			if (self.matrix[x][y].road == true):
				RoadMap.set_cell(x, y, 0)
			if (self.matrix[x][y].obstacle == true):
				RoadMap.set_cell(x, y, 1)

	RoadMap.update_bitmask_region(Vector2(0, 0), Vector2(size, size))
				

