extends CanvasLayer


func _ready():
	$Overlay.visible = false
	

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if !$Overlay.visible:
			$Overlay.visible = true
			get_tree().paused = true
		else:
			$Overlay.visible = false
			get_tree().paused = false



func _on_PauseButton_pressed():
	$Overlay.visible = false
	get_tree().paused = false


func _on_MainMenuButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/TitleScreen.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()
