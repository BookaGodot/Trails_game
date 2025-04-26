class_name State
extends Node

const STATE_DECAY_DURATION : int = 10800
const STATE_DECAY_RATE = 1.0 / STATE_DECAY_DURATION

var care : float

# State variables
var happiness : float
var hunger : float
var cleanliness : float


func _ready() -> void:
	care = SaveSystem.get_var("care", 4.0)
	happiness = SaveSystem.get_var("happiness", 1.0)
	hunger = SaveSystem.get_var("hunger", 1.0)
	cleanliness = SaveSystem.get_var("cleanliness", 1.0)
	
	var elapsed_time = clamp(
			Time.get_unix_time_from_system() - SaveSystem.get_var("time", Time.get_unix_time_from_system()), 
			0.0, STATE_DECAY_DURATION
		)
	_decay_states(elapsed_time)
	
	$StateDecayTimer.timeout.connect(_decay_states.bind($StateDecayTimer.wait_time))


func save() -> void:
	SaveSystem.set_var("time", Time.get_unix_time_from_system())
	SaveSystem.set_var("care", care)
	SaveSystem.set_var("happiness", happiness)
	SaveSystem.set_var("hunger", hunger)
	SaveSystem.set_var("cleanliness", cleanliness)
	SaveSystem.save()
	print_rich("[color=green]States and time saved")


func change_care(amount : float) -> void:
	care = clamp(care + amount, 0.0, 7.0)
	print("Care changed: " + str(care))
	Events.care_changed.emit(care)


func change_happiness(amount : float) -> void:
	happiness = clamp(happiness + amount, 0.0, 1.0)
	print("Happiness changed: " + str(happiness))
	Events.happiness_changed.emit(happiness)


func change_hunger(amount) -> void:
	hunger = clamp(hunger + amount, 0.0, 1.0)
	print("Hunger changed: " + str(hunger))
	Events.hunger_changed.emit(hunger)


func change_cleanliness(amount) -> void:
	cleanliness = clamp(cleanliness + amount, 0.0, 1.0)
	print("Cleanliness changed: " + str(cleanliness))
	Events.cleanliness_changed.emit(cleanliness)


func _decay_states(time : float) -> void:
	var decay = time * STATE_DECAY_RATE
	change_happiness(-decay)
	change_hunger(-decay)
	change_cleanliness(-decay)
