extends CanvasLayer


func _ready():
	pass # Replace with function body.


func _on_Player_current_speed(speed):
	$Container/Separator/StatContainer/SpeedContainer/SpeedValue.set_text(str(int(speed)))


func _on_Player_current_turn(turn, total):
	var str_value = ""
	if turn > total:
		str_value = "finished"
	else:
		str_value = str(turn) + " of " + str(total)
	$Container/Separator/StatContainer/TurnContainer/TurnValue.set_text(str_value)


func _on_racetrack_countdown(time):
	$CenterContainer/VBoxContainer/TimeLabel.set_text(time)


func _on_racetrack_stop_countdown():
	$CenterContainer/VBoxContainer/TimeLabel.visible = false


func _on_racetrack_pos(pos, total):
	$Container/Separator/StatContainer/PositionContainer/PositionValue.set_text(str(pos) + " out of " + str(total))


func _on_racetrack_leaderboard(content):
	$Container/Separator/LeaderboardContainer/LeaderboardContent.set_text(content)
