extends Node3D

signal progress_updated(percentage) # Отправляет прогресс (0.0 до 1.0)
signal generation_finished() 

@export var room_prefabs: Array[PackedScene]

# Размеры карты в "ячейках". Например, 20x20 = 400 возможных мест.
@export var map_bounds: Vector2i = Vector2i(20, 20)

# Физический размер одной ячейки в мире Godot. 
# Должен быть больше размера комнаты, чтобы между ними было пространство.
@export var cell_size: Vector2i = Vector2i(30, 30)

# Шанс (от 0.0 до 1.0), что в ячейке появится комната. 0.25 = 25%
@export_range(0.0, 1.0) var spawn_chance: float = 0.5

# --- Внутренние переменные ---
var rng = RandomNumberGenerator.new()

# --- Основная функция ---
func _ready():
	# Инициализация RNG с новым сидом для уникальной генерации при каждом запуске.
	rng.randomize()
	print("Generation seed: ", rng.get_seed())
	
	# Перед генерацией очистим все, что могло быть создано ранее.
	for child in get_children():
		child.queue_free()
		
	#generate_level()

# --- Логика генерации ---
func generate_level():
	if room_prefabs.is_empty():
		push_warning("Массив 'Room Prefabs' пуст! Генерация невозможна.")
		emit_signal("generation_finished") # Сразу завершаем, если нечего делать
		return

	# Очистка перед генерацией
	for child in get_children():
		child.queue_free()
		
	var total_cells = map_bounds.x * map_bounds.y
	var processed_cells = 0
	
	# Проходим по каждой ячейке
	for x in range(map_bounds.x):
		for y in range(map_bounds.y):
			if rng.randf() < spawn_chance:
				# Если шанс сработал, выбираем СЛУЧАЙНУЮ комнату из всего пула.
				var random_room_scene = room_prefabs.pick_random()
				
				# Создаем (инстанциируем) комнату.
				var room_instance = random_room_scene.instantiate()
				
				# Рассчитываем позицию в мировых координатах.
				# Можно добавить небольшой случайный сдвиг для большей естественности.
				var offset_x = (rng.randf() - 0.5) * 2.0 # Случайный сдвиг до 2.5 юнитов
				var offset_z = (rng.randf() - 0.5) * 2.0
				var world_pos = Vector3(x * cell_size.x + offset_x, 0, y * cell_size.y + offset_z)
				
				# Применяем рассчитанную позицию.
				room_instance.position = world_pos
				
				# Применяем случайный поворот вокруг вертикальной оси (Y).
				# TAU - это константа в Godot 4, равная 2 * PI (полный круг).
				#room_instance.rotate_y(rng.randf() * TAU) 
				
				# Добавляем созданную комнату на сцену.
				add_child(room_instance)
			if rng.randf() < spawn_chance:
				var random_room_scene = room_prefabs.pick_random()
				var room_instance = random_room_scene.instantiate()
				var offset_x = (rng.randf() - 0.5) * 2.0
				var offset_z = (rng.randf() - 0.5) * 2.0
				var world_pos = Vector3(x * cell_size.x + offset_x, 0, y * cell_size.y + offset_z)
				room_instance.position = world_pos
				add_child(room_instance)
			
			processed_cells += 1
			
			# ЖДЕМ СЛЕДУЮЩЕГО КАДРА каждые 25 ячеек, чтобы не заморозить игру
			if processed_cells % 25 == 0:
				# Обновляем прогресс
				emit_signal("progress_updated", float(processed_cells) / total_cells)
				# Эта строка - ключ к асинхронности. Она приостанавливает выполнение функции
				# до следующего кадра, позволяя движку обновить экран.
				await get_tree().process_frame

	print("Generation complete! Total rooms spawned: ", get_child_count())
	emit_signal("generation_finished")
