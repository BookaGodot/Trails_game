class_name Pet
extends Control

enum Temperaments { NEUTRAL, FUNNY, ANXIOUS, SHY, MELANCHOLY, STUBBORN }

@onready var state: State = %State
@onready var animation_manager: AnimationManager = %AnimationManager

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
	state.change_care(0.5)
	
	anim_player.play("play")


func clean() -> void:
	state.change_care(0.5)
	
	anim_player.play("wash")


func make_happy() -> void:
	state.change_care(0.5)
	anim_player.play("play")


func sleep() -> void:
	state.change_care(0.5)
	anim_player.play("sleep")


func _on_click() -> void:
	anim_player.stop()
	anim_player.play("touch")
