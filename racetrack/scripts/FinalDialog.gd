extends CanvasLayer

func _ready():
	$Overlay.visible = false


func _on_racetrack_finished(pos):
	$Overlay.visible = true
	$Overlay/Container/Options/PositionLabel.set_text("Pos: " + str(pos))


func _on_RestartButton_pressed():
	get_tree().change_scene("res://scenes/racetrack.tscn")


func _on_MenuButton_pressed():
	get_tree().change_scene("res://scenes/TitleScreen.tscn")
