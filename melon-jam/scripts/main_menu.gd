extends Control
func next_scene():
	get_tree().change_scene_to_file("res://scenes/typing.tscn")

func _on_play_button_button_up():
	call_deferred("next_scene")
