extends Button

func _pressed() -> void:
	%MarkovPredicter.pad.clear()
	%MarkovPredicter.assocs.clear()
	%MarkovPredicter.generate_table()
