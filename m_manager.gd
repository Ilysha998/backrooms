# MonsterManager.gd
extends Node3D

@export var monster_scene: PackedScene

var spawn_points: Array[Marker3D] = []
var spawned_monsters: Array[Node3D] = []

func _ready():
	# Собираем все точки спавна, которые являются дочерними узлами
	for child in get_children():
		if child is Marker3D:
			spawn_points.append(child)

	if spawn_points.is_empty():
		print("WARNING: MonsterManager has no Marker3D spawn points!")

	# Подключаемся к сигналам от глобального обработчика света
	GlobalLightHandler.spawn_monsters_in_darkness.connect(_on_spawn_monsters)
	GlobalLightHandler.lights_state_changed.connect(_on_lights_state_changed)

func _on_spawn_monsters():
	if not monster_scene or spawn_points.is_empty():
		return

	# Выбираем случайную точку спавна
	var spawn_point = spawn_points.pick_random()
	
	# Создаем монстра
	var monster = monster_scene.instantiate()
	
	# Добавляем его в сцену (не как дочерний узел менеджера, а в корень)
	get_tree().current_scene.add_child(monster)
	monster.global_position = spawn_point.global_position
	
	spawned_monsters.append(monster)
	print("Monster spawned at: ", spawn_point.name)

func _on_lights_state_changed(are_lights_on: bool):
	# Если свет включили, удаляем всех монстров
	if are_lights_on:
		for monster in spawned_monsters:
			if is_instance_valid(monster):
				monster.queue_free()
		
		spawned_monsters.clear()
		print("All monsters despawned because lights are ON.")
