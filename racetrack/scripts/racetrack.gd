extends Node2D

const Point = preload("res://scripts/point.gd")
const Matrix = preload("res://scripts/matrix.gd")

onready var RoadMap = $RoadMap
#onready var Car = $Car

const Automate = preload("res://scenes/Automate.tscn")

var cars = []
var cars_finished = []

signal countdown(time)
signal stop_countdown()
signal pos(pos, total)
signal leaderboard(content)
signal finished(pos)

# Jarvis march

func orientation(p, q, r):
	var val = (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y)
	if val == 0:
		return 0
	elif val > 0:
		return 1
	else:
		return 2

func jarvis_march(points):
	if len(points) < 3:
		return

	var hull = []

	var l = 0
	for i in range(len(points)):
		if points[i].x < points[l].x:
			l = i

	var p = l
	var is_true = true
	while is_true:
		hull.append(points[p])

		var q = (p + 1) % len(points)
		for i in range(len(points)):
			if orientation(points[p], points[i], points[q]) == 2:
				q = i

		p = q

		if p != l:
			is_true = true
		else:
			is_true = false

	for i in range(len(hull)):
		hull[i].road = true

	return hull

# A star

func calculate_cost(start, end):
	var x_diff = abs(start.x - end.x)
	var y_diff = abs(start.y - end.y)
	return x_diff * 10 + y_diff * 10


func update_h(matrix, end):
	for x in range(matrix.size):
		for y in range(matrix.size):
			matrix.get_point(x, y).h = calculate_cost(matrix.get_point(x, y), end)


func get_lowest_cost(open_set):
	var cheapest_point = open_set[0]
	for i in range(len(open_set)):
		if (cheapest_point.get_f() > open_set[i].get_f()):
			cheapest_point = open_set[i]
	
	return cheapest_point


func generate_neighbours(matrix):
	for x in range(matrix.size):
		for y in range(matrix.size):
			var neighbours = []
			if x < matrix.size - 1:
				if matrix.get_point(x + 1, y).walkable:
					neighbours.append(matrix.get_point(x + 1, y))
			if y < matrix.size - 1:
				if matrix.get_point(x, y + 1).walkable:
					neighbours.append(matrix.get_point(x, y + 1))
			if x > 0:
				if matrix.get_point(x - 1, y).walkable:
					neighbours.append(matrix.get_point(x - 1, y))
			if y > 0:
				if matrix.get_point(x, y - 1).walkable:
					neighbours.append(matrix.get_point(x, y - 1))

			matrix.get_point(x, y).neighbours = neighbours


func find_walkable(matrix, start, end):
	for x in range(matrix.size):
		for y in range(matrix.size):
			if !matrix.get_point(x, y).road:
				var count = 0
				if x < matrix.size - 1:
					if matrix.get_point(x + 1, y).road:
						count += 1
				if y < matrix.size - 1:
					if matrix.get_point(x, y + 1).road:
						count += 1
				if x > 0:
					if matrix.get_point(x - 1, y).road:
						count += 1
				if y > 0:
					if matrix.get_point(x, y - 1).road:
						count += 1

				if x < matrix.size - 1 and y < matrix.size - 1:
					if matrix.get_point(x + 1, y + 1).road:
						count += 1
				if x < matrix.size - 1 and y > 0:
					if matrix.get_point(x + 1, y - 1).road:
						count += 1
				if x > 0 and y < matrix.size - 1:
					if matrix.get_point(x - 1, y + 1).road:
						count += 1
				if x > 0 and y > 0:
					if matrix.get_point(x - 1, y - 1).road:
						count += 1

				if count >= 2:
					matrix.get_point(x, y).walkable = false

	start.walkable = true
	end.walkable = true


func generate_path(start, end, current):
	var track = [current]

	while current != start:
		track.append(current)
		current = current.parent

	for i in range(len(track)):
		track[i].road = true
		track[i].walkable = false

	return track


func a_star(matrix, start, end):
	update_h(matrix, end)
	find_walkable(matrix, start, end)
	generate_neighbours(matrix)

	var open_set = [start]
	var close_set = []
	var current = start

	while len(open_set) > 0:
		current = get_lowest_cost(open_set)
		if current == end:
			break
			
		close_set.append(current)
		open_set.erase(current)
		
		for neighbour in current.neighbours:
			var tentative_g_score = current.g + calculate_cost(current, neighbour)

			if tentative_g_score < neighbour.g or !open_set.has(neighbour):
				if !close_set.has(neighbour):
					neighbour.parent = current
					neighbour.g = tentative_g_score
					if !open_set.has(neighbour):
						open_set.append(neighbour)

	var final_path = generate_path(start, end, current)
	final_path.invert()
	return final_path


