extends LineEdit

func _ready() -> void:
	text_changed.connect(on_text_changed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_input_return"):
		release_focus()

func on_text_changed(text):
	%MarkovPredicter.n = int(text)	
	%MarkovPredicter.generate_table()
