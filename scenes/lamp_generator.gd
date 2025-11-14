extends Node3D

@export var lamp_scene: PackedScene
@export var start_position = Vector2(-500, -500)
@export var grid_size = Vector2i(10, 10)
@export var spacing: float = 5.0
@export var position_offset: float = 2.0
@export var lamp_y_position: float = 5.0

@export_range(0, 1) var broken_chance: float = 0.1
@export_range(0, 1) var flicker_chance: float = 0.15

func _ready():
	generate_lamps()

func generate_lamps():
	if not lamp_scene:
		print("Сцена лампы не установлена!")
		return

	for x in range(grid_size.x):
		for z in range(grid_size.y):
			var lamp_instance = lamp_scene.instantiate()

			var offset_x = randf_range(-position_offset, position_offset)
			var offset_z = randf_range(-position_offset, position_offset)
			
			var pos_x = start_position.x + (x * spacing) + offset_x
			var pos_z = start_position.y + (z * spacing) + offset_z
			var position = Vector3(pos_x, lamp_y_position, pos_z)
			
			lamp_instance.position = position

			var random_value = randf()

			if random_value < broken_chance:
				# --- ИЗМЕНЕННЫЙ БЛОК ---
				# Находим ВСЕ узлы света
				var lights = find_all_light_nodes(lamp_instance)
				# Проходимся по каждому найденному свету и отключаем его
				for light in lights:
					if is_instance_valid(light):
						light.visible = false
				# -----------------------

			elif random_value < broken_chance + flicker_chance:
				var flicker_component = Node.new()
				flicker_component.set_script(load("res://scripts/flicker_script.gd"))
				lamp_instance.add_child(flicker_component)

			add_child(lamp_instance)

# --- ИЗМЕНЕННАЯ ФУНКЦИЯ ---
# Вспомогательная функция для поиска ВСЕХ узлов света.
# Теперь она называется find_all_light_nodes и возвращает массив.
func find_all_light_nodes(node_root) -> Array[Light3D]:
	var found_lights: Array[Light3D] = []
	for child in node_root.get_children():
		if child is Light3D: # Проверяем тип узла
			found_lights.append(child)
	return found_lights # Возвращаем массив всех найденных узлов
# ---------------------------
