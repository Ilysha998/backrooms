extends Node3D

@export var water_bottle_scene: PackedScene
@export var stamina_bar_scene: PackedScene
@export var spawn_radius: float = 20.0
@export var spawn_interval: float = 10.0

var total_spawned_count: int = 0
var water_bottle_count: int = 0
var stamina_bar_count: int = 0

func _ready():
	if not water_bottle_scene:
		push_warning("Переменная 'water_bottle_scene' не назначена в инспекторе.")
	if not stamina_bar_scene:
		push_warning("Переменная 'stamina_bar_scene' не назначена в инспекторе.")

	$Timer.wait_time = spawn_interval
	$Timer.timeout.connect(_on_timer_timeout)
	$Timer.start()

func _on_timer_timeout():
	spawn_item()

func spawn_item():
	if not water_bottle_scene or not stamina_bar_scene:
		return

	var item_scene

	var random_value = randf()

	if random_value > 0.5:
		item_scene = water_bottle_scene
	else:
		item_scene = stamina_bar_scene
	
	
	if not item_scene:
		return
	
	var item = item_scene.instantiate()


	var random_position = Vector3(
		randf_range(-spawn_radius, spawn_radius),
		global_position.y,
		randf_range(-spawn_radius, spawn_radius)
	)

	var final_position = global_position + random_position
	
	get_parent().add_child(item)
	item.global_position = final_position
