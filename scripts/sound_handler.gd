# SoundHandler.gd
extends Node

@onready var music_on = $MusicLightsOn
@onready var music_off = $MusicLightsOff

func _ready():
	# Подключаемся к сигналу нашего синглтона
	GlobalLightHandler.lights_state_changed.connect(_on_lights_state_changed)
	
	# Устанавливаем начальное состояние музыки
	_on_lights_state_changed(GlobalLightHandler.are_lights_on)

func _on_lights_state_changed(are_lights_on: bool):
	if are_lights_on:
		music_off.stop()
		music_on.play()
	else:
		music_on.stop()
		music_off.play()
