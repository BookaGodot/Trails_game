class_name Pet
extends Control

enum Temperaments { NEUTRAL, FUNNY, ANXIOUS, SHY, MELANCHOLY, STUBBORN }

@onready var state: State = %State
@onready var animation_manager: AnimationManager = %AnimationManager

var care : float
var temperament : Temperaments = Temperaments.NEUTRAL


func _ready() -> void:
	care = SaveSystem.get_var("care", 4.0)
	# TODO: implement idle animation change based on temperament
	animation_manager.play_idle_animation("neutral")


func change_care(amount : float) -> void:
	care = clamp(care + amount, 0.0, 7.0)
	SaveSystem.set_var("care", care)
	Events.care_changed.emit(care)
	#print("Care changed: " + str(care))


func feed() -> void:
	change_care(0.33)
	state.change_hunger(1.0)
	animation_manager.play_action_animation("feed")
	animation_manager.remove_state_animation("hungry")


func clean() -> void:
	change_care(0.33)
	state.change_cleanliness(1.0)
	animation_manager.play_action_animation("clean")
	animation_manager.remove_state_animation("dirty")
	$BubblesEffect.show()


func make_happy() -> void:
	change_care(0.34)
	state.change_happiness(1.0)
	animation_manager.play_action_animation("play")
	animation_manager.remove_state_animation("sad")


func _on_click() -> void:
	animation_manager.play_action_animation("pet")
