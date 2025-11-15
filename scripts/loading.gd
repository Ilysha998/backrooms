extends Node


@onready var wall_spawner = $MapGenerator
@onready var lamp_spawner = $LampGenerator
@onready var item_spawner = $ItemsSpawner
@onready var loading_screen = $LoadingScreen

func _ready():
	# Запускаем асинхронный процесс загрузки
	start_loading_process()

# Ключевое слово 'async' позволяет использовать 'await' внутри функции
func start_loading_process():
	# 0. Показываем экран загрузки
	loading_screen.show()
	
	# 1. Генерация стен
	loading_screen.update_status("Генерация уровня...")
	# Подключаемся к сигналу прогресса
	wall_spawner.progress_updated.connect(loading_screen.update_progress)
	wall_spawner.generate_level() # Запускаем генерацию
	# Ждем, пока спавнер не отправит сигнал о завершении
	await wall_spawner.generation_finished 
	# Отключаемся, чтобы сигнал не влиял на другие этапы
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
	
	# Небольшая задержка для красоты
	await get_tree().create_timer(0.5).timeout 

	# 4. Завершение
	loading_screen.update_progress(1.0) # Устанавливаем 100%
	loading_screen.update_status("Готово!")
	
	await get_tree().create_timer(1.0).timeout # Показываем "Готово!" на секунду
	
	# Прячем экран загрузки
	loading_screen.hide()
	
	# Здесь можно включить управление игроком, запустить музыку и т.д.
	print("ЗАГРУЗКА ЗАВЕРШЕНА!")
