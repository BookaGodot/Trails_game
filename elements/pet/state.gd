class_name State
extends Node

var care : float = 4
var happiness : float = 3
var hunger : float = 3
var cleanliness : float = 3


func change_care(amount : float) -> void:
	care += amount
	Events.care_changed.emit()


func change_happy(amount : float) -> void:
	happiness += amount
	Events.happiness_changed.emit()


func change_hunger(amount) -> void:
	hunger += amount
	Events.hunger_changed.emit()


func change_clean(amount) -> void:
	cleanliness += amount
	Events.cleanliness_changed.emit()
