extends KinematicBody2D

# identifier
var id = "name"

# Base values
var wheel_base = 70
var steering_angle = 20
var engine_power = 800
var friction = -0.9
var drag = -0.001
var braking = -450
var max_speed_reverse = 250
var slip_speed = 300
var traction_fast = 0.01
var traction_slow = 0.7
var offroad_power = 200

# For randomness
var steering_angle_default
var engine_power_default
var friction_default
var offroad_power_default

var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO
var steer_direction

var track = []
var track_current

var follow_path = []
var follow_path_current
var seek_diff_x
var seek_diff_y

var on_track_check = null

var position_array = null
var score = 0

var effects = []

var turn = 1
var number_of_turn = 4
var can_turns = false
var current_track_pos = 0

var start = false
var finished = false

signal current_position(id, pos)
signal score_changed()
signal finished(id)

func _ready():
	steering_angle_default = rand_range(18, 22)
	engine_power_default = rand_range(750, 850)
	friction_default = rand_range(-0.8, -1.0)
	offroad_power_default = rand_range(150, 300)
	
	seek_diff_x = rand_range(-35, 35)
	seek_diff_y = rand_range(-35, 35)
	
	var color = randi() % 4
	if (color == 0):
		$Sprite.set_texture(load("res://assets/car-green.png"))
	elif (color == 1):
		$Sprite.set_texture(load("res://assets/car-orange.png"))
	elif (color == 2):
		$Sprite.set_texture(load("res://assets/car-purple.png"))
	else:
		$Sprite.set_texture(load("res://assets/car-red.png"))


func _process(delta):
	pass


func _physics_process(delta):
	if start == true:
		acceleration = Vector2.ZERO
		control()
		check_if_on_track()
		apply_effect()
		apply_friction()
		calculate_steering(delta)
		velocity += acceleration * delta
		velocity = move_and_slide(velocity)
		check_position()


# Used by the childrens
func control():
	pass


# If offroading, add the effect
func check_if_on_track():
	if on_track_check == null:
		on_track_check = []
		for i in range(len(track)):
			on_track_check.append(str(track[i].x) + str(track[i].y))
	else:
		var location = str(int(position.x / 256)) + str(int(position.y / 256))
		if !on_track_check.has(location):
			add_effect("offroad")


func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	acceleration += drag_force + friction_force


func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()


func add_effect(effect: String):
	if !effects.has(effect):
		effects.append(effect)


func apply_effect():
	# Reset all to default
	wheel_base = 70
	steering_angle = steering_angle_default
	engine_power = engine_power_default
	friction = friction_default
	drag = -0.001
	braking = -450
	max_speed_reverse = 250
	slip_speed = 300
	traction_fast = 0.01
	traction_slow = 0.7
	offroad_power = offroad_power_default
	
	$Particles2D.visible = false
	
	# Apply all the effect
	if effects.has("offroad"):
		engine_power = engine_power - offroad_power
		$Particles2D.visible = true
	
	if effects.has("boost"):
		engine_power = engine_power * 2
		
	effects = []

func check_position():
	if position_array == null:
		position_array = []
		for i in range(len(track)):
			position_array.append(Vector2(track[i].x, track[i].y))

	current_track_pos = position_array.find(Vector2(int(position.x / 256), int(position.y / 256)))
	
	if current_track_pos > 0:
		can_turns = true
	elif current_track_pos == 0 and can_turns == true:
		can_turns = false
		turn += 1
	
	if current_track_pos != -1:
		if score != turn * 1000 + current_track_pos:
			score = turn * 1000 + current_track_pos
			emit_signal("score_changed")
			
	if turn > number_of_turn and !finished:
		finished = true
		emit_signal("finished", id)
