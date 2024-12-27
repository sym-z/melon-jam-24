extends Control

func _ready() -> void:
	call_deferred("next_scene")

func next_scene():
	get_tree().change_scene_to_file("res://scenes/typing.tscn")
