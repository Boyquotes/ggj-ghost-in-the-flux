extends CharacterBody3D

@export var speed: float = 2.0
@export var detection_range: float = 20.0

var player: Node3D = null
@onready var ghost_model = $GhostModel
@onready var animation_player: AnimationPlayer = null

func _ready():
	# Find the player in the scene
	player = get_tree().get_first_node_in_group("player")
	
	# Find AnimationPlayer in the ghost model
	if ghost_model:
		animation_player = ghost_model.get_node_or_null("AnimationPlayer")
		if animation_player:
			# Play the first available animation in loop
			var animations = animation_player.get_animation_list()
			if animations.size() > 0:
				animation_player.play(animations[0])
				# Set loop mode for Godot 4
				var anim = animation_player.get_animation(animations[0])
				if anim:
					anim.loop_mode = Animation.LOOP_LINEAR
			else:
				push_warning("No animations found in ghost model")
		else:
			push_warning("No AnimationPlayer found in ghost model")

func _physics_process(delta: float) -> void:
	if player == null:
		return
	
	# Calculate distance to player
	var distance = global_position.distance_to(player.global_position)
	
	# Only move if player is within detection range
	if distance < detection_range:
		# Calculate direction to player
		var direction = (player.global_position - global_position).normalized()
		direction.y = 0  # Keep movement on XZ plane
		
		# Move toward player
		velocity = direction * speed
		move_and_slide()
		
		# Rotate ghost model to face AWAY from player (reverse facing)
		if ghost_model and direction.length() > 0:
			var away_direction = -direction  # Face opposite direction
			var target_position = global_position + away_direction * 10.0  # Look 10 units away
			ghost_model.look_at(target_position, Vector3.UP)
			ghost_model.rotation.x = 0
			ghost_model.rotation.z = 0
