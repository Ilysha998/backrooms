# MonsterSpawner.gd
extends Node3D

@export var monster_scene: PackedScene
# @export var player: CharacterBody3D  <- ЭТА СТРОКА БОЛЬШЕ НЕ НУЖНА
@export var spawn_radius: float = 15.0
@export var spawn_interval: float = 20.0

# Переменная для хранения ссылки на игрока
var player_node: CharacterBody3D

func _ready():
	# --- ГЛАВНОЕ ИЗМЕНЕНИЕ ---
	# Получаем ссылку на родительский узел, который и является игроком.
	player_node = get_parent()
	
	# Проверка на случай, если структура сцены изменится в будущем.
	if not player_node is CharacterBody3D:
		printerr("Ошибка: Родительский узел MonsterSpawner - не CharacterBody3D!")
		return

	$Timer.wait_time = spawn_interval
	$Timer.timeout.connect(_on_timer_timeout)
	$Timer.start()

func _on_timer_timeout():
	# Проверяем, существует ли узел игрока и выключен ли у него фонарик
	if player_node and not player_node.flashlight.is_visible_in_tree():
		spawn_monster()
		
func spawn_monster():
	if not monster_scene or not player_node:
		return
		
	var monster = monster_scene.instantiate()
	
	# Передаем монстру ссылку на игрока
	monster.player = player_node
	
	# Генерируем случайную позицию вокруг игрока
	var spawn_offset = Vector3(
		randf_range(-spawn_radius, spawn_radius),
		0, # Спавним на той же высоте, что и игрок
		randf_range(-spawn_radius, spawn_radius)
	).normalized() * spawn_radius
	
	# Позиция считается относительно игрока
	var spawn_position = player_node.global_position + spawn_offset
	
	monster.global_position = spawn_position
	# Добавляем монстра как дочерний узел к игроку (станет "братом" спаунера)
	get_parent().add_child(monster)
