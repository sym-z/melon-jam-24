extends Node2D

var currentLetter = 0
var word = ""
func _ready() -> void:
	WordBank.loadFromFile(WordBank.textFile)
	word = getRandomWord(4)
	print(word)
	
func _process(delta: float) -> void:
	pass

	
func getRandomWord(length : int) -> String:
	var wordSet = WordBank.bank[length]
	var index = randi_range(0,wordSet.size()-1)
	return wordSet[index]

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_released():
			print(event)
			print(String.chr(event.keycode))
			if String.chr(event.keycode) == word[currentLetter]:
				print("CORRECT")
				if currentLetter < word.length() - 1:
					currentLetter+=1
				else:
					print("DONE!!")
			else:
				print("FALSE")
			
