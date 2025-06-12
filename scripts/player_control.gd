class_name PlayerControl extends RigidBody3D

@export var input_strength: float = 200.0

@export var max_velocity: Vector3 = Vector3(3.0, 999.0, 3.0)

@export var jump_force: float = 5.0

func get_input_velocity(delta: float) -> Vector3:
	var current_viewport := get_viewport()
	if current_viewport == null:
		return Vector3.ZERO
		
	var current_camera := current_viewport.get_camera_3d()
	if current_camera == null:
		return Vector3.ZERO
		
	var directional_input := Vector3(Input.get_axis("move_left", "move_right"), 0.0, Input.get_axis("move_backward", "move_forward"))
	if directional_input.is_zero_approx():
		return Vector3.ZERO
		
	# Cameras look backwards in Godot, so we need to flip this for sanity's sake
	directional_input.z = directional_input.z * -1.0
		
	# Sorry about the dorky variable names this could be better lol
	var directional_input_magnitude: float = directional_input.length()
	var directional_input_in_camera_space: Vector3 = current_camera.global_basis * directional_input
	var flattened_normalized_directional_input_in_camera_space := Vector3(directional_input_in_camera_space.x, 0.0, directional_input_in_camera_space.z).normalized()
	
	var final_directional_input: Vector3 = directional_input_magnitude * flattened_normalized_directional_input_in_camera_space
	
	return final_directional_input * input_strength * delta

func _integrate_forces(_state: PhysicsDirectBodyState3D) -> void:
	linear_velocity = linear_velocity.clamp(-max_velocity, max_velocity)

func _physics_process(delta: float) -> void:
	if global_position.y < 0.0:
		get_tree().call_group_flags(SceneTree.GROUP_CALL_DEFERRED, "listen_for_level_change", "reset_current_level")
		return
	
	var input_velocity: Vector3 = get_input_velocity(delta)
	constant_force = input_velocity
	
	if Input.is_action_just_pressed("ui_accept"):
		apply_impulse(Vector3.UP * jump_force)
