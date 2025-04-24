class_name State
extends Node

var care : float

# State variables
var happiness : float
var hunger : float
var cleanliness : float


func _ready() -> void:
	# TODO: Make calculations of state values ​​depending on the last visit to the game
	care = SaveSystem.get_var("care", 4.0)
	happiness = SaveSystem.get_var("happiness", 1.0)
	hunger = SaveSystem.get_var("hunger", 1.0)
	cleanliness = SaveSystem.get_var("cleanliness", 1.0)


func change_care(amount : float) -> void:
	care = clamp(care + amount, 0.0, 7.0)
	Events.care_changed.emit(care)


func change_happy(amount : float) -> void:
	happiness = clamp(happiness + amount, 0.0, 1.0)
	Events.happiness_changed.emit(happiness)


func change_hunger(amount) -> void:
	hunger = clamp(hunger + amount, 0.0, 1.0)
	Events.hunger_changed.emit(hunger)


func change_clean(amount) -> void:
	cleanliness = clamp(cleanliness + amount, 0.0, 1.0)
	Events.cleanliness_changed.emit(cleanliness)
