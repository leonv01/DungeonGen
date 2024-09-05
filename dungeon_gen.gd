extends Node

@export var min_room_size: int = 3
@export var max_room_size: int = 5
@export var dungeon_width: int = 20
@export var dungeon_height: int = 20
@export var seed: int = 0 : 
	get:
		return rng.seed
	set(value): 
		rng.seed = seed
@export var room_count: int = 0 :
	set(value):
		room_count = value

@onready var grid_map: GridMap = $GridMap



var rooms: Array = []
var rng = RandomNumberGenerator.new()

const HALLWAY_TILE: int = 0
const BORDER_TILE: int = 1
const DOOR_TILE: int = 2
const ROOM_TILE: int = 3

func _ready() -> void:
	if not grid_map:
		print("null")

func generate_dungeon() -> void:
	generate_rooms()
	pass

func generate_rooms() -> void:
	rooms.clear()
	grid_map.clear()
	
	for i in range(room_count):
		var room_width: int = rng.randi_range(min_room_size, max_room_size)
		var room_height: int = rng.randi_range(min_room_size, max_room_size)
		var room_x = rng.randi_range(0, dungeon_width - room_width)
		var room_y = rng.randi_range(0, dungeon_height - room_height)
		
		if is_valid_room(room_x, room_y, room_width, room_height):
			rooms.append(Rect2(room_x, room_y, room_width, room_height))
			place_room(room_x, room_y, room_width, room_height)

func is_valid_room(x: int, y: int, width: int, height: int) -> bool:
	for room in rooms:
		if Rect2(x, y, width, height).intersects(room):
			return false
	return true
	
func place_room(x: int, y: int, width: int, height: int) -> void:
	for _x in range(width):
		for _y in range(height):
			if _x == 0 or _x == width - 1 or _y == 0 or _y == height - 1:
				grid_map.set_cell_item(Vector3i(x + _x, 0, y + _y), BORDER_TILE)
			else:
				grid_map.set_cell_item(Vector3i(x + _x, 0, y + _y), ROOM_TILE)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("refresh"):
		generate_dungeon()
