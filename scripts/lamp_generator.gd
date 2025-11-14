# lamp_generator.gd
extends Node3D

@export var lamp_scene: PackedScene
@export var broken_lamp_scene: PackedScene
@export var flickering_lamp_scene: PackedScene # Новая переменная

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
	if not lamp_scene or not broken_lamp_scene or not flickering_lamp_scene:
		print("Одна из сцен ламп не установлена!")
		return

	for x in range(grid_size.x):
		for z in range(grid_size.y):
			var lamp_instance
			var random_value = randf()

			if random_value < broken_chance:
				lamp_instance = broken_lamp_scene.instantiate()
			elif random_value < broken_chance + flicker_chance:
				lamp_instance = flickering_lamp_scene.instantiate()
			else:
				lamp_instance = lamp_scene.instantiate()
			
			var offset_x = randf_range(-position_offset, position_offset)
			var offset_z = randf_range(-position_offset, position_offset)
			
			var pos_x = start_position.x + (x * spacing) + offset_x
			var pos_z = start_position.y + (z * spacing) + offset_z
			var position = Vector3(pos_x, lamp_y_position, pos_z)
			
			lamp_instance.position = position
			add_child(lamp_instance)
