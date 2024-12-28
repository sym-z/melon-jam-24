extends Node2D

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
var word = ""
enum SPAWN{WEST,NORTH,EAST,SOUTH}
var currentSpawn : CollisionShape2D
var currentSpawnIndex = SPAWN.WEST
func _ready() -> void:
	WordBank.loadFromFile(WordBank.textFile)
	word = getRandomWord()
	currentSpawn = westSpawnZone
	makeMassesFromWord(word)
	print(word)
	
func _process(delta: float) -> void:
	pass

func makeMassesFromWord(word :String):	
	for letter in word:
		var box = currentSpawn.shape.get_rect()
		var startBox : Vector2 = currentSpawn.global_position
		var endBox : Vector2 = currentSpawn.global_position + currentSpawn.shape.size
		var yVal = randi_range(startBox.y,endBox.y)
		var xVal = randi_range(startBox.x,endBox.x)
		var inst = massScene.instantiate();
		inst.startLoc = Vector2(xVal,yVal)
		massParent.add_child(inst)
		print(currentSpawnIndex)
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
	var length = randi_range(1, WordBank.LEVELS)
	var wordSet = WordBank.bank[length]
	var index = randi_range(0,wordSet.size()-1)
	return wordSet[index]

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_released():
			if String.chr(event.keycode) == word[currentLetter]:
				print("CORRECT")
				if currentLetter < word.length() - 1:
					currentLetter+=1
					massParent.remove_child(massParent.get_child(0))
				else:
					print("DONE!!")
					massParent.remove_child(massParent.get_child(0))
			else:
				print("FALSE")
			
