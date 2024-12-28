extends Node2D

## Holds a reference to the player.
@export var player : Node2D

## Holds all the instances of masses
@export var massParent : Node2D

## Where the letters spawn in
@export var westSpawnZone : CollisionShape2D
@export var northSpawnZone : CollisionShape2D
@export var eastSpawnZone : CollisionShape2D
@export var southSpawnZone : CollisionShape2D

## For instantiating and referencing
var massScene = preload("res://scenes/mass.tscn")
var playerScene = preload("res://scenes/player.tscn")

## What word, letter and level the player is on
var currentLetter = 0
var currentWord = ""
var currLevel = 1

## Dictating spawn zones for masses
enum SPAWN{WEST,NORTH,EAST,SOUTH}
var currentSpawn : CollisionShape2D
var currentSpawnIndex = SPAWN.WEST

## How many words the player needs to type to go to the next planet
var wordsPerGrow : int = 3
## What word the player is on within the current planet level
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
	
func removeMass():
	for child in massParent.get_children():
		massParent.remove_child(child)
	if currentLetter >= currentWord.length():
		newWord()
		for mass in massParent.get_children():
			mass.sprite.frame = currLevel - 1

var tween : Tween
var tweenDur : float = 0.15
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_released():
			# Prevent keyboard mashing
			if currentLetter < currentWord.length() and String.chr(event.keycode) == currentWord[currentLetter]:
				print("CORRECT")
				currentLetter+=1
				if currentLetter < currentWord.length():
					## TODO: COOL ANIMATION TO SHOW LETTER WAS CORRECT
					pass
				else:
					print("DONE!!")
					if(massParent.get_child_count()):
						tween = create_tween()
						var childArr = massParent.get_children()
						for i in range(childArr.size()):
							tween.tween_property(childArr[i].sprite,"global_position",player.global_position,tweenDur)
							if i == childArr.size()-1:
								tween.connect("finished", removeMass)
			else:
				print("FALSE")
