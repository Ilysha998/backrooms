extends Control

# Эта функция вызывается при нажатии кнопки меню.
func _on_menu_button_pressed():
	# Снимаем игру с паузы перед переходом в другую сцену.
	get_tree().paused = false
	# Переходим к сцене главного меню.
	get_tree().change_scene_to_file("res://scenes/mmscene.tscn")


func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	hide()
