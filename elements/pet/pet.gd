class_name Pet
extends Control

const CARE_REDUCE_INTERVAL : int = 86400
#const CARE_REDUCE_INTERVAL : int = 60

@onready var state: State = %State
@onready var animation_manager: AnimationManager = %AnimationManager
@onready var temperament: Temperament = %Temperament

var care : float

var died : bool = false
var sick : bool = false
var ran_away : bool = false


func _ready() -> void:
	care = SaveSystem.get_var("care", 4.0)
	_reduce_parameters_based_on_time()
	
	await get_tree().process_frame
	if care <= 0:
		_die()


func change_care(amount : float) -> void:
	care = clamp(care + amount, 0.0, 7.0)
	SaveSystem.set_var("care", care)
	if care <= 3.0:
		animation_manager.play_idle_animation("sad")
	else:
		%Temperament.choose_and_play_idle_animation()
	Events.care_changed.emit(care)


func change_temperament(type : Temperament.Temperaments, amount : float) -> void:
	temperament.change_temperament(type, amount)


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
	%BubblesEffect.show()
	SaveSystem.set_var("last_cleaning_time", Time.get_unix_time_from_system())


func make_happy() -> void:
	change_care(0.34)
	state.change_happiness(1.0)
	animation_manager.play_action_animation("play")
	animation_manager.remove_state_animation("crying")
	SaveSystem.set_var("last_playing_time", Time.get_unix_time_from_system())


func revive() -> void:
	died = false
	change_care(4)
	find()
	heal()
	state.change_happiness(1.0)
	$Button.disabled = false
	$Sprite2D.show()


func find() -> void:
	ran_away = false
	state.change_hunger(1.0)
	if !sick:
		$Button.disabled = false
	$Sprite2D.show()


func heal() -> void:
	sick = false
	state.change_cleanliness(1.0)
	if !ran_away:
		$Button.disabled = false


func _die() -> void:
	died = true
	$Button.disabled = true
	$Sprite2D.hide()
	print("pet сдох")


func _run_away() -> void:
	ran_away = true
	$Button.disabled = true
	$Sprite2D.hide()
	print("pet ran away")


func _fall_sick() -> void:
	sick = true
	$Button.disabled = true
	# TODO: change animation
	print("pet is sick")


func _on_click() -> void:
	animation_manager.play_action_animation("pet")


func _reduce_parameters_based_on_time() -> void:
	var current_time = Time.get_unix_time_from_system()
	
	var days_since_feeding = _get_time_intervals_passed(SaveSystem.get_var("last_feeding_time", current_time), CARE_REDUCE_INTERVAL)
	if days_since_feeding > 0:
		print(days_since_feeding)
		change_care(-0.165 * days_since_feeding)
		if days_since_feeding >= 3:
			_run_away()
	
	var days_since_cleaning = _get_time_intervals_passed(SaveSystem.get_var("last_cleaning_time", current_time), CARE_REDUCE_INTERVAL)
	if days_since_cleaning > 0:
		print(days_since_cleaning)
		change_care(-0.165 * days_since_cleaning)
		if days_since_cleaning >= 3:
			_fall_sick()
	
	var days_since_playing = _get_time_intervals_passed(SaveSystem.get_var("last_playing_time", current_time), CARE_REDUCE_INTERVAL)
	if days_since_playing > 0:
		print(days_since_playing)
		change_care(-0.17 * days_since_playing)
		if days_since_playing % 3 == 0:
			change_care(-1 * days_since_playing/3.0)


func _get_time_intervals_passed(last_time: float, interval: float) -> int:
	var elapsed = Time.get_unix_time_from_system() - last_time
	return int(elapsed / interval)
