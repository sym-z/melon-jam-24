extends Node

@onready var textFile = 'res://text/wb.txt'
@onready var bank = {}
@onready var LEVELS = 13

func _ready() -> void:
	buildBank()
	
## Initialize empty bank
func buildBank():
	for num in range(1,LEVELS+1):
		bank[num] = []
	
func loadFromFile(text):
	var file = FileAccess.open(text, FileAccess.READ)
	var content = file.get_as_text()
	var arr = content.split("\n", false)
	parseWordArr(arr)

func parseWordArr(arr):
	for word in arr:
		word = word.c_unescape()
		if word.length():
			if word.length() > LEVELS:
				bank[LEVELS].append(word.to_upper())
			else:
				bank[word.length()].append(word.to_upper())

func printWordBank():
	print(bank)
