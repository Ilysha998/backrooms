extends Node3D

@export var water_bottle_scene: PackedScene
@export var stamina_bar_scene: PackedScene
@export var spawn_radius: float = 20.0
@export var spawn_interval: float = 10.0
@export var max_spawn_attempts: int = 10 # Максимальное количество попыток найти свободное место

# --- Внутренние переменные ---
var total_spawned_count: int = 0
var water_bottle_count: int = 0
var stamina_bar_count: int = 0

func _ready():
	pass

func start_spawning():
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

	# Выбор сцены для спавна
	var item_scene = water_bottle_scene if randf() > 0.5 else stamina_bar_scene
	if not item_scene:
		return
	
	var space_state = get_world_3d().direct_space_state
	var spawn_position: Vector3
	var is_position_valid = false

	# Пытаемся найти свободную позицию несколько раз
	for i in range(max_spawn_attempts):
		# Расчет случайной позиции
		var random_position = Vector3(
			randf_range(-spawn_radius, spawn_radius),
			1.0, # Немного приподнимем точку проверки над полом
			randf_range(-spawn_radius, spawn_radius)
		)
		var final_position = global_position + random_position

		# Создаем параметры для проверки на пересечение
		var query = PhysicsShapeQueryParameters3D.new()
		# Мы будем проверять пересечение небольшой сферой.
		# Вы можете использовать BoxShape3D или другую форму.
		query.shape = SphereShape3D.new()
		query.shape.radius = 0.5 # Радиус должен быть примерно равен половине размера предмета
		query.transform = Transform3D(Basis(), final_position)
		# Указываем, что нужно проверять столкновение только с объектами из группы "walls"
		query.collision_mask = 2 # Предполагаем, что группа "walls" находится на 2-м физическом слое.
								 # Настройте это в Project Settings -> Physics -> 3D

		var intersecting_bodies = space_state.intersect_shape(query)

		# Если массив пересечений пуст, значит, место свободно
		if intersecting_bodies.is_empty():
			spawn_position = final_position
			is_position_valid = true
			break # Выходим из цикла, так как нашли подходящее место

	# Если после всех попыток свободное место найдено, спавним предмет
	if is_position_valid:
		var item = item_scene.instantiate()
		get_parent().add_child(item)
		item.global_position = spawn_position
	else:
		print("Не удалось найти свободное место для спавна предмета после %d попыток." % max_spawn_attempts)
