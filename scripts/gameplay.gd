class_name Gameplay extends Node3D

@onready var player_marble: PlayerControl = $PlayerMarble

@onready var gameplay_camera: PhantomCamera3D = $GameplayCamera

var jumps_available: int:
	get:
		return player_marble.current_number_of_jumps_available
		
var max_jumps_available: int:
	get:
		return player_marble.max_number_of_jumps

# This is assigned on level load
var level: Node = null

func get_starting_positions() -> Array[StartPoint]:
	var result: Array[StartPoint] = []
	
	# I know this _could_ be slow, but if it somehow is we can address this, and we're only calling it once (twice?) right now
	var start_points = level.find_children("*", "StartPoint", true)
	result.assign(start_points)
	
	return result

func set_player_to_starting_position(player: PlayerControl, index: int = 0) -> void:
	var starting_positions := get_starting_positions()
	assert(not starting_positions.is_empty(), "No starting positions found for this level")
	var start_point_to_use := starting_positions[index % starting_positions.size()]
	player.global_position = start_point_to_use.global_position

func setup_camera() -> void:
	gameplay_camera.set_follow_target(player_marble)
	gameplay_camera.set_look_at_target(player_marble)
	

func setup_level(level_to_setup: PackedScene) -> void:
	var new_level: Node = level_to_setup.instantiate()
	add_child(new_level)
	level = new_level
	
	setup_camera()
	set_player_to_starting_position(player_marble, 0)

	
