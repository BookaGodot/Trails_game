class_name Pet
extends Control

enum Temperaments { NEUTRAL, FUNNY, ANXIOUS, SHY, MELANCHOLY, STUBBORN }

@onready var state: State = %State

var age : float = 0.0
var temperament : Temperaments = Temperaments.NEUTRAL


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_F:
			feed()
		elif event.keycode == KEY_C:
			clean()
		elif event.keycode == KEY_H:
			make_happy()


func feed() -> void:
	state.change_hunger(1.0)
	# TODO: add animation


func clean() -> void:
	state.change_cleanliness(1.0)
	# TODO: add animation


func make_happy() -> void:
	state.change_happiness(1.0)
	# TODO: add animation


func _on_click() -> void:
	print("Pet clicked")
	# TODO: add animation
