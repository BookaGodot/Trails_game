extends Node

signal care_changed(new_value : float)
signal happiness_changed(new_value : float)
signal cleanliness_changed(new_value : float)
signal hunger_changed(new_value : float)
signal money_updated

var money = 20


func _ready() -> void:
	money = SaveSystem.get_var("money", 20)


func set_money(amount: int):
	money_updated.emit()
	SaveSystem.set_var("money", money)
	SaveSystem.save()
