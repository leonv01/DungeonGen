extends Node

@export var min_room_size: int = 3
@export var max_room_size: int = 5
@export var dungeon_width: int = 20
@export var dungeon_height: int = 20
@export var seed: int = 0 : 
	## Seed Getter function
	## @return: seed
	get:
		return rng.seed
	## Seed Setter function
	## @param1: value - value of seed
	set(value): 
		rng.seed = seed
@export var room_count: int = 0 :
	set(value):
		room_count = value

@onready var grid_map: GridMap = $GridMap

## Array of added rooms
var rooms: Array = []
var rng = RandomNumberGenerator.new()

## Indexing elements of mesh library
const HALLWAY_TILE: int = 0
const BORDER_TILE: int = 1
const DOOR_TILE: int = 2
const ROOM_TILE: int = 3

func _ready() -> void:
	pass

## Generating dungeon
func generate_dungeon() -> void:
	generate_rooms()
	pass

## Generates rooms
func generate_rooms() -> void:
	# Clear all rooms from buffer
	rooms.clear()
	# Clear all instances from GridMap
	grid_map.clear()
	
	# For x-rooms that need to be generated
	for i in range(room_count):
		# Generate room width by random integer
		var room_width: int = rng.randi_range(min_room_size, max_room_size)
		# Generate room height by random integer (currently unused due to 2D generation)
		var room_height: int = rng.randi_range(min_room_size, max_room_size)
		# Generate room x position by random integer
		var room_x = rng.randi_range(0, dungeon_width - room_width)
		# Generate room y position by random integer
		var room_y = rng.randi_range(0, dungeon_height - room_height)
		
		# Check if room can be placed
		# If true: Append room to buffer and add room to GridMap
		# If false: Skip
		if is_valid_room(room_x, room_y, room_width, room_height):
			rooms.append(Rect2(room_x, room_y, room_width, room_height))
			place_room(room_x, room_y, room_width, room_height)

## Check function if room can be placed
## @param1: x-position of room
## @param2: y-position of room
## @param3: width of room
## @param4: height of room
## return: returns boolean value (true if can be placed, false if room can not be placed)
func is_valid_room(x: int, y: int, width: int, height: int) -> bool:
	# Check for each room in buffer
	for room in rooms:
		# Create a 2D-rectangle and check intersection with current room
		# If room intersects with any room: Stop comparing and return with false
		# Else: continue comparing
		if Rect2(x, y, width, height).intersects(room):
			return false
	return true

## Function for placing room in GridMap
## @param1: x-position of room
## @param2: y-position of room
## @param3: width of room
## @param4: height of room
func place_room(x: int, y: int, width: int, height: int) -> void:
	for _x in range(width):
		for _y in range(height):
			if _x == 0 or _x == width - 1 or _y == 0 or _y == height - 1:
				grid_map.set_cell_item(Vector3i(x + _x, 0, y + _y), BORDER_TILE)
			else:
				grid_map.set_cell_item(Vector3i(x + _x, 0, y + _y), ROOM_TILE)

## Function for handling user input
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("refresh"):
		generate_dungeon()