func generate():
	#
	# Creating a new matrix 
	#
	
	var matrix = Matrix.new()
	matrix.creation(RoadMap)

	#
	# Create a random set of points
	#
	
	var set_of_points = []
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	var _i = 0
	while _i < 8:
		var ok = true
		
		var x = rng.randi_range(0 + 10, matrix.size - 10)
		var y = rng.randi_range(0 + 10, matrix.size - 10)
		
		for j in range(len(set_of_points)):
			var dis_x = abs(set_of_points[j].x - x)
			var dis_y = abs(set_of_points[j].y - y)
			if (dis_x <= 5 and dis_y <= 5):
				ok = false
				
		if matrix.get_point(x, y).obstacle:
			ok = false

		if !set_of_points.has(matrix.get_point(x, y)) and ok == true:
			set_of_points.append(matrix.get_point(x, y))
			_i += 1

	set_of_points.append(matrix.get_point(8, matrix.size / 2 + 2))
	set_of_points.append(matrix.get_point(8, matrix.size / 2 - 2))

	#
	# Find the convex hull from the set of points aka perimeter
	#

	var perimeter = jarvis_march(set_of_points)

	#
	# Creating the final track
	#

	var track = []
	var final_track = []

	for i in range(len(perimeter) - 1):
		track = a_star(matrix, perimeter[i], perimeter[i + 1])
		
		for j in range(len(track)):
			if !final_track.has(track[j]):
				final_track.append(track[j])

	track = a_star(matrix, perimeter[len(perimeter) - 1], perimeter[0])

	for j in range(len(track)):
		if !final_track.has(track[j]):
			final_track.append(track[j])

	#
	# Drawing the matrix in the world
	#

	matrix.draw()
	RoadMap.set_cell(final_track[0].x + 1, final_track[0].y, 2)
	RoadMap.set_cell(final_track[0].x -1, final_track[0].y, 2)
	
	RoadMap.update_bitmask_region(Vector2(0, 0), Vector2(matrix.size, matrix.size))

	# Crete the RoadArea2d
	for i in range(len(final_track)):
		var rectangle = RectangleShape2D.new()
		rectangle.set_extents(Vector2(128, 128))
		var shape = CollisionShape2D.new()
		shape.set_shape(rectangle)
		shape.position += Vector2(final_track[i].x * 256 + 128, final_track[i].y * 256 + 128)
		$RoadAread2d.add_child(shape)

	#
	# Placing the player on the track and creating the follow track
	#

	var follow_path = []
	
	for i in range(len(final_track) - 1):
		if !((final_track[i - 1].x == final_track[i].x and final_track[i].x == final_track[i + 1].x) or (final_track[i - 1].y == final_track[i].y and final_track[i].y == final_track[i + 1].y)):
			final_track[i].corner = true
	
	if final_track[0].corner == true:
		var next = final_track[1]
		if !follow_path.has(next) and next.corner == false:
			follow_path.append(next)

	for i in range(1, len(final_track) - 1):
		if final_track[i].corner == true:
			var previous = final_track[i - 1]
			var next = final_track[i + 1]
			if !follow_path.has(previous) and previous.corner == false:
				follow_path.append(previous)
			if !follow_path.has(next) and next.corner == false:
				follow_path.append(next)

	if final_track[0].corner == true:
		var previous = final_track[len(final_track) - 1]
		if !follow_path.has(previous) and previous.corner == false:
			follow_path.append(previous)

	for i in range (5):
		var aut = Automate.instance()
		aut.rotate(deg2rad(-90))
		aut.position += Vector2(final_track[0].x * 256 + 16 + 45 * i, final_track[0].y * 256 + 128)
		aut.track = final_track
		aut.track_current = final_track[0]
		aut.follow_path = follow_path
		aut.follow_path_current = follow_path[0]
		aut.id = "automate " + str(i + 1)
		aut.connect("score_changed", self, "_on_car_score_changed")
		aut.connect("finished", self, "_on_car_finished")
		cars.append(aut)
		add_child(aut)
	
	$Player.rotate(deg2rad(-90))
	$Player.position += Vector2(final_track[0].x * 256 + 240, final_track[0].y * 256 + 128)
	$Player.track = final_track
	$Player.track_current = final_track[0]
	$Player.id = "player"
	$Player.connect("score_changed", self, "_on_car_score_changed")
	$Player.connect("finished", self, "_on_car_finished")
	
	cars.append($Player)


func _ready():
	generate()
	$Timer.start()
	pause_mode = Node.PAUSE_MODE_STOP

func _process(delta):
	var timeleft = int($Timer.get_time_left())
	emit_signal("countdown", str(timeleft))


func _on_car_finished(id):
	cars_finished.append(id)
	if id == "player":
		emit_signal("finished", cars_finished.size())


func _on_car_score_changed():
	var temp_cars = cars
	temp_cars.sort_custom(self, "car_sort")
	
	var current_pos = temp_cars.find($Player) + 1
	var number_of_cars = len(temp_cars)
	emit_signal("pos", current_pos, number_of_cars)
	
	var leaderboard_str = ""
	for i in range(len(temp_cars)):
		leaderboard_str += str(i + 1) + "-" + temp_cars[i].id + "\n"
	emit_signal("leaderboard", leaderboard_str)


func car_sort(a, b):
	return a.score > b.score


func _on_Timer_timeout():
	for i in range(len(cars)):
		cars[i].start = true
	$Timer.stop()
	emit_signal("stop_countdown")
