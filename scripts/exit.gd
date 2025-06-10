class_name Exit extends Area3D

## The level that will load in/out if the player enters this area
@export var level_key: String

## A temporary bit to show where an exit is
@onready var temp_mesh: Node = $TempMesh

func on_player_entered(_intruder: Node3D) -> void:
	if level_key.is_empty():
		push_warning("No level key found for %s" % get_path())
		return
	
	get_tree().call_group_flags(SceneTree.GROUP_CALL_DEFERRED, "listen_for_level_change", "level_transition", level_key)
	set_deferred("monitoring", false)

func _ready() -> void:
	body_entered.connect(on_player_entered)
	
func _process(delta: float) -> void:
	temp_mesh.rotate_y(delta * 4.0)
