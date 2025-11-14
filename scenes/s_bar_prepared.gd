extends Area3D

func _ready():
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.has_method("collect_stamina_bar"):
		body.collect_stamina_bar(self)
