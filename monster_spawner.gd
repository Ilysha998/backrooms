# MonsterSpawner.gd
extends Node3D

@export var monster_scene: PackedScene
@export var player: CharacterBody3D
@export var spawn_radius: float = 15.0
@export var spawn_interval: float = 20.0 # Монстр появляется реже

# Узел, который будет использоваться для проверки темноты
@export var darkness_check_point: Node3D 

func _ready():
	$Timer.wait_time = spawn_interval
	$Timer.timeout.connect(_on_timer_timeout)
	$Timer.start()

func _on_timer_timeout():
	# Пытаемся заспавнить монстра только если игрок в темноте
	# Простая проверка: если фонарик выключен
	if player and not player.flashlight.is_visible_in_tree():
		spawn_monster()
		
func spawn_monster():
	if not monster_scene or not player:
		return
		
	var monster = monster_scene.instantiate()
	
	# Задаем ссылку на игрока для монстра
	monster.player = player
	
	# Генерируем случайную позицию вокруг игрока
	var spawn_offset = Vector3(
		randf_range(-spawn_radius, spawn_radius),
		player.global_position.y, # На высоте игрока
		randf_range(-spawn_radius, spawn_radius)
	).normalized() * spawn_radius
	
	var spawn_position = player.global_position + spawn_offset
	
	monster.global_position = spawn_position
	get_parent().add_child(monster)
