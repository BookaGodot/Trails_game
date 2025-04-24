class_name Pet
extends Control

enum Temperaments { NEUTRAL, FUNNY, ANXIOUS, SHY, MELANCHOLY, STUBBORN }

@onready var state: State = %State

var age : float = 0.0
var temperament : Temperaments = Temperaments.NEUTRAL
