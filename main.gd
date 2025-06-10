class_name Main extends Node

var current_stage: Gameplay = null
@onready var gameplay_prefab: PackedScene = preload("res://gameplay.tscn")

func clear_current_level() -> void:
	assert(current_stage != null, "Trying to clear a stage when none is currently loaded")
	current_stage.queue_free()
	remove_child(current_stage)
	current_stage = null

func load_level(level_name: String) -> void:
	assert(current_stage == null, "Trying to load a new level when we already have one loaded")
	var level_path: String = "levels/%s.tscn" % level_name
	var level_to_load: PackedScene = load(level_path)
	current_stage = gameplay_prefab.instantiate()
	add_child(current_stage)
	current_stage.setup_level(level_to_load)
	
func _ready() -> void:
	load_level("test_level")
	clear_current_level()
	load_level("test_level")
