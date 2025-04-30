class_name Pet
extends Control

#const CARE_REDUCE_INTERVAL : int = 86400
const CARE_REDUCE_INTERVAL : int = 60
const TEMPERAMENT_POINTS : int = 1000

enum Temperaments { NEUTRAL, FUNNY, ANXIOUS, SHY, MELANCHOLY, STUBBORN }

@onready var state: State = %State
@onready var animation_manager: AnimationManager = %AnimationManager

var care : float
var temperament_points: Dictionary
var temperament : Temperaments = Temperaments.NEUTRAL


func _ready() -> void:
	care = SaveSystem.get_var("care", 4.0)
	var temp = SaveSystem.get_var("temperament_points", { 
		Temperaments.NEUTRAL: 0, 
		Temperaments.FUNNY: 0,
		Temperaments.ANXIOUS: 0,
		Temperaments.SHY: 0,
		Temperaments.MELANCHOLY: 0,
		Temperaments.STUBBORN: 0,
	})
	for i in temp:
		temperament_points[int(i)] = int(temp[i])
	
	temperament = _get_current_temperament()
	_choose_and_play_idle_animation()
	_reduce_care_based_on_time()


func change_care(amount : float) -> void:
	care = clamp(care + amount, 0.0, 7.0)
	SaveSystem.set_var("care", care)
	if care <= 3.0:
		%AnimationManager.play_idle_animation("sad")
	else:
		_choose_and_play_idle_animation()
	Events.care_changed.emit(care)
	#print("Care changed: " + str(care))


func change_temperament(type : Temperaments, amount : float) -> void:
	temperament_points[type] += amount 
	temperament = _get_current_temperament()
	_choose_and_play_idle_animation()
	SaveSystem.set_var("temperament_points", temperament_points)
	Events.care_changed.emit(care)


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
	animation_manager.remove_state_animation("crying")
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
	if days_since_playing % 3 == 0:
		change_care(-1 * days_since_playing/3)


func _get_time_intervals_passed(last_time: float, interval: float) -> int:
	var elapsed = Time.get_unix_time_from_system() - last_time
	return int(elapsed / interval)


func _get_current_temperament() -> int:
	var max : int = 0
	print(temperament_points)
	for i in temperament_points:
		if temperament_points[i] >= TEMPERAMENT_POINTS and temperament_points[i] >= temperament_points[max]:
			max = i
	return max


func _choose_and_play_idle_animation() -> void:
	var idle_animation_name : String = "neutral"
	
	match temperament:
		Temperaments.FUNNY:
			idle_animation_name = "happy"
		Temperaments.ANXIOUS:
			# TODO
			pass
		Temperaments.SHY:
			# TODO
			pass
		Temperaments.MELANCHOLY:
			idle_animation_name = "sad"
		Temperaments.STUBBORN:
			idle_animation_name = "angry"
	
	animation_manager.play_idle_animation(idle_animation_name)
