extends Camera2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DBG_next_scene"):
		get_tree().change_scene_to_file("res://words/words.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target_pos = %Player.global_position
	
	global_position = global_position.lerp(target_pos, 0.2)
