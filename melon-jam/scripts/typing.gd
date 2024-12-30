extends Node2D

## Holds a reference to the player.
@export var player : Node2D

## Holds all the instances of masses
@export var massParent : Node2D
## Holds all UI
@export var uiParent : Control
@export var wordContainer : HBoxContainer
@export var timerLabel : RichTextLabel
@export var timerOverlay: CenterContainer

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
var bh : CircleShape2D = preload("res://shapes/blackhole.tres")
var COLL_SHAPES = [sd,ast,moon,plut,merc,mars,vens,erth,nept,urns,sat,jup,sun,bh]

## Tracks player progress
@export var timer : Timer
## How many seconds are on the timer when the game starts
@export var startingSeconds : float = 4.0
## How much time is awarded when a word is fully typed
@export var secondsPerWord : float = 1.0
## How much time is awarded when a level is fully completed
@export var secondsPerLevel : float = 3.0
## How much time is deducted when an erroneous keystroke happens
@export var timePenalty : float = 0.5;
## The text label that shows the remaining time
@export var timeLabel : RichTextLabel
## Time in seconds deducted per level increase
@export var scalingPenalty : float = 0.5
## Keeps track of time during pause
var backupTimeLabel : String

var gameWon: bool = false
func _ready() -> void:
	timer.wait_time = startingSeconds
	WordBank.loadFromFile(WordBank.textFile)
	currentSpawn = westSpawnZone
	newWord()
	timer.start()
	
func _process(delta):

	if floor(timer.wait_time) > Globals.score:
		Globals.score = floor(timer.wait_time)
		print(Globals.score)
	var timeText : String = str(floor(timer.time_left))
	if !timer.is_stopped():
		timeLabel.text = "\n" + Globals.centerString(timeText)
		backupTimeLabel = timeText
	else:
		timeLabel.text = "\n" + Globals.centerString(backupTimeLabel)

func newWord():
	wordNum+=1
	# MOVE TO NEXT PLANET
	if wordNum > wordsPerGrow:
		timer.set_wait_time(timer.wait_time + secondsPerLevel)
		print("timer big bump")
	else:
		timer.set_wait_time(timer.wait_time + secondsPerWord)
		print("timer small bump")
	currentLetter = 0
	currentWord = getRandomWord()
	makeMassesFromWord(currentWord)
	wordLabel.text = Globals.centerString(currentWord.to_lower())
	# Transform if the player has made enough words
	if wordNum > wordsPerGrow:
		wordNum=1
		player.sprite.frame = currLevel
		player.shape.shape = COLL_SHAPES[currLevel]
	for mass in massParent.get_children():
			mass.sprite.frame = currLevel - 1
			mass.shape.shape = COLL_SHAPES[currLevel-1]
			mass.adjustOffset()
			if !gameWon:
				mass.sprite.visible = true
	print(currentWord)
	
# For each letter in word, make a mass in the current spawn box.
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
	if !gameWon:
		for child in massParent.get_children():
			massParent.remove_child(child)
		if currentLetter >= currentWord.length() and !gameWon:
			newWord()
			# resume timer after new word is made, with time left remaining
			timer.start(timer.time_left)
	


var tween : Tween
@export var tweenDur : float = 0.15
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_released():
			# Prevent keyboard mashing
			if currentLetter < currentWord.length() and String.chr(event.keycode) == currentWord[currentLetter]:
				print("CORRECT")
				currentLetter+=1
				wordLabel.text = Globals.centerString(currentWord.to_lower().erase(0,currentLetter))
				if currentLetter < currentWord.length():
					## TODO: COOL ANIMATION OR SOUND TO SHOW LETTER WAS CORRECT
					pass
				else:
					#print("WORD NUM" + str(wordNum))
					#print("WPG: " + str(wordsPerGrow))
					if wordNum >= wordsPerGrow:
						currLevel += 1
					print("DONE!!")
					if currLevel > WordBank.LEVELS:
						gameWon = true
						pullUI()
					# TODO IF GAME IS NOT WON
					# Pause timer for animation
					timer.stop()
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
							if i == childArr.size()-1 and !gameWon:
								tween.connect("finished", removeMass)
			else:
				print("FALSE")
				Globals.mistakes += 1
				# Make the penalty increase per level (0.5 sec per level) 
				# (currLevel-1)/(1/secondsPerLevel)
				# 1/0.5 = 2
				# Level 1 tP + (1-1)/2 -> tP
				# Level 2 tP + (2-1)/2 -> tP + 0.5
				# Level 3 tP + (3-1)/2 -> tP + 1
				# ...
				var penaltyTime : float = timer.time_left - (timePenalty+(currLevel-1)/(1/scalingPenalty))
				if penaltyTime < 0:
					set_time(0.1)
				else:
					set_time(penaltyTime)
## Sets word timer to any value given
func set_time(sec : float):
	timer.stop()
	timer.set_wait_time(sec)
	timer.start(timer.time_left)
func _on_timer_timeout() -> void:
	print("GAME OVER!")
	call_deferred("loss_scene")

func win_scene():
	get_tree().change_scene_to_file("res://scenes/game_won.tscn")
func loss_scene():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func pullUI():
	var wordElements = wordContainer.get_children()
	var totalWordElements = wordElements.size()
	tween = create_tween().set_trans(Tween.TRANS_QUAD)
	var childArr = wordElements
	throwToCenter(timerLabel)
	tween.set_parallel()
	throwToCenter(wordLabel)
	
	for ele in wordContainer.get_children():
		throwToCenter(ele)
	tween.connect("finished", win_scene)


func throwToCenter(n : Node):
	var xDelta = n.size.x / 2
	var yDelta = n.size.y / 2
	var deltaVector : Vector2 = Vector2(xDelta,yDelta)
	tween.tween_property(n,"position",Globals.SCREEN_CENTER,tweenDur)
	tween.set_parallel()
	tween.tween_property(n,"scale",Vector2.ZERO,tweenDur)
# try new with global
