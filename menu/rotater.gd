extends TextureRect

func _ready() -> void:
	pivot_offset = Vector2(texture.get_width() / 2, texture.get_height() / 2)

func _process(delta: float) -> void:
	var secs = Time.get_ticks_msec() / 1000.0
	rotation_degrees = sin(secs / 2) * 4
