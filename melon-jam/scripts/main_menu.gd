extends Control

@export var openingSprite : AnimatedSprite2D
func next_scene():
	get_tree().change_scene_to_file("res://scenes/typing.tscn")

func _on_play_button_button_up():
	call_deferred("next_scene")


func _on_opening_animation_finished():
	openingSprite.visible = false
