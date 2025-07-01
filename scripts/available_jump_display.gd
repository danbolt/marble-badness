class_name AvailableJumpDisplay extends Control

@onready var jump_display: HBoxContainer = $JumpDisplay
@onready var individual_jump_icon: PackedScene = preload("res://gameobjects/individual_jump_icon.tscn")

func refresh_jump_display(number_of_jumps: int, max_number_of_jumps: int) -> void:
	assert(max_number_of_jumps > 0, "Passed in a negative number of max jumps")
	
	if jump_display.get_child_count() != max_number_of_jumps:
		while jump_display.get_child_count() < max_number_of_jumps:
			var new_jump_icon: Control = individual_jump_icon.instantiate()
			jump_display.add_child(new_jump_icon)
		
		while jump_display.get_child_count() > max_number_of_jumps:
			jump_display.remove_child(jump_display.get_child(0))
		
	assert(jump_display.get_child_count() == max_number_of_jumps)
	
	for i in max_number_of_jumps:
		# TODO: Make this its own unique script and look
		var jump_item: ColorRect = jump_display.get_child(i) as ColorRect
		jump_item.color = Color.WHITE if i < number_of_jumps else Color.DIM_GRAY
