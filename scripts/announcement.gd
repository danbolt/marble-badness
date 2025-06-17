class_name Announcement extends Control

@onready var label: Label = $Label

var text: String:
	set(value):
		label.text = value
	get:
		return label.text
		
func reveal_text(text_to_show: String) -> void:
	text = text_to_show
	visible = true
	wait_then_hide.call_deferred(clamp(text_to_show.length() * 0.1, 2.0, 6.0))
	
func wait_then_hide(duration: float) -> void:
	var wait_timer := get_tree().create_timer(duration, false, true)
	await wait_timer.timeout
	queue_free()

func _ready() -> void:
	visible = false
