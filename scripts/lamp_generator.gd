extends Node3D

signal progress_updated(percentage) # Отправляет прогресс (0.0 до 1.0)
signal generation_finished() 

@export var lamp_scene: PackedScene
@export var broken_lamp_scene: PackedScene
@export var flickering_lamp_scene: PackedScene

@export var start_position = Vector2(-500, -500)
@export var grid_size = Vector2i(10, 10)
@export var spacing: float = 5.0
@export var position_offset: float = 2.0
@export var lamp_y_position: float = 5.0

@export_range(0, 1) var broken_chance: float = 0.1
@export_range(0, 1) var flicker_chance: float = 0.15

#func _ready():
	#generate_lamps()

func generate_lamps():
	if not lamp_scene or not broken_lamp_scene or not flickering_lamp_scene:
		print("Одна из сцен ламп не установлена!")
		emit_signal("generation_finished")
		return

	var space_state = get_world_3d().direct_space_state
	var total_lamps = grid_size.x * grid_size.y
	var processed_lamps = 0

	for x in range(grid_size.x):
		for z in range(grid_size.y):
			var offset_x = round(randf_range(-position_offset, position_offset))
			var offset_z = round(randf_range(-position_offset, position_offset))
			var pos_x = start_position.x + (x * spacing) + offset_x
			var pos_z = start_position.y + (z * spacing) + offset_z
			var position = Vector3(pos_x, lamp_y_position, pos_z)

			var query = PhysicsShapeQueryParameters3D.new()
			query.shape = SphereShape3D.new()
			query.shape.radius = 1.0 
			query.transform = Transform3D(Basis(), position)
			query.collision_mask = 2 

			var intersecting_bodies = space_state.intersect_shape(query)

			if intersecting_bodies.is_empty():
				var lamp_instance
				var random_value = randf()

				if random_value < broken_chance:
					lamp_instance = broken_lamp_scene.instantiate()
				elif random_value < broken_chance + flicker_chance:
					lamp_instance = flickering_lamp_scene.instantiate()
				else:
					lamp_instance = lamp_scene.instantiate()
				
				lamp_instance.position = position
				add_child(lamp_instance)
			
			processed_lamps += 1
			
			# Также ждем следующего кадра, чтобы не было лагов
			if processed_lamps % 50 == 0:
				emit_signal("progress_updated", float(processed_lamps) / total_lamps)
				await get_tree().process_frame

	emit_signal("generation_finished")
