class_name Pet
extends Control

#const CARE_REDUCE_INTERVAL : int = 86400
const CARE_REDUCE_INTERVAL : int = 60

enum Temperaments { NEUTRAL, FUNNY, ANXIOUS, SHY, MELANCHOLY, STUBBORN }

@onready var state: State = %State
@onready var animation_manager: AnimationManager = %AnimationManager

var care : float
var temperament : Temperaments = Temperaments.NEUTRAL


func _ready() -> void:
	care = SaveSystem.get_var("care", 4.0)
	_reduce_care_based_on_time()
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
	SaveSystem.set_var("last_feeding_time", Time.get_unix_time_from_system())


func clean() -> void:
	change_care(0.33)
	state.change_cleanliness(1.0)
	animation_manager.play_action_animation("clean")
	animation_manager.remove_state_animation("dirty")
	$BubblesEffect.show()
	SaveSystem.set_var("last_cleaning_time", Time.get_unix_time_from_system())


func make_happy() -> void:
	change_care(0.34)
	state.change_happiness(1.0)
	animation_manager.play_action_animation("play")
	animation_manager.remove_state_animation("sad")
	SaveSystem.set_var("last_playing_time", Time.get_unix_time_from_system())


func _on_click() -> void:
	animation_manager.play_action_animation("pet")


func _reduce_care_based_on_time() -> void:
	var current_time = Time.get_unix_time_from_system()
	
	var days_since_feeding = _get_time_intervals_passed(SaveSystem.get_var("last_feeding_time", current_time), CARE_REDUCE_INTERVAL)
	if days_since_feeding > 0:
		change_care(-0.165 * days_since_feeding)
	
	var days_since_cleaning = _get_time_intervals_passed(SaveSystem.get_var("last_cleaning_time", current_time), CARE_REDUCE_INTERVAL)
	if days_since_cleaning > 0:
		change_care(-0.165 * days_since_cleaning)
	
	var days_since_playing = _get_time_intervals_passed(SaveSystem.get_var("last_playing_time", current_time), CARE_REDUCE_INTERVAL)
	if days_since_playing > 0:
		change_care(-0.17 * days_since_playing)


func _get_time_intervals_passed(last_time: float, interval: float) -> int:
	var elapsed = Time.get_unix_time_from_system() - last_time
	return int(elapsed / interval)
