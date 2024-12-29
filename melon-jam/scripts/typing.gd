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

## Text shown to player
@export var wordLabel : RichTextLabel

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

## Shapes of collision boxes
var sd : CircleShape2D = preload("res://shapes/stardust.tres")
var ast : CircleShape2D = preload("res://shapes/asteroid.tres")
var moon : CircleShape2D = preload("res://shapes/moon.tres")
var plut : CircleShape2D = preload("res://shapes/pluto.tres")
var merc : CircleShape2D = preload("res://shapes/mercury.tres")
var mars : CircleShape2D = preload("res://shapes/mars.tres")
var vens : CircleShape2D = preload("res://shapes/venus.tres")
var erth : CircleShape2D = preload("res://shapes/earth.tres")
var nept : CircleShape2D = preload("res://shapes/neptune.tres")
var urns : CircleShape2D = preload("res://shapes/uranus.tres")
var sat : CircleShape2D = preload("res://shapes/saturn.tres")
var jup : CircleShape2D = preload("res://shapes/jupiter.tres")
var sun : CircleShape2D = preload("res://shapes/sun.tres")
var COLL_SHAPES = [sd,ast,moon,plut,merc,mars,vens,erth,nept,urns,sat,jup,sun]
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
	wordLabel.text = "[center]"+currentWord.to_lower()+"[/center]"
	# Transform if the player has made enough words
	if wordNum > wordsPerGrow:
		wordNum=1
		player.sprite.frame = currLevel
		#player.changeRadius(currLevel)
		player.shape.shape = COLL_SHAPES[currLevel]
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
	# Prevent overflow
	if currLevel > WordBank.LEVELS:
		currLevel = WordBank.LEVELS
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
			mass.shape.shape = COLL_SHAPES[currLevel-1]
			mass.adjustOffset()
			mass.sprite.visible = true


var tween : Tween
@export var tweenDur : float = 0.15
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_released():
			# Prevent keyboard mashing
			if currentLetter < currentWord.length() and String.chr(event.keycode) == currentWord[currentLetter]:
				print("CORRECT")
				currentLetter+=1
				wordLabel.text = "[center]"+currentWord.to_lower().erase(0,currentLetter)+"[/center]"
				if currentLetter < currentWord.length():
					## TODO: COOL ANIMATION TO SHOW LETTER WAS CORRECT
					pass
				else:
					print("DONE!!")
					if(massParent.get_child_count()):
						tween = create_tween().set_trans(Tween.TRANS_QUAD)
						var childArr = massParent.get_children()
						for i in range(childArr.size()):
							# Make sure the center of the sprite is homing toward the center of the player
							var xDelta = childArr[i].sprite.sprite_frames.get_frame_texture(childArr[i].sprite.animation,childArr[i].sprite.frame).get_width() / 2
							var yDelta = childArr[i].sprite.sprite_frames.get_frame_texture(childArr[i].sprite.animation,childArr[i].sprite.frame).get_height() / 2
							var deltaVector : Vector2 = Vector2(xDelta,yDelta)
							tween.tween_property(childArr[i].sprite,"global_position",player.global_position-deltaVector,tweenDur)
							tween.set_parallel();
							tween.tween_property(childArr[i].shape,"global_position",player.global_position-deltaVector,tweenDur)
							if i == childArr.size()-1:
								tween.connect("finished", removeMass)
			else:
				print("FALSE")
