extends Node

var SCREEN_X := 256
var SCREEN_Y := 240
var SCREEN_CENTER := Vector2(SCREEN_X/2,SCREEN_Y/2)
var score : int 
var mistakes : int = 0
## For using BBCode string formatting
func centerString(str : String) -> String:
	return "[center]"+str+"[/center]"
