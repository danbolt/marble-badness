class_name StartPoint extends Node3D

@onready var label: Label3D = $Label3D

# Get rid of the start label if we're not in the editor
func _ready() -> void:
	if not Engine.is_editor_hint():
		label.queue_free()
