extends Node2D

@export var sprite : AnimatedSprite2D
@export var shape : CollisionShape2D
@export var area : Area2D
var SIZES := [4,8,14,18,24,28,34,38,44,48,54,58,64]

func changeRadius(currLevel : int):
	area.scale *= 1000


func _on_area_2d_area_entered(area):
	if area.get_parent().has_method("hideSprite"):
		area.get_parent().hideSprite()
