extends Node3D

@export var wall_scene: PackedScene

func _ready():
	randomize_plane_size()
	spawn_obstacles()

func randomize_plane_size():
	var plane_size = randf_range(Globals.plane_min_size, Globals.plane_max_size)
	
	# Update plane mesh size
	var floor_mesh = $Floor/MeshInstance3D
	if floor_mesh and floor_mesh.mesh:
		floor_mesh.mesh.size = Vector2(plane_size, plane_size)
	
	# Update collision shape size
	var floor_collision = $Floor/CollisionShape3D
	if floor_collision and floor_collision.shape:
		floor_collision.shape.size = Vector3(plane_size, 0.2, plane_size)
	
	# Update enemy spawner radius to match plane size
	var enemy_spawner = $EnemySpawner
	if enemy_spawner:
		enemy_spawner.spawn_radius = plane_size * 0.4  # 40% of plane size

func spawn_obstacles():
	if not wall_scene:
		push_error("Wall scene not assigned!")
		return
	
	var player = get_tree().get_first_node_in_group("player")
	var plane_size = $Floor/MeshInstance3D.mesh.size.x
	var half_size = plane_size * 0.5
	
	for i in range(Globals.nb_obstacles):
		var wall = wall_scene.instantiate()
		
		# Generate random position on the plane
		var spawn_pos = Vector3.ZERO
		var valid_position = false
		var attempts = 0
		
		while not valid_position and attempts < 50:
			spawn_pos.x = randf_range(-half_size + 1, half_size - 1)
			spawn_pos.z = randf_range(-half_size + 1, half_size - 1)
			spawn_pos.y = 0
			
			# Check distance from player (at least 4 units)
			var distance_from_player = spawn_pos.distance_to(player.global_position)
			if distance_from_player >= 4.0:
				valid_position = true
			
			attempts += 1
		
		wall.global_position = spawn_pos
		
		# Random rotation for variety
		wall.rotation.y = randf_range(0, 2 * PI)
		
		add_child(wall)
