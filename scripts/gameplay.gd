class_name Gameplay extends Node3D

@onready var player_marble: PlayerControl = $PlayerMarble

func get_starting_positions() -> Array[StartPoint]:
	var result: Array[StartPoint] = []
	
	# I know this _could_ be slow, but if it somehow is we can address this, and we're only calling it once (twice?) right now
	var start_points = find_children("*", "StartPoint", true)
	result.assign(start_points)
	
	return result

func set_player_to_starting_position(player: PlayerControl, index: int = 0) -> void:
	var starting_positions := get_starting_positions()
	var start_point_to_use := starting_positions[index % starting_positions.size()]
	player.global_position = start_point_to_use.global_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_player_to_starting_position(player_marble, 1)
