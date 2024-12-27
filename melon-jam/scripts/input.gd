extends Node

@onready var KEYS = {}

func _ready() -> void:
	for i in range("A".unicode_at(0), "Z".unicode_at(0)+1):
		KEYS[i] = String.chr(i)
	print(KEYS)
