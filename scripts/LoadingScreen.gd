extends Control

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var status_label: Label = $Label

func _ready():
	# Сбрасываем значения при запуске
	progress_bar.value = 0
	status_label.text = "Загрузка..."
	hide() # Скрываем экран по умолчанию

# Функция для обновления статуса
func update_status(text: String):
	status_label.text = text
	print("Статус загрузки: ", text)

# Функция для обновления прогресс-бара (значение от 0 до 1)
func update_progress(progress: float):
	progress_bar.value = progress * 100 # ProgressBar ожидает значение от 0 до 100
