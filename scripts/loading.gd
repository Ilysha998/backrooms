extends Node

@onready var wall_spawner = $MapGenerator
@onready var lamp_spawner = $LampGenerator
@onready var item_spawner = $ItemsSpawner
@onready var loading_screen = $LoadingScreen

func _ready():
	start_loading_process()

func start_loading_process():
	# Замораживаем весь игровой мир. 
	get_tree().paused = true
	
	# 0. Показываем экран загрузки
	loading_screen.show()
	
	# 1. Генерация стен
	loading_screen.update_status("Генерация уровня...")
	wall_spawner.progress_updated.connect(loading_screen.update_progress)
	wall_spawner.generate_level()
	await wall_spawner.generation_finished 
	wall_spawner.progress_updated.disconnect(loading_screen.update_progress)

	# 2. Генерация ламп
	loading_screen.update_status("Расстановка освещения...")
	lamp_spawner.progress_updated.connect(loading_screen.update_progress)
	lamp_spawner.generate_lamps()
	await lamp_spawner.generation_finished
	lamp_spawner.progress_updated.disconnect(loading_screen.update_progress)

	# 3. Запускаем спавнер предметов
	loading_screen.update_status("Подготовка...")
	item_spawner.start_spawning()
	
	await get_tree().create_timer(0.5).timeout 

	# 4. Завершение
	loading_screen.update_progress(1.0)
	loading_screen.update_status("Готово!")
	
	await get_tree().create_timer(1.0).timeout
	
	# Прячем экран загрузки
	loading_screen.hide()
	
	# --- ШАГ 2: ВЫКЛЮЧАЕМ ПАУЗУ ---
	# "Размораживаем" игру. Теперь лампы начнут мигать, физика заработает.
	get_tree().paused = false
	
	# Здесь можно включить управление игроком, запустить музыку и т.д.
	print("ЗАГРУЗКА ЗАВЕРШЕНА!")
