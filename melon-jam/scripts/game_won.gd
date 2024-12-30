extends Control
@export var scoreText : RichTextLabel
@export var mistakesText : RichTextLabel

func _ready():
	scoreText.text = Globals.centerString("score: " + str(Globals.score)+"$")
	mistakesText.text = Globals.centerString("mistakes: " + str(Globals.mistakes))

func _on_continue_button_button_up():
	call_deferred("next_scene")

func next_scene():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
