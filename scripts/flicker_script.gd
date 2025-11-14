# FlickerController.gd
extends Node3D

@export var lamp_on_scene: PackedScene
@export var lamp_off_scene: PackedScene

var current_lamp_node: Node
var is_on = true

@onready var timer = $Timer

func _ready():
	# При запуске создаем включенную лампу
	spawn_lamp(lamp_on_scene)
	timer.start()

func _on_timer_timeout():
	# Меняем состояние
	is_on = not is_on
	if is_on:
		spawn_lamp(lamp_on_scene)
	else:
		spawn_lamp(lamp_off_scene)
		
	# Устанавливаем случайное время для следующего мигания
	timer.wait_time = randf_range(0.05, 0.4)

func spawn_lamp(scene: PackedScene):
	# Удаляем старую лампу, если она есть
	if is_instance_valid(current_lamp_node):
		current_lamp_node.queue_free()
	
	# Создаем и добавляем новую
	if scene:
		current_lamp_node = scene.instantiate()
		add_child(current_lamp_node)
