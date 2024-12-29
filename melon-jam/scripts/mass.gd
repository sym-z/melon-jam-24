extends Node2D

@export var sprite : AnimatedSprite2D
@export var shape : CollisionShape2D
var SIZES := [4,8,14,18,24,28,34,38,44,48,54,58,64]

## Where the letter is displayed, determined at runtime
var startLoc : Vector2

func _ready() -> void:
	global_position = startLoc
	adjustOffset()

func hideSprite():
	print("hiding")
	sprite.visible = false


func adjustOffset():
	var texture = sprite.sprite_frames.get_frame_texture(sprite.animation,sprite.frame)
	var growthAmount = Vector2(texture.get_width()/2,texture.get_height()/2)
	shape.position += growthAmount
	
