extends Area3D

@export var attack_speed: float = 9.0
@export var retreat_speed: float = 5.0
@export var ideal_distance: float = 20.0

var player = null

func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		print("ОШИБКА: Монстр (", self.name, ") не может найти игрока!")
		queue_free()

func _physics_process(delta):
	if not is_instance_valid(player):
		return

	# --- 1. ВЫЧИСЛЕНИЕ НАПРАВЛЕНИЯ ---
	# Получаем вектор направления к игроку и делаем его "плоским" (без учета высоты)
	var direction_to_player = player.global_position - global_position
	direction_to_player.y = 0
	direction_to_player = direction_to_player.normalized()

	# --- 2. ПОВОРОТ ---
	# Проверяем, что направление не является нулевым вектором
	if direction_to_player.length_squared() > 0:
		# Сначала поворачиваем монстра лицом к игроку
		look_at(player.global_position, Vector3.UP)
		# Затем применяем дополнительный поворот на -90 градусов по оси Y
		rotate_y(deg_to_rad(-90))

	# --- 3. РЕШЕНИЕ И ДВИЖЕНИЕ ---
	var should_attack = player.get("current_sanity") < 50
	
	var movement_direction = Vector3.ZERO
	var current_speed = 0.0

	if should_attack:
		current_speed = attack_speed
		# Движемся строго в направлении игрока (используем вектор, рассчитанный ранее)
		movement_direction = direction_to_player
	else:
		current_speed = retreat_speed
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player < ideal_distance:
			# Движемся строго от игрока
			movement_direction = -direction_to_player

	# --- 4. ПЕРЕМЕЩЕНИЕ ---
	# Сохраняем высоту перед движением
	var y_pos = global_position.y
	global_position += movement_direction * current_speed * delta
	# Восстанавливаем высоту
	global_position.y = y_pos

# --- 5. КАСАНИЕ ---
# Эта функция будет вызвана сигналом от самого себя (Area3D)
func _on_body_entered(body):
	if body.has_method("die"):
		body.die()
