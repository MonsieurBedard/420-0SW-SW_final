extends "res://scripts/Car.gd"

signal current_speed(speed)
signal current_turn(turn, total)

func _process(delta):
	emit_signal("current_speed", velocity.length())
	emit_signal("current_turn", turn, number_of_turn)
	$Sprite.set_texture(load("res://assets/car-black.png"))

func control():
	var turn = 0
	var strength = 0
	if Input.is_action_pressed("control_turn_right"):
		strength = Input.get_action_strength("control_turn_right")
		turn += strength
	if Input.is_action_pressed("control_turn_left"):
		strength = Input.get_action_strength("control_turn_left")
		turn -= strength
	steer_direction = turn * deg2rad(steering_angle)
	
	if Input.is_action_pressed("control_accelerate"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("control_reverse"):
		acceleration = transform.x * braking
		
	if Input.is_action_pressed("ui_select"):
		add_effect("boost")

