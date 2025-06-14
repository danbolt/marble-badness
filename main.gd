class_name Main extends Node

var current_stage: Gameplay = null
@onready var gameplay_prefab: PackedScene = preload("res://gameplay.tscn")

var current_stage_key: String = ""

var has_current_stage: bool:
	get:
		return current_stage != null

func reset_current_level() -> void:
	assert(not current_stage_key.is_empty(), "Trying to reset the current stage when we have no stage set")
	level_transition(current_stage_key)

func clear_current_level() -> void:
	assert(current_stage != null, "Trying to clear a stage when none is currently loaded")
	current_stage.queue_free()
	remove_child(current_stage)
	current_stage = null
	current_stage_key = ""

func load_level(level_name: String) -> void:
	assert(current_stage == null, "Trying to load a new level when we already have one loaded")
	var level_path: String = "levels/%s.tscn" % level_name
	var level_to_load: PackedScene = load(level_path)
	current_stage = gameplay_prefab.instantiate()
	add_child(current_stage)
	current_stage.setup_level(level_to_load)
	current_stage_key = level_name
	
func level_transition(level_name: String) -> void:
	if has_current_stage:
		clear_current_level()
	load_level(level_name)
	
func _ready() -> void:
	load_level("level_2")
