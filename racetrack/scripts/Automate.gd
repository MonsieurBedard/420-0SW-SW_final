extends "res://scripts/Car.gd"


func get_normal_point(p: Vector2, a: Vector2, b:Vector2):
	var ap: Vector2 = p - a
	var ab: Vector2 = b - a
	ab = ab.normalized()
	ab = ab * ap.dot(ab)
	var normal_point = a + ab
	return normal_point


func seek(target: Vector2):
	var desired = Vector2.ZERO
	desired = target - position
	
	if desired.length() == 0:
		return
	
	var predict = velocity.normalized()
	var angle = desired.angle_to(predict)

#	var deg_angle = deg2rad(angle)
#
#	var turn = 0
#	if deg_angle > 20:
#		turn = -1
#	elif deg_angle < -20:
#		turn = 1
#	else:
#		turn += (deg_angle / 20) * 1

	angle = rad2deg(angle) / 15
	if angle > 1:
		angle = 1
	elif angle < -1:
		angle = -1


	var turn = 0
	if angle > 0:
		turn -= abs(angle)
	elif angle < 0:
		turn += abs(angle)
		
	steer_direction = turn * deg2rad(steering_angle)


func follow():
	if int(position.x / 256) == follow_path_current.x and int(position.y / 256) == follow_path_current.y:
		var current_index = follow_path.find(follow_path_current)
		if current_index >= len(follow_path) - 1:
			follow_path_current = follow_path[0]
		else:
			follow_path_current = follow_path[current_index + 1]
		seek_diff_x = rand_range(-35, 35)
		seek_diff_y = rand_range(-35, 35)

	seek(Vector2(follow_path_current.x * 256 + 128 + seek_diff_x, follow_path_current.y * 256 + 128 + seek_diff_y))
	acceleration = transform.x * engine_power


func control():
	follow()
