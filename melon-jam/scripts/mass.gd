extends Node2D

## Where the letter is displayed, determined at runtime
var startLoc : Vector2

func _ready() -> void:
	global_position = startLoc

func _process(delta: float) -> void:
	pass
