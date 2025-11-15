# Этот скрипт должен быть на корневом узле Node3D
extends Node3D

@export var attack_speed: float = 9.0
@export var retreat_speed: float = 5.0
@export var ideal_distance: float = 20.0

var player = null
var initial_y: float

func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		print("ОШИБКА: Монстр (", self.name, ") не может найти игрока!")
		queue_free()
	
	initial_y = global_position.y

func _physics_process(delta):
	# Если игрока нет, ничего не делаем
	if not is_instance_valid(player):
		return

	# --- 1. ПРЯМАЯ ПРОВЕРКА РАССУДКА ИГРОКА ---
	# Это самый надежный способ. Монстр сам решает, что делать.
	var should_attack = false
	if player.has_method("get") and player.get("current_sanity") < 50:
		should_attack = true
	
	# --- 2. ДВИЖЕНИЕ НА ОСНОВЕ РЕШЕНИЯ ---
	
	var direction = Vector3.ZERO
	var current_speed = 0.0
	
	if should_attack:
		# РЕЖИМ АТАКИ: просто бежим на игрока
		current_speed = attack_speed
		direction = (player.global_position - global_position).normalized()
		
		# ОТЛАДКА: чтобы мы видели, что он в режиме атаки
		# print(self.name, " - АТАКУЮ!") 
	else:
		# РЕЖИМ ОТСТУПЛЕНИЯ/ОЖИДАНИЯ: держим дистанцию
		current_speed = retreat_speed
		var distance_to_player = global_position.distance_to(player.global_position)
		
		# Если мы слишком близко, отступаем. Если далеко - стоим и ждем.
		if distance_to_player < ideal_distance:
			direction = (global_position - player.global_position).normalized()
		else:
			direction = Vector3.ZERO # Стоим на месте
			
		# ОТЛАДКА: чтобы мы видели, что он в режиме ожидания
		# print(self.name, " - ЖДУ.")

	# --- 3. ПОВОРОТ И ПЕРЕМЕЩЕНИЕ ---
	var look_at_target = player.global_position
	look_at_target.y = global_position.y
	look_at(look_at_target, Vector3.UP)
	
	if direction != Vector3.ZERO:
		global_position += direction * current_speed * delta
		global_position.y = initial_y

# --- 4. КАСАНИЕ ---
# Сигнал по-прежнему должен быть подключен от Hitbox (Area3D)
func _on_hitbox_body_entered(body):
	if body.has_method("die"):
		body.die()
