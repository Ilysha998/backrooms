extends Node3D

@export var attack_speed: float = 9.0
@export var retreat_speed: float = 5.0
@export var ideal_distance: float = 20.0

var player = null
var initial_y: float

func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		print("ОШИБКА: Монстр (", self.name, ") не может найти игрока!")
		queue_free()
	
	initial_y = global_position.y

func _physics_process(delta):
	if not is_instance_valid(player):
		return

	var should_attack = false
	if player.has_method("get") and player.get("current_sanity") < 10:
		should_attack = true
	
	var direction = Vector3.ZERO
	var current_speed = 0.0
	
	if should_attack:
		current_speed = attack_speed
		direction = (player.global_position - global_position).normalized()
	else:
		current_speed = retreat_speed
		var distance_to_player = global_position.distance_to(player.global_position)
		
		if distance_to_player < ideal_distance:
			direction = (global_position - player.global_position).normalized()
		else:
			direction = Vector3.ZERO

	var look_at_target = player.global_position
	look_at_target.y = global_position.y
	look_at(look_at_target, Vector3.UP)
	
	if direction != Vector3.ZERO:
		global_position += direction * current_speed * delta
		global_position.y = initial_y

func _on_hitbox_body_entered(body):
	if body.has_method("die"):
		body.die()
