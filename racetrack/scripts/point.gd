extends Node

# Coordinates
var x = 0
var y = 0

var g = 0
var h = 0
var neighbours = []
var walkable = true
var parent

var road = false
var corner = false

var obstacle = false

func creation(x, y):
	self.x = x
	self.y = y

func get_f():
	return self.g + self.h
