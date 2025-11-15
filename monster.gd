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

	# --- 1. ПОВОРОТ ---
	# Создаем "плоскую" цель, чтобы монстр не наклонялся
	var target_position = player.global_position
	var current_position = global_position
	
	# Исключаем Y из обеих позиций для безопасного look_at
	target_position.y = 0
	current_position.y = 0

	# Проверяем, не находимся ли мы уже в точке цели
	if not current_position.is_equal_approx(target_position):
		look_at(player.global_position, Vector3.UP)

	# --- 2. РЕШЕНИЕ И ДВИЖЕНИЕ ---
	var should_attack = player.get("current_sanity") < 50
	
	var movement_direction = Vector3.ZERO
	var current_speed = 0.0

	if should_attack:
		current_speed = attack_speed
		# Движемся вперед (локальная ось -Z)
		movement_direction = -global_transform.basis.z
	else:
		current_speed = retreat_speed
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player < ideal_distance:
			# Движемся назад (локальная ось +Z)
			movement_direction = global_transform.basis.z

	# --- 3. ПЕРЕМЕЩЕНИЕ ---
	# Сохраняем высоту перед движением
	var y_pos = global_position.y
	global_position += movement_direction.normalized() * current_speed * delta
	# Восстанавливаем высоту
	global_position.y = y_pos

# --- 4. КАСАНИЕ ---
# Эта функция будет вызвана сигналом от самого себя (Area3D)
func _on_body_entered(body):
	if body.has_method("die"):
		body.die()
