class_name Temperament
extends Node

const TEMPERAMENT_POINTS : int = 1000

enum Temperaments { NEUTRAL, FUNNY, ANXIOUS, SHY, DREAMY, STUBBORN }

@onready var animation_manager: AnimationManager = %AnimationManager

var temperament_points: Dictionary
var temperament : Temperaments = Temperaments.NEUTRAL


func _ready() -> void:
	SaveSystem.delete_all()
	SaveSystem.save()
	var temp = SaveSystem.get_var("temperament_points", { 
		Temperaments.NEUTRAL: 0, 
		Temperaments.FUNNY: 0,
		Temperaments.ANXIOUS: 0,
		Temperaments.SHY: 0,
		Temperaments.DREAMY: 0,
		Temperaments.STUBBORN: 0,
	})
	for i in temp:
		temperament_points[int(i)] = int(temp[i])
	
	temperament = _get_current_temperament()
	choose_and_play_idle_animation()


func change_temperament(type : Temperaments, amount : float) -> void:
	temperament_points[type] += amount 
	temperament = _get_current_temperament()
	choose_and_play_idle_animation()
	SaveSystem.set_var("temperament_points", temperament_points)


func choose_and_play_idle_animation() -> void:
	var idle_animation_name : String
	
	match temperament:
		Temperaments.FUNNY:
			idle_animation_name = "happy"
		Temperaments.ANXIOUS:
			# TODO
			pass
		Temperaments.SHY:
			# TODO
			pass
		Temperaments.DREAMY:
			# TODO
			pass
		Temperaments.STUBBORN:
			idle_animation_name = "angry"
		_:
			idle_animation_name = "neutral"
	
	animation_manager.play_idle_animation(idle_animation_name)


func _get_current_temperament() -> int:
	var max : int = 0
	print(temperament_points)
	for i in temperament_points:
		if temperament_points[i] >= TEMPERAMENT_POINTS and temperament_points[i] >= temperament_points[max]:
			max = i
	return max
