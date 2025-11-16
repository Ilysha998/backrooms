# MonsterSpawner.gd
extends Node3D

@export var monster_scene: PackedScene
@export var spawn_radius: float = 15.0
@export var spawn_interval: float = 20.0

var player_node: CharacterBody3D

func _ready():
	player_node = get_parent()
	
	if not player_node is CharacterBody3D:
		printerr("Ошибка: Родительский узел MonsterSpawner - не CharacterBody3D!")
		return

	$Timer.wait_time = spawn_interval
	$Timer.timeout.connect(_on_timer_timeout)
	$Timer.start()

func _on_timer_timeout():
	if player_node and not player_node.flashlight.is_visible_in_tree():
		spawn_monster()
		
func spawn_monster():
	if not monster_scene or not player_node:
		return
		
	var monster = monster_scene.instantiate()
	
	monster.player = player_node
	
	var spawn_offset = Vector3(
		randf_range(-spawn_radius, spawn_radius),
		0,
		randf_range(-spawn_radius, spawn_radius)
	).normalized() * spawn_radius
	
	var spawn_position = player_node.global_position + spawn_offset
	
	monster.global_position = spawn_position
	get_parent().add_child(monster)
