extends Control

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var status_label: Label = $Label

func _ready():
	progress_bar.value = 0
	status_label.text = "Загрузка..."
	hide()

func update_status(text: String):
	status_label.text = text
	print("Статус загрузки: ", text)

func update_progress(progress: float):
	progress_bar.value = progress * 100
