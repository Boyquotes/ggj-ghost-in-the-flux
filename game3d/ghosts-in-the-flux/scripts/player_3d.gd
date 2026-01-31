extends CharacterBody3D

# Movement parameters
@export var speed: float = 5.0
@export var acceleration: float = 10.0
@export var friction: float = 10.0
@export var deadzone: float = 0.2

func _physics_process(delta: float) -> void:
	# Initialize input values
	var input_x := 0.0
	var input_z := 0.0
	
	# Check D-pad first (gamepad arrows)
	if Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_LEFT):
		input_x = -1.0
	elif Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_RIGHT):
		input_x = 1.0
	else:
		# Check analog stick with deadzone
		var joy_x = Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
		if abs(joy_x) > deadzone:
			input_x = joy_x
		
		# Keyboard overrides analog stick
		if Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT):
			input_x = -1.0
		elif Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT):
			input_x = 1.0
	
	if Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_UP):
		input_z = -1.0
	elif Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_DOWN):
		input_z = 1.0
	else:
		# Check analog stick with deadzone
		var joy_z = Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
		if abs(joy_z) > deadzone:
			input_z = joy_z
		
		# Keyboard overrides analog stick
		if Input.is_physical_key_pressed(KEY_W) or Input.is_physical_key_pressed(KEY_UP):
			input_z = -1.0
		elif Input.is_physical_key_pressed(KEY_S) or Input.is_physical_key_pressed(KEY_DOWN):
			input_z = 1.0
	
	# Calculate movement direction in 3D space (XZ plane)
	var direction := Vector3(input_x, 0, input_z).normalized()
	
	if direction:
		# Apply acceleration when moving
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration * delta)
		velocity.z = move_toward(velocity.z, direction.z * speed, acceleration * delta)
	else:
		# Apply friction when not moving
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		velocity.z = move_toward(velocity.z, 0, friction * delta)
	
	# Apply gravity
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	else:
		velocity.y = 0
	
	move_and_slide()
	
	# Get current plane size from the floor mesh
	var plane_size = 20.0  # default fallback
	var floor_mesh = get_tree().get_first_node_in_group("floor")
	if floor_mesh and floor_mesh is MeshInstance3D and floor_mesh.mesh:
		plane_size = floor_mesh.mesh.size.x
	
	# Clamp position to stay within plane boundaries
	var half_size = plane_size * 0.5
	position.x = clamp(position.x, -half_size, half_size)
	position.z = clamp(position.z, -half_size, half_size)
