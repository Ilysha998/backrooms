extends Control

func _on_restart_pressed() -> void:
	get_tree().paused = false
	hide()


func _on_menu_pressed() -> void:
	get_tree().paused = false
	# Переходим к сцене главного меню.
	get_tree().change_scene_to_file("res://scenes/mmscene.tscn")
