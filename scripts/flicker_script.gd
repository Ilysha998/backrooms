extends Node

var light_nodes: Array[Light3D] = []
var original_energies: Dictionary = {}

var flicker_timer: Timer

func _ready():
	var parent = get_parent()
	if not is_instance_valid(parent):
		queue_free()
		return

	for sibling in parent.get_children():
		if sibling is Light3D:
			light_nodes.append(sibling)
			original_energies[sibling] = sibling.light_energy
			
	if light_nodes.is_empty():
		print("Скрипт мигания не нашел ни одного узла типа Light3D. Самоудаление.")
		queue_free()
		return
		
	# Создаем и настраиваем ЕДИНЫЙ таймер
	flicker_timer = Timer.new()
	flicker_timer.wait_time = randf_range(0.05, 0.3)
	flicker_timer.timeout.connect(_on_flicker_timer_timeout)
	add_child(flicker_timer)
	flicker_timer.start()

func _on_flicker_timer_timeout():
	if light_nodes.is_empty():
		queue_free()
		return
		
	var is_currently_on = light_nodes[0].light_energy > 0
	
	var new_energy_value = 0.0
	
	if is_currently_on:
		if randf() > 0.3:
			new_energy_value = 0.0
		else:
			pass
	else:
		if randf() > 0.7:
			pass
		else:
			new_energy_value = 0.0
	
	for light_node in light_nodes:
		if not is_instance_valid(light_node):
			continue
		
		if new_energy_value == 0.0 and is_currently_on:
			light_node.light_energy = 0.0
		elif not is_currently_on and randf() > 0.7:
			light_node.light_energy = original_energies[light_node]

	
	flicker_timer.wait_time = randf_range(0.05, 0.4)
	flicker_timer.start()
