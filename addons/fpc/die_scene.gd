extends Control

# Эта функция вызывается при нажатии кнопки перезапуска.
func _on_restart_button_pressed():
	# Сначала снимаем игру с паузы, чтобы перезагрузка сработала корректно.
	get_tree().paused = false
	# Перезагружаем текущую игровую сцену.
	get_tree().reload_current_scene()

# Эта функция вызывается при нажатии кнопки меню.
func _on_menu_button_pressed():
	# Снимаем игру с паузы перед переходом в другую сцену.
	get_tree().paused = false
	# Переходим к сцене главного меню.
	get_tree().change_scene_to_file("res://scenes/mmscene.tscn")
