extends Node

var health := 100
var happy := 3
var hunger := 3
var clean := 3
var age := 1

func change_health(amount):
	health += amount
	Events.health_changed.emit()
	
func change_happy(amount):
	happy +=amount
	Events.happy_changed.emit()

func change_hunger(amount):
	hunger +=amount
	Events.hunger_changed.emit()

func change_clean(amount):
	clean +=amount
	Events.clean_changed.emit()
