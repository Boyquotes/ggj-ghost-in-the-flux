extends Node3D

@export var ghost_scene: PackedScene
@export var spawn_radius: float = 8.0
@export var min_distance_from_player: float = 3.0

func _ready():
	# Defer spawning to ensure all nodes are properly initialized
	call_deferred("spawn_enemies")

func spawn_enemies():
	var player = get_tree().get_first_node_in_group("player")
	if player == null or not player.is_inside_tree():
		push_error("Player not found or not in tree!")
		return
	
	var num_enemies = Globals.num_enemies
	
	for i in range(num_enemies):
		var ghost = ghost_scene.instantiate()
		
		# Generate random position around the map
		var spawn_pos = Vector3.ZERO
		var valid_position = false
		var attempts = 0
		
		while not valid_position and attempts < 20:
			spawn_pos.x = randf_range(-spawn_radius, spawn_radius)
			spawn_pos.z = randf_range(-spawn_radius, spawn_radius)
			spawn_pos.y = 0
			
			# Check distance from player
			var distance_from_player = spawn_pos.distance_to(player.global_position)
			var valid_distance = distance_from_player >= min_distance_from_player
			
			# Check distance from obstacles
			var valid_obstacle_distance = true
			var obstacles = get_tree().get_nodes_in_group("obstacle")
			for obstacle in obstacles:
				var distance_from_obstacle = spawn_pos.distance_to(obstacle.global_position)
				if distance_from_obstacle < 2.0:  # Minimum 2 units from obstacles
					valid_obstacle_distance = false
					break
			
			if valid_distance and valid_obstacle_distance:
				valid_position = true
			
			attempts += 1
		
		ghost.position = spawn_pos
		add_child(ghost)
