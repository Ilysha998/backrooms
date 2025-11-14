# GlobalLightHandler.gd
extends Node

signal lights_state_changed(are_lights_on: bool)
signal spawn_monsters_in_darkness

var are_lights_on: bool = true
var switch_timer: Timer

func _ready():
	switch_timer = Timer.new()
	add_child(switch_timer)
	switch_timer.timeout.connect(_on_switch_timer_timeout)
	
	reset_timer()

func _on_switch_timer_timeout():
	toggle_lights()
	reset_timer()

func reset_timer():
	switch_timer.wait_time = randf_range(60.0, 120.0)
	switch_timer.start()
	print("Next light switch in " + str(int(switch_timer.wait_time)) + " seconds.")

func turn_lights_off():
	if are_lights_on:
		are_lights_on = false
		emit_signal("lights_state_changed", are_lights_on)
		emit_signal("spawn_monsters_in_darkness")
		print("Global lights turned OFF")

func turn_lights_on():
	if not are_lights_on:
		are_lights_on = true
		emit_signal("lights_state_changed", are_lights_on)
		print("Global lights turned ON")

func toggle_lights():
	if are_lights_on:
		turn_lights_off()
	else:
		turn_lights_on()
