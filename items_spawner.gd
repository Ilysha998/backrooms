# ItemSpawner.gd
extends Node3D

@export var water_bottle_scene: PackedScene
@export var stamina_bar_scene: PackedScene
@export var spawn_radius: float = 20.0 # Радиус, в котором будут появляться предметы
@export var spawn_interval: float = 10.0 # Интервал спавна в секундах

func _ready():
	$Timer.wait_time = spawn_interval
	$Timer.timeout.connect(_on_timer_timeout)
	$Timer.start()

func _on_timer_timeout():
	spawn_item()

func spawn_item():
	if not water_bottle_scene or not stamina_bar_scene:
		return

	# Выбираем случайный предмет для спавна
	var item_scene = water_bottle_scene if randf() > 0.5 else stamina_bar_scene
	
	var item = item_scene.instantiate()
	
	# Генерируем случайную позицию в радиусе спавнера
	var random_position = Vector3(
		randf_range(-spawn_radius, spawn_radius),
		global_position.y, # Спавним на той же высоте, что и спавнер
		randf_range(-spawn_radius, spawn_radius)
	)
	
	item.global_position = global_position + random_position
	get_parent().add_child(item) # Добавляем предмет на главную сцену
