extends Area3D

func _ready():
	# Подключаем сигнал body_entered к нашей функции
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Проверяем, что в зону вошел именно игрок
	# (убедитесь, что у вашего игрока есть метод 'collect_water')
	if body.has_method("collect_water"):
		body.collect_water(self)
