class_name Pet
extends Control

enum Temperaments { NEUTRAL, FUNNY, ANXIOUS, SHY, MELANCHOLY, STUBBORN }

@onready var state: State = %State
@onready var animation_manager: AnimationManager = %AnimationManager

var temperament : Temperaments = Temperaments.NEUTRAL


func _ready() -> void:
	# TODO: implement idle animation change based on temperament
	animation_manager.play_idle_animation("neutral")


func feed() -> void:
	state.change_hunger(1.0)
	animation_manager.play_action_animation("feed")
	animation_manager.remove_state_animation("hungry")


func clean() -> void:
	state.change_cleanliness(1.0)
	animation_manager.play_action_animation("clean")
	animation_manager.remove_state_animation("dirty")
	$BubblesEffect.show()


func make_happy() -> void:
	state.change_happiness(1.0)
	animation_manager.play_action_animation("play")
	animation_manager.remove_state_animation("sad")


func _on_click() -> void:
	animation_manager.play_action_animation("pet")
