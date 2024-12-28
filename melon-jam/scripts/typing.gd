extends Node2D

@export var player : Node2D

## Holds all the instances of masses
@export var massParent : Node2D

## Where the letters spawn in
@export var westSpawnZone : CollisionShape2D
@export var northSpawnZone : CollisionShape2D
@export var eastSpawnZone : CollisionShape2D
@export var southSpawnZone : CollisionShape2D

var massScene = preload("res://scenes/mass.tscn")
var playerScene = preload("res://scenes/player.tscn")

var currentLetter = 0
var currentWord = ""
var currLevel = 1
enum SPAWN{WEST,NORTH,EAST,SOUTH}
var currentSpawn : CollisionShape2D
var currentSpawnIndex = SPAWN.WEST

var wordsPerGrow : int = 3
var wordNum : int = 0
func _ready() -> void:
	WordBank.loadFromFile(WordBank.textFile)
	currentSpawn = westSpawnZone
	newWord()

func newWord():
	wordNum+=1
	if wordNum > wordsPerGrow:
		currLevel += 1
	currentLetter = 0
	currentWord = getRandomWord()
	makeMassesFromWord(currentWord)
	# Transform if the player has made enough words
	if wordNum > wordsPerGrow:
		wordNum=1
		player.sprite.frame = currLevel
		var childrenMasses = massParent.get_children()

		
	print(currentWord)
func makeMassesFromWord(word :String):
	for letter in word:
		var box = currentSpawn.shape.get_rect()
		var startBox : Vector2 = currentSpawn.global_position - currentSpawn.shape.size/2
		var endBox : Vector2 = currentSpawn.global_position + currentSpawn.shape.size /2
		var yVal = randi_range(startBox.y,endBox.y)
		var xVal = randi_range(startBox.x,endBox.x)
		var inst = massScene.instantiate();
		inst.startLoc = Vector2(xVal,yVal)
		massParent.add_child(inst)
		getNextSpawn()

func getNextSpawn():
	match currentSpawnIndex:
		SPAWN.WEST:
			currentSpawn = northSpawnZone
			currentSpawnIndex = SPAWN.NORTH
		SPAWN.NORTH:
			currentSpawn = eastSpawnZone
			currentSpawnIndex = SPAWN.EAST
		SPAWN.EAST:
			currentSpawn = southSpawnZone
			currentSpawnIndex = SPAWN.SOUTH
		SPAWN.SOUTH:
			currentSpawn = westSpawnZone
			currentSpawnIndex = SPAWN.WEST
			
func getRandomWord() -> String:
	# Get random word length
	var length = randi_range(1, WordBank.LEVELS)
	# Grab list of words of that length
	var wordSet = WordBank.bank[currLevel]
	# Choose a random word from that list
	var index = randi_range(0,wordSet.size()-1)
	return wordSet[index]

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_released():
			if String.chr(event.keycode) == currentWord[currentLetter]:
				print("CORRECT")
				if currentLetter < currentWord.length() - 1:
					currentLetter+=1
					massParent.remove_child(massParent.get_child(0))
				else:
					print("DONE!!")
					massParent.remove_child(massParent.get_child(0))
					newWord()
					for mass in massParent.get_children():
						mass.sprite.frame = currLevel - 1
			else:
				print("FALSE")
			
