class_name AnnounceZone extends Area3D

@export var delete_on_announce: bool = true

@export_multiline var text_to_show: String = "<undecided>"

func _on_player_enetered(_intruder: Node3D) -> void:
	get_tree().call_group("listen_for_announce", "show_announcement", text_to_show)
	
	if delete_on_announce:
		queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Don't be visible to anything
	collision_layer = 0
	monitorable = false
	
	# Look for players
	collision_mask = 1 << 1
	
	body_entered.connect(_on_player_enetered)
