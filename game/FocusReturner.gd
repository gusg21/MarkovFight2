extends Control

func _unhandled_input(event):
	grab_focus()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_input_return"):
		grab_focus()
		
